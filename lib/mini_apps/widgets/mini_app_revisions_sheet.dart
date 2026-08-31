import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/mini_apps/widgets/revisions_skeleton.dart';

class MiniAppRevisionsSheet extends StatefulWidget {
  const MiniAppRevisionsSheet({
    required this.app,
    required this.repository,
    super.key,
    this.canRestore = false,
  });

  final MiniApp app;

  final MiniAppsRepository repository;

  final bool canRestore;

  @override
  State<MiniAppRevisionsSheet> createState() => _MiniAppRevisionsSheetState();
}

class _MiniAppRevisionsSheetState extends State<MiniAppRevisionsSheet> {
  List<MiniAppRevision>? _revisions;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    try {
      final revisions = await widget.repository.getRevisions(widget.app.id);
      if (mounted) setState(() => _revisions = revisions);
    } on Exception {
      if (mounted) setState(() => _revisions = const []);
    }
  }

  Future<void> _restore(MiniAppRevision revision) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await widget.repository.restoreRevision(
        appId: widget.app.id,
        version: revision.version,
      );
      if (mounted) Navigator.of(context).pop(true);
    } on Exception {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _changesLabel(BuildContext context, int index) {
    final revisions = _revisions ?? const [];
    final currentRevision = revisions.elementAtOrNull(index);
    final previousRevision = revisions.elementAtOrNull(index + 1);
    if (currentRevision == null || previousRevision == null) {
      return context.l10n.miniAppsRevFirst;
    }
    final current = {
      for (final screen in currentRevision.screens) screen.path: screen.json,
    };
    final previous = {
      for (final screen in previousRevision.screens) screen.path: screen.json,
    };
    final added = current.keys.where((p) => !previous.containsKey(p));
    final removed = previous.keys.where((p) => !current.containsKey(p));
    final changed = current.keys.where(
      (path) =>
          previous.containsKey(path) &&
          !const DeepCollectionEquality().equals(previous[path], current[path]),
    );
    final parts = [
      for (final path in added) '+$path',
      for (final path in removed) '−$path',
      for (final path in changed) '~$path',
    ];
    return parts.isEmpty ? context.l10n.miniAppsRevNoChanges : parts.join('  ');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final revisions = _revisions;
    if (revisions == null) {
      return RevisionsSkeleton(canRestore: widget.canRestore);
    }
    if (revisions.isEmpty) {
      return NinjaEmptyState(
        icon: AppLineIconWidget(
          AppLineIcon.clock,
          size: 20,
          color: context.ninja.muted,
        ),
        title: l10n.miniAppsRevEmpty,
      );
    }
    return Column(
      mainAxisSize: .min,
      children: [
        for (final (index, revision) in revisions.indexed)
          NinjaListCell(
            title:
                'v${revision.version}'
                '${index == 0 ? ' · ${l10n.miniAppsRevCurrent}' : ''}',
            subtitle: _changesLabel(context, index),
            horizontalPadding: 0,
            showChevron: false,
            trailing: widget.canRestore && index != 0
                ? NinjaButton.outline(
                    label: l10n.miniAppsRevRestore,
                    size: .small,
                    onPressed: _busy
                        ? null
                        : () => unawaited(_restore(revision)),
                  )
                : null,
          ),
      ],
    );
  }
}

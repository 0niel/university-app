import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/mini_apps/widgets/mini_app_tokens_skeleton.dart';

class MiniAppTokensSheet extends StatefulWidget {
  const MiniAppTokensSheet({required this.repository, super.key});

  final MiniAppsRepository repository;

  @override
  State<MiniAppTokensSheet> createState() => _MiniAppTokensSheetState();
}

class _MiniAppTokensSheetState extends State<MiniAppTokensSheet> {
  List<MiniAppDeployToken>? _tokens;
  String? _freshToken;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    try {
      final tokens = await widget.repository.listDeployTokens();
      if (mounted) setState(() => _tokens = tokens);
    } on Exception {
      if (mounted) setState(() => _tokens = const []);
    }
  }

  Future<void> _create() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final created = await widget.repository.createDeployToken(
        name: 'token-${(_tokens?.length ?? 0) + 1}',
      );
      if (!mounted) return;
      setState(() => _freshToken = created.token);
      await _load();
    } on Exception {
      if (mounted) {
        showNinjaToast(
          context,
          showCheck: false,
          message: context.l10n.miniAppsTokensLimit,
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _revoke(MiniAppDeployToken token) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await widget.repository.revokeDeployToken(token.id);
      await _load();
    } on Exception {
      if (mounted) {
        showNinjaToast(
          context,
          showCheck: false,
          message: context.l10n.miniAppsTokensLimit,
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _copyFresh() async {
    final token = _freshToken;
    if (token == null) return;
    await Clipboard.setData(ClipboardData(text: token));
    if (!mounted) return;
    showNinjaToast(context, message: context.l10n.miniAppsTokensCopied);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final tokens = _tokens;
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      children: [
        Text(
          l10n.miniAppsTokensBody,
          style: NinjaText.subtext.copyWith(color: colors.muted, height: 1.5),
        ),
        const SizedBox(height: 12),
        if (_freshToken != null) ...[
          Container(
            padding: const .all(14),
            decoration: BoxDecoration(
              color: colors.surfaceAlt,
              borderRadius: .circular(NinjaRadius.card),
            ),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  l10n.miniAppsTokensFresh,
                  style: NinjaText.microLabel.copyWith(
                    color: colors.mutedDark,
                  ),
                ),
                const SizedBox(height: 6),
                SelectableText(
                  _freshToken ?? '',
                  style: NinjaText.subtext.copyWith(
                    color: colors.ink,
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: 10),
                NinjaButton.secondary(
                  label: l10n.miniAppsTokensCopy,
                  size: .small,
                  onPressed: () => unawaited(_copyFresh()),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (tokens == null)
          const MiniAppTokensSkeleton()
        else
          for (final token in tokens)
            NinjaListCell(
              title: token.name.isEmpty ? token.id : token.name,
              subtitle: token.lastUsedAt == null
                  ? l10n.miniAppsTokensNeverUsed
                  : l10n.miniAppsTokensUsed,
              horizontalPadding: 0,
              showChevron: false,
              trailing: NinjaIconButton(
                icon: const AppLineIconWidget(.close, size: 20),
                tooltip: l10n.miniAppsTokensRevoke,
                onPressed: _busy ? null : () => unawaited(_revoke(token)),
              ),
            ),
        const SizedBox(height: 12),
        NinjaButton.primary(
          label: l10n.miniAppsTokensCreate,
          expanded: true,
          loading: _busy,
          onPressed: _busy ? null : () => unawaited(_create()),
        ),
      ],
    );
  }
}

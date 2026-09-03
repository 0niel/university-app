import 'dart:async';
import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/knowledge_bank/utils/material_search.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

Future<Set<String>?> showMaterialSubjectPicker(
  BuildContext context, {
  required CampusRepository repository,
  required Set<String> selected,
  List<String> initialSubjects = const [],
}) => showAppSheet<Set<String>>(
  context,
  title: context.l10n.knowledgeSubjectsTitle,
  subtitle: context.l10n.knowledgeSubjectsHint,
  child: MaterialSubjectPicker(
    repository: repository,
    selected: selected,
    initialSubjects: initialSubjects,
  ),
);

class MaterialSubjectPicker extends StatefulWidget {
  const MaterialSubjectPicker({
    required this.repository,
    required this.selected,
    this.initialSubjects = const [],
    super.key,
  });

  final CampusRepository repository;
  final Set<String> selected;
  final List<String> initialSubjects;

  @override
  State<MaterialSubjectPicker> createState() => _MaterialSubjectPickerState();
}

class _MaterialSubjectPickerState extends State<MaterialSubjectPicker> {
  final _controller = TextEditingController();
  late final Set<String> _selected = {...widget.selected};
  late List<String> _subjects = widget.initialSubjects;
  Timer? _debounce;
  int _revision = 0;
  bool _loading = true;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _queryChanged(String value) {
    _debounce?.cancel();
    _revision++;
    setState(() {
      _loading = true;
      _failed = false;
    });
    _debounce = Timer(const Duration(milliseconds: 300), () {
      unawaited(_load());
    });
  }

  Future<void> _load() async {
    final revision = ++_revision;
    setState(() {
      _loading = true;
      _failed = false;
    });
    try {
      final subjects = await widget.repository.searchMaterialSubjects(
        _controller.text,
      );
      if (!mounted || revision != _revision) return;
      setState(() {
        _subjects = subjects;
        _loading = false;
      });
    } on Object {
      if (!mounted || revision != _revision) return;
      setState(() {
        _loading = false;
        _failed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final query = normalizeMaterialSearch(_controller.text);
    final subjects = {
      ..._selected,
      ..._subjects,
    }.where((value) => normalizeMaterialSearch(value).contains(query)).toList();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSearchField(
          controller: _controller,
          hintText: l10n.knowledgeSubjectsSearch,
          onChanged: _queryChanged,
        ),
        const SizedBox(height: AppSpacing.md),
        if (_loading)
          const AppSkeletonGroup(
            child: Column(
              children: [
                AppSkeletonRow(showTrailing: false),
                AppSkeletonRow(showTrailing: false),
              ],
            ),
          )
        else if (subjects.isEmpty && !_failed)
          Padding(
            padding: const EdgeInsets.all(AppSpacing.screen),
            child: Text(
              l10n.knowledgeSubjectsEmpty,
              textAlign: TextAlign.center,
              style: AppText.body.copyWith(color: context.colors.muted),
            ),
          )
        else if (subjects.isNotEmpty)
          SizedBox(
            height: math.min(300, subjects.length * 56.0),
            child: ListView(
              children: [
                for (final subject in subjects)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: AppCheckbox(
                      label: subject,
                      value: _selected.contains(subject),
                      onChanged:
                          _selected.length >= 10 && !_selected.contains(subject)
                          ? null
                          : (selected) => setState(() {
                              if (selected) {
                                _selected.add(subject);
                              } else {
                                _selected.remove(subject);
                              }
                            }),
                    ),
                  ),
              ],
            ),
          ),
        if (_failed) ...[
          AppBanner(
            message: l10n.knowledgeSubjectsLoadError,
            tone: AppBannerTone.danger,
          ),
          AppButton.text(
            label: l10n.retry,
            onPressed: () => unawaited(_load()),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        AppButton.primary(
          label: l10n.knowledgeSubjectsApply,
          expanded: true,
          onPressed: () => Navigator.of(context).pop(_selected),
        ),
      ],
    );
  }
}

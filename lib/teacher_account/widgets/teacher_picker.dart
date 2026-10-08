import 'dart:async';
import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:schedule_repository/schedule_repository.dart';

class TeacherPicker extends StatefulWidget {
  const TeacherPicker({
    required this.onSelected,
    this.selected,
    this.enabled = true,
    this.maxResultsHeight = 320,
    super.key,
  }) : assert(maxResultsHeight > 0, 'Result height must be positive');

  final Teacher? selected;
  final ValueChanged<Teacher> onSelected;
  final bool enabled;
  final double maxResultsHeight;

  @override
  State<TeacherPicker> createState() => _TeacherPickerState();
}

class _TeacherPickerState extends State<TeacherPicker>
    with WidgetsBindingObserver {
  late final _controller = TextEditingController(text: widget.selected?.name);
  late final ScheduleRepository _repository;
  Teacher? _selected;
  List<Teacher> _teachers = const [];
  Timer? _debounce;
  int _revision = 0;
  bool _loading = true;
  bool _failed = false;
  final _ambiguousNames = <String>{};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _repository = context.read<ScheduleRepository>();
    _selected = _validSelection(widget.selected);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_search(++_revision));
    });
  }

  @override
  void didUpdateWidget(covariant TeacherPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selected != widget.selected) {
      _selected = _validSelection(widget.selected);
    }
  }

  @override
  void didChangeMetrics() {
    if (mounted) setState(() {});
  }

  void _queryChanged(String _) {
    final revision = ++_revision;
    _debounce?.cancel();
    setState(() {
      _loading = true;
      _failed = false;
      _teachers = const [];
    });
    _debounce = Timer(const Duration(milliseconds: 350), () {
      unawaited(_search(revision));
    });
  }

  Future<void> _search(int revision) async {
    if (!mounted || revision != _revision) return;
    setState(() {
      _loading = true;
      _failed = false;
    });
    try {
      final response = await _repository.searchTeachers(
        query: _controller.text.trim(),
      );
      if (!mounted || revision != _revision) return;
      final unique = <String, Teacher>{};
      for (final teacher in response.results) {
        if (teacher.name.trim().isNotEmpty) {
          unique[_teacherKey(teacher)] = teacher;
        }
      }
      final nameCounts = <String, int>{};
      for (final teacher in unique.values) {
        final name = teacher.name.trim().toLowerCase();
        nameCounts[name] = (nameCounts[name] ?? 0) + 1;
      }
      if (_selected case final selected?
          when !unique.containsKey(_teacherKey(selected))) {
        final name = selected.name.trim().toLowerCase();
        nameCounts[name] = (nameCounts[name] ?? 0) + 1;
      }
      setState(() {
        _teachers = unique.values.toList();
        _ambiguousNames.addAll([
          for (final entry in nameCounts.entries)
            if (entry.value > 1) entry.key,
        ]);
        _loading = false;
      });
    } on Exception catch (_) {
      if (!mounted || revision != _revision) return;
      setState(() {
        _loading = false;
        _failed = true;
        _teachers = const [];
      });
    }
  }

  void _retry() {
    _debounce?.cancel();
    unawaited(_search(++_revision));
  }

  void _select(Teacher teacher) {
    if (!widget.enabled || !_linkable(teacher)) return;
    setState(() => _selected = teacher);
    FocusScope.of(context).unfocus();
    widget.onSelected(teacher);
  }

  @override
  void dispose() {
    _revision++;
    WidgetsBinding.instance.removeObserver(this);
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final view = View.of(context);
    final keyboardInset = math.max(
      MediaQuery.viewInsetsOf(context).bottom,
      view.viewInsets.bottom / view.devicePixelRatio,
    );
    final availableHeight =
        MediaQuery.sizeOf(context).height -
        keyboardInset -
        MediaQuery.paddingOf(context).vertical;
    final resultsHeight = math.min(
      widget.maxResultsHeight,
      math.max<double>(120, availableHeight * 0.5),
    );
    final duplicateNames = <String, int>{};
    for (final teacher in _teachers) {
      final name = teacher.name.trim().toLowerCase();
      duplicateNames[name] = (duplicateNames[name] ?? 0) + 1;
    }
    if (_selected case final selected?
        when !_teachers.any(
          (teacher) => _teacherKey(teacher) == _teacherKey(selected),
        )) {
      final name = selected.name.trim().toLowerCase();
      duplicateNames[name] = (duplicateNames[name] ?? 0) + 1;
    }
    final visibleTeachers = [
      for (final teacher in _teachers)
        if (_selected == null ||
            _teacherKey(teacher) != _teacherKey(_selected!))
          teacher,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppInputField(
          key: const ValueKey('teacher-picker-search'),
          controller: _controller,
          enabled: widget.enabled,
          placeholder: l10n.teacherPickerPlaceholder,
          leadingIcon: AppLineIcon.search,
          textInputAction: TextInputAction.search,
          onChanged: _queryChanged,
          onSubmitted: (_) => _retry(),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (_selected case final selected?) ...[
          Semantics(
            key: const ValueKey('teacher-picker-selection'),
            liveRegion: true,
            label: l10n.teacherPickerSelected(selected.name),
            excludeSemantics: true,
            child: AppCard(
              tinted: true,
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.xs),
                    child: AppCheckMark(size: 16, color: colors.accent),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.teacherPickerSelectionLabel,
                          style: AppText.subtext.copyWith(color: colors.accent),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          selected.name,
                          style: AppText.headline.copyWith(color: colors.ink),
                        ),
                        if (_ambiguousNames.contains(
                              selected.name.trim().toLowerCase(),
                            ) &&
                            _linkable(selected)) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            l10n.teacherPickerIdentity(selected.uid!),
                            style: AppText.sans(
                              11.5,
                              FontWeight.w400,
                              height: 1.35,
                            ).copyWith(color: colors.muted),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        if (_loading)
          AppSkeletonGroup(
            key: const ValueKey('teacher-picker-loading'),
            semanticsLabel: l10n.loadingContent,
            child: AppCard(
              child: Column(
                children: [
                  for (var index = 0; index < 3; index++) ...[
                    if (index > 0) const SizedBox(height: AppSpacing.lg),
                    const AppSkeleton.bar(height: 16, widthFactor: 0.7),
                  ],
                ],
              ),
            ),
          )
        else if (_failed)
          AppErrorState(
            key: const ValueKey('teacher-picker-error'),
            title: l10n.loadingError,
            message: l10n.tryAgain,
            primaryLabel: l10n.retry,
            onPrimary: widget.enabled ? _retry : null,
            footnote: null,
          )
        else if (_teachers.isEmpty && _controller.text.trim().isEmpty)
          AppEmptyState(
            key: const ValueKey('teacher-picker-catalog-empty'),
            title: l10n.teacherPickerCatalogEmpty,
            subtitle: l10n.teacherPickerCatalogEmptyHint,
            actionLabel: l10n.retry,
            onAction: widget.enabled ? _retry : null,
          )
        else if (_teachers.isEmpty)
          AppEmptyState.compact(
            key: const ValueKey('teacher-picker-empty'),
            title: l10n.teacherPickerEmpty,
            subtitle: l10n.teacherPickerEmptyHint,
          )
        else if (visibleTeachers.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.row),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: resultsHeight),
              child: ListView.separated(
                key: const ValueKey('teacher-picker-results'),
                padding: EdgeInsets.zero,
                primary: false,
                shrinkWrap: true,
                separatorBuilder: (_, _) => const AppDivider(),
                itemCount: visibleTeachers.length,
                itemBuilder: (context, index) {
                  final teacher = visibleTeachers[index];
                  final linkable = _linkable(teacher);
                  final enabled = widget.enabled && linkable;
                  final duplicate =
                      (duplicateNames[teacher.name.trim().toLowerCase()] ?? 0) >
                      1;
                  final detail = !linkable
                      ? l10n.teacherPickerUnavailable
                      : duplicate && teacher.uid != null
                      ? l10n.teacherPickerIdentity(teacher.uid!)
                      : teacher.department ?? teacher.post;
                  return AppPressable(
                    key: ValueKey('teacher-picker-${_teacherKey(teacher)}'),
                    onTap: () => _select(teacher),
                    enabled: enabled,
                    pressedScale: 1,
                    semanticsLabel: [teacher.name, ?detail].join(', '),
                    semanticsButton: true,
                    semanticsSelected: false,
                    child: ColoredBox(
                      color: colors.surface,
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    teacher.name,
                                    style: AppText.headline.copyWith(
                                      color: enabled
                                          ? colors.ink
                                          : colors.muted,
                                    ),
                                  ),
                                  if (detail != null && detail.isNotEmpty) ...[
                                    const SizedBox(height: AppSpacing.xs),
                                    Text(
                                      detail,
                                      style: AppText.sans(
                                        11.5,
                                        FontWeight.w400,
                                        height: 1.35,
                                      ).copyWith(color: colors.muted),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Container(
                              width: 22,
                              height: 22,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: colors.surface2,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        if (_controller.text.trim().isEmpty &&
            !_failed &&
            (_loading || visibleTeachers.isNotEmpty)) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.teacherPickerHint,
            style: AppText.subtext.copyWith(color: colors.muted),
          ),
        ],
      ],
    );
  }
}

String _teacherKey(Teacher teacher) => teacher.uid?.trim().isNotEmpty == true
    ? 'id:${teacher.uid!.trim()}'
    : 'name:${teacher.name.trim().toLowerCase()}';

bool _linkable(Teacher teacher) => teacher.uid?.trim().isNotEmpty == true;

Teacher? _validSelection(Teacher? teacher) =>
    teacher != null && _linkable(teacher) ? teacher : null;

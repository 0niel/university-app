import 'dart:async';
import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/teacher_account/bloc/teacher_picker_bloc.dart';
import 'package:rtu_mirea_app/teacher_account/widgets/picker/teacher_picker_results.dart';
import 'package:rtu_mirea_app/teacher_account/widgets/picker/teacher_picker_selection.dart';
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
  late final TeacherPickerBloc _bloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _bloc =
        TeacherPickerBloc(
          scheduleRepository: context.read<ScheduleRepository>(),
          selected: widget.selected,
        )..add(
          TeacherPickerEvent.searchRequested(
            query: _controller.text,
            immediate: true,
          ),
        );
  }

  @override
  void didUpdateWidget(covariant TeacherPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selected != widget.selected) {
      _bloc.add(TeacherPickerEvent.selectionChanged(widget.selected));
    }
  }

  @override
  void didChangeMetrics() {
    if (mounted) setState(() {});
  }

  void _retry() => _bloc.add(
    TeacherPickerEvent.searchRequested(
      query: _controller.text,
      immediate: true,
    ),
  );

  void _select(Teacher teacher) {
    if (!widget.enabled || !teacher.isPickerLinkable) return;
    _bloc.add(TeacherPickerEvent.teacherSelected(teacher));
    FocusScope.of(context).unfocus();
    widget.onSelected(teacher);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_bloc.close());
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
    return BlocBuilder<TeacherPickerBloc, TeacherPickerState>(
      bloc: _bloc,
      builder: (context, state) => Column(
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
            onChanged: (query) => _bloc.add(
              TeacherPickerEvent.searchRequested(query: query),
            ),
            onSubmitted: (_) => _retry(),
          ),
          const SizedBox(height: AppSpacing.sm),
          if (state.selected case final selected?) ...[
            TeacherPickerSelection(
              teacher: selected,
              showIdentity: state.isAmbiguous(selected),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          if (state.results.isLoading)
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
          else if (state.results.hasError)
            AppErrorState(
              key: const ValueKey('teacher-picker-error'),
              title: l10n.loadingError,
              message: l10n.tryAgain,
              primaryLabel: l10n.retry,
              onPrimary: widget.enabled ? _retry : null,
              footnote: null,
            )
          else if (state.teachers.isEmpty && state.query.isEmpty)
            AppEmptyState(
              key: const ValueKey('teacher-picker-catalog-empty'),
              title: l10n.teacherPickerCatalogEmpty,
              subtitle: l10n.teacherPickerCatalogEmptyHint,
              actionLabel: l10n.retry,
              onAction: widget.enabled ? _retry : null,
            )
          else if (state.teachers.isEmpty)
            AppEmptyState.compact(
              key: const ValueKey('teacher-picker-empty'),
              title: l10n.teacherPickerEmpty,
              subtitle: l10n.teacherPickerEmptyHint,
            )
          else if (state.visibleTeachers.isNotEmpty)
            TeacherPickerResults(
              state: state,
              enabled: widget.enabled,
              maxHeight: resultsHeight,
              onSelected: _select,
            ),
          if (state.query.isEmpty &&
              !state.results.hasError &&
              (state.results.isLoading ||
                  state.visibleTeachers.isNotEmpty)) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.teacherPickerHint,
              style: AppText.subtext.copyWith(color: colors.muted),
            ),
          ],
        ],
      ),
    );
  }
}

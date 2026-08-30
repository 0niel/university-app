import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/widgets/custom_schedule_selector/schedule_selector_widgets.dart';
import 'package:schedule_repository/schedule_repository.dart';

class CustomScheduleSelector extends StatefulWidget {
  const CustomScheduleSelector({required this.lesson, super.key});

  final LessonSchedulePart lesson;

  @override
  State<CustomScheduleSelector> createState() => _CustomScheduleSelectorState();
}

class _CustomScheduleSelectorState extends State<CustomScheduleSelector> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isCreatingNew = false;
  String? _selectedScheduleId;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        spacing: 18,
        children: [
          ScheduleSelectorLessonPreview(lesson: widget.lesson),
          AppSegmentedControl<bool>(
            value: _isCreatingNew,
            onChanged: (value) => setState(() => _isCreatingNew = value),
            options: [
              AppSegmentedOption(
                value: false,
                label: context.l10n.selectExisting,
              ),
              AppSegmentedOption(
                value: true,
                label: context.l10n.createNew,
              ),
            ],
          ),
          NinjaStateSwitcher(child: _buildMode()),
        ],
      ),
    );
  }

  Widget _buildMode() {
    if (_isCreatingNew) {
      return ScheduleSelectorCreateForm(
        key: const ValueKey('schedule_selector_create'),
        formKey: _formKey,
        nameController: _nameController,
        descriptionController: _descriptionController,
        onSubmit: _isSubmitting ? null : _createAndAddToSchedule,
      );
    }
    return ScheduleSelectorOptionList(
      key: const ValueKey('schedule_selector_list'),
      selectedId: _selectedScheduleId,
      onSelected: (value) => setState(() => _selectedScheduleId = value),
      onSubmit: _isSubmitting ? null : _addToSelectedSchedule,
      onCreateRequested: () => setState(() => _isCreatingNew = true),
    );
  }

  void _createAndAddToSchedule() {
    if (_formKey.currentState?.validate() != true) return;

    setState(() => _isSubmitting = true);

    final customScheduleCubit = context.read<CustomScheduleCubit>();
    final description = _descriptionController.text.trim();
    final newSchedule = customScheduleCubit.create(
      name: _nameController.text.trim(),
      description: description.isNotEmpty ? description : null,
    );
    customScheduleCubit.addLesson(newSchedule.id, widget.lesson);

    _showAddedToast(scheduleId: newSchedule.id, scheduleName: newSchedule.name);
  }

  void _addToSelectedSchedule() {
    final scheduleId = _selectedScheduleId;
    if (scheduleId == null) return;

    setState(() => _isSubmitting = true);

    final customScheduleCubit = context.read<CustomScheduleCubit>()
      ..addLesson(scheduleId, widget.lesson);

    final schedule = customScheduleCubit.state.customSchedules.firstWhere(
      (candidate) => candidate.id == scheduleId,
      orElse: () =>
          CustomSchedule(id: '', name: context.l10n.schedule, lessons: []),
    );

    _showAddedToast(scheduleId: scheduleId, scheduleName: schedule.name);
  }

  void _showAddedToast({
    required String scheduleId,
    required String scheduleName,
  }) {
    if (!mounted) return;

    final scheduleBloc = context.read<ScheduleBloc>();
    final customScheduleCubit = context.read<CustomScheduleCubit>();

    showNinjaToast(
      context,
      message: context.l10n.classAddedToSchedule(scheduleName),
      actionLabel: context.l10n.open,
      onAction: () {
        final selected = customScheduleCubit.buildSelectedSchedule(scheduleId);
        if (selected != null) {
          scheduleBloc.add(ScheduleSelected(selectedSchedule: selected));
        }
      },
    );
    Navigator.pop(context);
  }
}

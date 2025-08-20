import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:app_ui/app_ui.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/models/custom_schedule.dart';
import 'package:rtu_mirea_app/schedule/widgets/lesson_card.dart';
import 'package:university_app_server_api/client.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class CustomScheduleSelector extends StatefulWidget {
  final LessonSchedulePart lesson;

  const CustomScheduleSelector({super.key, required this.lesson});

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
    final colors = Theme.of(context).extension<AppColors>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.background03,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.background03),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.addedClass, style: AppTextStyle.captionL.copyWith(color: colors.deactive)),
                const SizedBox(height: 12),
                Text(widget.lesson.subject, style: AppTextStyle.titleS.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildLessonInfo(
                      context,
                      LessonCard.getLessonTypeName(widget.lesson.lessonType),
                      LessonCard.getColorByType(widget.lesson.lessonType),
                      icon: HugeIcons.strokeRoundedNotebook01,
                    ),
                    const SizedBox(width: 12),
                    _buildLessonInfo(
                      context,
                      '${widget.lesson.lessonBells.startTime} - ${widget.lesson.lessonBells.endTime}',
                      colors.colorful01,
                      icon: HugeIcons.strokeRoundedClock01,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildOptionButton(
                  context,
                  title: context.l10n.selectExisting,
                  icon: HugeIcons.strokeRoundedListView,
                  isSelected: !_isCreatingNew,
                  onTap: () => setState(() => _isCreatingNew = false),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildOptionButton(
                  context,
                  title: context.l10n.createNew,
                  icon: HugeIcons.strokeRoundedAdd01,
                  isSelected: _isCreatingNew,
                  onTap: () => setState(() => _isCreatingNew = true),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(animation),
                  child: child,
                ),
              );
            },
            child: _isCreatingNew ? _buildCreateForm() : _buildScheduleList(),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? colors.primary.withOpacity(0.1) : colors.background03.withOpacity(0.8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? colors.primary : colors.background03),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: isSelected ? colors.primary : colors.deactive, size: 24),
              const SizedBox(height: 8),
              Text(
                title,
                style: AppTextStyle.captionL.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isSelected ? colors.primary : colors.deactive,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreateForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.createNewSchedule, style: AppTextStyle.titleS.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextInput(
            controller: _nameController,
            labelText: context.l10n.scheduleNameLabel,
            hintText: context.l10n.scheduleNamePlaceholder,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return context.l10n.enterScheduleName;
              }
              if (value.length > 50) {
                return context.l10n.nameTooLong;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextInput(
            controller: _descriptionController,
            labelText: context.l10n.descriptionOptionalLabel,
            hintText: context.l10n.addScheduleDescriptionPlaceholder,
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              onPressed: _isSubmitting ? null : _createAndAddToSchedule,
              text: context.l10n.createAndAddClass,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleList() {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) {
        if (state.customSchedules.isEmpty) {
          return _buildNoSchedulesMessage();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.selectSchedule, style: AppTextStyle.titleS.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.customSchedules.length,
              itemBuilder: (context, index) {
                final schedule = state.customSchedules[index];
                return _buildScheduleItem(schedule);
              },
            ),
            if (_selectedScheduleId != null) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  onPressed: _isSubmitting ? null : _addToSelectedSchedule,
                  text: context.l10n.addToSelectedSchedule,
                  enabled: _isSubmitting,
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildScheduleItem(CustomSchedule schedule) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final isSelected = _selectedScheduleId == schedule.id;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedScheduleId = schedule.id;
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? colors.primary.withOpacity(0.1) : colors.background03.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isSelected ? colors.primary : colors.background03, width: isSelected ? 2 : 1),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSelected ? colors.primary.withOpacity(0.2) : colors.background03,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      HugeIcons.strokeRoundedCalendar02,
                      size: 24,
                      color: isSelected ? colors.primary : colors.deactive,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(schedule.name, style: AppTextStyle.titleS.copyWith(fontWeight: FontWeight.w600)),
                      if (schedule.description != null && schedule.description!.isNotEmpty)
                        Text(
                          schedule.description!,
                          style: AppTextStyle.captionL.copyWith(color: colors.deactive),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      Text(
                        '${schedule.lessons.length} ${context.l10n.classesCount(schedule.lessons.length)}',
                        style: AppTextStyle.captionL.copyWith(color: colors.deactive),
                      ),
                    ],
                  ),
                ),
                Radio<String>(
                  value: schedule.id,
                  groupValue: _selectedScheduleId,
                  onChanged: (value) {
                    setState(() {
                      _selectedScheduleId = value;
                    });
                  },
                  activeColor: colors.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoSchedulesMessage() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).extension<AppColors>()!.background03.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).extension<AppColors>()!.background03),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Theme.of(context).extension<AppColors>()!.background01.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                HugeIcons.strokeRoundedCalendar01,
                size: 40,
                color: Theme.of(context).extension<AppColors>()!.deactive,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.noOwnSchedules,
            style: AppTextStyle.titleS.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.createCustomSchedule,
            style: AppTextStyle.body.copyWith(color: Theme.of(context).extension<AppColors>()!.deactive),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            icon: Icon(HugeIcons.strokeRoundedAdd01, size: 16),
            label: Text(context.l10n.createSchedule),
            onPressed: () => setState(() => _isCreatingNew = true),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonInfo(BuildContext context, String text, Color color, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 14, color: color), const SizedBox(width: 4)],
          Text(text, style: AppTextStyle.captionL.copyWith(color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  void _createAndAddToSchedule() async {
    if (_formKey.currentState?.validate() != true) return;

    setState(() => _isSubmitting = true);

    final bloc = context.read<ScheduleBloc>();

    // First, create the new schedule
    bloc.add(
      CreateCustomSchedule(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isNotEmpty ? _descriptionController.text.trim() : null,
      ),
    );

    // Wait a bit for the state to update
    await Future.delayed(const Duration(milliseconds: 300));

    // Get the newly created schedule and add the lesson to it
    final customSchedules = bloc.state.customSchedules;
    if (customSchedules.isNotEmpty) {
      final newSchedule = customSchedules.last;

      bloc.add(AddLessonToCustomSchedule(scheduleId: newSchedule.id, lesson: widget.lesson));

      // Wait for the state to update
      await Future.delayed(const Duration(milliseconds: 300));

      // Show success message and close the modal
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.classAddedToSchedule(newSchedule.name)),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: context.l10n.open,
              onPressed: () {
                bloc.add(SelectCustomSchedule(scheduleId: newSchedule.id));
                Navigator.pop(context);
              },
            ),
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  void _addToSelectedSchedule() async {
    if (_selectedScheduleId == null) return;

    setState(() => _isSubmitting = true);

    final bloc = context.read<ScheduleBloc>();

    bloc.add(AddLessonToCustomSchedule(scheduleId: _selectedScheduleId!, lesson: widget.lesson));

    // Wait for the state to update
    await Future.delayed(const Duration(milliseconds: 300));

    // Get the selected schedule name for the success message
    final schedule = bloc.state.customSchedules.firstWhere(
      (s) => s.id == _selectedScheduleId,
      orElse: () => CustomSchedule(id: '', name: context.l10n.schedule, lessons: []),
    );

    // Show success message and close the modal
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.classAddedToSchedule(schedule.name)),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: context.l10n.open,
            onPressed: () {
              bloc.add(SelectCustomSchedule(scheduleId: _selectedScheduleId!));
              Navigator.pop(context);
            },
          ),
        ),
      );
      Navigator.pop(context);
    }
  }
}

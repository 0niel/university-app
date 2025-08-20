import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter/material.dart' as material;
import 'package:intl/intl.dart';
import 'package:app_ui/app_ui.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:university_app_server_api/client.dart';
import 'package:rtu_mirea_app/schedule/widgets/widgets.dart';

/// Reusable widgets extracted from custom lesson editor page

class SectionCard extends StatelessWidget {
  const SectionCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.background02,
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      child: child,
    );
  }
}

class StepIndicatorWidget extends StatelessWidget {
  const StepIndicatorWidget({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.stepTitles,
    required this.onStepTap,
  });

  final int currentStep;
  final int totalSteps;
  final List<String> stepTitles;
  final void Function(int) onStepTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.sm,
        horizontal: AppSpacing.md,
      ),
      child: Row(
        children: List.generate(totalSteps, (i) {
          final isActive = i == currentStep;
          return Expanded(
            child: GestureDetector(
              onTap: () => onStepTap(i),
              child: Column(
                children: [
                  Container(
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      color: isActive ? colors.primary : colors.background03,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    stepTitles[i],
                    style: AppTextStyle.captionL.copyWith(
                      color: isActive ? colors.primary : colors.deactive,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class NavigationButtonsWidget extends StatelessWidget {
  const NavigationButtonsWidget({
    super.key,
    this.onBack,
    required this.onNext,
    this.isLastStep = false,
    this.canProceed = true,
    this.nextLabel,
  });

  final void Function()? onBack;
  final void Function() onNext;
  final bool isLastStep;
  final bool canProceed;
  final String? nextLabel;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            if (onBack != null)
              TextButton(onPressed: onBack, child: const Text('Назад'))
            else
              const SizedBox.shrink(),
            const Spacer(),
            FilledButton(
              onPressed: canProceed ? onNext : null,
              child: Text(nextLabel ?? (isLastStep ? 'Готово' : 'Далее')),
            ),
          ],
        ),
      ),
    );
  }
}

class TimePickerFieldWidget extends StatelessWidget {
  const TimePickerFieldWidget({
    super.key,
    required this.label,
    required this.time,
    required this.onTap,
  });

  final String label;
  final TimeOfDay time;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final formatted =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.titleS.copyWith(
            color: colors.active,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Material(
          color: colors.background01,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              alignment: Alignment.centerLeft,
              child: Text(
                formatted,
                style: AppTextStyle.body.copyWith(color: colors.active),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class LessonNumberSelectorWidget extends StatelessWidget {
  const LessonNumberSelectorWidget({
    super.key,
    this.selectedNumber,
    required this.onNumberChanged,
  });

  final int? selectedNumber;
  final void Function(int?) onNumberChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(6, (i) {
        final num = i + 1;
        final isSelected = selectedNumber == num;
        return Padding(
          padding: const EdgeInsets.only(right: AppSpacing.sm),
          child: ChoiceChip(
            selected: isSelected,
            onSelected: (_) => onNumberChanged(num),
            label: Text('$num'),
          ),
        );
      }),
    );
  }
}

class GroupsSelectorWidget extends StatelessWidget {
  const GroupsSelectorWidget({
    super.key,
    required this.groups,
    required this.onAddGroup,
    required this.onRemoveGroup,
  });

  final List<String> groups;
  final VoidCallback onAddGroup;
  final void Function(String) onRemoveGroup;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Группы', style: AppTextStyle.titleS),
            const Spacer(),
            TextButton(onPressed: onAddGroup, child: const Text('Добавить')),
          ],
        ),
        Wrap(
          spacing: AppSpacing.sm,
          children:
              groups
                  .map(
                    (g) =>
                        Chip(label: Text(g), onDeleted: () => onRemoveGroup(g)),
                  )
                  .toList(),
        ),
      ],
    );
  }
}

class TeachersSelectorWidget extends StatelessWidget {
  const TeachersSelectorWidget({
    super.key,
    required this.teachers,
    required this.onAddTeacher,
    required this.onRemoveTeacher,
  });

  final List<Teacher> teachers;
  final VoidCallback onAddTeacher;
  final void Function(Teacher) onRemoveTeacher;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Преподаватели', style: AppTextStyle.titleS),
            const Spacer(),
            TextButton(onPressed: onAddTeacher, child: const Text('Добавить')),
          ],
        ),
        Wrap(
          spacing: AppSpacing.sm,
          children:
              teachers
                  .map(
                    (t) => Chip(
                      label: Text(t.name),
                      onDeleted: () => onRemoveTeacher(t),
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }
}

class DateSelectorWidget extends StatelessWidget {
  const DateSelectorWidget({
    super.key,
    required this.selectedDates,
    required this.onAddDates,
    required this.onRemoveDate,
  });

  final List<DateTime> selectedDates;
  final VoidCallback onAddDates;
  final void Function(DateTime) onRemoveDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Даты', style: AppTextStyle.titleS),
            const Spacer(),
            TextButton(onPressed: onAddDates, child: const Text('Выбрать')),
          ],
        ),
        Wrap(
          spacing: AppSpacing.sm,
          children:
              selectedDates
                  .map(
                    (d) => Chip(
                      label: Text(DateFormat('dd.MM.yyyy').format(d)),
                      onDeleted: () => onRemoveDate(d),
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }
}

class LocationSelectorWidget extends StatelessWidget {
  const LocationSelectorWidget({
    super.key,
    required this.isOnline,
    required this.onlineUrl,
    required this.classrooms,
    required this.onOnlineChanged,
    required this.onUrlChanged,
    required this.onAddClassroom,
    required this.onRemoveClassroom,
  });

  final bool isOnline;
  final String onlineUrl;
  final List<Classroom> classrooms;
  final void Function(bool) onOnlineChanged;
  final void Function(String) onUrlChanged;
  final VoidCallback onAddClassroom;
  final void Function(Classroom) onRemoveClassroom;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Row(
          children: [
            Text('Онлайн', style: AppTextStyle.titleS),
            const Spacer(),
            Switch(value: isOnline, onChanged: onOnlineChanged),
          ],
        ),
        if (isOnline)
          TextInput(
            controller: TextEditingController(text: onlineUrl),
            labelText: 'Ссылка',
            onChanged: (v) => onUrlChanged(v),
          )
        else ...[
          Row(
            children: [
              Text('Аудитории', style: AppTextStyle.titleS),
              const Spacer(),
              TextButton(
                onPressed: onAddClassroom,
                child: const Text('Добавить'),
              ),
            ],
          ),
          Wrap(
            spacing: AppSpacing.sm,
            children:
                classrooms
                    .map(
                      (c) => Chip(
                        label: Text(c.name),
                        onDeleted: () => onRemoveClassroom(c),
                      ),
                    )
                    .toList(),
          ),
        ],
      ],
    );
  }
}

class LessonPreviewWidget extends StatelessWidget {
  const LessonPreviewWidget({super.key, required this.lesson});

  final LessonSchedulePart? lesson;

  @override
  Widget build(BuildContext context) {
    if (lesson == null) return const SizedBox.shrink();
    return LessonCard(lesson: lesson!);
  }
}

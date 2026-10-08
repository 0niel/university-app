import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/login/widgets/auth_page_layout.dart';
import 'package:rtu_mirea_app/teacher_account/widgets/teacher_picker.dart';
import 'package:schedule_repository/schedule_repository.dart';

class OnboardingTeacherStep extends StatelessWidget {
  const OnboardingTeacherStep({
    required this.totalSteps,
    required this.onSelected,
    required this.onBack,
    required this.onNext,
    required this.onLater,
    required this.onStudentMode,
    this.selected,
    super.key,
  });

  final int totalSteps;
  final Teacher? selected;
  final ValueChanged<Teacher> onSelected;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback onLater;
  final VoidCallback onStudentMode;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AuthPageLayout(
      step: 2,
      totalSteps: totalSteps,
      title: l10n.onboardingTeacherTitle,
      subtitle: l10n.onboardingTeacherLead,
      onBack: onBack,
      actions: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppButton.primary(
            key: const Key('onboarding_teacherContinue'),
            label: l10n.onboardingContinue,
            size: AppButtonSize.hero,
            expanded: true,
            onPressed: selected == null ? null : onNext,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppButton.text(
            key: const Key('onboarding_teacherLater'),
            label: l10n.teacherChooseLater,
            expanded: true,
            size: AppButtonSize.large,
            onPressed: onLater,
          ),
          AppButton.text(
            key: const Key('onboarding_studentMode'),
            label: l10n.onboardingStudentStart,
            expanded: true,
            foregroundColor: context.colors.muted,
            onPressed: onStudentMode,
          ),
        ],
      ),
      child: TeacherPicker(selected: selected, onSelected: onSelected),
    );
  }
}

import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class AccountRoleSelector extends StatelessWidget {
  const AccountRoleSelector({
    required this.role,
    required this.onChanged,
    this.showDescription = true,
    super.key,
  });

  final AccountRole role;
  final ValueChanged<AccountRole>? onChanged;
  final bool showDescription;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppSegmentedControl<AccountRole>(
          onCanvas: true,
          value: role,
          options: [
            AppSegmentedOption(
              value: AccountRole.student,
              label: l10n.accountRoleStudent,
            ),
            AppSegmentedOption(
              value: AccountRole.teacher,
              label: l10n.teacherRoleFallback,
            ),
          ],
          onChanged: onChanged,
        ),
        if (showDescription) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            role == AccountRole.teacher
                ? l10n.accountRoleTeacherDescription
                : l10n.accountRoleStudentDescription,
            style: AppText.body.copyWith(color: context.colors.muted),
          ),
        ],
      ],
    );
  }
}

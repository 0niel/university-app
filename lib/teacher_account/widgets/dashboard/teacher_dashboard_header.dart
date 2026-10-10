import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class TeacherDashboardHeader extends StatelessWidget {
  const TeacherDashboardHeader({required this.onBack, super.key});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (MediaQuery.textScalerOf(context).scale(1) <= 1.4) {
      return AppInnerHeader(
        title: l10n.teacherCabinetTitle,
        backSemanticsLabel: l10n.back,
        onBack: onBack,
      );
    }
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.screenTop + MediaQuery.paddingOf(context).top,
        AppSpacing.screen,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: AppIconButton(
              icon: const AppLineIconWidget(AppLineIcon.chevronL),
              tooltip: l10n.back,
              onPressed: onBack,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Semantics(
            header: true,
            child: Text(
              l10n.teacherCabinetTitle,
              style: AppText.section.copyWith(color: context.colors.ink),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class SchedulePageHeader extends StatelessWidget {
  const SchedulePageHeader({required this.title, super.key, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const .fromLTRB(
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Row(
        children: [
          AppIconButton(
            icon: const AppLineIconWidget(
              .chevronL,
              size: 20,
            ),
            tooltip: context.l10n.back,
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: .center,
              style: AppText.headline.copyWith(
                color: colors.ink,
                fontWeight: .w700,
              ),
            ),
          ),
          if (trailing != null)
            trailing!
          else
            const SizedBox(width: AppSpacing.xxlg),
        ],
      ),
    );
  }
}

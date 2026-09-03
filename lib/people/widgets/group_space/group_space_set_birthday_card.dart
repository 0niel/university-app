import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class GroupSpaceSetBirthdayCard extends StatelessWidget {
  const GroupSpaceSetBirthdayCard({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
      child: AppPressable(
        onTap: onTap,
        semanticsLabel: l10n.groupSpaceSetBirthdayCta,
        semanticsButton: true,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.tint,
            borderRadius: BorderRadius.circular(AppRadius.card),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              spacing: 12,
              children: [
                AppIconTile(
                  icon: AppLineIcon.calendar,
                  background: colors.surface,
                  foreground: colors.accent,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.groupSpaceSetBirthdayCta,
                        style: AppText.headline.copyWith(color: colors.ink),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.groupSpaceSetBirthdaySubtitle,
                        style: AppText.caption.copyWith(color: colors.muted),
                      ),
                    ],
                  ),
                ),
                AppLineIconWidget(
                  AppLineIcon.chevronR,
                  size: 16,
                  color: colors.muted2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

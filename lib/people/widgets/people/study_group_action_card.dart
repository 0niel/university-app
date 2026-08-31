part of '../people_widgets.dart';

class StudyGroupActionCard extends StatelessWidget {
  const StudyGroupActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    super.key,
  });

  final AppLineIcon icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return AppPressable(
      onTap: onTap,
      semanticsLabel: '$title, $subtitle',
      semanticsButton: true,
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: .circular(NinjaRadius.card),
        ),
        padding: const .fromLTRB(16, 14, 12, 14),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              alignment: .center,
              decoration: BoxDecoration(
                color: colors.surfaceAlt,
                borderRadius: .circular(11),
              ),
              child: AppLineIconWidget(icon, size: 18, color: colors.mutedDark),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: .ellipsis,
                    style: NinjaText.body.copyWith(
                      color: colors.ink,
                      fontWeight: .w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: .ellipsis,
                    style: NinjaText.helper.copyWith(color: colors.muted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            AppLineIconWidget(.chevronR, size: 16, color: colors.chevron),
          ],
        ),
      ),
    );
  }
}

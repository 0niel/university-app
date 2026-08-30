part of '../create_schedule_page.dart';

class _WayCard extends StatelessWidget {
  const _WayCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
    this.recommended = false,
    this.badge,
  });

  final AppLineIcon icon;
  final String title;
  final String description;
  final bool recommended;
  final String? badge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final badge = this.badge;
    return NinjaScheduleSurface(
      onTap: onTap,
      semanticLabel: title,
      child: Row(
        spacing: 8,
        children: [
          Container(
            width: 44,
            height: 44,
            margin: const .only(right: 6),
            decoration: BoxDecoration(
              color: colors.brandTint,
              shape: .circle,
            ),
            child: Center(
              child: AppLineIconWidget(
                icon,
                size: 21,
                color: colors.brandInk,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              spacing: 3,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: NinjaText.body.copyWith(
                          color: colors.ink,
                          fontWeight: .w700,
                        ),
                      ),
                    ),
                    if (recommended && badge != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const .symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colors.brand,
                          borderRadius: .circular(NinjaRadius.pill),
                        ),
                        child: Text(
                          badge,
                          style: NinjaText.badge.copyWith(
                            color: colors.onBrand,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  description,
                  style: NinjaText.subtext.copyWith(
                    color: colors.muted,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          AppLineIconWidget(.chevronR, size: 16, color: colors.chevron),
        ],
      ),
    );
  }
}

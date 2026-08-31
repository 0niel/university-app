part of '../view/onboarding_page.dart';

class _PermissionRow extends StatelessWidget {
  const _PermissionRow({
    required this.icon,
    required this.title,
    required this.description,
    required this.granted,
    required this.onTap,
  });

  final AppLineIcon icon;
  final String title;
  final String description;
  final bool granted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Semantics(
      button: !granted,
      enabled: !granted,
      child: AppPressable(
        onTap: granted ? null : onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: .circular(NinjaRadius.card),
          ),
          child: Padding(
            padding: const .fromLTRB(16, 14, 16, 14),
            child: Row(
              crossAxisAlignment: .start,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: granted ? colors.brand : colors.brandTint,
                    shape: .circle,
                  ),
                  child: SizedBox.square(
                    dimension: NinjaMetrics.minTouchTarget,
                    child: AppLineIconWidget(
                      icon,
                      size: 20,
                      color: granted ? colors.onBrand : colors.brand,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        title,
                        style: NinjaText.headline.copyWith(color: colors.ink),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        description,
                        style: NinjaText.subtext.copyWith(
                          color: colors.mutedDark,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Padding(
                  padding: const .only(top: 9),
                  child: _GrantedCheck(granted: granted),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

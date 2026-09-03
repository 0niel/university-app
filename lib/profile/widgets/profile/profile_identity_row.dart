part of 'profile_widgets.dart';

class ProfileIdentityRow extends StatelessWidget {
  const ProfileIdentityRow({
    required this.name,
    required this.meta,
    this.onTap,
    super.key,
  });

  final String name;
  final String meta;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppPressable(
      onTap: onTap,
      semanticsLabel: name,
      semanticsButton: onTap != null,
      pressedScale: 1,
      child: Row(
        children: [
          AppAvatar(name: name, size: 72, color: colors.accent),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.sectionLarge.copyWith(color: colors.ink),
                ),
                if (meta.isNotEmpty) ...[
                  const SizedBox(height: 5),
                  Text(
                    meta,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.sans(
                      13.5,
                      FontWeight.w500,
                      height: 17 / 13.5,
                    ).copyWith(color: colors.muted),
                  ),
                ],
              ],
            ),
          ),
          if (onTap != null) ...[
            const SizedBox(width: AppSpacing.md),
            AppLineIconWidget(
              AppLineIcon.chevronR,
              size: 16,
              color: colors.muted2,
            ),
          ],
        ],
      ),
    );
  }
}

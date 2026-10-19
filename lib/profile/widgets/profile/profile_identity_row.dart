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
    return AppFeatureCard.identity(
      onTap: onTap,
      semanticsLabel: name,
      leading: Container(
        padding: const EdgeInsets.all(AppSpacing.fine),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: colors.accent.withValues(alpha: .22)),
          color: colors.surface.withValues(alpha: .5),
        ),
        child: AppAvatar(name: name, size: 64, color: colors.accent),
      ),
      trailing: onTap == null
          ? null
          : SizedBox.square(
              dimension: AppIconSize.md + AppSpacing.md * 2,
              child: Center(
                child: AppLineIconWidget(
                  AppLineIcon.chevronR,
                  size: AppIconSize.md,
                  color: colors.ink,
                ),
              ),
            ),
      title: Text(name, maxLines: 3, overflow: TextOverflow.ellipsis),
      subtitle: meta.isEmpty
          ? null
          : Text(meta, maxLines: 3, overflow: TextOverflow.ellipsis),
    );
  }
}

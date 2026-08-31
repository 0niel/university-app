part of 'mini_app_submit_page.dart';

class _PermissionsSection extends StatelessWidget {
  const _PermissionsSection({
    required this.permissions,
    required this.onToggled,
  });

  final Set<MiniAppPermission> permissions;
  final void Function(MiniAppPermission permission) onToggled;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: .start,
      children: [
        _SubmitSectionLabel(
          title: l10n.miniAppsSubmitPermissions,
          subtitle: l10n.miniAppsSubmitPermissionsSubtitle,
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final permission in MiniAppPermission.values)
              NinjaChip(
                label: miniAppPermissionLabel(context, permission),
                selected: permissions.contains(permission),
                onTap: () => onToggled(permission),
              ),
          ],
        ),
      ],
    );
  }
}

part of '../view/onboarding_page.dart';

class _PermissionsStepBody extends StatelessWidget {
  const _PermissionsStepBody({
    required this.notificationsGranted,
    required this.locationGranted,
    required this.showNotifications,
    required this.loading,
    required this.onRequestNotifications,
    required this.onRequestLocation,
  });

  final bool notificationsGranted;
  final bool locationGranted;
  final bool showNotifications;
  final bool loading;
  final VoidCallback onRequestNotifications;
  final VoidCallback onRequestLocation;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final rowCount = showNotifications ? 2 : 1;

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        const _OnboardingLeadIcon(AppLineIcon.tune),
        const SizedBox(height: 18),
        Text(
          l10n.onboardingPermTitle,
          style: NinjaText.title.copyWith(color: colors.ink),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.onboardingPermSubtitle,
          style: NinjaText.body.copyWith(color: colors.mutedDark),
        ),
        const SizedBox(height: 22),
        NinjaStateSwitcher(
          child: loading
              ? _PermissionRowsSkeleton(
                  key: const ValueKey('loading'),
                  rows: rowCount,
                )
              : Column(
                  key: const ValueKey('permissions'),
                  crossAxisAlignment: .stretch,
                  children: [
                    if (showNotifications) ...[
                      _PermissionRow(
                        icon: .bell,
                        title: l10n.onboardingPermNotificationsTitle,
                        description: l10n.onboardingPermNotificationsDesc,
                        granted: notificationsGranted,
                        onTap: onRequestNotifications,
                      ),
                      const SizedBox(height: 10),
                    ],
                    _PermissionRow(
                      icon: .pin,
                      title: l10n.onboardingPermLocationTitle,
                      description: l10n.onboardingPermLocationDesc,
                      granted: locationGranted,
                      onTap: onRequestLocation,
                    ),
                  ],
                ),
        ),
        const SizedBox(height: 22),
        Text(
          l10n.onboardingPermNote,
          style: NinjaText.helper.copyWith(color: colors.muted),
        ),
      ],
    );
  }
}

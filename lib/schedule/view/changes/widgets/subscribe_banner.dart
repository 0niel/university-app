part of '../changes_page.dart';

class _SubscribeBanner extends StatelessWidget {
  const _SubscribeBanner({required this.enabled, required this.onChanged});

  final bool enabled;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) => AppCard(
    padding: EdgeInsets.zero,
    child: AppSettingsToggleRow(
      title: context.l10n.changesAlertsTitle,
      subtitle: context.l10n.changesPushBanner,
      value: enabled,
      onChanged: onChanged,
      isFirst: true,
      isLast: true,
    ),
  );
}

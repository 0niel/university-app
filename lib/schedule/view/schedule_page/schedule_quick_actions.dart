import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class ScheduleQuickActions extends StatelessWidget {
  const ScheduleQuickActions({
    required this.onSearch,
    required this.onChanges,
    required this.onExport,
    required this.hasChanges,
    super.key,
  });

  final VoidCallback onSearch;
  final VoidCallback onChanges;
  final VoidCallback onExport;
  final bool hasChanges;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      children: [
        Expanded(
          child: AppButton.secondary(
            key: const ValueKey('schedule-search'),
            label: l10n.search,
            icon: const AppLineIconWidget(AppLineIcon.search),
            size: AppButtonSize.small,
            expanded: true,
            onPressed: onSearch,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        AppIconButton(
          key: const ValueKey('schedule-changes'),
          icon: const AppLineIconWidget(AppLineIcon.bell),
          shape: AppIconButtonShape.circle,
          tone: AppIconButtonTone.surface,
          tooltip: l10n.changesTitle,
          onPressed: onChanges,
          dot: hasChanges,
          dotColor: context.colors.warn,
        ),
        const SizedBox(width: AppSpacing.sm),
        AppIconButton(
          key: const ValueKey('schedule-export'),
          icon: const AppLineIconWidget(AppLineIcon.download),
          shape: AppIconButtonShape.circle,
          tone: AppIconButtonTone.surface,
          tooltip: l10n.exportScheduleTitle,
          onPressed: onExport,
        ),
      ],
    );
  }
}

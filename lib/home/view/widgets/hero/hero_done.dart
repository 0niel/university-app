import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class HeroDone extends StatelessWidget {
  const HeroDone({
    required this.tomorrowLabel,
    required this.deadlineLabel,
    required this.onDeadlines,
    required this.onTomorrow,
    super.key,
  });
  final String tomorrowLabel;
  final String deadlineLabel;
  final VoidCallback onDeadlines;
  final VoidCallback onTomorrow;

  @override
  Widget build(BuildContext context) => AppCard(
    radius: AppRadius.hero,
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.l10n.homeHeroDoneTitle,
          style: AppText.sectionLarge.copyWith(color: context.colors.ink),
        ),
        const SizedBox(height: 12),
        Text(
          tomorrowLabel,
          style: AppText.compact.copyWith(color: context.colors.muted),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final actions = [
              AppButton.tonal(
                label: deadlineLabel,
                size: AppButtonSize.small,
                onPressed: onDeadlines,
              ),
              AppButton.secondary(
                label: context.l10n.homeHeroTomorrowPlan,
                size: AppButtonSize.small,
                backgroundColor: context.colors.canvas,
                onPressed: onTomorrow,
              ),
            ];
            if (constraints.maxWidth < 320 ||
                MediaQuery.textScalerOf(context).scale(1) > 1.3) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  actions.first,
                  const SizedBox(height: 8),
                  actions.last,
                ],
              );
            }
            return Row(
              children: [
                Expanded(child: actions.first),
                const SizedBox(width: 8),
                Expanded(child: actions.last),
              ],
            );
          },
        ),
      ],
    ),
  );
}

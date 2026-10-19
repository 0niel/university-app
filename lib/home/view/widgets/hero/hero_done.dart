import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/home/view/widgets/hero/home_hero_surface.dart';
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
  Widget build(BuildContext context) => HomeHeroSurface(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.l10n.homeHeroDoneTitle,
          style: AppText.sectionLarge.copyWith(color: context.colors.ink),
        ),
        const SizedBox(height: 8),
        Text(
          tomorrowLabel,
          style: AppText.compact.copyWith(color: context.colors.muted),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final deadlines = AppButton.tonal(
              label: deadlineLabel,
              size: AppButtonSize.small,
              onPressed: onDeadlines,
            );
            final tomorrow = AppButton.secondary(
              label: context.l10n.homeHeroTomorrowPlan,
              size: AppButtonSize.small,
              backgroundColor: context.colors.canvas,
              onPressed: onTomorrow,
            );
            if (constraints.maxWidth < 280 ||
                MediaQuery.textScalerOf(context).scale(1) > 1.3) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  deadlines,
                  const SizedBox(height: 8),
                  tomorrow,
                ],
              );
            }
            return Row(
              children: [
                Expanded(child: deadlines),
                const SizedBox(width: 8),
                Expanded(child: tomorrow),
              ],
            );
          },
        ),
      ],
    ),
  );
}

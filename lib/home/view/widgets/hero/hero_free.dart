import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class HeroFree extends StatelessWidget {
  const HeroFree({super.key});

  @override
  Widget build(BuildContext context) => AppCard(
    radius: AppRadius.hero,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: '${context.l10n.homeHeroFreeTitle}\n'),
              TextSpan(
                text: context.l10n.scheduleFreeDayTitle,
                style: AppText.serif(
                  24,
                  italic: true,
                ).copyWith(color: context.colors.accent),
              ),
            ],
          ),
          style: AppText.sectionLarge.copyWith(color: context.colors.ink),
        ),
        const SizedBox(height: 8),
        Text(
          context.l10n.homeHeroFreeBody,
          style: AppText.compact.copyWith(
            color: context.colors.muted,
            height: 1.45,
          ),
        ),
      ],
    ),
  );
}

import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/home/view/widgets/hero/home_hero_surface.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class HeroFree extends StatelessWidget {
  const HeroFree({super.key});

  @override
  Widget build(BuildContext context) => HomeHeroSurface(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: '${context.l10n.homeHeroFreeTitle}\n'),
              TextSpan(
                text: context.l10n.scheduleFreeDayTitle,
                style: AppText.sans(
                  20,
                  FontWeight.w700,
                  height: 1.15,
                ).copyWith(color: context.colors.accent, letterSpacing: -.7),
              ),
            ],
          ),
          style: AppText.title.copyWith(color: context.colors.ink),
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

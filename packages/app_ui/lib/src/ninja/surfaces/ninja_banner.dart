import 'package:app_ui/src/ninja/ninja_colors.dart';
import 'package:app_ui/src/ninja/ninja_text.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/widgets.dart';

class NinjaBanner extends StatelessWidget {
  const NinjaBanner({
    required this.title,
    super.key,
    this.tone = NinjaBannerTone.info,
    this.body,
    this.actionLabel,
    this.onAction,
    this.icon,
  });

  final String title;
  final NinjaBannerTone tone;
  final String? body;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final palette = _palette(colors);
    final bodyText = body;
    final action = actionLabel;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(NinjaRadius.card),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: palette.accent.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(13),
              ),
              child: icon ??
                  AppLineIconWidget(
                    palette.icon,
                    size: 20,
                    color: palette.accent,
                  ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: NinjaText.headline.copyWith(color: colors.ink),
                  ),
                  if (bodyText != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      bodyText,
                      style:
                          NinjaText.subtext.copyWith(color: colors.mutedDark),
                    ),
                  ],
                  if (action != null) ...[
                    const SizedBox(height: 7),
                    _NinjaBannerAction(
                      label: action,
                      accent: palette.accent,
                      onPressed: onAction,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _NinjaBannerPalette _palette(NinjaColors colors) => switch (tone) {
        NinjaBannerTone.danger => _NinjaBannerPalette(
            accent: colors.scarlet,
            icon: AppLineIcon.alert,
          ),
        NinjaBannerTone.warn => _NinjaBannerPalette(
            accent: colors.amberInk,
            icon: AppLineIcon.alert,
          ),
        NinjaBannerTone.success => _NinjaBannerPalette(
            accent: colors.green,
            icon: AppLineIcon.check,
          ),
        NinjaBannerTone.info => _NinjaBannerPalette(
            accent: colors.brandInk,
            icon: AppLineIcon.info,
          ),
      };
}

enum NinjaBannerTone { danger, warn, success, info }

class _NinjaBannerAction extends StatelessWidget {
  const _NinjaBannerAction({
    required this.label,
    required this.accent,
    required this.onPressed,
  });

  final String label;
  final Color accent;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final content = Container(
      constraints: const BoxConstraints(minHeight: NinjaMetrics.minTouchTarget),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: AlignmentDirectional.centerStart,
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(NinjaRadius.pill),
      ),
      child: Text(
        label,
        style: NinjaText.button.copyWith(color: accent),
      ),
    );
    final onPressed = this.onPressed;
    if (onPressed == null) return content;
    return AppPressable(
      onTap: onPressed,
      semanticsLabel: label,
      child: content,
    );
  }
}

class _NinjaBannerPalette {
  const _NinjaBannerPalette({required this.accent, required this.icon});

  final Color accent;
  final AppLineIcon icon;
}

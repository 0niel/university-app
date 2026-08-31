import 'package:app_ui/src/ninja/ninja_colors.dart';
import 'package:app_ui/src/ninja/ninja_text.dart';
import 'package:app_ui/src/ninja/surfaces/ninja_action_button.dart';
import 'package:app_ui/src/ninja/surfaces/ninja_glyph.dart';
import 'package:flutter/widgets.dart';

class NinjaErrorState extends StatelessWidget {
  const NinjaErrorState({
    required this.title,
    super.key,
    this.message,
    this.tone = NinjaErrorTone.danger,
    this.icon,
    this.retryLabel,
    this.onRetry,
    this.secondaryLabel,
    this.onSecondary,
  });
  final String title;
  final String? message;
  final NinjaErrorTone tone;
  final Widget? icon;
  final String? retryLabel;
  final VoidCallback? onRetry;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final messageText = message;
    final retry = retryLabel;
    final secondary = secondaryLabel;
    final accent = tone.accentOf(colors);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(NinjaRadius.card),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: tone.tintOf(colors),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: IconTheme(
              data: IconThemeData(size: 24, color: accent),
              child:
                  icon ?? NinjaGlyphIcon(tone.glyph, size: 24, color: accent),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: NinjaText.headline.copyWith(color: colors.ink),
          ),
          if (messageText != null) ...[
            const SizedBox(height: 4),
            Text(
              messageText,
              textAlign: TextAlign.center,
              style: NinjaText.subtext.copyWith(color: colors.muted),
            ),
          ],
          if (retry != null || secondary != null) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                if (retry != null)
                  NinjaActionButton(
                    label: retry,
                    onPressed: onRetry,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    fontSize: 13,
                  ),
                if (secondary != null)
                  NinjaActionButton(
                    label: secondary,
                    onPressed: onSecondary,
                    tone: NinjaActionTone.surface,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    fontSize: 13,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

enum NinjaErrorTone {
  danger,
  warn,
  info;

  Color accentOf(NinjaColors colors) => switch (this) {
        NinjaErrorTone.danger => colors.scarlet,
        NinjaErrorTone.warn => colors.amberInk,
        NinjaErrorTone.info => colors.brandInk,
      };
  Color tintOf(NinjaColors colors) => switch (this) {
        NinjaErrorTone.danger => colors.dangerTint,
        NinjaErrorTone.warn => colors.warnTint,
        NinjaErrorTone.info => colors.infoTint,
      };
  NinjaGlyph get glyph => switch (this) {
        NinjaErrorTone.danger => NinjaGlyph.warning,
        NinjaErrorTone.warn || NinjaErrorTone.info => NinjaGlyph.info,
      };
}

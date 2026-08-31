import 'package:app_ui/src/ninja/ninja_colors.dart';
import 'package:app_ui/src/ninja/ninja_text.dart';
import 'package:app_ui/src/ninja/widgets/ninja_button.dart';
import 'package:flutter/widgets.dart';

class NinjaEmptyState extends StatelessWidget {
  const NinjaEmptyState({
    required this.title,
    super.key,
    this.message,
    this.icon,
    this.actionLabel,
    this.onAction,
    this.outlinedAction = false,
  }) : _screen = false;

  const NinjaEmptyState.screen({
    required this.title,
    super.key,
    this.message,
    this.icon,
    this.actionLabel,
    this.onAction,
    this.outlinedAction = false,
  }) : _screen = true;

  final bool _screen;

  final String title;
  final String? message;
  final Widget? icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool outlinedAction;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final messageText = message;
    final action = actionLabel;
    final iconWidget = icon;

    final circle = _screen ? 72.0 : 56.0;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: _screen ? const Color(0x00000000) : colors.surface,
        borderRadius: BorderRadius.circular(NinjaRadius.card),
      ),
      child: Padding(
        padding: _screen
            ? const EdgeInsets.symmetric(horizontal: 20, vertical: 40)
            : const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: colors.surfaceAlt,
                shape: BoxShape.circle,
              ),
              child: SizedBox.square(
                dimension: circle,
                child: Center(
                  child: iconWidget == null
                      ? Text(
                          '?',
                          style: NinjaText.title.copyWith(color: colors.muted),
                        )
                      : IconTheme(
                          data: IconThemeData(
                            size: _screen ? 28 : 24,
                            color: colors.brandInk,
                          ),
                          child: iconWidget,
                        ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: (_screen ? NinjaText.title : NinjaText.headline).copyWith(
                color: colors.ink,
              ),
            ),
            if (messageText != null) ...[
              const SizedBox(height: 6),
              Text(
                messageText,
                textAlign: TextAlign.center,
                style: NinjaText.subtext.copyWith(color: colors.muted),
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: 18),
              if (outlinedAction)
                NinjaButton.secondary(
                  label: action,
                  size: NinjaButtonSize.small,
                  onPressed: onAction,
                )
              else
                NinjaButton.primary(
                  label: action,
                  size: NinjaButtonSize.small,
                  onPressed: onAction,
                ),
            ],
          ],
        ),
      ),
    );
  }
}

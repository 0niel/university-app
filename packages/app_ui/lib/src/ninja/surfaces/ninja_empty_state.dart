import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/ninja/surfaces/ninja_pill_button.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
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
  })  : _screen = false,
        _compact = false;

  const NinjaEmptyState.screen({
    required this.title,
    super.key,
    this.message,
    this.icon,
    this.actionLabel,
    this.onAction,
    this.outlinedAction = false,
  })  : _screen = true,
        _compact = false;

  const NinjaEmptyState.compact({
    required this.title,
    super.key,
    this.message,
    this.icon,
    this.actionLabel,
    this.onAction,
    this.outlinedAction = false,
  })  : _screen = false,
        _compact = true;

  final bool _screen;
  final bool _compact;

  final String title;
  final String? message;
  final Widget? icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool outlinedAction;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final messageText = message;
    final action = actionLabel;
    final iconWidget = icon;

    if (_compact) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.fieldGap,
          vertical: AppSpacing.sheetBottom,
        ),
        child: Center(
          child: Text(
            messageText ?? title,
            textAlign: TextAlign.center,
            style: AppText.body.copyWith(color: colors.muted),
          ),
        ),
      );
    }

    final tile = _screen ? 64.0 : 56.0;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: _screen ? const Color(0x00000000) : colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Padding(
        padding: _screen
            ? const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.xxlg,
              )
            : const EdgeInsets.symmetric(
                horizontal: AppSpacing.fieldGap,
                vertical: AppSpacing.xlg,
              ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: tile,
              height: tile,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.tint,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: IconTheme(
                data: IconThemeData(
                  size: _screen ? 26 : 24,
                  color: colors.accent,
                ),
                child: iconWidget ?? const SizedBox.shrink(),
              ),
            ),
            const SizedBox(height: AppSpacing.gap),
            Text(
              title,
              textAlign: TextAlign.center,
              style: (_screen ? AppText.section : AppText.sectionSmall)
                  .copyWith(color: colors.ink),
            ),
            if (messageText != null) ...[
              const SizedBox(height: AppSpacing.gap),
              Text(
                messageText,
                textAlign: TextAlign.center,
                style: AppText.subtext.copyWith(
                  color: colors.muted,
                  height: 1.4,
                ),
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: AppSpacing.gap),
              NinjaPillButton(
                label: action,
                onPressed: onAction,
                tone: outlinedAction
                    ? NinjaPillTone.secondary
                    : NinjaPillTone.tonal,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class PromoBottomBar extends StatelessWidget {
  const PromoBottomBar({
    required this.accent,
    required this.registerLabel,
    required this.onRegister,
    required this.contactSemanticsLabel,
    super.key,
    this.onContact,
  });

  final Color accent;
  final String registerLabel;
  final VoidCallback onRegister;
  final String contactSemanticsLabel;
  final VoidCallback? onContact;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ColoredBox(
      color: colors.canvas,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            AppSpacing.md,
            AppSpacing.screen,
            AppSpacing.lg,
          ),
          child: Row(
            children: [
              Expanded(
                child: AppButton.primary(
                  label: registerLabel,
                  size: AppButtonSize.large,
                  expanded: true,
                  backgroundColor: accent,
                  foregroundColor: colors.white,
                  trailingIcon: const AppLineIconWidget(
                    AppLineIcon.arrowRight,
                    size: AppIconSize.compact,
                  ),
                  onPressed: onRegister,
                ),
              ),
              if (onContact != null) ...[
                const SizedBox(width: AppSpacing.sm),
                SizedBox.square(
                  dimension: AppControlSize.buttonLarge,
                  child: AppIconButton(
                    icon: const AppLineIconWidget(AppLineIcon.send),
                    tooltip: contactSemanticsLabel,
                    tone: AppIconButtonTone.tonal,
                    onPressed: onContact,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppSearchField extends StatelessWidget {
  const AppSearchField({
    required this.controller,
    super.key,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.autofocus = false,
    this.height = 48,
    this.borderRadius = AppRadius.button,
    this.fillColor,
    this.accentIconWhenEmpty = false,
    this.trailing,
    this.focusNode,
    this.textCapitalization = TextCapitalization.none,
    this.keyboardType,
  });

  final TextEditingController controller;

  final String? hintText;

  final ValueChanged<String>? onChanged;

  final ValueChanged<String>? onSubmitted;

  final VoidCallback? onClear;

  final bool autofocus;

  final double height;

  final double borderRadius;

  final Color? fillColor;

  final bool accentIconWhenEmpty;

  final Widget? trailing;

  final FocusNode? focusNode;

  final TextCapitalization textCapitalization;

  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final trailing = this.trailing;
    return Material(
      color: Colors.transparent,
      child: Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        decoration: BoxDecoration(
          color: fillColor ?? colors.surface,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Row(
          children: [
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, _) => AppLineIconWidget(
                AppLineIcon.search,
                size: AppIconSize.md,
                color: accentIconWhenEmpty && value.text.isEmpty
                    ? colors.primary
                    : colors.deactiveDarker,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                autofocus: autofocus,
                textInputAction: TextInputAction.search,
                textCapitalization: textCapitalization,
                keyboardType: keyboardType,
                cursorColor: colors.primary,
                onChanged: onChanged,
                onSubmitted: onSubmitted,
                style: AppText.body.copyWith(color: colors.active),
                decoration: InputDecoration(
                  isCollapsed: true,
                  isDense: true,
                  filled: false,
                  fillColor: Colors.transparent,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: hintText,
                  hintStyle: AppText.body.copyWith(
                    color: colors.deactiveDarker,
                  ),
                ),
              ),
            ),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, _) {
                if (value.text.isEmpty) return const SizedBox.shrink();
                return AppPressable(
                  pressedScale: 0.92,
                  onTap: () {
                    controller.clear();
                    onChanged?.call('');
                    onClear?.call();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: AppSpacing.sm),
                    child: AppLineIconWidget(
                      AppLineIcon.close,
                      size: 18,
                      color: colors.deactiveDarker,
                    ),
                  ),
                );
              },
            ),
            if (trailing != null) ...[
              const SizedBox(width: AppSpacing.sm),
              trailing,
            ],
          ],
        ),
      ),
    );
  }
}

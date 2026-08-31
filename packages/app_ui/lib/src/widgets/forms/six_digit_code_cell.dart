import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SixDigitCodeCell extends StatelessWidget {
  const SixDigitCodeCell({
    required this.controller,
    required this.focusNode,
    required this.autofocus,
    required this.onChanged,
    super.key,
    this.fillColor,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool autofocus;
  final ValueChanged<String> onChanged;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colors;
    final textField = TextField(
      controller: controller,
      focusNode: focusNode,
      autofocus: autofocus,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      textAlignVertical: TextAlignVertical.center,
      maxLength: 1,
      showCursor: true,
      cursorColor: colors.primary,
      style: AppText.title.copyWith(color: colors.active),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: const InputDecoration(
        counterText: '',
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        isCollapsed: true,
        contentPadding: EdgeInsets.zero,
      ),
      onChanged: onChanged,
    );

    return ListenableBuilder(
      listenable: Listenable.merge([controller, focusNode]),
      child: textField,
      builder: (context, child) {
        final themeColors = Theme.of(context).colors;
        final hasFocus = focusNode.hasFocus;
        final borderColor = hasFocus
            ? themeColors.primary
            : controller.text.isNotEmpty
                ? themeColors.borderMedium
                : Colors.transparent;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          height: 58,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: fillColor ?? themeColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: borderColor, width: hasFocus ? 2 : 1.5),
          ),
          child: child,
        );
      },
    );
  }
}

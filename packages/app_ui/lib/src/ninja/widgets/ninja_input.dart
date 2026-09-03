import 'package:app_ui/src/widgets/forms/app_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NinjaInput extends StatelessWidget {
  const NinjaInput({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.placeholder,
    this.leadingIcon,
    this.trailing,
    this.errorText,
    this.helperText,
    this.success = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.obscureText = false,
    this.clearable = true,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.autofillHints,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.textAlign = TextAlign.start,
    this.textStyle,
  }) : showCounter = false;

  const NinjaInput.multiline({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.placeholder,
    this.errorText,
    this.helperText,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLength,
    this.maxLines,
    this.minLines,
    this.inputFormatters,
    this.onChanged,
    this.onTap,
    this.textStyle,
  })  : leadingIcon = null,
        textAlign = TextAlign.start,
        trailing = null,
        success = false,
        obscureText = false,
        clearable = false,
        keyboardType = TextInputType.multiline,
        textInputAction = TextInputAction.newline,
        textCapitalization = TextCapitalization.sentences,
        autofillHints = null,
        onSubmitted = null,
        showCounter = true;

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? placeholder;
  final Widget? leadingIcon;
  final Widget? trailing;
  final String? errorText;
  final String? helperText;
  final bool success;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final bool obscureText;
  final bool clearable;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final bool showCounter;
  final TextAlign textAlign;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return AppInputField(
      controller: controller,
      focusNode: focusNode,
      label: label,
      placeholder: placeholder,
      leading: leadingIcon,
      trailing: trailing,
      errorText: errorText,
      helperText: helperText,
      success: success,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
      obscureText: obscureText,
      showPasswordToggle: obscureText,
      showClear: clearable,
      showCounter: showCounter,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      autofillHints: autofillHints,
      maxLength: maxLength,
      maxLines: maxLines,
      minLines: minLines,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onTap: onTap,
      textAlign: textAlign,
      textStyle: textStyle,
    );
  }
}

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  const TextInput({
    super.key,
    this.hintText,
    this.errorText,
    this.controller,
    this.keyboardType,
    this.maxLines,
    this.fillColor,
    this.prefixIcon,
    this.labelText,
    this.onChanged,
    this.textInputAction = TextInputAction.done,
    this.validator,
  });

  final String? hintText;
  final String? errorText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final int? maxLines;
  final Color? fillColor;
  final Widget? prefixIcon;
  final String? labelText;
  final ValueChanged<String>? onChanged;
  final TextInputAction textInputAction;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              labelText!,
              style: AppTextStyle.titleS.copyWith(
                color: Theme.of(context).extension<AppColors>()!.active,
              ),
            ),
          ),
        TextFormField(
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            errorText: errorText,
            errorStyle: AppTextStyle.captionL.copyWith(
              color: Theme.of(context).extension<AppColors>()!.colorful07,
            ),
            hintText: hintText,
            hintStyle: AppTextStyle.titleS.copyWith(
              color: Theme.of(context).extension<AppColors>()!.deactive,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            prefixIcon: prefixIcon,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).extension<AppColors>()!.primary,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).extension<AppColors>()!.colorful07,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.transparent,
                width: 0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.transparent,
                width: 0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).extension<AppColors>()!.colorful07,
              ),
            ),
            fillColor: fillColor ?? Theme.of(context).extension<AppColors>()!.background01,
            filled: true,
          ),
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          style: AppTextStyle.titleS,
          controller: controller,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

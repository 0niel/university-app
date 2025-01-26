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
  });

  final String? hintText;
  final String? errorText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final int? maxLines;
  final Color? fillColor;
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines,
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
      textInputAction: TextInputAction.done,
      style: AppTextStyle.titleS,
      controller: controller,
    );
  }
}

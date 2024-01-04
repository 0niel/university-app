import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';

class TextInput extends StatelessWidget {
  const TextInput({
    Key? key,
    this.hintText,
    this.errorText,
    this.controller,
    this.keyboardType,
    this.maxLines,
    this.fillColor,
  }) : super(key: key);

  final String? hintText;
  final String? errorText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final int? maxLines;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        errorText: errorText,
        errorStyle: AppTextStyle.captionL.copyWith(
          color: AppTheme.colors.colorful07,
        ),
        hintText: hintText,
        hintStyle: AppTextStyle.titleS.copyWith(
          color: AppTheme.colors.deactive,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppTheme.colors.primary,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppTheme.colors.colorful07,
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
            color: AppTheme.colors.colorful07,
          ),
        ),
        fillColor: fillColor ?? AppTheme.colors.background01,
        filled: true,
      ),
      keyboardType: keyboardType,
      textInputAction: TextInputAction.done,
      style: AppTextStyle.titleS,
      controller: controller,
    );
  }
}

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class NinjaFormInput extends StatelessWidget {
  const NinjaFormInput({
    required this.controller,
    required this.onValidate,
    super.key,
    this.label,
    this.placeholder,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final FormFieldValidator<String> onValidate;
  final String? label;
  final String? placeholder;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: controller.text,
      validator: onValidate,
      builder: (field) => NinjaInput(
        controller: controller,
        label: label,
        placeholder: placeholder,
        maxLines: maxLines,
        errorText: field.errorText,
        onChanged: field.didChange,
      ),
    );
  }
}

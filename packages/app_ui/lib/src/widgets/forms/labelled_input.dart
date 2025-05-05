import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class LabelledInput extends StatefulWidget {
  const LabelledInput({
    required this.label,
    this.placeholder,
    this.controller,
    this.obscureText,
    this.keyboardType,
    super.key,
    this.value,
    this.onChanged,
    this.errorText,
    this.showPasswordToggle = false,
    this.autofillHints,
  });

  final String label;
  final String? placeholder;
  final String? value;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final bool showPasswordToggle;
  final Iterable<String>? autofillHints;

  @override
  State<LabelledInput> createState() => _LabelledInputState();
}

class _LabelledInputState extends State<LabelledInput> {
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label.toUpperCase(),
          textAlign: TextAlign.left,
          style: AppTextStyle.chip.copyWith(color: Theme.of(context).extension<AppColors>()!.deactiveDarker),
        ),
        TextField(
          controller: widget.controller,
          autofillHints: widget.autofillHints,
          style: AppTextStyle.title,
          onTap: () {},
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText == true && !_showPassword,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            suffixIcon: widget.showPasswordToggle && widget.obscureText == true
                ? IconButton(
                    icon: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off,
                      color: Theme.of(context).extension<AppColors>()!.deactiveDarker,
                    ),
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                  )
                : widget.controller?.text.isNotEmpty == true
                    ? IconButton(
                        icon: Icon(
                          Icons.cancel,
                          color: Theme.of(context).extension<AppColors>()!.deactiveDarker,
                        ),
                        onPressed: () {
                          widget.controller?.clear();
                        },
                      )
                    : null,
            hintText: widget.placeholder,
            hintStyle: AppTextStyle.titleM.copyWith(color: Theme.of(context).extension<AppColors>()!.deactive),
            errorText: widget.errorText,
            errorStyle: AppTextStyle.captionL.copyWith(
              color: AppColors.dark.colorful07,
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).extension<AppColors>()!.colorful05),
            ),
            filled: false,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).extension<AppColors>()!.deactiveDarker),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).extension<AppColors>()!.colorful05),
            ),
          ),
        ),
      ],
    );
  }
}

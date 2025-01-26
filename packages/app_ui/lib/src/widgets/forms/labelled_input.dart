import 'package:app_ui/app_ui.dart';
import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class LabelledInput extends StatefulWidget {
  const LabelledInput({
    required this.placeholder,
    required this.keyboardType,
    required this.controller,
    required this.obscureText,
    required this.label,
    super.key,
    this.value,
  });

  final String label;
  final String placeholder;
  final String? value;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextEditingController controller;

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
        const SizedBox(height: 10),
        Text(
          widget.label.toUpperCase(),
          textAlign: TextAlign.left,
          style: AppTextStyle.chip.copyWith(color: AppColors.dark.deactiveDarker),
        ),
        TextField(
          controller: widget.controller,
          autofillHints: [
            if (widget.placeholder == 'Пароль') ...[AutofillHints.password] else if (widget.placeholder == 'Email')
              AutofillHints.email,
          ],
          style: AppTextStyle.title,
          onTap: () {},
          keyboardType: widget.keyboardType,
          obscureText:
              (widget.placeholder == 'Пароль' || widget.placeholder == 'Введите пароль') && _showPassword == false
                  ? true
                  : false,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 20,
            ),
            suffixIcon: widget.placeholder == 'Пароль'
                ? PlatformInkWell(
                    onTap: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                    child: HugeIcon(
                      icon: _showPassword ? HugeIcons.strokeRoundedView : HugeIcons.strokeRoundedViewOff,
                      size: 15,
                      color: AppColors.dark.deactiveDarker,
                    ),
                  )
                : PlatformInkWell(
                    onTap: () {
                      widget.controller.text = '';
                    },
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedCancelCircle,
                      size: 15,
                      color: AppColors.dark.deactiveDarker,
                    ),
                  ),
            hintText: widget.placeholder,
            hintStyle: AppTextStyle.titleM.copyWith(color: AppColors.dark.deactive),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.dark.colorful05),
            ),
            filled: false,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.dark.deactiveDarker),
            ),
            border: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
            ),
          ),
        ),
      ],
    );
  }
}

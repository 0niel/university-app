import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';

class LabelledInput extends StatefulWidget {
  final String label;
  final String placeholder;
  final String? value;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextEditingController controller;
  const LabelledInput(
      {Key? key,
      required this.placeholder,
      required this.keyboardType,
      required this.controller,
      required this.obscureText,
      required this.label,
      this.value})
      : super(key: key);

  @override
  State<LabelledInput> createState() => _LabelledInputState();
}

class _LabelledInputState extends State<LabelledInput> {
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          widget.label.toUpperCase(),
          textAlign: TextAlign.left,
          style: AppTextStyle.chip.copyWith(color: AppTheme.colors.deactiveDarker),
        ),
        TextField(
          controller: widget.controller,
          autofillHints: [
            if (widget.placeholder == "Пароль") ...[AutofillHints.password] else if (widget.placeholder == "Email")
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
              horizontal: 0,
              vertical: 20,
            ),
            suffixIcon: widget.placeholder == "Пароль"
                ? InkWell(
                    onTap: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                    child: Icon(
                      _showPassword ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
                      size: 15.0,
                      color: AppTheme.colors.deactiveDarker,
                    ))
                : InkWell(
                    onTap: () {
                      widget.controller.text = "";
                    },
                    child: Icon(FontAwesomeIcons.solidCircleXmark, size: 15, color: AppTheme.colors.deactiveDarker),
                  ),
            hintText: widget.placeholder,
            hintStyle: AppTextStyle.titleM.copyWith(color: AppTheme.colors.deactive),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppTheme.colors.colorful05),
            ),
            filled: false,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppTheme.colors.deactiveDarker),
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

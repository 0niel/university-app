import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

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
          style: DarkTextTheme.chip
              .copyWith(color: DarkThemeColors.deactiveDarker),
        ),
        TextField(
          controller: widget.controller,
          autofillHints: [
            if (widget.placeholder == "Пароль") ...[
              AutofillHints.password
            ] else if (widget.placeholder == "Email")
              AutofillHints.email,
          ],
          style: DarkTextTheme.title,
          onTap: () {},
          keyboardType: widget.keyboardType,
          obscureText: (widget.placeholder == 'Пароль' ||
                      widget.placeholder == 'Введите пароль') &&
                  _showPassword == false
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
                      _showPassword
                          ? FontAwesomeIcons.eye
                          : FontAwesomeIcons.eyeSlash,
                      size: 15.0,
                      color: DarkThemeColors.deactiveDarker,
                    ))
                : InkWell(
                    onTap: () {
                      widget.controller.text = "";
                    },
                    child: const Icon(FontAwesomeIcons.solidTimesCircle,
                        size: 15, color: DarkThemeColors.deactiveDarker),
                  ),
            hintText: widget.placeholder,
            hintStyle:
                DarkTextTheme.titleM.copyWith(color: DarkThemeColors.deactive),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: DarkThemeColors.colorful05),
            ),
            filled: false,
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: DarkThemeColors.deactiveDarker),
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

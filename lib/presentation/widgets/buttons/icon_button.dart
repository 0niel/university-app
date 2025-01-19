import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';

class SocialIconButton extends StatelessWidget {
  const SocialIconButton({
    super.key,
    required this.icon,
    required this.onClick,
    this.text,
    this.assetPath,
  });

  final Icon icon;
  final Function onClick;
  final String? text;
  final String? assetPath;

  factory SocialIconButton.asset({
    required String assetPath,
    required Function onClick,
    String? text,
  }) =>
      SocialIconButton(
        icon: const Icon(Icons.add),
        onClick: onClick,
        text: text,
        assetPath: assetPath,
      );

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
        shadowColor: WidgetStateProperty.all<Color>(Colors.transparent),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
            side: BorderSide(color: AppTheme.colorsOf(context).deactive, width: 1),
          ),
        ),
      ),
      child: text != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text!,
                  style: AppTextStyle.buttonS.copyWith(color: AppTheme.colorsOf(context).active),
                ),
                const SizedBox(width: 8),
                assetPath != null ? Image.asset(assetPath!, height: 16, width: 16) : icon,
              ],
            )
          : assetPath != null
              ? Image.asset(assetPath!, height: 16, width: 16)
              : icon,
      onPressed: () {
        onClick();
      },
    );
  }
}

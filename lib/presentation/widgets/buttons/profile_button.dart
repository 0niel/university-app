import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({
    Key? key,
    required this.text,
    required this.icon,
    this.onPressed,
    this.trailing,
  }) : super(key: key);

  final String text;
  final Widget icon;
  final VoidCallback? onPressed;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Card(
        margin: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        color: AppTheme.colorsOf(context).background02,
        shadowColor: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween, 
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: icon,
                  ),
                  Text(
                    text,
                    style: AppTextStyle.buttonL,
                  ),
                ],
              ),
              if (trailing != null)
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: trailing,
                ),
            ],
          ),
          onTap: () {
            onPressed?.call();
          },
        ),
      ),
    );
  }
}

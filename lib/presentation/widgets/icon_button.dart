import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';

class SocialIconButton extends StatelessWidget {
  const SocialIconButton(
      {Key? key, required this.assetImage, required this.onClick})
      : super(key: key);
  final AssetImage assetImage;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
          shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
              side: const BorderSide(color: DarkThemeColors.deactive),
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Image(
            image: assetImage,
            height: 16.0,
          ),
        ),
        onPressed: () {
          onClick();
        },
      ),
    );
  }
}

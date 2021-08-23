import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/pages/home/home_navigator_screen.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

/// Get next button to open next page
/// or to close onboarding and start main app
class NextPageViewButton extends StatelessWidget {
  const NextPageViewButton(
      {Key? key, required this.isLastPage, required this.onClick})
      : super(key: key);

  final bool isLastPage;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (isLastPage) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomeNavigatorScreen(isFirstRun: true)),
          );
        } else {
          onClick();
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: isLastPage
            ? const EdgeInsets.symmetric(vertical: 12.0, horizontal: 32.0)
            : const EdgeInsets.symmetric(vertical: 12.0, horizontal: 5),
        child: isLastPage
            ? Text(
                "Начать!",
                style: DarkTextTheme.buttonS,
              )
            : Icon(Icons.arrow_forward_ios, color: DarkThemeColors.white),
      ),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        onPrimary: DarkThemeColors.primary.withOpacity(0.25),
        shadowColor: Color(0x7f000000),
        primary: DarkThemeColors.primary,
        elevation: 8.0,
      ),
    );
  }
}

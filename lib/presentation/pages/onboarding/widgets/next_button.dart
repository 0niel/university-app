import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/pages/home/home_navigator_screen.dart';

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
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      margin: EdgeInsets.symmetric(horizontal: 3.75),
      child: ElevatedButton(
        onPressed: () {
          if (isLastPage) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeNavigatorScreen()),
            );
          } else {
            onClick();
          }
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 150),
          padding: isLastPage
              ? EdgeInsets.symmetric(vertical: 20.0, horizontal: 55.0)
              : EdgeInsets.symmetric(vertical: 20.0, horizontal: 5),
          child: isLastPage
              ? Text(
                  "Начать!",
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: 24.0),
                )
              : Icon(Icons.arrow_forward_ios, color: Colors.black),
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          onPrimary: Colors.black.withOpacity(0.25),
          shadowColor: Colors.black,
          primary: Colors.white,
          elevation: 4.0,
        ),
      ),
    );
  }
}

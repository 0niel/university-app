import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';

class IndicatorPageView extends StatelessWidget {
  const IndicatorPageView({Key? key, required this.isActive}) : super(key: key);

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 3.75),
      height: isActive ? 15.0 : 11.0,
      width: isActive ? 15.0 : 11.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : DarkThemeColors.active,
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        boxShadow: <BoxShadow>[
          isActive
              ? BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  offset: Offset(0.0, 2.0),
                  blurRadius: 4.0,
                )
              : BoxShadow(color: Colors.transparent),
        ],
      ),
    );
  }
}

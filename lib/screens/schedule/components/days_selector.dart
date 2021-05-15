import 'package:flutter/material.dart';
import '../../../constants.dart';

class DaySelectorTabBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.symmetric(
              horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "ПН\n",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFBCC1CD),
                    fontSize: 18,
                  ),
                ),
                TextSpan(
                  text: "21",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 19,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
        ),
      ],
    );
  }
}

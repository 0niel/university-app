import 'package:flutter/material.dart';

class LessonsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      SizedBox(height: 30),
      RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "09:00\n",
              style: TextStyle(
                color: Color(0xFF212525),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: "10:30",
              style: TextStyle(color: Color(0xFFBCC1CD), fontSize: 16),
            ),
          ],
        ),
      ),
      SizedBox(
        height: 80,
        child: VerticalDivider(
          color: Color(0xFFFAF9F9),
          thickness: 2,
          width: 50,
        ),
      ),
      RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Математический анализ\n",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            TextSpan(
              text: "Практика в А-249",
              style: TextStyle(
                color: Colors.black.withOpacity(0.5),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}

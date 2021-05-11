import 'package:flutter/material.dart';

class Lessons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
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
          width: 20,
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Практика в А-249\n",
                style: TextStyle(
                  color: Colors.black.withOpacity(0.5),
                  fontSize: 18,
                ),
              ),
              TextSpan(
                text: "Математический анализ",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

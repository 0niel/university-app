import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';

class HolidayPage extends StatelessWidget {
  const HolidayPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Image(
          image: AssetImage('assets/images/Saly-18.png'),
          height: 225.0,
        ),
        Text(title, style: AppTextStyle.title),
        const SizedBox(
          height: 8,
        ),
        Text(
          "Пар в этот день нет!",
          style: AppTextStyle.bodyL,
        ),
      ],
    );
  }
}

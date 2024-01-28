import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

class AttendanceCard extends StatelessWidget {
  const AttendanceCard({Key? key, required this.type, required this.date, required this.time}) : super(key: key);

  final String type;
  final String date;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.colorsOf(context).background02,
      child: Container(
        width: double.infinity,
        height: 80,
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.colorsOf(context).background03,
              ),
              alignment: Alignment.center,
              child: Container(
                width: 24,
                height: 24,
                decoration: type == "Вход"
                    ? const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xff99db7e), Color(0xff6da95b)],
                        ),
                      )
                    : BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.colorsOf(context).colorful02,
                      ),
                alignment: Alignment.center,
                child: type == "Вход"
                    ? const Icon(FontAwesomeIcons.rightToBracket, size: 15)
                    : const Icon(FontAwesomeIcons.rightFromBracket, size: 15),
              ),
            ),
            const SizedBox(width: 55.50),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: AppTextStyle.bodyBold,
                ),
                Text(
                  '$date, $time',
                  style: AppTextStyle.captionL.copyWith(
                      color: type == "Вход"
                          ? AppTheme.colorsOf(context).colorful05
                          : AppTheme.colorsOf(context).colorful02),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

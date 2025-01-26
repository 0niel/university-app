import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:app_ui/app_ui.dart';

class AttendanceCard extends StatelessWidget {
  const AttendanceCard({super.key, required this.type, required this.date, required this.time});

  final String type;
  final String date;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).extension<AppColors>()!.background02,
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
                color: Theme.of(context).extension<AppColors>()!.background03,
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
                        color: Theme.of(context).extension<AppColors>()!.colorful02,
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
                          ? Theme.of(context).extension<AppColors>()!.colorful05
                          : Theme.of(context).extension<AppColors>()!.colorful02),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

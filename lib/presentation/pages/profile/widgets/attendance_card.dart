import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

class AttendanceCard extends StatelessWidget {
  const AttendanceCard(
      {Key? key, required this.type, required this.date, required this.time})
      : super(key: key);

  final String type;
  final String date;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: DarkThemeColors.background02,
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: DarkThemeColors.background03,
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
                  : const BoxDecoration(
                      shape: BoxShape.circle,
                      color: DarkThemeColors.colorful02,
                    ),
              alignment: Alignment.center,
              child: type == "Вход"
                  ? const Icon(FontAwesomeIcons.signInAlt, size: 15)
                  : const Icon(FontAwesomeIcons.signOutAlt, size: 15),
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
                style: DarkTextTheme.bodyBold,
              ),
              Text(
                date + ', ' + time,
                style: DarkTextTheme.captionL.copyWith(
                    color: type == "Вход"
                        ? DarkThemeColors.colorful05
                        : DarkThemeColors.colorful02),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

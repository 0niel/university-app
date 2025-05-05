import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';
import 'package:rtu_mirea_app/profile/widgets/widgets.dart';

class ScheduleSectionWrapper extends StatelessWidget {
  final String title;
  final ScheduleManagementSection scheduleSection;

  const ScheduleSectionWrapper({super.key, required this.title, required this.scheduleSection});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: AppTextStyle.bodyL.copyWith(
              color: Theme.of(context).extension<AppColors>()!.deactive,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        scheduleSection,
      ],
    );
  }
}

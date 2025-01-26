import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:app_ui/app_ui.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';
import 'package:university_app_server_api/client.dart';

class StickyHeader extends StatelessWidget {
  const StickyHeader({
    super.key,
    required this.day,
    required this.lessons,
  });

  final DateTime day;
  final List<LessonSchedulePart> lessons;

  @override
  Widget build(BuildContext context) {
    return SliverStickyHeader(
      header: Container(
        color: Theme.of(context).extension<AppColors>()!.background01,
        padding: const EdgeInsets.only(left: 22.0, bottom: 8.0, top: 16.0),
        alignment: Alignment.centerLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              HugeIcons.strokeRoundedCalendar04,
              size: 17.5,
            ),
            const SizedBox(width: 8),
            Text(
              DateFormat('EEEE, d MMMM', 'ru').format(day),
              style: AppTextStyle.bodyBold,
            ),
          ],
        ),
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final lessonPart = lessons[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: LessonCard(
                lesson: lessonPart,
                onTap: (lesson) {
                  context.go('/schedule/details', extra: (lesson, day));
                },
              ),
            );
          },
          childCount: lessons.length,
        ),
      ),
    );
  }
}

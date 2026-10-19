import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/home/view/home_day_lessons.dart';
import 'package:rtu_mirea_app/home/view/widgets/hero/hero_lesson_layout.dart';
import 'package:rtu_mirea_app/home/view/widgets/hero/hero_parts.dart';
import 'package:rtu_mirea_app/home/view/widgets/hero/home_hero_surface.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class HeroOther extends StatelessWidget {
  const HeroOther({
    required this.entry,
    required this.meta,
    required this.onOpen,
    super.key,
  });
  final HomeLessonEntry entry;
  final String meta;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) => HomeHeroSurface(
    onTap: onOpen,
    child: HeroLessonLayout(
      start: DateFormat.Hm().format(entry.start),
      end: DateFormat.Hm().format(entry.end),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.homeHeroFirstLesson,
            style: AppText.micro.copyWith(color: context.colors.muted),
          ),
          const SizedBox(height: 4),
          HeroSubject(
            subject: entry.lesson.subject,
            meta: meta,
            size: 18,
            height: 1.2,
          ),
        ],
      ),
    ),
  );
}

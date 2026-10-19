import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/home/view/home_day_lessons.dart';
import 'package:rtu_mirea_app/home/view/widgets/hero/hero_lesson_layout.dart';
import 'package:rtu_mirea_app/home/view/widgets/hero/hero_parts.dart';
import 'package:rtu_mirea_app/home/view/widgets/hero/home_hero_surface.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class HeroDuring extends StatelessWidget {
  const HeroDuring({
    required this.entry,
    required this.meta,
    required this.now,
    required this.onOpen,
    required this.onRoute,
    required this.onNote,
    super.key,
  });
  final HomeLessonEntry entry;
  final String meta;
  final DateTime now;
  final VoidCallback onOpen;
  final VoidCallback? onRoute;
  final VoidCallback onNote;

  @override
  Widget build(BuildContext context) {
    final format = DateFormat.Hm();
    final duration = entry.end.difference(entry.start).inSeconds;
    final progress = duration <= 0
        ? 0.0
        : (now.difference(entry.start).inSeconds / duration).clamp(0.0, 1.0);
    return HomeHeroSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HeroLessonHeader(
            status: HeroPill(
              label: context.l10n.homeHeroNow,
              leading: const AppPulseDot(size: 8),
            ),
            detail: context.l10n.minutesLeft(homeMinutesUntil(entry.end, now)),
            onRoute: onRoute,
            onNote: onNote,
          ),
          const SizedBox(height: 8),
          HeroLessonLayout(
            start: format.format(entry.start),
            end: format.format(entry.end),
            child: HeroSubject(
              subject: entry.lesson.subject,
              meta: meta,
              size: 18,
              height: 1.2,
              onTap: onOpen,
            ),
          ),
          const SizedBox(height: 8),
          AppProgressBar(value: progress, trackColor: context.colors.surface),
        ],
      ),
    );
  }
}

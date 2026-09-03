import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/home/view/home_day_lessons.dart';
import 'package:rtu_mirea_app/home/view/widgets/hero/hero_parts.dart';
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
    return AppCard(
      tinted: true,
      radius: AppRadius.hero,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              HeroPill(
                label: context.l10n.homeHeroNow,
                leading: const AppPulseDot(size: 8),
              ),
              HeroMeta(
                context.l10n.minutesLeft(homeMinutesUntil(entry.end, now)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeroTimeColumn(
                start: format.format(entry.start),
                end: format.format(entry.end),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: HeroSubject(
                  subject: entry.lesson.subject,
                  meta: meta,
                  size: 21,
                  height: 1.2,
                  onTap: onOpen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AppProgressBar(value: progress, trackColor: context.colors.surface),
          const SizedBox(height: 12),
          HeroActions(onRoute: onRoute, onNote: onNote),
        ],
      ),
    );
  }
}

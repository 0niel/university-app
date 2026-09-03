import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/home/view/home_day_lessons.dart';
import 'package:rtu_mirea_app/home/view/widgets/hero/hero_parts.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class HeroBefore extends StatelessWidget {
  const HeroBefore({
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
    final l10n = context.l10n;
    final format = DateFormat.Hm();
    return AppCard(
      tinted: true,
      radius: AppRadius.hero,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: .stretch,
        mainAxisSize: .min,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              HeroPill(
                label: l10n.homeHeroFirstIn(
                  homeMinutesUntil(entry.start, now),
                ),
              ),
              HeroMeta(
                '${format.format(entry.start)}–${format.format(entry.end)}',
              ),
            ],
          ),
          const SizedBox(height: 14),
          HeroSubject(subject: entry.lesson.subject, meta: meta, onTap: onOpen),
          const SizedBox(height: 14),
          HeroActions(onRoute: onRoute, onNote: onNote),
        ],
      ),
    );
  }
}

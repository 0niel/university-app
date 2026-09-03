import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/home/view/home_day_lessons.dart';
import 'package:rtu_mirea_app/home/view/widgets/hero/hero_parts.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class HeroPause extends StatelessWidget {
  const HeroPause({
    required this.entry,
    required this.meta,
    required this.now,
    required this.onOpen,
    required this.onFreeRooms,
    super.key,
  });
  final HomeLessonEntry entry;
  final String meta;
  final DateTime now;
  final VoidCallback onOpen;
  final VoidCallback onFreeRooms;

  @override
  Widget build(BuildContext context) => AppCard(
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
              label: context.l10n.homeHeroBreak(
                homeMinutesUntil(entry.start, now),
              ),
              background: context.colors.lectureTint,
              foreground: context.colors.lecture,
            ),
            HeroMeta(
              context.l10n.homeStatusNext(DateFormat.Hm().format(entry.start)),
            ),
          ],
        ),
        const SizedBox(height: 14),
        HeroSubject(subject: entry.lesson.subject, meta: meta, onTap: onOpen),
        const SizedBox(height: 14),
        AppListGroup(
          radius: AppRadius.field,
          color: context.colors.canvas,
          children: [
            AppListRow(
              title: context.l10n.freeClassrooms,
              subtitle: context.l10n.homeFreeRoomsSub,
              strong: true,
              leading: AppIconTile(
                icon: AppLineIcon.door,
                background: context.colors.lectureTint,
                foreground: context.colors.lecture,
              ),
              onTap: onFreeRooms,
            ),
          ],
        ),
      ],
    ),
  );
}

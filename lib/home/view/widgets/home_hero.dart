import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/home/view/home_day_lessons.dart';
import 'package:rtu_mirea_app/home/view/home_labels.dart';
import 'package:rtu_mirea_app/home/view/widgets/hero/hero.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/tour/tour.dart';
import 'package:schedule_repository/schedule_repository.dart';

class HomeHero extends StatelessWidget {
  const HomeHero({
    required this.entries,
    required this.kind,
    required this.tomorrow,
    required this.now,
    required this.onOpen,
    required this.onRoute,
    required this.onNote,
    required this.onFreeRooms,
    required this.onDeadlines,
    required this.onTomorrow,
    this.deadline,
    super.key,
  });
  final List<HomeLessonEntry> entries;
  final HomeHeroKind kind;
  final List<LessonSchedulePart> tomorrow;
  final DateTime now;
  final Deadline? deadline;
  final ValueChanged<HomeLessonEntry> onOpen;
  final ValueChanged<HomeLessonEntry>? onRoute;
  final ValueChanged<HomeLessonEntry> onNote;
  final VoidCallback onFreeRooms;
  final VoidCallback onDeadlines;
  final VoidCallback onTomorrow;

  @override
  Widget build(BuildContext context) => AppTourAnchor(
    target: .homeBoard,
    child: _content(context),
  );

  Widget _content(BuildContext context) {
    final entry = homeHeroEntry(entries, kind);
    final l10n = context.l10n;
    if (kind == HomeHeroKind.free || entry == null) return const HeroFree();
    final meta = homeLessonMeta(l10n, entry);
    void open() => onOpen(entry);
    void note() => onNote(entry);
    final route = onRoute == null ? null : () => onRoute!(entry);
    final firstTomorrow = tomorrow.firstOrNull;
    final tomorrowLabel = firstTomorrow == null
        ? l10n.homeHeroTomorrowFree
        : l10n.homeHeroTomorrow(
            l10n.lessonsCount(tomorrow.length),
            '${firstTomorrow.lessonBells.startTime}',
          );
    return switch (kind) {
      HomeHeroKind.before => HeroBefore(
        entry: entry,
        meta: meta,
        now: now,
        onOpen: open,
        onRoute: route,
        onNote: note,
      ),
      HomeHeroKind.during => HeroDuring(
        entry: entry,
        meta: meta,
        now: now,
        onOpen: open,
        onRoute: route,
        onNote: note,
      ),
      HomeHeroKind.pause => HeroPause(
        entry: entry,
        meta: meta,
        now: now,
        onOpen: open,
        onFreeRooms: onFreeRooms,
      ),
      HomeHeroKind.other => HeroOther(entry: entry, meta: meta, onOpen: open),
      HomeHeroKind.done => HeroDone(
        tomorrowLabel: tomorrowLabel,
        deadlineLabel: deadline == null
            ? l10n.homeHeroDeadlineNone
            : l10n.homeHeroDeadlineChip(homeDeadlineLeft(l10n, deadline!, now)),
        onDeadlines: onDeadlines,
        onTomorrow: onTomorrow,
      ),
      HomeHeroKind.free => const HeroFree(),
    };
  }
}

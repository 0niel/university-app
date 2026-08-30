import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';
import 'package:rtu_mirea_app/services/view/services_now_card.dart';
import 'package:rtu_mirea_app/services/view/services_section_label.dart';
import 'package:schedule_repository/schedule_repository.dart';

class ServicesNowSection extends StatefulWidget {
  const ServicesNowSection({super.key});

  @override
  State<ServicesNowSection> createState() => _ServicesNowSectionState();
}

class _ServicesNowSectionState extends State<ServicesNowSection> {
  int? _shurikens;

  @override
  void initState() {
    super.initState();
    unawaited(_loadBalance());
  }

  Future<void> _loadBalance() async {
    try {
      final profile = await context.read<GamificationRepository>().getProfile();
      if (mounted) setState(() => _shurikens = profile.shurikens);
    } on Exception {
      _shurikens = null;
    }
  }

  int? _examDays(List<SchedulePart> schedule) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    DateTime? nearest;
    for (final lesson in schedule.whereType<LessonSchedulePart>()) {
      if (lesson.lessonType != .exam && lesson.lessonType != .credit) {
        continue;
      }
      for (final date in lesson.dates) {
        if (!date.isBefore(today) &&
            (nearest == null || date.isBefore(nearest))) {
          nearest = date;
        }
      }
    }
    return nearest?.difference(today).inDays;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final schedule = context.select<ScheduleBloc, List<SchedulePart>>(
      (bloc) => bloc.state.selectedSchedule?.schedule ?? const [],
    );
    final examDays = _examDays(schedule);
    final cards = <ServicesNowCard>[
      if (examDays != null)
        ServicesNowCard(
          icon: AppLineIcon.calendar,
          title: l10n.sessionTitle,
          subtitle: examDays == 0
              ? l10n.servicesNowSessionToday
              : l10n.servicesNowSessionInDays(examDays),
          cta: l10n.open,
          onTap: () => Navigator.of(
            context,
          ).push(MaterialPageRoute<void>(builder: (_) => const SessionPage())),
        ),
      if (_shurikens case final value?)
        ServicesNowCard(
          icon: AppLineIcon.card,
          title: l10n.walletTitle,
          subtitle: l10n.servicesNowShurikens(value),
          cta: l10n.open,
          onTap: () => context.go('/services/wallet'),
        ),
    ];
    if (cards.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: .start,
      children: [
        ServicesSectionLabel(
          title: l10n.servicesNowTitle,
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final textScale = MediaQuery.textScalerOf(context).scale(1);
            final height = (126 + (textScale - 1).clamp(0, 1) * 74).toDouble();
            final width = (constraints.maxWidth - 52)
                .clamp(220, 310)
                .toDouble();
            return SizedBox(
              height: height,
              child: ListView.separated(
                scrollDirection: .horizontal,
                padding: const .symmetric(
                  horizontal: NinjaMetrics.screenPadding,
                ),
                itemCount: cards.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final card = cards[index];
                  return ServicesNowCard(
                    icon: card.icon,
                    title: card.title,
                    subtitle: card.subtitle,
                    cta: card.cta,
                    onTap: card.onTap,
                    width: width,
                    featured: index == 0,
                  );
                },
              ),
            );
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

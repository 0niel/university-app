import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_text.dart';
import 'package:schedule_repository/schedule_repository.dart';

class LessonFactsStrip extends StatelessWidget {
  const LessonFactsStrip({required this.lesson, super.key});

  final LessonSchedulePart lesson;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.ninja;
    final teachers = lesson.teachers.map((teacher) => teacher.name).join(', ');
    final facts = [
      (
        icon: AppLineIcon.door,
        label: l10n.classroom,
        value: singleClassroomText(l10n, lesson),
      ),
      if (teachers.isNotEmpty)
        (icon: AppLineIcon.user, label: l10n.teacher, value: teachers),
    ];

    return Padding(
      padding: const .fromLTRB(
        NinjaMetrics.screenPadding,
        10,
        NinjaMetrics.screenPadding,
        12,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final largeText = MediaQuery.textScalerOf(context).scale(1) >= 1.5;
          final itemWidth = largeText || facts.length == 1
              ? constraints.maxWidth
              : (constraints.maxWidth - 8) / facts.length;
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final fact in facts)
                SizedBox(
                  width: itemWidth,
                  child: AppSmartChip.icon(
                    icon: AppLineIconWidget(
                      fact.icon,
                      size: 20,
                      color: colors.brand,
                    ),
                    label: fact.label,
                    value: fact.value,
                    tone: colors.brand,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

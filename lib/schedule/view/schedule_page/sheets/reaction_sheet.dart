import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/sheets/widgets/schedule_sheet_widgets.dart';
import 'package:schedule_repository/schedule_repository.dart';

Future<void> showReactionSheet(
  BuildContext context, {
  required LessonSchedulePart lesson,
  required DateTime day,
}) {
  final l10n = context.l10n;
  final labels = {
    ReactionType.fire: l10n.reactionFire,
    ReactionType.brain: l10n.reactionBrain,
    ReactionType.love: l10n.reactionLove,
    ReactionType.sad: l10n.reactionSad,
    ReactionType.flushed: l10n.reactionFlushed,
    ReactionType.sick: l10n.reactionSick,
    ReactionType.poo: l10n.reactionPoo,
    ReactionType.thinking: l10n.reactionThinking,
    ReactionType.sleepy: l10n.reactionSleepy,
    ReactionType.skull: l10n.reactionSkull,
    ReactionType.mindblown: l10n.reactionMindblown,
    ReactionType.respect: l10n.reactionRespect,
  };
  ReactionType? picked = .fire;
  var anonymous = true;

  final teacher = lesson.teachers.firstOrNull?.name;

  return showAppSheet<void>(
    context,
    title: l10n.reactionSheetTitle,
    subtitle: '${lesson.subject}${teacher == null ? '' : ' · $teacher'}',
    backgroundColor: context.ninja.canvas,
    child: StatefulBuilder(
      builder: (context, setState) {
        final colors = context.ninja;
        return Padding(
          padding: const .fromLTRB(0, 4, 0, 24),
          child: Column(
            mainAxisSize: .min,
            children: [
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.86,
                children: [
                  for (final type in ReactionType.values)
                    AppPressable(
                      onTap: () => setState(() => picked = type),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: picked == type
                              ? colors.brand
                              : colors.surfaceAlt,
                          borderRadius: .circular(NinjaRadius.control),
                        ),
                        child: Column(
                          mainAxisAlignment: .center,
                          children: [
                            Text(
                              type.emoji,
                              style: const TextStyle(fontSize: 26),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              labels[type] ?? '',
                              maxLines: 1,
                              overflow: .ellipsis,
                              style: NinjaText.badge.copyWith(
                                letterSpacing: 0,
                                color: picked == type
                                    ? colors.onBrand
                                    : colors.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              ScheduleSheetToggleRow(
                title: l10n.anonymously,
                subtitle: l10n.anonymouslySub,
                value: anonymous,
                first: true,
                onChanged: (value) => setState(() => anonymous = value),
              ),
              const SizedBox(height: 16),
              NinjaButton.primary(
                label: l10n.reactionSend,
                expanded: true,
                size: .large,
                onPressed: picked == null
                    ? null
                    : () {
                        final reaction = picked;
                        if (reaction == null) return;
                        unawaited(
                          context.read<LessonReactionsCubit>().addReaction(
                            subjectName: lesson.subject,
                            lessonDate: day,
                            lessonBells: lesson.lessonBells,
                            reactionType: reaction,
                          ),
                        );
                        Navigator.of(context).pop();
                        showNinjaToast(
                          context,
                          message: l10n.reactionSent(reaction.emoji),
                        );
                      },
              ),
            ],
          ),
        );
      },
    ),
  );
}

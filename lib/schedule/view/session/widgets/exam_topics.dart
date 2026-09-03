import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/view/session/exam_topics_cubit.dart';
import 'package:rtu_mirea_app/schedule/view/session/session_exam.dart';

class ExamTopics extends StatelessWidget {
  const ExamTopics({
    required this.exam,
    required this.cubit,
    required this.onChanged,
    super.key,
  });

  final SessionExam exam;
  final ExamTopicsCubit cubit;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final topics = cubit.state.forExam(exam.key);
    final plan = cubit.state.plan(exam.key);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSectionTitle(
          title: l10n.examsTopicsTitle,
          meta: l10n.examsTopicsHint,
          topMargin: AppSpacing.xlg,
        ),
        if (topics.isEmpty)
          AppEmptyState.compact(title: l10n.examsTopicsEmpty)
        else
          AppListGroup(
            children: [
              for (final (index, topic) in topics.indexed)
                Semantics(
                  customSemanticsActions: {
                    CustomSemanticsAction(label: l10n.examsRemoveTopic): () =>
                        _removeTopic(context, index, topic.title),
                  },
                  child: AppPressable(
                    semanticsLabel: topic.title,
                    semanticsToggled: topic.done,
                    onTap: () {
                      cubit.toggle(exam.key, index);
                      onChanged();
                    },
                    onLongPress: () =>
                        _removeTopic(context, index, topic.title),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.gap,
                        AppSpacing.md,
                        AppSpacing.lg,
                        AppSpacing.md,
                      ),
                      child: Row(
                        children: [
                          AppDeadlineCheck(done: topic.done),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Text(
                              topic.title,
                              style: AppText.cell.copyWith(
                                color: topic.done
                                    ? context.colors.muted2
                                    : context.colors.ink,
                                decoration: topic.done
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        AppSectionTitle(
          title: l10n.examsPlanTitle,
          action: l10n.examsPlanRebuild,
          topMargin: AppSpacing.xlg,
          onActionTap: plan.isEmpty ? null : () => cubit.rebuild(exam.key),
        ),
        if (plan.isEmpty)
          AppEmptyState.compact(
            title: topics.isEmpty ? l10n.examsTopicsEmpty : l10n.examsPlanEmpty,
          )
        else
          AppListGroup(
            children: [
              for (final (index, topic) in plan.indexed)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: 13,
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: AppControlSize.buttonHero,
                        child: Text(
                          DateFormat.MMMd(
                            Localizations.localeOf(context).toString(),
                          ).format(
                            DateTime.now().add(
                              Duration(
                                days: exam.days <= 1
                                    ? 0
                                    : index * exam.days ~/ plan.length,
                              ),
                            ),
                          ),
                          style: AppText.sans(12, FontWeight.w700).copyWith(
                            color: context.colors.muted,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          topic.title,
                          style: AppText.cell.copyWith(
                            color: context.colors.ink,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Text(
                        l10n.examsPlanMinutes(30),
                        style: AppText.sans(
                          12,
                          FontWeight.w700,
                        ).copyWith(color: context.colors.accent),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        const SizedBox(height: AppSpacing.md),
        AppButton.tonal(
          label: l10n.examsAddTopic,
          icon: const AppLineIconWidget(AppLineIcon.plus),
          onPressed: () => unawaited(
            showAppSheet<void>(
              context,
              title: l10n.examsAddTopic,
              child: _AddTopic(
                cubit: cubit,
                examKey: exam.key,
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _removeTopic(BuildContext context, int index, String title) => unawaited(
    showAppSheet<void>(
      context,
      title: context.l10n.examsRemoveTopic,
      subtitle: title,
      child: Builder(
        builder: (sheetContext) => AppButton.danger(
          label: context.l10n.examsRemoveTopic,
          expanded: true,
          onPressed: () {
            cubit.remove(exam.key, index);
            onChanged();
            Navigator.of(sheetContext).pop();
          },
        ),
      ),
    ),
  );
}

class _AddTopic extends StatefulWidget {
  const _AddTopic({
    required this.cubit,
    required this.examKey,
    required this.onChanged,
  });

  final ExamTopicsCubit cubit;
  final String examKey;
  final VoidCallback onChanged;

  @override
  State<_AddTopic> createState() => _AddTopicState();
}

class _AddTopicState extends State<_AddTopic> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      AppInputField(
        controller: controller,
        placeholder: context.l10n.examsTopicHint,
        autofocus: true,
        maxLength: 150,
        onChanged: (_) => setState(() {}),
      ),
      const SizedBox(height: AppSpacing.sectionGap),
      AppButton.primary(
        label: context.l10n.add,
        expanded: true,
        onPressed: controller.text.trim().isEmpty
            ? null
            : () {
                if (widget.cubit.addTopic(widget.examKey, controller.text)) {
                  widget.onChanged();
                  Navigator.of(context).pop();
                }
              },
      ),
    ],
  );
}

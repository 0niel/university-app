import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/tools/cubit/tools_cubit.dart';
import 'package:rtu_mirea_app/tools/view/widgets/tools_number_sheet.dart';

class ToolsGrantPanel extends StatelessWidget {
  const ToolsGrantPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ToolsCubit>().state;
    final l10n = context.l10n;
    final labels = {
      'base': l10n.toolsGrantBase,
      'study': l10n.toolsGrantStudy,
      'science': l10n.toolsGrantScience,
      'social': l10n.toolsGrantSocial,
    };
    return Column(
      children: [
        AppListGroup(
          children: [
            for (final entry in labels.entries)
              AppPressable(
                semanticsButton: true,
                onTap: () => showToolsNumberSheet(
                  context,
                  title: entry.value,
                  value: state.grants[entry.key] ?? 0,
                  max: 1000000,
                  onSave: (value) =>
                      context.read<ToolsCubit>().setGrant(entry.key, value),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sectionGap,
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) => Row(
                      children: [
                        Expanded(
                          child: Text(
                            entry.value,
                            style: AppText.cell.copyWith(
                              height: 18 / 14.5,
                              color: context.colors.ink,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: constraints.maxWidth * .45,
                          ),
                          child: Text(
                            state.grants[entry.key] == null
                                ? l10n.toolsNoValue
                                : l10n.toolsRubles(
                                    '${state.grants[entry.key]}',
                                  ),
                            textAlign: TextAlign.end,
                            style: AppText.cell.copyWith(
                              height: 18 / 14.5,
                              color: context.colors.ink,
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
        const SizedBox(height: AppSpacing.sm),
        AppCard(
          tinted: true,
          radius: AppRadius.row,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sectionGap,
          ),
          child: Text(
            l10n.toolsLocalEstimate,
            style: AppText.sans(
              13.5,
              FontWeight.w400,
              height: 1.45,
            ).copyWith(color: context.colors.ink),
          ),
        ),
      ],
    );
  }
}

class ToolsCreditsPanel extends StatelessWidget {
  const ToolsCreditsPanel({required this.subjects, super.key});

  final List<String> subjects;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ToolsCubit>().state;
    final l10n = context.l10n;
    final colors = context.colors;
    final earned = subjects.fold(
      0,
      (sum, subject) => sum + (state.credits[subject] ?? 0),
    );
    final tones = [colors.lecture, colors.practice, colors.lab, colors.exam];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LayoutBuilder(
                builder: (context, constraints) => Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.toolsEctsEarned,
                        style: AppText.sans(
                          14,
                          FontWeight.w600,
                        ).copyWith(color: colors.ink),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: constraints.maxWidth / 2,
                      ),
                      child: Text(
                        l10n.toolsEctsValue(earned, state.creditTarget),
                        textAlign: TextAlign.end,
                        style: AppText.sans(
                          14,
                          FontWeight.w600,
                        ).copyWith(color: colors.ink),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.gap),
              AppProgressBar(
                value: (earned / state.creditTarget).clamp(0, 1),
                height: 8,
              ),
              if (earned > 0) ...[
                const SizedBox(height: AppSpacing.sectionGap),
                Row(
                  children: [
                    for (final (index, subject) in subjects.indexed)
                      if ((state.credits[subject] ?? 0) > 0)
                        Expanded(
                          flex: state.credits[subject]!,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 3),
                            child: AppProgressBar(
                              value: 1,
                              color: tones[index % tones.length],
                            ),
                          ),
                        ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: 12,
                  runSpacing: 6,
                  children: [
                    for (final subject in subjects)
                      if ((state.credits[subject] ?? 0) > 0)
                        Text(
                          '${state.credits[subject]} $subject',
                          style: AppText.sans(
                            11.5,
                            FontWeight.w600,
                          ).copyWith(color: colors.muted),
                        ),
                  ],
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppListGroup(
          children: [
            AppListRow(
              title: l10n.toolsEctsTarget,
              meta: '${state.creditTarget}',
              onTap: () => showToolsNumberSheet(
                context,
                title: l10n.toolsEctsTarget,
                value: state.creditTarget,
                min: 1,
                max: 600,
                onSave: context.read<ToolsCubit>().setCreditTarget,
              ),
            ),
            for (final subject in subjects)
              AppListRow(
                title: subject,
                meta: '${state.credits[subject] ?? 0}',
                onTap: () => showToolsNumberSheet(
                  context,
                  title: subject,
                  value: state.credits[subject] ?? 0,
                  max: 120,
                  onSave: (value) =>
                      context.read<ToolsCubit>().setCredits(subject, value),
                ),
              ),
          ],
        ),
        if (subjects.isEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          AppEmptyState(
            title: l10n.toolsMarksEmpty,
            lineIcon: AppLineIcon.book,
          ),
        ],
      ],
    );
  }
}

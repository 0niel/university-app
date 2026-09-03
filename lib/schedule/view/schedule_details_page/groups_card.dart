part of '../schedule_details_page.dart';

class _GroupsCard extends StatefulWidget {
  const _GroupsCard({required this.lesson});

  final LessonSchedulePart lesson;

  @override
  State<_GroupsCard> createState() => _GroupsCardState();
}

class _GroupsCardState extends State<_GroupsCard> {
  static const _collapsedLimit = 12;
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final names =
        widget.lesson.groupEntities?.map((group) => group.name).toList() ??
        widget.lesson.groups ??
        const <String>[];
    if (names.isEmpty) return const SizedBox.shrink();
    final shown = _expanded ? names : names.take(_collapsedLimit).toList();
    final hidden = names.length - shown.length;

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        _SectionTitle(
          title: context.l10n.lessonDetailsGroupsTitle,
          action: '${names.length}',
        ),
        Padding(
          padding: const .fromLTRB(
            AppSpacing.screen,
            AppSpacing.zero,
            AppSpacing.screen,
            AppSpacing.lg,
          ),
          child: Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final name in shown)
                AppChip(
                  label: name,
                  onTap: () => openGlobalSearch(context, query: name),
                ),
              if (hidden > 0)
                AppChip(
                  label: context.l10n.lessonDetailsGroupsMore(hidden),
                  onTap: () => setState(() => _expanded = true),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

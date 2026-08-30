part of 'knowledge_bank_view.dart';

class _KnowledgeFilters extends StatelessWidget {
  const _KnowledgeFilters({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final filters = [
      ('all', l10n.knowledgeChipAll),
      ('note', l10n.knowledgeChipNotes),
      ('exam', l10n.knowledgeChipTickets),
      ('task', l10n.knowledgeChipSolutions),
      ('cheat', l10n.knowledgeChipCheats),
    ];
    return NinjaChipRow(
      children: [
        for (final filter in filters)
          NinjaChip(
            label: filter.$2,
            selected: filter.$1 == value,
            onTap: () => onChanged(filter.$1),
          ),
      ],
    );
  }
}

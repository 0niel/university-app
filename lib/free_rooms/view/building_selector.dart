part of 'free_rooms_view.dart';

class _BuildingSelector extends StatelessWidget {
  const _BuildingSelector({
    required this.buildings,
    required this.value,
    required this.onChanged,
  });

  final List<String> buildings;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final choices = [
      ('all', l10n.freeRoomsAllBuildings),
      for (final building in buildings) (building, building),
    ];
    return Padding(
      padding: const .only(bottom: 18),
      child: NinjaChipRow(
        children: [
          for (final choice in choices)
            NinjaChip(
              label: choice.$2,
              selected: choice.$1 == value,
              onTap: () => onChanged(choice.$1),
            ),
        ],
      ),
    );
  }
}

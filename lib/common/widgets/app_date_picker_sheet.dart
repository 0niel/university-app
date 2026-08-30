part of 'app_date_picker.dart';

class AppDatePickerSheet extends StatefulWidget {
  const AppDatePickerSheet({
    required this.initial,
    required this.firstDate,
    required this.lastDate,
    required this.quickChips,
    this.dateEnabledBuilder,
    super.key,
  });

  final DateTime initial;
  final DateTime firstDate;
  final DateTime lastDate;
  final List<DateQuickChip> quickChips;
  final bool Function(DateTime)? dateEnabledBuilder;

  @override
  State<AppDatePickerSheet> createState() => _AppDatePickerSheetState();
}

class _AppDatePickerSheetState extends State<AppDatePickerSheet> {
  late DateTime _selected = widget.initial;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      spacing: 12,
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      children: [
        if (widget.quickChips.isNotEmpty)
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: .horizontal,
              padding: const .symmetric(horizontal: 20),
              itemCount: widget.quickChips.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final chip = widget.quickChips[index];
                return AppDatePickerQuickChip(
                  label: chip.label,
                  selected: _sameDay(chip.date, _selected),
                  onTap: () => Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pop(chip.date),
                );
              },
            ),
          ),
        Padding(
          padding: const .symmetric(horizontal: 20),
          child: Column(
            spacing: 16,
            mainAxisSize: .min,
            crossAxisAlignment: .stretch,
            children: [
              AppFlatCalendar(
                firstDay: widget.firstDate,
                lastDay: widget.lastDate,
                initialFocus: _selected,
                dateSelectedBuilder: (day) => _sameDay(day, _selected),
                dateEnabledBuilder: widget.dateEnabledBuilder,
                onDateSelected: (day) => setState(() => _selected = day),
              ),
              NinjaButton.primary(
                label: l10n.done,
                expanded: true,
                onPressed: () => Navigator.of(
                  context,
                  rootNavigator: true,
                ).pop(_selected),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

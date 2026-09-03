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

  void _pop(DateTime value) =>
      Navigator.of(context, rootNavigator: true).pop(value);

  int get _quickIndex => widget.quickChips.indexWhere(
    (chip) => _sameDay(chip.date, _selected),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      children: [
        if (widget.quickChips.isNotEmpty) ...[
          AppChipRow<int>(
            padding: const .symmetric(horizontal: AppSpacing.screen),
            value: _quickIndex,
            items: [
              for (final (index, chip) in widget.quickChips.indexed)
                AppChipRowItem(value: index, label: chip.label),
            ],
            onChanged: (index) => _pop(widget.quickChips[index].date),
          ),
          const SizedBox(height: 14),
        ],
        Padding(
          padding: const .symmetric(horizontal: AppSpacing.screen),
          child: Column(
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
              const SizedBox(height: 14),
              AppSheetAction(label: l10n.done, onTap: () => _pop(_selected)),
            ],
          ),
        ),
      ],
    );
  }
}

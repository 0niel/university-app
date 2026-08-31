part of 'app_date_picker.dart';

class AppMultiDatePickerSheet extends StatefulWidget {
  const AppMultiDatePickerSheet({
    required this.selected,
    required this.firstDate,
    required this.lastDate,
    this.dateEnabledBuilder,
    super.key,
  });

  final List<DateTime> selected;
  final DateTime firstDate;
  final DateTime lastDate;
  final bool Function(DateTime)? dateEnabledBuilder;

  @override
  State<AppMultiDatePickerSheet> createState() =>
      _AppMultiDatePickerSheetState();
}

class _AppMultiDatePickerSheetState extends State<AppMultiDatePickerSheet> {
  late final List<DateTime> _selected = [...widget.selected];

  void _toggle(DateTime day) {
    setState(() {
      final index = _selected.indexWhere((date) => _sameDay(date, day));
      if (index >= 0) {
        _selected.removeAt(index);
      } else {
        _selected.add(day);
      }
      _selected.sort();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.ninja;
    return Column(
      spacing: 16,
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      children: [
        Column(
          spacing: 8,
          crossAxisAlignment: .stretch,
          children: [
            Row(
              children: [
                Text(
                  l10n.pickerSelectedCount(_selected.length),
                  style: NinjaText.subtext.copyWith(
                    color: colors.muted,
                  ),
                ),
                const Spacer(),
                if (_selected.isNotEmpty)
                  AppPressable(
                    onTap: () => setState(_selected.clear),
                    semanticsLabel: l10n.pickerClear,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 44),
                      child: Center(
                        child: Text(
                          l10n.pickerClear,
                          style: NinjaText.subtext.copyWith(
                            color: colors.scarlet,
                            fontWeight: .w600,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            AppFlatCalendar(
              firstDay: widget.firstDate,
              lastDay: widget.lastDate,
              initialFocus: _selected.elementAtOrNull(0) ?? DateTime.now(),
              dateSelectedBuilder: (day) =>
                  _selected.any((date) => _sameDay(date, day)),
              dateEnabledBuilder: widget.dateEnabledBuilder,
              onDateSelected: _toggle,
            ),
          ],
        ),
        NinjaButton.primary(
          label: l10n.done,
          expanded: true,
          onPressed: () =>
              Navigator.of(context, rootNavigator: true).pop(_selected),
        ),
      ],
    );
  }
}

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
    final colors = context.colors;
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.sm,
          children: [
            Text(
              l10n.pickerSelectedCount(_selected.length),
              style: AppText.subtext.copyWith(color: colors.muted),
            ),
            if (_selected.isNotEmpty)
              AppButton.text(
                label: l10n.pickerClear,
                size: AppButtonSize.small,
                foregroundColor: colors.danger,
                onPressed: () => setState(_selected.clear),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        AppFlatCalendar(
          firstDay: widget.firstDate,
          lastDay: widget.lastDate,
          initialFocus: _selected.elementAtOrNull(0) ?? DateTime.now(),
          dateSelectedBuilder: (day) =>
              _selected.any((date) => _sameDay(date, day)),
          dateEnabledBuilder: widget.dateEnabledBuilder,
          onDateSelected: _toggle,
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        AppSheetAction(
          label: l10n.done,
          onTap: () =>
              Navigator.of(context, rootNavigator: true).pop(_selected),
        ),
      ],
    );
  }
}

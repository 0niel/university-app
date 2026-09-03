part of 'app_time_picker.dart';

class AppTimePickerSheet extends StatefulWidget {
  const AppTimePickerSheet({
    required this.start,
    this.end,
    this.isRange = false,
    this.quickSlots = const [],
    super.key,
  });

  final PickedTime start;
  final PickedTime? end;
  final bool isRange;
  final List<TimeSlot> quickSlots;

  @override
  State<AppTimePickerSheet> createState() => _AppTimePickerSheetState();
}

class _AppTimePickerSheetState extends State<AppTimePickerSheet> {
  late PickedTime _start = widget.start;
  late PickedTime _end =
      widget.end ??
      (hour: (widget.start.hour + 1) % 24, minute: widget.start.minute);
  int _epoch = 0;

  void _applySlot(TimeSlot slot) {
    setState(() {
      _start = slot.start;
      _end = slot.end;
      _epoch++;
    });
  }

  void _done() {
    if (widget.isRange && _minutesOf(_end) <= _minutesOf(_start)) {
      ToastManager.showWarning(
        context,
        message: context.l10n.lessonEditorEndAfterStart,
      );
      return;
    }
    Navigator.of(
      context,
      rootNavigator: true,
    ).pop(widget.isRange ? (_start, _end) : _start);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      children: [
        Center(
          child: Text(
            widget.isRange
                ? '${formatPickedTime(_start)} – ${formatPickedTime(_end)}'
                : formatPickedTime(_start),
            style: AppText.sans(
              28,
              .w800,
              tabular: true,
            ).copyWith(color: colors.ink),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const .symmetric(horizontal: AppSpacing.screen),
          child: widget.isRange
              ? Row(
                  spacing: 12,
                  children: [
                    Expanded(
                      child: AppTimeWheelGroup(
                        key: ValueKey('start-$_epoch'),
                        label: l10n.pickerStart,
                        initial: _start,
                        onChanged: (time) => setState(() => _start = time),
                      ),
                    ),
                    Expanded(
                      child: AppTimeWheelGroup(
                        key: ValueKey('end-$_epoch'),
                        label: l10n.pickerEnd,
                        initial: _end,
                        onChanged: (time) => setState(() => _end = time),
                      ),
                    ),
                  ],
                )
              : AppTimeWheelGroup(
                  key: ValueKey('single-$_epoch'),
                  initial: _start,
                  onChanged: (time) => setState(() => _start = time),
                ),
        ),
        if (widget.quickSlots.isNotEmpty) ...[
          const SizedBox(height: 16),
          AppChipRow<int>(
            padding: const .symmetric(horizontal: AppSpacing.screen),
            value: widget.quickSlots.indexWhere(
              (slot) => slot.start == _start && slot.end == _end,
            ),
            items: [
              for (final (index, slot) in widget.quickSlots.indexed)
                AppChipRowItem(value: index, label: slot.label),
            ],
            onChanged: (index) => _applySlot(widget.quickSlots[index]),
          ),
        ],
        const SizedBox(height: 20),
        Padding(
          padding: const .symmetric(horizontal: AppSpacing.screen),
          child: AppSheetAction(label: l10n.done, onTap: _done),
        ),
      ],
    );
  }
}

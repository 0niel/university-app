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
      showNinjaToast(
        context,
        showCheck: false,
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
    final colors = context.ninja;
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      children: [
        Padding(
          padding: const .symmetric(horizontal: 20),
          child: Center(
            child: Text(
              widget.isRange
                  ? '${formatPickedTime(_start)} – ${formatPickedTime(_end)}'
                  : formatPickedTime(_start),
              style: NinjaText.tabular(
                NinjaText.title.copyWith(
                  fontSize: 28,
                  color: colors.ink,
                  fontWeight: .w800,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const .symmetric(horizontal: 20),
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
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: .horizontal,
              padding: const .symmetric(horizontal: 20),
              itemCount: widget.quickSlots.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final slot = widget.quickSlots[index];
                final selected = slot.start == _start && slot.end == _end;
                return AppSlotChip(
                  label: slot.label,
                  selected: selected,
                  onTap: () => _applySlot(slot),
                );
              },
            ),
          ),
        ],
        const SizedBox(height: 20),
        Padding(
          padding: const .symmetric(horizontal: 20),
          child: NinjaButton.primary(
            label: l10n.done,
            expanded: true,
            onPressed: _done,
          ),
        ),
      ],
    );
  }
}

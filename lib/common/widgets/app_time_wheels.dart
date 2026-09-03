part of 'app_time_picker.dart';

class AppTimeWheels extends StatefulWidget {
  const AppTimeWheels({
    required this.initial,
    required this.onChanged,
    super.key,
  });

  final PickedTime initial;
  final ValueChanged<PickedTime> onChanged;

  @override
  State<AppTimeWheels> createState() => _AppTimeWheelsState();
}

class _AppTimeWheelsState extends State<AppTimeWheels> {
  late int _hour = widget.initial.hour;
  late int _minute = widget.initial.minute;
  late final FixedExtentScrollController _hourController =
      FixedExtentScrollController(initialItem: _hour);
  late final FixedExtentScrollController _minuteController =
      FixedExtentScrollController(initialItem: _minute);

  static const _extent = 40.0;
  static const _height = 160.0;

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  void _emit() => widget.onChanged((hour: _hour, minute: _minute));

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox(
      height: _height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: _extent,
            margin: const .symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: .circular(AppRadius.card),
            ),
          ),
          Row(
            mainAxisAlignment: .center,
            children: [
              _wheel(
                controller: _hourController,
                count: 24,
                selected: _hour,
                onChanged: (index) {
                  setState(() => _hour = index);
                  _emit();
                },
              ),
              Text(
                ':',
                style: AppText.tabular(
                  AppText.title.copyWith(
                    color: colors.muted,
                    fontWeight: .w700,
                  ),
                ),
              ),
              _wheel(
                controller: _minuteController,
                count: 60,
                selected: _minute,
                onChanged: (index) {
                  setState(() => _minute = index);
                  _emit();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _wheel({
    required FixedExtentScrollController controller,
    required int count,
    required int selected,
    required ValueChanged<int> onChanged,
  }) {
    final colors = context.colors;
    return SizedBox(
      width: 56,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: _extent,
        physics: const FixedExtentScrollPhysics(),
        perspective: 0.004,
        diameterRatio: 1.5,
        overAndUnderCenterOpacity: 0.35,
        onSelectedItemChanged: onChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: count,
          builder: (context, index) {
            final isActive = index == selected;
            return Center(
              child: Text(
                _two(index),
                style: AppText.tabular(
                  AppText.title.copyWith(
                    fontSize: isActive ? 22 : 20,
                    color: isActive ? colors.ink : colors.muted,
                    fontWeight: isActive ? .w700 : .w500,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

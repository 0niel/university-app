part of 'app_time_picker.dart';

class AppTimeWheelGroup extends StatelessWidget {
  const AppTimeWheelGroup({
    required this.initial,
    required this.onChanged,
    this.label,
    super.key,
  });

  final String? label;
  final PickedTime initial;
  final ValueChanged<PickedTime> onChanged;

  @override
  Widget build(BuildContext context) {
    final label = this.label;
    return Column(
      mainAxisSize: .min,
      children: [
        if (label != null) ...[
          Text(
            label.toUpperCase(),
            style: AppText.overline.copyWith(color: context.colors.muted),
          ),
          const SizedBox(height: 8),
        ],
        AppTimeWheels(initial: initial, onChanged: onChanged),
      ],
    );
  }
}

part of 'app_date_picker.dart';

class AppDatePickerDayCell extends StatelessWidget {
  const AppDatePickerDayCell({
    required this.day,
    this.state = AppDatePickerDayState.normal,
    super.key,
  });

  final DateTime day;
  final AppDatePickerDayState state;

  static const double height = 46;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final selected = state == AppDatePickerDayState.selected;
    final color = switch (state) {
      AppDatePickerDayState.selected => colors.onAccent,
      AppDatePickerDayState.disabled => colors.muted2,
      AppDatePickerDayState.normal || AppDatePickerDayState.today => colors.ink,
    };
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Container(
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? colors.accent : colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.iconTile),
          border: state == AppDatePickerDayState.today
              ? Border.all(color: colors.accent, width: 2)
              : null,
        ),
        child: Text(
          '${day.day}',
          style: AppText.sans(14, .w700, tabular: true).copyWith(color: color),
        ),
      ),
    );
  }
}

enum AppDatePickerDayState { normal, today, selected, disabled }

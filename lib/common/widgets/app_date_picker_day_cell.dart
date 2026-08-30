part of 'app_date_picker.dart';

class AppDatePickerDayCell extends StatelessWidget {
  const AppDatePickerDayCell({
    required this.day,
    required this.color,
    this.background,
    this.bold = false,
    super.key,
  });

  final DateTime day;
  final Color color;
  final Color? background;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 38,
        height: 38,
        alignment: Alignment.center,
        decoration: background != null
            ? BoxDecoration(
                color: background,
                borderRadius: .circular(NinjaRadius.control),
              )
            : null,
        child: Text(
          '${day.day}',
          style: NinjaText.tabular(
            NinjaText.body.copyWith(
              fontSize: 15,
              color: color,
              fontWeight: bold ? .w700 : .w500,
            ),
          ),
        ),
      ),
    );
  }
}

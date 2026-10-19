import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_paging.dart';

class ScheduleViewSelector extends StatelessWidget {
  const ScheduleViewSelector({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final ScheduleView value;
  final ValueChanged<ScheduleView> onChanged;

  @override
  Widget build(BuildContext context) => AppGlassSurface(
    borderRadius: AppRadius.full,
    child: AppSegmentedControl<ScheduleView>(
      options: [
        AppSegmentedOption(
          value: ScheduleView.day,
          label: context.l10n.scheduleViewDay,
        ),
        AppSegmentedOption(value: ScheduleView.week, label: context.l10n.week),
        AppSegmentedOption(
          value: ScheduleView.month,
          label: context.l10n.month,
        ),
      ],
      value: value,
      backgroundColor: const Color(0x00000000),
      onChanged: onChanged,
    ),
  );
}

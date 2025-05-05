import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:app_ui/app_ui.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';

class ComparisonModeButton extends StatelessWidget {
  const ComparisonModeButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isComparisonModeEnabled = context.select((ScheduleBloc bloc) => bloc.state.isComparisonModeEnabled);
    final comparisonCount = context.select((ScheduleBloc bloc) => bloc.state.comparisonSchedules.length);
    final bool hasSchedules = comparisonCount > 0;
    final colors = Theme.of(context).extension<AppColors>()!;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: Icon(
            HugeIcons.strokeRoundedAbacus,
            size: 24,
            color: isComparisonModeEnabled ? colors.colorful01 : colors.active,
          ),
          tooltip: isComparisonModeEnabled ? 'Выключить режим сравнения' : 'Сравнить расписания',
          style: IconButton.styleFrom(
            backgroundColor: isComparisonModeEnabled ? colors.colorful01.withOpacity(0.2) : Colors.transparent,
            padding: const EdgeInsets.all(8.0),
          ),
          onPressed: onPressed,
        ),
        if (hasSchedules && !isComparisonModeEnabled)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: colors.colorful03,
                shape: BoxShape.circle,
                border: Border.all(color: colors.background01, width: 2),
              ),
              child: Center(
                child: Text(
                  comparisonCount.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

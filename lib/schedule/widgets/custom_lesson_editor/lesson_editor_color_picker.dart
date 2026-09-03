import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/schedule/widgets/schedule_metrics.dart';

class LessonEditorColorPicker extends StatelessWidget {
  const LessonEditorColorPicker({
    required this.colors,
    required this.selected,
    required this.semanticLabelBuilder,
    required this.onSelected,
    super.key,
  });

  final List<int> colors;
  final int selected;
  final String Function(int index) semanticLabelBuilder;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: AppSpacing.xs,
    runSpacing: AppSpacing.xs,
    children: [
      for (final (index, value) in colors.indexed)
        AppPressable(
          onTap: () => onSelected(value),
          semanticsLabel: semanticLabelBuilder(index),
          semanticsSelected: value == selected,
          child: SizedBox.square(
            dimension: AppControlSize.touchTarget,
            child: Center(
              child: Container(
                width: ScheduleMetrics.timeColumn,
                height: ScheduleMetrics.timeColumn,
                decoration: BoxDecoration(
                  color: Color(value),
                  shape: .circle,
                ),
                child: value == selected
                    ? const Center(
                        child: AppLineIconWidget(
                          .check,
                          size: 16,
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : null,
              ),
            ),
          ),
        ),
    ],
  );
}

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';

class ScheduleSelectorOptionRow extends StatelessWidget {
  const ScheduleSelectorOptionRow({
    required this.schedule,
    required this.selectedId,
    required this.onSelected,
    super.key,
  });

  final CustomSchedule schedule;
  final String? selectedId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final description = schedule.description;
    final lessonsCount = schedule.lessons.length;
    final selected = selectedId == schedule.id;

    return Padding(
      padding: const .only(bottom: 10),
      child: AppPressable(
        onTap: () => onSelected(schedule.id),
        semanticsLabel: schedule.name,
        semanticsSelected: selected,
        child: AnimatedContainer(
          duration: NinjaMotion.of(context, NinjaMotion.fast),
          constraints: const BoxConstraints(minHeight: 64),
          padding: const .all(12),
          decoration: BoxDecoration(
            color: selected ? colors.brandTint : colors.surfaceAlt,
            borderRadius: .circular(NinjaRadius.card),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colors.surface,
                  shape: .circle,
                ),
                child: Center(
                  child: AppLineIconWidget(
                    AppLineIcon.calendar,
                    color: selected ? colors.brandInk : colors.mutedDark,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      schedule.name,
                      style: NinjaText.body.copyWith(
                        color: colors.ink,
                        fontWeight: .w600,
                      ),
                    ),
                    if (description case final value? when value.isNotEmpty)
                      Text(
                        value,
                        style: NinjaText.subtext.copyWith(color: colors.muted),
                        maxLines: 2,
                        overflow: .ellipsis,
                      ),
                    Text(
                      '$lessonsCount '
                      '${context.l10n.classesCount(lessonsCount)}',
                      style: NinjaText.subtext.copyWith(color: colors.muted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              NinjaRadio<String>(
                value: schedule.id,
                groupValue: selectedId,
                onChanged: onSelected,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_picker_options.dart';

class SchedulePickerMenu extends StatelessWidget {
  const SchedulePickerMenu({required this.bloc, super.key});

  final ScheduleBloc bloc;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      bloc: bloc,
      builder: (context, state) {
        final selectedId = state.selectedSchedule?.pickerId;
        final options = schedulePickerOptions(state);
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
              child: Text(
                l10n.selectSchedule,
                style: AppText.captionStrong.copyWith(color: colors.muted),
              ),
            ),
            for (final schedule in options)
              MergeSemantics(
                child: Semantics(
                  selected: schedule.pickerId == selectedId,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.iconTile),
                      color: schedule.pickerId == selectedId
                          ? colors.accent.withValues(alpha: .1)
                          : Colors.transparent,
                    ),
                    child: AppListRow(
                      key: ValueKey('schedule-picker-${schedule.pickerId}'),
                      title: schedule.name,
                      titleMaxLines: null,
                      subtitle: schedule.pickerSubtitle(l10n),
                      dense: true,
                      strong: schedule.pickerId == selectedId,
                      leading: AppLineIconWidget(
                        schedule.pickerIcon,
                        size: AppIconSize.compact,
                        color: schedule.pickerId == selectedId
                            ? colors.accent
                            : colors.muted,
                      ),
                      trailing: SizedBox.square(
                        dimension: AppIconSize.compact,
                        child: schedule.pickerId == selectedId
                            ? AppLineIconWidget(
                                AppLineIcon.check,
                                color: colors.accent,
                                size: AppIconSize.compact,
                              )
                            : null,
                      ),
                      onTap: () => Navigator.of(context).pop(
                        SchedulePickerSelection(schedule),
                      ),
                    ),
                  ),
                ),
              ),
            if (options.isEmpty)
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  l10n.noAvailableSchedules,
                  style: AppText.body.copyWith(color: colors.muted),
                ),
              ),
            const SizedBox(height: AppSpacing.xsm),
            AppListRow(
              key: const ValueKey('schedule-picker-management'),
              title: l10n.scheduleHubAllSchedules,
              titleMaxLines: null,
              subtitle: l10n.scheduleHubAllSchedulesSubtitle,
              dense: true,
              leading: AppLineIconWidget(
                AppLineIcon.tune,
                color: colors.accent,
                size: AppIconSize.compact,
              ),
              onTap: () => Navigator.of(context).pop(
                const SchedulePickerManagement(),
              ),
            ),
          ],
        );
      },
    );
  }
}

sealed class SchedulePickerChoice {
  const SchedulePickerChoice();
}

final class SchedulePickerSelection extends SchedulePickerChoice {
  const SchedulePickerSelection(this.schedule);

  final SelectedSchedule schedule;
}

final class SchedulePickerManagement extends SchedulePickerChoice {
  const SchedulePickerManagement();
}

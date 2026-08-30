import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/widgets/custom_schedule_selector/schedule_selector_empty_state.dart';
import 'package:rtu_mirea_app/schedule/widgets/custom_schedule_selector/schedule_selector_option_row.dart';

class ScheduleSelectorOptionList extends StatelessWidget {
  const ScheduleSelectorOptionList({
    required this.selectedId,
    required this.onSelected,
    required this.onSubmit,
    required this.onCreateRequested,
    super.key,
  });

  final String? selectedId;
  final ValueChanged<String> onSelected;
  final VoidCallback? onSubmit;
  final VoidCallback onCreateRequested;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<CustomScheduleCubit, CustomScheduleState>(
      builder: (context, state) => NinjaStateSwitcher(
        child: _buildState(context, l10n, state.customSchedules),
      ),
    );
  }

  Widget _buildState(
    BuildContext context,
    AppLocalizations l10n,
    List<CustomSchedule> schedules,
  ) {
    if (schedules.isEmpty) {
      return ScheduleSelectorEmptyState(
        onCreate: onCreateRequested,
      ).animateEmptyState(key: const ValueKey('schedule_selector_empty'));
    }

    return Column(
      key: const ValueKey('schedule_selector_options'),
      crossAxisAlignment: .start,
      children: [
        Text(
          l10n.selectSchedule,
          style: NinjaText.headline.copyWith(color: context.ninja.ink),
        ),
        const SizedBox(height: 12),
        for (final (index, schedule) in schedules.indexed)
          ScheduleSelectorOptionRow(
            schedule: schedule,
            selectedId: selectedId,
            onSelected: onSelected,
          ).animateListItem(index: index),
        if (selectedId != null) ...[
          const SizedBox(height: 18),
          SizedBox(
            width: .infinity,
            child: NinjaButton.primary(
              onPressed: onSubmit,
              label: l10n.addToSelectedSchedule,
              size: .large,
              expanded: true,
            ),
          ),
        ],
      ],
    );
  }
}

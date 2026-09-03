import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:schedule_repository/schedule_repository.dart';

class DeadlineOptions extends StatefulWidget {
  const DeadlineOptions({
    required this.dueAt,
    required this.subject,
    required this.priority,
    required this.remind,
    required this.remindMinutes,
    required this.progress,
    required this.onSubjectChanged,
    required this.onTime,
    required this.onPriorityChanged,
    required this.onRemindChanged,
    required this.onRemindMinutesChanged,
    required this.onProgressChanged,
    super.key,
  });

  final DateTime dueAt;
  final String subject;
  final DeadlinePriority priority;
  final bool remind;
  final int remindMinutes;
  final int progress;
  final ValueChanged<String> onSubjectChanged;
  final VoidCallback onTime;
  final ValueChanged<DeadlinePriority> onPriorityChanged;
  final ValueChanged<bool> onRemindChanged;
  final ValueChanged<int> onRemindMinutesChanged;
  final ValueChanged<int> onProgressChanged;

  @override
  State<DeadlineOptions> createState() => _DeadlineOptionsState();
}

class _DeadlineOptionsState extends State<DeadlineOptions> {
  bool expanded = false;
  late final subjectController = TextEditingController(text: widget.subject);

  @override
  void didUpdateWidget(covariant DeadlineOptions oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.subject != oldWidget.subject &&
        subjectController.text != widget.subject) {
      subjectController.text = widget.subject;
    }
  }

  @override
  void dispose() {
    subjectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        AppListRow(
          title: l10n.settings,
          trailing: AppLineIconWidget(
            expanded ? AppLineIcon.chevronU : AppLineIcon.chevronD,
          ),
          onTap: () => setState(() => expanded = !expanded),
        ),
        if (expanded) ...[
          const SizedBox(height: AppSpacing.sm),
          AppInputField(
            controller: subjectController,
            placeholder: l10n.deadlineSubjectHint,
            onChanged: widget.onSubjectChanged,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppListRow(
            title: l10n.deadlineTimeLabel,
            meta: DateFormat.Hm(
              Localizations.localeOf(context).toString(),
            ).format(widget.dueAt),
            onTap: widget.onTime,
          ),
          AppOverline(l10n.deadlinePriorityLabel, topPadding: 12),
          AppSegmentedControl<DeadlinePriority>(
            value: widget.priority,
            onChanged: widget.onPriorityChanged,
            options: [
              AppSegmentedOption(value: .low, label: l10n.deadlinePriorityLow),
              AppSegmentedOption(
                value: .medium,
                label: l10n.deadlinePriorityMedium,
              ),
              AppSegmentedOption(
                value: .urgent,
                label: l10n.deadlinePriorityUrgent,
              ),
            ],
          ),
          AppOverline(l10n.deadlineProgressLabel, topPadding: 16),
          AppSegmentedControl<int>(
            value: widget.progress,
            onChanged: widget.onProgressChanged,
            options: const [
              AppSegmentedOption(value: 0, label: '0%'),
              AppSegmentedOption(value: 25, label: '25%'),
              AppSegmentedOption(value: 50, label: '50%'),
              AppSegmentedOption(value: 75, label: '75%'),
              AppSegmentedOption(value: 100, label: '100%'),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          AppListRow(
            title: l10n.deadlineRemindTitle,
            subtitle: l10n.deadlineRemindSubtitle,
            trailing: AppSwitch(
              value: widget.remind,
              semanticsLabel: l10n.deadlineRemindTitle,
              onChanged: widget.onRemindChanged,
            ),
          ),
          if (widget.remind) ...[
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                AppChip.filter(
                  key: const ValueKey('deadline-remind-hour'),
                  label: l10n.deadlineRemindLeadHour,
                  selected: widget.remindMinutes == 60,
                  onTap: () => widget.onRemindMinutesChanged(60),
                ),
                AppChip.filter(
                  key: const ValueKey('deadline-remind-day'),
                  label: l10n.deadlineRemindLeadDay,
                  selected: widget.remindMinutes == 1440,
                  onTap: () => widget.onRemindMinutesChanged(1440),
                ),
              ],
            ),
          ],
        ],
      ],
    );
  }
}

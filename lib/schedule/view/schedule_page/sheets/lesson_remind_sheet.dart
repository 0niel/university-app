import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_notifications_repository/local_notifications_repository.dart';
import 'package:rtu_mirea_app/common/widgets/app_time_picker.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_text.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_dates.dart';
import 'package:schedule_repository/schedule_repository.dart';

Future<void> showLessonRemindSheet(
  BuildContext context, {
  required LessonSchedulePart lesson,
  required DateTime day,
  Future<PickedTime?> Function(PickedTime initial)? timePicker,
}) {
  return showAppSheet<void>(
    context,
    title: context.l10n.reminderSheetTitle,
    subtitle: '${lesson.subject} · ${timeRangeText(lesson)}',
    child: _Reminder(
      lesson: lesson,
      day: day,
      repository: context.read<ScheduleRepository>(),
      reminders: context.read<LessonRemindersCubit>(),
      notifications: context.read<LocalNotificationsRepository>(),
      timePicker: timePicker,
    ),
  );
}

class _Reminder extends StatefulWidget {
  const _Reminder({
    required this.lesson,
    required this.day,
    required this.repository,
    required this.reminders,
    required this.notifications,
    this.timePicker,
  });
  final LessonSchedulePart lesson;
  final DateTime day;
  final ScheduleRepository repository;
  final LessonRemindersCubit reminders;
  final LocalNotificationsRepository notifications;
  final Future<PickedTime?> Function(PickedTime initial)? timePicker;

  @override
  State<_Reminder> createState() => _ReminderState();
}

enum _ReminderTime { lead, morning, custom }

class _ReminderState extends State<_Reminder> {
  late int _minutes =
      widget.reminders.minutesFor(widget.lesson, widget.day) ?? 15;
  bool _saving = false;
  String? _error;
  bool _expanded = false;
  bool _withRoute = true;
  _ReminderTime _time = _ReminderTime.lead;
  PickedTime? _customTime;

  DateTime get _start => atTime(
    widget.day,
    widget.lesson.lessonBells.startTime,
  );

  DateTime get _fireAt => switch (_time) {
    _ReminderTime.lead => _start.subtract(Duration(minutes: _minutes)),
    _ReminderTime.morning => DateTime(
      widget.day.year,
      widget.day.month,
      widget.day.day,
      8,
    ),
    _ReminderTime.custom => DateTime(
      widget.day.year,
      widget.day.month,
      widget.day.day,
      _customTime!.hour,
      _customTime!.minute,
    ),
  };

  Future<void> _pickCustomTime() async {
    final initial = _customTime ?? (hour: _start.hour, minute: _start.minute);
    final picked =
        await (widget.timePicker?.call(initial) ??
            showAppTimePicker(context, initial: initial));
    if (picked == null || !mounted) return;
    setState(() {
      _customTime = picked;
      _time = _ReminderTime.custom;
      _error = null;
    });
  }

  Future<void> _save() async {
    if (_saving) return;
    if (widget.reminders.minutesFor(widget.lesson, widget.day) != null) {
      Navigator.of(context).pop();
      return;
    }
    final at = _fireAt;
    if (!at.isAfter(DateTime.now()) || !at.isBefore(_start)) {
      setState(() => _error = context.l10n.reminderTimeInvalid);
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      if (!await widget.notifications.ensurePermission()) {
        if (mounted) setState(() => _error = context.l10n.onboardingPushDenied);
        return;
      }
      if (!mounted) return;
      final room = widget.lesson.classrooms.firstOrNull?.name;
      final startsAt = context.l10n.reminderAtTime(
        '${widget.lesson.lessonBells.startTime}',
      );
      await widget.repository.createReminder(
        fireAt: at,
        title: widget.lesson.subject,
        body: [
          startsAt,
          if (_withRoute && room != null) room,
        ].join(' · '),
        route: _withRoute ? '/services/map' : '/schedule',
      );
      if (!widget.reminders.isClosed) {
        widget.reminders.set(
          widget.lesson,
          widget.day,
          _start.difference(at).inMinutes,
        );
      }
      if (!mounted) return;
      ToastManager.showSuccess(
        context,
        message: context.l10n.reminderSuccessBody(
          formatPickedTime((hour: at.hour, minute: at.minute)),
        ),
      );
      Navigator.of(context).pop();
    } on Exception {
      if (mounted) setState(() => _error = context.l10n.scheduleActionFailed);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final existing = widget.reminders.minutesFor(widget.lesson, widget.day);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var row = 0; row < 2; row++)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              children: [
                for (var column = 0; column < 2; column++)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: column == AppSpacing.zero
                            ? AppSpacing.zero
                            : AppSpacing.sm,
                      ),
                      child: AppButton(
                        label:
                            LessonRemindersCubit.options[row * 2 + column] == 60
                            ? l10n.scheduleRemindHour
                            : l10n.scheduleRemindIn(
                                LessonRemindersCubit.options[row * 2 + column],
                              ),
                        variant:
                            _time == _ReminderTime.lead &&
                                _minutes ==
                                    LessonRemindersCubit.options[row * 2 +
                                        column]
                            ? AppButtonVariant.primary
                            : AppButtonVariant.secondary,
                        borderRadius: AppRadius.button,
                        backgroundColor:
                            _time == _ReminderTime.lead &&
                                _minutes ==
                                    LessonRemindersCubit.options[row * 2 +
                                        column]
                            ? context.colors.accent
                            : context.colors.surface,
                        size: AppButtonSize.large,
                        onPressed: _saving || existing != null
                            ? null
                            : () => setState(() {
                                _time = _ReminderTime.lead;
                                _minutes = LessonRemindersCubit
                                    .options[row * 2 + column];
                                _error = null;
                              }),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        if (existing == null) ...[
          AppButton.text(
            key: const ValueKey('lesson-reminder-advanced'),
            label: l10n.more,
            icon: AppLineIconWidget(
              _expanded ? AppLineIcon.chevronU : AppLineIcon.chevronD,
            ),
            onPressed: _saving
                ? null
                : () => setState(() => _expanded = !_expanded),
          ),
          if (_expanded) ...[
            AppListGroup(
              children: [
                AppRadioRow(
                  key: const ValueKey('lesson-reminder-morning'),
                  title: l10n.reminderMorning,
                  subtitle: l10n.reminderMorningSub,
                  selected: _time == _ReminderTime.morning,
                  isFirst: true,
                  onTap: _saving
                      ? null
                      : () => setState(() {
                          _time = _ReminderTime.morning;
                          _error = null;
                        }),
                ),
                AppRadioRow(
                  key: const ValueKey('lesson-reminder-custom'),
                  title: l10n.reminderCustom,
                  subtitle: _customTime == null
                      ? l10n.reminderCustomHint
                      : l10n.reminderCustomAt(
                          formatPickedTime(_customTime!),
                        ),
                  selected: _time == _ReminderTime.custom,
                  onTap: _saving ? null : _pickCustomTime,
                ),
                AppListRow(
                  title: l10n.reminderRoute,
                  trailing: AppSwitch(
                    key: const ValueKey('lesson-reminder-route'),
                    value: _withRoute,
                    semanticsLabel: l10n.reminderRoute,
                    onChanged: _saving
                        ? null
                        : (value) => setState(() => _withRoute = value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ],
        if (_error != null)
          AppBanner(message: _error!, tone: AppBannerTone.danger),
        if (existing != null)
          AppBanner(
            message:
                '${l10n.reminderSuccessBody(formatPickedTime((
                  hour: _start.subtract(Duration(minutes: existing)).hour,
                  minute: _start.subtract(Duration(minutes: existing)).minute,
                )))}. ${l10n.scheduleReminderLocked}',
          ),
        const SizedBox(height: AppSpacing.sm),
        AppButton.primary(
          label: l10n.done,
          expanded: true,
          loading: _saving,
          size: AppButtonSize.large,
          onPressed: _saving ? null : _save,
        ),
      ],
    );
  }
}

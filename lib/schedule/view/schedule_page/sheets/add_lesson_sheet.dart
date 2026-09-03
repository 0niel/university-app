import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_text.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_dates.dart';
import 'package:schedule_repository/schedule_repository.dart';

Future<bool> showAddLessonSheet(
  BuildContext context, {
  DateTime? day,
  int? slot,
  LessonBellSlotConfig? bell,
}) async {
  final configured =
      context.read<UniversityConfig?>()?.lessonBellSlots ??
      UniversityConfig.defaultLessonBellSlots;
  final bells = [
    ...(configured.isEmpty
        ? UniversityConfig.defaultLessonBellSlots
        : configured),
  ];
  if (bell != null &&
      !bells.any(
        (item) =>
            item.startMinutes == bell.startMinutes &&
            item.endMinutes == bell.endMinutes,
      )) {
    bells.add(bell);
  }
  final saved = await showAppSheet<bool>(
    context,
    title: context.l10n.scheduleAddTitle,
    subtitle: context.l10n.scheduleAddSubtitle,
    child: _AddLesson(
      day: day ?? DateTime.now(),
      slot: bell == null
          ? slot ?? 0
          : bells.indexWhere(
              (item) =>
                  item.startMinutes == bell.startMinutes &&
                  item.endMinutes == bell.endMinutes,
            ),
      bells: bells,
      repository: context.read<ScheduleRepository>(),
      activities: context.read<UserActivitiesCubit>(),
    ),
  );
  return saved ?? false;
}

class _AddLesson extends StatefulWidget {
  const _AddLesson({
    required this.day,
    required this.slot,
    required this.bells,
    required this.repository,
    required this.activities,
  });
  final DateTime day;
  final int slot;
  final List<LessonBellSlotConfig> bells;
  final ScheduleRepository repository;
  final UserActivitiesCubit activities;
  @override
  State<_AddLesson> createState() => _AddLessonState();
}

class _AddLessonState extends State<_AddLesson> {
  final _name = TextEditingController();
  final _place = TextEditingController();
  late DateTime _day = dateOnly(widget.day);
  late int _slot = widget.slot.clamp(
    0,
    widget.bells.length - 1,
  );
  UserActivityType _type = UserActivityType.personal;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _place.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_name.text.trim().length < 2 || _saving) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final bell = widget.bells[_slot];
    try {
      await widget.repository.upsertUserActivity(
        UpsertUserActivityRequest(
          type: _type,
          title: _name.text.trim(),
          place: _place.text.trim().isEmpty ? null : _place.text.trim(),
          startsAt: _day.add(Duration(minutes: bell.startMinutes)),
          endsAt: _day.add(Duration(minutes: bell.endMinutes)),
        ),
      );
      await widget.activities.load(
        from: DateTime(_day.year, _day.month, -6),
        to: DateTime(_day.year, _day.month + 1, 8),
      );
      if (!mounted) return;
      ToastManager.showSuccess(context, message: context.l10n.scheduleAddDone);
      Navigator.of(context).pop(true);
    } on Exception {
      if (mounted) setState(() => _error = context.l10n.scheduleActionFailed);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppInputField(
          controller: _name,
          placeholder: l10n.scheduleAddName,
          fillColor: context.colors.surface,
          height: AppControlSize.search,
          enabled: !_saving,
          maxLength: 200,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: AppSpacing.md),
        AppInputField(
          controller: _place,
          placeholder: l10n.scheduleAddPlace,
          fillColor: context.colors.surface,
          height: AppControlSize.search,
          enabled: !_saving,
          maxLength: 200,
        ),
        AppOverline(l10n.scheduleAddType, topPadding: AppSpacing.lg),
        Wrap(
          spacing: AppSpacing.xsm,
          runSpacing: AppSpacing.xsm,
          children: [
            for (final type in UserActivityType.values)
              AppChip.filter(
                label: activityTypeLabel(l10n, type),
                selected: _type == type,
                onTap: _saving ? null : () => setState(() => _type = type),
              ),
          ],
        ),
        AppOverline(l10n.scheduleAddDay, topPadding: AppSpacing.lg),
        Wrap(
          spacing: AppSpacing.xsm,
          runSpacing: AppSpacing.xsm,
          children: [
            for (final day in weekDaysFor(widget.day))
              AppChip.filter(
                label: DateFormat('E d', locale).format(day),
                selected: isSameDate(day, _day),
                onTap: _saving ? null : () => setState(() => _day = day),
              ),
          ],
        ),
        AppOverline(l10n.scheduleAddSlot, topPadding: AppSpacing.lg),
        Wrap(
          spacing: AppSpacing.xsm,
          runSpacing: AppSpacing.xsm,
          children: [
            for (var index = 0; index < widget.bells.length; index++)
              AppChip.filter(
                label: DateFormat.Hm(locale).format(
                  _day.add(
                    Duration(
                      minutes: widget.bells[index].startMinutes,
                    ),
                  ),
                ),
                selected: index == _slot,
                onTap: _saving ? null : () => setState(() => _slot = index),
              ),
          ],
        ),
        if (_error != null) ...[
          const SizedBox(height: AppSpacing.md),
          AppBanner(message: _error!, tone: AppBannerTone.danger),
        ],
        const SizedBox(height: AppSpacing.fieldGap),
        AppButton.primary(
          label: l10n.add,
          expanded: true,
          size: AppButtonSize.large,
          loading: _saving,
          onPressed: !_saving && _name.text.trim().length >= 2 ? _save : null,
        ),
      ],
    );
  }
}

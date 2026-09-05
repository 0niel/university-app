import 'dart:convert';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/common/widgets/app_date_picker.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_status.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/sheets/schedule_share_data.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/sheets/schedule_share_event.dart';
import 'package:rtu_mirea_app/schedule_management/bloc/schedule_exporter_cubit.dart';
import 'package:schedule_repository/schedule_repository.dart';
import 'package:share_plus/share_plus.dart';

Future<void> showScheduleShareSheet(
  BuildContext context, {
  LessonSchedulePart? lesson,
  DateTime? day,
}) {
  final selected = context.read<ScheduleBloc>().state.selectedSchedule;
  final changes = context.read<ScheduleChangesCubit?>();
  final request = changesRequestFor(selected);
  return showAppSheet<void>(
    context,
    scrollable: false,
    contentPadding: EdgeInsets.zero,
    child: _ScheduleShare(
      day: day ?? DateTime.now(),
      single: lesson != null,
      name:
          lesson?.subject ??
          selected?.name ??
          context.l10n.scheduleLessonsTitle,
      lessons: lesson == null
          ? selected?.schedule.whereType<LessonSchedulePart>().toList() ?? []
          : [lesson],
      config: context.read<UniversityConfig>(),
      exporter: context.read<ScheduleExporterCubit>(),
      schedule: lesson == null ? selected?.schedule ?? [] : [],
      activities: lesson == null
          ? context.read<UserActivitiesCubit?>()?.state.activities ?? []
          : [],
      preferences:
          context.read<SchedulePreferencesCubit?>()?.state ??
          const SchedulePreferencesState(),
      display:
          context.read<ScheduleDisplayCubit?>()?.state ??
          const ScheduleDisplayState(),
      changes:
          request != null &&
              changes != null &&
              changes.matchesTarget(request.$1, request.$2)
          ? changes.state.changes
          : [],
    ),
  );
}

Future<void> showScheduleExportSheet(BuildContext context) =>
    showScheduleShareSheet(context);

class _ScheduleShare extends StatefulWidget {
  const _ScheduleShare({
    required this.day,
    required this.single,
    required this.name,
    required this.lessons,
    required this.config,
    required this.exporter,
    required this.schedule,
    required this.activities,
    required this.preferences,
    required this.display,
    required this.changes,
  });
  final DateTime day;
  final bool single;
  final String name;
  final List<LessonSchedulePart> lessons;
  final UniversityConfig config;
  final ScheduleExporterCubit exporter;
  final List<SchedulePart> schedule;
  final List<UserActivity> activities;
  final SchedulePreferencesState preferences;
  final ScheduleDisplayState display;
  final List<ScheduleChange> changes;
  @override
  State<_ScheduleShare> createState() => _ScheduleShareState();
}

class _ScheduleShareState extends State<_ScheduleShare> {
  int _period = 1;
  bool _busy = false;
  bool _reminders = true;
  bool _hasContentAbove = false;
  bool _hasContentBelow = false;
  String? _error;
  _ScheduleExportFormat _format = _ScheduleExportFormat.image;
  late DateTime _day = widget.day;

  void _updateScrollEdges(ScrollMetrics metrics) {
    final above = metrics.extentBefore > 0;
    final below = metrics.extentAfter > 0;
    if (above == _hasContentAbove && below == _hasContentBelow) return;
    setState(() {
      _hasContentAbove = above;
      _hasContentBelow = below;
    });
  }

  bool get _supportsCalendar =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  bool get _isCalendar =>
      _format == _ScheduleExportFormat.calendar ||
      _format == _ScheduleExportFormat.ics;

  List<LessonSchedulePart> get _lessons {
    final clipped = scheduleShareLessons(
      widget.lessons,
      day: _day,
      period: widget.single ? 0 : _period,
    );
    if (widget.single) return clipped;
    return [
      for (final lesson in clipped)
        for (final date in lesson.dates)
          if (visibleLessonsForDay(
                schedule: [lesson],
                day: date,
                now: DateTime.now(),
                preferences: widget.preferences,
                display: widget.display,
                changes: widget.changes,
              ).isNotEmpty &&
              (!_isCalendar ||
                  !isCancelled(changeFor(widget.changes, lesson, date))))
            lesson.copyWith(
              dates: [date],
              subject: isCancelled(changeFor(widget.changes, lesson, date))
                  ? '${context.l10n.calloutCancelled} · ${lesson.subject}'
                  : lesson.subject,
            ),
    ];
  }

  List<ScheduleShareEvent> get _events {
    final (first, last) = scheduleShareRange(
      day: _day,
      period: widget.single ? 0 : _period,
    );
    return scheduleShareEvents(
      l10n: context.l10n,
      schedule: widget.schedule,
      activities: widget.activities,
      first: first,
      last: last,
      showPast: widget.display.showPast,
      now: DateTime.now(),
    );
  }

  List<ScheduleShareEvent> get _calendarEvents =>
      _events.where((event) => event.canExportCalendar).toList();
  int get _count => scheduleShareOccurrenceCount(
    _lessons,
    events: _isCalendar ? _calendarEvents : _events,
  );
  bool get _hasIncompleteTime =>
      _calendarEvents.any((event) => !event.hasCompleteTime);

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await action();
    } on Exception {
      if (mounted) setState(() => _error = context.l10n.scheduleActionFailed);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _share(ShareParams params) async {
    final box = context.findRenderObject();
    await SharePlus.instance.share(
      ShareParams(
        text: params.text,
        files: params.files,
        fileNameOverrides: params.fileNameOverrides,
        sharePositionOrigin: box is RenderBox && box.hasSize
            ? Rect.fromPoints(
                box.localToGlobal(Offset.zero),
                box.localToGlobal(box.size.bottomRight(Offset.zero)),
              )
            : const Rect.fromLTWH(0, 0, 1, 1),
      ),
    );
  }

  Future<void> _textShare() => _run(
    () => _share(
      ShareParams(
        text: scheduleShareText(
          context.l10n,
          widget.name,
          _lessons,
          events: _events,
        ),
      ),
    ),
  );

  Future<void> _calendar() => _run(() async {
    final l10n = context.l10n;
    await widget.exporter.exportSchedule(
      calendarName: '${widget.config.universityShortName} · ${widget.name}',
      lessons: _lessons,
      events: _calendarEvents.map((event) => event.toCalendarPart()).toList(),
      includeShortTypeNames: true,
      reminderMinutes: _reminders ? [15] : [],
    );
    if (!mounted) return;
    if (!widget.exporter.state.isSuccess) {
      setState(() => _error = l10n.scheduleActionFailed);
      return;
    }
    ToastManager.showSuccess(context, message: l10n.scheduleExported);
  });

  Future<void> _image() => _run(() async {
    final pages = await scheduleShareImages(
      context,
      widget.name,
      _lessons,
      events: _events,
    );
    if (!mounted) return;
    await showAppSheet<void>(
      context,
      title: context.l10n.exportImagePreview,
      subtitle: context.l10n.exportImagePages(pages.length),
      child: _ScheduleImagePreview(
        pages: pages,
        onShare: () => _share(
          ShareParams(
            files: [
              for (final (index, bytes) in pages.indexed)
                XFile.fromData(
                  bytes,
                  mimeType: 'image/png',
                  name: 'schedule-${index + 1}.png',
                ),
            ],
            fileNameOverrides: [
              for (var index = 0; index < pages.length; index++)
                'schedule-${index + 1}.png',
            ],
          ),
        ),
      ),
    );
  });

  Future<void> _ics() => _run(() async {
    final data = scheduleShareCalendar(
      context.l10n,
      _lessons,
      reminders: _reminders,
      events: _calendarEvents,
    );
    await _share(
      ShareParams(
        files: [
          XFile.fromData(
            Uint8List.fromList(utf8.encode(data)),
            mimeType: 'text/calendar',
            name: 'schedule.ics',
          ),
        ],
        fileNameOverrides: ['schedule.ics'],
      ),
    );
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scrollController = PrimaryScrollController.of(context);
    final (first, last) = scheduleShareRange(
      day: _day,
      period: widget.single ? 0 : _period,
    );
    final from = DateFormat.yMMMd(l10n.localeName).format(first);
    final until = DateFormat.yMMMd(
      l10n.localeName,
    ).format(last.subtract(const Duration(days: 1)));
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Flexible(
          child: NotificationListener<ScrollMetricsNotification>(
            onNotification: (notification) {
              if (notification.depth == 0) {
                _updateScrollEdges(notification.metrics);
              }
              return false;
            },
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification.depth == 0) {
                  _updateScrollEdges(notification.metrics);
                }
                return false;
              },
              child: Stack(
                children: [
                  RawScrollbar(
                    controller: scrollController,
                    thumbVisibility: true,
                    thickness: AppSpacing.xxs,
                    radius: const Radius.circular(AppRadius.xxs),
                    thumbColor: context.colors.muted2,
                    padding: const EdgeInsets.only(right: AppSpacing.xs),
                    child: SingleChildScrollView(
                      key: const ValueKey('schedule-export-scroll'),
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.screen,
                        0,
                        AppSpacing.screen,
                        AppSpacing.lg,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AppSheetTitle(title: l10n.exportScheduleTitle),
                          const SizedBox(height: AppSpacing.sectionGap),
                          if (!widget.single) ...[
                            AppSegmentedControl<int>(
                              options: [
                                AppSegmentedOption(
                                  value: 0,
                                  label: l10n.exportSelectedDay,
                                ),
                                AppSegmentedOption(
                                  value: 1,
                                  label: l10n.exportPeriodWeek,
                                ),
                                AppSegmentedOption(
                                  value: 2,
                                  label: l10n.exportPeriodSemester,
                                ),
                              ],
                              value: _period,
                              onChanged: _busy
                                  ? null
                                  : (value) => setState(() => _period = value),
                            ),
                            const SizedBox(height: AppSpacing.sectionGap),
                            AppListRow(
                              title: context.l10n.pickerDateTitle,
                              subtitle: DateFormat.yMMMd(
                                l10n.localeName,
                              ).format(_day),
                              leading: const AppLineIconWidget(
                                AppLineIcon.calendar,
                              ),
                              onTap: _busy
                                  ? null
                                  : () async {
                                      final date = await showAppDatePicker(
                                        context,
                                        initial: _day,
                                      );
                                      if (date != null && mounted) {
                                        setState(() => _day = date);
                                      }
                                    },
                            ),
                            const SizedBox(height: AppSpacing.sectionGap),
                          ],
                          AppCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              spacing: AppSpacing.xs,
                              children: [
                                Text(
                                  widget.name,
                                  style: AppText.section.copyWith(
                                    color: context.colors.ink,
                                  ),
                                ),
                                Text(
                                  l10n.exportEntriesCount(_count),
                                  style: AppText.label.copyWith(
                                    color: context.colors.muted,
                                  ),
                                ),
                                Text(
                                  from == until ? from : '$from — $until',
                                  style: AppText.subtext.copyWith(
                                    color: context.colors.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sectionGap),
                          AppListGroup(
                            key: const ValueKey('schedule-export-formats'),
                            children: [
                              _formatRow(
                                _ScheduleExportFormat.image,
                                l10n.exportPng,
                                l10n.exportImageHint,
                                first: true,
                              ),
                              _formatRow(
                                _ScheduleExportFormat.calendar,
                                l10n.exportSystemCalendar,
                                _supportsCalendar
                                    ? l10n.exportCalendarSafeHint
                                    : l10n.exportCalendarMobileOnly,
                              ),
                              _formatRow(
                                _ScheduleExportFormat.ics,
                                l10n.exportIcsFile,
                                l10n.exportIcsFileSub,
                              ),
                              _formatRow(
                                _ScheduleExportFormat.text,
                                l10n.share,
                                l10n.scheduleLessonsTitle,
                              ),
                            ],
                          ),
                          if (_isCalendar) ...[
                            const SizedBox(height: AppSpacing.lg),
                            AppListGroup(
                              key: const ValueKey('schedule-export-reminders'),
                              children: [
                                AppListRow(
                                  title: l10n.exportReminders,
                                  subtitle: l10n.exportRemindersSub,
                                  trailing: AppSwitch(
                                    value: _reminders,
                                    semanticsLabel: l10n.exportReminders,
                                    onChanged: _busy
                                        ? null
                                        : (value) => setState(
                                            () => _reminders = value,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: AppSpacing.lg),
                          if (_isCalendar &&
                              _events.any((event) => !event.canExportCalendar))
                            AppBanner(
                              message: l10n.exportUnscheduledEventsHint,
                            ),
                          if (_format == _ScheduleExportFormat.calendar &&
                              _hasIncompleteTime)
                            AppBanner(message: l10n.exportCalendarIncomplete),
                        ],
                      ),
                    ),
                  ),
                  if (_hasContentAbove)
                    Positioned(
                      key: const ValueKey('schedule-export-top-fade'),
                      top: 0,
                      left: 0,
                      right: 0,
                      child: _scrollFade(atTop: true),
                    ),
                  if (_hasContentBelow)
                    Positioned(
                      key: const ValueKey('schedule-export-bottom-fade'),
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: _scrollFade(atTop: false),
                    ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          key: const ValueKey('schedule-export-footer'),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            AppSpacing.md,
            AppSpacing.screen,
            0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_error != null) ...[
                AppBanner(message: _error!, tone: AppBannerTone.danger),
                const SizedBox(height: AppSpacing.md),
              ],
              AppButton.primary(
                key: const ValueKey('schedule-export-submit'),
                expanded: true,
                loading: _busy,
                label: _format == _ScheduleExportFormat.image
                    ? l10n.exportImagePreview
                    : l10n.export,
                onPressed:
                    _busy ||
                        _count == 0 ||
                        (_format == _ScheduleExportFormat.calendar &&
                            (!_supportsCalendar || _hasIncompleteTime))
                    ? null
                    : switch (_format) {
                        _ScheduleExportFormat.image => _image,
                        _ScheduleExportFormat.calendar => _calendar,
                        _ScheduleExportFormat.ics => _ics,
                        _ScheduleExportFormat.text => _textShare,
                      },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _scrollFade({required bool atTop}) {
    final canvas = context.colors.canvas;
    return IgnorePointer(
      child: ExcludeSemantics(
        child: SizedBox(
          height: AppSpacing.lg,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: atTop ? Alignment.topCenter : Alignment.bottomCenter,
                end: atTop ? Alignment.bottomCenter : Alignment.topCenter,
                colors: [canvas, canvas.withValues(alpha: 0)],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _formatRow(
    _ScheduleExportFormat format,
    String title,
    String subtitle, {
    bool first = false,
  }) => AppRadioRow(
    title: title,
    subtitle: subtitle,
    selected: _format == format,
    isFirst: first,
    borderRadius: BorderRadius.zero,
    onTap: _busy
        ? null
        : () => setState(() {
            _format = format;
            _error = null;
          }),
  );
}

enum _ScheduleExportFormat { image, calendar, ics, text }

class _ScheduleImagePreview extends StatefulWidget {
  const _ScheduleImagePreview({required this.pages, required this.onShare});
  final List<Uint8List> pages;
  final Future<void> Function() onShare;

  @override
  State<_ScheduleImagePreview> createState() => _ScheduleImagePreviewState();
}

class _ScheduleImagePreviewState extends State<_ScheduleImagePreview> {
  final _controller = PageController();
  int _page = 0;
  bool _busy = false;
  bool _failed = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _share() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _failed = false;
    });
    try {
      await widget.onShare();
    } on Exception {
      if (mounted) setState(() => _failed = true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Column(
    spacing: AppSpacing.md,
    children: [
      SizedBox(
        height: 320,
        child: PageView.builder(
          controller: _controller,
          itemCount: widget.pages.length,
          onPageChanged: (value) => setState(() => _page = value),
          itemBuilder: (_, index) => Image.memory(
            widget.pages[index],
            fit: BoxFit.contain,
            semanticLabel:
                '${context.l10n.exportPng} ${index + 1}/${widget.pages.length}',
          ),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppIconButton(
            icon: const AppLineIconWidget(AppLineIcon.chevronL),
            tooltip: context.l10n.back,
            onPressed: _page == 0
                ? null
                : () => _controller.previousPage(
                    duration: NinjaMotion.of(context),
                    curve: Curves.easeInOut,
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Text(
              '${_page + 1}/${widget.pages.length}',
              style: AppText.label,
            ),
          ),
          AppIconButton(
            icon: const AppLineIconWidget(AppLineIcon.chevronR),
            tooltip: context.l10n.next,
            onPressed: _page + 1 == widget.pages.length
                ? null
                : () => _controller.nextPage(
                    duration: NinjaMotion.of(context),
                    curve: Curves.easeInOut,
                  ),
          ),
        ],
      ),
      if (_failed)
        AppBanner(
          message: context.l10n.scheduleActionFailed,
          tone: AppBannerTone.danger,
        ),
      AppButton.primary(
        label: context.l10n.share,
        expanded: true,
        loading: _busy,
        onPressed: _busy ? null : _share,
      ),
    ],
  );
}

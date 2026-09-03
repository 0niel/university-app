import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/community/cubit/events/events_cubit.dart';
import 'package:rtu_mirea_app/community/models/models.dart';
import 'package:rtu_mirea_app/community/view/events/events_body.dart';
import 'package:rtu_mirea_app/community/view/events/events_calendar_view.dart';
import 'package:rtu_mirea_app/community/view/events/events_filters.dart';
import 'package:rtu_mirea_app/community/view/events/events_view_mode.dart';
import 'package:rtu_mirea_app/community/widgets/create_event_sheet.dart';
import 'package:rtu_mirea_app/community/widgets/events/event_detail_sheet.dart';
import 'package:rtu_mirea_app/community/widgets/events/events_calendar_skeleton.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class EventsView extends StatefulWidget {
  const EventsView({super.key});

  @override
  State<EventsView> createState() => _EventsViewState();
}

class _EventsViewState extends State<EventsView> {
  EventsFilter _filter = EventsFilter.all;
  EventsViewMode _viewMode = EventsViewMode.list;

  Future<void> _create() async {
    final cubit = context.read<EventsCubit>();
    if (cubit.state.isCreating) return;
    final l10n = context.l10n;
    final created = await showAppSheet<bool>(
      context,
      title: l10n.eventsCreateSheetTitle,
      subtitle: l10n.eventsCreateSheetSubtitle,
      child: CreateEventSheet(onSubmit: cubit.createEvent),
    );
    if (!mounted) return;
    if (created ?? false) {
      showNinjaToast(context, message: l10n.eventsCreateSuccess);
    }
  }

  Future<void> _edit(CampusEvent event) async {
    final cubit = context.read<EventsCubit>();
    if (cubit.state.isSaving) return;
    final l10n = context.l10n;
    final saved = await showAppSheet<bool>(
      context,
      title: l10n.eventsEditSheetTitle,
      subtitle: l10n.eventsCreateSheetSubtitle,
      child: CreateEventSheet(
        existing: event,
        onSubmit: (draft) => cubit.updateEvent(event.id, draft),
      ),
    );
    if (!mounted) return;
    if (saved ?? false) {
      showNinjaToast(context, message: l10n.eventsUpdateSuccess);
    }
  }

  Future<void> _delete(CampusEvent event) async {
    final l10n = context.l10n;
    final confirmed = await showAppConfirmDialog(
      context,
      title: l10n.eventsDeleteConfirmTitle,
      message: l10n.eventsDeleteConfirmMessage,
      confirmLabel: l10n.delete,
      cancelLabel: l10n.cancel,
      destructive: true,
    );
    if (!confirmed || !mounted) return;
    final deleted = await context.read<EventsCubit>().deleteEvent(event.id);
    if (!mounted) return;
    showNinjaToast(
      context,
      showCheck: deleted,
      message: deleted ? l10n.eventsDeleteSuccess : l10n.eventsDeleteError,
    );
  }

  Future<void> _openDetail(CampusEvent event) async {
    final action = await showEventDetailSheet(context, event: event);
    if (!mounted || action == null) return;
    switch (action) {
      case EventDetailAction.edit:
        await _edit(event);
      case EventDetailAction.delete:
        await _delete(event);
    }
  }

  Future<void> _toggleRsvp(CampusEvent event) async {
    final l10n = context.l10n;
    final going = event.isGoing;
    final succeeded = await context.read<EventsCubit>().toggleRsvp(event.id);
    if (!mounted) return;
    if (succeeded) {
      showNinjaToast(
        context,
        message: going ? l10n.eventsToastRemoved : l10n.eventsToastGoing,
      );
    } else {
      showNinjaToast(context, showCheck: false, message: l10n.eventsRsvpError);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final state = context.watch<EventsCubit>().state;
    final cubit = context.read<EventsCubit>();
    return Scaffold(
      backgroundColor: colors.canvas,
      body: RefreshIndicator(
        color: colors.accent,
        backgroundColor: colors.surface,
        onRefresh: cubit.load,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: AppInnerHeader(
                title: l10n.eventsTitle,
                onBack: () => Navigator.of(context).maybePop(),
                backSemanticsLabel: l10n.back,
                actions: [
                  AppHeaderAction(
                    icon: AppLineIcon.calendar,
                    semanticsLabel: l10n.eventsCreate,
                    onTap: state.isCreating ? null : () => unawaited(_create()),
                  ),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                20,
                AppSpacing.screen,
                0,
              ),
              sliver: SliverToBoxAdapter(
                child: AppSegmentedControl<EventsViewMode>(
                  value: _viewMode,
                  onChanged: (mode) => setState(() => _viewMode = mode),
                  options: [
                    AppSegmentedOption(
                      value: EventsViewMode.list,
                      label: l10n.eventsViewList,
                    ),
                    AppSegmentedOption(
                      value: EventsViewMode.calendar,
                      label: l10n.eventsViewCalendar,
                    ),
                  ],
                ),
              ),
            ),
            if (_viewMode == .list)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screen,
                  14,
                  AppSpacing.screen,
                  0,
                ),
                sliver: SliverToBoxAdapter(
                  child: EventsFilters(
                    value: _filter,
                    onChanged: (value) => setState(() => _filter = value),
                  ),
                ),
              ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.screen,
                14,
                AppSpacing.screen,
                ninjaBottomInset(context) + AppSpacing.lg,
              ),
              sliver: SliverToBoxAdapter(
                child: _viewMode == .list
                    ? EventsBody(
                        state: state,
                        filter: _filter,
                        onRetry: () => unawaited(cubit.load()),
                        onCreate: () => unawaited(_create()),
                        onToggleRsvp: (event) => unawaited(
                          _toggleRsvp(event),
                        ),
                        onOpen: (event) => unawaited(_openDetail(event)),
                      )
                    : AppStateSwitcher(child: _calendarContent(context, state)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _calendarContent(BuildContext context, EventsState state) {
    final l10n = context.l10n;
    if (state.status == .loading && state.events.isEmpty) {
      return const EventsCalendarSkeleton(
        key: ValueKey('events-calendar-loading'),
      );
    }
    if (state.status == .failure && state.events.isEmpty) {
      return AppErrorState(
        key: const ValueKey('events-calendar-failure'),
        title: l10n.eventsLoadError,
        message: l10n.eventsLoadErrorSub,
        primaryLabel: l10n.retry,
        onPrimary: () => unawaited(context.read<EventsCubit>().load()),
      );
    }
    return EventsCalendarView(
      key: const ValueKey('events-calendar-ready'),
      state: state,
      onToggleRsvp: (event) => unawaited(_toggleRsvp(event)),
      onOpen: (event) => unawaited(_openDetail(event)),
    );
  }
}

import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/community/cubit/events/events_cubit.dart';
import 'package:rtu_mirea_app/community/models/models.dart';
import 'package:rtu_mirea_app/community/view/events/events_body.dart';
import 'package:rtu_mirea_app/community/view/events/events_filters.dart';
import 'package:rtu_mirea_app/community/widgets/create_event_sheet.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class EventsView extends StatefulWidget {
  const EventsView({super.key});

  @override
  State<EventsView> createState() => _EventsViewState();
}

class _EventsViewState extends State<EventsView> {
  EventsFilter _filter = EventsFilter.all;

  Future<void> _create() async {
    final cubit = context.read<EventsCubit>();
    if (cubit.state.isCreating) return;
    final l10n = context.l10n;
    final draft = await showAppSheet<EventDraft>(
      context,
      title: l10n.eventsCreateSheetTitle,
      subtitle: l10n.eventsCreateSheetSubtitle,
      child: const CreateEventSheet(),
    );
    if (draft == null || !mounted) return;
    final created = await cubit.createEvent(draft);
    if (!created && mounted) {
      showNinjaToast(
        context,
        showCheck: false,
        message: context.l10n.eventsCreateError,
      );
    }
  }

  Future<void> _toggleRsvp(String eventId, {required bool going}) async {
    final l10n = context.l10n;
    final succeeded = await context.read<EventsCubit>().toggleRsvp(eventId);
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
                child: EventsFilters(
                  value: _filter,
                  onChanged: (value) => setState(() => _filter = value),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                14,
                AppSpacing.screen,
                40,
              ),
              sliver: SliverToBoxAdapter(
                child: EventsBody(
                  state: state,
                  filter: _filter,
                  onRetry: () => unawaited(cubit.load()),
                  onCreate: () => unawaited(_create()),
                  onToggleRsvp: (event) => unawaited(
                    _toggleRsvp(event.id, going: event.isGoing),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

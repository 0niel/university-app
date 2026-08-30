import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/community/cubit/events/events_cubit.dart';
import 'package:rtu_mirea_app/community/models/models.dart';
import 'package:rtu_mirea_app/community/widgets/create_event_sheet.dart';
import 'package:rtu_mirea_app/community/widgets/event_cards.dart';
import 'package:rtu_mirea_app/community/widgets/event_category_style.dart';
import 'package:rtu_mirea_app/community/widgets/events_skeleton.dart';
import 'package:rtu_mirea_app/community/widgets/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

part 'events/category_filters.dart';
part 'events/empty_events.dart';
part 'events/events_body.dart';
part 'events/events_list.dart';
part 'events/load_failure.dart';

Future<void> _createEvent(BuildContext context) async {
  final cubit = context.read<EventsCubit>();
  if (cubit.state.isCreating) return;
  final l10n = context.l10n;
  final draft = await showAppSheet<EventDraft>(
    context,
    title: l10n.eventsCreateSheetTitle,
    subtitle: l10n.eventsCreateSheetSubtitle,
    child: const CreateEventSheet(),
  );
  if (draft == null || !context.mounted) return;
  final created = await cubit.createEvent(draft);
  if (!created && context.mounted) {
    _showError(context, context.l10n.eventsCreateError);
  }
}

void _showError(BuildContext context, String message) {
  showNinjaToast(context, message: message, showCheck: false);
}

class EventsView extends StatelessWidget {
  const EventsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsCubit, EventsState>(
      builder: (context, state) {
        final colors = context.ninja;
        final l10n = context.l10n;
        return Scaffold(
          backgroundColor: colors.canvas,
          floatingActionButton: NinjaCommunityFab(
            label: state.isCreating
                ? l10n.eventsCreating
                : l10n.eventsCreateCta,
            onPressed: () => unawaited(_createEvent(context)),
          ),
          body: _EventsBody(state: state),
        );
      },
    );
  }
}

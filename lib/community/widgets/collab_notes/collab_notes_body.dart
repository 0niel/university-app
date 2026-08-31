import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/community/cubit/collab_notes/collab_notes.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/collab_note_card.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/collab_notes_failure.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/collab_notes_skeleton.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class CollabNotesBody extends StatelessWidget {
  const CollabNotesBody({super.key, this.onOpen, this.onCreate});

  final ValueChanged<CollabNote>? onOpen;
  final VoidCallback? onCreate;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CollabNotesCubit>().state;
    return NinjaStateSwitcher(child: _content(context, state));
  }

  Widget _content(BuildContext context, CollabNotesState state) {
    if (state.status == .loading && state.notes.isEmpty) {
      return const CollabNotesSkeleton(key: ValueKey('notes-loading'));
    }
    if (state.status == .failure && state.notes.isEmpty) {
      return CollabNotesFailure(
        key: const ValueKey('notes-failure'),
        onRetry: context.read<CollabNotesCubit>().load,
      );
    }
    if (state.notes.isEmpty) {
      return ListView(
        key: const ValueKey('notes-empty'),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Padding(
            padding: const .fromLTRB(
              NinjaMetrics.screenPadding,
              64,
              NinjaMetrics.screenPadding,
              0,
            ),
            child: NinjaEmptyState.screen(
              icon: const AppLineIconWidget(AppLineIcon.pencil, size: 24),
              title: context.l10n.collabNotesEmptyTitle,
              message: context.l10n.collabNotesEmptySubtitle,
              actionLabel: context.l10n.collabNotesCreateTitle,
              onAction: onCreate,
            ).animateEmptyState(),
          ),
        ],
      );
    }
    return RefreshIndicator(
      key: const ValueKey('notes-list'),
      color: context.ninja.ink,
      onRefresh: context.read<CollabNotesCubit>().load,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const .fromLTRB(0, 8, 0, 96),
        itemCount: state.notes.length,
        itemBuilder: (context, index) {
          final note = state.notes[index];
          return CollabNoteCard(
            note: note,
            onTap: () => onOpen?.call(note),
          ).animateListItem(key: ValueKey(note.id), index: index);
        },
      ),
    );
  }
}

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/app/app.dart';
import 'package:rtu_mirea_app/community/cubit/collab_notes/collab_notes.dart';
import 'package:rtu_mirea_app/community/view/collab_note_editor_page.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/collab_notes_body.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/create_collab_note_sheet.dart';
import 'package:rtu_mirea_app/community/widgets/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class CollabNotesView extends StatelessWidget {
  const CollabNotesView({super.key});

  Future<void> _create(BuildContext context) async {
    final cubit = context.read<CollabNotesCubit>();
    final note = await showAppSheet<CollabNote>(
      context,
      title: context.l10n.collabNotesCreateTitle,
      subtitle: context.l10n.collabNotesCreateSubtitle,
      child: BlocProvider.value(
        value: cubit,
        child: const CreateCollabNoteSheet(),
      ),
    );
    if (note != null && context.mounted) await _open(context, note);
  }

  Future<void> _open(BuildContext context, CollabNote note) async {
    final fullName = context.read<AppBloc>().state.user.name?.trim() ?? '';
    final editorName = fullName.isEmpty
        ? context.l10n.collabNotesNinja
        : (fullName.split(RegExp(r'\s+')).firstOrNull ??
              context.l10n.collabNotesNinja);
    final repository = context.read<CampusRepository>();
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CollabNoteEditorPage(
          note: note,
          editorName: editorName,
          repository: repository,
        ),
      ),
    );
    if (context.mounted) await context.read<CollabNotesCubit>().load();
  }

  void _showRefreshError(BuildContext context) {
    showNinjaToast(
      context,
      showCheck: false,
      message: context.l10n.collabNotesRefreshError,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CollabNotesCubit, CollabNotesState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == .failure &&
          current.notes.isNotEmpty,
      listener: (context, _) => _showRefreshError(context),
      builder: (context, state) => Scaffold(
        backgroundColor: context.ninja.canvas,
        body: Column(
          children: [
            NinjaCommunityHeader(
              title: context.l10n.collabNotesTitle,
              subtitle: context.l10n.collabNotesSubtitle,
            ),
            Expanded(
              child: CollabNotesBody(
                onOpen: (note) => _open(context, note),
                onCreate: state.isCreating ? null : () => _create(context),
              ),
            ),
          ],
        ),
        floatingActionButton: NinjaCommunityFab(
          label: context.l10n.collabNotesCreateTitle,
          icon: .pencil,
          onPressed: state.isCreating ? null : () => _create(context),
        ),
      ),
    );
  }
}

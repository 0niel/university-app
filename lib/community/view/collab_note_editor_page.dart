import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/community/cubit/note_editor/note_editor.dart';
import 'package:rtu_mirea_app/community/data/note_draft_store.dart';
import 'package:rtu_mirea_app/community/view/collab_note_editor_view.dart';

class CollabNoteEditorPage extends StatelessWidget {
  const CollabNoteEditorPage({
    required this.repository,
    required this.note,
    required this.editorName,
    super.key,
  });

  final CampusRepository repository;
  final CollabNote note;
  final String editorName;

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AppBloc?>()?.state.user.id;
    return BlocProvider(
      create: (_) => NoteEditorCubit(
        repository: repository,
        note: note,
        editorName: editorName,
        currentUserId: userId,
        draftStore: userId == null || userId.isEmpty
            ? null
            : NoteDraftStore(storage: HydratedBloc.storage),
      ),
      child: Scaffold(
        backgroundColor: context.colors.canvas,
        resizeToAvoidBottomInset: true,
        body: const SafeArea(child: CollabNoteEditorView()),
      ),
    );
  }
}

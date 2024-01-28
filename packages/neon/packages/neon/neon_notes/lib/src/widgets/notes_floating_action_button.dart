import 'package:flutter/material.dart';
import 'package:neon_notes/l10n/localizations.dart';
import 'package:neon_notes/src/blocs/notes.dart';
import 'package:neon_notes/src/widgets/dialog.dart';

class NotesFloatingActionButton extends StatelessWidget {
  const NotesFloatingActionButton({
    required this.bloc,
    this.category,
    super.key,
  });

  final NotesBloc bloc;
  final String? category;

  @override
  Widget build(BuildContext context) => FloatingActionButton(
        onPressed: () async {
          final result = await showAdaptiveDialog<(String, String?)>(
            context: context,
            builder: (context) => NotesCreateNoteDialog(
              bloc: bloc,
              initialCategory: category,
            ),
          );
          if (result != null) {
            final (title, category) = result;
            bloc.createNote(
              title: title,
              category: category ?? '',
            );
          }
        },
        tooltip: NotesLocalizations.of(context).noteCreate,
        child: const Icon(Icons.add),
      );
}

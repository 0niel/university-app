import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:neon_framework/blocs.dart';
import 'package:neon_framework/utils.dart';
import 'package:neon_framework/widgets.dart';
import 'package:neon_notes/l10n/localizations.dart';
import 'package:neon_notes/src/blocs/notes.dart';
import 'package:neon_notes/src/widgets/category_select.dart';
import 'package:nextcloud/notes.dart' as notes;

/// A dialog for creating a note.
class NotesCreateNoteDialog extends StatefulWidget {
  /// Creates a new create note dialog.
  const NotesCreateNoteDialog({
    required this.bloc,
    this.initialCategory,
    super.key,
  });

  /// The active notes bloc.
  final NotesBloc bloc;

  /// The initial category of the note.
  final String? initialCategory;

  @override
  State<NotesCreateNoteDialog> createState() => _NotesCreateNoteDialogState();
}

class _NotesCreateNoteDialogState extends State<NotesCreateNoteDialog> {
  final formKey = GlobalKey<FormState>();
  final controller = TextEditingController();
  String? selectedCategory;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void submit() {
    if (formKey.currentState!.validate()) {
      Navigator.of(context).pop((controller.text, widget.initialCategory ?? selectedCategory));
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleField = Form(
      key: formKey,
      child: TextFormField(
        autofocus: true,
        controller: controller,
        decoration: InputDecoration(
          hintText: NotesLocalizations.of(context).noteTitle,
        ),
        validator: (input) => validateNotEmpty(context, input),
        onFieldSubmitted: (_) {
          submit();
        },
      ),
    );

    final folderSelector = ResultBuilder<BuiltList<notes.Note>>.behaviorSubject(
      subject: widget.bloc.notesList,
      builder: (context, notes) {
        if (notes.hasError) {
          return Center(
            child: NeonError(
              notes.error,
              onRetry: widget.bloc.refresh,
            ),
          );
        }
        if (!notes.hasData) {
          return Center(
            child: NeonLinearProgressIndicator(
              visible: notes.isLoading,
            ),
          );
        }

        return NotesCategorySelect(
          categories: notes.requireData.map((note) => note.category).toSet().toList(),
          onChanged: (category) {
            selectedCategory = category;
          },
          onSubmitted: submit,
        );
      },
    );

    return NeonDialog(
      title: Text(NotesLocalizations.of(context).noteCreate),
      content: Material(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            titleField,
            const SizedBox(height: 8),
            folderSelector,
          ],
        ),
      ),
      actions: [
        NeonDialogAction(
          isDefaultAction: true,
          onPressed: submit,
          child: Text(
            NotesLocalizations.of(context).noteCreate,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

/// A dialog for selecting a category for a note.
class NotesSelectCategoryDialog extends StatefulWidget {
  /// Creates a new category selection dialog.
  const NotesSelectCategoryDialog({
    required this.bloc,
    this.initialCategory,
    super.key,
  });

  /// The active notes bloc.
  final NotesBloc bloc;

  /// The initial category of the note.
  final String? initialCategory;

  @override
  State<NotesSelectCategoryDialog> createState() => _NotesSelectCategoryDialogState();
}

class _NotesSelectCategoryDialogState extends State<NotesSelectCategoryDialog> {
  final formKey = GlobalKey<FormState>();

  String? selectedCategory;

  void submit() {
    if (formKey.currentState!.validate()) {
      Navigator.of(context).pop(selectedCategory);
    }
  }

  @override
  Widget build(BuildContext context) {
    final folderSelector = ResultBuilder<BuiltList<notes.Note>>.behaviorSubject(
      subject: widget.bloc.notesList,
      builder: (context, notes) {
        if (notes.hasError) {
          return Center(
            child: NeonError(
              notes.error,
              onRetry: widget.bloc.refresh,
            ),
          );
        }
        if (!notes.hasData) {
          return Center(
            child: NeonLinearProgressIndicator(
              visible: notes.isLoading,
            ),
          );
        }

        return Form(
          key: formKey,
          child: NotesCategorySelect(
            categories: notes.requireData.map((note) => note.category).toSet().toList(),
            initialValue: widget.initialCategory,
            onChanged: (category) {
              selectedCategory = category;
            },
            onSubmitted: submit,
          ),
        );
      },
    );

    return NeonDialog(
      title: Text(NotesLocalizations.of(context).category),
      content: Material(
        child: folderSelector,
      ),
      actions: [
        NeonDialogAction(
          isDefaultAction: true,
          onPressed: submit,
          child: Text(
            NotesLocalizations.of(context).noteSetCategory,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

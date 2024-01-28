import 'localizations.dart';

/// The translations for English (`en`).
class NotesLocalizationsEn extends NotesLocalizations {
  NotesLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get errorChangedOnServer => 'The note has been changed on the server. Please refresh and try again';

  @override
  String get general => 'General';

  @override
  String get notes => 'Notes';

  @override
  String get note => 'Note';

  @override
  String get noteCreate => 'Create note';

  @override
  String get noteTitle => 'Title';

  @override
  String get noteSetCategory => 'Set category';

  @override
  String get noteChangeCategory => 'Change note category';

  @override
  String get noteShowEditor => 'Edit note';

  @override
  String get noteShowPreview => 'Preview note';

  @override
  String get noteStar => 'Star note';

  @override
  String get noteUnstar => 'Unstar note';

  @override
  String noteDeleteConfirm(String name) {
    return 'Are you sure you want to delete the note \'$name\'?';
  }

  @override
  String get categories => 'Categories';

  @override
  String get category => 'Category';

  @override
  String categoryNotesCount(int count) {
    return '$count notes';
  }

  @override
  String get categoryUncategorized => 'Uncategorized';

  @override
  String get optionsDefaultCategory => 'Category to show by default';

  @override
  String get optionsDefaultNoteViewType => 'How to show note';

  @override
  String get optionsDefaultNoteViewTypePreview => 'Preview';

  @override
  String get optionsDefaultNoteViewTypeEdit => 'Editor';

  @override
  String get optionsNotesSortOrder => 'Sort order of notes';

  @override
  String get optionsNotesSortProperty => 'How to sort notes';

  @override
  String get optionsNotesSortPropertyLastModified => 'Last modified';

  @override
  String get optionsNotesSortPropertyAlphabetical => 'Alphabetical';

  @override
  String get optionsCategoriesSortOrder => 'Sort order of categories';

  @override
  String get optionsCategoriesSortProperty => 'How to sort categories';

  @override
  String get optionsCategoriesSortPropertyAlphabetical => 'Alphabetical';

  @override
  String get optionsCategoriesSortPropertyNotesCount => 'Count of notes';
}

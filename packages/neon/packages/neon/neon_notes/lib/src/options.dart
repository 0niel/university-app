import 'package:neon_framework/settings.dart';
import 'package:neon_framework/sort_box.dart';
import 'package:neon_notes/l10n/localizations.dart';

class NotesOptions extends AppImplementationOptions {
  NotesOptions(super.storage) {
    super.categories = [
      generalCategory,
      notesCategory,
      categoriesCategory,
    ];
    super.options = [
      defaultCategoryOption,
      defaultNoteViewTypeOption,
      notesSortPropertyOption,
      notesSortBoxOrderOption,
      categoriesSortPropertyOption,
      categoriesSortBoxOrderOption,
    ];
  }

  final generalCategory = OptionsCategory(
    name: (context) => NotesLocalizations.of(context).general,
  );

  final notesCategory = OptionsCategory(
    name: (context) => NotesLocalizations.of(context).notes,
  );

  final categoriesCategory = OptionsCategory(
    name: (context) => NotesLocalizations.of(context).categories,
  );

  late final defaultCategoryOption = SelectOption<DefaultCategory>(
    storage: super.storage,
    category: generalCategory,
    key: NotesOptionKeys.defaultCategory,
    label: (context) => NotesLocalizations.of(context).optionsDefaultCategory,
    defaultValue: DefaultCategory.notes,
    values: {
      DefaultCategory.notes: (context) => NotesLocalizations.of(context).notes,
      DefaultCategory.categories: (context) => NotesLocalizations.of(context).categories,
    },
  );

  late final defaultNoteViewTypeOption = SelectOption<DefaultNoteViewType>(
    storage: super.storage,
    category: generalCategory,
    key: NotesOptionKeys.defaultNoteViewType,
    label: (context) => NotesLocalizations.of(context).optionsDefaultNoteViewType,
    defaultValue: DefaultNoteViewType.preview,
    values: {
      DefaultNoteViewType.preview: (context) => NotesLocalizations.of(context).optionsDefaultNoteViewTypePreview,
      DefaultNoteViewType.edit: (context) => NotesLocalizations.of(context).optionsDefaultNoteViewTypeEdit,
    },
  );

  late final notesSortPropertyOption = SelectOption<NotesSortProperty>(
    storage: super.storage,
    category: notesCategory,
    key: NotesOptionKeys.notesSortProperty,
    label: (context) => NotesLocalizations.of(context).optionsNotesSortProperty,
    defaultValue: NotesSortProperty.lastModified,
    values: {
      NotesSortProperty.lastModified: (context) => NotesLocalizations.of(context).optionsNotesSortPropertyLastModified,
      NotesSortProperty.alphabetical: (context) => NotesLocalizations.of(context).optionsNotesSortPropertyAlphabetical,
    },
  );

  late final notesSortBoxOrderOption = SelectOption<SortBoxOrder>(
    storage: super.storage,
    category: notesCategory,
    key: NotesOptionKeys.notesSortBoxOrder,
    label: (context) => NotesLocalizations.of(context).optionsNotesSortOrder,
    defaultValue: SortBoxOrder.descending,
    values: sortBoxOrderOptionValues,
  );

  late final categoriesSortPropertyOption = SelectOption<CategoriesSortProperty>(
    storage: super.storage,
    category: categoriesCategory,
    key: NotesOptionKeys.categoriesSortProperty,
    label: (context) => NotesLocalizations.of(context).optionsCategoriesSortProperty,
    defaultValue: CategoriesSortProperty.alphabetical,
    values: {
      CategoriesSortProperty.alphabetical: (context) =>
          NotesLocalizations.of(context).optionsCategoriesSortPropertyAlphabetical,
      CategoriesSortProperty.notesCount: (context) =>
          NotesLocalizations.of(context).optionsCategoriesSortPropertyNotesCount,
    },
  );

  late final categoriesSortBoxOrderOption = SelectOption<SortBoxOrder>(
    storage: super.storage,
    category: categoriesCategory,
    key: NotesOptionKeys.categoriesSortBoxOrder,
    label: (context) => NotesLocalizations.of(context).optionsCategoriesSortOrder,
    defaultValue: SortBoxOrder.ascending,
    values: sortBoxOrderOptionValues,
  );
}

enum NotesOptionKeys implements Storable {
  defaultCategory._('default-category'),
  defaultNoteViewType._('default-note-view-type'),
  notesSortProperty._('notes-sort-property'),
  notesSortBoxOrder._('notes-sort-box-order'),
  categoriesSortProperty._('categories-sort-property'),
  categoriesSortBoxOrder._('categories-sort-box-order');

  const NotesOptionKeys._(this.value);

  @override
  final String value;
}

enum DefaultNoteViewType {
  preview,
  edit,
}

enum NotesSortProperty {
  lastModified,
  alphabetical,
  favorite,
}

enum CategoriesSortProperty {
  alphabetical,
  notesCount,
}

enum DefaultCategory {
  notes,
  categories,
}

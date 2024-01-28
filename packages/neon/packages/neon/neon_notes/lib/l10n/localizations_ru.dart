import 'localizations.dart';

/// The translations for Russian (`ru`).
class NotesLocalizationsRu extends NotesLocalizations {
  NotesLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get errorChangedOnServer =>
      'Заметка была изменена на сервере. Пожалуйста, обновите страницу и попробуйте снова';

  @override
  String get general => 'Общее';

  @override
  String get notes => 'Заметки';

  @override
  String get note => 'Заметка';

  @override
  String get noteCreate => 'Создать заметку';

  @override
  String get noteTitle => 'Заголовок';

  @override
  String get noteSetCategory => 'Установить категорию';

  @override
  String get noteChangeCategory => 'Изменить категорию заметки';

  @override
  String get noteShowEditor => 'Редактировать заметку';

  @override
  String get noteShowPreview => 'Предпросмотр заметки';

  @override
  String get noteStar => 'Отметить заметку звездой';

  @override
  String get noteUnstar => 'Убрать звезду с заметки';

  @override
  String noteDeleteConfirm(String name) {
    return 'Вы уверены, что хотите удалить заметку \'$name\'?';
  }

  @override
  String get categories => 'Категории';

  @override
  String get category => 'Категория';

  @override
  String categoryNotesCount(int count) {
    return '$count записок';
  }

  @override
  String get categoryUncategorized => 'Без категории';

  @override
  String get optionsDefaultCategory => 'Категория для отображения по умолчанию';

  @override
  String get optionsDefaultNoteViewType => 'Как показывать заметку';

  @override
  String get optionsDefaultNoteViewTypePreview => 'Предпросмотр';

  @override
  String get optionsDefaultNoteViewTypeEdit => 'Редактор';

  @override
  String get optionsNotesSortOrder => 'Порядок сортировки записок';

  @override
  String get optionsNotesSortProperty => 'Метод сортировки записок';

  @override
  String get optionsNotesSortPropertyLastModified => 'Последние изменения';

  @override
  String get optionsNotesSortPropertyAlphabetical => 'По алфавиту';

  @override
  String get optionsCategoriesSortOrder => 'Порядок сортировки категорий';

  @override
  String get optionsCategoriesSortProperty => 'Метод сортировки категорий';

  @override
  String get optionsCategoriesSortPropertyAlphabetical => 'По алфавиту';

  @override
  String get optionsCategoriesSortPropertyNotesCount => 'Количество записок';
}

import 'localizations.dart';

/// The translations for Russian (`ru`).
class NewsLocalizationsRu extends NewsLocalizations {
  NewsLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get actionDelete => 'Удалить';

  @override
  String get actionRename => 'Переименовать';

  @override
  String get actionMove => 'Переместить';

  @override
  String get general => 'Общее';

  @override
  String get folder => 'Папка';

  @override
  String get folders => 'Папки';

  @override
  String get folderRoot => 'Корневая папка';

  @override
  String get folderCreate => 'Создать папку';

  @override
  String get folderCreateName => 'Имя папки';

  @override
  String folderDeleteConfirm(String name) {
    return 'Вы уверены, что хотите удалить папку \'$name\'?';
  }

  @override
  String get actionDeleteTitle => 'Удалить навсегда?';

  @override
  String get folderRename => 'Переименовать папку';

  @override
  String get feeds => 'Ленты';

  @override
  String get feedAdd => 'Добавить ленту';

  @override
  String feedRemoveConfirm(String name) {
    return 'Вы уверены, что хотите удалить ленту \'$name\'?';
  }

  @override
  String get feedMove => 'Переместить ленту';

  @override
  String get feedRename => 'Переименовать ленту';

  @override
  String get feedShowURL => 'Показать URL';

  @override
  String get feedCopyURL => 'Скопировать URL';

  @override
  String get feedCopiedURL => 'URL скопирован в буфер обмена';

  @override
  String get feedShowErrorMessage => 'Показать сообщение об ошибке';

  @override
  String get feedCopyErrorMessage => 'Скопировать сообщение об ошибке';

  @override
  String get feedCopiedErrorMessage => 'Сообщение об ошибке скопировано в буфер обмена';

  @override
  String get articles => 'Статьи';

  @override
  String articlesUnread(int count) {
    return '$count непрочитанных';
  }

  @override
  String get articlesFilterAll => 'Все';

  @override
  String get articlesFilterUnread => 'Непрочитанные';

  @override
  String get articlesFilterStarred => 'Избранные';

  @override
  String get articleStar => 'Добавить статью в избранное';

  @override
  String get articleUnstar => 'Убрать статью из избранного';

  @override
  String get articleMarkRead => 'Отметить статью как прочитанную';

  @override
  String get articleMarkUnread => 'Отметить статью как непрочитанную';

  @override
  String get articleOpenLink => 'Открыть в браузере';

  @override
  String get articleShare => 'Поделиться';

  @override
  String get optionsDefaultCategory => 'Категория для отображения по умолчанию';

  @override
  String get optionsArticleViewType => 'Как открывать статью';

  @override
  String get optionsArticleViewTypeDirect => 'Показать текст напрямую';

  @override
  String get optionsArticleViewTypeInternalBrowser => 'Открыть во внутреннем браузере';

  @override
  String get optionsArticleViewTypeExternalBrowser => 'Открыть во внешнем браузере';

  @override
  String get optionsArticleDisableMarkAsReadTimeout => 'Отмечать статьи прочитанными немедленно';

  @override
  String get optionsDefaultArticlesFilter => 'Статьи для отображения по умолчанию';

  @override
  String get optionsArticlesSortProperty => 'Как сортировать статьи';

  @override
  String get optionsArticlesSortPropertyPublishDate => 'Дата публикации';

  @override
  String get optionsArticlesSortPropertyAlphabetical => 'По алфавиту';

  @override
  String get optionsArticlesSortPropertyFeed => 'Лента';

  @override
  String get optionsArticlesSortOrder => 'Порядок сортировки статей';

  @override
  String get optionsFeedsSortProperty => 'Как сортировать ленты';

  @override
  String get optionsFeedsSortPropertyAlphabetical => 'По алфавиту';

  @override
  String get optionsFeedsSortPropertyUnreadCount => 'Количество непрочитанных';

  @override
  String get optionsFeedsSortOrder => 'Порядок стировки лент';

  @override
  String get optionsFoldersSortProperty => 'Как сортировать папки';

  @override
  String get optionsFoldersSortPropertyAlphabetical => 'По алфавиту';

  @override
  String get optionsFoldersSortPropertyUnreadCount => 'Количество непрочитх';

  @override
  String get optionsFoldersSortOrder => 'Порядок сортировки папок';

  @override
  String get optionsDefaultFolderViewType => 'Что отображать вначале при открытии папки';
}

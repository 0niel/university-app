import 'localizations.dart';

/// The translations for English (`en`).
class NewsLocalizationsEn extends NewsLocalizations {
  NewsLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionRename => 'Rename';

  @override
  String get actionMove => 'Move';

  @override
  String get general => 'General';

  @override
  String get folder => 'Folder';

  @override
  String get folders => 'Folders';

  @override
  String get folderRoot => 'Root Folder';

  @override
  String get folderCreate => 'Create folder';

  @override
  String get folderCreateName => 'Folder name';

  @override
  String folderDeleteConfirm(String name) {
    return 'Are you sure you want to delete the folder \'$name\'?';
  }

  @override
  String get actionDeleteTitle => 'Permanently delete?';

  @override
  String get folderRename => 'Rename folder';

  @override
  String get feeds => 'Feeds';

  @override
  String get feedAdd => 'Add feed';

  @override
  String feedRemoveConfirm(String name) {
    return 'Are you sure you want to remove the feed \'$name\'?';
  }

  @override
  String get feedMove => 'Move feed';

  @override
  String get feedRename => 'Rename feed';

  @override
  String get feedShowURL => 'Show URL';

  @override
  String get feedCopyURL => 'Copy URL';

  @override
  String get feedCopiedURL => 'URL copied to clipboard';

  @override
  String get feedShowErrorMessage => 'Show error message';

  @override
  String get feedCopyErrorMessage => 'Copy error message';

  @override
  String get feedCopiedErrorMessage => 'Error message copied to clipboard';

  @override
  String get articles => 'Articles';

  @override
  String articlesUnread(int count) {
    return '$count unread';
  }

  @override
  String get articlesFilterAll => 'All';

  @override
  String get articlesFilterUnread => 'Unread';

  @override
  String get articlesFilterStarred => 'Starred';

  @override
  String get articleStar => 'Star article';

  @override
  String get articleUnstar => 'Unstar article';

  @override
  String get articleMarkRead => 'Mark article as read';

  @override
  String get articleMarkUnread => 'Mark article as unread';

  @override
  String get articleOpenLink => 'Open in browser';

  @override
  String get articleShare => 'Share';

  @override
  String get optionsDefaultCategory => 'Category to show by default';

  @override
  String get optionsArticleViewType => 'How to open article';

  @override
  String get optionsArticleViewTypeDirect => 'Show text directly';

  @override
  String get optionsArticleViewTypeInternalBrowser => 'Open in internal browser';

  @override
  String get optionsArticleViewTypeExternalBrowser => 'Open in external browser';

  @override
  String get optionsArticleDisableMarkAsReadTimeout => 'Mark articles as read instantly';

  @override
  String get optionsDefaultArticlesFilter => 'Articles to show by default';

  @override
  String get optionsArticlesSortProperty => 'How to sort articles';

  @override
  String get optionsArticlesSortPropertyPublishDate => 'Publish date';

  @override
  String get optionsArticlesSortPropertyAlphabetical => 'Alphabetical';

  @override
  String get optionsArticlesSortPropertyFeed => 'Feed';

  @override
  String get optionsArticlesSortOrder => 'Sort order of articles';

  @override
  String get optionsFeedsSortProperty => 'How to sort feeds';

  @override
  String get optionsFeedsSortPropertyAlphabetical => 'Alphabetical';

  @override
  String get optionsFeedsSortPropertyUnreadCount => 'Unread count';

  @override
  String get optionsFeedsSortOrder => 'Sort order of feeds';

  @override
  String get optionsFoldersSortProperty => 'How to sort folders';

  @override
  String get optionsFoldersSortPropertyAlphabetical => 'Alphabetical';

  @override
  String get optionsFoldersSortPropertyUnreadCount => 'Unread count';

  @override
  String get optionsFoldersSortOrder => 'Sort order of folders';

  @override
  String get optionsDefaultFolderViewType => 'What should be shown first when opening a folder';
}

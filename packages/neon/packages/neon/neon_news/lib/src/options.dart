import 'package:neon_framework/platform.dart';
import 'package:neon_framework/settings.dart';
import 'package:neon_framework/sort_box.dart';
import 'package:neon_news/l10n/localizations.dart';
import 'package:neon_news/src/blocs/articles.dart';

class NewsOptions extends AppImplementationOptions {
  NewsOptions(super.storage) {
    super.categories = [
      generalCategory,
      articlesCategory,
      foldersCategory,
      feedsCategory,
    ];
    super.options = [
      defaultCategoryOption,
      articleViewTypeOption,
      articleDisableMarkAsReadTimeoutOption,
      defaultArticlesFilterOption,
      articlesSortPropertyOption,
      articlesSortBoxOrderOption,
      foldersSortPropertyOption,
      foldersSortBoxOrderOption,
      defaultFolderViewTypeOption,
      feedsSortPropertyOption,
      feedsSortBoxOrderOption,
    ];
  }

  final generalCategory = OptionsCategory(
    name: (context) => NewsLocalizations.of(context).general,
  );

  final articlesCategory = OptionsCategory(
    name: (context) => NewsLocalizations.of(context).articles,
  );

  final foldersCategory = OptionsCategory(
    name: (context) => NewsLocalizations.of(context).folders,
  );

  final feedsCategory = OptionsCategory(
    name: (context) => NewsLocalizations.of(context).feeds,
  );

  late final defaultCategoryOption = SelectOption<DefaultCategory>(
    storage: super.storage,
    category: generalCategory,
    key: NewsOptionKeys.defaultCategory,
    label: (context) => NewsLocalizations.of(context).optionsDefaultCategory,
    defaultValue: DefaultCategory.articles,
    values: {
      DefaultCategory.articles: (context) => NewsLocalizations.of(context).articles,
      DefaultCategory.folders: (context) => NewsLocalizations.of(context).folders,
      DefaultCategory.feeds: (context) => NewsLocalizations.of(context).feeds,
    },
  );

  late final articleViewTypeOption = SelectOption<ArticleViewType>(
    storage: super.storage,
    category: articlesCategory,
    key: NewsOptionKeys.articleViewType,
    label: (context) => NewsLocalizations.of(context).optionsArticleViewType,
    defaultValue: ArticleViewType.direct,
    values: {
      ArticleViewType.direct: (context) => NewsLocalizations.of(context).optionsArticleViewTypeDirect,
      if (NeonPlatform.instance.canUseWebView)
        ArticleViewType.internalBrowser: (context) =>
            NewsLocalizations.of(context).optionsArticleViewTypeInternalBrowser,
      ArticleViewType.externalBrowser: (context) => NewsLocalizations.of(context).optionsArticleViewTypeExternalBrowser,
    },
  );

  late final articleDisableMarkAsReadTimeoutOption = ToggleOption(
    storage: super.storage,
    category: articlesCategory,
    key: NewsOptionKeys.articleDisableMarkAsReadTimeout,
    label: (context) => NewsLocalizations.of(context).optionsArticleDisableMarkAsReadTimeout,
    defaultValue: false,
  );

  late final defaultArticlesFilterOption = SelectOption<FilterType>(
    storage: super.storage,
    category: articlesCategory,
    key: NewsOptionKeys.defaultArticlesFilter,
    label: (context) => NewsLocalizations.of(context).optionsDefaultArticlesFilter,
    defaultValue: FilterType.unread,
    values: {
      FilterType.all: (context) => NewsLocalizations.of(context).articlesFilterAll,
      FilterType.unread: (context) => NewsLocalizations.of(context).articlesFilterUnread,
      FilterType.starred: (context) => NewsLocalizations.of(context).articlesFilterStarred,
    },
  );

  late final articlesSortPropertyOption = SelectOption<ArticlesSortProperty>(
    storage: super.storage,
    category: articlesCategory,
    key: NewsOptionKeys.articlesSortProperty,
    label: (context) => NewsLocalizations.of(context).optionsArticlesSortProperty,
    defaultValue: ArticlesSortProperty.publishDate,
    values: {
      ArticlesSortProperty.publishDate: (context) =>
          NewsLocalizations.of(context).optionsArticlesSortPropertyPublishDate,
      ArticlesSortProperty.alphabetical: (context) =>
          NewsLocalizations.of(context).optionsArticlesSortPropertyAlphabetical,
      ArticlesSortProperty.byFeed: (context) => NewsLocalizations.of(context).optionsArticlesSortPropertyFeed,
    },
  );

  late final articlesSortBoxOrderOption = SelectOption<SortBoxOrder>(
    storage: super.storage,
    category: articlesCategory,
    key: NewsOptionKeys.articlesSortBoxOrder,
    label: (context) => NewsLocalizations.of(context).optionsArticlesSortOrder,
    defaultValue: SortBoxOrder.descending,
    values: sortBoxOrderOptionValues,
  );

  late final foldersSortPropertyOption = SelectOption<FoldersSortProperty>(
    storage: super.storage,
    category: foldersCategory,
    key: NewsOptionKeys.foldersSortProperty,
    label: (context) => NewsLocalizations.of(context).optionsFoldersSortProperty,
    defaultValue: FoldersSortProperty.alphabetical,
    values: {
      FoldersSortProperty.alphabetical: (context) =>
          NewsLocalizations.of(context).optionsFoldersSortPropertyAlphabetical,
      FoldersSortProperty.unreadCount: (context) => NewsLocalizations.of(context).optionsFoldersSortPropertyUnreadCount,
    },
  );

  late final foldersSortBoxOrderOption = SelectOption<SortBoxOrder>(
    storage: super.storage,
    category: foldersCategory,
    key: NewsOptionKeys.foldersSortBoxOrder,
    label: (context) => NewsLocalizations.of(context).optionsFoldersSortOrder,
    defaultValue: SortBoxOrder.ascending,
    values: sortBoxOrderOptionValues,
  );

  late final defaultFolderViewTypeOption = SelectOption<DefaultFolderViewType>(
    storage: super.storage,
    category: foldersCategory,
    key: NewsOptionKeys.defaultFolderViewType,
    label: (context) => NewsLocalizations.of(context).optionsDefaultFolderViewType,
    defaultValue: DefaultFolderViewType.articles,
    values: {
      DefaultFolderViewType.articles: (context) => NewsLocalizations.of(context).articles,
      DefaultFolderViewType.feeds: (context) => NewsLocalizations.of(context).feeds,
    },
  );

  late final feedsSortPropertyOption = SelectOption<FeedsSortProperty>(
    storage: super.storage,
    category: feedsCategory,
    key: NewsOptionKeys.feedsSortProperty,
    label: (context) => NewsLocalizations.of(context).optionsFeedsSortProperty,
    defaultValue: FeedsSortProperty.alphabetical,
    values: {
      FeedsSortProperty.alphabetical: (context) => NewsLocalizations.of(context).optionsFeedsSortPropertyAlphabetical,
      FeedsSortProperty.unreadCount: (context) => NewsLocalizations.of(context).optionsFeedsSortPropertyUnreadCount,
    },
  );

  late final feedsSortBoxOrderOption = SelectOption<SortBoxOrder>(
    storage: super.storage,
    category: feedsCategory,
    key: NewsOptionKeys.feedsSortBoxOrder,
    label: (context) => NewsLocalizations.of(context).optionsFeedsSortOrder,
    defaultValue: SortBoxOrder.ascending,
    values: sortBoxOrderOptionValues,
  );
}

enum NewsOptionKeys implements Storable {
  defaultCategory._('default-category'),
  articleViewType._('article-view-type'),
  articleDisableMarkAsReadTimeout._('article-disable-mark-as-read-timeout'),
  defaultArticlesFilter._('default-articles-filter'),
  articlesSortProperty._('articles-sort-property'),
  articlesSortBoxOrder._('articles-sort-box-order'),
  foldersSortProperty._('folders-sort-property'),
  foldersSortBoxOrder._('folders-sort-box-order'),
  defaultFolderViewType._('default-folder-view-type'),
  feedsSortProperty._('feeds-sort-property'),
  feedsSortBoxOrder._('feeds-sort-box-order');

  const NewsOptionKeys._(this.value);

  @override
  final String value;
}

enum DefaultCategory {
  articles,
  folders,
  feeds,
}

enum ArticleViewType {
  direct,
  internalBrowser,
  externalBrowser,
}

enum ArticlesSortProperty {
  publishDate,
  alphabetical,
  byFeed,
}

enum FoldersSortProperty {
  alphabetical,
  unreadCount,
}

enum DefaultFolderViewType {
  articles,
  feeds,
}

enum FeedsSortProperty {
  alphabetical,
  unreadCount,
}

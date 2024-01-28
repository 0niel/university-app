import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'localizations_en.dart';
import 'localizations_ru.dart';

/// Callers can lookup localized strings with an instance of NewsLocalizations
/// returned by `NewsLocalizations.of(context)`.
///
/// Applications need to include `NewsLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: NewsLocalizations.localizationsDelegates,
///   supportedLocales: NewsLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the NewsLocalizations.supportedLocales
/// property.
abstract class NewsLocalizations {
  NewsLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static NewsLocalizations of(BuildContext context) {
    return Localizations.of<NewsLocalizations>(context, NewsLocalizations)!;
  }

  static const LocalizationsDelegate<NewsLocalizations> delegate = _NewsLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en'), Locale('ru')];

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @actionRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get actionRename;

  /// No description provided for @actionMove.
  ///
  /// In en, this message translates to:
  /// **'Move'**
  String get actionMove;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @folder.
  ///
  /// In en, this message translates to:
  /// **'Folder'**
  String get folder;

  /// No description provided for @folders.
  ///
  /// In en, this message translates to:
  /// **'Folders'**
  String get folders;

  /// No description provided for @folderRoot.
  ///
  /// In en, this message translates to:
  /// **'Root Folder'**
  String get folderRoot;

  /// No description provided for @folderCreate.
  ///
  /// In en, this message translates to:
  /// **'Create folder'**
  String get folderCreate;

  /// No description provided for @folderCreateName.
  ///
  /// In en, this message translates to:
  /// **'Folder name'**
  String get folderCreateName;

  /// No description provided for @folderDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the folder \'{name}\'?'**
  String folderDeleteConfirm(String name);

  /// No description provided for @actionDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete?'**
  String get actionDeleteTitle;

  /// No description provided for @folderRename.
  ///
  /// In en, this message translates to:
  /// **'Rename folder'**
  String get folderRename;

  /// No description provided for @feeds.
  ///
  /// In en, this message translates to:
  /// **'Feeds'**
  String get feeds;

  /// No description provided for @feedAdd.
  ///
  /// In en, this message translates to:
  /// **'Add feed'**
  String get feedAdd;

  /// No description provided for @feedRemoveConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove the feed \'{name}\'?'**
  String feedRemoveConfirm(String name);

  /// No description provided for @feedMove.
  ///
  /// In en, this message translates to:
  /// **'Move feed'**
  String get feedMove;

  /// No description provided for @feedRename.
  ///
  /// In en, this message translates to:
  /// **'Rename feed'**
  String get feedRename;

  /// No description provided for @feedShowURL.
  ///
  /// In en, this message translates to:
  /// **'Show URL'**
  String get feedShowURL;

  /// No description provided for @feedCopyURL.
  ///
  /// In en, this message translates to:
  /// **'Copy URL'**
  String get feedCopyURL;

  /// No description provided for @feedCopiedURL.
  ///
  /// In en, this message translates to:
  /// **'URL copied to clipboard'**
  String get feedCopiedURL;

  /// No description provided for @feedShowErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Show error message'**
  String get feedShowErrorMessage;

  /// No description provided for @feedCopyErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Copy error message'**
  String get feedCopyErrorMessage;

  /// No description provided for @feedCopiedErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Error message copied to clipboard'**
  String get feedCopiedErrorMessage;

  /// No description provided for @articles.
  ///
  /// In en, this message translates to:
  /// **'Articles'**
  String get articles;

  /// No description provided for @articlesUnread.
  ///
  /// In en, this message translates to:
  /// **'{count} unread'**
  String articlesUnread(int count);

  /// No description provided for @articlesFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get articlesFilterAll;

  /// No description provided for @articlesFilterUnread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get articlesFilterUnread;

  /// No description provided for @articlesFilterStarred.
  ///
  /// In en, this message translates to:
  /// **'Starred'**
  String get articlesFilterStarred;

  /// No description provided for @articleStar.
  ///
  /// In en, this message translates to:
  /// **'Star article'**
  String get articleStar;

  /// No description provided for @articleUnstar.
  ///
  /// In en, this message translates to:
  /// **'Unstar article'**
  String get articleUnstar;

  /// No description provided for @articleMarkRead.
  ///
  /// In en, this message translates to:
  /// **'Mark article as read'**
  String get articleMarkRead;

  /// No description provided for @articleMarkUnread.
  ///
  /// In en, this message translates to:
  /// **'Mark article as unread'**
  String get articleMarkUnread;

  /// No description provided for @articleOpenLink.
  ///
  /// In en, this message translates to:
  /// **'Open in browser'**
  String get articleOpenLink;

  /// No description provided for @articleShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get articleShare;

  /// No description provided for @optionsDefaultCategory.
  ///
  /// In en, this message translates to:
  /// **'Category to show by default'**
  String get optionsDefaultCategory;

  /// No description provided for @optionsArticleViewType.
  ///
  /// In en, this message translates to:
  /// **'How to open article'**
  String get optionsArticleViewType;

  /// No description provided for @optionsArticleViewTypeDirect.
  ///
  /// In en, this message translates to:
  /// **'Show text directly'**
  String get optionsArticleViewTypeDirect;

  /// No description provided for @optionsArticleViewTypeInternalBrowser.
  ///
  /// In en, this message translates to:
  /// **'Open in internal browser'**
  String get optionsArticleViewTypeInternalBrowser;

  /// No description provided for @optionsArticleViewTypeExternalBrowser.
  ///
  /// In en, this message translates to:
  /// **'Open in external browser'**
  String get optionsArticleViewTypeExternalBrowser;

  /// No description provided for @optionsArticleDisableMarkAsReadTimeout.
  ///
  /// In en, this message translates to:
  /// **'Mark articles as read instantly'**
  String get optionsArticleDisableMarkAsReadTimeout;

  /// No description provided for @optionsDefaultArticlesFilter.
  ///
  /// In en, this message translates to:
  /// **'Articles to show by default'**
  String get optionsDefaultArticlesFilter;

  /// No description provided for @optionsArticlesSortProperty.
  ///
  /// In en, this message translates to:
  /// **'How to sort articles'**
  String get optionsArticlesSortProperty;

  /// No description provided for @optionsArticlesSortPropertyPublishDate.
  ///
  /// In en, this message translates to:
  /// **'Publish date'**
  String get optionsArticlesSortPropertyPublishDate;

  /// No description provided for @optionsArticlesSortPropertyAlphabetical.
  ///
  /// In en, this message translates to:
  /// **'Alphabetical'**
  String get optionsArticlesSortPropertyAlphabetical;

  /// No description provided for @optionsArticlesSortPropertyFeed.
  ///
  /// In en, this message translates to:
  /// **'Feed'**
  String get optionsArticlesSortPropertyFeed;

  /// No description provided for @optionsArticlesSortOrder.
  ///
  /// In en, this message translates to:
  /// **'Sort order of articles'**
  String get optionsArticlesSortOrder;

  /// No description provided for @optionsFeedsSortProperty.
  ///
  /// In en, this message translates to:
  /// **'How to sort feeds'**
  String get optionsFeedsSortProperty;

  /// No description provided for @optionsFeedsSortPropertyAlphabetical.
  ///
  /// In en, this message translates to:
  /// **'Alphabetical'**
  String get optionsFeedsSortPropertyAlphabetical;

  /// No description provided for @optionsFeedsSortPropertyUnreadCount.
  ///
  /// In en, this message translates to:
  /// **'Unread count'**
  String get optionsFeedsSortPropertyUnreadCount;

  /// No description provided for @optionsFeedsSortOrder.
  ///
  /// In en, this message translates to:
  /// **'Sort order of feeds'**
  String get optionsFeedsSortOrder;

  /// No description provided for @optionsFoldersSortProperty.
  ///
  /// In en, this message translates to:
  /// **'How to sort folders'**
  String get optionsFoldersSortProperty;

  /// No description provided for @optionsFoldersSortPropertyAlphabetical.
  ///
  /// In en, this message translates to:
  /// **'Alphabetical'**
  String get optionsFoldersSortPropertyAlphabetical;

  /// No description provided for @optionsFoldersSortPropertyUnreadCount.
  ///
  /// In en, this message translates to:
  /// **'Unread count'**
  String get optionsFoldersSortPropertyUnreadCount;

  /// No description provided for @optionsFoldersSortOrder.
  ///
  /// In en, this message translates to:
  /// **'Sort order of folders'**
  String get optionsFoldersSortOrder;

  /// No description provided for @optionsDefaultFolderViewType.
  ///
  /// In en, this message translates to:
  /// **'What should be shown first when opening a folder'**
  String get optionsDefaultFolderViewType;
}

class _NewsLocalizationsDelegate extends LocalizationsDelegate<NewsLocalizations> {
  const _NewsLocalizationsDelegate();

  @override
  Future<NewsLocalizations> load(Locale locale) {
    return SynchronousFuture<NewsLocalizations>(lookupNewsLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_NewsLocalizationsDelegate old) => false;
}

NewsLocalizations lookupNewsLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return NewsLocalizationsEn();
    case 'ru':
      return NewsLocalizationsRu();
  }

  throw FlutterError('NewsLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

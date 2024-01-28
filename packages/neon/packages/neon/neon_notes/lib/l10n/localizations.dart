import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'localizations_en.dart';
import 'localizations_ru.dart';

/// Callers can lookup localized strings with an instance of NotesLocalizations
/// returned by `NotesLocalizations.of(context)`.
///
/// Applications need to include `NotesLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: NotesLocalizations.localizationsDelegates,
///   supportedLocales: NotesLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the NotesLocalizations.supportedLocales
/// property.
abstract class NotesLocalizations {
  NotesLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static NotesLocalizations of(BuildContext context) {
    return Localizations.of<NotesLocalizations>(context, NotesLocalizations)!;
  }

  static const LocalizationsDelegate<NotesLocalizations> delegate = _NotesLocalizationsDelegate();

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

  /// No description provided for @errorChangedOnServer.
  ///
  /// In en, this message translates to:
  /// **'The note has been changed on the server. Please refresh and try again'**
  String get errorChangedOnServer;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @noteCreate.
  ///
  /// In en, this message translates to:
  /// **'Create note'**
  String get noteCreate;

  /// No description provided for @noteTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get noteTitle;

  /// No description provided for @noteSetCategory.
  ///
  /// In en, this message translates to:
  /// **'Set category'**
  String get noteSetCategory;

  /// No description provided for @noteChangeCategory.
  ///
  /// In en, this message translates to:
  /// **'Change note category'**
  String get noteChangeCategory;

  /// No description provided for @noteShowEditor.
  ///
  /// In en, this message translates to:
  /// **'Edit note'**
  String get noteShowEditor;

  /// No description provided for @noteShowPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview note'**
  String get noteShowPreview;

  /// No description provided for @noteStar.
  ///
  /// In en, this message translates to:
  /// **'Star note'**
  String get noteStar;

  /// No description provided for @noteUnstar.
  ///
  /// In en, this message translates to:
  /// **'Unstar note'**
  String get noteUnstar;

  /// No description provided for @noteDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the note \'{name}\'?'**
  String noteDeleteConfirm(String name);

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @categoryNotesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} notes'**
  String categoryNotesCount(int count);

  /// No description provided for @categoryUncategorized.
  ///
  /// In en, this message translates to:
  /// **'Uncategorized'**
  String get categoryUncategorized;

  /// No description provided for @optionsDefaultCategory.
  ///
  /// In en, this message translates to:
  /// **'Category to show by default'**
  String get optionsDefaultCategory;

  /// No description provided for @optionsDefaultNoteViewType.
  ///
  /// In en, this message translates to:
  /// **'How to show note'**
  String get optionsDefaultNoteViewType;

  /// No description provided for @optionsDefaultNoteViewTypePreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get optionsDefaultNoteViewTypePreview;

  /// No description provided for @optionsDefaultNoteViewTypeEdit.
  ///
  /// In en, this message translates to:
  /// **'Editor'**
  String get optionsDefaultNoteViewTypeEdit;

  /// No description provided for @optionsNotesSortOrder.
  ///
  /// In en, this message translates to:
  /// **'Sort order of notes'**
  String get optionsNotesSortOrder;

  /// No description provided for @optionsNotesSortProperty.
  ///
  /// In en, this message translates to:
  /// **'How to sort notes'**
  String get optionsNotesSortProperty;

  /// No description provided for @optionsNotesSortPropertyLastModified.
  ///
  /// In en, this message translates to:
  /// **'Last modified'**
  String get optionsNotesSortPropertyLastModified;

  /// No description provided for @optionsNotesSortPropertyAlphabetical.
  ///
  /// In en, this message translates to:
  /// **'Alphabetical'**
  String get optionsNotesSortPropertyAlphabetical;

  /// No description provided for @optionsCategoriesSortOrder.
  ///
  /// In en, this message translates to:
  /// **'Sort order of categories'**
  String get optionsCategoriesSortOrder;

  /// No description provided for @optionsCategoriesSortProperty.
  ///
  /// In en, this message translates to:
  /// **'How to sort categories'**
  String get optionsCategoriesSortProperty;

  /// No description provided for @optionsCategoriesSortPropertyAlphabetical.
  ///
  /// In en, this message translates to:
  /// **'Alphabetical'**
  String get optionsCategoriesSortPropertyAlphabetical;

  /// No description provided for @optionsCategoriesSortPropertyNotesCount.
  ///
  /// In en, this message translates to:
  /// **'Count of notes'**
  String get optionsCategoriesSortPropertyNotesCount;
}

class _NotesLocalizationsDelegate extends LocalizationsDelegate<NotesLocalizations> {
  const _NotesLocalizationsDelegate();

  @override
  Future<NotesLocalizations> load(Locale locale) {
    return SynchronousFuture<NotesLocalizations>(lookupNotesLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_NotesLocalizationsDelegate old) => false;
}

NotesLocalizations lookupNotesLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return NotesLocalizationsEn();
    case 'ru':
      return NotesLocalizationsRu();
  }

  throw FlutterError('NotesLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

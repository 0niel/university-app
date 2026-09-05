import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// Title for the schedule page
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get scheduleAppBarTitle;

  /// Error message when loading fails
  ///
  /// In en, this message translates to:
  /// **'Loading error'**
  String get loadingError;

  /// Title for image viewer
  ///
  /// In en, this message translates to:
  /// **'Image viewer'**
  String get imageViewer;

  /// Button text to select a date
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// Button text to select date range
  ///
  /// In en, this message translates to:
  /// **'Select dates'**
  String get selectDates;

  /// Tooltip for enabling comparison mode
  ///
  /// In en, this message translates to:
  /// **'Enable comparison mode'**
  String get enableComparisonMode;

  /// Tooltip for disabling comparison mode
  ///
  /// In en, this message translates to:
  /// **'Disable comparison mode'**
  String get disableComparisonMode;

  /// Button text for comparing schedules
  ///
  /// In en, this message translates to:
  /// **'Compare schedules'**
  String get compareSchedules;

  /// Message when there are no classes
  ///
  /// In en, this message translates to:
  /// **'No classes today'**
  String get noClassesToday;

  /// Placeholder for time selection
  ///
  /// In en, this message translates to:
  /// **'Select time'**
  String get selectTime;

  /// Button text to clear selection
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// Calendar format - month view
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// Calendar format - week view
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get week;

  /// Button text to apply changes
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// Tooltip for previous day button
  ///
  /// In en, this message translates to:
  /// **'Previous day'**
  String get previousDay;

  /// Tooltip for next day button
  ///
  /// In en, this message translates to:
  /// **'Next day'**
  String get nextDay;

  /// Button text for today
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// Tooltip for refresh button
  ///
  /// In en, this message translates to:
  /// **'Refresh data'**
  String get refreshData;

  /// Schedule comparison title
  ///
  /// In en, this message translates to:
  /// **'Schedule comparison'**
  String get scheduleComparison;

  /// Tooltip for schedule analytics
  ///
  /// In en, this message translates to:
  /// **'Schedule analytics'**
  String get scheduleAnalytics;

  /// Tooltip for all classes list
  ///
  /// In en, this message translates to:
  /// **'All classes list'**
  String get allClassesList;

  /// Message when no schedule is selected
  ///
  /// In en, this message translates to:
  /// **'Schedule not selected'**
  String get scheduleNotSelected;

  /// Button text to find schedule
  ///
  /// In en, this message translates to:
  /// **'Find schedule'**
  String get findSchedule;

  /// Title for schedule content
  ///
  /// In en, this message translates to:
  /// **'Schedule for selected day'**
  String get scheduleForSelectedDay;

  /// Text for tomorrow
  ///
  /// In en, this message translates to:
  /// **'tomorrow'**
  String get tomorrow;

  /// Checkbox label for showing empty classes
  ///
  /// In en, this message translates to:
  /// **'Show empty classes'**
  String get showEmptyClasses;

  /// Label for empty classes section
  ///
  /// In en, this message translates to:
  /// **'Empty classes'**
  String get emptyClasses;

  /// Label for analytics section
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// Title for weekend page
  ///
  /// In en, this message translates to:
  /// **'Weekend'**
  String get weekend;

  /// Message when there are no classes on a specific day
  ///
  /// In en, this message translates to:
  /// **'No classes this day'**
  String get noClassesThisDay;

  /// Suggestion for free time
  ///
  /// In en, this message translates to:
  /// **'You can rest or do independent work'**
  String get canRestOrStudy;

  /// Button text to navigate to another day
  ///
  /// In en, this message translates to:
  /// **'Go to another day'**
  String get goToAnotherDay;

  /// Plural form for classes count
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{class} few{classes} other{classes}}'**
  String classesCount(int count);

  /// Text when there's no class
  ///
  /// In en, this message translates to:
  /// **'No class'**
  String get noClass;

  /// Title for display settings
  ///
  /// In en, this message translates to:
  /// **'Display settings'**
  String get displaySettings;

  /// Checkbox label for showing comment indicators
  ///
  /// In en, this message translates to:
  /// **'Show comment indicators'**
  String get showCommentIndicators;

  /// Checkbox label for compact card mode
  ///
  /// In en, this message translates to:
  /// **'Compact card mode'**
  String get compactCardMode;

  /// Lesson type - lecture
  ///
  /// In en, this message translates to:
  /// **'Lecture'**
  String get lecture;

  /// Lesson type - laboratory
  ///
  /// In en, this message translates to:
  /// **'Laboratory'**
  String get laboratory;

  /// Lesson type - practice
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get practice;

  /// Lesson type - exam
  ///
  /// In en, this message translates to:
  /// **'Exam'**
  String get exam;

  /// Lesson type - consultation
  ///
  /// In en, this message translates to:
  /// **'Consultation'**
  String get consultation;

  /// Lesson type - credit
  ///
  /// In en, this message translates to:
  /// **'Credit'**
  String get credit;

  /// Unknown author label
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// Label for lesson type selector
  ///
  /// In en, this message translates to:
  /// **'Lesson type'**
  String get lessonType;

  /// Lesson type - individual work
  ///
  /// In en, this message translates to:
  /// **'Individual'**
  String get individual;

  /// Lesson type - physical education
  ///
  /// In en, this message translates to:
  /// **'Physical Education'**
  String get physicalEducation;

  /// Lesson type - course work
  ///
  /// In en, this message translates to:
  /// **'Course Work'**
  String get courseWork;

  /// Lesson type - course project
  ///
  /// In en, this message translates to:
  /// **'Course Project'**
  String get courseProject;

  /// Abbreviated lesson type label - individual work (lesson card tag)
  ///
  /// In en, this message translates to:
  /// **'Self-study'**
  String get lessonTypeIndividualShort;

  /// Abbreviated lesson type label - course work (lesson card tag)
  ///
  /// In en, this message translates to:
  /// **'Course work'**
  String get lessonTypeCourseWorkShort;

  /// Abbreviated lesson type label - course project (lesson card tag)
  ///
  /// In en, this message translates to:
  /// **'Course project'**
  String get lessonTypeCourseProjectShort;

  /// Message about maps availability
  ///
  /// In en, this message translates to:
  /// **'Maps are only available on mobile devices'**
  String get mapsOnlyOnMobile;

  /// Title for schedule analytics page
  ///
  /// In en, this message translates to:
  /// **'Schedule Analytics'**
  String get scheduleAnalyticsTitle;

  /// Description for schedule analytics
  ///
  /// In en, this message translates to:
  /// **'Statistics and analysis of your academic schedule'**
  String get scheduleAnalyticsDescription;

  /// Chart title for daily load
  ///
  /// In en, this message translates to:
  /// **'Load by days'**
  String get loadByDays;

  /// Chart title for lesson types
  ///
  /// In en, this message translates to:
  /// **'Lesson types'**
  String get lessonTypes;

  /// Teachers section title
  ///
  /// In en, this message translates to:
  /// **'Teachers'**
  String get teachers;

  /// No description provided for @searchScopeCommunity.
  ///
  /// In en, this message translates to:
  /// **'Posts'**
  String get searchScopeCommunity;

  /// No description provided for @searchSectionPosts.
  ///
  /// In en, this message translates to:
  /// **'Group posts'**
  String get searchSectionPosts;

  /// No description provided for @searchGlobalHint.
  ///
  /// In en, this message translates to:
  /// **'Class, person, room, post…'**
  String get searchGlobalHint;

  /// No description provided for @searchCoachTitle.
  ///
  /// In en, this message translates to:
  /// **'Global search'**
  String get searchCoachTitle;

  /// No description provided for @searchCoachBody.
  ///
  /// In en, this message translates to:
  /// **'The same icon lives in the header of every root screen: Home · Schedule · Feed · People · Services.'**
  String get searchCoachBody;

  /// No description provided for @searchCoachGesture.
  ///
  /// In en, this message translates to:
  /// **'Plus a gesture: swipe down on Home and Schedule'**
  String get searchCoachGesture;

  /// No description provided for @searchScopeAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get searchScopeAll;

  /// No description provided for @searchScopeClasses.
  ///
  /// In en, this message translates to:
  /// **'Classes'**
  String get searchScopeClasses;

  /// No description provided for @searchScopeClassrooms.
  ///
  /// In en, this message translates to:
  /// **'Rooms'**
  String get searchScopeClassrooms;

  /// No description provided for @searchTrendingTimes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} search this week} other{{count} searches this week}}'**
  String searchTrendingTimes(int count);

  /// No description provided for @searchRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get searchRecent;

  /// No description provided for @searchTrendingNow.
  ///
  /// In en, this message translates to:
  /// **'Trending now'**
  String get searchTrendingNow;

  /// No description provided for @searchBestMatch.
  ///
  /// In en, this message translates to:
  /// **'Best match'**
  String get searchBestMatch;

  /// No description provided for @searchMoreResults.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} more result} other{{count} more results}}'**
  String searchMoreResults(int count);

  /// No description provided for @searchNoResults.
  ///
  /// In en, this message translates to:
  /// **'Nothing found'**
  String get searchNoResults;

  /// No description provided for @searchNoResultsHint.
  ///
  /// In en, this message translates to:
  /// **'Try another query or scope'**
  String get searchNoResultsHint;

  /// No description provided for @searchTagGroup.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get searchTagGroup;

  /// No description provided for @searchTagTeacher.
  ///
  /// In en, this message translates to:
  /// **'Teacher'**
  String get searchTagTeacher;

  /// No description provided for @searchTagClassroom.
  ///
  /// In en, this message translates to:
  /// **'Room'**
  String get searchTagClassroom;

  /// No description provided for @searchTagPerson.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get searchTagPerson;

  /// No description provided for @searchTagPost.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get searchTagPost;

  /// Classrooms section title
  ///
  /// In en, this message translates to:
  /// **'Classrooms'**
  String get classrooms;

  /// Message when there's no data for analytics
  ///
  /// In en, this message translates to:
  /// **'No data for analytics'**
  String get noDataForAnalytics;

  /// Suggestion when no analytics data
  ///
  /// In en, this message translates to:
  /// **'Select another schedule or check for classes'**
  String get selectAnotherSchedule;

  /// Button text for data export
  ///
  /// In en, this message translates to:
  /// **'Export data'**
  String get exportData;

  /// Export option description
  ///
  /// In en, this message translates to:
  /// **'Full report with all charts'**
  String get fullReportWithCharts;

  /// Export option description
  ///
  /// In en, this message translates to:
  /// **'Data in table format'**
  String get dataInTableFormat;

  /// Export option title
  ///
  /// In en, this message translates to:
  /// **'Share image'**
  String get shareImage;

  /// Export option description
  ///
  /// In en, this message translates to:
  /// **'Current chart or all'**
  String get currentOrAllCharts;

  /// Button text for export
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// Day of week - Monday
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// Day of week - Tuesday
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// Day of week - Wednesday
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// Day of week - Thursday
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// Day of week - Friday
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// Title for schedule changes dialog
  ///
  /// In en, this message translates to:
  /// **'Schedule changes'**
  String get scheduleChanges;

  /// Title for calendar page
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// Error message for schedule loading
  ///
  /// In en, this message translates to:
  /// **'Error loading schedule'**
  String get scheduleLoadingError;

  /// Message when no schedules for comparison
  ///
  /// In en, this message translates to:
  /// **'Add schedules for comparison'**
  String get addSchedulesForComparison;

  /// Button text to build route
  ///
  /// In en, this message translates to:
  /// **'Build route'**
  String get buildRoute;

  /// Title for custom schedules page
  ///
  /// In en, this message translates to:
  /// **'My schedules'**
  String get mySchedules;

  /// Button text to create schedule
  ///
  /// In en, this message translates to:
  /// **'Create schedule'**
  String get createSchedule;

  /// Button text to add class
  ///
  /// In en, this message translates to:
  /// **'Add class'**
  String get addClass;

  /// Button text for classes list
  ///
  /// In en, this message translates to:
  /// **'Classes list'**
  String get classesList;

  /// Label for single class
  ///
  /// In en, this message translates to:
  /// **'Class'**
  String get classLabel;

  /// Button text to open
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// Menu item to edit
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Menu item to delete
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Dialog title for editing schedule
  ///
  /// In en, this message translates to:
  /// **'Edit schedule'**
  String get editSchedule;

  /// Button text to cancel
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Button text to save
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Dialog title for deleting schedule
  ///
  /// In en, this message translates to:
  /// **'Delete schedule'**
  String get deleteSchedule;

  /// Confirmation message for deleting schedule
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete schedule \"{scheduleName}\"?'**
  String deleteScheduleConfirmation(String scheduleName);

  /// Button text to create new class
  ///
  /// In en, this message translates to:
  /// **'Create new class'**
  String get createNewClass;

  /// Message when no classes are added
  ///
  /// In en, this message translates to:
  /// **'No added classes'**
  String get noAddedClasses;

  /// Dialog title for deleting class
  ///
  /// In en, this message translates to:
  /// **'Delete class'**
  String get deleteClass;

  /// Confirmation message for deleting class
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete class \"{subject}\" from schedule?'**
  String deleteClassConfirmation(String subject);

  /// Label for start time
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// Label for end time
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get end;

  /// Error message for invalid time range
  ///
  /// In en, this message translates to:
  /// **'End time must be after start time'**
  String get endTimeMustBeAfterStart;

  /// Label for class number
  ///
  /// In en, this message translates to:
  /// **'Class number'**
  String get classNumber;

  /// Option for no class number
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// Groups section title
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get groups;

  /// Message when no teachers are selected
  ///
  /// In en, this message translates to:
  /// **'No teachers selected'**
  String get noTeachersSelected;

  /// Dialog title for adding teacher
  ///
  /// In en, this message translates to:
  /// **'Add teacher'**
  String get addTeacher;

  /// Button text to add
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// Validation missing dates
  ///
  /// In en, this message translates to:
  /// **'Select at least one date'**
  String get selectAtLeastOneDate;

  /// Error message for classroom selection
  ///
  /// In en, this message translates to:
  /// **'Add at least one classroom or make the class online'**
  String get addAtLeastOneClassroom;

  /// Message when no dates are selected
  ///
  /// In en, this message translates to:
  /// **'No selected dates'**
  String get noSelectedDates;

  /// Button text to select dates
  ///
  /// In en, this message translates to:
  /// **'Select dates'**
  String get selectDatesButton;

  /// Message when no classrooms are selected
  ///
  /// In en, this message translates to:
  /// **'No selected classrooms'**
  String get noSelectedClassrooms;

  /// Button text to add classroom
  ///
  /// In en, this message translates to:
  /// **'Add classroom'**
  String get addClassroom;

  /// Message when no groups are selected
  ///
  /// In en, this message translates to:
  /// **'No groups selected'**
  String get noGroupsSelected;

  /// Dialog title for adding group
  ///
  /// In en, this message translates to:
  /// **'Add group'**
  String get addGroup;

  /// Label for example class names
  ///
  /// In en, this message translates to:
  /// **'Example class names:'**
  String get exampleClassNames;

  /// Message when text is copied
  ///
  /// In en, this message translates to:
  /// **'Text copied!'**
  String get textCopied;

  /// Error message when image fails to open
  ///
  /// In en, this message translates to:
  /// **'Failed to open image: {error}'**
  String failedToOpenImage(String error);

  /// Error message for login failure
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;

  /// Button text for next
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Error message for ads loading
  ///
  /// In en, this message translates to:
  /// **'Error loading ads'**
  String get errorLoadingAds;

  /// Button text for login
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Message to prompt login
  ///
  /// In en, this message translates to:
  /// **'Login to continue'**
  String get loginToContinue;

  /// Title for delete schedule dialog
  ///
  /// In en, this message translates to:
  /// **'Delete schedule'**
  String get deleteScheduleTitle;

  /// Message for delete schedule confirmation
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this schedule?'**
  String get deleteScheduleMessage;

  /// Menu item to make schedule active
  ///
  /// In en, this message translates to:
  /// **'Make active'**
  String get makeActive;

  /// Comment label
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get comment;

  /// Title for schedules page
  ///
  /// In en, this message translates to:
  /// **'Schedules'**
  String get schedules;

  /// Message while loading schedules
  ///
  /// In en, this message translates to:
  /// **'Loading schedules...'**
  String get loadingSchedules;

  /// Label for added class
  ///
  /// In en, this message translates to:
  /// **'Added class:'**
  String get addedClass;

  /// Button text to create new schedule
  ///
  /// In en, this message translates to:
  /// **'Create new schedule'**
  String get createNewSchedule;

  /// Label for schedule selection
  ///
  /// In en, this message translates to:
  /// **'Select schedule:'**
  String get selectSchedule;

  /// Success message when class is added
  ///
  /// In en, this message translates to:
  /// **'Class added to schedule \"{scheduleName}\"'**
  String classAddedToSchedule(String scheduleName);

  /// Label for calendar legends
  ///
  /// In en, this message translates to:
  /// **'Legends'**
  String get legends;

  /// Error message for schedule comparison limit
  ///
  /// In en, this message translates to:
  /// **'Maximum 3 schedules for comparison'**
  String get maxThreeSchedules;

  /// Label for university
  ///
  /// In en, this message translates to:
  /// **'University'**
  String get university;

  /// Search placeholder text
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Search mode - all results
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// Error title
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Search error message
  ///
  /// In en, this message translates to:
  /// **'Failed to perform search'**
  String get searchFailed;

  /// Comment input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter comment text...'**
  String get enterCommentText;

  /// Remove button text
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// Message when no schedules available
  ///
  /// In en, this message translates to:
  /// **'No available schedules'**
  String get noAvailableSchedules;

  /// Success message when schedule deleted
  ///
  /// In en, this message translates to:
  /// **'Schedule deleted'**
  String get scheduleDeleted;

  /// Delete schedule confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this schedule?'**
  String get deleteScheduleConfirmationDialog;

  /// Active status
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// Comments label plural
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// Activate button text
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get activate;

  /// Group label
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get group;

  /// Teacher label
  ///
  /// In en, this message translates to:
  /// **'Teacher'**
  String get teacher;

  /// Classroom label
  ///
  /// In en, this message translates to:
  /// **'Classroom'**
  String get classroom;

  /// Schedule label
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// Success message when comment deleted
  ///
  /// In en, this message translates to:
  /// **'Comment deleted'**
  String get commentDeleted;

  /// Success message when comment saved
  ///
  /// In en, this message translates to:
  /// **'Comment saved'**
  String get commentSaved;

  /// Schedule comment title
  ///
  /// In en, this message translates to:
  /// **'Schedule comment'**
  String get scheduleComment;

  /// Schedule comment description
  ///
  /// In en, this message translates to:
  /// **'Add or edit a note to the schedule'**
  String get addOrEditNote;

  /// Edit comment menu item
  ///
  /// In en, this message translates to:
  /// **'Edit comment'**
  String get editComment;

  /// Active schedule badge on the card
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get scheduleActiveBadge;

  /// Delete schedule menu item
  ///
  /// In en, this message translates to:
  /// **'Delete schedule'**
  String get deleteScheduleAction;

  /// Add comment menu item
  ///
  /// In en, this message translates to:
  /// **'Add comment'**
  String get addComment;

  /// Add schedule tooltip
  ///
  /// In en, this message translates to:
  /// **'Add schedule'**
  String get addSchedule;

  /// Active schedule label
  ///
  /// In en, this message translates to:
  /// **'Active schedule'**
  String get activeSchedule;

  /// Go to view tooltip
  ///
  /// In en, this message translates to:
  /// **'Go to view'**
  String get goToView;

  /// Message when no groups added
  ///
  /// In en, this message translates to:
  /// **'No added groups'**
  String get noAddedGroups;

  /// Instruction to add group
  ///
  /// In en, this message translates to:
  /// **'Add a group to see its schedule'**
  String get addGroupToSeeSchedule;

  /// Message when no teachers added
  ///
  /// In en, this message translates to:
  /// **'No added teachers'**
  String get noAddedTeachers;

  /// Instruction to add teacher
  ///
  /// In en, this message translates to:
  /// **'Add a teacher to see their schedule'**
  String get addTeacherToSeeSchedule;

  /// Message when no classrooms added
  ///
  /// In en, this message translates to:
  /// **'No added classrooms'**
  String get noAddedClassrooms;

  /// Instruction to add classroom
  ///
  /// In en, this message translates to:
  /// **'Add a classroom to see its schedule'**
  String get addClassroomToSeeSchedule;

  /// Error message when schedules fail to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load schedules'**
  String get failedToLoadSchedules;

  /// Internet connection error description
  ///
  /// In en, this message translates to:
  /// **'Check your internet connection'**
  String get checkInternetConnection;

  /// JSON input validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter JSON string'**
  String get enterJsonString;

  /// JSON input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter JSON string...'**
  String get enterJsonStringPlaceholder;

  /// Tabs label
  ///
  /// In en, this message translates to:
  /// **'Tabs'**
  String get tabs;

  /// Schedule changes dialog title
  ///
  /// In en, this message translates to:
  /// **'Schedule changes'**
  String get scheduleChangesTitle;

  /// Daily load chart title
  ///
  /// In en, this message translates to:
  /// **'Load by days'**
  String get loadByDaysChart;

  /// Lesson types chart title
  ///
  /// In en, this message translates to:
  /// **'Lesson types'**
  String get lessonTypesChart;

  /// Teachers chart title
  ///
  /// In en, this message translates to:
  /// **'Teachers'**
  String get teachersChart;

  /// Classrooms chart title
  ///
  /// In en, this message translates to:
  /// **'Classrooms'**
  String get classroomsChart;

  /// Export option description
  ///
  /// In en, this message translates to:
  /// **'Full report with all charts'**
  String get fullReportWithAllCharts;

  /// Export option description
  ///
  /// In en, this message translates to:
  /// **'Data in table format'**
  String get dataInTableFormatExport;

  /// Export option title
  ///
  /// In en, this message translates to:
  /// **'Share image'**
  String get shareImageExport;

  /// Export option description
  ///
  /// In en, this message translates to:
  /// **'Current chart or all'**
  String get currentOrAllChartsExport;

  /// Total classes statistics label
  ///
  /// In en, this message translates to:
  /// **'Total classes'**
  String get totalClasses;

  /// Statistics period description
  ///
  /// In en, this message translates to:
  /// **'For the entire period'**
  String get forEntirePeriod;

  /// Average per day statistics label
  ///
  /// In en, this message translates to:
  /// **'Average per day'**
  String get averagePerDay;

  /// Academic load description
  ///
  /// In en, this message translates to:
  /// **'Academic load'**
  String get academicLoad;

  /// Maximum per day statistics label
  ///
  /// In en, this message translates to:
  /// **'Maximum per day'**
  String get maximumPerDay;

  /// Busiest day description
  ///
  /// In en, this message translates to:
  /// **'Busiest day'**
  String get busiestDay;

  /// Show empty classes setting
  ///
  /// In en, this message translates to:
  /// **'Show empty classes'**
  String get showEmptyClassesSettings;

  /// Show comment indicators setting
  ///
  /// In en, this message translates to:
  /// **'Show comment indicators'**
  String get showCommentIndicatorsSettings;

  /// Compact card mode setting
  ///
  /// In en, this message translates to:
  /// **'Compact card mode'**
  String get compactCardModeSettings;

  /// Holiday page title
  ///
  /// In en, this message translates to:
  /// **'Holiday'**
  String get holiday;

  /// Select existing option
  ///
  /// In en, this message translates to:
  /// **'Select existing'**
  String get selectExisting;

  /// Create new option
  ///
  /// In en, this message translates to:
  /// **'Create new'**
  String get createNew;

  /// Schedule name field label
  ///
  /// In en, this message translates to:
  /// **'Schedule name'**
  String get scheduleName;

  /// Schedule name placeholder
  ///
  /// In en, this message translates to:
  /// **'For example: My main schedule'**
  String get scheduleNamePlaceholder;

  /// Description field label
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get descriptionOptional;

  /// Description field placeholder
  ///
  /// In en, this message translates to:
  /// **'Add schedule description'**
  String get addScheduleDescription;

  /// Open schedule button
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get openSchedule;

  /// Week selection title
  ///
  /// In en, this message translates to:
  /// **'Select week'**
  String get selectWeek;

  /// Week selection description
  ///
  /// In en, this message translates to:
  /// **'Quick way to go to a specific week'**
  String get quickWayToWeek;

  /// Schedule comparison description
  ///
  /// In en, this message translates to:
  /// **'Select up to 4 schedules to compare them by days'**
  String get selectUpToFourSchedules;

  /// Add to schedule title
  ///
  /// In en, this message translates to:
  /// **'Add to schedule'**
  String get addToSchedule;

  /// Comment hint
  ///
  /// In en, this message translates to:
  /// **'Enter a comment for the class...'**
  String get enterLessonComment;

  /// No custom schedules message
  ///
  /// In en, this message translates to:
  /// **'You don\'t have your own schedules yet'**
  String get noOwnSchedules;

  /// Custom schedule creation description
  ///
  /// In en, this message translates to:
  /// **'Create a custom schedule by adding classes from different available schedules'**
  String get createCustomSchedule;

  /// Schedule creation title
  ///
  /// In en, this message translates to:
  /// **'Schedule creation'**
  String get scheduleCreation;

  /// Schedule creation description
  ///
  /// In en, this message translates to:
  /// **'Enter name and description for the new schedule'**
  String get enterNameAndDescription;

  /// Schedule name label
  ///
  /// In en, this message translates to:
  /// **'Schedule name'**
  String get scheduleNameLabel;

  /// Schedule name example
  ///
  /// In en, this message translates to:
  /// **'For example: My schedule'**
  String get scheduleNameExample;

  /// Description optional label
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get descriptionOptionalLabel;

  /// Description placeholder
  ///
  /// In en, this message translates to:
  /// **'Add schedule description'**
  String get addScheduleDescriptionPlaceholder;

  /// Edit schedule title
  ///
  /// In en, this message translates to:
  /// **'Edit schedule'**
  String get editScheduleTitle;

  /// Classes list title
  ///
  /// In en, this message translates to:
  /// **'Classes list'**
  String get classesListTitle;

  /// Add new class description
  ///
  /// In en, this message translates to:
  /// **'You can add a new class to schedule {scheduleName}'**
  String addNewClassToSchedule(String scheduleName);

  /// Offline mode label
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// Online mode label
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// Subject name field label
  ///
  /// In en, this message translates to:
  /// **'Subject name'**
  String get subjectName;

  /// Subject name placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter subject name'**
  String get enterSubjectName;

  /// Teacher name field label
  ///
  /// In en, this message translates to:
  /// **'Teacher full name'**
  String get teacherFullName;

  /// Teacher name example
  ///
  /// In en, this message translates to:
  /// **'For example: Ivanov Ivan Ivanovich'**
  String get teacherNameExample;

  /// Time validation error
  ///
  /// In en, this message translates to:
  /// **'End time must be after start time'**
  String get endTimeMustBeAfterStartTime;

  /// Date selection error
  ///
  /// In en, this message translates to:
  /// **'Select at least one date'**
  String get selectAtLeastOneDateError;

  /// Classroom selection error
  ///
  /// In en, this message translates to:
  /// **'Add at least one classroom or make the class online'**
  String get addAtLeastOneClassroomError;

  /// Select dates button text
  ///
  /// In en, this message translates to:
  /// **'Select dates'**
  String get selectDatesButtonText;

  /// Online class link field label
  ///
  /// In en, this message translates to:
  /// **'Online class link'**
  String get onlineClassLink;

  /// Connection URL placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter connection URL'**
  String get enterConnectionUrl;

  /// Classroom number title
  ///
  /// In en, this message translates to:
  /// **'Classroom {name}'**
  String classroomNumber(String name);

  /// Classroom number example
  ///
  /// In en, this message translates to:
  /// **'For example: A-123'**
  String get classroomExample;

  /// Campus name field label
  ///
  /// In en, this message translates to:
  /// **'Campus name (optional)'**
  String get campusNameOptional;

  /// Campus name example
  ///
  /// In en, this message translates to:
  /// **'For example: B-78'**
  String get campusExample;

  /// Add classroom dialog title
  ///
  /// In en, this message translates to:
  /// **'Add classroom'**
  String get addClassroomDialog;

  /// Group name field label
  ///
  /// In en, this message translates to:
  /// **'Group name'**
  String get groupName;

  /// Group name example
  ///
  /// In en, this message translates to:
  /// **'For example: IKBO-01-21'**
  String get groupNameExample;

  /// Add group dialog title
  ///
  /// In en, this message translates to:
  /// **'Add group'**
  String get addGroupDialog;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Reset filter button text
  ///
  /// In en, this message translates to:
  /// **'Reset filter'**
  String get resetFilter;

  /// Support service title
  ///
  /// In en, this message translates to:
  /// **'Support our service'**
  String get supportOurService;

  /// Leave ad button text
  ///
  /// In en, this message translates to:
  /// **'Leave ad'**
  String get leaveAd;

  /// Disable button text
  ///
  /// In en, this message translates to:
  /// **'Disable'**
  String get disable;

  /// Error message with details
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorWithMessage(String message);

  /// Map page title
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get map;

  /// Try again button text
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// Announcement label
  ///
  /// In en, this message translates to:
  /// **'Announcement'**
  String get announcement;

  /// Contact button text
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// Copied to clipboard message
  ///
  /// In en, this message translates to:
  /// **'{title} copied to clipboard'**
  String copiedToClipboard(String title);

  /// Post page title
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get post;

  /// Error loading post message
  ///
  /// In en, this message translates to:
  /// **'Error loading post'**
  String get errorLoadingPost;

  /// Error loading contributors message
  ///
  /// In en, this message translates to:
  /// **'Error loading contributors'**
  String get errorLoadingContributors;

  /// Commit count under a contributor name
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} commit} other{{count} commits}}'**
  String contributorCommitsCount(int count);

  /// Section title for related articles
  ///
  /// In en, this message translates to:
  /// **'Related articles'**
  String get relatedArticles;

  /// Error description when an article fails to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load article'**
  String get failedToLoadArticle;

  /// Error message when share action fails
  ///
  /// In en, this message translates to:
  /// **'Failed to share'**
  String get shareFailed;

  /// Trending section title
  ///
  /// In en, this message translates to:
  /// **'Trending'**
  String get trending;

  /// Slideshow label
  ///
  /// In en, this message translates to:
  /// **'Slideshow'**
  String get slideshow;

  /// Search prompt when no query entered
  ///
  /// In en, this message translates to:
  /// **'Enter a search query'**
  String get enterSearchQuery;

  /// Error description when loading more content fails
  ///
  /// In en, this message translates to:
  /// **'Failed to load more content'**
  String get failedToLoadMoreContent;

  /// Search history header
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get searchHistory;

  /// Validation message for empty schedule name
  ///
  /// In en, this message translates to:
  /// **'Enter name'**
  String get enterScheduleName;

  /// Validation message when schedule name is too long
  ///
  /// In en, this message translates to:
  /// **'Name is too long'**
  String get nameTooLong;

  /// Button text to create a schedule and add class
  ///
  /// In en, this message translates to:
  /// **'Create and add class'**
  String get createAndAddClass;

  /// Button text to add class to selected schedule
  ///
  /// In en, this message translates to:
  /// **'Add to selected schedule'**
  String get addToSelectedSchedule;

  /// MIREA Map service title
  ///
  /// In en, this message translates to:
  /// **'Campus map'**
  String get campusMap;

  /// MIREA Map service description
  ///
  /// In en, this message translates to:
  /// **'Find the needed classroom'**
  String get findNeededClassroom;

  /// NFC Pass service title
  ///
  /// In en, this message translates to:
  /// **'NFC Pass'**
  String get nfcPass;

  /// NFC Pass service description
  ///
  /// In en, this message translates to:
  /// **'Pass for university entry'**
  String get passForUniversityEntry;

  /// Cloud service title
  ///
  /// In en, this message translates to:
  /// **'Cloud Mirea Ninja'**
  String get cloudMireaNinja;

  /// Mirea Ninja community title
  ///
  /// In en, this message translates to:
  /// **'Mirea Ninja'**
  String get mireaNinja;

  /// Mirea Ninja community description
  ///
  /// In en, this message translates to:
  /// **'Most popular unofficial chat'**
  String get mostPopularUnofficialChat;

  /// KIS Department title
  ///
  /// In en, this message translates to:
  /// **'KIS Department'**
  String get kisDepartment;

  /// KIS Department description
  ///
  /// In en, this message translates to:
  /// **'Corporate Information Systems Department'**
  String get corporateInformationSystems;

  /// IPPO Department title
  ///
  /// In en, this message translates to:
  /// **'IPPO Department'**
  String get ippoDepartment;

  /// IPPO Department description
  ///
  /// In en, this message translates to:
  /// **'Instrumental and Applied Software Department'**
  String get instrumentalAndAppliedSoftware;

  /// Competitive programming title
  ///
  /// In en, this message translates to:
  /// **'Competitive Programming MIREA'**
  String get competitiveProgrammingMirea;

  /// Competitive programming description
  ///
  /// In en, this message translates to:
  /// **'Various news and updates on competitive programming at MIREA are published here'**
  String get competitiveProgrammingDescription;

  /// Personal account service title
  ///
  /// In en, this message translates to:
  /// **'Personal Account'**
  String get personalAccount;

  /// Personal account description
  ///
  /// In en, this message translates to:
  /// **'Access to grades, applications and other services'**
  String get accessToGradesAndServices;

  /// Open action button
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get openAction;

  /// Educational portal title
  ///
  /// In en, this message translates to:
  /// **'Educational Portal'**
  String get educationalPortal;

  /// Educational portal description
  ///
  /// In en, this message translates to:
  /// **'Access to courses and materials'**
  String get accessToCoursesAndMaterials;

  /// Go to action button
  ///
  /// In en, this message translates to:
  /// **'Go to'**
  String get goToAction;

  /// Electronic journal title
  ///
  /// In en, this message translates to:
  /// **'Electronic Journal'**
  String get electronicJournal;

  /// Electronic journal description
  ///
  /// In en, this message translates to:
  /// **'Attendance check, schedule'**
  String get attendanceCheckSchedule;

  /// Library service title
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get library;

  /// Free software service title
  ///
  /// In en, this message translates to:
  /// **'Free Software'**
  String get freeSoftware;

  /// Cyberzone service title
  ///
  /// In en, this message translates to:
  /// **'Cyberzone'**
  String get cyberzone;

  /// Handbook service title
  ///
  /// In en, this message translates to:
  /// **'Handbook'**
  String get handbook;

  /// Scholarships service title
  ///
  /// In en, this message translates to:
  /// **'Scholarships'**
  String get scholarships;

  /// Military registration service title
  ///
  /// In en, this message translates to:
  /// **'Military Registration'**
  String get militaryRegistration;

  /// Dormitories service title
  ///
  /// In en, this message translates to:
  /// **'Dormitories'**
  String get dormitories;

  /// Student office service title
  ///
  /// In en, this message translates to:
  /// **'Student Office'**
  String get studentOffice;

  /// Student office description
  ///
  /// In en, this message translates to:
  /// **'Certificates, documents, questions'**
  String get certificatesDocumentsQuestions;

  /// Career center service title
  ///
  /// In en, this message translates to:
  /// **'Career Center'**
  String get careerCenter;

  /// Career center description
  ///
  /// In en, this message translates to:
  /// **'Vacancies and internships'**
  String get vacanciesAndInternships;

  /// Initiative service title
  ///
  /// In en, this message translates to:
  /// **'Initiative Service'**
  String get initiativeService;

  /// Initiative service description
  ///
  /// In en, this message translates to:
  /// **'Ideas and suggestions'**
  String get ideasAndSuggestions;

  /// Virtual tour service title
  ///
  /// In en, this message translates to:
  /// **'Virtual Tour'**
  String get virtualTour;

  /// Virtual tour description
  ///
  /// In en, this message translates to:
  /// **'Interactive tour of university buildings'**
  String get interactiveUniversityTour;

  /// Startup accelerator service title
  ///
  /// In en, this message translates to:
  /// **'Startup Accelerator'**
  String get startupAccelerator;

  /// Startup accelerator description
  ///
  /// In en, this message translates to:
  /// **'Startup and entrepreneurial ideas support'**
  String get startupSupport;

  /// Corporate portal service title
  ///
  /// In en, this message translates to:
  /// **'Corporate Portal'**
  String get corporatePortal;

  /// Corporate portal description
  ///
  /// In en, this message translates to:
  /// **'Access for teachers and staff'**
  String get accessForTeachersAndStaff;

  /// Main services section title
  ///
  /// In en, this message translates to:
  /// **'Main services'**
  String get mainServices;

  /// Student life section title
  ///
  /// In en, this message translates to:
  /// **'Student life'**
  String get studentLife;

  /// Useful section title
  ///
  /// In en, this message translates to:
  /// **'Useful'**
  String get useful;

  /// Create account button text
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// Create account dialog title
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get createAccountTitle;

  /// Create account dialog description
  ///
  /// In en, this message translates to:
  /// **'We offer you to create a free account in our cloud storage so you can store your files and documents!'**
  String get createAccountDescription;

  /// Cloud storage service description
  ///
  /// In en, this message translates to:
  /// **'On cloud.mirea.ninja you can store up to 10 GB for free (quota can be expanded in the telegram bot), as well as share files and edit documents online together with classmates.'**
  String get cloudStorageDescription;

  /// Search input placeholder
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchPlaceholder;

  /// Search in announcements placeholder
  ///
  /// In en, this message translates to:
  /// **'Search in announcements...'**
  String get searchInAnnouncements;

  /// Item name field label
  ///
  /// In en, this message translates to:
  /// **'Item name'**
  String get itemName;

  /// Item name example
  ///
  /// In en, this message translates to:
  /// **'For example: Keys with keychain'**
  String get itemNameExample;

  /// Description field label
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Item description placeholder
  ///
  /// In en, this message translates to:
  /// **'Details about the item, where and when it was found/lost...'**
  String get itemDescription;

  /// Telegram field label
  ///
  /// In en, this message translates to:
  /// **'Telegram'**
  String get telegram;

  /// Phone field label
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// Leave feedback title
  ///
  /// In en, this message translates to:
  /// **'Leave feedback'**
  String get leaveFeedback;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Your email'**
  String get yourEmail;

  /// Email field placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter email'**
  String get enterEmail;

  /// Feedback question label
  ///
  /// In en, this message translates to:
  /// **'What happened?'**
  String get whatHappened;

  /// Feedback placeholder text
  ///
  /// In en, this message translates to:
  /// **'When I press \"X\" \"Y\" happens'**
  String get feedbackPlaceholder;

  /// Export to calendar title
  ///
  /// In en, this message translates to:
  /// **'Export to calendar'**
  String get exportToCalendar;

  /// Schedule exported success message
  ///
  /// In en, this message translates to:
  /// **'Schedule exported'**
  String get scheduleExported;

  /// Export schedule error message
  ///
  /// In en, this message translates to:
  /// **'Failed to export schedule'**
  String get failedToExportSchedule;

  /// Export settings title
  ///
  /// In en, this message translates to:
  /// **'Export settings'**
  String get exportSettings;

  /// Emoji setting title
  ///
  /// In en, this message translates to:
  /// **'Emoji in lesson types'**
  String get emojiInLessonTypes;

  /// Emoji setting description
  ///
  /// In en, this message translates to:
  /// **'Example: \"📚 Lecture\" instead of \"Lecture\"'**
  String get emojiExample;

  /// Short names setting title
  ///
  /// In en, this message translates to:
  /// **'Short lesson type names'**
  String get shortLessonTypeNames;

  /// Short names setting description
  ///
  /// In en, this message translates to:
  /// **'Example: \"Lec.\" instead of \"Lecture\"'**
  String get shortNamesExample;

  /// Preview section title
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// Full type name subtitle
  ///
  /// In en, this message translates to:
  /// **'Full type name'**
  String get fullTypeName;

  /// Short type name subtitle
  ///
  /// In en, this message translates to:
  /// **'Short type name'**
  String get shortTypeName;

  /// Subject selection title
  ///
  /// In en, this message translates to:
  /// **'Subject selection'**
  String get subjectSelection;

  /// Standard reminders title
  ///
  /// In en, this message translates to:
  /// **'Standard reminders'**
  String get standardReminders;

  /// Card settings title
  ///
  /// In en, this message translates to:
  /// **'Card settings'**
  String get cardSettings;

  /// Code from email title
  ///
  /// In en, this message translates to:
  /// **'Code from email'**
  String get codeFromEmail;

  /// News navigation item
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get news;

  /// Services navigation item
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// Profile navigation item
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// About app navigation item
  ///
  /// In en, this message translates to:
  /// **'About app'**
  String get aboutApp;

  /// Settings navigation item
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Classroom schedule search description
  ///
  /// In en, this message translates to:
  /// **'You can quickly find a schedule for this classroom using schedule search.'**
  String get findScheduleForClassroom;

  /// New Year holidays title
  ///
  /// In en, this message translates to:
  /// **'New Year holidays'**
  String get newYearHolidays;

  /// Orthodox Christmas title
  ///
  /// In en, this message translates to:
  /// **'Orthodox Christmas'**
  String get orthodoxChristmas;

  /// Winter vacation title
  ///
  /// In en, this message translates to:
  /// **'Winter vacation'**
  String get winterVacation;

  /// Defender of the Fatherland Day title
  ///
  /// In en, this message translates to:
  /// **'Defender of the Fatherland Day'**
  String get defenderOfFatherlandDay;

  /// International Women's Day title
  ///
  /// In en, this message translates to:
  /// **'International Women\'s Day'**
  String get internationalWomensDay;

  /// Spring and Labor Day title
  ///
  /// In en, this message translates to:
  /// **'Spring and Labor Day'**
  String get springAndLaborDay;

  /// Victory Day title
  ///
  /// In en, this message translates to:
  /// **'Victory Day'**
  String get victoryDay;

  /// Russia Day title
  ///
  /// In en, this message translates to:
  /// **'Russia Day'**
  String get russiaDay;

  /// National Unity Day title
  ///
  /// In en, this message translates to:
  /// **'National Unity Day'**
  String get nationalUnityDay;

  /// New Year title
  ///
  /// In en, this message translates to:
  /// **'New Year'**
  String get newYear;

  /// Total label
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// Lectures label
  ///
  /// In en, this message translates to:
  /// **'Lectures'**
  String get lectures;

  /// Practicals label
  ///
  /// In en, this message translates to:
  /// **'Practicals'**
  String get practicals;

  /// Labs label
  ///
  /// In en, this message translates to:
  /// **'Labs'**
  String get labs;

  /// No description provided for @topicsLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading discussion…'**
  String get topicsLoading;

  /// Just now time label
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get justNow;

  /// Status label
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// Phone contact label
  ///
  /// In en, this message translates to:
  /// **'Phone: {phoneNumber}'**
  String phoneContact(String phoneNumber);

  /// Header for lessons on a specific day
  ///
  /// In en, this message translates to:
  /// **'Lessons on {day}'**
  String lessonsOnDay(String day);

  /// today, lowercase
  ///
  /// In en, this message translates to:
  /// **'today'**
  String get todayLower;

  /// tomorrow, lowercase
  ///
  /// In en, this message translates to:
  /// **'tomorrow'**
  String get tomorrowLower;

  /// Tooltip for empty lessons toggle
  ///
  /// In en, this message translates to:
  /// **'Show empty classes'**
  String get showEmptyLessonsTooltip;

  /// Label for empty lessons toggle
  ///
  /// In en, this message translates to:
  /// **'Empty classes'**
  String get emptyLessons;

  /// Short label for analytics
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analyticsShort;

  /// Holiday title for Sunday
  ///
  /// In en, this message translates to:
  /// **'Day off'**
  String get dayOff;

  /// Empty day title
  ///
  /// In en, this message translates to:
  /// **'No classes on this day'**
  String get noLessonsThatDay;

  /// Short empty day line
  ///
  /// In en, this message translates to:
  /// **'No classes this day!'**
  String get noLessonsThatDayShort;

  /// Suggestion on empty day
  ///
  /// In en, this message translates to:
  /// **'You can rest or do self-study'**
  String get restSuggestion;

  /// Window gap between lessons with pluralization
  ///
  /// In en, this message translates to:
  /// **'Gap: {count, plural, one{{count} class} other{{count} classes}}'**
  String windowGap(int count);

  /// Pluralized word for a lesson period/pair, used after a period number or count
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{class} other{classes}}'**
  String lessonPeriodWord(int count);

  /// Empty schedule title
  ///
  /// In en, this message translates to:
  /// **'No schedule selected'**
  String get noScheduleSelected;

  /// Empty schedule subtitle
  ///
  /// In en, this message translates to:
  /// **'Select a group, teacher or classroom to view schedule'**
  String get selectEntityToSeeSchedule;

  /// Title shown when no schedule group is active yet
  ///
  /// In en, this message translates to:
  /// **'No active group set'**
  String get noActiveGroupTitle;

  /// Subtitle shown when no schedule group is active yet
  ///
  /// In en, this message translates to:
  /// **'Download a schedule for at least one group to see the calendar.'**
  String get noActiveGroupSubtitle;

  /// Snack error loading schedule
  ///
  /// In en, this message translates to:
  /// **'Error loading schedule'**
  String get errorLoadingSchedule;

  /// Tooltip for manage comparisons
  ///
  /// In en, this message translates to:
  /// **'Manage comparisons'**
  String get manageComparisons;

  /// Description for compare modal
  ///
  /// In en, this message translates to:
  /// **'Select up to 4 schedules to compare by days'**
  String get selectUpTo4Schedules;

  /// Title for no upcoming lessons state
  ///
  /// In en, this message translates to:
  /// **'No upcoming classes'**
  String get noUpcomingLessons;

  /// Description for no upcoming lessons state
  ///
  /// In en, this message translates to:
  /// **'No classes are scheduled in the near future. Switch to the calendar to view other days.'**
  String get noUpcomingLessonsDescription;

  /// Button to switch to calendar
  ///
  /// In en, this message translates to:
  /// **'Switch to calendar'**
  String get switchToCalendar;

  /// Lectures short label
  ///
  /// In en, this message translates to:
  /// **'Lect.'**
  String get lecturesShort;

  /// Practice short label
  ///
  /// In en, this message translates to:
  /// **'Pract.'**
  String get practiceShort;

  /// Labs short label
  ///
  /// In en, this message translates to:
  /// **'Lab.'**
  String get labsShort;

  /// Legend title
  ///
  /// In en, this message translates to:
  /// **'Legend'**
  String get legend;

  /// Laboratory work label
  ///
  /// In en, this message translates to:
  /// **'Laboratory'**
  String get laboratoryWork;

  /// Schedule load error description
  ///
  /// In en, this message translates to:
  /// **'An error occurred while fetching the schedule. Please try again.'**
  String get scheduleLoadError;

  /// Comparison manager title
  ///
  /// In en, this message translates to:
  /// **'Select schedules for comparison (up to 3)'**
  String get selectSchedulesForComparison;

  /// Confirm delete schedule
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"?'**
  String deleteScheduleConfirm(String name);

  /// Confirm delete class
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{subject}\" from the schedule?'**
  String deleteClassConfirm(String subject);

  /// Comment length validation
  ///
  /// In en, this message translates to:
  /// **'Comment is too long'**
  String get commentTooLong;

  /// Validation missing classroom
  ///
  /// In en, this message translates to:
  /// **'Add at least one classroom or make the class online'**
  String get addOneClassroomOrOnline;

  /// Create class title
  ///
  /// In en, this message translates to:
  /// **'Create class'**
  String get createClass;

  /// Edit class title
  ///
  /// In en, this message translates to:
  /// **'Edit class'**
  String get editClass;

  /// Start time label
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get startTime;

  /// End time label
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get endTime;

  /// Lesson number label
  ///
  /// In en, this message translates to:
  /// **'Lesson number'**
  String get lessonNumber;

  /// Teacher full name hint
  ///
  /// In en, this message translates to:
  /// **'e.g. Ivanov Ivan Ivanovich'**
  String get teacherFullNameHint;

  /// Teacher full name validation
  ///
  /// In en, this message translates to:
  /// **'Enter teacher full name'**
  String get enterTeacherFullName;

  /// Online URL label
  ///
  /// In en, this message translates to:
  /// **'Online lesson URL'**
  String get onlineLessonUrl;

  /// URL hint
  ///
  /// In en, this message translates to:
  /// **'Enter URL'**
  String get enterUrl;

  /// Classroom number hint
  ///
  /// In en, this message translates to:
  /// **'e.g. A-123'**
  String get classroomNumberHint;

  /// Classroom number validation
  ///
  /// In en, this message translates to:
  /// **'Enter classroom number'**
  String get enterClassroomNumber;

  /// Group name validation
  ///
  /// In en, this message translates to:
  /// **'Enter group name'**
  String get enterGroupName;

  /// Basic tab
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get basic;

  /// Dates tab
  ///
  /// In en, this message translates to:
  /// **'Dates'**
  String get dates;

  /// Place tab
  ///
  /// In en, this message translates to:
  /// **'Place'**
  String get place;

  /// Create button
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// Tooltip to add date
  ///
  /// In en, this message translates to:
  /// **'Add date'**
  String get addDate;

  /// Header for lesson delivery type
  ///
  /// In en, this message translates to:
  /// **'Lesson delivery type'**
  String get lessonDeliveryType;

  /// Empty state for classrooms
  ///
  /// In en, this message translates to:
  /// **'No classrooms selected'**
  String get noClassroomsSelected;

  /// Back button
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @scheduleLessonsTitle.
  ///
  /// In en, this message translates to:
  /// **'Classes'**
  String get scheduleLessonsTitle;

  /// No description provided for @busyDayBadge.
  ///
  /// In en, this message translates to:
  /// **'Busy day'**
  String get busyDayBadge;

  /// No description provided for @studyWeekBadge.
  ///
  /// In en, this message translates to:
  /// **'Week {week} · {parity}'**
  String studyWeekBadge(int week, String parity);

  /// No description provided for @studyWeekNumber.
  ///
  /// In en, this message translates to:
  /// **'Week {week}'**
  String studyWeekNumber(int week);

  /// No description provided for @weekParityEvenFull.
  ///
  /// In en, this message translates to:
  /// **'even'**
  String get weekParityEvenFull;

  /// No description provided for @weekParityOddFull.
  ///
  /// In en, this message translates to:
  /// **'odd'**
  String get weekParityOddFull;

  /// Odd study week, as printed in the header summary line
  ///
  /// In en, this message translates to:
  /// **'numerator'**
  String get weekParityNumerator;

  /// Even study week, as printed in the header summary line
  ///
  /// In en, this message translates to:
  /// **'denominator'**
  String get weekParityDenominator;

  /// Distinct buildings the day's classes are spread across
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} building} other{{count} buildings}}'**
  String campusesCount(num count);

  /// Bare minute amount, e.g. the ONGOING · 34 MIN marker
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String minutesShort(int minutes);

  /// Live-lesson marker on the home ink block, printed in caps
  ///
  /// In en, this message translates to:
  /// **'ongoing'**
  String get homeOngoingShort;

  /// No description provided for @backToToday.
  ///
  /// In en, this message translates to:
  /// **'← today'**
  String get backToToday;

  /// No description provided for @offlineFromCache.
  ///
  /// In en, this message translates to:
  /// **'No connection — schedule from cache'**
  String get offlineFromCache;

  /// No description provided for @updatedAtTime.
  ///
  /// In en, this message translates to:
  /// **'updated {time}'**
  String updatedAtTime(String time);

  /// No description provided for @liveNow.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get liveNow;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noData;

  /// No description provided for @todayLabel.
  ///
  /// In en, this message translates to:
  /// **'today'**
  String get todayLabel;

  /// No description provided for @tomorrowLabel.
  ///
  /// In en, this message translates to:
  /// **'tomorrow'**
  String get tomorrowLabel;

  /// No description provided for @yesterdayLabel.
  ///
  /// In en, this message translates to:
  /// **'yesterday'**
  String get yesterdayLabel;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} min ago'**
  String minutesAgo(int count);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} h ago'**
  String hoursAgo(int count);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} d ago'**
  String daysAgo(int count);

  /// No description provided for @lessonsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{no classes} =1{{count} class} other{{count} classes}}'**
  String lessonsCount(num count);

  /// No description provided for @activitiesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} activity} other{{count} activities}}'**
  String activitiesCount(num count);

  /// No description provided for @windowsCountSuffix.
  ///
  /// In en, this message translates to:
  /// **'+{count, plural, =1{{count} window} other{{count} windows}}'**
  String windowsCountSuffix(num count);

  /// No description provided for @eventsCountSuffix.
  ///
  /// In en, this message translates to:
  /// **'+{count, plural, =1{{count} event} other{{count} events}}'**
  String eventsCountSuffix(num count);

  /// No description provided for @scheduleQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get scheduleQuickActions;

  /// No description provided for @scheduleActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage schedule'**
  String get scheduleActionsTitle;

  /// No description provided for @scheduleActionsImportant.
  ///
  /// In en, this message translates to:
  /// **'Important'**
  String get scheduleActionsImportant;

  /// No description provided for @scheduleActionsTools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get scheduleActionsTools;

  /// No description provided for @scheduleActionsSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings and sharing'**
  String get scheduleActionsSettings;

  /// No description provided for @mySchedulesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create or open your own schedule'**
  String get mySchedulesSubtitle;

  /// No description provided for @changesTitle.
  ///
  /// In en, this message translates to:
  /// **'Changes'**
  String get changesTitle;

  /// No description provided for @changesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Moves, cancellations and substitutions'**
  String get changesSubtitle;

  /// No description provided for @compareTitle.
  ///
  /// In en, this message translates to:
  /// **'Compare'**
  String get compareTitle;

  /// No description provided for @compareSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find shared windows with another schedule'**
  String get compareSubtitle;

  /// No description provided for @sessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Exams'**
  String get sessionTitle;

  /// No description provided for @sessionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Countdown to your exams'**
  String get sessionSubtitle;

  /// No description provided for @analyticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analyticsTitle;

  /// No description provided for @analyticsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Load by days and lesson types'**
  String get analyticsSubtitle;

  /// No description provided for @exportScheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Export schedule'**
  String get exportScheduleTitle;

  /// No description provided for @exportScheduleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sync classes with any calendar'**
  String get exportScheduleSubtitle;

  /// No description provided for @filtersTitle.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filtersTitle;

  /// No description provided for @filtersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'What to show in the schedule'**
  String get filtersSubtitle;

  /// No description provided for @viewList.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get viewList;

  /// No description provided for @viewDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get viewDay;

  /// No description provided for @viewWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get viewWeek;

  /// No description provided for @viewMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get viewMonth;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterLectures.
  ///
  /// In en, this message translates to:
  /// **'Lectures'**
  String get filterLectures;

  /// No description provided for @filterSeminars.
  ///
  /// In en, this message translates to:
  /// **'Seminars'**
  String get filterSeminars;

  /// No description provided for @filterLabs.
  ///
  /// In en, this message translates to:
  /// **'Labs'**
  String get filterLabs;

  /// No description provided for @filterExams.
  ///
  /// In en, this message translates to:
  /// **'Exams'**
  String get filterExams;

  /// No description provided for @filterLabsFull.
  ///
  /// In en, this message translates to:
  /// **'Laboratory classes'**
  String get filterLabsFull;

  /// No description provided for @filterExamsFull.
  ///
  /// In en, this message translates to:
  /// **'Credits and exams'**
  String get filterExamsFull;

  /// No description provided for @filterWordAll.
  ///
  /// In en, this message translates to:
  /// **'classes'**
  String get filterWordAll;

  /// No description provided for @filterWordLectures.
  ///
  /// In en, this message translates to:
  /// **'lectures'**
  String get filterWordLectures;

  /// No description provided for @filterWordSeminars.
  ///
  /// In en, this message translates to:
  /// **'seminars'**
  String get filterWordSeminars;

  /// No description provided for @filterWordLabs.
  ///
  /// In en, this message translates to:
  /// **'labs'**
  String get filterWordLabs;

  /// No description provided for @filterWordExams.
  ///
  /// In en, this message translates to:
  /// **'exams'**
  String get filterWordExams;

  /// No description provided for @pastTodaySummary.
  ///
  /// In en, this message translates to:
  /// **'Passed today: {lessons}'**
  String pastTodaySummary(String lessons);

  /// No description provided for @hidePastLessons.
  ///
  /// In en, this message translates to:
  /// **'Hide passed'**
  String get hidePastLessons;

  /// No description provided for @xpAmount.
  ///
  /// In en, this message translates to:
  /// **'+{xp} XP'**
  String xpAmount(int xp);

  /// No description provided for @windowMinutes.
  ///
  /// In en, this message translates to:
  /// **'Window {minutes} min'**
  String windowMinutes(int minutes);

  /// No description provided for @gapCoffeeHint.
  ///
  /// In en, this message translates to:
  /// **'· coffee'**
  String get gapCoffeeHint;

  /// No description provided for @freeClassrooms.
  ///
  /// In en, this message translates to:
  /// **'Free classrooms'**
  String get freeClassrooms;

  /// No description provided for @endOfDay.
  ///
  /// In en, this message translates to:
  /// **'End of day — {time}'**
  String endOfDay(String time);

  /// No description provided for @endOfDayPotential.
  ///
  /// In en, this message translates to:
  /// **'potential +{xp} XP'**
  String endOfDayPotential(int xp);

  /// No description provided for @swipeCoachMark.
  ///
  /// In en, this message translates to:
  /// **'Swipe a class left — note, reminder, route'**
  String get swipeCoachMark;

  /// No description provided for @swipeActionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get swipeActionsLabel;

  /// No description provided for @nextInMinutes.
  ///
  /// In en, this message translates to:
  /// **'Next · in {minutes} min'**
  String nextInMinutes(int minutes);

  /// No description provided for @nextInHours.
  ///
  /// In en, this message translates to:
  /// **'Next · in {hours} h'**
  String nextInHours(String hours);

  /// No description provided for @minutesLeft.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min left'**
  String minutesLeft(int minutes);

  /// No description provided for @classroomNotSpecified.
  ///
  /// In en, this message translates to:
  /// **'Room not specified'**
  String get classroomNotSpecified;

  /// No description provided for @prepHintLab.
  ///
  /// In en, this message translates to:
  /// **'For class: laptop and lab materials'**
  String get prepHintLab;

  /// No description provided for @prepHintExam.
  ///
  /// In en, this message translates to:
  /// **'Review the key exam questions'**
  String get prepHintExam;

  /// No description provided for @prepHintCourse.
  ///
  /// In en, this message translates to:
  /// **'Check your course-work plan'**
  String get prepHintCourse;

  /// No description provided for @calloutCancelled.
  ///
  /// In en, this message translates to:
  /// **'Class cancelled'**
  String get calloutCancelled;

  /// No description provided for @calloutMoved.
  ///
  /// In en, this message translates to:
  /// **'Class moved: was {time}'**
  String calloutMoved(String time);

  /// No description provided for @calloutRoomChanged.
  ///
  /// In en, this message translates to:
  /// **'Room changed: was {rooms}'**
  String calloutRoomChanged(String rooms);

  /// No description provided for @calloutTeacherChanged.
  ///
  /// In en, this message translates to:
  /// **'Teacher substituted: {teachers}'**
  String calloutTeacherChanged(String teachers);

  /// No description provided for @calloutAdded.
  ///
  /// In en, this message translates to:
  /// **'Class added'**
  String get calloutAdded;

  /// No description provided for @emptyFilterTitle.
  ///
  /// In en, this message translates to:
  /// **'No {filter} on this day'**
  String emptyFilterTitle(String filter);

  /// No description provided for @emptyFilterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try another day or reset the filter'**
  String get emptyFilterSubtitle;

  /// No description provided for @liveActionChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get liveActionChat;

  /// No description provided for @liveActionRecord.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get liveActionRecord;

  /// No description provided for @friendsInClass.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{{name} is in class} =1{{name} and 1 other in class} other{{name} and {count} others in class}}'**
  String friendsInClass(String name, int count);

  /// No description provided for @noLessonsShort.
  ///
  /// In en, this message translates to:
  /// **'No classes'**
  String get noLessonsShort;

  /// No description provided for @weekendTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekend!'**
  String get weekendTitle;

  /// No description provided for @weekendShort.
  ///
  /// In en, this message translates to:
  /// **'Weekend'**
  String get weekendShort;

  /// No description provided for @scheduleTransferredDayOff.
  ///
  /// In en, this message translates to:
  /// **'Transferred day off'**
  String get scheduleTransferredDayOff;

  /// No description provided for @scheduleTransferredWorkday.
  ///
  /// In en, this message translates to:
  /// **'Transferred workday'**
  String get scheduleTransferredWorkday;

  /// No description provided for @scheduleTransferCalendarPending.
  ///
  /// In en, this message translates to:
  /// **'Day-off transfers for {year} have not been published yet'**
  String scheduleTransferCalendarPending(int year);

  /// No description provided for @scheduleWeekHoldLesson.
  ///
  /// In en, this message translates to:
  /// **'Hold to expand class details'**
  String get scheduleWeekHoldLesson;

  /// No description provided for @scheduleWeekHoldToExpand.
  ///
  /// In en, this message translates to:
  /// **'{count} more · hold'**
  String scheduleWeekHoldToExpand(int count);

  /// No description provided for @scheduleWeekHoldToCollapse.
  ///
  /// In en, this message translates to:
  /// **'All classes · hold to collapse'**
  String get scheduleWeekHoldToCollapse;

  /// No description provided for @whatToDo.
  ///
  /// In en, this message translates to:
  /// **'What to do?'**
  String get whatToDo;

  /// No description provided for @noLessonsSelectedDay.
  ///
  /// In en, this message translates to:
  /// **'No classes on the selected day'**
  String get noLessonsSelectedDay;

  /// No description provided for @dayOffTitle.
  ///
  /// In en, this message translates to:
  /// **'No classes today'**
  String get dayOffTitle;

  /// No description provided for @dayOffWithActivities.
  ///
  /// In en, this message translates to:
  /// **'No classes, but you have planned activities.'**
  String get dayOffWithActivities;

  /// No description provided for @dayOffFree.
  ///
  /// In en, this message translates to:
  /// **'No classes. Plan your own things.'**
  String get dayOffFree;

  /// No description provided for @addActivity.
  ///
  /// In en, this message translates to:
  /// **'Add activity'**
  String get addActivity;

  /// No description provided for @nearestLessonText.
  ///
  /// In en, this message translates to:
  /// **'No classes. Nearest — {day} at {time}, {subject}.'**
  String nearestLessonText(String day, String time, String subject);

  /// No description provided for @goToMonday.
  ///
  /// In en, this message translates to:
  /// **'To Monday'**
  String get goToMonday;

  /// No description provided for @goToToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get goToToday;

  /// No description provided for @previousMonth.
  ///
  /// In en, this message translates to:
  /// **'Previous month'**
  String get previousMonth;

  /// No description provided for @nextMonth.
  ///
  /// In en, this message translates to:
  /// **'Next month'**
  String get nextMonth;

  /// No description provided for @previousWeek.
  ///
  /// In en, this message translates to:
  /// **'Previous week'**
  String get previousWeek;

  /// No description provided for @nextWeek.
  ///
  /// In en, this message translates to:
  /// **'Next week'**
  String get nextWeek;

  /// No description provided for @legendLessons.
  ///
  /// In en, this message translates to:
  /// **'Classes'**
  String get legendLessons;

  /// No description provided for @legendHoliday.
  ///
  /// In en, this message translates to:
  /// **'Public holiday'**
  String get legendHoliday;

  /// No description provided for @legendRetake.
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get legendRetake;

  /// No description provided for @legendEvent.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get legendEvent;

  /// No description provided for @weekdayMonday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get weekdayMonday;

  /// No description provided for @weekdayTuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get weekdayTuesday;

  /// No description provided for @weekdayWednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get weekdayWednesday;

  /// No description provided for @weekdayThursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get weekdayThursday;

  /// No description provided for @weekdayFriday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get weekdayFriday;

  /// No description provided for @weekdaySaturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get weekdaySaturday;

  /// No description provided for @weekdaySunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get weekdaySunday;

  /// No description provided for @weekdayShortMon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get weekdayShortMon;

  /// No description provided for @weekdayShortTue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get weekdayShortTue;

  /// No description provided for @weekdayShortWed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get weekdayShortWed;

  /// No description provided for @weekdayShortThu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get weekdayShortThu;

  /// No description provided for @weekdayShortFri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get weekdayShortFri;

  /// No description provided for @weekdayShortSat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get weekdayShortSat;

  /// No description provided for @weekdayShortSun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get weekdayShortSun;

  /// No description provided for @exportPeriodToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get exportPeriodToday;

  /// No description provided for @exportPeriodWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get exportPeriodWeek;

  /// No description provided for @exportPeriodSemester.
  ///
  /// In en, this message translates to:
  /// **'Semester'**
  String get exportPeriodSemester;

  /// No description provided for @exportWhereSection.
  ///
  /// In en, this message translates to:
  /// **'Where'**
  String get exportWhereSection;

  /// No description provided for @exportOptionsSection.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get exportOptionsSection;

  /// No description provided for @exportSystemCalendar.
  ///
  /// In en, this message translates to:
  /// **'System calendar'**
  String get exportSystemCalendar;

  /// No description provided for @exportSystemCalendarSub.
  ///
  /// In en, this message translates to:
  /// **'added to the device calendar'**
  String get exportSystemCalendarSub;

  /// No description provided for @exportGoogleCalendar.
  ///
  /// In en, this message translates to:
  /// **'Google Calendar'**
  String get exportGoogleCalendar;

  /// No description provided for @exportGoogleCalendarSub.
  ///
  /// In en, this message translates to:
  /// **'via the device calendar'**
  String get exportGoogleCalendarSub;

  /// No description provided for @exportIcsFile.
  ///
  /// In en, this message translates to:
  /// **'.ics file'**
  String get exportIcsFile;

  /// No description provided for @exportIcsFileSub.
  ///
  /// In en, this message translates to:
  /// **'one-off, no updates'**
  String get exportIcsFileSub;

  /// No description provided for @exportPng.
  ///
  /// In en, this message translates to:
  /// **'PNG image'**
  String get exportPng;

  /// No description provided for @exportPngSub.
  ///
  /// In en, this message translates to:
  /// **'for stories / save to photos'**
  String get exportPngSub;

  /// No description provided for @exportReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get exportReminders;

  /// No description provided for @exportRemindersSub.
  ///
  /// In en, this message translates to:
  /// **'15 minutes before class'**
  String get exportRemindersSub;

  /// No description provided for @exportAutoUpdate.
  ///
  /// In en, this message translates to:
  /// **'Auto-update'**
  String get exportAutoUpdate;

  /// No description provided for @exportAutoUpdateSub.
  ///
  /// In en, this message translates to:
  /// **'picks up schedule changes'**
  String get exportAutoUpdateSub;

  /// No description provided for @exportIncludeRooms.
  ///
  /// In en, this message translates to:
  /// **'Include room and campus'**
  String get exportIncludeRooms;

  /// No description provided for @exportActionToday.
  ///
  /// In en, this message translates to:
  /// **'Export today'**
  String get exportActionToday;

  /// No description provided for @exportActionWeek.
  ///
  /// In en, this message translates to:
  /// **'Export week'**
  String get exportActionWeek;

  /// No description provided for @exportActionSemester.
  ///
  /// In en, this message translates to:
  /// **'Export semester'**
  String get exportActionSemester;

  /// No description provided for @exportFormatSoon.
  ///
  /// In en, this message translates to:
  /// **'This format is coming soon — using the device calendar for now'**
  String get exportFormatSoon;

  /// No description provided for @exportStarted.
  ///
  /// In en, this message translates to:
  /// **'Exporting {lessons} to the calendar'**
  String exportStarted(String lessons);

  /// No description provided for @filtersLessonTypes.
  ///
  /// In en, this message translates to:
  /// **'Lesson types'**
  String get filtersLessonTypes;

  /// No description provided for @filtersDisplaySection.
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get filtersDisplaySection;

  /// No description provided for @filtersShowGaps.
  ///
  /// In en, this message translates to:
  /// **'Show windows'**
  String get filtersShowGaps;

  /// No description provided for @filtersShowGapsSub.
  ///
  /// In en, this message translates to:
  /// **'breaks between classes'**
  String get filtersShowGapsSub;

  /// No description provided for @filtersPastLessons.
  ///
  /// In en, this message translates to:
  /// **'Past classes'**
  String get filtersPastLessons;

  /// No description provided for @filtersPastLessonsSub.
  ///
  /// In en, this message translates to:
  /// **'collapse automatically'**
  String get filtersPastLessonsSub;

  /// No description provided for @filtersHiddenSection.
  ///
  /// In en, this message translates to:
  /// **'Hidden classes'**
  String get filtersHiddenSection;

  /// No description provided for @filtersHiddenHint.
  ///
  /// In en, this message translates to:
  /// **'Tap to bring a class back to the schedule'**
  String get filtersHiddenHint;

  /// No description provided for @filtersRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get filtersRestore;

  /// No description provided for @classActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Class actions'**
  String get classActionsTitle;

  /// No description provided for @classActionRate.
  ///
  /// In en, this message translates to:
  /// **'Rate the class'**
  String get classActionRate;

  /// No description provided for @classActionRateSub.
  ///
  /// In en, this message translates to:
  /// **'reaction for the group'**
  String get classActionRateSub;

  /// No description provided for @classActionNote.
  ///
  /// In en, this message translates to:
  /// **'Add a note'**
  String get classActionNote;

  /// No description provided for @classActionRoute.
  ///
  /// In en, this message translates to:
  /// **'Build a route'**
  String get classActionRoute;

  /// No description provided for @classActionRemind.
  ///
  /// In en, this message translates to:
  /// **'Remind'**
  String get classActionRemind;

  /// No description provided for @classActionRemindSub.
  ///
  /// In en, this message translates to:
  /// **'15 min before'**
  String get classActionRemindSub;

  /// No description provided for @classActionShare.
  ///
  /// In en, this message translates to:
  /// **'Share the class'**
  String get classActionShare;

  /// No description provided for @classActionHide.
  ///
  /// In en, this message translates to:
  /// **'Hide from schedule'**
  String get classActionHide;

  /// No description provided for @reactionSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'How was the class?'**
  String get reactionSheetTitle;

  /// No description provided for @reactionFire.
  ///
  /// In en, this message translates to:
  /// **'Fire'**
  String get reactionFire;

  /// No description provided for @reactionBrain.
  ///
  /// In en, this message translates to:
  /// **'Useful'**
  String get reactionBrain;

  /// No description provided for @reactionLove.
  ///
  /// In en, this message translates to:
  /// **'Top'**
  String get reactionLove;

  /// No description provided for @reactionSad.
  ///
  /// In en, this message translates to:
  /// **'Sad'**
  String get reactionSad;

  /// No description provided for @reactionFlushed.
  ///
  /// In en, this message translates to:
  /// **'Surprised'**
  String get reactionFlushed;

  /// No description provided for @reactionSick.
  ///
  /// In en, this message translates to:
  /// **'Disgusting'**
  String get reactionSick;

  /// No description provided for @reactionPoo.
  ///
  /// In en, this message translates to:
  /// **'Awful'**
  String get reactionPoo;

  /// No description provided for @reactionThinking.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get reactionThinking;

  /// No description provided for @reactionSleepy.
  ///
  /// In en, this message translates to:
  /// **'Boring'**
  String get reactionSleepy;

  /// No description provided for @reactionSkull.
  ///
  /// In en, this message translates to:
  /// **'Rough'**
  String get reactionSkull;

  /// No description provided for @reactionMindblown.
  ///
  /// In en, this message translates to:
  /// **'Blast'**
  String get reactionMindblown;

  /// No description provided for @reactionRespect.
  ///
  /// In en, this message translates to:
  /// **'Respect'**
  String get reactionRespect;

  /// No description provided for @anonymously.
  ///
  /// In en, this message translates to:
  /// **'Anonymously'**
  String get anonymously;

  /// No description provided for @anonymouslySub.
  ///
  /// In en, this message translates to:
  /// **'your name won\'t be shown to the group'**
  String get anonymouslySub;

  /// No description provided for @reactionSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get reactionSend;

  /// No description provided for @reactionSent.
  ///
  /// In en, this message translates to:
  /// **'Reaction sent {emoji}'**
  String reactionSent(String emoji);

  /// No description provided for @reactionRemoved.
  ///
  /// In en, this message translates to:
  /// **'Reaction removed'**
  String get reactionRemoved;

  /// No description provided for @reactionAdded.
  ///
  /// In en, this message translates to:
  /// **'Reaction added!'**
  String get reactionAdded;

  /// No description provided for @reminderSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Remind'**
  String get reminderSheetTitle;

  /// No description provided for @reminder15Min.
  ///
  /// In en, this message translates to:
  /// **'15 minutes before'**
  String get reminder15Min;

  /// No description provided for @reminder15MinSub.
  ///
  /// In en, this message translates to:
  /// **'enough time to walk'**
  String get reminder15MinSub;

  /// No description provided for @reminder5Min.
  ///
  /// In en, this message translates to:
  /// **'5 minutes before'**
  String get reminder5Min;

  /// No description provided for @reminder5MinSub.
  ///
  /// In en, this message translates to:
  /// **'if you\'re already nearby'**
  String get reminder5MinSub;

  /// No description provided for @reminderMorning.
  ///
  /// In en, this message translates to:
  /// **'In the morning of the class day'**
  String get reminderMorning;

  /// No description provided for @reminderMorningSub.
  ///
  /// In en, this message translates to:
  /// **'at 08:00'**
  String get reminderMorningSub;

  /// No description provided for @reminderSet.
  ///
  /// In en, this message translates to:
  /// **'Set reminder'**
  String get reminderSet;

  /// No description provided for @reminderSetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Reminder set'**
  String get reminderSetSuccess;

  /// Reminder notification body prefix before the class start time
  ///
  /// In en, this message translates to:
  /// **'at {time}'**
  String reminderAtTime(String time);

  /// No description provided for @reminderWhenSection.
  ///
  /// In en, this message translates to:
  /// **'When'**
  String get reminderWhenSection;

  /// No description provided for @reminderHowSection.
  ///
  /// In en, this message translates to:
  /// **'How'**
  String get reminderHowSection;

  /// No description provided for @reminderCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom time'**
  String get reminderCustom;

  /// No description provided for @reminderCustomHint.
  ///
  /// In en, this message translates to:
  /// **'pick a time'**
  String get reminderCustomHint;

  /// No description provided for @reminderCustomAt.
  ///
  /// In en, this message translates to:
  /// **'at {time}'**
  String reminderCustomAt(String time);

  /// No description provided for @reminderPush.
  ///
  /// In en, this message translates to:
  /// **'Push notification'**
  String get reminderPush;

  /// No description provided for @reminderRoute.
  ///
  /// In en, this message translates to:
  /// **'With route to the classroom'**
  String get reminderRoute;

  /// No description provided for @reminderTraffic.
  ///
  /// In en, this message translates to:
  /// **'Account for traffic'**
  String get reminderTraffic;

  /// No description provided for @reminderTrafficSub.
  ///
  /// In en, this message translates to:
  /// **'leave earlier if it\'s far'**
  String get reminderTrafficSub;

  /// No description provided for @reminderSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder set'**
  String get reminderSuccessTitle;

  /// No description provided for @reminderSuccessBody.
  ///
  /// In en, this message translates to:
  /// **'We\'ll remind you at {time}'**
  String reminderSuccessBody(String time);

  /// No description provided for @reminderSuccessBodyRoute.
  ///
  /// In en, this message translates to:
  /// **'We\'ll remind you at {time} with a route to {room}'**
  String reminderSuccessBodyRoute(String time, String room);

  /// No description provided for @hideLessonTitle.
  ///
  /// In en, this message translates to:
  /// **'Hide the class?'**
  String get hideLessonTitle;

  /// No description provided for @hideLessonBody.
  ///
  /// In en, this message translates to:
  /// **'“{subject}” will disappear from the schedule. You can bring it back in Filters.'**
  String hideLessonBody(String subject);

  /// No description provided for @hideLessonAllSubject.
  ///
  /// In en, this message translates to:
  /// **'Hide all classes of this subject'**
  String get hideLessonAllSubject;

  /// No description provided for @hideLessonAction.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get hideLessonAction;

  /// No description provided for @hideLessonDone.
  ///
  /// In en, this message translates to:
  /// **'Class hidden from the schedule'**
  String get hideLessonDone;

  /// No description provided for @sessionScheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Exam schedule'**
  String get sessionScheduleTitle;

  /// No description provided for @sessionNoExams.
  ///
  /// In en, this message translates to:
  /// **'No exams or credits in the schedule yet.'**
  String get sessionNoExams;

  /// No description provided for @sessionNoExamsTitle.
  ///
  /// In en, this message translates to:
  /// **'No exams'**
  String get sessionNoExamsTitle;

  /// No description provided for @sessionUntilFirstExam.
  ///
  /// In en, this message translates to:
  /// **'Until the first exam'**
  String get sessionUntilFirstExam;

  /// No description provided for @sessionNoPlannedExams.
  ///
  /// In en, this message translates to:
  /// **'no planned exams'**
  String get sessionNoPlannedExams;

  /// No description provided for @sessionHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'days · {subject} · {date}'**
  String sessionHeroSubtitle(String subject, String date);

  /// No description provided for @sessionExamsCredits.
  ///
  /// In en, this message translates to:
  /// **'exams · credits'**
  String get sessionExamsCredits;

  /// No description provided for @sessionReadinessLabel.
  ///
  /// In en, this message translates to:
  /// **'readiness'**
  String get sessionReadinessLabel;

  /// No description provided for @sessionDaysTotal.
  ///
  /// In en, this message translates to:
  /// **'days total'**
  String get sessionDaysTotal;

  /// No description provided for @sessionDaysShort.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get sessionDaysShort;

  /// No description provided for @sessionReadiness.
  ///
  /// In en, this message translates to:
  /// **'Readiness'**
  String get sessionReadiness;

  /// No description provided for @sessionStudyPlanText.
  ///
  /// In en, this message translates to:
  /// **'Today — {subject} (2 h). Readiness is only {percent}%'**
  String sessionStudyPlanText(String subject, int percent);

  /// No description provided for @compareYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get compareYou;

  /// No description provided for @compareMySchedule.
  ///
  /// In en, this message translates to:
  /// **'My schedule'**
  String get compareMySchedule;

  /// No description provided for @comparePick.
  ///
  /// In en, this message translates to:
  /// **'Pick a schedule'**
  String get comparePick;

  /// No description provided for @comparePickGroup.
  ///
  /// In en, this message translates to:
  /// **'Pick a group'**
  String get comparePickGroup;

  /// No description provided for @compareFriend.
  ///
  /// In en, this message translates to:
  /// **'friend'**
  String get compareFriend;

  /// No description provided for @compareTapToPick.
  ///
  /// In en, this message translates to:
  /// **'tap to pick'**
  String get compareTapToPick;

  /// No description provided for @compareEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Add a friend\'s schedule to see shared windows and classes you attend together.'**
  String get compareEmptyHint;

  /// No description provided for @compareNoLessonsBoth.
  ///
  /// In en, this message translates to:
  /// **'No classes for either of you this day'**
  String get compareNoLessonsBoth;

  /// No description provided for @compareCommonWindow.
  ///
  /// In en, this message translates to:
  /// **'Shared window {from}–{to} — both free. Coffee?'**
  String compareCommonWindow(String from, String to);

  /// No description provided for @compareBothFree.
  ///
  /// In en, this message translates to:
  /// **'Both free'**
  String get compareBothFree;

  /// No description provided for @compareFreeCell.
  ///
  /// In en, this message translates to:
  /// **'free'**
  String get compareFreeCell;

  /// No description provided for @compareTogether.
  ///
  /// In en, this message translates to:
  /// **'together'**
  String get compareTogether;

  /// No description provided for @comparePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Compare with whom?'**
  String get comparePickerTitle;

  /// No description provided for @comparePickerDescription.
  ///
  /// In en, this message translates to:
  /// **'Find your friend\'s group'**
  String get comparePickerDescription;

  /// No description provided for @comparePickerHint.
  ///
  /// In en, this message translates to:
  /// **'IKBO-09-22…'**
  String get comparePickerHint;

  /// No description provided for @compareLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load the group schedule'**
  String get compareLoadError;

  /// No description provided for @changesPushBanner.
  ///
  /// In en, this message translates to:
  /// **'Push on any change in your schedule'**
  String get changesPushBanner;

  /// No description provided for @changesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No changes yet'**
  String get changesEmptyTitle;

  /// No description provided for @changesEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'When classes get moved, cancelled or rescheduled — it all shows up here.'**
  String get changesEmptySubtitle;

  /// No description provided for @changeMovedTitle.
  ///
  /// In en, this message translates to:
  /// **'{subject} moved'**
  String changeMovedTitle(String subject);

  /// No description provided for @changeMovedDescription.
  ///
  /// In en, this message translates to:
  /// **'was {from} → now {to}'**
  String changeMovedDescription(String from, String to);

  /// No description provided for @changeCancelledTitle.
  ///
  /// In en, this message translates to:
  /// **'{subject} cancelled'**
  String changeCancelledTitle(String subject);

  /// No description provided for @changeCancelledDescription.
  ///
  /// In en, this message translates to:
  /// **'the {time} class will not take place'**
  String changeCancelledDescription(String time);

  /// No description provided for @changeAddedTitle.
  ///
  /// In en, this message translates to:
  /// **'Class added: {subject}'**
  String changeAddedTitle(String subject);

  /// No description provided for @changeTeacherTitle.
  ///
  /// In en, this message translates to:
  /// **'Teacher substituted'**
  String get changeTeacherTitle;

  /// No description provided for @changeRoomTitle.
  ///
  /// In en, this message translates to:
  /// **'Room changed'**
  String get changeRoomTitle;

  /// No description provided for @analyticsHoursPerWeek.
  ///
  /// In en, this message translates to:
  /// **'hours/week'**
  String get analyticsHoursPerWeek;

  /// No description provided for @analyticsAvgPerDay.
  ///
  /// In en, this message translates to:
  /// **'avg classes/day'**
  String get analyticsAvgPerDay;

  /// No description provided for @analyticsLoadByDay.
  ///
  /// In en, this message translates to:
  /// **'Load by day'**
  String get analyticsLoadByDay;

  /// No description provided for @analyticsOverloadedDay.
  ///
  /// In en, this message translates to:
  /// **'{day} is overloaded — {hours} hours'**
  String analyticsOverloadedDay(String day, String hours);

  /// No description provided for @analyticsBalancedWeek.
  ///
  /// In en, this message translates to:
  /// **'The week is balanced'**
  String get analyticsBalancedWeek;

  /// No description provided for @analyticsByType.
  ///
  /// In en, this message translates to:
  /// **'By lesson type'**
  String get analyticsByType;

  /// No description provided for @analyticsInsightLightTitle.
  ///
  /// In en, this message translates to:
  /// **'Best morning — {day}'**
  String analyticsInsightLightTitle(String day);

  /// No description provided for @analyticsInsightLightSub.
  ///
  /// In en, this message translates to:
  /// **'only {hours} h of classes, you can sleep in'**
  String analyticsInsightLightSub(String hours);

  /// No description provided for @analyticsInsightWindowsTitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} window a week} other{{count} windows a week}}'**
  String analyticsInsightWindowsTitle(int count);

  /// No description provided for @analyticsInsightWindowsSub.
  ///
  /// In en, this message translates to:
  /// **'{hours} h between classes in total'**
  String analyticsInsightWindowsSub(String hours);

  /// No description provided for @analyticsNoSchedule.
  ///
  /// In en, this message translates to:
  /// **'Pick a schedule to see analytics.'**
  String get analyticsNoSchedule;

  /// No description provided for @analyticsShareText.
  ///
  /// In en, this message translates to:
  /// **'My week: {hours} hours of classes, on average {avg} classes a day'**
  String analyticsShareText(String hours, String avg);

  /// No description provided for @createScheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Create schedule'**
  String get createScheduleTitle;

  /// No description provided for @createScheduleHeadline.
  ///
  /// In en, this message translates to:
  /// **'How shall we fill the schedule?'**
  String get createScheduleHeadline;

  /// No description provided for @createScheduleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick a convenient way — everything can be adjusted later'**
  String get createScheduleSubtitle;

  /// No description provided for @createWayGroupTitle.
  ///
  /// In en, this message translates to:
  /// **'Find your group'**
  String get createWayGroupTitle;

  /// No description provided for @createWayGroupDescription.
  ///
  /// In en, this message translates to:
  /// **'We\'ll pull the schedule automatically'**
  String get createWayGroupDescription;

  /// No description provided for @createWayFastBadge.
  ///
  /// In en, this message translates to:
  /// **'fast'**
  String get createWayFastBadge;

  /// No description provided for @createWaySearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Teacher or classroom'**
  String get createWaySearchTitle;

  /// No description provided for @createWaySearchDescription.
  ///
  /// In en, this message translates to:
  /// **'Any schedule by name'**
  String get createWaySearchDescription;

  /// No description provided for @createWayScanTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan a schedule photo'**
  String get createWayScanTitle;

  /// No description provided for @createWayScanDescription.
  ///
  /// In en, this message translates to:
  /// **'Recognise the timetable from a photo'**
  String get createWayScanDescription;

  /// No description provided for @createWayScanSoon.
  ///
  /// In en, this message translates to:
  /// **'Schedule scanning is coming soon'**
  String get createWayScanSoon;

  /// No description provided for @createWayManualTitle.
  ///
  /// In en, this message translates to:
  /// **'Fill in manually'**
  String get createWayManualTitle;

  /// No description provided for @createWayManualDescription.
  ///
  /// In en, this message translates to:
  /// **'Add classes one by one'**
  String get createWayManualDescription;

  /// No description provided for @createWayCopyTitle.
  ///
  /// In en, this message translates to:
  /// **'Copy from a groupmate'**
  String get createWayCopyTitle;

  /// No description provided for @createWayCopyDescription.
  ///
  /// In en, this message translates to:
  /// **'Via an invite link'**
  String get createWayCopyDescription;

  /// No description provided for @createWayCopySoon.
  ///
  /// In en, this message translates to:
  /// **'Invite links are coming soon'**
  String get createWayCopySoon;

  /// No description provided for @openMySchedules.
  ///
  /// In en, this message translates to:
  /// **'Open my schedules'**
  String get openMySchedules;

  /// No description provided for @openMySchedulesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Hand-made schedules'**
  String get openMySchedulesSubtitle;

  /// No description provided for @editScheduleSwipeHint.
  ///
  /// In en, this message translates to:
  /// **'Drag to reorder · swipe left to delete'**
  String get editScheduleSwipeHint;

  /// No description provided for @editScheduleEmptyDay.
  ///
  /// In en, this message translates to:
  /// **'No classes this day — add the first one'**
  String get editScheduleEmptyDay;

  /// No description provided for @editScheduleNotFound.
  ///
  /// In en, this message translates to:
  /// **'Schedule not found'**
  String get editScheduleNotFound;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hi, {name}'**
  String homeGreeting(String name);

  /// No description provided for @homeNinja.
  ///
  /// In en, this message translates to:
  /// **'ninja'**
  String get homeNinja;

  /// No description provided for @homeStudent.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get homeStudent;

  /// No description provided for @homePass.
  ///
  /// In en, this message translates to:
  /// **'Pass'**
  String get homePass;

  /// No description provided for @homeOngoingNow.
  ///
  /// In en, this message translates to:
  /// **'ONGOING NOW'**
  String get homeOngoingNow;

  /// No description provided for @homeUntil.
  ///
  /// In en, this message translates to:
  /// **'until {time}'**
  String homeUntil(String time);

  /// No description provided for @homeNextLabel.
  ///
  /// In en, this message translates to:
  /// **'NEXT'**
  String get homeNextLabel;

  /// No description provided for @homeInMinutes.
  ///
  /// In en, this message translates to:
  /// **'in {minutes} min'**
  String homeInMinutes(int minutes);

  /// No description provided for @homeShurikens.
  ///
  /// In en, this message translates to:
  /// **'Shurikens'**
  String get homeShurikens;

  /// No description provided for @homeStreak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get homeStreak;

  /// No description provided for @homeDaysShort.
  ///
  /// In en, this message translates to:
  /// **'{days} d'**
  String homeDaysShort(int days);

  /// No description provided for @homeHoursShort.
  ///
  /// In en, this message translates to:
  /// **'{hours} h'**
  String homeHoursShort(int hours);

  /// No description provided for @homeRoomsFree.
  ///
  /// In en, this message translates to:
  /// **'free'**
  String get homeRoomsFree;

  /// No description provided for @homeKnowledgeBank.
  ///
  /// In en, this message translates to:
  /// **'Knowledge bank'**
  String get homeKnowledgeBank;

  /// No description provided for @homeBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get homeBalance;

  /// No description provided for @homeOpen.
  ///
  /// In en, this message translates to:
  /// **'open'**
  String get homeOpen;

  /// No description provided for @homeGrades.
  ///
  /// In en, this message translates to:
  /// **'Grades'**
  String get homeGrades;

  /// No description provided for @homeDeadlines.
  ///
  /// In en, this message translates to:
  /// **'Deadlines'**
  String get homeDeadlines;

  /// No description provided for @homeBurningCount.
  ///
  /// In en, this message translates to:
  /// **'{count} burning'**
  String homeBurningCount(int count);

  /// No description provided for @homeActiveShort.
  ///
  /// In en, this message translates to:
  /// **'{count} active'**
  String homeActiveShort(int count);

  /// No description provided for @homePeople.
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get homePeople;

  /// No description provided for @homeCreateArrow.
  ///
  /// In en, this message translates to:
  /// **'Create →'**
  String get homeCreateArrow;

  /// No description provided for @homeAllArrow.
  ///
  /// In en, this message translates to:
  /// **'All {count} →'**
  String homeAllArrow(int count);

  /// No description provided for @homeNearDontMiss.
  ///
  /// In en, this message translates to:
  /// **'{count} near · don\'\'t miss'**
  String homeNearDontMiss(int count);

  /// No description provided for @homeNoDeadlines.
  ///
  /// In en, this message translates to:
  /// **'No deadlines — take a breather'**
  String get homeNoDeadlines;

  /// No description provided for @homeScheduleArrow.
  ///
  /// In en, this message translates to:
  /// **'Schedule →'**
  String get homeScheduleArrow;

  /// No description provided for @homeClassesLeft.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} class left} other{{count} classes left}}'**
  String homeClassesLeft(int count);

  /// No description provided for @homeNoMoreToday.
  ///
  /// In en, this message translates to:
  /// **'No more classes today'**
  String get homeNoMoreToday;

  /// No description provided for @homeTrending.
  ///
  /// In en, this message translates to:
  /// **'Trending'**
  String get homeTrending;

  /// No description provided for @homeFeedArrow.
  ///
  /// In en, this message translates to:
  /// **'Feed →'**
  String get homeFeedArrow;

  /// No description provided for @homeAllClassesDone.
  ///
  /// In en, this message translates to:
  /// **'That\'\'s all for today'**
  String get homeAllClassesDone;

  /// No description provided for @homeOpenWeek.
  ///
  /// In en, this message translates to:
  /// **'open week schedule'**
  String get homeOpenWeek;

  /// No description provided for @homeOverdue.
  ///
  /// In en, this message translates to:
  /// **'overdue'**
  String get homeOverdue;

  /// No description provided for @homeNextTag.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get homeNextTag;

  /// No description provided for @homeCreditTag.
  ///
  /// In en, this message translates to:
  /// **'Credit'**
  String get homeCreditTag;

  /// No description provided for @homeDueToday.
  ///
  /// In en, this message translates to:
  /// **'today {time}'**
  String homeDueToday(String time);

  /// No description provided for @homeDueTomorrow.
  ///
  /// In en, this message translates to:
  /// **'tomorrow {time}'**
  String homeDueTomorrow(String time);

  /// No description provided for @scheduleUpdatedChanges.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Schedule updated: {count} change} other{Schedule updated: {count} changes}}'**
  String scheduleUpdatedChanges(int count);

  /// No description provided for @scheduleActionFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'\'t do that — has the time already passed?'**
  String get scheduleActionFailed;

  /// No description provided for @lessonEditorCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'New class'**
  String get lessonEditorCreateTitle;

  /// No description provided for @lessonEditorEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit class'**
  String get lessonEditorEditTitle;

  /// No description provided for @lessonEditorStepBasic.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get lessonEditorStepBasic;

  /// No description provided for @lessonEditorStepDates.
  ///
  /// In en, this message translates to:
  /// **'Dates'**
  String get lessonEditorStepDates;

  /// No description provided for @lessonEditorStepLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get lessonEditorStepLocation;

  /// No description provided for @lessonEditorStepPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get lessonEditorStepPreview;

  /// No description provided for @lessonEditorSubjectName.
  ///
  /// In en, this message translates to:
  /// **'Subject name'**
  String get lessonEditorSubjectName;

  /// No description provided for @lessonEditorSubjectHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the subject name'**
  String get lessonEditorSubjectHint;

  /// No description provided for @lessonEditorSubjectLabel.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get lessonEditorSubjectLabel;

  /// No description provided for @lessonEditorTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Class type'**
  String get lessonEditorTypeLabel;

  /// No description provided for @lessonEditorTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get lessonEditorTimeLabel;

  /// No description provided for @lessonEditorRoomLabel.
  ///
  /// In en, this message translates to:
  /// **'Classroom'**
  String get lessonEditorRoomLabel;

  /// No description provided for @lessonEditorTeacherLabel.
  ///
  /// In en, this message translates to:
  /// **'Teacher'**
  String get lessonEditorTeacherLabel;

  /// No description provided for @lessonEditorDatesLabel.
  ///
  /// In en, this message translates to:
  /// **'Dates'**
  String get lessonEditorDatesLabel;

  /// No description provided for @lessonEditorNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get lessonEditorNotSet;

  /// No description provided for @lessonEditorDatesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} date} other{{count} dates}}'**
  String lessonEditorDatesCount(int count);

  /// No description provided for @lessonEditorColorLabel.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get lessonEditorColorLabel;

  /// No description provided for @lessonEditorRepeatLabel.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get lessonEditorRepeatLabel;

  /// No description provided for @lessonEditorRepeatEvery.
  ///
  /// In en, this message translates to:
  /// **'Every week'**
  String get lessonEditorRepeatEvery;

  /// No description provided for @lessonEditorRepeatEven.
  ///
  /// In en, this message translates to:
  /// **'Every even week'**
  String get lessonEditorRepeatEven;

  /// No description provided for @lessonEditorRepeatOdd.
  ///
  /// In en, this message translates to:
  /// **'Every odd week'**
  String get lessonEditorRepeatOdd;

  /// No description provided for @lessonEditorRepeatEveryShort.
  ///
  /// In en, this message translates to:
  /// **'Every'**
  String get lessonEditorRepeatEveryShort;

  /// No description provided for @lessonEditorRepeatEvenShort.
  ///
  /// In en, this message translates to:
  /// **'Even'**
  String get lessonEditorRepeatEvenShort;

  /// No description provided for @lessonEditorRepeatOddShort.
  ///
  /// In en, this message translates to:
  /// **'Odd'**
  String get lessonEditorRepeatOddShort;

  /// No description provided for @lessonEditorRepeatManual.
  ///
  /// In en, this message translates to:
  /// **'Pick dates manually'**
  String get lessonEditorRepeatManual;

  /// No description provided for @lessonEditorReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get lessonEditorReminderTitle;

  /// No description provided for @lessonEditorReminderLead.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min before'**
  String lessonEditorReminderLead(int minutes);

  /// No description provided for @customScheduleDefaultName.
  ///
  /// In en, this message translates to:
  /// **'My schedule'**
  String get customScheduleDefaultName;

  /// No description provided for @pickerTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get pickerTimeTitle;

  /// No description provided for @pickerTimeRangeTitle.
  ///
  /// In en, this message translates to:
  /// **'Class time'**
  String get pickerTimeRangeTitle;

  /// No description provided for @pickerStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get pickerStart;

  /// No description provided for @pickerEnd.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get pickerEnd;

  /// No description provided for @pickerDateTitle.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get pickerDateTitle;

  /// No description provided for @pickerDatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Dates'**
  String get pickerDatesTitle;

  /// No description provided for @pickerToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get pickerToday;

  /// No description provided for @pickerTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get pickerTomorrow;

  /// No description provided for @pickerNextWeek.
  ///
  /// In en, this message translates to:
  /// **'In a week'**
  String get pickerNextWeek;

  /// No description provided for @pickerSelectedCount.
  ///
  /// In en, this message translates to:
  /// **'Selected: {count}'**
  String pickerSelectedCount(int count);

  /// No description provided for @pickerClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get pickerClear;

  /// No description provided for @pickerSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search or type manually'**
  String get pickerSearchHint;

  /// No description provided for @pickerAddManually.
  ///
  /// In en, this message translates to:
  /// **'Add “{query}”'**
  String pickerAddManually(String query);

  /// No description provided for @pickerNothingFound.
  ///
  /// In en, this message translates to:
  /// **'Nothing found'**
  String get pickerNothingFound;

  /// No description provided for @lessonEditorClassroomSearchHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. А-220'**
  String get lessonEditorClassroomSearchHint;

  /// No description provided for @lessonEditorTeacherSearchHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Ivanov'**
  String get lessonEditorTeacherSearchHint;

  /// No description provided for @lessonTypeLectureName.
  ///
  /// In en, this message translates to:
  /// **'Lecture'**
  String get lessonTypeLectureName;

  /// No description provided for @lessonTypeSeminarName.
  ///
  /// In en, this message translates to:
  /// **'Seminar'**
  String get lessonTypeSeminarName;

  /// No description provided for @lessonTypeLabName.
  ///
  /// In en, this message translates to:
  /// **'Lab'**
  String get lessonTypeLabName;

  /// No description provided for @lessonTypeCreditName.
  ///
  /// In en, this message translates to:
  /// **'Credit'**
  String get lessonTypeCreditName;

  /// No description provided for @lessonTypeExamName.
  ///
  /// In en, this message translates to:
  /// **'Exam'**
  String get lessonTypeExamName;

  /// No description provided for @lessonEditorEndAfterStart.
  ///
  /// In en, this message translates to:
  /// **'End time must be later than the start time'**
  String get lessonEditorEndAfterStart;

  /// No description provided for @lessonEditorRepeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get lessonEditorRepeat;

  /// No description provided for @lessonEditorRepeatSoon.
  ///
  /// In en, this message translates to:
  /// **'Repeat configuration will be available in future versions.'**
  String get lessonEditorRepeatSoon;

  /// No description provided for @lessonEditorSelectDateError.
  ///
  /// In en, this message translates to:
  /// **'Select at least one date'**
  String get lessonEditorSelectDateError;

  /// No description provided for @lessonEditorClassroomError.
  ///
  /// In en, this message translates to:
  /// **'Add at least one classroom or make the class online'**
  String get lessonEditorClassroomError;

  /// No description provided for @lessonEditorAddClassroom.
  ///
  /// In en, this message translates to:
  /// **'Add classroom'**
  String get lessonEditorAddClassroom;

  /// No description provided for @lessonEditorClassroomNumber.
  ///
  /// In en, this message translates to:
  /// **'Classroom number'**
  String get lessonEditorClassroomNumber;

  /// No description provided for @lessonEditorClassroomHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. A-123'**
  String get lessonEditorClassroomHint;

  /// No description provided for @lessonEditorClassroomNumberError.
  ///
  /// In en, this message translates to:
  /// **'Enter the classroom number'**
  String get lessonEditorClassroomNumberError;

  /// No description provided for @lessonEditorCampusName.
  ///
  /// In en, this message translates to:
  /// **'Campus name (optional)'**
  String get lessonEditorCampusName;

  /// No description provided for @lessonEditorCampusHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. V-78'**
  String get lessonEditorCampusHint;

  /// No description provided for @lessonEditorAddGroup.
  ///
  /// In en, this message translates to:
  /// **'Add group'**
  String get lessonEditorAddGroup;

  /// No description provided for @lessonEditorGroupName.
  ///
  /// In en, this message translates to:
  /// **'Group name'**
  String get lessonEditorGroupName;

  /// No description provided for @lessonEditorGroupHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. IKBO-01-21'**
  String get lessonEditorGroupHint;

  /// No description provided for @lessonEditorGroupError.
  ///
  /// In en, this message translates to:
  /// **'Enter the group name'**
  String get lessonEditorGroupError;

  /// No description provided for @lessonEditorAddTeacher.
  ///
  /// In en, this message translates to:
  /// **'Add teacher'**
  String get lessonEditorAddTeacher;

  /// No description provided for @lessonEditorTeacherName.
  ///
  /// In en, this message translates to:
  /// **'Teacher full name'**
  String get lessonEditorTeacherName;

  /// No description provided for @lessonEditorTeacherHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Ivanov Ivan Ivanovich'**
  String get lessonEditorTeacherHint;

  /// No description provided for @lessonEditorTeacherError.
  ///
  /// In en, this message translates to:
  /// **'Enter the teacher full name'**
  String get lessonEditorTeacherError;

  /// No description provided for @customSchedulesCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'New schedule'**
  String get customSchedulesCreateTitle;

  /// No description provided for @customSchedulesCreateDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter a name and description for the new schedule'**
  String get customSchedulesCreateDesc;

  /// No description provided for @customSchedulesEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit schedule'**
  String get customSchedulesEditTitle;

  /// No description provided for @customSchedulesEditDesc.
  ///
  /// In en, this message translates to:
  /// **'Change the schedule name or description'**
  String get customSchedulesEditDesc;

  /// No description provided for @customSchedulesLessonsTitle.
  ///
  /// In en, this message translates to:
  /// **'Class list'**
  String get customSchedulesLessonsTitle;

  /// No description provided for @customSchedulesLessonsDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage classes in the «{name}» schedule'**
  String customSchedulesLessonsDesc(String name);

  /// No description provided for @customSchedulesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'You don\'\'t have any schedules yet'**
  String get customSchedulesEmptyTitle;

  /// No description provided for @customSchedulesEmptyDesc.
  ///
  /// In en, this message translates to:
  /// **'Create your own schedule by adding classes from different available schedules'**
  String get customSchedulesEmptyDesc;

  /// No description provided for @customSchedulesCreate.
  ///
  /// In en, this message translates to:
  /// **'Create schedule'**
  String get customSchedulesCreate;

  /// No description provided for @customSchedulesCreateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A new empty schedule'**
  String get customSchedulesCreateSubtitle;

  /// No description provided for @customSchedulesSearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search schedules'**
  String get customSchedulesSearchTitle;

  /// No description provided for @customSchedulesSearchSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Search a schedule by name'**
  String get customSchedulesSearchSubtitle;

  /// No description provided for @customSchedulesMyCount.
  ///
  /// In en, this message translates to:
  /// **'My schedules ({count})'**
  String customSchedulesMyCount(int count);

  /// No description provided for @customSchedulesLessonsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} class} other{{count} classes}}'**
  String customSchedulesLessonsCount(int count);

  /// No description provided for @customSchedulesUpdated.
  ///
  /// In en, this message translates to:
  /// **'Updated {time}'**
  String customSchedulesUpdated(String time);

  /// No description provided for @customSchedulesEmpty.
  ///
  /// In en, this message translates to:
  /// **'Empty schedule'**
  String get customSchedulesEmpty;

  /// No description provided for @customSchedulesUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get customSchedulesUnknown;

  /// No description provided for @customSchedulesDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days} d ago'**
  String customSchedulesDaysAgo(int days);

  /// No description provided for @customSchedulesHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours} h ago'**
  String customSchedulesHoursAgo(int hours);

  /// No description provided for @customSchedulesMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min ago'**
  String customSchedulesMinutesAgo(int minutes);

  /// No description provided for @customSchedulesJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get customSchedulesJustNow;

  /// No description provided for @customSchedulesOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get customSchedulesOpen;

  /// No description provided for @customSchedulesRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get customSchedulesRename;

  /// No description provided for @customSchedulesNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Schedule name'**
  String get customSchedulesNameLabel;

  /// No description provided for @customSchedulesNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. My schedule'**
  String get customSchedulesNameHint;

  /// No description provided for @customSchedulesNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a name'**
  String get customSchedulesNameRequired;

  /// No description provided for @customSchedulesNameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Name is too long'**
  String get customSchedulesNameTooLong;

  /// No description provided for @customSchedulesDescLabel.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get customSchedulesDescLabel;

  /// No description provided for @customSchedulesDescHint.
  ///
  /// In en, this message translates to:
  /// **'Add a schedule description'**
  String get customSchedulesDescHint;

  /// No description provided for @customSchedulesSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get customSchedulesSaveChanges;

  /// No description provided for @customSchedulesAddLesson.
  ///
  /// In en, this message translates to:
  /// **'Create a new class'**
  String get customSchedulesAddLesson;

  /// No description provided for @customSchedulesNoLessons.
  ///
  /// In en, this message translates to:
  /// **'No classes added'**
  String get customSchedulesNoLessons;

  /// No description provided for @customSchedulesNoLessonsHint.
  ///
  /// In en, this message translates to:
  /// **'Create the first class for this schedule'**
  String get customSchedulesNoLessonsHint;

  /// No description provided for @customSchedulesClassroomLabel.
  ///
  /// In en, this message translates to:
  /// **'Classroom: {rooms}'**
  String customSchedulesClassroomLabel(String rooms);

  /// No description provided for @lessonDetailsRoomToClass.
  ///
  /// In en, this message translates to:
  /// **'To the room'**
  String get lessonDetailsRoomToClass;

  /// No description provided for @lessonDetailsMaterials.
  ///
  /// In en, this message translates to:
  /// **'Materials'**
  String get lessonDetailsMaterials;

  /// No description provided for @lessonDetailsSignInReact.
  ///
  /// In en, this message translates to:
  /// **'Sign in to react'**
  String get lessonDetailsSignInReact;

  /// No description provided for @lessonDetailsReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Class review'**
  String get lessonDetailsReviewTitle;

  /// No description provided for @lessonDetailsNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Class note'**
  String get lessonDetailsNoteTitle;

  /// No description provided for @lessonDetailsRoomCoordsMissing.
  ///
  /// In en, this message translates to:
  /// **'Room coordinates not found'**
  String get lessonDetailsRoomCoordsMissing;

  /// No description provided for @lessonDetailsRecordingSoon.
  ///
  /// In en, this message translates to:
  /// **'Class recording will arrive after integration'**
  String get lessonDetailsRecordingSoon;

  /// No description provided for @lessonDetailsAddToSchedule.
  ///
  /// In en, this message translates to:
  /// **'Add to schedule'**
  String get lessonDetailsAddToSchedule;

  /// No description provided for @lessonDetailsLiveNow.
  ///
  /// In en, this message translates to:
  /// **'Live now'**
  String get lessonDetailsLiveNow;

  /// No description provided for @lessonDetailsEnded.
  ///
  /// In en, this message translates to:
  /// **'Ended'**
  String get lessonDetailsEnded;

  /// No description provided for @lessonDetailsPairNumber.
  ///
  /// In en, this message translates to:
  /// **'class {number}'**
  String lessonDetailsPairNumber(String number);

  /// No description provided for @lessonDetailsRoomNotSpecified.
  ///
  /// In en, this message translates to:
  /// **'Room not specified'**
  String get lessonDetailsRoomNotSpecified;

  /// No description provided for @lessonDetailsTypeNote.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get lessonDetailsTypeNote;

  /// No description provided for @lessonDetailsTypeBoard.
  ///
  /// In en, this message translates to:
  /// **'Board photo'**
  String get lessonDetailsTypeBoard;

  /// No description provided for @lessonDetailsTypeTask.
  ///
  /// In en, this message translates to:
  /// **'Task'**
  String get lessonDetailsTypeTask;

  /// No description provided for @lessonDetailsTypeExtra.
  ///
  /// In en, this message translates to:
  /// **'Extra material'**
  String get lessonDetailsTypeExtra;

  /// No description provided for @lessonDetailsFile.
  ///
  /// In en, this message translates to:
  /// **'file'**
  String get lessonDetailsFile;

  /// No description provided for @lessonDetailsJustNow.
  ///
  /// In en, this message translates to:
  /// **'now'**
  String get lessonDetailsJustNow;

  /// No description provided for @lessonDetailsMinutesShort.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String lessonDetailsMinutesShort(int minutes);

  /// No description provided for @lessonDetailsHoursShort.
  ///
  /// In en, this message translates to:
  /// **'{hours} h'**
  String lessonDetailsHoursShort(int hours);

  /// No description provided for @lessonDetailsYesterday.
  ///
  /// In en, this message translates to:
  /// **'yesterday'**
  String get lessonDetailsYesterday;

  /// No description provided for @lessonDetailsStatusLive.
  ///
  /// In en, this message translates to:
  /// **'LIVE'**
  String get lessonDetailsStatusLive;

  /// No description provided for @lessonDetailsStatusPast.
  ///
  /// In en, this message translates to:
  /// **'PAST'**
  String get lessonDetailsStatusPast;

  /// No description provided for @lessonDetailsStatusSoon.
  ///
  /// In en, this message translates to:
  /// **'SOON'**
  String get lessonDetailsStatusSoon;

  /// No description provided for @lessonDetailsRecord.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get lessonDetailsRecord;

  /// No description provided for @lessonDetailsNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get lessonDetailsNote;

  /// No description provided for @lessonDetailsRoute.
  ///
  /// In en, this message translates to:
  /// **'Route'**
  String get lessonDetailsRoute;

  /// No description provided for @lessonDetailsTeacherFallback.
  ///
  /// In en, this message translates to:
  /// **'Lecturer'**
  String get lessonDetailsTeacherFallback;

  /// No description provided for @lessonDetailsTeacherProfile.
  ///
  /// In en, this message translates to:
  /// **'profile and reviews'**
  String get lessonDetailsTeacherProfile;

  /// No description provided for @lessonDetailsAllCount.
  ///
  /// In en, this message translates to:
  /// **'All {count}'**
  String lessonDetailsAllCount(int count);

  /// No description provided for @lessonDetailsPeersTitle.
  ///
  /// In en, this message translates to:
  /// **'With you in class'**
  String get lessonDetailsPeersTitle;

  /// No description provided for @lessonDetailsPeersFriends.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No friends in this group yet} =1{1 friend in your group} other{{count} friends in your group}}'**
  String lessonDetailsPeersFriends(int count);

  /// No description provided for @lessonDetailsGroupsTitle.
  ///
  /// In en, this message translates to:
  /// **'Stream groups'**
  String get lessonDetailsGroupsTitle;

  /// No description provided for @lessonDetailsGroupsMore.
  ///
  /// In en, this message translates to:
  /// **'+{count}'**
  String lessonDetailsGroupsMore(int count);

  /// No description provided for @lessonDetailsMaterialsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} material} other{{count} materials}}'**
  String lessonDetailsMaterialsCount(int count);

  /// No description provided for @lessonDetailsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'\'t load materials'**
  String get lessonDetailsLoadFailed;

  /// No description provided for @lessonDetailsTapRetry.
  ///
  /// In en, this message translates to:
  /// **'Tap to retry'**
  String get lessonDetailsTapRetry;

  /// No description provided for @lessonDetailsNoMaterialsYet.
  ///
  /// In en, this message translates to:
  /// **'No materials yet'**
  String get lessonDetailsNoMaterialsYet;

  /// No description provided for @lessonDetailsUploadHint.
  ///
  /// In en, this message translates to:
  /// **'Upload notes or a board photo'**
  String get lessonDetailsUploadHint;

  /// No description provided for @lessonDetailsOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'\'t open the material'**
  String get lessonDetailsOpenFailed;

  /// No description provided for @lessonDetailsMaterialToClass.
  ///
  /// In en, this message translates to:
  /// **'Material for the class'**
  String get lessonDetailsMaterialToClass;

  /// No description provided for @lessonDetailsUpload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get lessonDetailsUpload;

  /// No description provided for @lessonDetailsMaterialsPage.
  ///
  /// In en, this message translates to:
  /// **'Class materials'**
  String get lessonDetailsMaterialsPage;

  /// No description provided for @lessonDetailsNewestFirst.
  ///
  /// In en, this message translates to:
  /// **'newest first'**
  String get lessonDetailsNewestFirst;

  /// No description provided for @lessonDetailsCheckConnection.
  ///
  /// In en, this message translates to:
  /// **'Check the connection and try again'**
  String get lessonDetailsCheckConnection;

  /// No description provided for @lessonDetailsContributePre.
  ///
  /// In en, this message translates to:
  /// **'Upload notes or a board photo — '**
  String get lessonDetailsContributePre;

  /// No description provided for @lessonDetailsContributePost.
  ///
  /// In en, this message translates to:
  /// **' and the group\'\'s thanks'**
  String get lessonDetailsContributePost;

  /// No description provided for @lessonDetailsShurikensReward.
  ///
  /// In en, this message translates to:
  /// **'+30 shurikens'**
  String get lessonDetailsShurikensReward;

  /// No description provided for @lessonDetailsEmptyMaterialsTitle.
  ///
  /// In en, this message translates to:
  /// **'Class materials will appear here'**
  String get lessonDetailsEmptyMaterialsTitle;

  /// No description provided for @lessonDetailsEmptyMaterialsSub.
  ///
  /// In en, this message translates to:
  /// **'Be the first to upload a file or board photo'**
  String get lessonDetailsEmptyMaterialsSub;

  /// No description provided for @lessonDetailsVotesAnon.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} vote · can be anonymous} other{{count} votes · can be anonymous}}'**
  String lessonDetailsVotesAnon(int count);

  /// No description provided for @lessonDetailsGroupReactions.
  ///
  /// In en, this message translates to:
  /// **'Group reactions'**
  String get lessonDetailsGroupReactions;

  /// No description provided for @lessonDetailsLeaveReview.
  ///
  /// In en, this message translates to:
  /// **'Leave a class review'**
  String get lessonDetailsLeaveReview;

  /// No description provided for @lessonDetailsSignInReview.
  ///
  /// In en, this message translates to:
  /// **'Sign in to leave a review'**
  String get lessonDetailsSignInReview;

  /// No description provided for @lessonDetailsReviewHint.
  ///
  /// In en, this message translates to:
  /// **'What was useful, hard or important?'**
  String get lessonDetailsReviewHint;

  /// No description provided for @lessonDetailsAnonymous.
  ///
  /// In en, this message translates to:
  /// **'Anonymous'**
  String get lessonDetailsAnonymous;

  /// No description provided for @lessonDetailsSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get lessonDetailsSaving;

  /// No description provided for @lessonDetailsSubmitReview.
  ///
  /// In en, this message translates to:
  /// **'Leave a review'**
  String get lessonDetailsSubmitReview;

  /// No description provided for @lessonDetailsNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Class note'**
  String get lessonDetailsNoteHint;

  /// No description provided for @noteEditorTitle.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get noteEditorTitle;

  /// No description provided for @noteEditorDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get noteEditorDone;

  /// No description provided for @noteEditorBound.
  ///
  /// In en, this message translates to:
  /// **'Pinned to the class · {room}'**
  String noteEditorBound(String room);

  /// No description provided for @noteEditorPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'…add thoughts, a photo of the board or by voice'**
  String get noteEditorPlaceholder;

  /// No description provided for @noteShareWithGroup.
  ///
  /// In en, this message translates to:
  /// **'Share with classmates'**
  String get noteShareWithGroup;

  /// No description provided for @noteShareWithGroupSub.
  ///
  /// In en, this message translates to:
  /// **'appears in the {group} space'**
  String noteShareWithGroupSub(String group);

  /// No description provided for @noteShareWithGroupGeneric.
  ///
  /// In en, this message translates to:
  /// **'appears in the group space'**
  String get noteShareWithGroupGeneric;

  /// No description provided for @noteSavedIndicator.
  ///
  /// In en, this message translates to:
  /// **'saved'**
  String get noteSavedIndicator;

  /// No description provided for @noteSharedToGroup.
  ///
  /// In en, this message translates to:
  /// **'Note shared with the group'**
  String get noteSharedToGroup;

  /// No description provided for @lessonDetailsFileTooLarge.
  ///
  /// In en, this message translates to:
  /// **'File is larger than 50 MB'**
  String get lessonDetailsFileTooLarge;

  /// No description provided for @lessonDetailsPickFileFirst.
  ///
  /// In en, this message translates to:
  /// **'Pick a file or photo'**
  String get lessonDetailsPickFileFirst;

  /// No description provided for @lessonDetailsAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a material title'**
  String get lessonDetailsAddTitle;

  /// No description provided for @lessonDetailsSignInUpload.
  ///
  /// In en, this message translates to:
  /// **'Sign in and try uploading again'**
  String get lessonDetailsSignInUpload;

  /// No description provided for @lessonDetailsCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get lessonDetailsCamera;

  /// No description provided for @lessonDetailsGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get lessonDetailsGallery;

  /// No description provided for @lessonDetailsFiles.
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get lessonDetailsFiles;

  /// No description provided for @lessonDetailsTypeHeader.
  ///
  /// In en, this message translates to:
  /// **'TYPE'**
  String get lessonDetailsTypeHeader;

  /// No description provided for @lessonDetailsTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get lessonDetailsTitleLabel;

  /// No description provided for @lessonDetailsTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Backprop notes'**
  String get lessonDetailsTitleHint;

  /// No description provided for @lessonDetailsPublicTitle.
  ///
  /// In en, this message translates to:
  /// **'Available to the whole group'**
  String get lessonDetailsPublicTitle;

  /// No description provided for @lessonDetailsPublicSub.
  ///
  /// In en, this message translates to:
  /// **'otherwise — only you'**
  String get lessonDetailsPublicSub;

  /// No description provided for @lessonDetailsRewardPre.
  ///
  /// In en, this message translates to:
  /// **'We\'\'ll award '**
  String get lessonDetailsRewardPre;

  /// No description provided for @lessonDetailsUploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading…'**
  String get lessonDetailsUploading;

  /// No description provided for @lessonDetailsUploadMaterial.
  ///
  /// In en, this message translates to:
  /// **'Upload material'**
  String get lessonDetailsUploadMaterial;

  /// No description provided for @lessonDetailsPickFileOrPhoto.
  ///
  /// In en, this message translates to:
  /// **'Pick a file or photo'**
  String get lessonDetailsPickFileOrPhoto;

  /// No description provided for @lessonDetailsDropHint.
  ///
  /// In en, this message translates to:
  /// **'PDF, board photo, laptop · up to 50 MB'**
  String get lessonDetailsDropHint;

  /// No description provided for @teacherProfileReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Teacher review'**
  String get teacherProfileReviewTitle;

  /// No description provided for @teacherProfileShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get teacherProfileShare;

  /// No description provided for @teacherProfileReviewsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} review} other{{count} reviews}}'**
  String teacherProfileReviewsCount(int count);

  /// No description provided for @teacherProfileNoReviewsInline.
  ///
  /// In en, this message translates to:
  /// **'no reviews yet'**
  String get teacherProfileNoReviewsInline;

  /// No description provided for @teacherProfileClarity.
  ///
  /// In en, this message translates to:
  /// **'Clarity'**
  String get teacherProfileClarity;

  /// No description provided for @teacherProfileLoyalty.
  ///
  /// In en, this message translates to:
  /// **'Loyalty'**
  String get teacherProfileLoyalty;

  /// No description provided for @teacherProfileUsefulness.
  ///
  /// In en, this message translates to:
  /// **'Usefulness'**
  String get teacherProfileUsefulness;

  /// No description provided for @teacherProfileSubjects.
  ///
  /// In en, this message translates to:
  /// **'Teaches'**
  String get teacherProfileSubjects;

  /// No description provided for @teacherProfileReviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get teacherProfileReviews;

  /// No description provided for @teacherProfileEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get teacherProfileEmptyTitle;

  /// No description provided for @teacherProfileEmptySub.
  ///
  /// In en, this message translates to:
  /// **'Be the first — you\'\'ll help other students'**
  String get teacherProfileEmptySub;

  /// No description provided for @teacherProfileLeaveReview.
  ///
  /// In en, this message translates to:
  /// **'Leave a review'**
  String get teacherProfileLeaveReview;

  /// No description provided for @teacherProfileReviewHint.
  ///
  /// In en, this message translates to:
  /// **'Explains complex things in simple words…'**
  String get teacherProfileReviewHint;

  /// No description provided for @teacherProfileAnonymous.
  ///
  /// In en, this message translates to:
  /// **'Anonymous'**
  String get teacherProfileAnonymous;

  /// No description provided for @teacherProfileSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get teacherProfileSaving;

  /// No description provided for @teacherProfilePublish.
  ///
  /// In en, this message translates to:
  /// **'Publish review'**
  String get teacherProfilePublish;

  /// No description provided for @feedTitle.
  ///
  /// In en, this message translates to:
  /// **'Feed'**
  String get feedTitle;

  /// No description provided for @feedLoadCategoriesError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'\'t load categories'**
  String get feedLoadCategoriesError;

  /// No description provided for @feedLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'\'t load the news feed'**
  String get feedLoadError;

  /// No description provided for @feedLoadMoreError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'\'t load more news'**
  String get feedLoadMoreError;

  /// No description provided for @feedEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get feedEmptyTitle;

  /// No description provided for @feedEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'This feed has no posts yet. Check back later — news arrives automatically.'**
  String get feedEmptyDescription;

  /// No description provided for @feedSourcesTitle.
  ///
  /// In en, this message translates to:
  /// **'Channels'**
  String get feedSourcesTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navSchedule.
  ///
  /// In en, this message translates to:
  /// **'Classes'**
  String get navSchedule;

  /// No description provided for @navMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get navMap;

  /// No description provided for @navServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get navServices;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @mapRoomTitle.
  ///
  /// In en, this message translates to:
  /// **'Room {name}'**
  String mapRoomTitle(String name);

  /// No description provided for @authSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authSignInTitle;

  /// No description provided for @authSignInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get authSignInSubtitle;

  /// No description provided for @authContinueWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Continue with email'**
  String get authContinueWithEmail;

  /// No description provided for @authSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'\'t sign in'**
  String get authSignInFailed;

  /// No description provided for @authEmailHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get authEmailHeaderTitle;

  /// No description provided for @authYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Your email'**
  String get authYourEmail;

  /// No description provided for @authInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get authInvalidEmail;

  /// No description provided for @authNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get authNext;

  /// No description provided for @authUniversityEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Use a university address from one of these domains: {domains}'**
  String authUniversityEmailHint(String domains);

  /// No description provided for @authEmailLinkFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'\'t send the sign-in link'**
  String get authEmailLinkFailed;

  /// No description provided for @authSignUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get authSignUpTitle;

  /// No description provided for @authSignUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign up with your university address: {domains}'**
  String authSignUpSubtitle(String domains);

  /// No description provided for @authSignUpButton.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get authSignUpButton;

  /// No description provided for @authSignUpFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'\'t sign up. Try again.'**
  String get authSignUpFailed;

  /// No description provided for @authEmailDomainError.
  ///
  /// In en, this message translates to:
  /// **'Use an address from one of these domains: {domains}'**
  String authEmailDomainError(String domains);

  /// No description provided for @authPasswordMinLength.
  ///
  /// In en, this message translates to:
  /// **'At least {count} characters'**
  String authPasswordMinLength(int count);

  /// No description provided for @authPasswordsDontMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords don\'\'t match'**
  String get authPasswordsDontMatch;

  /// No description provided for @authPasswordResetTitle.
  ///
  /// In en, this message translates to:
  /// **'Password reset'**
  String get authPasswordResetTitle;

  /// No description provided for @authPasswordResetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email — we\'\'ll send a recovery link.'**
  String get authPasswordResetSubtitle;

  /// No description provided for @authPasswordResetButton.
  ///
  /// In en, this message translates to:
  /// **'Send link'**
  String get authPasswordResetButton;

  /// No description provided for @authPasswordResetSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent. Check your inbox.'**
  String get authPasswordResetSent;

  /// No description provided for @authPasswordResetFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'\'t send the email. Try again.'**
  String get authPasswordResetFailed;

  /// No description provided for @authCheckEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Check your email'**
  String get authCheckEmailTitle;

  /// No description provided for @authCheckEmailSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We sent a 6-digit code to {email}. Enter it below to confirm your email.'**
  String authCheckEmailSubtitle(String email);

  /// No description provided for @authCodeFromEmail.
  ///
  /// In en, this message translates to:
  /// **'Code from the email'**
  String get authCodeFromEmail;

  /// No description provided for @authCheckingCode.
  ///
  /// In en, this message translates to:
  /// **'Checking the code…'**
  String get authCheckingCode;

  /// No description provided for @authInvalidCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid or expired code. Check it and try again.'**
  String get authInvalidCode;

  /// No description provided for @authInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password.'**
  String get authInvalidCredentials;

  /// No description provided for @authGuestUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'\'t sign in as a guest. Try again later.'**
  String get authGuestUnavailable;

  /// No description provided for @settingsAmoledTitle.
  ///
  /// In en, this message translates to:
  /// **'AMOLED'**
  String get settingsAmoledTitle;

  /// No description provided for @settingsAmoledSubtitle.
  ///
  /// In en, this message translates to:
  /// **'True-black dark theme for OLED screens'**
  String get settingsAmoledSubtitle;

  /// No description provided for @scheduleDiffTitle.
  ///
  /// In en, this message translates to:
  /// **'Schedule updates'**
  String get scheduleDiffTitle;

  /// No description provided for @scheduleDiffFoundChanges.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{Found {count} change in your schedule} other{Found {count} changes in your schedule}}'**
  String scheduleDiffFoundChanges(int count);

  /// No description provided for @scheduleDiffNewLessons.
  ///
  /// In en, this message translates to:
  /// **'New lessons'**
  String get scheduleDiffNewLessons;

  /// No description provided for @scheduleDiffAddedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{Added {count} lesson} other{Added {count} lessons}}'**
  String scheduleDiffAddedCount(int count);

  /// No description provided for @scheduleDiffChanges.
  ///
  /// In en, this message translates to:
  /// **'Changes'**
  String get scheduleDiffChanges;

  /// No description provided for @scheduleDiffModifiedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{Modified {count} lesson} other{Modified {count} lessons}}'**
  String scheduleDiffModifiedCount(int count);

  /// No description provided for @scheduleDiffRemovedLessons.
  ///
  /// In en, this message translates to:
  /// **'Removed lessons'**
  String get scheduleDiffRemovedLessons;

  /// No description provided for @scheduleDiffRemovedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{Removed {count} lesson} other{Removed {count} lessons}}'**
  String scheduleDiffRemovedCount(int count);

  /// No description provided for @scheduleDiffNewLabel.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get scheduleDiffNewLabel;

  /// No description provided for @scheduleDiffModifiedLabel.
  ///
  /// In en, this message translates to:
  /// **'Modified'**
  String get scheduleDiffModifiedLabel;

  /// No description provided for @scheduleDiffRemovedLabel.
  ///
  /// In en, this message translates to:
  /// **'Removed'**
  String get scheduleDiffRemovedLabel;

  /// No description provided for @scheduleDiffKindNew.
  ///
  /// In en, this message translates to:
  /// **'NEW'**
  String get scheduleDiffKindNew;

  /// No description provided for @scheduleDiffKindModified.
  ///
  /// In en, this message translates to:
  /// **'MODIFIED'**
  String get scheduleDiffKindModified;

  /// No description provided for @scheduleDiffKindRemoved.
  ///
  /// In en, this message translates to:
  /// **'REMOVED'**
  String get scheduleDiffKindRemoved;

  /// No description provided for @scheduleDiffFieldLessonType.
  ///
  /// In en, this message translates to:
  /// **'Lesson type'**
  String get scheduleDiffFieldLessonType;

  /// No description provided for @scheduleDiffFieldTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get scheduleDiffFieldTime;

  /// No description provided for @scheduleDiffFieldNumber.
  ///
  /// In en, this message translates to:
  /// **'Class number'**
  String get scheduleDiffFieldNumber;

  /// No description provided for @scheduleDiffFieldTeachers.
  ///
  /// In en, this message translates to:
  /// **'Teachers'**
  String get scheduleDiffFieldTeachers;

  /// No description provided for @scheduleDiffFieldClassrooms.
  ///
  /// In en, this message translates to:
  /// **'Rooms'**
  String get scheduleDiffFieldClassrooms;

  /// No description provided for @scheduleDiffFieldDates.
  ///
  /// In en, this message translates to:
  /// **'Dates'**
  String get scheduleDiffFieldDates;

  /// No description provided for @scheduleDiffFieldGroups.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get scheduleDiffFieldGroups;

  /// No description provided for @aboutAppDescription.
  ///
  /// In en, this message translates to:
  /// **'This app and all its services are 100% free and open source. We welcome any suggestions and feedback, and we are happy about any contribution to the project!'**
  String get aboutAppDescription;

  /// No description provided for @aboutAppContributors.
  ///
  /// In en, this message translates to:
  /// **'Project contributors'**
  String get aboutAppContributors;

  /// No description provided for @communityCategoryGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get communityCategoryGeneral;

  /// No description provided for @communityCategoryInstitutes.
  ///
  /// In en, this message translates to:
  /// **'Institutes'**
  String get communityCategoryInstitutes;

  /// No description provided for @communityCategorySports.
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get communityCategorySports;

  /// No description provided for @communityCategoryCreative.
  ///
  /// In en, this message translates to:
  /// **'Creative'**
  String get communityCategoryCreative;

  /// No description provided for @communityCategoryCompetitive.
  ///
  /// In en, this message translates to:
  /// **'Competitive programming'**
  String get communityCategoryCompetitive;

  /// No description provided for @communityCategoryScience.
  ///
  /// In en, this message translates to:
  /// **'Science'**
  String get communityCategoryScience;

  /// No description provided for @communityCategoryVolunteering.
  ///
  /// In en, this message translates to:
  /// **'Volunteering'**
  String get communityCategoryVolunteering;

  /// No description provided for @communityCategoryEntertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get communityCategoryEntertainment;

  /// No description provided for @communitiesTitle.
  ///
  /// In en, this message translates to:
  /// **'Communities'**
  String get communitiesTitle;

  /// No description provided for @communitiesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'catalog of MIREA chats and channels'**
  String get communitiesSubtitle;

  /// No description provided for @communitiesSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search communities…'**
  String get communitiesSearchHint;

  /// No description provided for @communitiesSearchHintInline.
  ///
  /// In en, this message translates to:
  /// **'Find a channel or chat…'**
  String get communitiesSearchHintInline;

  /// No description provided for @communitiesAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get communitiesAll;

  /// No description provided for @communitiesGroupStudy.
  ///
  /// In en, this message translates to:
  /// **'Study'**
  String get communitiesGroupStudy;

  /// No description provided for @communitiesGroupInterests.
  ///
  /// In en, this message translates to:
  /// **'Interests'**
  String get communitiesGroupInterests;

  /// No description provided for @communitiesGroupLife.
  ///
  /// In en, this message translates to:
  /// **'Life'**
  String get communitiesGroupLife;

  /// No description provided for @communitiesSectionStudy.
  ///
  /// In en, this message translates to:
  /// **'Academic'**
  String get communitiesSectionStudy;

  /// No description provided for @communitiesSectionInterests.
  ///
  /// In en, this message translates to:
  /// **'By interest'**
  String get communitiesSectionInterests;

  /// No description provided for @communitiesSectionLife.
  ///
  /// In en, this message translates to:
  /// **'Life'**
  String get communitiesSectionLife;

  /// No description provided for @communitiesSuggestTitle.
  ///
  /// In en, this message translates to:
  /// **'Know a cool chat?'**
  String get communitiesSuggestTitle;

  /// No description provided for @communitiesSuggestSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add it to the catalog'**
  String get communitiesSuggestSubtitle;

  /// No description provided for @communitiesNotFound.
  ///
  /// In en, this message translates to:
  /// **'No communities found'**
  String get communitiesNotFound;

  /// No description provided for @communitiesTryFilters.
  ///
  /// In en, this message translates to:
  /// **'Try changing the filters'**
  String get communitiesTryFilters;

  /// No description provided for @communitiesFavorites.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get communitiesFavorites;

  /// No description provided for @communitiesMembersCount.
  ///
  /// In en, this message translates to:
  /// **'{count} members'**
  String communitiesMembersCount(String count);

  /// No description provided for @friendsMeters.
  ///
  /// In en, this message translates to:
  /// **'{meters} m'**
  String friendsMeters(int meters);

  /// No description provided for @friendsKm.
  ///
  /// In en, this message translates to:
  /// **'{km} km'**
  String friendsKm(String km);

  /// No description provided for @friendsJustNow.
  ///
  /// In en, this message translates to:
  /// **'now'**
  String get friendsJustNow;

  /// No description provided for @friendsMinutesShort.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String friendsMinutesShort(int minutes);

  /// No description provided for @friendsHoursShort.
  ///
  /// In en, this message translates to:
  /// **'{hours} h'**
  String friendsHoursShort(int hours);

  /// No description provided for @friendsDaysShort.
  ///
  /// In en, this message translates to:
  /// **'{days} d'**
  String friendsDaysShort(int days);

  /// No description provided for @friendsGhostMode.
  ///
  /// In en, this message translates to:
  /// **'Ghost mode'**
  String get friendsGhostMode;

  /// No description provided for @friendsGhostModeOff.
  ///
  /// In en, this message translates to:
  /// **'Turn off ghost mode'**
  String get friendsGhostModeOff;

  /// No description provided for @friendsOnMapLive.
  ///
  /// In en, this message translates to:
  /// **'{count} on the map · live'**
  String friendsOnMapLive(int count);

  /// No description provided for @friendsRequests.
  ///
  /// In en, this message translates to:
  /// **'Friend requests'**
  String get friendsRequests;

  /// No description provided for @friendsAddFriend.
  ///
  /// In en, this message translates to:
  /// **'Add friend'**
  String get friendsAddFriend;

  /// No description provided for @friendsAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add friends'**
  String get friendsAddTitle;

  /// No description provided for @friendsClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get friendsClose;

  /// No description provided for @friendsGeoDenied.
  ///
  /// In en, this message translates to:
  /// **'No location access — friends can\'\'t see you. Enable it in settings.'**
  String get friendsGeoDenied;

  /// No description provided for @friendsMyLocation.
  ///
  /// In en, this message translates to:
  /// **'My location'**
  String get friendsMyLocation;

  /// No description provided for @friendsGeoSharing.
  ///
  /// In en, this message translates to:
  /// **'Location sharing'**
  String get friendsGeoSharing;

  /// No description provided for @friendsTitle.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get friendsTitle;

  /// No description provided for @friendsAddShort.
  ///
  /// In en, this message translates to:
  /// **'+ Add'**
  String get friendsAddShort;

  /// No description provided for @friendsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No one yet'**
  String get friendsEmptyTitle;

  /// No description provided for @friendsEmptySub.
  ///
  /// In en, this message translates to:
  /// **'Add friends — see them on the map in real time'**
  String get friendsEmptySub;

  /// No description provided for @friendsStatusHidden.
  ///
  /// In en, this message translates to:
  /// **'hidden'**
  String get friendsStatusHidden;

  /// No description provided for @friendsStatusLive.
  ///
  /// In en, this message translates to:
  /// **'on the map · live'**
  String get friendsStatusLive;

  /// No description provided for @friendsStatusRecent.
  ///
  /// In en, this message translates to:
  /// **'seen recently'**
  String get friendsStatusRecent;

  /// No description provided for @friendsStatusGeoOff.
  ///
  /// In en, this message translates to:
  /// **'location off'**
  String get friendsStatusGeoOff;

  /// No description provided for @friendsWriteTelegram.
  ///
  /// In en, this message translates to:
  /// **'Message on Telegram'**
  String get friendsWriteTelegram;

  /// No description provided for @friendsRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove from friends'**
  String get friendsRemove;

  /// No description provided for @friendsShareGeo.
  ///
  /// In en, this message translates to:
  /// **'Share my location'**
  String get friendsShareGeo;

  /// No description provided for @friendsShareGeoSub.
  ///
  /// In en, this message translates to:
  /// **'send location updates to your chosen audience'**
  String get friendsShareGeoSub;

  /// No description provided for @friendsPrivacySyncError.
  ///
  /// In en, this message translates to:
  /// **'The server did not confirm your privacy settings. Location publishing is stopped on this device — retry the sync.'**
  String get friendsPrivacySyncError;

  /// No description provided for @friendsGhostSub.
  ///
  /// In en, this message translates to:
  /// **'temporarily hide from everyone'**
  String get friendsGhostSub;

  /// No description provided for @friendsWhoSeesExact.
  ///
  /// In en, this message translates to:
  /// **'WHO SEES MY LOCATION'**
  String get friendsWhoSeesExact;

  /// No description provided for @friendsVisAll.
  ///
  /// In en, this message translates to:
  /// **'All friends'**
  String get friendsVisAll;

  /// No description provided for @friendsVisClose.
  ///
  /// In en, this message translates to:
  /// **'Close friends only'**
  String get friendsVisClose;

  /// No description provided for @friendsVisCloseSub.
  ///
  /// In en, this message translates to:
  /// **'others see the building'**
  String get friendsVisCloseSub;

  /// No description provided for @friendsVisNone.
  ///
  /// In en, this message translates to:
  /// **'No one'**
  String get friendsVisNone;

  /// No description provided for @friendsVisNoneSub.
  ///
  /// In en, this message translates to:
  /// **'you\'\'re not on the map'**
  String get friendsVisNoneSub;

  /// No description provided for @friendsPrecisionHeader.
  ///
  /// In en, this message translates to:
  /// **'LOCATION PRECISION'**
  String get friendsPrecisionHeader;

  /// No description provided for @friendsPrecisionExact.
  ///
  /// In en, this message translates to:
  /// **'Exact'**
  String get friendsPrecisionExact;

  /// No description provided for @friendsPrecisionCampus.
  ///
  /// In en, this message translates to:
  /// **'Building'**
  String get friendsPrecisionCampus;

  /// No description provided for @friendsPrecisionCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get friendsPrecisionCity;

  /// No description provided for @friendsAutoOffHeader.
  ///
  /// In en, this message translates to:
  /// **'AUTOMATICALLY TURN OFF'**
  String get friendsAutoOffHeader;

  /// No description provided for @friendsAutoOffCampus.
  ///
  /// In en, this message translates to:
  /// **'When I leave campus'**
  String get friendsAutoOffCampus;

  /// No description provided for @friendsAutoOffNight.
  ///
  /// In en, this message translates to:
  /// **'At night · 22:00–08:00'**
  String get friendsAutoOffNight;

  /// No description provided for @friendsAutoOffNever.
  ///
  /// In en, this message translates to:
  /// **'Don\'\'t turn off'**
  String get friendsAutoOffNever;

  /// No description provided for @friendsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Name, @handle or group'**
  String get friendsSearchHint;

  /// No description provided for @friendsMyQr.
  ///
  /// In en, this message translates to:
  /// **'My QR code'**
  String get friendsMyQr;

  /// No description provided for @friendsMyQrSub.
  ///
  /// In en, this message translates to:
  /// **'show it to get added'**
  String get friendsMyQrSub;

  /// No description provided for @friendsMyQrHint.
  ///
  /// In en, this message translates to:
  /// **'Show this code to a friend — they point their camera and add you'**
  String get friendsMyQrHint;

  /// No description provided for @friendsShareLink.
  ///
  /// In en, this message translates to:
  /// **'Share link'**
  String get friendsShareLink;

  /// No description provided for @friendsNoneFound.
  ///
  /// In en, this message translates to:
  /// **'No one found'**
  String get friendsNoneFound;

  /// No description provided for @friendsNoneFoundSub.
  ///
  /// In en, this message translates to:
  /// **'Try another name or group'**
  String get friendsNoneFoundSub;

  /// No description provided for @friendsFromGroup.
  ///
  /// In en, this message translates to:
  /// **'FROM YOUR GROUP'**
  String get friendsFromGroup;

  /// No description provided for @friendsYourGroup.
  ///
  /// In en, this message translates to:
  /// **'your group'**
  String get friendsYourGroup;

  /// No description provided for @friendsAddWholeGroup.
  ///
  /// In en, this message translates to:
  /// **'Add the whole group · {count}'**
  String friendsAddWholeGroup(int count);

  /// No description provided for @friendsInFriends.
  ///
  /// In en, this message translates to:
  /// **'friends'**
  String get friendsInFriends;

  /// No description provided for @friendsRequestSent.
  ///
  /// In en, this message translates to:
  /// **'request sent'**
  String get friendsRequestSent;

  /// No description provided for @friendsAddBare.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get friendsAddBare;

  /// No description provided for @friendsScan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get friendsScan;

  /// No description provided for @friendsScanSub.
  ///
  /// In en, this message translates to:
  /// **'a friend\'\'s QR nearby'**
  String get friendsScanSub;

  /// No description provided for @friendsScanTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan QR code'**
  String get friendsScanTitle;

  /// No description provided for @friendsScanInstruction.
  ///
  /// In en, this message translates to:
  /// **'Point the camera at a friend\'\'s QR code'**
  String get friendsScanInstruction;

  /// No description provided for @friendsScanInvalid.
  ///
  /// In en, this message translates to:
  /// **'This isn\'\'t a Mirea Ninja friend code'**
  String get friendsScanInvalid;

  /// No description provided for @friendsScanCameraError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'\'t open the camera. Check the permission in settings.'**
  String get friendsScanCameraError;

  /// No description provided for @friendsFromGroupNamed.
  ///
  /// In en, this message translates to:
  /// **'From your group {group}'**
  String friendsFromGroupNamed(String group);

  /// No description provided for @friendsNotYetFriends.
  ///
  /// In en, this message translates to:
  /// **'not friends yet'**
  String get friendsNotYetFriends;

  /// No description provided for @friendsMayKnow.
  ///
  /// In en, this message translates to:
  /// **'You may know'**
  String get friendsMayKnow;

  /// No description provided for @friendsMutual.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 mutual friend} other{{count} mutual friends}}'**
  String friendsMutual(int count);

  /// No description provided for @friendsInviteTelegram.
  ///
  /// In en, this message translates to:
  /// **'Invite from Telegram'**
  String get friendsInviteTelegram;

  /// No description provided for @friendsInviteTelegramSub.
  ///
  /// In en, this message translates to:
  /// **'send an invite link'**
  String get friendsInviteTelegramSub;

  /// No description provided for @friendsNoRequests.
  ///
  /// In en, this message translates to:
  /// **'No requests'**
  String get friendsNoRequests;

  /// No description provided for @friendsNoRequestsSub.
  ///
  /// In en, this message translates to:
  /// **'When someone adds you — it\'\'ll show here'**
  String get friendsNoRequestsSub;

  /// No description provided for @friendsAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get friendsAccept;

  /// No description provided for @friendsDecline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get friendsDecline;

  /// No description provided for @friendsYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get friendsYou;

  /// No description provided for @lostFoundCatTech.
  ///
  /// In en, this message translates to:
  /// **'Tech'**
  String get lostFoundCatTech;

  /// No description provided for @lostFoundCatDocs.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get lostFoundCatDocs;

  /// No description provided for @lostFoundCatKeys.
  ///
  /// In en, this message translates to:
  /// **'Keys'**
  String get lostFoundCatKeys;

  /// No description provided for @lostFoundCatCloth.
  ///
  /// In en, this message translates to:
  /// **'Clothing'**
  String get lostFoundCatCloth;

  /// No description provided for @lostFoundCatOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get lostFoundCatOther;

  /// No description provided for @lostFoundJustNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get lostFoundJustNow;

  /// No description provided for @lostFoundMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min ago'**
  String lostFoundMinutesAgo(int minutes);

  /// No description provided for @lostFoundHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours} h ago'**
  String lostFoundHoursAgo(int hours);

  /// No description provided for @lostFoundDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days} d ago'**
  String lostFoundDaysAgo(int days);

  /// No description provided for @lostFoundFoundBy.
  ///
  /// In en, this message translates to:
  /// **'found by {name}'**
  String lostFoundFoundBy(String name);

  /// No description provided for @lostFoundLostBy.
  ///
  /// In en, this message translates to:
  /// **'lost by {name}'**
  String lostFoundLostBy(String name);

  /// No description provided for @lostFoundTagFound.
  ///
  /// In en, this message translates to:
  /// **'found'**
  String get lostFoundTagFound;

  /// No description provided for @lostFoundTagSearching.
  ///
  /// In en, this message translates to:
  /// **'searching'**
  String get lostFoundTagSearching;

  /// No description provided for @lostFoundBusy.
  ///
  /// In en, this message translates to:
  /// **'One sec…'**
  String get lostFoundBusy;

  /// No description provided for @lostFoundFoundOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner found — move to \"Lost\"'**
  String get lostFoundFoundOwner;

  /// No description provided for @lostFoundFoundItem.
  ///
  /// In en, this message translates to:
  /// **'Item found — move to \"Found\"'**
  String get lostFoundFoundItem;

  /// No description provided for @lostFoundDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete listing'**
  String get lostFoundDelete;

  /// No description provided for @lostFoundCall.
  ///
  /// In en, this message translates to:
  /// **'Call {phone}'**
  String lostFoundCall(String phone);

  /// No description provided for @lostFoundContactUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The author chose not to share contact details'**
  String get lostFoundContactUnavailable;

  /// No description provided for @lostFoundContactConsent.
  ///
  /// In en, this message translates to:
  /// **'Show my contact details to students at my university'**
  String get lostFoundContactConsent;

  /// No description provided for @lostFoundPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'Phone number (optional)'**
  String get lostFoundPhoneHint;

  /// No description provided for @lostFoundDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this listing?'**
  String get lostFoundDeleteConfirmTitle;

  /// No description provided for @lostFoundDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'The listing and its photos will be removed permanently.'**
  String get lostFoundDeleteConfirmBody;

  /// No description provided for @lostFoundCleanupWarning.
  ///
  /// In en, this message translates to:
  /// **'The listing was deleted, but some photos could not be cleaned up yet'**
  String get lostFoundCleanupWarning;

  /// No description provided for @lostFoundContactOpenError.
  ///
  /// In en, this message translates to:
  /// **'Could not open this contact'**
  String get lostFoundContactOpenError;

  /// No description provided for @lostFoundImageError.
  ///
  /// In en, this message translates to:
  /// **'Use up to 5 JPEG, PNG, or WebP images, 8 MB each'**
  String get lostFoundImageError;

  /// No description provided for @lostFoundContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get lostFoundContact;

  /// No description provided for @lostFoundReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Report an item'**
  String get lostFoundReportTitle;

  /// No description provided for @lostFoundReportSub.
  ///
  /// In en, this message translates to:
  /// **'students at your university will see the listing'**
  String get lostFoundReportSub;

  /// No description provided for @lostFoundReport.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get lostFoundReport;

  /// No description provided for @lostFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Lost & Found'**
  String get lostFoundTitle;

  /// No description provided for @lostFoundItemsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} listing} other{{count} listings}}'**
  String lostFoundItemsCount(int count);

  /// No description provided for @lostFoundSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get lostFoundSearch;

  /// No description provided for @lostFoundSearchHint.
  ///
  /// In en, this message translates to:
  /// **'What are we looking for?…'**
  String get lostFoundSearchHint;

  /// No description provided for @lostFoundTabFound.
  ///
  /// In en, this message translates to:
  /// **'Found · {count}'**
  String lostFoundTabFound(int count);

  /// No description provided for @lostFoundTabLost.
  ///
  /// In en, this message translates to:
  /// **'Lost · {count}'**
  String lostFoundTabLost(int count);

  /// No description provided for @lostFoundLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'\'t load listings'**
  String get lostFoundLoadError;

  /// No description provided for @lostFoundLoadErrorSub.
  ///
  /// In en, this message translates to:
  /// **'Pull down to try again'**
  String get lostFoundLoadErrorSub;

  /// No description provided for @lostFoundEmptyFound.
  ///
  /// In en, this message translates to:
  /// **'No found items yet'**
  String get lostFoundEmptyFound;

  /// No description provided for @lostFoundEmptyLost.
  ///
  /// In en, this message translates to:
  /// **'No lost items yet'**
  String get lostFoundEmptyLost;

  /// No description provided for @lostFoundEmptySub.
  ///
  /// In en, this message translates to:
  /// **'Found or lost something? Report it — we\'\'ll help find the owner'**
  String get lostFoundEmptySub;

  /// No description provided for @lostFoundStatusFoundMe.
  ///
  /// In en, this message translates to:
  /// **'Found'**
  String get lostFoundStatusFoundMe;

  /// No description provided for @lostFoundStatusLostMe.
  ///
  /// In en, this message translates to:
  /// **'Lost'**
  String get lostFoundStatusLostMe;

  /// No description provided for @lostFoundTitleHint.
  ///
  /// In en, this message translates to:
  /// **'What\'\'s the item? E.g. \"AirPods Pro\"'**
  String get lostFoundTitleHint;

  /// No description provided for @lostFoundLocationHint.
  ///
  /// In en, this message translates to:
  /// **'Where? E.g. \"G-407, under the desk\"'**
  String get lostFoundLocationHint;

  /// No description provided for @lostFoundDetailsHint.
  ///
  /// In en, this message translates to:
  /// **'Details: marks, when, circumstances…'**
  String get lostFoundDetailsHint;

  /// No description provided for @lostFoundTelegramHint.
  ///
  /// In en, this message translates to:
  /// **'Telegram to contact, e.g. @ninja'**
  String get lostFoundTelegramHint;

  /// No description provided for @lostFoundPhotosLabel.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get lostFoundPhotosLabel;

  /// No description provided for @lostFoundPublishing.
  ///
  /// In en, this message translates to:
  /// **'Publishing…'**
  String get lostFoundPublishing;

  /// No description provided for @lostFoundPublish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get lostFoundPublish;

  /// No description provided for @lostFoundPublishError.
  ///
  /// In en, this message translates to:
  /// **'Could not publish the listing. Please try again'**
  String get lostFoundPublishError;

  /// No description provided for @lostFoundActionError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again'**
  String get lostFoundActionError;

  /// Label for the pill that toggles favorites edit mode on the Services hub
  ///
  /// In en, this message translates to:
  /// **'Configure'**
  String get servicesConfigure;

  /// Label shown on the configure pill while favorites edit mode is active
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get servicesEditDone;

  /// No description provided for @servicesConfigureHint.
  ///
  /// In en, this message translates to:
  /// **'Tap a service to pin it. Press and drag to move it.'**
  String get servicesConfigureHint;

  /// No description provided for @servicesMoveEarlier.
  ///
  /// In en, this message translates to:
  /// **'Move earlier'**
  String get servicesMoveEarlier;

  /// No description provided for @servicesMoveLater.
  ///
  /// In en, this message translates to:
  /// **'Move later'**
  String get servicesMoveLater;

  /// Placeholder for the services search field
  ///
  /// In en, this message translates to:
  /// **'Find a service or link'**
  String get servicesSearchHint;

  /// Header of the pinned favorites section on the Services hub
  ///
  /// In en, this message translates to:
  /// **'Pinned'**
  String get servicesSectionPinned;

  /// Hint shown in the pinned section while editing and nothing is pinned
  ///
  /// In en, this message translates to:
  /// **'Turn on Configure and tap a service to pin it here'**
  String get servicesPinnedEmptyHint;

  /// Header introducing the full categorized list of services
  ///
  /// In en, this message translates to:
  /// **'All services'**
  String get servicesSectionAll;

  /// No description provided for @servicesNowTitle.
  ///
  /// In en, this message translates to:
  /// **'Right now'**
  String get servicesNowTitle;

  /// No description provided for @servicesNowSessionToday.
  ///
  /// In en, this message translates to:
  /// **'Exam today — good luck!'**
  String get servicesNowSessionToday;

  /// No description provided for @servicesNowSessionInDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{Session in {count} day} other{Session in {count} days}}'**
  String servicesNowSessionInDays(int count);

  /// No description provided for @servicesNowShurikens.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} shuriken} other{{count} shurikens}}'**
  String servicesNowShurikens(int count);

  /// Overline label of the build-your-own mini-app CTA card
  ///
  /// In en, this message translates to:
  /// **'Your own mini-app'**
  String get servicesBuildLabel;

  /// Title of the build-your-own mini-app CTA card
  ///
  /// In en, this message translates to:
  /// **'Build a service and share it with the university'**
  String get servicesBuildTitle;

  /// Subtitle of the build-your-own mini-app CTA card
  ///
  /// In en, this message translates to:
  /// **'TypeScript SDK · 5 minutes to your first deploy'**
  String get servicesBuildSubtitle;

  /// No description provided for @servicesTabMain.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get servicesTabMain;

  /// No description provided for @servicesTabDigital.
  ///
  /// In en, this message translates to:
  /// **'Digital university'**
  String get servicesTabDigital;

  /// No description provided for @servicesSectionImportant.
  ///
  /// In en, this message translates to:
  /// **'Important'**
  String get servicesSectionImportant;

  /// No description provided for @servicesSectionCommunity.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get servicesSectionCommunity;

  /// No description provided for @servicesSectionMain.
  ///
  /// In en, this message translates to:
  /// **'Main services'**
  String get servicesSectionMain;

  /// No description provided for @servicesSectionStudentLife.
  ///
  /// In en, this message translates to:
  /// **'Student life'**
  String get servicesSectionStudentLife;

  /// No description provided for @servicesSectionUseful.
  ///
  /// In en, this message translates to:
  /// **'Useful'**
  String get servicesSectionUseful;

  /// No description provided for @servicesFriendsMap.
  ///
  /// In en, this message translates to:
  /// **'Friends on the map'**
  String get servicesFriendsMap;

  /// No description provided for @servicesWallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get servicesWallet;

  /// No description provided for @servicesKnowledgeBank.
  ///
  /// In en, this message translates to:
  /// **'Knowledge bank'**
  String get servicesKnowledgeBank;

  /// No description provided for @servicesEvents.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get servicesEvents;

  /// No description provided for @servicesTeamFinder.
  ///
  /// In en, this message translates to:
  /// **'Team finder'**
  String get servicesTeamFinder;

  /// No description provided for @servicesMentorship.
  ///
  /// In en, this message translates to:
  /// **'Mentorship'**
  String get servicesMentorship;

  /// No description provided for @servicesMarketplace.
  ///
  /// In en, this message translates to:
  /// **'Marketplace'**
  String get servicesMarketplace;

  /// No description provided for @servicesNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get servicesNotes;

  /// No description provided for @servicesMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get servicesMap;

  /// No description provided for @deadlinesTitle.
  ///
  /// In en, this message translates to:
  /// **'Deadlines'**
  String get deadlinesTitle;

  /// No description provided for @deadlinesFabLabel.
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get deadlinesFabLabel;

  /// No description provided for @deadlinesCalendarTooltip.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get deadlinesCalendarTooltip;

  /// No description provided for @createDeadlineTitle.
  ///
  /// In en, this message translates to:
  /// **'Create deadline'**
  String get createDeadlineTitle;

  /// No description provided for @createDeadlineButton.
  ///
  /// In en, this message translates to:
  /// **'Create deadline'**
  String get createDeadlineButton;

  /// No description provided for @deadlinesOnFire.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} on fire} other{{count} on fire}}'**
  String deadlinesOnFire(int count);

  /// No description provided for @deadlinesActive.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} active} other{{count} active}}'**
  String deadlinesActive(int count);

  /// No description provided for @deadlinesFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get deadlinesFilterAll;

  /// No description provided for @deadlinesFilterHot.
  ///
  /// In en, this message translates to:
  /// **'Hot'**
  String get deadlinesFilterHot;

  /// No description provided for @deadlinesFilterMine.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get deadlinesFilterMine;

  /// No description provided for @deadlinesFilterGroup.
  ///
  /// In en, this message translates to:
  /// **'From group'**
  String get deadlinesFilterGroup;

  /// No description provided for @deadlinesFilterDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get deadlinesFilterDone;

  /// No description provided for @deadlinesGroupWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get deadlinesGroupWeek;

  /// No description provided for @deadlinesGroupLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get deadlinesGroupLater;

  /// No description provided for @deadlinesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No deadlines'**
  String get deadlinesEmptyTitle;

  /// No description provided for @deadlinesEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add your first one and keep your progress on track'**
  String get deadlinesEmptySubtitle;

  /// No description provided for @deadlineToday.
  ///
  /// In en, this message translates to:
  /// **'today'**
  String get deadlineToday;

  /// No description provided for @deadlineTomorrow.
  ///
  /// In en, this message translates to:
  /// **'tomorrow'**
  String get deadlineTomorrow;

  /// No description provided for @deadlineOverdue.
  ///
  /// In en, this message translates to:
  /// **'overdue'**
  String get deadlineOverdue;

  /// No description provided for @deadlineLeftHours.
  ///
  /// In en, this message translates to:
  /// **'{count} h'**
  String deadlineLeftHours(int count);

  /// No description provided for @deadlineLeftDays.
  ///
  /// In en, this message translates to:
  /// **'{count} d'**
  String deadlineLeftDays(int count);

  /// No description provided for @deadlineLeftWeeks.
  ///
  /// In en, this message translates to:
  /// **'{count} w'**
  String deadlineLeftWeeks(int count);

  /// No description provided for @deadlineDone.
  ///
  /// In en, this message translates to:
  /// **'done'**
  String get deadlineDone;

  /// No description provided for @deadlineSourceMine.
  ///
  /// In en, this message translates to:
  /// **'personal'**
  String get deadlineSourceMine;

  /// No description provided for @deadlineSourceGroup.
  ///
  /// In en, this message translates to:
  /// **'from group'**
  String get deadlineSourceGroup;

  /// No description provided for @deadlineSourceProf.
  ///
  /// In en, this message translates to:
  /// **'from teacher'**
  String get deadlineSourceProf;

  /// No description provided for @deadlineTitleHint.
  ///
  /// In en, this message translates to:
  /// **'What to do?'**
  String get deadlineTitleHint;

  /// No description provided for @deadlineSubjectHint.
  ///
  /// In en, this message translates to:
  /// **'Subject (optional)'**
  String get deadlineSubjectHint;

  /// No description provided for @deadlineDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get deadlineDateLabel;

  /// No description provided for @deadlineTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get deadlineTimeLabel;

  /// No description provided for @deadlineQuickToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get deadlineQuickToday;

  /// No description provided for @deadlineQuickTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get deadlineQuickTomorrow;

  /// No description provided for @deadlineQuickWeek.
  ///
  /// In en, this message translates to:
  /// **'In a week'**
  String get deadlineQuickWeek;

  /// No description provided for @deadlineQuickSession.
  ///
  /// In en, this message translates to:
  /// **'By exams'**
  String get deadlineQuickSession;

  /// No description provided for @deadlinePriorityLabel.
  ///
  /// In en, this message translates to:
  /// **'PRIORITY'**
  String get deadlinePriorityLabel;

  /// No description provided for @deadlinePriorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get deadlinePriorityLow;

  /// No description provided for @deadlinePriorityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get deadlinePriorityMedium;

  /// No description provided for @deadlinePriorityUrgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get deadlinePriorityUrgent;

  /// No description provided for @deadlineRemindTitle.
  ///
  /// In en, this message translates to:
  /// **'Remind in advance'**
  String get deadlineRemindTitle;

  /// No description provided for @deadlineRemindSubtitle.
  ///
  /// In en, this message translates to:
  /// **'at the chosen lead time before the deadline'**
  String get deadlineRemindSubtitle;

  /// No description provided for @deadlineShareTitle.
  ///
  /// In en, this message translates to:
  /// **'Share with group'**
  String get deadlineShareTitle;

  /// No description provided for @deadlineShareSubtitle.
  ///
  /// In en, this message translates to:
  /// **'all your groupmates will see it'**
  String get deadlineShareSubtitle;

  /// No description provided for @deadlineSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get deadlineSaving;

  /// No description provided for @deadlinesLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load deadlines'**
  String get deadlinesLoadError;

  /// No description provided for @deadlinesLoadErrorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again'**
  String get deadlinesLoadErrorSubtitle;

  /// No description provided for @deadlinesCreateError.
  ///
  /// In en, this message translates to:
  /// **'Could not create the deadline. Try again.'**
  String get deadlinesCreateError;

  /// No description provided for @deadlinesUpdateError.
  ///
  /// In en, this message translates to:
  /// **'Could not update the deadline. Try again.'**
  String get deadlinesUpdateError;

  /// No description provided for @deadlinesRefreshError.
  ///
  /// In en, this message translates to:
  /// **'Could not refresh the list. The current data may be outdated.'**
  String get deadlinesRefreshError;

  /// No description provided for @deadlinePastError.
  ///
  /// In en, this message translates to:
  /// **'Choose a future date and time'**
  String get deadlinePastError;

  /// No description provided for @deadlineMarkDone.
  ///
  /// In en, this message translates to:
  /// **'Mark as done'**
  String get deadlineMarkDone;

  /// No description provided for @deadlineMarkActive.
  ///
  /// In en, this message translates to:
  /// **'Mark as active'**
  String get deadlineMarkActive;

  /// No description provided for @loginWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get loginWelcomeBack;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your account'**
  String get loginSubtitle;

  /// No description provided for @loginEmailPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'name@example.com'**
  String get loginEmailPlaceholder;

  /// No description provided for @loginEmailError.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get loginEmailError;

  /// No description provided for @loginPasswordError.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{At least {count} character} other{At least {count} characters}}'**
  String loginPasswordError(int count);

  /// No description provided for @loginForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get loginForgotPassword;

  /// No description provided for @loginSubmit.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginSubmit;

  /// No description provided for @loginOr.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get loginOr;

  /// No description provided for @loginProviderElk.
  ///
  /// In en, this message translates to:
  /// **'ELK MIREA'**
  String get loginProviderElk;

  /// No description provided for @loginProviderGosuslugi.
  ///
  /// In en, this message translates to:
  /// **'Gosuslugi'**
  String get loginProviderGosuslugi;

  /// No description provided for @loginComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get loginComingSoon;

  /// No description provided for @loginNoAccount.
  ///
  /// In en, this message translates to:
  /// **'No account? '**
  String get loginNoAccount;

  /// No description provided for @loginGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as guest'**
  String get loginGuest;

  /// No description provided for @loginWithCode.
  ///
  /// In en, this message translates to:
  /// **'Sign in with a code'**
  String get loginWithCode;

  /// No description provided for @loginGenericError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t sign in. Check your details and try again.'**
  String get loginGenericError;

  /// Mini apps catalog title
  ///
  /// In en, this message translates to:
  /// **'Mini apps'**
  String get miniAppsTitle;

  /// No description provided for @miniAppsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{no apps yet} one{{count} app} other{{count} apps}}'**
  String miniAppsSubtitle(int count);

  /// No description provided for @miniAppsSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get miniAppsSearch;

  /// No description provided for @miniAppsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search mini apps'**
  String get miniAppsSearchHint;

  /// No description provided for @miniAppsCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get miniAppsCreate;

  /// No description provided for @miniAppsModeration.
  ///
  /// In en, this message translates to:
  /// **'Moderation'**
  String get miniAppsModeration;

  /// No description provided for @miniAppsMyApps.
  ///
  /// In en, this message translates to:
  /// **'My apps'**
  String get miniAppsMyApps;

  /// No description provided for @miniAppsCatalogSection.
  ///
  /// In en, this message translates to:
  /// **'Catalog'**
  String get miniAppsCatalogSection;

  /// No description provided for @miniAppsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No mini apps yet'**
  String get miniAppsEmptyTitle;

  /// No description provided for @miniAppsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Be the first: build a mini app on Stac JSON and publish it for all students'**
  String get miniAppsEmptySubtitle;

  /// No description provided for @miniAppsNothingFound.
  ///
  /// In en, this message translates to:
  /// **'Nothing found'**
  String get miniAppsNothingFound;

  /// No description provided for @miniAppsNothingFoundSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try a different query or category'**
  String get miniAppsNothingFoundSubtitle;

  /// No description provided for @miniAppsLaunches.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{no launches} one{{count} launch} other{{count} launches}}'**
  String miniAppsLaunches(int count);

  /// No description provided for @miniAppsOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get miniAppsOpen;

  /// No description provided for @miniAppsAbout.
  ///
  /// In en, this message translates to:
  /// **'About & rating'**
  String get miniAppsAbout;

  /// No description provided for @miniAppsHide.
  ///
  /// In en, this message translates to:
  /// **'Hide from my catalog'**
  String get miniAppsHide;

  /// No description provided for @miniAppsUnhide.
  ///
  /// In en, this message translates to:
  /// **'Show in my catalog'**
  String get miniAppsUnhide;

  /// No description provided for @miniAppsReport.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get miniAppsReport;

  /// No description provided for @miniAppsAlreadyReported.
  ///
  /// In en, this message translates to:
  /// **'Report sent'**
  String get miniAppsAlreadyReported;

  /// No description provided for @miniAppsReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Report mini app'**
  String get miniAppsReportTitle;

  /// No description provided for @miniAppsReportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'moderators will review it shortly'**
  String get miniAppsReportSubtitle;

  /// No description provided for @miniAppsReportDetailsHint.
  ///
  /// In en, this message translates to:
  /// **'What is wrong? (optional)'**
  String get miniAppsReportDetailsHint;

  /// No description provided for @miniAppsReportSend.
  ///
  /// In en, this message translates to:
  /// **'Send report'**
  String get miniAppsReportSend;

  /// No description provided for @miniAppsReportSending.
  ///
  /// In en, this message translates to:
  /// **'Sending...'**
  String get miniAppsReportSending;

  /// No description provided for @miniAppsReportSent.
  ///
  /// In en, this message translates to:
  /// **'Report sent. Thank you!'**
  String get miniAppsReportSent;

  /// No description provided for @miniAppsRate.
  ///
  /// In en, this message translates to:
  /// **'Your rating'**
  String get miniAppsRate;

  /// No description provided for @miniAppsDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete app'**
  String get miniAppsDelete;

  /// No description provided for @miniAppsCategoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get miniAppsCategoryAll;

  /// No description provided for @miniAppsCategoryStudy.
  ///
  /// In en, this message translates to:
  /// **'Study'**
  String get miniAppsCategoryStudy;

  /// No description provided for @miniAppsCategoryCampus.
  ///
  /// In en, this message translates to:
  /// **'Campus'**
  String get miniAppsCategoryCampus;

  /// No description provided for @miniAppsCategoryTools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get miniAppsCategoryTools;

  /// No description provided for @miniAppsCategoryFun.
  ///
  /// In en, this message translates to:
  /// **'Fun'**
  String get miniAppsCategoryFun;

  /// No description provided for @miniAppsCategorySocial.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get miniAppsCategorySocial;

  /// No description provided for @miniAppsCategoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get miniAppsCategoryOther;

  /// No description provided for @miniAppsStatusDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get miniAppsStatusDraft;

  /// No description provided for @miniAppsStatusPending.
  ///
  /// In en, this message translates to:
  /// **'In review'**
  String get miniAppsStatusPending;

  /// No description provided for @miniAppsStatusPublished.
  ///
  /// In en, this message translates to:
  /// **'Published'**
  String get miniAppsStatusPublished;

  /// No description provided for @miniAppsStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get miniAppsStatusRejected;

  /// No description provided for @miniAppsStatusSuspended.
  ///
  /// In en, this message translates to:
  /// **'Suspended'**
  String get miniAppsStatusSuspended;

  /// No description provided for @miniAppsReasonSpam.
  ///
  /// In en, this message translates to:
  /// **'Spam'**
  String get miniAppsReasonSpam;

  /// No description provided for @miniAppsReasonInappropriate.
  ///
  /// In en, this message translates to:
  /// **'Inappropriate'**
  String get miniAppsReasonInappropriate;

  /// No description provided for @miniAppsReasonBroken.
  ///
  /// In en, this message translates to:
  /// **'Broken'**
  String get miniAppsReasonBroken;

  /// No description provided for @miniAppsReasonScam.
  ///
  /// In en, this message translates to:
  /// **'Scam'**
  String get miniAppsReasonScam;

  /// No description provided for @miniAppsReasonPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get miniAppsReasonPrivacy;

  /// No description provided for @miniAppsReasonOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get miniAppsReasonOther;

  /// No description provided for @miniAppsRunnerNotFound.
  ///
  /// In en, this message translates to:
  /// **'App not found'**
  String get miniAppsRunnerNotFound;

  /// No description provided for @miniAppsRunnerNotFoundSubtitle.
  ///
  /// In en, this message translates to:
  /// **'It may have been unpublished or removed'**
  String get miniAppsRunnerNotFoundSubtitle;

  /// No description provided for @miniAppsRunnerError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t render the screen'**
  String get miniAppsRunnerError;

  /// No description provided for @miniAppsReload.
  ///
  /// In en, this message translates to:
  /// **'Reload'**
  String get miniAppsReload;

  /// No description provided for @miniAppsClose.
  ///
  /// In en, this message translates to:
  /// **'Close app'**
  String get miniAppsClose;

  /// No description provided for @miniAppsSubmitTitle.
  ///
  /// In en, this message translates to:
  /// **'New mini app'**
  String get miniAppsSubmitTitle;

  /// No description provided for @miniAppsSubmitSubtitle.
  ///
  /// In en, this message translates to:
  /// **'publishes after moderation'**
  String get miniAppsSubmitSubtitle;

  /// No description provided for @miniAppsSubmitNameHint.
  ///
  /// In en, this message translates to:
  /// **'App name'**
  String get miniAppsSubmitNameHint;

  /// No description provided for @miniAppsSubmitSlugHint.
  ///
  /// In en, this message translates to:
  /// **'slug (latin, digits, dashes)'**
  String get miniAppsSubmitSlugHint;

  /// No description provided for @miniAppsSubmitDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Short description for the catalog'**
  String get miniAppsSubmitDescriptionHint;

  /// No description provided for @miniAppsSubmitCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get miniAppsSubmitCategory;

  /// No description provided for @miniAppsSubmitSource.
  ///
  /// In en, this message translates to:
  /// **'Screens source'**
  String get miniAppsSubmitSource;

  /// No description provided for @miniAppsSubmitSourceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'hosted JSON or your own server'**
  String get miniAppsSubmitSourceSubtitle;

  /// No description provided for @miniAppsSourceHosted.
  ///
  /// In en, this message translates to:
  /// **'JSON in app'**
  String get miniAppsSourceHosted;

  /// No description provided for @miniAppsSourceRemote.
  ///
  /// In en, this message translates to:
  /// **'My server'**
  String get miniAppsSourceRemote;

  /// No description provided for @miniAppsSubmitEntryPathHint.
  ///
  /// In en, this message translates to:
  /// **'Entry path, e.g. /'**
  String get miniAppsSubmitEntryPathHint;

  /// No description provided for @miniAppsSubmitJsonHint.
  ///
  /// In en, this message translates to:
  /// **'Stac screen JSON'**
  String get miniAppsSubmitJsonHint;

  /// No description provided for @miniAppsSubmitPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get miniAppsSubmitPreview;

  /// No description provided for @miniAppsSubmitSend.
  ///
  /// In en, this message translates to:
  /// **'Submit for review'**
  String get miniAppsSubmitSend;

  /// No description provided for @miniAppsSubmitSending.
  ///
  /// In en, this message translates to:
  /// **'Submitting...'**
  String get miniAppsSubmitSending;

  /// No description provided for @miniAppsSubmitDraft.
  ///
  /// In en, this message translates to:
  /// **'Save as draft'**
  String get miniAppsSubmitDraft;

  /// No description provided for @miniAppsSubmitSuccess.
  ///
  /// In en, this message translates to:
  /// **'Submitted! The app will appear after moderation.'**
  String get miniAppsSubmitSuccess;

  /// No description provided for @miniAppsSubmitInvalidJson.
  ///
  /// In en, this message translates to:
  /// **'Screen JSON is invalid — check the syntax'**
  String get miniAppsSubmitInvalidJson;

  /// No description provided for @miniAppsSubmitInvalidFields.
  ///
  /// In en, this message translates to:
  /// **'Check the name, slug and origin URL (https only)'**
  String get miniAppsSubmitInvalidFields;

  /// No description provided for @miniAppsSubmitFailure.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t submit. The slug may be taken.'**
  String get miniAppsSubmitFailure;

  /// No description provided for @miniAppsModerationTitle.
  ///
  /// In en, this message translates to:
  /// **'Moderation'**
  String get miniAppsModerationTitle;

  /// No description provided for @miniAppsModerationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'submissions and reports'**
  String get miniAppsModerationSubtitle;

  /// No description provided for @miniAppsModerationEmpty.
  ///
  /// In en, this message translates to:
  /// **'Queue is empty'**
  String get miniAppsModerationEmpty;

  /// No description provided for @miniAppsModerationEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'No pending apps or open reports'**
  String get miniAppsModerationEmptySubtitle;

  /// No description provided for @miniAppsModerationPending.
  ///
  /// In en, this message translates to:
  /// **'Awaiting review'**
  String get miniAppsModerationPending;

  /// No description provided for @miniAppsModerationPendingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'tap a card to preview the app'**
  String get miniAppsModerationPendingSubtitle;

  /// No description provided for @miniAppsModerationReported.
  ///
  /// In en, this message translates to:
  /// **'Reported'**
  String get miniAppsModerationReported;

  /// No description provided for @miniAppsModerationReportedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'apps with open reports'**
  String get miniAppsModerationReportedSubtitle;

  /// No description provided for @miniAppsModerationNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Notes for the author (optional)'**
  String get miniAppsModerationNotesHint;

  /// No description provided for @miniAppsModerationConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get miniAppsModerationConfirm;

  /// No description provided for @miniAppsApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get miniAppsApprove;

  /// No description provided for @miniAppsRejectAction.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get miniAppsRejectAction;

  /// No description provided for @miniAppsSuspend.
  ///
  /// In en, this message translates to:
  /// **'Suspend'**
  String get miniAppsSuspend;

  /// No description provided for @miniAppsRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get miniAppsRestore;

  /// No description provided for @miniAppsDismissReports.
  ///
  /// In en, this message translates to:
  /// **'Dismiss reports'**
  String get miniAppsDismissReports;

  /// No description provided for @profileLoadErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Failed to load profile'**
  String get profileLoadErrorTitle;

  /// No description provided for @profileLoadErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again. Schedule and notes are available offline.'**
  String get profileLoadErrorMessage;

  /// No description provided for @profileStudentFallback.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get profileStudentFallback;

  /// No description provided for @profileCourseLabel.
  ///
  /// In en, this message translates to:
  /// **'{course} course'**
  String profileCourseLabel(int course);

  /// No description provided for @profileLinkCopied.
  ///
  /// In en, this message translates to:
  /// **'Profile copied'**
  String get profileLinkCopied;

  /// No description provided for @profileQuestsOfDay.
  ///
  /// In en, this message translates to:
  /// **'Daily quests'**
  String get profileQuestsOfDay;

  /// No description provided for @profileQuestsCountdown.
  ///
  /// In en, this message translates to:
  /// **'until midnight · +{xp} XP'**
  String profileQuestsCountdown(int xp);

  /// No description provided for @profileGroupLeaderboard.
  ///
  /// In en, this message translates to:
  /// **'Group leaderboard'**
  String get profileGroupLeaderboard;

  /// No description provided for @profileAchievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get profileAchievements;

  /// No description provided for @profileMaxRank.
  ///
  /// In en, this message translates to:
  /// **'max rank'**
  String get profileMaxRank;

  /// No description provided for @profileLevel.
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String profileLevel(int level);

  /// No description provided for @profileXpOfLevel.
  ///
  /// In en, this message translates to:
  /// **'{current} / {total} XP'**
  String profileXpOfLevel(int current, int total);

  /// No description provided for @profileRankNextXp.
  ///
  /// In en, this message translates to:
  /// **'{xp} XP to {rank}'**
  String profileRankNextXp(int xp, String rank);

  /// No description provided for @profileStatStreakDays.
  ///
  /// In en, this message translates to:
  /// **'day streak'**
  String get profileStatStreakDays;

  /// No description provided for @profileStatBadges.
  ///
  /// In en, this message translates to:
  /// **'achievements'**
  String get profileStatBadges;

  /// No description provided for @profileBadgesSection.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get profileBadgesSection;

  /// No description provided for @profileStatGroupRank.
  ///
  /// In en, this message translates to:
  /// **'rank in group'**
  String get profileStatGroupRank;

  /// No description provided for @profileBadgeUnlocked.
  ///
  /// In en, this message translates to:
  /// **'New achievement'**
  String get profileBadgeUnlocked;

  /// No description provided for @profileBadgeEarned.
  ///
  /// In en, this message translates to:
  /// **'Earned'**
  String get profileBadgeEarned;

  /// No description provided for @profileBadgeLocked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get profileBadgeLocked;

  /// No description provided for @profileSectionLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load this section'**
  String get profileSectionLoadFailed;

  /// No description provided for @profileShopTitle.
  ///
  /// In en, this message translates to:
  /// **'Shuriken shop'**
  String get profileShopTitle;

  /// No description provided for @profileShopSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Icons, themes, emoji packs'**
  String get profileShopSubtitle;

  /// No description provided for @profileShopComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get profileShopComingSoon;

  /// No description provided for @profileAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get profileAccount;

  /// No description provided for @profileSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get profileSignOut;

  /// No description provided for @profileSignOutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get profileSignOutConfirm;

  /// No description provided for @profileStreakDays.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, one{{days} day } other{{days} days }}'**
  String profileStreakDays(int days);

  /// No description provided for @profileStreakWord.
  ///
  /// In en, this message translates to:
  /// **'streak'**
  String get profileStreakWord;

  /// No description provided for @profileStreakHint.
  ///
  /// In en, this message translates to:
  /// **'Keep your streak every day'**
  String get profileStreakHint;

  /// No description provided for @profileStreakRecord.
  ///
  /// In en, this message translates to:
  /// **'Record {record, plural, one{{record} day} other{{record} days}} · {more} more to beat it'**
  String profileStreakRecord(int record, int more);

  /// No description provided for @profileStreakRecordBeaten.
  ///
  /// In en, this message translates to:
  /// **'Your personal best!'**
  String get profileStreakRecordBeaten;

  /// No description provided for @profileStreakDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, one{{days} day ago} other{{days} days ago}}'**
  String profileStreakDaysAgo(int days);

  /// No description provided for @profileStreakToday.
  ///
  /// In en, this message translates to:
  /// **'today'**
  String get profileStreakToday;

  /// No description provided for @ninjaPathTitle.
  ///
  /// In en, this message translates to:
  /// **'Ninja path'**
  String get ninjaPathTitle;

  /// No description provided for @ninjaPathTabBadges.
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get ninjaPathTabBadges;

  /// No description provided for @ninjaPathTabQuests.
  ///
  /// In en, this message translates to:
  /// **'Quests'**
  String get ninjaPathTabQuests;

  /// No description provided for @ninjaPathTabRating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get ninjaPathTabRating;

  /// No description provided for @ninjaPathLoadError.
  ///
  /// In en, this message translates to:
  /// **'Loading error'**
  String get ninjaPathLoadError;

  /// No description provided for @ninjaPathToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get ninjaPathToday;

  /// No description provided for @ninjaPathThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get ninjaPathThisWeek;

  /// No description provided for @ninjaPathNoData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get ninjaPathNoData;

  /// No description provided for @ninjaPathScopeGroup.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get ninjaPathScopeGroup;

  /// No description provided for @ninjaPathScopeCourse.
  ///
  /// In en, this message translates to:
  /// **'Stream'**
  String get ninjaPathScopeCourse;

  /// No description provided for @ninjaPathScopeFaculty.
  ///
  /// In en, this message translates to:
  /// **'Institute'**
  String get ninjaPathScopeFaculty;

  /// No description provided for @ninjaPathScopeAll.
  ///
  /// In en, this message translates to:
  /// **'All uni'**
  String get ninjaPathScopeAll;

  /// No description provided for @ninjaRankRow.
  ///
  /// In en, this message translates to:
  /// **'Level {level} · Rank'**
  String ninjaRankRow(int level);

  /// No description provided for @ninjaRankBadges.
  ///
  /// In en, this message translates to:
  /// **'badges'**
  String get ninjaRankBadges;

  /// No description provided for @ninjaRankStreak.
  ///
  /// In en, this message translates to:
  /// **'day streak'**
  String get ninjaRankStreak;

  /// No description provided for @ninjaRankShurikens.
  ///
  /// In en, this message translates to:
  /// **'shurikens'**
  String get ninjaRankShurikens;

  /// No description provided for @miniAppsConsentTitle.
  ///
  /// In en, this message translates to:
  /// **'{name} requests access'**
  String miniAppsConsentTitle(String name);

  /// No description provided for @miniAppsConsentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'you choose what the developer sees'**
  String get miniAppsConsentSubtitle;

  /// No description provided for @miniAppsConsentBody.
  ///
  /// In en, this message translates to:
  /// **'This mini app is run by a third-party developer. Choose what to share — everything below is optional, the app works either way.'**
  String get miniAppsConsentBody;

  /// No description provided for @miniAppsConsentFootnote.
  ///
  /// In en, this message translates to:
  /// **'Your password and session are never shared. Without grants the developer only sees an anonymous ID. You can change this anytime in the app menu.'**
  String get miniAppsConsentFootnote;

  /// No description provided for @miniAppsConsentAllow.
  ///
  /// In en, this message translates to:
  /// **'Allow selected'**
  String get miniAppsConsentAllow;

  /// No description provided for @miniAppsConsentDenyAll.
  ///
  /// In en, this message translates to:
  /// **'Share nothing'**
  String get miniAppsConsentDenyAll;

  /// No description provided for @miniAppsPermissionsSection.
  ///
  /// In en, this message translates to:
  /// **'Data permissions'**
  String get miniAppsPermissionsSection;

  /// No description provided for @miniAppsSubmitPermissions.
  ///
  /// In en, this message translates to:
  /// **'Requested data'**
  String get miniAppsSubmitPermissions;

  /// No description provided for @miniAppsSubmitPermissionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'users will be asked for consent on first launch'**
  String get miniAppsSubmitPermissionsSubtitle;

  /// No description provided for @miniAppsPermIdentity.
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get miniAppsPermIdentity;

  /// No description provided for @miniAppsPermIdentityDesc.
  ///
  /// In en, this message translates to:
  /// **'Stable identifier of your account'**
  String get miniAppsPermIdentityDesc;

  /// No description provided for @miniAppsPermEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get miniAppsPermEmail;

  /// No description provided for @miniAppsPermEmailDesc.
  ///
  /// In en, this message translates to:
  /// **'Your university email address'**
  String get miniAppsPermEmailDesc;

  /// No description provided for @miniAppsPermProfile.
  ///
  /// In en, this message translates to:
  /// **'Name and course'**
  String get miniAppsPermProfile;

  /// No description provided for @miniAppsPermProfileDesc.
  ///
  /// In en, this message translates to:
  /// **'Full name and current course'**
  String get miniAppsPermProfileDesc;

  /// No description provided for @miniAppsPermGroup.
  ///
  /// In en, this message translates to:
  /// **'Academic group'**
  String get miniAppsPermGroup;

  /// No description provided for @miniAppsPermGroupDesc.
  ///
  /// In en, this message translates to:
  /// **'Your group code, e.g. ABCD-01-23'**
  String get miniAppsPermGroupDesc;

  /// Title of the Tools / Links screen
  ///
  /// In en, this message translates to:
  /// **'Links'**
  String get toolsTitle;

  /// Hint and tooltip for the link search field
  ///
  /// In en, this message translates to:
  /// **'Search links'**
  String get toolsSearchHint;

  /// Tooltip to close the link search field
  ///
  /// In en, this message translates to:
  /// **'Close search'**
  String get toolsSearchClose;

  /// Section header for the app-community featured grid
  ///
  /// In en, this message translates to:
  /// **'App community'**
  String get toolsCommunitySection;

  /// Subtitle for the app-community section
  ///
  /// In en, this message translates to:
  /// **'an open-source student project'**
  String get toolsCommunitySectionSubtitle;

  /// Subtitle of the GitHub community card
  ///
  /// In en, this message translates to:
  /// **'Source code on GitHub'**
  String get toolsCardGithubSubtitle;

  /// Title of the Telegram app-chat community card
  ///
  /// In en, this message translates to:
  /// **'App chat'**
  String get toolsCardChatTitle;

  /// Subtitle of the Telegram app-chat community card
  ///
  /// In en, this message translates to:
  /// **'Telegram @mirea_ninja_chat'**
  String get toolsCardChatSubtitle;

  /// Title of the roadmap community card
  ///
  /// In en, this message translates to:
  /// **'Roadmap'**
  String get toolsCardRoadmapTitle;

  /// Subtitle of the roadmap community card
  ///
  /// In en, this message translates to:
  /// **'What\'s in progress and next'**
  String get toolsCardRoadmapSubtitle;

  /// Title of the report-a-bug community card
  ///
  /// In en, this message translates to:
  /// **'Report a bug'**
  String get toolsCardBugTitle;

  /// Subtitle of the report-a-bug community card
  ///
  /// In en, this message translates to:
  /// **'Straight to the GitHub tracker'**
  String get toolsCardBugSubtitle;

  /// Headline of the contributors card with the real contributor count
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} student is building this app} other{{count} students are building this app}}'**
  String toolsContributorsCount(int count);

  /// Headline shown while the contributors list is loading
  ///
  /// In en, this message translates to:
  /// **'Loading contributors…'**
  String get toolsContributorsLoading;

  /// Button that opens the GitHub repository
  ///
  /// In en, this message translates to:
  /// **'Become a contributor'**
  String get toolsBecomeContributor;

  /// Header for the study external-links group
  ///
  /// In en, this message translates to:
  /// **'Study'**
  String get toolsGroupStudy;

  /// Header for the government-services external-links group
  ///
  /// In en, this message translates to:
  /// **'Government services'**
  String get toolsGroupGov;

  /// Header for the community external-links group
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get toolsGroupCommunity;

  /// Name of the LMS educational portal link
  ///
  /// In en, this message translates to:
  /// **'Educational portal'**
  String get toolsLinkEducationalPortal;

  /// Name of the electronic library link
  ///
  /// In en, this message translates to:
  /// **'Electronic library'**
  String get toolsLinkLibrary;

  /// Name of the anti-plagiarism link
  ///
  /// In en, this message translates to:
  /// **'Anti-plagiarism'**
  String get toolsLinkAntiplagiat;

  /// Name of the Modeus schedule link
  ///
  /// In en, this message translates to:
  /// **'Modeus'**
  String get toolsLinkModeus;

  /// Name of the Gosuslugi government-services link
  ///
  /// In en, this message translates to:
  /// **'Gosuslugi'**
  String get toolsLinkGosuslugi;

  /// Name of the SberBank scholarship link
  ///
  /// In en, this message translates to:
  /// **'SberBank scholarship'**
  String get toolsLinkSber;

  /// Name of the Troika transport card link
  ///
  /// In en, this message translates to:
  /// **'Troika card'**
  String get toolsLinkTroika;

  /// Name of the MIREA news Telegram channel link
  ///
  /// In en, this message translates to:
  /// **'@mirea_news'**
  String get toolsLinkNewsChannel;

  /// Name of the CTF team Telegram channel link
  ///
  /// In en, this message translates to:
  /// **'@ctf_keeper'**
  String get toolsLinkCtfTeam;

  /// Title of the Links entry in the services list
  ///
  /// In en, this message translates to:
  /// **'Links'**
  String get toolsServiceTitle;

  /// Free rooms screen subtitle
  ///
  /// In en, this message translates to:
  /// **'by the live schedule'**
  String get freeRoomsSubtitle;

  /// Tooltip of the refresh button on the free rooms screen
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get freeRoomsRefresh;

  /// Free rooms building filter: show all buildings
  ///
  /// In en, this message translates to:
  /// **'All buildings'**
  String get freeRoomsAllBuildings;

  /// Label next to the free rooms count in the summary card
  ///
  /// In en, this message translates to:
  /// **'rooms free right now'**
  String get freeRoomsSummaryLabel;

  /// Current time line in the free rooms summary card
  ///
  /// In en, this message translates to:
  /// **'now {time}'**
  String freeRoomsNow(String time);

  /// Empty state title when no rooms are free
  ///
  /// In en, this message translates to:
  /// **'No free rooms'**
  String get freeRoomsEmptyTitle;

  /// Empty state subtitle when no rooms are free
  ///
  /// In en, this message translates to:
  /// **'Every room is busy — try again later'**
  String get freeRoomsEmptySub;

  /// Free room availability when it stays free until the end of the day
  ///
  /// In en, this message translates to:
  /// **'until end of day'**
  String get freeRoomsUntilEndOfDay;

  /// Free room availability until the next class starts
  ///
  /// In en, this message translates to:
  /// **'until {time}'**
  String freeRoomsFreeUntil(String time);

  /// Campus name line on a free room card
  ///
  /// In en, this message translates to:
  /// **'campus {campus}'**
  String freeRoomsCampus(String campus);

  /// Knowledge bank screen title
  ///
  /// In en, this message translates to:
  /// **'Knowledge bank'**
  String get knowledgeTitle;

  /// Knowledge bank header subtitle with the material count
  ///
  /// In en, this message translates to:
  /// **'{count} materials from students'**
  String knowledgeSubtitle(int count);

  /// Upload material FAB label
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get knowledgeUpload;

  /// Title of the upload bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Upload material'**
  String get knowledgeUploadTitle;

  /// Subtitle of the upload bottom sheet
  ///
  /// In en, this message translates to:
  /// **'share your notes — earn shurikens'**
  String get knowledgeUploadSubtitle;

  /// Material type chip: all materials
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get knowledgeChipAll;

  /// Material type chip: notes
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get knowledgeChipNotes;

  /// Material type chip: exam tickets
  ///
  /// In en, this message translates to:
  /// **'Tickets'**
  String get knowledgeChipTickets;

  /// Material type chip: solutions
  ///
  /// In en, this message translates to:
  /// **'Solutions'**
  String get knowledgeChipSolutions;

  /// Material type chip: cheatsheets
  ///
  /// In en, this message translates to:
  /// **'Cheatsheets'**
  String get knowledgeChipCheats;

  /// Material type label: note
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get knowledgeTypeNote;

  /// Material type label: exam tickets
  ///
  /// In en, this message translates to:
  /// **'Tickets'**
  String get knowledgeTypeExam;

  /// Material type label: solutions
  ///
  /// In en, this message translates to:
  /// **'Solutions'**
  String get knowledgeTypeTask;

  /// Material type label: cheatsheet
  ///
  /// In en, this message translates to:
  /// **'Cheatsheet'**
  String get knowledgeTypeCheat;

  /// Hint next to the shuriken balance
  ///
  /// In en, this message translates to:
  /// **'your balance — paid materials deduct shurikens'**
  String get knowledgeBalanceHint;

  /// Empty catalog title
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get knowledgeEmptyTitle;

  /// Empty catalog subtitle
  ///
  /// In en, this message translates to:
  /// **'Upload the first note — earn shurikens for every download'**
  String get knowledgeEmptySub;

  /// Top authors section title
  ///
  /// In en, this message translates to:
  /// **'Top authors'**
  String get knowledgeTopAuthors;

  /// Status shown when a material has no downloadable file
  ///
  /// In en, this message translates to:
  /// **'No attachment'**
  String get knowledgeMaterialNoAttachment;

  /// Status shown for a protected legacy anonymous attachment
  ///
  /// In en, this message translates to:
  /// **'Needs re-upload'**
  String get knowledgeMaterialRepublishRequired;

  /// Page count shown on a material card
  ///
  /// In en, this message translates to:
  /// **'{n} pp.'**
  String knowledgePages(int n);

  /// Trailing stats on a top author row: downloads and material count
  ///
  /// In en, this message translates to:
  /// **'{downloads} · {materials} mat.'**
  String knowledgeAuthorStats(int downloads, int materials);

  /// Type field label in the upload form
  ///
  /// In en, this message translates to:
  /// **'TYPE'**
  String get knowledgeUploadTypeLabel;

  /// File picker prompt in the upload form
  ///
  /// In en, this message translates to:
  /// **'Drop a file or pick one'**
  String get knowledgeUploadFilePrompt;

  /// File picker hint in the upload form
  ///
  /// In en, this message translates to:
  /// **'PDF, DOCX, photo · up to 50 MB'**
  String get knowledgeUploadFileHint;

  /// Selected file size in the upload form
  ///
  /// In en, this message translates to:
  /// **'{size} MB'**
  String knowledgeUploadFileSize(String size);

  /// Title field hint in the upload form
  ///
  /// In en, this message translates to:
  /// **'Title (ML lecture notes…)'**
  String get knowledgeUploadTitleHint;

  /// Subject field hint in the upload form
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get knowledgeUploadSubjectHint;

  /// Price field label in the upload form
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get knowledgeUploadPriceLabel;

  /// No description provided for @knowledgeUploadDecreasePrice.
  ///
  /// In en, this message translates to:
  /// **'Decrease price'**
  String get knowledgeUploadDecreasePrice;

  /// No description provided for @knowledgeUploadIncreasePrice.
  ///
  /// In en, this message translates to:
  /// **'Increase price'**
  String get knowledgeUploadIncreasePrice;

  /// Price field hint in the upload form
  ///
  /// In en, this message translates to:
  /// **'0 — free · you get 70%'**
  String get knowledgeUploadPriceHint;

  /// Anonymity toggle label in the upload form
  ///
  /// In en, this message translates to:
  /// **'Anonymous'**
  String get knowledgeUploadAnonymous;

  /// Upload reward note in the upload form
  ///
  /// In en, this message translates to:
  /// **'We\'ll award +{amount} shurikens for the material'**
  String knowledgeUploadReward(int amount);

  /// Publish button label while uploading
  ///
  /// In en, this message translates to:
  /// **'Uploading…'**
  String get knowledgeUploadPublishing;

  /// Publish button label
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get knowledgeUploadPublish;

  /// Shuriken wallet screen title
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get walletTitle;

  /// Overline label above the shuriken balance
  ///
  /// In en, this message translates to:
  /// **'BALANCE'**
  String get walletBalanceLabel;

  /// Label under the streak-days balance stat
  ///
  /// In en, this message translates to:
  /// **'days streak'**
  String get walletStreakDays;

  /// Label under the in-group rank balance stat
  ///
  /// In en, this message translates to:
  /// **'in group'**
  String get walletInGroup;

  /// Label under the level balance stat (fallback when rank is unknown)
  ///
  /// In en, this message translates to:
  /// **'level'**
  String get walletLevel;

  /// Explainer describing what shurikens are
  ///
  /// In en, this message translates to:
  /// **'Shurikens are points for activity. Spend them inside the app.'**
  String get walletExplainer;

  /// Highlighted note that shurikens are non-withdrawable
  ///
  /// In en, this message translates to:
  /// **'They cannot be withdrawn for cash.'**
  String get walletExplainerNoCash;

  /// Earn tab label
  ///
  /// In en, this message translates to:
  /// **'Earn'**
  String get walletTabEarn;

  /// Spend tab label
  ///
  /// In en, this message translates to:
  /// **'Spend'**
  String get walletTabSpend;

  /// History tab label
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get walletTabHistory;

  /// Tag on an earn row that is active right now
  ///
  /// In en, this message translates to:
  /// **'now'**
  String get walletEarnLiveTag;

  /// Earn row title: attending classes
  ///
  /// In en, this message translates to:
  /// **'Attend classes'**
  String get walletEarnAttendTitle;

  /// Earn row description: attending classes
  ///
  /// In en, this message translates to:
  /// **'geolocation check-in'**
  String get walletEarnAttendDesc;

  /// Earn row per-unit label: attending classes
  ///
  /// In en, this message translates to:
  /// **'per class'**
  String get walletEarnAttendPer;

  /// Earn row title: streak
  ///
  /// In en, this message translates to:
  /// **'Keep your streak'**
  String get walletEarnStreakTitle;

  /// Earn row description: streak
  ///
  /// In en, this message translates to:
  /// **'every day in a row'**
  String get walletEarnStreakDesc;

  /// Earn row per-unit label: streak
  ///
  /// In en, this message translates to:
  /// **'grows'**
  String get walletEarnStreakPer;

  /// Earn row title: upload material
  ///
  /// In en, this message translates to:
  /// **'Upload notes'**
  String get walletEarnUploadTitle;

  /// Earn row description: upload material
  ///
  /// In en, this message translates to:
  /// **'to the Knowledge Bank'**
  String get walletEarnUploadDesc;

  /// Earn row per-unit label: upload material
  ///
  /// In en, this message translates to:
  /// **'per material'**
  String get walletEarnUploadPer;

  /// Earn row title: downloads of your material
  ///
  /// In en, this message translates to:
  /// **'Your material gets downloaded'**
  String get walletEarnDownloadTitle;

  /// Earn row description: downloads of your material
  ///
  /// In en, this message translates to:
  /// **'70% of the price to the author'**
  String get walletEarnDownloadDesc;

  /// Earn row per-unit label: downloads of your material
  ///
  /// In en, this message translates to:
  /// **'per download'**
  String get walletEarnDownloadPer;

  /// Earn row title: likes
  ///
  /// In en, this message translates to:
  /// **'Likes on materials'**
  String get walletEarnLikeTitle;

  /// Earn row description: likes
  ///
  /// In en, this message translates to:
  /// **'community ratings'**
  String get walletEarnLikeDesc;

  /// Earn row per-unit label: likes
  ///
  /// In en, this message translates to:
  /// **'per ★'**
  String get walletEarnLikePer;

  /// Earn row title: quests
  ///
  /// In en, this message translates to:
  /// **'Complete quests'**
  String get walletEarnQuestTitle;

  /// Earn row description: quests
  ///
  /// In en, this message translates to:
  /// **'daily and weekly'**
  String get walletEarnQuestDesc;

  /// Earn row per-unit label: quests
  ///
  /// In en, this message translates to:
  /// **'per quest'**
  String get walletEarnQuestPer;

  /// Earn row title: chat answers
  ///
  /// In en, this message translates to:
  /// **'Help in chats'**
  String get walletEarnChatTitle;

  /// Earn row description: chat answers
  ///
  /// In en, this message translates to:
  /// **'accepted answers'**
  String get walletEarnChatDesc;

  /// Earn row per-unit label: chat answers
  ///
  /// In en, this message translates to:
  /// **'per answer'**
  String get walletEarnChatPer;

  /// Earn row title: lost and found return
  ///
  /// In en, this message translates to:
  /// **'Return a found item'**
  String get walletEarnFoundTitle;

  /// Earn row description: lost and found return
  ///
  /// In en, this message translates to:
  /// **'via Lost & Found'**
  String get walletEarnFoundDesc;

  /// Earn row per-unit label: lost and found return
  ///
  /// In en, this message translates to:
  /// **'per item'**
  String get walletEarnFoundPer;

  /// Earn row title: referral
  ///
  /// In en, this message translates to:
  /// **'Invite a friend'**
  String get walletEarnReferralTitle;

  /// Earn row description: referral
  ///
  /// In en, this message translates to:
  /// **'by referral link'**
  String get walletEarnReferralDesc;

  /// Earn row per-unit label: referral
  ///
  /// In en, this message translates to:
  /// **'per friend'**
  String get walletEarnReferralPer;

  /// Section title for in-app shuriken sinks
  ///
  /// In en, this message translates to:
  /// **'Spend inside the app'**
  String get walletSpendSectionTitle;

  /// Honest note that partner rewards are not available yet
  ///
  /// In en, this message translates to:
  /// **'Partner rewards are coming later.'**
  String get walletSpendPartnersLater;

  /// Spend row title: knowledge bank materials
  ///
  /// In en, this message translates to:
  /// **'Materials in the Knowledge Bank'**
  String get walletSpendMaterialsTitle;

  /// Spend row description: knowledge bank materials
  ///
  /// In en, this message translates to:
  /// **'notes, tickets, solutions'**
  String get walletSpendMaterialsDesc;

  /// Spend row cost: knowledge bank materials
  ///
  /// In en, this message translates to:
  /// **'from 10'**
  String get walletSpendMaterialsCost;

  /// Spend row title: post boost
  ///
  /// In en, this message translates to:
  /// **'Boost a post in the feed'**
  String get walletSpendBoostTitle;

  /// Spend row description: post boost
  ///
  /// In en, this message translates to:
  /// **'show it to more people'**
  String get walletSpendBoostDesc;

  /// No description provided for @walletSpendBoostCost.
  ///
  /// In en, this message translates to:
  /// **'50'**
  String get walletSpendBoostCost;

  /// Spend row title: themes and icons
  ///
  /// In en, this message translates to:
  /// **'App themes and icons'**
  String get walletSpendThemesTitle;

  /// Spend row description: themes and icons
  ///
  /// In en, this message translates to:
  /// **'customization'**
  String get walletSpendThemesDesc;

  /// Spend row title: Ninja Pro
  ///
  /// In en, this message translates to:
  /// **'Ninja Pro for a month'**
  String get walletSpendProTitle;

  /// Spend row description: Ninja Pro
  ///
  /// In en, this message translates to:
  /// **'no ads and perks'**
  String get walletSpendProDesc;

  /// Empty history title
  ///
  /// In en, this message translates to:
  /// **'History is empty'**
  String get walletHistoryEmptyTitle;

  /// Empty history subtitle
  ///
  /// In en, this message translates to:
  /// **'Complete quests and spend shurikens — every operation will show up here'**
  String get walletHistoryEmptySub;

  /// History timestamp for entries from today
  ///
  /// In en, this message translates to:
  /// **'today {time}'**
  String walletHistoryToday(String time);

  /// History timestamp for entries from yesterday
  ///
  /// In en, this message translates to:
  /// **'yesterday {time}'**
  String walletHistoryYesterday(String time);

  /// Marketplace screen title
  ///
  /// In en, this message translates to:
  /// **'Market'**
  String get marketTitle;

  /// Marketplace header subtitle with the listing count
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{buy-sell among your own · {count} lot} other{buy-sell among your own · {count} lots}}'**
  String marketSubtitle(int count);

  /// Marketplace category filter: all listings
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get marketCatAll;

  /// Marketplace category: textbooks
  ///
  /// In en, this message translates to:
  /// **'Textbooks'**
  String get marketCatBooks;

  /// Marketplace category: tech
  ///
  /// In en, this message translates to:
  /// **'Tech'**
  String get marketCatTech;

  /// Marketplace category: clothes
  ///
  /// In en, this message translates to:
  /// **'Clothes'**
  String get marketCatCloth;

  /// Marketplace category: free / giveaway
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get marketCatFree;

  /// Marketplace category: other
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get marketCatOther;

  /// Price label for a free listing
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get marketFree;

  /// Generic price label for a free item
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get priceFree;

  /// Price of a listing in rubles
  ///
  /// In en, this message translates to:
  /// **'{price}₽'**
  String marketPrice(String price);

  /// Tag shown on a sold listing
  ///
  /// In en, this message translates to:
  /// **'sold'**
  String get marketSold;

  /// Relative time: a day ago
  ///
  /// In en, this message translates to:
  /// **'yesterday'**
  String get marketYesterday;

  /// Marketplace empty state title
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get marketEmptyTitle;

  /// Marketplace empty state subtitle
  ///
  /// In en, this message translates to:
  /// **'List your first item — textbooks and tech get snapped up fast'**
  String get marketEmptySub;

  /// Sell FAB label
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get marketSell;

  /// Sell sheet title
  ///
  /// In en, this message translates to:
  /// **'Sell an item'**
  String get marketSellTitle;

  /// Sell sheet subtitle
  ///
  /// In en, this message translates to:
  /// **'every student will see the listing'**
  String get marketSellSubtitle;

  /// Sell sheet title field hint
  ///
  /// In en, this message translates to:
  /// **'What are you selling?'**
  String get marketTitleHint;

  /// Sell sheet price field hint
  ///
  /// In en, this message translates to:
  /// **'Price, ₽'**
  String get marketPriceHint;

  /// Sell sheet description field hint
  ///
  /// In en, this message translates to:
  /// **'Description (condition, where to pick up…)'**
  String get marketDescriptionHint;

  /// Sell sheet publish button label
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get marketPublish;

  /// Sell sheet publish button label while saving
  ///
  /// In en, this message translates to:
  /// **'Publishing…'**
  String get marketPublishing;

  /// No description provided for @marketLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load the marketplace'**
  String get marketLoadError;

  /// No description provided for @marketLoadErrorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again.'**
  String get marketLoadErrorSubtitle;

  /// No description provided for @marketRefreshError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t refresh listings'**
  String get marketRefreshError;

  /// No description provided for @marketCreateError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t publish the listing'**
  String get marketCreateError;

  /// No description provided for @marketMutationError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t update the listing'**
  String get marketMutationError;

  /// No description provided for @marketDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete listing'**
  String get marketDelete;

  /// No description provided for @marketDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this listing?'**
  String get marketDeleteConfirmTitle;

  /// No description provided for @marketDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'It will disappear from the marketplace permanently.'**
  String get marketDeleteConfirmBody;

  /// No description provided for @marketMarkSold.
  ///
  /// In en, this message translates to:
  /// **'Mark as sold'**
  String get marketMarkSold;

  /// No description provided for @marketMarkAvailable.
  ///
  /// In en, this message translates to:
  /// **'Mark as available'**
  String get marketMarkAvailable;

  /// No description provided for @marketDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Listing details'**
  String get marketDetailsTitle;

  /// No description provided for @marketContactSeller.
  ///
  /// In en, this message translates to:
  /// **'Message seller on Telegram'**
  String get marketContactSeller;

  /// No description provided for @marketContactUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Seller contact isn\'t available'**
  String get marketContactUnavailable;

  /// No description provided for @marketTelegramOpenError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open Telegram'**
  String get marketTelegramOpenError;

  /// No description provided for @marketDescriptionEmpty.
  ///
  /// In en, this message translates to:
  /// **'The seller didn\'t add a description.'**
  String get marketDescriptionEmpty;

  /// No description provided for @marketSellerFallback.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get marketSellerFallback;

  /// No description provided for @marketContactConsent.
  ///
  /// In en, this message translates to:
  /// **'Show my Telegram handle'**
  String get marketContactConsent;

  /// No description provided for @marketContactConsentHint.
  ///
  /// In en, this message translates to:
  /// **'Only students from your university can see it. You can publish without contact details.'**
  String get marketContactConsentHint;

  /// No description provided for @marketPriceInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a price greater than zero'**
  String get marketPriceInvalid;

  /// No description provided for @marketPriceHintWithCurrency.
  ///
  /// In en, this message translates to:
  /// **'Price, {currency}'**
  String marketPriceHintWithCurrency(String currency);

  /// No description provided for @marketOpenDetails.
  ///
  /// In en, this message translates to:
  /// **'Open listing details'**
  String get marketOpenDetails;

  /// Welcome screen tagline under the app name
  ///
  /// In en, this message translates to:
  /// **'Schedule, map, grades and community — all in one pocket.'**
  String get onboardingTagline;

  /// Welcome screen primary button: sign in with a MIREA account
  ///
  /// In en, this message translates to:
  /// **'Sign in with MIREA'**
  String get onboardingSignInMirea;

  /// Onboarding group step heading
  ///
  /// In en, this message translates to:
  /// **'Your group'**
  String get onboardingGroupTitle;

  /// Onboarding group step subtitle
  ///
  /// In en, this message translates to:
  /// **'Start typing your group code'**
  String get onboardingGroupHint;

  /// Onboarding group step search field placeholder
  ///
  /// In en, this message translates to:
  /// **'Group code…'**
  String get onboardingGroupSearchHint;

  /// Onboarding group step message when the query has no matching groups
  ///
  /// In en, this message translates to:
  /// **'No groups found'**
  String get onboardingGroupEmpty;

  /// Onboarding wizard primary CTA to advance to the next step
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// Onboarding wizard skip action
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// Onboarding permissions step heading
  ///
  /// In en, this message translates to:
  /// **'Last touch'**
  String get onboardingPermTitle;

  /// Onboarding permissions step subtitle
  ///
  /// In en, this message translates to:
  /// **'Allow these and the app opens up fully'**
  String get onboardingPermSubtitle;

  /// Onboarding permissions notifications row title
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get onboardingPermNotificationsTitle;

  /// Onboarding permissions notifications row description
  ///
  /// In en, this message translates to:
  /// **'reminders about classes and changes'**
  String get onboardingPermNotificationsDesc;

  /// Onboarding permissions location row title
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get onboardingPermLocationTitle;

  /// Onboarding permissions location row description
  ///
  /// In en, this message translates to:
  /// **'campus navigation'**
  String get onboardingPermLocationDesc;

  /// Onboarding permissions privacy note
  ///
  /// In en, this message translates to:
  /// **'Change anytime in Settings. We don\'t share your data.'**
  String get onboardingPermNote;

  /// Onboarding permissions step primary CTA
  ///
  /// In en, this message translates to:
  /// **'Let\'s go'**
  String get onboardingPermCta;

  /// No description provided for @settingsAppTour.
  ///
  /// In en, this message translates to:
  /// **'App tour'**
  String get settingsAppTour;

  /// Guided tour: bottom navigation step title
  ///
  /// In en, this message translates to:
  /// **'Five sections, one bar'**
  String get tourNavTitle;

  /// Guided tour: bottom navigation step body
  ///
  /// In en, this message translates to:
  /// **'Home, schedule, campus map, services and your profile. Tap the active tab again to jump back to the top.'**
  String get tourNavBody;

  /// Guided tour: global search step title
  ///
  /// In en, this message translates to:
  /// **'Search the whole campus'**
  String get tourSearchTitle;

  /// Guided tour: global search step body
  ///
  /// In en, this message translates to:
  /// **'Classes, lecturers, rooms, people and discussions — from the header of every root screen.'**
  String get tourSearchBody;

  /// Guided tour: home day rail step title
  ///
  /// In en, this message translates to:
  /// **'Your week at a glance'**
  String get tourDaysTitle;

  /// Guided tour: home day rail step body
  ///
  /// In en, this message translates to:
  /// **'Pick a day here, or swipe the board below left and right. Dots show how loaded the day is.'**
  String get tourDaysBody;

  /// Guided tour: home board step title
  ///
  /// In en, this message translates to:
  /// **'What is happening now'**
  String get tourBoardTitle;

  /// Guided tour: home board step body
  ///
  /// In en, this message translates to:
  /// **'The current or next class with its timer, room and the timeline of the whole day.'**
  String get tourBoardBody;

  /// Guided tour: home services step title
  ///
  /// In en, this message translates to:
  /// **'Shortcuts you use daily'**
  String get tourServicesTitle;

  /// Guided tour: home services step body
  ///
  /// In en, this message translates to:
  /// **'Campus pass, map and the rest — one tap away. You choose what lives here in settings.'**
  String get tourServicesBody;

  /// Guided tour: schedule view selector step title
  ///
  /// In en, this message translates to:
  /// **'Day, week, month'**
  String get tourScheduleViewsTitle;

  /// Guided tour: schedule view selector step body
  ///
  /// In en, this message translates to:
  /// **'Three ways to read the schedule. Switch anytime — the selected day follows you.'**
  String get tourScheduleViewsBody;

  /// Guided tour: schedule week strip step title
  ///
  /// In en, this message translates to:
  /// **'Swipe through weeks'**
  String get tourScheduleWeekTitle;

  /// Guided tour: schedule week strip step body
  ///
  /// In en, this message translates to:
  /// **'Swipe the strip for other weeks and tap a date to open it.'**
  String get tourScheduleWeekBody;

  /// Guided tour: services catalog step title
  ///
  /// In en, this message translates to:
  /// **'Every service in one list'**
  String get tourCatalogTitle;

  /// Guided tour: services catalog step body
  ///
  /// In en, this message translates to:
  /// **'Search the catalog and drag the tiles you need into the pinned row.'**
  String get tourCatalogBody;

  /// Guided tour: profile stats step title
  ///
  /// In en, this message translates to:
  /// **'Your ninja path'**
  String get tourProfileTitle;

  /// Guided tour: profile stats step body
  ///
  /// In en, this message translates to:
  /// **'Experience, streaks and achievements grow as you attend and use the app.'**
  String get tourProfileBody;

  /// Guided tour: closing step title
  ///
  /// In en, this message translates to:
  /// **'That is the tour'**
  String get tourDoneTitle;

  /// Guided tour: closing step body
  ///
  /// In en, this message translates to:
  /// **'Take it again anytime: Profile → Settings → App tour.'**
  String get tourDoneBody;

  /// Guided tour: advance to the next step
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get tourNext;

  /// Guided tour: return to the previous step
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get tourBack;

  /// Guided tour: leave the tour
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get tourSkip;

  /// Guided tour: finish the last step
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get tourFinish;

  /// Guided tour: step counter
  ///
  /// In en, this message translates to:
  /// **'{current} of {total}'**
  String tourProgress(int current, int total);

  /// No description provided for @miniAppsSubmitAddScreen.
  ///
  /// In en, this message translates to:
  /// **'Add screen'**
  String get miniAppsSubmitAddScreen;

  /// No description provided for @miniAppsSubmitScreenPathHint.
  ///
  /// In en, this message translates to:
  /// **'Screen path, e.g. /stats'**
  String get miniAppsSubmitScreenPathHint;

  /// No description provided for @miniAppsSubmitRemoveScreen.
  ///
  /// In en, this message translates to:
  /// **'Remove screen'**
  String get miniAppsSubmitRemoveScreen;

  /// No description provided for @miniAppsSubmitInvalidScreens.
  ///
  /// In en, this message translates to:
  /// **'Check screens: paths must be unique latin paths and include /'**
  String get miniAppsSubmitInvalidScreens;

  /// No description provided for @peopleTitle.
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get peopleTitle;

  /// No description provided for @peopleLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t load people'**
  String get peopleLoadError;

  /// No description provided for @peopleLoadErrorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again.'**
  String get peopleLoadErrorSubtitle;

  /// No description provided for @peopleGroupLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not check your group'**
  String get peopleGroupLoadError;

  /// No description provided for @peopleGroupLoadErrorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We will not create another group until your current membership is restored. Try again.'**
  String get peopleGroupLoadErrorSubtitle;

  /// No description provided for @peoplePartialLoadError.
  ///
  /// In en, this message translates to:
  /// **'Some people data could not be refreshed. Showing the latest available data.'**
  String get peoplePartialLoadError;

  /// No description provided for @peopleActionError.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t complete the action. Please try again.'**
  String get peopleActionError;

  /// No description provided for @lessonEditorSubjectRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a subject name.'**
  String get lessonEditorSubjectRequired;

  /// No description provided for @lessonEditorInvalidTimeRange.
  ///
  /// In en, this message translates to:
  /// **'The lesson must end after it starts.'**
  String get lessonEditorInvalidTimeRange;

  /// No description provided for @lessonEditorDuplicateError.
  ///
  /// In en, this message translates to:
  /// **'An identical lesson already exists.'**
  String get lessonEditorDuplicateError;

  /// No description provided for @lessonEditorScheduleMissing.
  ///
  /// In en, this message translates to:
  /// **'This schedule or lesson is no longer available.'**
  String get lessonEditorScheduleMissing;

  /// No description provided for @lessonEditorSaveError.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t save the lesson. Please try again.'**
  String get lessonEditorSaveError;

  /// No description provided for @customScheduleSyncInProgress.
  ///
  /// In en, this message translates to:
  /// **'Syncing schedules'**
  String get customScheduleSyncInProgress;

  /// No description provided for @customScheduleSyncInProgressSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Saving the latest version to your account.'**
  String get customScheduleSyncInProgressSubtitle;

  /// No description provided for @customScheduleSyncPending.
  ///
  /// In en, this message translates to:
  /// **'Changes saved on this device'**
  String get customScheduleSyncPending;

  /// No description provided for @customScheduleSyncPendingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Cloud backup will start shortly.'**
  String get customScheduleSyncPendingSubtitle;

  /// No description provided for @customScheduleSyncOffline.
  ///
  /// In en, this message translates to:
  /// **'Cloud backup is pending'**
  String get customScheduleSyncOffline;

  /// No description provided for @customScheduleSyncOfflineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your schedules are safe on this device. Retry when you’re online.'**
  String get customScheduleSyncOfflineSubtitle;

  /// No description provided for @customScheduleSyncConflict.
  ///
  /// In en, this message translates to:
  /// **'A newer cloud version was detected'**
  String get customScheduleSyncConflict;

  /// No description provided for @customScheduleSyncConflictSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your local changes were kept. Retry to reconcile the versions.'**
  String get customScheduleSyncConflictSubtitle;

  /// No description provided for @peopleRequestSent.
  ///
  /// In en, this message translates to:
  /// **'Friend request sent'**
  String get peopleRequestSent;

  /// No description provided for @peopleTabFriends.
  ///
  /// In en, this message translates to:
  /// **'Friends · {count}'**
  String peopleTabFriends(int count);

  /// No description provided for @peopleTabGroup.
  ///
  /// In en, this message translates to:
  /// **'My group · {count}'**
  String peopleTabGroup(int count);

  /// No description provided for @peopleRequestsLabel.
  ///
  /// In en, this message translates to:
  /// **'Requests · {count}'**
  String peopleRequestsLabel(int count);

  /// No description provided for @peopleLiveNow.
  ///
  /// In en, this message translates to:
  /// **'Live now'**
  String get peopleLiveNow;

  /// No description provided for @peopleAllFriends.
  ///
  /// In en, this message translates to:
  /// **'All friends'**
  String get peopleAllFriends;

  /// No description provided for @peopleEmptyFriendsTitle.
  ///
  /// In en, this message translates to:
  /// **'No friends yet'**
  String get peopleEmptyFriendsTitle;

  /// No description provided for @peopleEmptyFriendsSub.
  ///
  /// In en, this message translates to:
  /// **'Add classmates — see them on the map and in activity'**
  String get peopleEmptyFriendsSub;

  /// No description provided for @peopleFindFriends.
  ///
  /// In en, this message translates to:
  /// **'Find friends'**
  String get peopleFindFriends;

  /// No description provided for @peopleMapTitle.
  ///
  /// In en, this message translates to:
  /// **'Friends on the map'**
  String get peopleMapTitle;

  /// No description provided for @peopleMapOpen.
  ///
  /// In en, this message translates to:
  /// **'Open the friends map'**
  String get peopleMapOpen;

  /// No description provided for @peopleFriendsOnline.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 friend online} other{{count} friends online}}'**
  String peopleFriendsOnline(int count);

  /// No description provided for @peopleOnline.
  ///
  /// In en, this message translates to:
  /// **'online'**
  String get peopleOnline;

  /// No description provided for @peopleGroupTitle.
  ///
  /// In en, this message translates to:
  /// **'My group'**
  String get peopleGroupTitle;

  /// No description provided for @peopleGroupCourse.
  ///
  /// In en, this message translates to:
  /// **'{count} year'**
  String peopleGroupCourse(int count);

  /// No description provided for @peopleGroupPeople.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 person} other{{count} people}}'**
  String peopleGroupPeople(int count);

  /// No description provided for @peopleGroupInFriends.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 in friends} other{{count} in friends}}'**
  String peopleGroupInFriends(int count);

  /// No description provided for @peopleGroupSpaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Group space'**
  String get peopleGroupSpaceTitle;

  /// No description provided for @peopleGroupSpaceSub.
  ///
  /// In en, this message translates to:
  /// **'notes · links · birthdays'**
  String get peopleGroupSpaceSub;

  /// No description provided for @peopleEmptyGroupTitle.
  ///
  /// In en, this message translates to:
  /// **'Group is still empty'**
  String get peopleEmptyGroupTitle;

  /// No description provided for @peopleEmptyGroupSub.
  ///
  /// In en, this message translates to:
  /// **'Classmates will appear here automatically once they open the app'**
  String get peopleEmptyGroupSub;

  /// No description provided for @peopleGroupList.
  ///
  /// In en, this message translates to:
  /// **'Group list'**
  String get peopleGroupList;

  /// No description provided for @peoplePrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'Classmates appear here automatically. You share location and activity only with those you\'\'ve added as friends.'**
  String get peoplePrivacyNote;

  /// No description provided for @peopleTagYou.
  ///
  /// In en, this message translates to:
  /// **'it\'\'s you'**
  String get peopleTagYou;

  /// No description provided for @peopleTagFriend.
  ///
  /// In en, this message translates to:
  /// **'friend'**
  String get peopleTagFriend;

  /// No description provided for @peopleTagRequest.
  ///
  /// In en, this message translates to:
  /// **'request'**
  String get peopleTagRequest;

  /// No description provided for @peopleAddToFriends.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get peopleAddToFriends;

  /// No description provided for @groupSpaceHeaderSubtitleGroup.
  ///
  /// In en, this message translates to:
  /// **'{group} · just us'**
  String groupSpaceHeaderSubtitleGroup(String group);

  /// No description provided for @groupSpaceHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'just us'**
  String get groupSpaceHeaderSubtitle;

  /// No description provided for @groupSpaceMyGroup.
  ///
  /// In en, this message translates to:
  /// **'My group'**
  String get groupSpaceMyGroup;

  /// No description provided for @groupSpaceMembers.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 person} other{{count} people}}'**
  String groupSpaceMembers(int count);

  /// No description provided for @groupSpaceAddTelegramTitle.
  ///
  /// In en, this message translates to:
  /// **'Telegram link'**
  String get groupSpaceAddTelegramTitle;

  /// No description provided for @groupSpaceAddLinkTitle.
  ///
  /// In en, this message translates to:
  /// **'Add link'**
  String get groupSpaceAddLinkTitle;

  /// No description provided for @groupSpaceAddTelegramSubtitle.
  ///
  /// In en, this message translates to:
  /// **'no chat in the app — only in Telegram'**
  String get groupSpaceAddTelegramSubtitle;

  /// No description provided for @groupSpaceAddLinkSubtitleGroup.
  ///
  /// In en, this message translates to:
  /// **'the whole group {group} will see it'**
  String groupSpaceAddLinkSubtitleGroup(String group);

  /// No description provided for @groupSpaceAddLinkSubtitle.
  ///
  /// In en, this message translates to:
  /// **'the whole group will see it'**
  String get groupSpaceAddLinkSubtitle;

  /// No description provided for @groupSpaceAnnouncementSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Group announcement'**
  String get groupSpaceAnnouncementSheetTitle;

  /// No description provided for @groupSpaceNoteSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Share a note'**
  String get groupSpaceNoteSheetTitle;

  /// No description provided for @groupSpaceSectionAnnouncement.
  ///
  /// In en, this message translates to:
  /// **'Headman\'\'s announcement'**
  String get groupSpaceSectionAnnouncement;

  /// No description provided for @groupSpaceSectionLinks.
  ///
  /// In en, this message translates to:
  /// **'Useful links'**
  String get groupSpaceSectionLinks;

  /// No description provided for @groupSpaceSectionNotes.
  ///
  /// In en, this message translates to:
  /// **'Group notes'**
  String get groupSpaceSectionNotes;

  /// No description provided for @groupSpaceSectionBirthdays.
  ///
  /// In en, this message translates to:
  /// **'Birthdays coming up'**
  String get groupSpaceSectionBirthdays;

  /// No description provided for @groupSpaceActionNew.
  ///
  /// In en, this message translates to:
  /// **'+ New'**
  String get groupSpaceActionNew;

  /// No description provided for @groupSpaceActionAdd.
  ///
  /// In en, this message translates to:
  /// **'+ Add'**
  String get groupSpaceActionAdd;

  /// No description provided for @groupSpaceOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get groupSpaceOpen;

  /// No description provided for @groupSpaceAddTelegramRow.
  ///
  /// In en, this message translates to:
  /// **'Add a link to the group chat in Telegram'**
  String get groupSpaceAddTelegramRow;

  /// No description provided for @groupSpaceAnnouncementEmpty.
  ///
  /// In en, this message translates to:
  /// **'No announcements yet — the headman can write the first one'**
  String get groupSpaceAnnouncementEmpty;

  /// No description provided for @groupSpaceLinksEmpty.
  ///
  /// In en, this message translates to:
  /// **'Add a drive with lectures, a duty schedule or class recordings'**
  String get groupSpaceLinksEmpty;

  /// No description provided for @groupSpaceNotesPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Share your notes with the group…'**
  String get groupSpaceNotesPlaceholder;

  /// No description provided for @groupSpaceNotePinned.
  ///
  /// In en, this message translates to:
  /// **'pinned'**
  String get groupSpaceNotePinned;

  /// No description provided for @groupSpaceLinkAddedBy.
  ///
  /// In en, this message translates to:
  /// **'added by {name}'**
  String groupSpaceLinkAddedBy(String name);

  /// No description provided for @groupSpaceBirthdayToday.
  ///
  /// In en, this message translates to:
  /// **'today'**
  String get groupSpaceBirthdayToday;

  /// No description provided for @groupSpaceBirthdayTomorrow.
  ///
  /// In en, this message translates to:
  /// **'tomorrow'**
  String get groupSpaceBirthdayTomorrow;

  /// No description provided for @groupSpaceBirthdayInDays.
  ///
  /// In en, this message translates to:
  /// **'in {days} d'**
  String groupSpaceBirthdayInDays(int days);

  /// No description provided for @groupSpaceBirthdayYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get groupSpaceBirthdayYou;

  /// No description provided for @groupSpaceTimeMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String groupSpaceTimeMinutes(int minutes);

  /// No description provided for @groupSpaceTimeHours.
  ///
  /// In en, this message translates to:
  /// **'{hours} h'**
  String groupSpaceTimeHours(int hours);

  /// No description provided for @groupSpaceTimeYesterday.
  ///
  /// In en, this message translates to:
  /// **'yesterday'**
  String get groupSpaceTimeYesterday;

  /// No description provided for @groupSpaceTimeDays.
  ///
  /// In en, this message translates to:
  /// **'{days} d'**
  String groupSpaceTimeDays(int days);

  /// No description provided for @groupSpaceLinkSheetWhereLabel.
  ///
  /// In en, this message translates to:
  /// **'WHERE IT LEADS'**
  String get groupSpaceLinkSheetWhereLabel;

  /// No description provided for @groupSpaceLinkSheetHandleLabel.
  ///
  /// In en, this message translates to:
  /// **'HANDLE OR LINK'**
  String get groupSpaceLinkSheetHandleLabel;

  /// No description provided for @groupSpaceLinkSheetUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'LINK'**
  String get groupSpaceLinkSheetUrlLabel;

  /// No description provided for @groupSpaceLinkSheetTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'NAME'**
  String get groupSpaceLinkSheetTitleLabel;

  /// No description provided for @groupSpaceLinkSheetCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'CATEGORY'**
  String get groupSpaceLinkSheetCategoryLabel;

  /// No description provided for @groupSpaceLinkSheetTgHint.
  ///
  /// In en, this message translates to:
  /// **'t.me/ikbo09_chat'**
  String get groupSpaceLinkSheetTgHint;

  /// No description provided for @groupSpaceLinkSheetUrlHint.
  ///
  /// In en, this message translates to:
  /// **'drive.google.com/…'**
  String get groupSpaceLinkSheetUrlHint;

  /// No description provided for @groupSpaceLinkSheetTitleHintTg.
  ///
  /// In en, this message translates to:
  /// **'Group chat'**
  String get groupSpaceLinkSheetTitleHintTg;

  /// No description provided for @groupSpaceLinkSheetTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Drive with ML lectures'**
  String get groupSpaceLinkSheetTitleHint;

  /// No description provided for @groupSpaceLinkRecognized.
  ///
  /// In en, this message translates to:
  /// **'recognized automatically'**
  String get groupSpaceLinkRecognized;

  /// No description provided for @groupSpaceLinkCheck.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get groupSpaceLinkCheck;

  /// No description provided for @groupSpaceLinkPrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'Mirea Ninja does not store messages. All chats stay in Telegram, and classmates will see the link.'**
  String get groupSpaceLinkPrivacyNote;

  /// No description provided for @groupSpaceTgDestChat.
  ///
  /// In en, this message translates to:
  /// **'Group chat'**
  String get groupSpaceTgDestChat;

  /// No description provided for @groupSpaceTgDestProfile.
  ///
  /// In en, this message translates to:
  /// **'My profile'**
  String get groupSpaceTgDestProfile;

  /// No description provided for @groupSpaceTgDestChannel.
  ///
  /// In en, this message translates to:
  /// **'Channel'**
  String get groupSpaceTgDestChannel;

  /// No description provided for @groupSpaceCatStudy.
  ///
  /// In en, this message translates to:
  /// **'Study'**
  String get groupSpaceCatStudy;

  /// No description provided for @groupSpaceCatDrive.
  ///
  /// In en, this message translates to:
  /// **'Drive'**
  String get groupSpaceCatDrive;

  /// No description provided for @groupSpaceCatDuty.
  ///
  /// In en, this message translates to:
  /// **'Duty'**
  String get groupSpaceCatDuty;

  /// No description provided for @groupSpaceCatRecords.
  ///
  /// In en, this message translates to:
  /// **'Recordings'**
  String get groupSpaceCatRecords;

  /// No description provided for @groupSpaceCatOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get groupSpaceCatOther;

  /// No description provided for @groupSpaceRecognizedDrive.
  ///
  /// In en, this message translates to:
  /// **'Google Drive · folder'**
  String get groupSpaceRecognizedDrive;

  /// No description provided for @groupSpaceRecognizedDocs.
  ///
  /// In en, this message translates to:
  /// **'Google Docs'**
  String get groupSpaceRecognizedDocs;

  /// No description provided for @groupSpaceRecognizedTelegram.
  ///
  /// In en, this message translates to:
  /// **'Telegram'**
  String get groupSpaceRecognizedTelegram;

  /// No description provided for @groupSpaceRecognizedLms.
  ///
  /// In en, this message translates to:
  /// **'LMS MIREA'**
  String get groupSpaceRecognizedLms;

  /// No description provided for @groupSpaceRecognizedGithub.
  ///
  /// In en, this message translates to:
  /// **'GitHub'**
  String get groupSpaceRecognizedGithub;

  /// No description provided for @groupSpaceRecognizedYoutube.
  ///
  /// In en, this message translates to:
  /// **'YouTube'**
  String get groupSpaceRecognizedYoutube;

  /// No description provided for @groupSpaceSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get groupSpaceSaving;

  /// No description provided for @groupSpaceSaveTelegram.
  ///
  /// In en, this message translates to:
  /// **'Save link'**
  String get groupSpaceSaveTelegram;

  /// No description provided for @groupSpaceSaveLink.
  ///
  /// In en, this message translates to:
  /// **'Add to group'**
  String get groupSpaceSaveLink;

  /// No description provided for @groupSpacePostTitleHintAnnouncement.
  ///
  /// In en, this message translates to:
  /// **'What happened?'**
  String get groupSpacePostTitleHintAnnouncement;

  /// No description provided for @groupSpacePostTitleHintNote.
  ///
  /// In en, this message translates to:
  /// **'Note title'**
  String get groupSpacePostTitleHintNote;

  /// No description provided for @groupSpacePostBodyHint.
  ///
  /// In en, this message translates to:
  /// **'Details (optional)'**
  String get groupSpacePostBodyHint;

  /// No description provided for @groupSpacePublishing.
  ///
  /// In en, this message translates to:
  /// **'Publishing…'**
  String get groupSpacePublishing;

  /// No description provided for @groupSpacePublish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get groupSpacePublish;

  /// No description provided for @postDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get postDetailTitle;

  /// No description provided for @postDetailLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load the post'**
  String get postDetailLoadError;

  /// No description provided for @postDetailComments.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Comments} =1{1 comment} other{{count} comments}}'**
  String postDetailComments(int count);

  /// No description provided for @postDetailNoComments.
  ///
  /// In en, this message translates to:
  /// **'No comments yet'**
  String get postDetailNoComments;

  /// No description provided for @teamFinderTitle.
  ///
  /// In en, this message translates to:
  /// **'Find a team'**
  String get teamFinderTitle;

  /// No description provided for @teamFinderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'hackathons · projects · coursework'**
  String get teamFinderSubtitle;

  /// No description provided for @teamFinderCreateCta.
  ///
  /// In en, this message translates to:
  /// **'Build a team'**
  String get teamFinderCreateCta;

  /// No description provided for @teamFinderFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get teamFinderFilterAll;

  /// No description provided for @teamFinderFilterMine.
  ///
  /// In en, this message translates to:
  /// **'Mine'**
  String get teamFinderFilterMine;

  /// No description provided for @teamFinderKindHackathon.
  ///
  /// In en, this message translates to:
  /// **'Hackathon'**
  String get teamFinderKindHackathon;

  /// No description provided for @teamFinderKindProject.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get teamFinderKindProject;

  /// No description provided for @teamFinderKindStudy.
  ///
  /// In en, this message translates to:
  /// **'Study'**
  String get teamFinderKindStudy;

  /// No description provided for @teamFinderFilterHackathons.
  ///
  /// In en, this message translates to:
  /// **'Hackathons'**
  String get teamFinderFilterHackathons;

  /// No description provided for @teamFinderFilterProjects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get teamFinderFilterProjects;

  /// No description provided for @teamFinderFilterStudy.
  ///
  /// In en, this message translates to:
  /// **'Study'**
  String get teamFinderFilterStudy;

  /// No description provided for @teamFinderEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No teams yet'**
  String get teamFinderEmptyTitle;

  /// No description provided for @teamFinderEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Build your own — for a hackathon, coursework or a pet project'**
  String get teamFinderEmptySubtitle;

  /// No description provided for @teamFinderApplicationSent.
  ///
  /// In en, this message translates to:
  /// **'Application sent'**
  String get teamFinderApplicationSent;

  /// No description provided for @teamFinderApplySheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get teamFinderApplySheetTitle;

  /// No description provided for @teamFinderApplicationsSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Applications · {team}'**
  String teamFinderApplicationsSheetTitle(String team);

  /// No description provided for @teamFinderCreateSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Build a team'**
  String get teamFinderCreateSheetTitle;

  /// No description provided for @teamFinderCreateSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'we\'ll find people for your task'**
  String get teamFinderCreateSheetSubtitle;

  /// No description provided for @teamFinderTagBurning.
  ///
  /// In en, this message translates to:
  /// **'burning'**
  String get teamFinderTagBurning;

  /// No description provided for @teamFinderTagTop.
  ///
  /// In en, this message translates to:
  /// **'top'**
  String get teamFinderTagTop;

  /// No description provided for @teamFinderDeadlineUntil.
  ///
  /// In en, this message translates to:
  /// **'until {date}'**
  String teamFinderDeadlineUntil(String date);

  /// No description provided for @teamFinderLookingForRole.
  ///
  /// In en, this message translates to:
  /// **'looking for: {role}'**
  String teamFinderLookingForRole(String role);

  /// No description provided for @teamFinderMembersOf.
  ///
  /// In en, this message translates to:
  /// **'{count}/{capacity} on the team'**
  String teamFinderMembersOf(int count, int capacity);

  /// No description provided for @teamFinderApplicationsCount.
  ///
  /// In en, this message translates to:
  /// **'Applications · {count}'**
  String teamFinderApplicationsCount(int count);

  /// No description provided for @teamFinderNoApplications.
  ///
  /// In en, this message translates to:
  /// **'No applications'**
  String get teamFinderNoApplications;

  /// No description provided for @teamFinderOnTeam.
  ///
  /// In en, this message translates to:
  /// **'On the team'**
  String get teamFinderOnTeam;

  /// No description provided for @teamFinderApplied.
  ///
  /// In en, this message translates to:
  /// **'Application sent'**
  String get teamFinderApplied;

  /// No description provided for @teamFinderFull.
  ///
  /// In en, this message translates to:
  /// **'No spots'**
  String get teamFinderFull;

  /// No description provided for @teamFinderApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get teamFinderApply;

  /// No description provided for @teamFinderCreateNameLabel.
  ///
  /// In en, this message translates to:
  /// **'NAME'**
  String get teamFinderCreateNameLabel;

  /// No description provided for @teamFinderCreateNameHint.
  ///
  /// In en, this message translates to:
  /// **'Campus app for students'**
  String get teamFinderCreateNameHint;

  /// No description provided for @teamFinderCreateDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'DESCRIPTION'**
  String get teamFinderCreateDescriptionLabel;

  /// No description provided for @teamFinderCreateDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'We have a backend and an idea. Building it over the weekend…'**
  String get teamFinderCreateDescriptionHint;

  /// No description provided for @teamFinderCreateRolesLabel.
  ///
  /// In en, this message translates to:
  /// **'WHO I\'M LOOKING FOR'**
  String get teamFinderCreateRolesLabel;

  /// No description provided for @teamFinderRoleFrontend.
  ///
  /// In en, this message translates to:
  /// **'Frontend'**
  String get teamFinderRoleFrontend;

  /// No description provided for @teamFinderRoleMl.
  ///
  /// In en, this message translates to:
  /// **'ML'**
  String get teamFinderRoleMl;

  /// No description provided for @teamFinderRoleDesign.
  ///
  /// In en, this message translates to:
  /// **'Design'**
  String get teamFinderRoleDesign;

  /// No description provided for @teamFinderRoleBackend.
  ///
  /// In en, this message translates to:
  /// **'Backend'**
  String get teamFinderRoleBackend;

  /// No description provided for @teamFinderRoleMarketing.
  ///
  /// In en, this message translates to:
  /// **'Marketing'**
  String get teamFinderRoleMarketing;

  /// No description provided for @teamFinderRoleSelected.
  ///
  /// In en, this message translates to:
  /// **'{role}'**
  String teamFinderRoleSelected(String role);

  /// No description provided for @teamFinderCreateSizeLabel.
  ///
  /// In en, this message translates to:
  /// **'Team size'**
  String get teamFinderCreateSizeLabel;

  /// No description provided for @teamFinderCreateDeadlineLabel.
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get teamFinderCreateDeadlineLabel;

  /// No description provided for @teamFinderCreateDeadlineEmpty.
  ///
  /// In en, this message translates to:
  /// **'we\'ll mark it as \"burning\" closer to the date'**
  String get teamFinderCreateDeadlineEmpty;

  /// No description provided for @teamFinderCreateBoostTitle.
  ///
  /// In en, this message translates to:
  /// **'Boost to top for 50 shurikens'**
  String get teamFinderCreateBoostTitle;

  /// No description provided for @teamFinderCreateBoostSubtitle.
  ///
  /// In en, this message translates to:
  /// **'people see it first all day'**
  String get teamFinderCreateBoostSubtitle;

  /// No description provided for @teamFinderPublishing.
  ///
  /// In en, this message translates to:
  /// **'Publishing…'**
  String get teamFinderPublishing;

  /// No description provided for @teamFinderPublish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get teamFinderPublish;

  /// No description provided for @teamFinderApplyMembersInfo.
  ///
  /// In en, this message translates to:
  /// **'{count}/{capacity} on the team{roles}'**
  String teamFinderApplyMembersInfo(int count, int capacity, String roles);

  /// No description provided for @teamFinderApplyNeededRoles.
  ///
  /// In en, this message translates to:
  /// **' · need {roles}'**
  String teamFinderApplyNeededRoles(String roles);

  /// No description provided for @teamFinderApplyDeadline.
  ///
  /// In en, this message translates to:
  /// **'deadline by {date}'**
  String teamFinderApplyDeadline(String date);

  /// No description provided for @teamFinderApplyRoleLabel.
  ///
  /// In en, this message translates to:
  /// **'FOR WHICH ROLE'**
  String get teamFinderApplyRoleLabel;

  /// No description provided for @teamFinderApplyAboutLabel.
  ///
  /// In en, this message translates to:
  /// **'A FEW WORDS ABOUT YOU'**
  String get teamFinderApplyAboutLabel;

  /// No description provided for @teamFinderApplyAboutHint.
  ///
  /// In en, this message translates to:
  /// **'Built 3 projects in React, I have a portfolio…'**
  String get teamFinderApplyAboutHint;

  /// No description provided for @teamFinderApplyPreviewLabel.
  ///
  /// In en, this message translates to:
  /// **'WHAT THE AUTHOR SEES'**
  String get teamFinderApplyPreviewLabel;

  /// No description provided for @teamFinderApplyYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get teamFinderApplyYou;

  /// No description provided for @teamFinderApplyYouNamed.
  ///
  /// In en, this message translates to:
  /// **'You · {name}'**
  String teamFinderApplyYouNamed(String name);

  /// No description provided for @teamFinderApplyAttachProfile.
  ///
  /// In en, this message translates to:
  /// **'Attach profile and group'**
  String get teamFinderApplyAttachProfile;

  /// No description provided for @teamFinderSending.
  ///
  /// In en, this message translates to:
  /// **'Sending…'**
  String get teamFinderSending;

  /// No description provided for @teamFinderSendApplication.
  ///
  /// In en, this message translates to:
  /// **'Send application'**
  String get teamFinderSendApplication;

  /// No description provided for @teamFinderApplicationsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No applications yet'**
  String get teamFinderApplicationsEmptyTitle;

  /// No description provided for @teamFinderApplicationsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Boost your team to the top — more people will see it'**
  String get teamFinderApplicationsEmptySubtitle;

  /// No description provided for @teamFinderWriteTelegram.
  ///
  /// In en, this message translates to:
  /// **'Message on Telegram'**
  String get teamFinderWriteTelegram;

  /// No description provided for @mentorshipTitle.
  ///
  /// In en, this message translates to:
  /// **'Mentorship'**
  String get mentorshipTitle;

  /// No description provided for @mentorshipHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'seniors help juniors · {count, plural, =1{{count} mentor} other{{count} mentors}}'**
  String mentorshipHeaderSubtitle(int count);

  /// No description provided for @mentorshipMyProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'My mentor profile'**
  String get mentorshipMyProfileTitle;

  /// No description provided for @mentorshipBecomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Become a mentor'**
  String get mentorshipBecomeTitle;

  /// No description provided for @mentorshipBecomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your topics, meeting formats and how you can help'**
  String get mentorshipBecomeSubtitle;

  /// No description provided for @mentorshipRequestSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Request to a mentor'**
  String get mentorshipRequestSheetTitle;

  /// No description provided for @mentorshipRequestSent.
  ///
  /// In en, this message translates to:
  /// **'Request sent'**
  String get mentorshipRequestSent;

  /// No description provided for @mentorshipYouAreMentor.
  ///
  /// In en, this message translates to:
  /// **'You\'re a mentor'**
  String get mentorshipYouAreMentor;

  /// No description provided for @mentorshipBecomeCta.
  ///
  /// In en, this message translates to:
  /// **'Become a mentor'**
  String get mentorshipBecomeCta;

  /// No description provided for @mentorshipEditHint.
  ///
  /// In en, this message translates to:
  /// **'edit topics or profile'**
  String get mentorshipEditHint;

  /// No description provided for @mentorshipBecomeHint.
  ///
  /// In en, this message translates to:
  /// **'Help out and earn shurikens + reputation'**
  String get mentorshipBecomeHint;

  /// No description provided for @mentorshipRequestsToYou.
  ///
  /// In en, this message translates to:
  /// **'REQUESTS TO YOU'**
  String get mentorshipRequestsToYou;

  /// No description provided for @mentorshipEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No mentors yet'**
  String get mentorshipEmptyTitle;

  /// No description provided for @mentorshipEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Be the first — help junior years with studies and careers'**
  String get mentorshipEmptySubtitle;

  /// No description provided for @mentorshipCourse.
  ///
  /// In en, this message translates to:
  /// **'year {course}'**
  String mentorshipCourse(int course);

  /// No description provided for @mentorshipItsYou.
  ///
  /// In en, this message translates to:
  /// **'it\'s you'**
  String get mentorshipItsYou;

  /// No description provided for @mentorshipEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get mentorshipEditProfile;

  /// No description provided for @mentorshipNoHandle.
  ///
  /// In en, this message translates to:
  /// **'handle not set'**
  String get mentorshipNoHandle;

  /// No description provided for @mentorshipTopicMl.
  ///
  /// In en, this message translates to:
  /// **'ML'**
  String get mentorshipTopicMl;

  /// No description provided for @mentorshipTopicPython.
  ///
  /// In en, this message translates to:
  /// **'Python'**
  String get mentorshipTopicPython;

  /// No description provided for @mentorshipTopicCareer.
  ///
  /// In en, this message translates to:
  /// **'Career'**
  String get mentorshipTopicCareer;

  /// No description provided for @mentorshipTopicDesign.
  ///
  /// In en, this message translates to:
  /// **'Design'**
  String get mentorshipTopicDesign;

  /// No description provided for @mentorshipTopicFrontend.
  ///
  /// In en, this message translates to:
  /// **'Frontend'**
  String get mentorshipTopicFrontend;

  /// No description provided for @mentorshipTopicCybersec.
  ///
  /// In en, this message translates to:
  /// **'Cybersec'**
  String get mentorshipTopicCybersec;

  /// No description provided for @mentorshipLevelCourse3.
  ///
  /// In en, this message translates to:
  /// **'3rd year'**
  String get mentorshipLevelCourse3;

  /// No description provided for @mentorshipLevelCourse4.
  ///
  /// In en, this message translates to:
  /// **'4th year'**
  String get mentorshipLevelCourse4;

  /// No description provided for @mentorshipLevelMaster.
  ///
  /// In en, this message translates to:
  /// **'Master\'s'**
  String get mentorshipLevelMaster;

  /// No description provided for @mentorshipFormatOnline.
  ///
  /// In en, this message translates to:
  /// **'Online call'**
  String get mentorshipFormatOnline;

  /// No description provided for @mentorshipFormatCampus.
  ///
  /// In en, this message translates to:
  /// **'In person on campus'**
  String get mentorshipFormatCampus;

  /// No description provided for @mentorshipFormatChat.
  ///
  /// In en, this message translates to:
  /// **'Chat only'**
  String get mentorshipFormatChat;

  /// No description provided for @mentorshipRewardTitle.
  ///
  /// In en, this message translates to:
  /// **'≈ 80 shurikens per session'**
  String get mentorshipRewardTitle;

  /// No description provided for @mentorshipRewardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'+ a «Mentor» badge on your profile'**
  String get mentorshipRewardSubtitle;

  /// No description provided for @mentorshipTopicsLabel.
  ///
  /// In en, this message translates to:
  /// **'What you\'re good at'**
  String get mentorshipTopicsLabel;

  /// No description provided for @mentorshipCustomTopicLabel.
  ///
  /// In en, this message translates to:
  /// **'Your own topic'**
  String get mentorshipCustomTopicLabel;

  /// No description provided for @mentorshipCustomTopicHint.
  ///
  /// In en, this message translates to:
  /// **'For example, Flutter or calculus'**
  String get mentorshipCustomTopicHint;

  /// No description provided for @mentorshipTopicsLimit.
  ///
  /// In en, this message translates to:
  /// **'Up to 20 topics, 60 characters each'**
  String get mentorshipTopicsLimit;

  /// No description provided for @mentorshipBioLabel.
  ///
  /// In en, this message translates to:
  /// **'About you'**
  String get mentorshipBioLabel;

  /// No description provided for @mentorshipPending.
  ///
  /// In en, this message translates to:
  /// **'Awaiting a reply'**
  String get mentorshipPending;

  /// No description provided for @mentorshipAccepted.
  ///
  /// In en, this message translates to:
  /// **'Session agreed'**
  String get mentorshipAccepted;

  /// No description provided for @mentorshipLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Your level'**
  String get mentorshipLevelLabel;

  /// No description provided for @mentorshipFormatLabel.
  ///
  /// In en, this message translates to:
  /// **'Meeting format'**
  String get mentorshipFormatLabel;

  /// No description provided for @mentorshipPriceTitle.
  ///
  /// In en, this message translates to:
  /// **'Session price'**
  String get mentorshipPriceTitle;

  /// No description provided for @mentorshipPriceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'in shurikens · can be free'**
  String get mentorshipPriceSubtitle;

  /// No description provided for @mentorshipBioHint.
  ///
  /// In en, this message translates to:
  /// **'About you: how you can help…'**
  String get mentorshipBioHint;

  /// No description provided for @mentorshipSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get mentorshipSaving;

  /// No description provided for @mentorshipSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get mentorshipSave;

  /// No description provided for @mentorshipQuit.
  ///
  /// In en, this message translates to:
  /// **'Stop being a mentor'**
  String get mentorshipQuit;

  /// No description provided for @mentorshipSessionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} session} other{{count} sessions}}'**
  String mentorshipSessionsCount(int count);

  /// No description provided for @mentorshipTopicLabel.
  ///
  /// In en, this message translates to:
  /// **'Topic'**
  String get mentorshipTopicLabel;

  /// No description provided for @mentorshipWhenLabel.
  ///
  /// In en, this message translates to:
  /// **'When works for you'**
  String get mentorshipWhenLabel;

  /// No description provided for @mentorshipWhenTonight.
  ///
  /// In en, this message translates to:
  /// **'Tonight'**
  String get mentorshipWhenTonight;

  /// No description provided for @mentorshipWhenTonightHint.
  ///
  /// In en, this message translates to:
  /// **'after 18:00'**
  String get mentorshipWhenTonightHint;

  /// No description provided for @mentorshipWhenTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow afternoon'**
  String get mentorshipWhenTomorrow;

  /// No description provided for @mentorshipWhenWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get mentorshipWhenWeek;

  /// No description provided for @mentorshipWhenShortTonight.
  ///
  /// In en, this message translates to:
  /// **'tonight'**
  String get mentorshipWhenShortTonight;

  /// No description provided for @mentorshipWhenShortTomorrow.
  ///
  /// In en, this message translates to:
  /// **'tomorrow afternoon'**
  String get mentorshipWhenShortTomorrow;

  /// No description provided for @mentorshipWhenShortWeek.
  ///
  /// In en, this message translates to:
  /// **'this week'**
  String get mentorshipWhenShortWeek;

  /// No description provided for @mentorshipMessageLabel.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get mentorshipMessageLabel;

  /// No description provided for @mentorshipMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Hi! I\'m stuck on backprop in my coursework…'**
  String get mentorshipMessageHint;

  /// No description provided for @mentorshipFreeSession.
  ///
  /// In en, this message translates to:
  /// **'This session is free'**
  String get mentorshipFreeSession;

  /// No description provided for @mentorshipPaidSession.
  ///
  /// In en, this message translates to:
  /// **'{price} shurikens will be reserved after the request is accepted'**
  String mentorshipPaidSession(int price);

  /// No description provided for @mentorshipSendRequest.
  ///
  /// In en, this message translates to:
  /// **'Send request'**
  String get mentorshipSendRequest;

  /// No description provided for @mentorshipReplyTelegram.
  ///
  /// In en, this message translates to:
  /// **'Reply on Telegram'**
  String get mentorshipReplyTelegram;

  /// No description provided for @mentorshipLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load mentors'**
  String get mentorshipLoadError;

  /// No description provided for @mentorshipLoadErrorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again.'**
  String get mentorshipLoadErrorSubtitle;

  /// No description provided for @mentorshipRefreshError.
  ///
  /// In en, this message translates to:
  /// **'Could not refresh mentorship data'**
  String get mentorshipRefreshError;

  /// No description provided for @mentorshipRequestsError.
  ///
  /// In en, this message translates to:
  /// **'Could not load mentorship requests'**
  String get mentorshipRequestsError;

  /// No description provided for @mentorshipRequestsErrorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Mentor profiles are still available.'**
  String get mentorshipRequestsErrorSubtitle;

  /// No description provided for @mentorshipInvalidHandle.
  ///
  /// In en, this message translates to:
  /// **'This Telegram username is invalid'**
  String get mentorshipInvalidHandle;

  /// No description provided for @mentorshipOpenTelegramError.
  ///
  /// In en, this message translates to:
  /// **'Could not open Telegram'**
  String get mentorshipOpenTelegramError;

  /// No description provided for @mentorshipRequestActionError.
  ///
  /// In en, this message translates to:
  /// **'Could not update the request'**
  String get mentorshipRequestActionError;

  /// No description provided for @mentorshipProfileSaveError.
  ///
  /// In en, this message translates to:
  /// **'Could not save the mentor profile'**
  String get mentorshipProfileSaveError;

  /// No description provided for @mentorshipProfileDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Could not disable the mentor profile'**
  String get mentorshipProfileDeleteError;

  /// No description provided for @mentorshipQuitConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Stop being a mentor?'**
  String get mentorshipQuitConfirmTitle;

  /// No description provided for @mentorshipQuitConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Your profile will disappear from the mentor list.'**
  String get mentorshipQuitConfirmBody;

  /// No description provided for @mentorshipDecreasePrice.
  ///
  /// In en, this message translates to:
  /// **'Decrease session price'**
  String get mentorshipDecreasePrice;

  /// No description provided for @mentorshipIncreasePrice.
  ///
  /// In en, this message translates to:
  /// **'Increase session price'**
  String get mentorshipIncreasePrice;

  /// No description provided for @mentorshipRequestError.
  ///
  /// In en, this message translates to:
  /// **'Could not send the request'**
  String get mentorshipRequestError;

  /// No description provided for @mentorshipOutgoingRequests.
  ///
  /// In en, this message translates to:
  /// **'YOUR REQUESTS'**
  String get mentorshipOutgoingRequests;

  /// No description provided for @mentorshipAcceptRequest.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get mentorshipAcceptRequest;

  /// No description provided for @mentorshipDeclineRequest.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get mentorshipDeclineRequest;

  /// No description provided for @mentorshipCancelRequest.
  ///
  /// In en, this message translates to:
  /// **'Cancel request'**
  String get mentorshipCancelRequest;

  /// No description provided for @mentorshipCancelConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel this request?'**
  String get mentorshipCancelConfirmTitle;

  /// No description provided for @mentorshipCancelConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'The request will close. The session will not count as completed.'**
  String get mentorshipCancelConfirmBody;

  /// No description provided for @mentorshipCancelConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Cancel request'**
  String get mentorshipCancelConfirmAction;

  /// No description provided for @mentorshipConfirmComplete.
  ///
  /// In en, this message translates to:
  /// **'Confirm session complete'**
  String get mentorshipConfirmComplete;

  /// No description provided for @mentorshipWaitingConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Waiting for the other participant'**
  String get mentorshipWaitingConfirmation;

  /// No description provided for @mentorshipCompleted.
  ///
  /// In en, this message translates to:
  /// **'Session completed'**
  String get mentorshipCompleted;

  /// No description provided for @mentorshipDeclined.
  ///
  /// In en, this message translates to:
  /// **'Request declined'**
  String get mentorshipDeclined;

  /// No description provided for @mentorshipCancelled.
  ///
  /// In en, this message translates to:
  /// **'Request cancelled'**
  String get mentorshipCancelled;

  /// No description provided for @miniAppsPermNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get miniAppsPermNotifications;

  /// No description provided for @miniAppsPermNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Push messages from the developer (max 2 per day)'**
  String get miniAppsPermNotificationsDesc;

  /// No description provided for @miniAppsPermLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get miniAppsPermLocation;

  /// No description provided for @miniAppsPermLocationDesc.
  ///
  /// In en, this message translates to:
  /// **'Your device coordinates, when the app asks'**
  String get miniAppsPermLocationDesc;

  /// No description provided for @miniAppsPermCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get miniAppsPermCamera;

  /// No description provided for @miniAppsPermCameraDesc.
  ///
  /// In en, this message translates to:
  /// **'Take photos and scan codes'**
  String get miniAppsPermCameraDesc;

  /// No description provided for @miniAppsPermFiles.
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get miniAppsPermFiles;

  /// No description provided for @miniAppsPermFilesDesc.
  ///
  /// In en, this message translates to:
  /// **'Attach a file you choose'**
  String get miniAppsPermFilesDesc;

  /// No description provided for @miniAppsPermCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get miniAppsPermCalendar;

  /// No description provided for @miniAppsPermCalendarDesc.
  ///
  /// In en, this message translates to:
  /// **'Add events to your device calendar'**
  String get miniAppsPermCalendarDesc;

  /// No description provided for @miniAppsScopeNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get miniAppsScopeNotNow;

  /// No description provided for @miniAppsScanTitle.
  ///
  /// In en, this message translates to:
  /// **'Scanner'**
  String get miniAppsScanTitle;

  /// No description provided for @miniAppsScanInstruction.
  ///
  /// In en, this message translates to:
  /// **'Point the camera at a code'**
  String get miniAppsScanInstruction;

  /// No description provided for @miniAppsScanCameraError.
  ///
  /// In en, this message translates to:
  /// **'Could not open the camera'**
  String get miniAppsScanCameraError;

  /// No description provided for @miniAppsSortTitle.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get miniAppsSortTitle;

  /// No description provided for @miniAppsSortPopular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get miniAppsSortPopular;

  /// No description provided for @miniAppsSortNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get miniAppsSortNew;

  /// No description provided for @miniAppsSortTop.
  ///
  /// In en, this message translates to:
  /// **'Top rated'**
  String get miniAppsSortTop;

  /// No description provided for @miniAppsRecents.
  ///
  /// In en, this message translates to:
  /// **'Recently opened'**
  String get miniAppsRecents;

  /// No description provided for @miniAppsFeature.
  ///
  /// In en, this message translates to:
  /// **'Feature in catalog'**
  String get miniAppsFeature;

  /// No description provided for @miniAppsUnfeature.
  ///
  /// In en, this message translates to:
  /// **'Remove from featured'**
  String get miniAppsUnfeature;

  /// No description provided for @miniAppsQr.
  ///
  /// In en, this message translates to:
  /// **'QR code'**
  String get miniAppsQr;

  /// No description provided for @miniAppsShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get miniAppsShare;

  /// No description provided for @miniAppsQrHint.
  ///
  /// In en, this message translates to:
  /// **'Scan with a camera to open this mini app'**
  String get miniAppsQrHint;

  /// No description provided for @miniAppsStatsTitle.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get miniAppsStatsTitle;

  /// Stats screen subtitle describing the selected range
  ///
  /// In en, this message translates to:
  /// **'{days, plural, one{last day} other{last {days} days}}'**
  String miniAppsStatsRangeDays(int days);

  /// Short range label for the stats range selector
  ///
  /// In en, this message translates to:
  /// **'{days}d'**
  String miniAppsStatsDaysShort(int days);

  /// No description provided for @miniAppsStatsLaunches.
  ///
  /// In en, this message translates to:
  /// **'Launches'**
  String get miniAppsStatsLaunches;

  /// No description provided for @miniAppsStatsUsers.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get miniAppsStatsUsers;

  /// No description provided for @miniAppsStatsRating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get miniAppsStatsRating;

  /// No description provided for @miniAppsStatsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No data yet'**
  String get miniAppsStatsEmpty;

  /// No description provided for @miniAppsStatsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Stats appear after the first launches'**
  String get miniAppsStatsEmptySubtitle;

  /// No description provided for @miniAppsRevTitle.
  ///
  /// In en, this message translates to:
  /// **'Version history'**
  String get miniAppsRevTitle;

  /// No description provided for @miniAppsRevSubtitle.
  ///
  /// In en, this message translates to:
  /// **'last 20 screen snapshots'**
  String get miniAppsRevSubtitle;

  /// No description provided for @miniAppsRevCurrent.
  ///
  /// In en, this message translates to:
  /// **'current'**
  String get miniAppsRevCurrent;

  /// No description provided for @miniAppsRevFirst.
  ///
  /// In en, this message translates to:
  /// **'first version'**
  String get miniAppsRevFirst;

  /// No description provided for @miniAppsRevNoChanges.
  ///
  /// In en, this message translates to:
  /// **'no screen changes'**
  String get miniAppsRevNoChanges;

  /// No description provided for @miniAppsRevEmpty.
  ///
  /// In en, this message translates to:
  /// **'No revisions yet'**
  String get miniAppsRevEmpty;

  /// No description provided for @miniAppsRevRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get miniAppsRevRestore;

  /// No description provided for @miniAppsTokensTitle.
  ///
  /// In en, this message translates to:
  /// **'Deploy tokens'**
  String get miniAppsTokensTitle;

  /// No description provided for @miniAppsTokensSubtitle.
  ///
  /// In en, this message translates to:
  /// **'for the deploy and push HTTP API'**
  String get miniAppsTokensSubtitle;

  /// No description provided for @miniAppsTokensBody.
  ///
  /// In en, this message translates to:
  /// **'Tokens let you deploy hosted screens from CI and send pushes via the HTTP API. The value is shown only once — store it safely.'**
  String get miniAppsTokensBody;

  /// No description provided for @miniAppsTokensFresh.
  ///
  /// In en, this message translates to:
  /// **'Copy now — it will not be shown again:'**
  String get miniAppsTokensFresh;

  /// No description provided for @miniAppsTokensCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy token'**
  String get miniAppsTokensCopy;

  /// No description provided for @miniAppsTokensCopied.
  ///
  /// In en, this message translates to:
  /// **'Token copied'**
  String get miniAppsTokensCopied;

  /// No description provided for @miniAppsTokensCreate.
  ///
  /// In en, this message translates to:
  /// **'Create token'**
  String get miniAppsTokensCreate;

  /// No description provided for @miniAppsTokensRevoke.
  ///
  /// In en, this message translates to:
  /// **'Revoke'**
  String get miniAppsTokensRevoke;

  /// No description provided for @miniAppsTokensLimit.
  ///
  /// In en, this message translates to:
  /// **'Token limit reached (5)'**
  String get miniAppsTokensLimit;

  /// No description provided for @miniAppsTokensNeverUsed.
  ///
  /// In en, this message translates to:
  /// **'never used'**
  String get miniAppsTokensNeverUsed;

  /// No description provided for @miniAppsTokensUsed.
  ///
  /// In en, this message translates to:
  /// **'in use'**
  String get miniAppsTokensUsed;

  /// No description provided for @miniAppsSecretTitle.
  ///
  /// In en, this message translates to:
  /// **'Signing secret'**
  String get miniAppsSecretTitle;

  /// No description provided for @miniAppsSecretSubtitle.
  ///
  /// In en, this message translates to:
  /// **'verify proxy requests on your server'**
  String get miniAppsSecretSubtitle;

  /// No description provided for @miniAppsSecretBody.
  ///
  /// In en, this message translates to:
  /// **'The proxy signs every request to your server with this secret (HMAC-SHA256). Verify it to be sure a request really came from Mirea Ninja. Shown once on generation — store it as NINJA_SECRET.'**
  String get miniAppsSecretBody;

  /// No description provided for @miniAppsSecretFresh.
  ///
  /// In en, this message translates to:
  /// **'Copy now — it will not be shown again:'**
  String get miniAppsSecretFresh;

  /// No description provided for @miniAppsSecretCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy secret'**
  String get miniAppsSecretCopy;

  /// No description provided for @miniAppsSecretCopied.
  ///
  /// In en, this message translates to:
  /// **'Secret copied'**
  String get miniAppsSecretCopied;

  /// No description provided for @miniAppsSecretGenerate.
  ///
  /// In en, this message translates to:
  /// **'Generate secret'**
  String get miniAppsSecretGenerate;

  /// No description provided for @miniAppsSecretRotate.
  ///
  /// In en, this message translates to:
  /// **'Rotate secret'**
  String get miniAppsSecretRotate;

  /// No description provided for @miniAppsSecretDisable.
  ///
  /// In en, this message translates to:
  /// **'Disable signing'**
  String get miniAppsSecretDisable;

  /// No description provided for @miniAppsSecretNone.
  ///
  /// In en, this message translates to:
  /// **'No secret yet'**
  String get miniAppsSecretNone;

  /// No description provided for @miniAppsSecretActive.
  ///
  /// In en, this message translates to:
  /// **'Active · {fingerprint}'**
  String miniAppsSecretActive(String fingerprint);

  /// No description provided for @miniAppsSecretPrevActive.
  ///
  /// In en, this message translates to:
  /// **'Previous secret still accepted'**
  String get miniAppsSecretPrevActive;

  /// No description provided for @miniAppsSecretRotateHint.
  ///
  /// In en, this message translates to:
  /// **'After rotating, the old secret keeps working for 24 h (sent as X-MireaNinja-Signature-Prev) — update your server within that window.'**
  String get miniAppsSecretRotateHint;

  /// No description provided for @miniAppsSecretFailure.
  ///
  /// In en, this message translates to:
  /// **'Could not update the secret'**
  String get miniAppsSecretFailure;

  /// No description provided for @miniAppsTplTitle.
  ///
  /// In en, this message translates to:
  /// **'Templates'**
  String get miniAppsTplTitle;

  /// No description provided for @miniAppsTplSubtitle.
  ///
  /// In en, this message translates to:
  /// **'ready multi-screen starters'**
  String get miniAppsTplSubtitle;

  /// No description provided for @miniAppsTplList.
  ///
  /// In en, this message translates to:
  /// **'List + details'**
  String get miniAppsTplList;

  /// No description provided for @miniAppsTplChecklist.
  ///
  /// In en, this message translates to:
  /// **'Checklist (storage)'**
  String get miniAppsTplChecklist;

  /// No description provided for @miniAppsTplPoll.
  ///
  /// In en, this message translates to:
  /// **'Poll'**
  String get miniAppsTplPoll;

  /// No description provided for @miniAppsTplReplaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Replace screens?'**
  String get miniAppsTplReplaceTitle;

  /// No description provided for @miniAppsTplReplaceBody.
  ///
  /// In en, this message translates to:
  /// **'The template will overwrite your current screen JSON.'**
  String get miniAppsTplReplaceBody;

  /// No description provided for @miniAppsSubmitUnknownTypes.
  ///
  /// In en, this message translates to:
  /// **'Warning, unknown types: {types}. They will render as empty widgets.'**
  String miniAppsSubmitUnknownTypes(String types);

  /// No description provided for @collabNotesTitle.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get collabNotesTitle;

  /// No description provided for @collabNotesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'shared group notes · autosave'**
  String get collabNotesSubtitle;

  /// No description provided for @collabNotesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get collabNotesEmptyTitle;

  /// No description provided for @collabNotesEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create the first note — the whole group can edit it'**
  String get collabNotesEmptySubtitle;

  /// No description provided for @collabNotesCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'New note'**
  String get collabNotesCreateTitle;

  /// No description provided for @collabNotesCreateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'the whole group will be able to edit it'**
  String get collabNotesCreateSubtitle;

  /// No description provided for @collabNotesUpdated.
  ///
  /// In en, this message translates to:
  /// **'updated {time}'**
  String collabNotesUpdated(String time);

  /// No description provided for @collabNotesUpdatedAutosave.
  ///
  /// In en, this message translates to:
  /// **'updated {time} · autosave'**
  String collabNotesUpdatedAutosave(String time);

  /// No description provided for @collabNotesTitleExampleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. “ML lecture 7”'**
  String get collabNotesTitleExampleHint;

  /// No description provided for @collabNotesCreating.
  ///
  /// In en, this message translates to:
  /// **'Creating…'**
  String get collabNotesCreating;

  /// No description provided for @collabNotesCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get collabNotesCreate;

  /// No description provided for @collabNotesTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get collabNotesTitleHint;

  /// No description provided for @collabNotesBodyHint.
  ///
  /// In en, this message translates to:
  /// **'Start writing the note…'**
  String get collabNotesBodyHint;

  /// No description provided for @collabNotesDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete note?'**
  String get collabNotesDeleteTitle;

  /// No description provided for @collabNotesDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'It will disappear for the whole group.'**
  String get collabNotesDeleteBody;

  /// No description provided for @collabNotesCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get collabNotesCancel;

  /// No description provided for @collabNotesDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get collabNotesDelete;

  /// No description provided for @collabNotesEditorHeader.
  ///
  /// In en, this message translates to:
  /// **'Note · {title}'**
  String collabNotesEditorHeader(String title);

  /// No description provided for @collabNotesPresenceSolo.
  ///
  /// In en, this message translates to:
  /// **'only you'**
  String get collabNotesPresenceSolo;

  /// No description provided for @collabNotesPresenceEditing.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} editing now} other{{count} editing now}}'**
  String collabNotesPresenceEditing(int count);

  /// No description provided for @collabNotesToolbarEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get collabNotesToolbarEdit;

  /// No description provided for @collabNotesToolbarSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get collabNotesToolbarSave;

  /// No description provided for @collabNotesNinja.
  ///
  /// In en, this message translates to:
  /// **'Ninja'**
  String get collabNotesNinja;

  /// No description provided for @collabNotesLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load notes'**
  String get collabNotesLoadError;

  /// No description provided for @collabNotesLoadErrorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again.'**
  String get collabNotesLoadErrorSubtitle;

  /// No description provided for @collabNotesRefreshError.
  ///
  /// In en, this message translates to:
  /// **'Could not refresh notes'**
  String get collabNotesRefreshError;

  /// No description provided for @collabNotesCreateError.
  ///
  /// In en, this message translates to:
  /// **'Could not create the note'**
  String get collabNotesCreateError;

  /// No description provided for @collabNotesSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get collabNotesSaving;

  /// No description provided for @collabNotesSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get collabNotesSaved;

  /// No description provided for @collabNotesUnsaved.
  ///
  /// In en, this message translates to:
  /// **'Unsaved changes'**
  String get collabNotesUnsaved;

  /// No description provided for @collabNotesSaveError.
  ///
  /// In en, this message translates to:
  /// **'Could not save the note. Your text is still here.'**
  String get collabNotesSaveError;

  /// No description provided for @collabNotesConflict.
  ///
  /// In en, this message translates to:
  /// **'This note changed elsewhere. Your text is still here.'**
  String get collabNotesConflict;

  /// No description provided for @collabNotesDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Could not delete the note'**
  String get collabNotesDeleteError;

  /// No description provided for @collabNotesDiscardTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave without saving?'**
  String get collabNotesDiscardTitle;

  /// No description provided for @collabNotesDiscardBody.
  ///
  /// In en, this message translates to:
  /// **'Your unsaved text will be lost.'**
  String get collabNotesDiscardBody;

  /// No description provided for @collabNotesStay.
  ///
  /// In en, this message translates to:
  /// **'Keep editing'**
  String get collabNotesStay;

  /// No description provided for @collabNotesDiscard.
  ///
  /// In en, this message translates to:
  /// **'Leave without saving'**
  String get collabNotesDiscard;

  /// No description provided for @eventsTitle.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get eventsTitle;

  /// No description provided for @eventsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'what\'s happening on campus'**
  String get eventsSubtitle;

  /// No description provided for @eventsCreateCta.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get eventsCreateCta;

  /// No description provided for @eventsFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get eventsFilterAll;

  /// No description provided for @eventsCategoryCareer.
  ///
  /// In en, this message translates to:
  /// **'Career'**
  String get eventsCategoryCareer;

  /// No description provided for @eventsCategorySport.
  ///
  /// In en, this message translates to:
  /// **'Sport'**
  String get eventsCategorySport;

  /// No description provided for @eventsCategoryArt.
  ///
  /// In en, this message translates to:
  /// **'Arts'**
  String get eventsCategoryArt;

  /// No description provided for @eventsCategorySci.
  ///
  /// In en, this message translates to:
  /// **'Science'**
  String get eventsCategorySci;

  /// No description provided for @eventsCategoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get eventsCategoryOther;

  /// No description provided for @eventsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get eventsEmptyTitle;

  /// No description provided for @eventsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create the first event — the board is shared across the whole university'**
  String get eventsEmptySubtitle;

  /// No description provided for @eventsSectionUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get eventsSectionUpcoming;

  /// No description provided for @eventsFeaturedTag.
  ///
  /// In en, this message translates to:
  /// **'Featured event'**
  String get eventsFeaturedTag;

  /// No description provided for @eventsGoingYes.
  ///
  /// In en, this message translates to:
  /// **'You\'re going'**
  String get eventsGoingYes;

  /// No description provided for @eventsGoingShort.
  ///
  /// In en, this message translates to:
  /// **'Going'**
  String get eventsGoingShort;

  /// No description provided for @eventsRsvp.
  ///
  /// In en, this message translates to:
  /// **'I\'ll go'**
  String get eventsRsvp;

  /// No description provided for @eventsCreateSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'New event'**
  String get eventsCreateSheetTitle;

  /// No description provided for @eventsCreateSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'everyone in the app will see it'**
  String get eventsCreateSheetSubtitle;

  /// No description provided for @eventsCreatePreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Event title'**
  String get eventsCreatePreviewTitle;

  /// No description provided for @eventsCreatePreviewHint.
  ///
  /// In en, this message translates to:
  /// **'this is how it appears on the board ↑'**
  String get eventsCreatePreviewHint;

  /// No description provided for @eventsCreateCoverLabel.
  ///
  /// In en, this message translates to:
  /// **'COVER'**
  String get eventsCreateCoverLabel;

  /// No description provided for @eventsCreateNameLabel.
  ///
  /// In en, this message translates to:
  /// **'TITLE'**
  String get eventsCreateNameLabel;

  /// No description provided for @eventsCreateNameHint.
  ///
  /// In en, this message translates to:
  /// **'Workshop: build your own app in one evening'**
  String get eventsCreateNameHint;

  /// No description provided for @eventsCreateCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'CATEGORY'**
  String get eventsCreateCategoryLabel;

  /// No description provided for @eventsCreateWhenLabel.
  ///
  /// In en, this message translates to:
  /// **'WHEN'**
  String get eventsCreateWhenLabel;

  /// No description provided for @eventsCreateWhereLabel.
  ///
  /// In en, this message translates to:
  /// **'WHERE'**
  String get eventsCreateWhereLabel;

  /// No description provided for @eventsCreatePlaceHint.
  ///
  /// In en, this message translates to:
  /// **'Room I-301'**
  String get eventsCreatePlaceHint;

  /// No description provided for @eventsCreateDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'What\'s on: agenda, speakers, who it\'s for…'**
  String get eventsCreateDescriptionHint;

  /// No description provided for @eventsCreating.
  ///
  /// In en, this message translates to:
  /// **'Creating…'**
  String get eventsCreating;

  /// No description provided for @eventsCreate.
  ///
  /// In en, this message translates to:
  /// **'Create event'**
  String get eventsCreate;

  /// No description provided for @eventsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load events'**
  String get eventsLoadError;

  /// No description provided for @eventsLoadErrorSub.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again'**
  String get eventsLoadErrorSub;

  /// No description provided for @eventsCreateError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t create the event. Please try again'**
  String get eventsCreateError;

  /// No description provided for @eventsRsvpError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t update your RSVP. Please try again'**
  String get eventsRsvpError;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeAuto.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get settingsThemeAuto;

  /// No description provided for @settingsAccent.
  ///
  /// In en, this message translates to:
  /// **'Institute accent'**
  String get settingsAccent;

  /// No description provided for @settingsAccentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'One color for buttons, navigation and active controls'**
  String get settingsAccentSubtitle;

  /// No description provided for @settingsAccentBlue.
  ///
  /// In en, this message translates to:
  /// **'Sky blue'**
  String get settingsAccentBlue;

  /// No description provided for @settingsAccentViolet.
  ///
  /// In en, this message translates to:
  /// **'Violet'**
  String get settingsAccentViolet;

  /// No description provided for @settingsAccentYellow.
  ///
  /// In en, this message translates to:
  /// **'Amber'**
  String get settingsAccentYellow;

  /// No description provided for @settingsAccentRed.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get settingsAccentRed;

  /// No description provided for @settingsAccentGreen.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get settingsAccentGreen;

  /// No description provided for @settingsLessonColors.
  ///
  /// In en, this message translates to:
  /// **'Lesson type colors'**
  String get settingsLessonColors;

  /// No description provided for @settingsLessonColorsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a restrained color that identifies this lesson type in the schedule'**
  String get settingsLessonColorsSubtitle;

  /// No description provided for @settingsLessonColorGreen.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get settingsLessonColorGreen;

  /// No description provided for @settingsLessonColorBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get settingsLessonColorBlue;

  /// No description provided for @settingsLessonColorViolet.
  ///
  /// In en, this message translates to:
  /// **'Violet'**
  String get settingsLessonColorViolet;

  /// No description provided for @settingsLessonColorAmber.
  ///
  /// In en, this message translates to:
  /// **'Amber'**
  String get settingsLessonColorAmber;

  /// No description provided for @settingsLessonColorRed.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get settingsLessonColorRed;

  /// No description provided for @settingsLessonColorGray.
  ///
  /// In en, this message translates to:
  /// **'Gray'**
  String get settingsLessonColorGray;

  /// No description provided for @settingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get settingsPrivacy;

  /// No description provided for @settingsWhoSeesProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile visibility'**
  String get settingsWhoSeesProfile;

  /// No description provided for @settingsWhoSeesProfileValue.
  ///
  /// In en, this message translates to:
  /// **'Group only'**
  String get settingsWhoSeesProfileValue;

  /// No description provided for @settingsAnonymousReactions.
  ///
  /// In en, this message translates to:
  /// **'Anonymous reactions'**
  String get settingsAnonymousReactions;

  /// No description provided for @settingsAnonymousReactionsValue.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get settingsAnonymousReactionsValue;

  /// No description provided for @settingsBiometricsPass.
  ///
  /// In en, this message translates to:
  /// **'Biometrics for the pass'**
  String get settingsBiometricsPass;

  /// No description provided for @settingsNfcEmulation.
  ///
  /// In en, this message translates to:
  /// **'NFC pass at the turnstile'**
  String get settingsNfcEmulation;

  /// No description provided for @settingsNfcEmulationSub.
  ///
  /// In en, this message translates to:
  /// **'Tap your phone to the turnstile. Turn off if another app handles it'**
  String get settingsNfcEmulationSub;

  /// No description provided for @settingsMyGroup.
  ///
  /// In en, this message translates to:
  /// **'My group'**
  String get settingsMyGroup;

  /// No description provided for @settingsSubgroup.
  ///
  /// In en, this message translates to:
  /// **'Subgroup'**
  String get settingsSubgroup;

  /// No description provided for @settingsSubgroupValue.
  ///
  /// In en, this message translates to:
  /// **'Subgroup 2'**
  String get settingsSubgroupValue;

  /// No description provided for @settingsWeekParity.
  ///
  /// In en, this message translates to:
  /// **'Week parity'**
  String get settingsWeekParity;

  /// No description provided for @settingsWeekParityValue.
  ///
  /// In en, this message translates to:
  /// **'auto by date'**
  String get settingsWeekParityValue;

  /// No description provided for @settingsHideElectives.
  ///
  /// In en, this message translates to:
  /// **'Hide electives'**
  String get settingsHideElectives;

  /// No description provided for @settingsHomeAndWidgets.
  ///
  /// In en, this message translates to:
  /// **'Home and widgets'**
  String get settingsHomeAndWidgets;

  /// No description provided for @settingsDataAndLanguage.
  ///
  /// In en, this message translates to:
  /// **'Data and language'**
  String get settingsDataAndLanguage;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageValue.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get settingsLanguageValue;

  /// No description provided for @settingsSync.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get settingsSync;

  /// No description provided for @settingsSyncValue.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi + network'**
  String get settingsSyncValue;

  /// No description provided for @settingsClearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear cache'**
  String get settingsClearCache;

  /// No description provided for @settingsClearCacheValue.
  ///
  /// In en, this message translates to:
  /// **'48 MB'**
  String get settingsClearCacheValue;

  /// No description provided for @settingsCacheCleared.
  ///
  /// In en, this message translates to:
  /// **'Cache cleared'**
  String get settingsCacheCleared;

  /// No description provided for @settingsExportSchedule.
  ///
  /// In en, this message translates to:
  /// **'Export schedule'**
  String get settingsExportSchedule;

  /// No description provided for @settingsExportScheduleValue.
  ///
  /// In en, this message translates to:
  /// **'.ics calendar'**
  String get settingsExportScheduleValue;

  /// No description provided for @settingsExportScheduleHint.
  ///
  /// In en, this message translates to:
  /// **'Open it on the Classes screen'**
  String get settingsExportScheduleHint;

  /// No description provided for @settingsManageAccount.
  ///
  /// In en, this message translates to:
  /// **'Manage account'**
  String get settingsManageAccount;

  /// No description provided for @settingsLessonReactions.
  ///
  /// In en, this message translates to:
  /// **'Lesson reactions'**
  String get settingsLessonReactions;

  /// No description provided for @settingsVisibilityEveryone.
  ///
  /// In en, this message translates to:
  /// **'Everyone'**
  String get settingsVisibilityEveryone;

  /// No description provided for @settingsVisibilityGroup.
  ///
  /// In en, this message translates to:
  /// **'Group only'**
  String get settingsVisibilityGroup;

  /// No description provided for @settingsVisibilityNobody.
  ///
  /// In en, this message translates to:
  /// **'Nobody'**
  String get settingsVisibilityNobody;

  /// No description provided for @settingsVisibilitySheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose who can find you in search and suggestions.'**
  String get settingsVisibilitySheetSubtitle;

  /// No description provided for @biometricFaceId.
  ///
  /// In en, this message translates to:
  /// **'Face ID'**
  String get biometricFaceId;

  /// No description provided for @biometricFingerprint.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint'**
  String get biometricFingerprint;

  /// No description provided for @biometricUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get biometricUnavailable;

  /// No description provided for @biometricOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get biometricOff;

  /// No description provided for @passLockTitle.
  ///
  /// In en, this message translates to:
  /// **'Pass locked'**
  String get passLockTitle;

  /// No description provided for @passLockSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm it\'s you to show the pass.'**
  String get passLockSubtitle;

  /// No description provided for @passLockReason.
  ///
  /// In en, this message translates to:
  /// **'Confirm it\'s you to open the pass'**
  String get passLockReason;

  /// No description provided for @passUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get passUnlock;

  /// No description provided for @settingsHomeContentTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s on home'**
  String get settingsHomeContentTitle;

  /// No description provided for @settingsHomeContentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show or hide home sections.'**
  String get settingsHomeContentSubtitle;

  /// No description provided for @homeSectionSmartChips.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get homeSectionSmartChips;

  /// No description provided for @homeSectionDeadlines.
  ///
  /// In en, this message translates to:
  /// **'Deadlines'**
  String get homeSectionDeadlines;

  /// No description provided for @homeSectionToday.
  ///
  /// In en, this message translates to:
  /// **'Today\'s schedule'**
  String get homeSectionToday;

  /// No description provided for @homeSectionTrending.
  ///
  /// In en, this message translates to:
  /// **'Discussions'**
  String get homeSectionTrending;

  /// No description provided for @settingsWidgetSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The schedule widget shows your active schedule and the current class. Add it from the home screen.'**
  String get settingsWidgetSheetSubtitle;

  /// No description provided for @settingsWidgetRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh widget'**
  String get settingsWidgetRefresh;

  /// No description provided for @settingsWidgetRefreshed.
  ///
  /// In en, this message translates to:
  /// **'Widget updated'**
  String get settingsWidgetRefreshed;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsLanguageSystem;

  /// No description provided for @settingsLanguageRu.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get settingsLanguageRu;

  /// No description provided for @settingsLanguageEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEn;

  /// No description provided for @settingsSupportEyebrow.
  ///
  /// In en, this message translates to:
  /// **'OPEN-SOURCE'**
  String get settingsSupportEyebrow;

  /// No description provided for @settingsSupportTitle.
  ///
  /// In en, this message translates to:
  /// **'Support the project'**
  String get settingsSupportTitle;

  /// No description provided for @settingsSupportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Mirea Ninja is built by students. Star it on GitHub or send a PR.'**
  String get settingsSupportSubtitle;

  /// No description provided for @settingsSupportCta.
  ///
  /// In en, this message translates to:
  /// **'Open GitHub'**
  String get settingsSupportCta;

  /// No description provided for @accountEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get accountEmailLabel;

  /// No description provided for @accountGuest.
  ///
  /// In en, this message translates to:
  /// **'Guest account'**
  String get accountGuest;

  /// No description provided for @accountChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get accountChangePassword;

  /// No description provided for @accountChangePasswordSub.
  ///
  /// In en, this message translates to:
  /// **'We\'ll email a reset code'**
  String get accountChangePasswordSub;

  /// No description provided for @accountResetSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent'**
  String get accountResetSent;

  /// No description provided for @accountResetError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t send the email. Try again.'**
  String get accountResetError;

  /// No description provided for @accountDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get accountDelete;

  /// No description provided for @accountDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account?'**
  String get accountDeleteConfirmTitle;

  /// No description provided for @accountDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes your account and data. This can\'t be undone.'**
  String get accountDeleteConfirmBody;

  /// No description provided for @accountDeleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get accountDeleteAction;

  /// No description provided for @accountDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t delete the account. Try again.'**
  String get accountDeleteError;

  /// No description provided for @settingsSyncAlways.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi + mobile'**
  String get settingsSyncAlways;

  /// No description provided for @settingsSyncWifiOnly.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi only'**
  String get settingsSyncWifiOnly;

  /// No description provided for @settingsSyncManual.
  ///
  /// In en, this message translates to:
  /// **'Manual only'**
  String get settingsSyncManual;

  /// No description provided for @settingsSyncSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'When the schedule may refresh over the network.'**
  String get settingsSyncSheetSubtitle;

  /// No description provided for @settingsFooter.
  ///
  /// In en, this message translates to:
  /// **'Mirea Ninja · made with in Moscow'**
  String get settingsFooter;

  /// No description provided for @settingsNotifyClasses.
  ///
  /// In en, this message translates to:
  /// **'Class reminders'**
  String get settingsNotifyClasses;

  /// No description provided for @settingsNotifyClassesSub.
  ///
  /// In en, this message translates to:
  /// **'15 min before'**
  String get settingsNotifyClassesSub;

  /// No description provided for @settingsNotifyScheduleChanges.
  ///
  /// In en, this message translates to:
  /// **'Schedule changes'**
  String get settingsNotifyScheduleChanges;

  /// No description provided for @settingsNotifyScheduleChangesSub.
  ///
  /// In en, this message translates to:
  /// **'instantly'**
  String get settingsNotifyScheduleChangesSub;

  /// No description provided for @settingsNotifyReactions.
  ///
  /// In en, this message translates to:
  /// **'Reactions and replies'**
  String get settingsNotifyReactions;

  /// No description provided for @settingsNotifyReactionsSub.
  ///
  /// In en, this message translates to:
  /// **'quiet hours 22:00 → 8:00'**
  String get settingsNotifyReactionsSub;

  /// No description provided for @settingsNotifyUniversityNews.
  ///
  /// In en, this message translates to:
  /// **'University news'**
  String get settingsNotifyUniversityNews;

  /// No description provided for @settingsNotifyUniversityNewsSub.
  ///
  /// In en, this message translates to:
  /// **'morning digest'**
  String get settingsNotifyUniversityNewsSub;

  /// No description provided for @settingsNotifyCommunityEvents.
  ///
  /// In en, this message translates to:
  /// **'Community events'**
  String get settingsNotifyCommunityEvents;

  /// No description provided for @settingsHomeContent.
  ///
  /// In en, this message translates to:
  /// **'What\'s on home'**
  String get settingsHomeContent;

  /// No description provided for @settingsQuickServices.
  ///
  /// In en, this message translates to:
  /// **'Quick services'**
  String get settingsQuickServices;

  /// No description provided for @settingsQuickServicesValue.
  ///
  /// In en, this message translates to:
  /// **'Pinned: {count}'**
  String settingsQuickServicesValue(int count);

  /// No description provided for @settingsHomeContentAll.
  ///
  /// In en, this message translates to:
  /// **'all sections'**
  String get settingsHomeContentAll;

  /// No description provided for @settingsHomeContentNone.
  ///
  /// In en, this message translates to:
  /// **'nothing'**
  String get settingsHomeContentNone;

  /// No description provided for @settingsScreenWidgets.
  ///
  /// In en, this message translates to:
  /// **'Screen widgets'**
  String get settingsScreenWidgets;

  /// No description provided for @settingsNotificationsOn.
  ///
  /// In en, this message translates to:
  /// **'on'**
  String get settingsNotificationsOn;

  /// No description provided for @settingsNotificationsOff.
  ///
  /// In en, this message translates to:
  /// **'off'**
  String get settingsNotificationsOff;

  /// No description provided for @settingsNinjaMascot.
  ///
  /// In en, this message translates to:
  /// **'Ninja mascot'**
  String get settingsNinjaMascot;

  /// No description provided for @settingsCompactMode.
  ///
  /// In en, this message translates to:
  /// **'Compact mode'**
  String get settingsCompactMode;

  /// No description provided for @settingsProBanner.
  ///
  /// In en, this message translates to:
  /// **'NINJA PRO'**
  String get settingsProBanner;

  /// No description provided for @settingsProTitle.
  ///
  /// In en, this message translates to:
  /// **'Themes and no ads'**
  String get settingsProTitle;

  /// No description provided for @settingsProPrice.
  ///
  /// In en, this message translates to:
  /// **'149₽/mo · first month free for students'**
  String get settingsProPrice;

  /// No description provided for @settingsProTry.
  ///
  /// In en, this message translates to:
  /// **'Try it'**
  String get settingsProTry;

  /// No description provided for @settingsAboutVersion.
  ///
  /// In en, this message translates to:
  /// **'v {version} · open-source'**
  String settingsAboutVersion(String version);

  /// No description provided for @settingsAboutDescription.
  ///
  /// In en, this message translates to:
  /// **'Made by students for students. PRs welcome'**
  String get settingsAboutDescription;

  /// No description provided for @settingsNotificationsPushTitle.
  ///
  /// In en, this message translates to:
  /// **'Push notifications'**
  String get settingsNotificationsPushTitle;

  /// No description provided for @settingsNotificationsPushSub.
  ///
  /// In en, this message translates to:
  /// **'All notifications from the app'**
  String get settingsNotificationsPushSub;

  /// No description provided for @settingsNotificationsScheduleSection.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get settingsNotificationsScheduleSection;

  /// No description provided for @settingsNotificationsScheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Schedule changes'**
  String get settingsNotificationsScheduleTitle;

  /// No description provided for @settingsNotificationsScheduleSub.
  ///
  /// In en, this message translates to:
  /// **'Cancellation, reschedule, room change'**
  String get settingsNotificationsScheduleSub;

  /// No description provided for @settingsNotificationsGamificationSection.
  ///
  /// In en, this message translates to:
  /// **'Gamification'**
  String get settingsNotificationsGamificationSection;

  /// No description provided for @settingsNotificationsQuestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Quest reminders'**
  String get settingsNotificationsQuestsTitle;

  /// No description provided for @settingsNotificationsQuestsSub.
  ///
  /// In en, this message translates to:
  /// **'Daily quests by midnight'**
  String get settingsNotificationsQuestsSub;

  /// No description provided for @settingsNotificationsAchievementsTitle.
  ///
  /// In en, this message translates to:
  /// **'New achievements'**
  String get settingsNotificationsAchievementsTitle;

  /// No description provided for @settingsNotificationsAchievementsSub.
  ///
  /// In en, this message translates to:
  /// **'When a badge unlocks'**
  String get settingsNotificationsAchievementsSub;

  /// No description provided for @settingsNotificationsLeaderboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard updates'**
  String get settingsNotificationsLeaderboardTitle;

  /// No description provided for @settingsNotificationsLeaderboardSub.
  ///
  /// In en, this message translates to:
  /// **'Who overtook you on the leaderboard'**
  String get settingsNotificationsLeaderboardSub;

  /// No description provided for @settingsNfcTitle.
  ///
  /// In en, this message translates to:
  /// **'NFC pass setup'**
  String get settingsNfcTitle;

  /// No description provided for @settingsNfcDescription.
  ///
  /// In en, this message translates to:
  /// **'Personalize the look of your pass by choosing an image or video for the background'**
  String get settingsNfcDescription;

  /// No description provided for @settingsScheduleManageTooltip.
  ///
  /// In en, this message translates to:
  /// **'Manage schedule'**
  String get settingsScheduleManageTooltip;

  /// Hint shown on the NFC pass card
  ///
  /// In en, this message translates to:
  /// **'Hold your phone\nto the turnstile'**
  String get nfcPassTapHint;

  /// Status pill on the active NFC pass card
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get nfcPassActiveStatus;

  /// ID field label on the NFC pass card
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get nfcPassIdLabel;

  /// Device field label on the NFC pass card
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get nfcPassDeviceLabel;

  /// Title of the empty NFC pass state
  ///
  /// In en, this message translates to:
  /// **'Pass not connected'**
  String get nfcPassNotConnectedTitle;

  /// Description of the empty NFC pass state
  ///
  /// In en, this message translates to:
  /// **'Connect your NFC pass to walk through MIREA turnstiles with your phone.'**
  String get nfcPassNotConnectedDescription;

  /// Primary button that starts NFC pass binding
  ///
  /// In en, this message translates to:
  /// **'Connect pass'**
  String get nfcPassConnectButton;

  /// Button that unbinds the NFC pass
  ///
  /// In en, this message translates to:
  /// **'Unbind device'**
  String get nfcPassUnbindButton;

  /// Title of the unbind confirmation sheet
  ///
  /// In en, this message translates to:
  /// **'Unbind the pass?'**
  String get nfcPassUnbindConfirmTitle;

  /// Body of the unbind confirmation sheet
  ///
  /// In en, this message translates to:
  /// **'The pass will stop working on this device. You can connect it again at any time.'**
  String get nfcPassUnbindConfirmDescription;

  /// Title of the verification code sheet
  ///
  /// In en, this message translates to:
  /// **'Code from the email'**
  String get nfcPassCodeSheetTitle;

  /// Description of the verification code sheet
  ///
  /// In en, this message translates to:
  /// **'The attendance service sent a code to the email linked to your student account. Enter it below.'**
  String get nfcPassCodeSheetDescription;

  /// Title shown while waiting for the verification code
  ///
  /// In en, this message translates to:
  /// **'Check your email'**
  String get nfcPassCheckEmailTitle;

  /// Description shown while waiting for the verification code
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a confirmation code to your student account email. Enter it to bind the pass.'**
  String get nfcPassCheckEmailDescription;

  /// Button that reopens the verification code sheet
  ///
  /// In en, this message translates to:
  /// **'Enter code'**
  String get nfcPassEnterCodeButton;

  /// Title of the NFC pass error state
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get nfcPassErrorTitle;

  /// Description of the NFC pass error state
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load your pass. Check your connection and try again.'**
  String get nfcPassErrorDescription;

  /// Title of the NFC pass onboarding steps
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get nfcPassHowItWorksTitle;

  /// First NFC pass onboarding step
  ///
  /// In en, this message translates to:
  /// **'Connect the pass through the attendance journal'**
  String get nfcPassStep1;

  /// Second NFC pass onboarding step
  ///
  /// In en, this message translates to:
  /// **'Confirm the binding with the code from the email'**
  String get nfcPassStep2;

  /// Third NFC pass onboarding step
  ///
  /// In en, this message translates to:
  /// **'Hold the phone to the turnstile like a regular pass'**
  String get nfcPassStep3;

  /// Title of the media picker in NFC pass settings
  ///
  /// In en, this message translates to:
  /// **'Background media'**
  String get nfcPassMediaTitle;

  /// Description of the media picker in NFC pass settings
  ///
  /// In en, this message translates to:
  /// **'Choose an image or video for the pass card background'**
  String get nfcPassMediaDescription;

  /// Button to pick background media
  ///
  /// In en, this message translates to:
  /// **'Choose'**
  String get nfcPassMediaSelect;

  /// Button to change background media
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get nfcPassMediaChange;

  /// Button to remove background media
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get nfcPassMediaRemove;

  /// Title of the card preview in NFC pass settings
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get nfcPassPreviewTitle;

  /// Caption on the image preview
  ///
  /// In en, this message translates to:
  /// **'Card with an image'**
  String get nfcPassPreviewImageHint;

  /// Caption on the video preview
  ///
  /// In en, this message translates to:
  /// **'Card with a video'**
  String get nfcPassPreviewVideoHint;

  /// Caption on the default background preview
  ///
  /// In en, this message translates to:
  /// **'Default background'**
  String get nfcPassDefaultBackground;

  /// Title of the pass details block in NFC pass settings
  ///
  /// In en, this message translates to:
  /// **'Pass details'**
  String get nfcPassInfoTitle;

  /// Pass ID field label in pass details
  ///
  /// In en, this message translates to:
  /// **'Pass ID'**
  String get nfcPassIdField;

  /// Status field label in pass details
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get nfcPassStatusField;

  /// Polls screen title
  ///
  /// In en, this message translates to:
  /// **'Polls'**
  String get pollsTitle;

  /// Polls header subtitle with the poll count
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{vote on what matters · {count} poll} other{vote on what matters · {count} polls}}'**
  String pollsSubtitle(int count);

  /// Polls tile title on the services screen
  ///
  /// In en, this message translates to:
  /// **'Polls'**
  String get pollsServiceTitle;

  /// Label of the create-poll button
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get pollsCreate;

  /// Label of the create-poll button while saving
  ///
  /// In en, this message translates to:
  /// **'Creating…'**
  String get pollsCreating;

  /// Title of the poll creator screen / sheet
  ///
  /// In en, this message translates to:
  /// **'New poll'**
  String get pollsCreateTitle;

  /// Cancel action in the poll creator
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get pollsCancel;

  /// Poll type: one option only
  ///
  /// In en, this message translates to:
  /// **'Single'**
  String get pollsTypeSingle;

  /// Poll type: several options allowed
  ///
  /// In en, this message translates to:
  /// **'Multiple'**
  String get pollsTypeMultiple;

  /// Poll type: quiz with a correct answer
  ///
  /// In en, this message translates to:
  /// **'Quiz'**
  String get pollsTypeQuiz;

  /// Hint of the poll question field
  ///
  /// In en, this message translates to:
  /// **'Ask a question…'**
  String get pollsQuestionHint;

  /// Section label above the poll options list
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get pollsOptionsLabel;

  /// Hint of a poll option field
  ///
  /// In en, this message translates to:
  /// **'Option {number}'**
  String pollsOptionHint(int number);

  /// Label of the add-option button in the creator
  ///
  /// In en, this message translates to:
  /// **'Add option'**
  String get pollsAddOption;

  /// Tooltip of the remove-option button in the creator
  ///
  /// In en, this message translates to:
  /// **'Remove option'**
  String get pollsRemoveOption;

  /// Settings section label in the poll creator
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get pollsSettings;

  /// Anonymous poll toggle title
  ///
  /// In en, this message translates to:
  /// **'Anonymous poll'**
  String get pollsAnonymous;

  /// Anonymous poll toggle subtitle
  ///
  /// In en, this message translates to:
  /// **'no one sees who voted how'**
  String get pollsAnonymousSub;

  /// Show-results toggle title
  ///
  /// In en, this message translates to:
  /// **'Show results right away'**
  String get pollsShowResults;

  /// Poll expiry section label
  ///
  /// In en, this message translates to:
  /// **'Ends in'**
  String get pollsExpiry;

  /// Poll expiry option: no deadline
  ///
  /// In en, this message translates to:
  /// **'No limit'**
  String get pollsExpiryNone;

  /// Poll expiry option: 24 hours
  ///
  /// In en, this message translates to:
  /// **'24 hours'**
  String get pollsExpiry24h;

  /// Poll expiry option: 3 days
  ///
  /// In en, this message translates to:
  /// **'3 days'**
  String get pollsExpiry3d;

  /// Poll expiry option: 7 days
  ///
  /// In en, this message translates to:
  /// **'7 days'**
  String get pollsExpiry7d;

  /// Label of the vote button on a multi-choice poll
  ///
  /// In en, this message translates to:
  /// **'Vote'**
  String get pollsVote;

  /// Total vote count of a poll
  ///
  /// In en, this message translates to:
  /// **'{count, plural, zero{No votes} one{{count} vote} other{{count} votes}}'**
  String pollsVotesCount(int count);

  /// Share of votes an option holds, as a percentage
  ///
  /// In en, this message translates to:
  /// **'{percent}%'**
  String pollsSharePercent(int percent);

  /// Tag shown on a finished poll
  ///
  /// In en, this message translates to:
  /// **'ended'**
  String get pollsTagEnded;

  /// Tag shown on an anonymous poll
  ///
  /// In en, this message translates to:
  /// **'anonymous'**
  String get pollsTagAnonymous;

  /// Tag shown on a quiz poll
  ///
  /// In en, this message translates to:
  /// **'quiz'**
  String get pollsTagQuiz;

  /// Polls empty state title
  ///
  /// In en, this message translates to:
  /// **'No polls yet'**
  String get pollsEmptyTitle;

  /// Polls empty state subtitle
  ///
  /// In en, this message translates to:
  /// **'Be the first to ask the community a question.'**
  String get pollsEmptySub;

  /// Title of the delete-poll confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Delete poll?'**
  String get pollsDeleteConfirmTitle;

  /// Body of the delete-poll confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'This poll and all its votes will be removed.'**
  String get pollsDeleteConfirmBody;

  /// Confirm action in the delete-poll dialog
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get pollsDelete;

  /// Cancel action in the delete-poll dialog
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get pollsDeleteCancel;

  /// Title of the schedules hub (the saved-schedules manager)
  ///
  /// In en, this message translates to:
  /// **'Schedules'**
  String get schedulesTitle;

  /// Uppercase section label above the active schedule on the hub
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get scheduleHubPrimarySection;

  /// Hub section header for saved group schedules
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get scheduleHubGroupsSection;

  /// Hub section header for saved teacher schedules
  ///
  /// In en, this message translates to:
  /// **'Teachers'**
  String get scheduleHubTeachersSection;

  /// Hub section header for saved classroom schedules
  ///
  /// In en, this message translates to:
  /// **'Classrooms'**
  String get scheduleHubClassroomsSection;

  /// Badge on the primary card marking the user's active schedule
  ///
  /// In en, this message translates to:
  /// **'MINE'**
  String get scheduleHubMineBadge;

  /// Live badge on a schedule card when a lesson is in progress
  ///
  /// In en, this message translates to:
  /// **'class now'**
  String get scheduleHubLiveLesson;

  /// Primary card headline for the lesson in progress
  ///
  /// In en, this message translates to:
  /// **'Now: {subject}'**
  String scheduleHubNowSubject(String subject);

  /// Meta showing when the current lesson ends
  ///
  /// In en, this message translates to:
  /// **'until {time}'**
  String scheduleHubLessonUntil(String time);

  /// Minutes remaining until the current lesson ends
  ///
  /// In en, this message translates to:
  /// **'{minutes} min left'**
  String scheduleHubRemaining(int minutes);

  /// Primary card headline for the next upcoming lesson today
  ///
  /// In en, this message translates to:
  /// **'Next: {subject}'**
  String scheduleHubNextSubject(String subject);

  /// Meta showing when the next lesson starts
  ///
  /// In en, this message translates to:
  /// **'at {time}'**
  String scheduleHubNextAt(String time);

  /// Primary card line when there are no lessons left today
  ///
  /// In en, this message translates to:
  /// **'No classes today'**
  String get scheduleHubNoLessonsToday;

  /// Secondary line on a schedule card with today's lesson count
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{day off today} =1{{count} class today} other{{count} classes today}}'**
  String scheduleHubLessonsToday(int count);

  /// Last-synced line on a schedule card; time is a relative phrase
  ///
  /// In en, this message translates to:
  /// **'updated {time}'**
  String scheduleHubUpdatedAgo(String time);

  /// Compact updated-chip: synced just now
  ///
  /// In en, this message translates to:
  /// **'now'**
  String get scheduleHubAgoNow;

  /// Compact updated-chip in minutes
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String scheduleHubAgoMinutes(int minutes);

  /// Compact updated-chip in hours
  ///
  /// In en, this message translates to:
  /// **'{hours} h'**
  String scheduleHubAgoHours(int hours);

  /// Compact updated-chip in days
  ///
  /// In en, this message translates to:
  /// **'{days} d'**
  String scheduleHubAgoDays(int days);

  /// Empty-state title on the schedules hub
  ///
  /// In en, this message translates to:
  /// **'No schedules yet'**
  String get scheduleHubEmptyTitle;

  /// Empty-state subtitle on the schedules hub
  ///
  /// In en, this message translates to:
  /// **'Add a group, teacher or classroom to see its schedule'**
  String get scheduleHubEmptySubtitle;

  /// Schedule quick-actions row that opens the schedules hub
  ///
  /// In en, this message translates to:
  /// **'All schedules'**
  String get scheduleHubAllSchedules;

  /// Subtitle for the all-schedules quick-action row
  ///
  /// In en, this message translates to:
  /// **'Switch, add or reorder'**
  String get scheduleHubAllSchedulesSubtitle;

  /// Toast after unsubscribing from a saved schedule
  ///
  /// In en, this message translates to:
  /// **'Schedule removed'**
  String get scheduleRemovedToast;

  /// Title of the add-schedule screen
  ///
  /// In en, this message translates to:
  /// **'Add schedule'**
  String get addScheduleTitle;

  /// Add-schedule tab: search by group
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get addScheduleTabGroup;

  /// Add-schedule tab: search by teacher (shortened)
  ///
  /// In en, this message translates to:
  /// **'Teacher'**
  String get addScheduleTabTeacher;

  /// Add-schedule tab: search by classroom
  ///
  /// In en, this message translates to:
  /// **'Classroom'**
  String get addScheduleTabClassroom;

  /// Search-field hint when adding a group schedule
  ///
  /// In en, this message translates to:
  /// **'Group number, e.g. ИКБО-09-22'**
  String get addScheduleSearchGroupHint;

  /// Search-field hint when adding a teacher schedule
  ///
  /// In en, this message translates to:
  /// **'Teacher last name'**
  String get addScheduleSearchTeacherHint;

  /// Search-field hint when adding a classroom schedule
  ///
  /// In en, this message translates to:
  /// **'Classroom, e.g. А-220'**
  String get addScheduleSearchClassroomHint;

  /// Uppercase results-count label on the add-schedule screen
  ///
  /// In en, this message translates to:
  /// **'Found · {count}'**
  String addScheduleFound(int count);

  /// Trailing chip on a result already in the user's saved list
  ///
  /// In en, this message translates to:
  /// **'added'**
  String get addScheduleAdded;

  /// Trailing button that subscribes to a search result
  ///
  /// In en, this message translates to:
  /// **'add'**
  String get addScheduleAddAction;

  /// Footer CTA on the add-schedule screen
  ///
  /// In en, this message translates to:
  /// **'Create your own from scratch'**
  String get addScheduleCreateTitle;

  /// Footer CTA subtitle on the add-schedule screen
  ///
  /// In en, this message translates to:
  /// **'no group, teacher or classroom needed'**
  String get addScheduleCreateSubtitle;

  /// Lead-in before the create-from-scratch CTA
  ///
  /// In en, this message translates to:
  /// **'Didn\'t find it?'**
  String get addScheduleNotFound;

  /// Zero state on the add-schedule screen
  ///
  /// In en, this message translates to:
  /// **'Start typing to search'**
  String get addScheduleStartTyping;

  /// Empty results state on the add-schedule screen
  ///
  /// In en, this message translates to:
  /// **'Nothing found'**
  String get addScheduleNoResults;

  /// Title of the reorder/unsubscribe edit screen
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editSchedulesTitle;

  /// Helper hint at the top of the edit screen
  ///
  /// In en, this message translates to:
  /// **'Drag to reorder · tap minus to unsubscribe'**
  String get editSchedulesHint;

  /// Study group management screen title
  ///
  /// In en, this message translates to:
  /// **'My group'**
  String get studyGroupTitle;

  /// Member count label
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{no members} =1{1 member} other{{count} members}}'**
  String studyGroupMembersCount(int count);

  /// Empty state title when the user has no study group
  ///
  /// In en, this message translates to:
  /// **'You\'re not in a group yet'**
  String get studyGroupNoGroupTitle;

  /// Empty state subtitle when the user has no study group
  ///
  /// In en, this message translates to:
  /// **'Create a study group or join an existing one to unlock the group space.'**
  String get studyGroupNoGroupSubtitle;

  /// CTA to create a study group
  ///
  /// In en, this message translates to:
  /// **'Create a group'**
  String get studyGroupCreateCta;

  /// CTA to join a group by code
  ///
  /// In en, this message translates to:
  /// **'Join by code'**
  String get studyGroupJoinByCodeCta;

  /// CTA to open the group catalog
  ///
  /// In en, this message translates to:
  /// **'Find a group'**
  String get studyGroupDiscoverCta;

  /// Entry to the group management screen
  ///
  /// In en, this message translates to:
  /// **'Manage group'**
  String get studyGroupManage;

  /// Section label for incoming invites
  ///
  /// In en, this message translates to:
  /// **'Invitations'**
  String get studyGroupInvitesSection;

  /// Accept an incoming group invite
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get studyGroupInviteJoin;

  /// Decline an incoming group invite
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get studyGroupInviteDismiss;

  /// Members section label
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get studyGroupMembersSection;

  /// Tag for the group owner
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get studyGroupOwnerTag;

  /// Tag for the current user
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get studyGroupYouTag;

  /// Catalog subtitle showing the owner's first name
  ///
  /// In en, this message translates to:
  /// **'owner {name}'**
  String studyGroupOwnerName(String name);

  /// Accept a join request
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get studyGroupAccept;

  /// Decline a join request
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get studyGroupDecline;

  /// Remove a member
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get studyGroupRemove;

  /// Remove member confirm title
  ///
  /// In en, this message translates to:
  /// **'Remove member?'**
  String get studyGroupRemoveMemberTitle;

  /// Remove member confirm body
  ///
  /// In en, this message translates to:
  /// **'{name} will lose access to the group space.'**
  String studyGroupRemoveMemberBody(String name);

  /// Pending join requests section label
  ///
  /// In en, this message translates to:
  /// **'Join requests ({count})'**
  String studyGroupRequestsSection(int count);

  /// Open the invite sheet
  ///
  /// In en, this message translates to:
  /// **'Invite to the group'**
  String get studyGroupInviteAction;

  /// Invite sheet title
  ///
  /// In en, this message translates to:
  /// **'Invite to the group'**
  String get studyGroupInviteTitle;

  /// Invite sheet subtitle
  ///
  /// In en, this message translates to:
  /// **'Find a student by name or @handle'**
  String get studyGroupInviteSubtitle;

  /// Invite search hint
  ///
  /// In en, this message translates to:
  /// **'Name or @handle'**
  String get studyGroupInviteSearchHint;

  /// Invite button on a search row
  ///
  /// In en, this message translates to:
  /// **'Invite'**
  String get studyGroupInviteSend;

  /// Invited tag on a search row
  ///
  /// In en, this message translates to:
  /// **'Invited'**
  String get studyGroupInviteSent;

  /// Invite failure toast
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t invite. They may already be in a group.'**
  String get studyGroupInviteError;

  /// Invite search empty title
  ///
  /// In en, this message translates to:
  /// **'No one found'**
  String get studyGroupInviteNoneFound;

  /// Invite search empty subtitle
  ///
  /// In en, this message translates to:
  /// **'Try another name or @handle'**
  String get studyGroupInviteNoneFoundSub;

  /// Hint above the share code
  ///
  /// In en, this message translates to:
  /// **'Or share the code or invite link'**
  String get studyGroupInviteByLink;

  /// Label for the share code
  ///
  /// In en, this message translates to:
  /// **'Group code'**
  String get studyGroupShareCode;

  /// Share message for the invite link
  ///
  /// In en, this message translates to:
  /// **'Join the group «{name}» in Mirea Ninja. Code: {code}\n{link}'**
  String studyGroupShareCodeText(String name, String code, String link);

  /// Toast after copying the code
  ///
  /// In en, this message translates to:
  /// **'Code copied'**
  String get studyGroupCodeCopied;

  /// Create sheet title
  ///
  /// In en, this message translates to:
  /// **'New study group'**
  String get studyGroupCreateTitle;

  /// Create sheet subtitle
  ///
  /// In en, this message translates to:
  /// **'You\'ll be the owner. One person — one group.'**
  String get studyGroupCreateSubtitle;

  /// Create group button
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get studyGroupCreateButton;

  /// Create group button while saving
  ///
  /// In en, this message translates to:
  /// **'Creating…'**
  String get studyGroupCreating;

  /// Create failure toast
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t create the group'**
  String get studyGroupCreateError;

  /// Group name field hint
  ///
  /// In en, this message translates to:
  /// **'Name, e.g. IKBO-09-22'**
  String get studyGroupNameHint;

  /// Group description field hint
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get studyGroupDescriptionHint;

  /// Discoverable toggle label
  ///
  /// In en, this message translates to:
  /// **'Show in the catalog (others can request to join)'**
  String get studyGroupDiscoverableLabel;

  /// Join-by-code sheet title
  ///
  /// In en, this message translates to:
  /// **'Join by code'**
  String get studyGroupJoinTitle;

  /// Join-by-code sheet subtitle
  ///
  /// In en, this message translates to:
  /// **'Enter the invite code the group owner shared'**
  String get studyGroupJoinSubtitle;

  /// Join code field hint
  ///
  /// In en, this message translates to:
  /// **'Code, e.g. MNMN6T'**
  String get studyGroupCodeHint;

  /// Join button
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get studyGroupJoinButton;

  /// Join button while saving
  ///
  /// In en, this message translates to:
  /// **'Joining…'**
  String get studyGroupJoining;

  /// Join failure toast
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t join. Check the code.'**
  String get studyGroupJoinError;

  /// Toast after joining a group
  ///
  /// In en, this message translates to:
  /// **'You joined «{name}»'**
  String studyGroupJoinedToast(String name);

  /// Leave group button
  ///
  /// In en, this message translates to:
  /// **'Leave group'**
  String get studyGroupLeave;

  /// Leave confirm title
  ///
  /// In en, this message translates to:
  /// **'Leave the group?'**
  String get studyGroupLeaveTitle;

  /// Leave confirm body
  ///
  /// In en, this message translates to:
  /// **'You\'ll lose access to the group space.'**
  String get studyGroupLeaveBody;

  /// Delete group button
  ///
  /// In en, this message translates to:
  /// **'Delete group'**
  String get studyGroupDelete;

  /// Delete confirm title
  ///
  /// In en, this message translates to:
  /// **'Delete the group?'**
  String get studyGroupDeleteTitle;

  /// Delete confirm body
  ///
  /// In en, this message translates to:
  /// **'The group, its links, announcements and shared notes will be permanently deleted.'**
  String get studyGroupDeleteBody;

  /// Cancel button in confirm dialogs
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get studyGroupCancel;

  /// Generic action failure toast
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get studyGroupGenericError;

  /// Catalog screen title
  ///
  /// In en, this message translates to:
  /// **'Group catalog'**
  String get studyGroupDiscoverTitle;

  /// Catalog screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Find a group and send the owner a request'**
  String get studyGroupDiscoverSubtitle;

  /// Catalog search hint
  ///
  /// In en, this message translates to:
  /// **'Name or code'**
  String get studyGroupDiscoverSearchHint;

  /// Catalog empty title
  ///
  /// In en, this message translates to:
  /// **'Nothing found'**
  String get studyGroupDiscoverEmptyTitle;

  /// Catalog empty subtitle
  ///
  /// In en, this message translates to:
  /// **'Try another name or code'**
  String get studyGroupDiscoverEmptySubtitle;

  /// Request-to-join button
  ///
  /// In en, this message translates to:
  /// **'Request'**
  String get studyGroupRequestJoin;

  /// Request-sent tag/toast
  ///
  /// In en, this message translates to:
  /// **'Request sent'**
  String get studyGroupRequested;

  /// Request failure toast
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t send the request'**
  String get studyGroupRequestError;

  /// Note visibility selector label
  ///
  /// In en, this message translates to:
  /// **'Who can see it'**
  String get collabNotesVisibilityLabel;

  /// Group-visible note option
  ///
  /// In en, this message translates to:
  /// **'Whole group'**
  String get collabNotesVisibilityGroup;

  /// Personal note option
  ///
  /// In en, this message translates to:
  /// **'Only me'**
  String get collabNotesVisibilityPersonal;

  /// Badge on a personal note
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get collabNotesPersonalBadge;

  /// Hint when group sharing needs a group
  ///
  /// In en, this message translates to:
  /// **'Join a group to share notes with it'**
  String get collabNotesNeedGroup;

  /// No description provided for @teamFinderExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get teamFinderExpired;

  /// No description provided for @teamFinderDeleteTeam.
  ///
  /// In en, this message translates to:
  /// **'Delete team'**
  String get teamFinderDeleteTeam;

  /// No description provided for @teamFinderLeaveTeam.
  ///
  /// In en, this message translates to:
  /// **'Leave team'**
  String get teamFinderLeaveTeam;

  /// No description provided for @teamFinderWithdrawApplication.
  ///
  /// In en, this message translates to:
  /// **'Withdraw application'**
  String get teamFinderWithdrawApplication;

  /// No description provided for @teamFinderLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load teams'**
  String get teamFinderLoadError;

  /// No description provided for @teamFinderLoadErrorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again.'**
  String get teamFinderLoadErrorSubtitle;

  /// No description provided for @teamFinderCreateError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t create the team'**
  String get teamFinderCreateError;

  /// No description provided for @teamFinderDecreaseCapacity.
  ///
  /// In en, this message translates to:
  /// **'Decrease team size'**
  String get teamFinderDecreaseCapacity;

  /// No description provided for @teamFinderIncreaseCapacity.
  ///
  /// In en, this message translates to:
  /// **'Increase team size'**
  String get teamFinderIncreaseCapacity;

  /// No description provided for @teamFinderApplyError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t send the application'**
  String get teamFinderApplyError;

  /// No description provided for @teamFinderApplyAttachProfileHint.
  ///
  /// In en, this message translates to:
  /// **'The owner will see your Telegram handle and group. Your name is always included in the application.'**
  String get teamFinderApplyAttachProfileHint;

  /// No description provided for @teamFinderContactHidden.
  ///
  /// In en, this message translates to:
  /// **'Contact hidden'**
  String get teamFinderContactHidden;

  /// No description provided for @teamFinderAccepting.
  ///
  /// In en, this message translates to:
  /// **'Accepting…'**
  String get teamFinderAccepting;

  /// No description provided for @teamFinderAcceptApplication.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get teamFinderAcceptApplication;

  /// No description provided for @teamFinderRejectApplication.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get teamFinderRejectApplication;

  /// No description provided for @teamFinderTelegramUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Telegram contact isn\'t available'**
  String get teamFinderTelegramUnavailable;

  /// No description provided for @teamFinderApplicationsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load applications'**
  String get teamFinderApplicationsLoadError;

  /// No description provided for @teamFinderApplicationsLoadErrorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again.'**
  String get teamFinderApplicationsLoadErrorSubtitle;

  /// No description provided for @teamFinderApplicationActionError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t update the application'**
  String get teamFinderApplicationActionError;

  /// No description provided for @teamFinderTelegramOpenError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open Telegram'**
  String get teamFinderTelegramOpenError;

  /// No description provided for @teamFinderWithdrawConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Withdraw the application?'**
  String get teamFinderWithdrawConfirmTitle;

  /// No description provided for @teamFinderWithdrawConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'The team owner will no longer see it. You can apply again later.'**
  String get teamFinderWithdrawConfirmBody;

  /// No description provided for @teamFinderLeaveConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave the team?'**
  String get teamFinderLeaveConfirmTitle;

  /// No description provided for @teamFinderLeaveConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Your spot will become available to another applicant.'**
  String get teamFinderLeaveConfirmBody;

  /// No description provided for @teamFinderDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete the team?'**
  String get teamFinderDeleteConfirmTitle;

  /// No description provided for @teamFinderDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'The team and all pending applications will be permanently deleted.'**
  String get teamFinderDeleteConfirmBody;

  /// No description provided for @teamFinderLeaveError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t leave the team'**
  String get teamFinderLeaveError;

  /// No description provided for @teamFinderDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t delete the team'**
  String get teamFinderDeleteError;

  /// No description provided for @teamFinderRefreshError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t refresh teams'**
  String get teamFinderRefreshError;

  /// Label for the full-name field
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get identityNameLabel;

  /// Placeholder for the full-name field
  ///
  /// In en, this message translates to:
  /// **'Ivan Ivanov'**
  String get identityNameHint;

  /// Label for the @handle field
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get identityHandleLabel;

  /// Placeholder for the @handle field
  ///
  /// In en, this message translates to:
  /// **'ivan_99'**
  String get identityHandleHint;

  /// Helper text under the handle field
  ///
  /// In en, this message translates to:
  /// **'3–20 chars: latin letters, digits, underscore'**
  String get identityHandleHelp;

  /// Handle is free
  ///
  /// In en, this message translates to:
  /// **'Nickname is available'**
  String get identityHandleAvailable;

  /// Handle is taken by someone else
  ///
  /// In en, this message translates to:
  /// **'This nickname is already taken'**
  String get identityHandleTaken;

  /// Handle format is invalid
  ///
  /// In en, this message translates to:
  /// **'Only latin letters, digits and _ (3–20)'**
  String get identityHandleInvalid;

  /// Save button label while saving identity
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get identitySaving;

  /// Generic identity save failure toast
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save. Try again later.'**
  String get identitySaveError;

  /// Onboarding identity step title
  ///
  /// In en, this message translates to:
  /// **'Tell us about you'**
  String get onboardingIdentityTitle;

  /// Onboarding identity step subtitle
  ///
  /// In en, this message translates to:
  /// **'Your name and nickname are visible to groupmates and friends'**
  String get onboardingIdentitySubtitle;

  /// Settings row opening the identity editor
  ///
  /// In en, this message translates to:
  /// **'Name & nickname'**
  String get profileIdentityRow;

  /// Identity edit sheet title
  ///
  /// In en, this message translates to:
  /// **'Name & nickname'**
  String get profileEditIdentityTitle;

  /// Identity edit sheet subtitle
  ///
  /// In en, this message translates to:
  /// **'Visible to groupmates and friends'**
  String get profileEditIdentitySubtitle;

  /// Save button in the identity edit sheet
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get profileEditSave;

  /// Toast after saving identity
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get profileIdentitySaved;

  /// Semantic label for an article image
  ///
  /// In en, this message translates to:
  /// **'Article image'**
  String get articleImage;

  /// Live-region announcement while screen content is loading
  ///
  /// In en, this message translates to:
  /// **'Loading content'**
  String get loadingContent;

  /// Section title above the campus picker on the map panel
  ///
  /// In en, this message translates to:
  /// **'Building'**
  String get mapBuildingLabel;

  /// Hint under the campus section title of the map panel
  ///
  /// In en, this message translates to:
  /// **'Pull the panel up to change building'**
  String get mapChangeBuildingHint;

  /// Label of a single campus floor, e.g. Floor 3
  ///
  /// In en, this message translates to:
  /// **'Floor {number}'**
  String mapFloorNumber(int number);

  /// Number of floor plans available for a campus building
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} floor} other{{count} floors}}'**
  String mapFloorsCount(int count);

  /// Semantic label of the floor switcher row
  ///
  /// In en, this message translates to:
  /// **'Floor selection'**
  String get mapFloorSelection;

  /// Map control that zooms the whole floor plan into view
  ///
  /// In en, this message translates to:
  /// **'Fit floor plan'**
  String get mapFitFloorPlan;

  /// Short visible label for the map fit control
  ///
  /// In en, this message translates to:
  /// **'Whole floor'**
  String get mapWholeFloor;

  /// Map control that zooms the floor plan in
  ///
  /// In en, this message translates to:
  /// **'Zoom in'**
  String get mapZoomIn;

  /// Map control that zooms the floor plan out
  ///
  /// In en, this message translates to:
  /// **'Zoom out'**
  String get mapZoomOut;

  /// Live-region announcement while a floor plan is loading
  ///
  /// In en, this message translates to:
  /// **'Opening floor'**
  String get mapOpeningFloor;

  /// Map search field placeholder and room finder sheet title
  ///
  /// In en, this message translates to:
  /// **'Find a room'**
  String get mapFindRoom;

  /// Subtitle of the room finder sheet
  ///
  /// In en, this message translates to:
  /// **'Search this floor and jump straight to the room'**
  String get mapFindRoomHint;

  /// Placeholder of the room finder input
  ///
  /// In en, this message translates to:
  /// **'Room number or name'**
  String get mapRoomSearchHint;

  /// Empty state title when the room search returns nothing
  ///
  /// In en, this message translates to:
  /// **'No rooms found on this floor'**
  String get mapNoRoomsTitle;

  /// Empty state message when the room search returns nothing
  ///
  /// In en, this message translates to:
  /// **'Try another room number or name'**
  String get mapNoRoomsMessage;

  /// Semantic label of the interactive floor plan canvas
  ///
  /// In en, this message translates to:
  /// **'Interactive floor map'**
  String get mapInteractiveLabel;

  /// Semantic hint of the interactive floor plan canvas
  ///
  /// In en, this message translates to:
  /// **'Pan the map, pinch or double tap to zoom'**
  String get mapInteractiveHint;

  /// Onboarding welcome headline; the accent word is onboardingWelcomeTitleAccent
  ///
  /// In en, this message translates to:
  /// **'University\nin one tap'**
  String get onboardingWelcomeTitle;

  /// Accent (italic) word inside onboardingWelcomeTitle
  ///
  /// In en, this message translates to:
  /// **'tap'**
  String get onboardingWelcomeTitleAccent;

  /// Onboarding welcome lead paragraph
  ///
  /// In en, this message translates to:
  /// **'Classes, deadlines, free rooms and your pass — no extra tabs.'**
  String get onboardingWelcomeLead;

  /// Welcome feature row title
  ///
  /// In en, this message translates to:
  /// **'Schedule with changes'**
  String get onboardingFeatureScheduleTitle;

  /// Welcome feature row subtitle
  ///
  /// In en, this message translates to:
  /// **'Reschedules and swaps — right in your feed'**
  String get onboardingFeatureScheduleSub;

  /// Welcome feature row title
  ///
  /// In en, this message translates to:
  /// **'Free rooms nearby'**
  String get onboardingFeatureRoomsTitle;

  /// Welcome feature row subtitle
  ///
  /// In en, this message translates to:
  /// **'Where to study during a break'**
  String get onboardingFeatureRoomsSub;

  /// Welcome feature row title
  ///
  /// In en, this message translates to:
  /// **'Friends on campus'**
  String get onboardingFeatureFriendsTitle;

  /// Welcome feature row subtitle
  ///
  /// In en, this message translates to:
  /// **'Shared gaps and who is where right now'**
  String get onboardingFeatureFriendsSub;

  /// Welcome primary button
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingStart;

  /// Welcome secondary button
  ///
  /// In en, this message translates to:
  /// **'I already have an account'**
  String get onboardingHaveAccount;

  /// Group picker lead paragraph
  ///
  /// In en, this message translates to:
  /// **'Your schedule will load automatically. You can change it in Settings.'**
  String get onboardingGroupLead;

  /// Group search field placeholder (example group code)
  ///
  /// In en, this message translates to:
  /// **'ИКБО-01-24'**
  String get onboardingGroupPlaceholder;

  /// Group picker empty state, text before the accent action
  ///
  /// In en, this message translates to:
  /// **'Group not found. Check the spelling or '**
  String get onboardingGroupNotFound;

  /// Group picker empty state, accent part
  ///
  /// In en, this message translates to:
  /// **'create your own schedule'**
  String get onboardingGroupNotFoundAction;

  /// Group picker empty state, trailing punctuation
  ///
  /// In en, this message translates to:
  /// **'.'**
  String get onboardingGroupNotFoundSuffix;

  /// Onboarding continue button
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get onboardingContinue;

  /// Onboarding settings step title
  ///
  /// In en, this message translates to:
  /// **'A couple of settings'**
  String get onboardingSettingsTitle;

  /// Onboarding settings step lead
  ///
  /// In en, this message translates to:
  /// **'You can change everything later.'**
  String get onboardingSettingsLead;

  /// Notifications toggle subtitle
  ///
  /// In en, this message translates to:
  /// **'Classes, deadlines, changes'**
  String get onboardingPushSub;

  /// Location toggle title
  ///
  /// In en, this message translates to:
  /// **'Location on campus'**
  String get onboardingGeoTitle;

  /// Location toggle subtitle
  ///
  /// In en, this message translates to:
  /// **'For the map and free rooms'**
  String get onboardingGeoSub;

  /// Profile visibility toggle title
  ///
  /// In en, this message translates to:
  /// **'Show me to friends'**
  String get onboardingFriendsTitle;

  /// Profile visibility toggle subtitle
  ///
  /// In en, this message translates to:
  /// **'Only while you are on campus'**
  String get onboardingFriendsSub;

  /// Toast when the OS notification permission is denied
  ///
  /// In en, this message translates to:
  /// **'Allow notifications in the system settings'**
  String get onboardingPushDenied;

  /// Toast when the OS location permission is denied
  ///
  /// In en, this message translates to:
  /// **'Allow location access in the system settings'**
  String get onboardingGeoDenied;

  /// Toast when a settings update fails
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save the setting. Try again.'**
  String get onboardingSettingsSaveError;

  /// Toast after finishing onboarding
  ///
  /// In en, this message translates to:
  /// **'Welcome, {group}'**
  String onboardingWelcomeToast(String group);

  /// Progress bar semantics
  ///
  /// In en, this message translates to:
  /// **'Step {step} of {total}'**
  String onboardingStepSemantics(int step, int total);

  /// Compact relative time in minutes on news cards
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String newsTimeMinutes(int count);

  /// Compact relative time in hours on news cards
  ///
  /// In en, this message translates to:
  /// **'{count} h'**
  String newsTimeHours(int count);

  /// Compact relative time for the previous day
  ///
  /// In en, this message translates to:
  /// **'yesterday'**
  String get newsTimeYesterday;

  /// Compact relative time in days on news cards
  ///
  /// In en, this message translates to:
  /// **'{count} d'**
  String newsTimeDays(int count);

  /// Compact relative time for a just published item
  ///
  /// In en, this message translates to:
  /// **'now'**
  String get newsTimeNow;

  /// Semantics label of the source rail on the news page
  ///
  /// In en, this message translates to:
  /// **'News sources'**
  String get newsSourcesSemantics;

  /// Relative publish time suffix on the article page
  ///
  /// In en, this message translates to:
  /// **'{time} ago'**
  String articleTimeAgo(String time);

  /// Toast after removing an article from saved
  ///
  /// In en, this message translates to:
  /// **'Removed from saved'**
  String get articleUnsaved;

  /// Semantics label of the save button when the article is saved
  ///
  /// In en, this message translates to:
  /// **'Remove from saved'**
  String get articleRemoveFromSaved;

  /// Source kind label on the article source card
  ///
  /// In en, this message translates to:
  /// **'Official channel'**
  String get articleSourceOfficial;

  /// Source kind label for Telegram sources
  ///
  /// In en, this message translates to:
  /// **'Telegram channel'**
  String get articleSourceTelegram;

  /// Source kind label for RSS sources
  ///
  /// In en, this message translates to:
  /// **'RSS feed'**
  String get articleSourceRss;

  /// Subscriber count on the article source card
  ///
  /// In en, this message translates to:
  /// **'{count} subscribers'**
  String articleSourceSubscribers(String count);

  /// Source card pill when the source is followed
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get articleSourceSubscribed;

  /// Source card pill when the source is not followed
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get articleSourceSubscribe;

  /// Toast after following a news source
  ///
  /// In en, this message translates to:
  /// **'You follow {name}'**
  String articleSourceFollowedToast(String name);

  /// Toast after unfollowing a news source
  ///
  /// In en, this message translates to:
  /// **'Unfollowed'**
  String get articleSourceUnfollowedToast;

  /// Story viewer button that opens the article
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get storyRead;

  /// Semantics label of the story viewer close button
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get storyClose;

  /// Semantics label of the story viewer left tap zone
  ///
  /// In en, this message translates to:
  /// **'Previous story'**
  String get storyPrevious;

  /// Semantics label of the story viewer right tap zone
  ///
  /// In en, this message translates to:
  /// **'Next story'**
  String get storyNext;

  /// Story viewer empty state
  ///
  /// In en, this message translates to:
  /// **'No stories from this source yet'**
  String get storyEmpty;

  /// Overline above the joined communities group
  ///
  /// In en, this message translates to:
  /// **'Mine'**
  String get communitiesMine;

  /// Overline above the community cards when no category is selected
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get communitiesRecommended;

  /// Join button label when the user joined the community
  ///
  /// In en, this message translates to:
  /// **'You are a member'**
  String get communitiesMember;

  /// Toast after joining a community
  ///
  /// In en, this message translates to:
  /// **'Welcome to {name}'**
  String communitiesJoinedToast(String name);

  /// Toast after leaving a community
  ///
  /// In en, this message translates to:
  /// **'You left the community'**
  String get communitiesLeftToast;

  /// Empty state of the joined communities group
  ///
  /// In en, this message translates to:
  /// **'Join a community and it will appear here'**
  String get communitiesMineEmpty;

  /// Empty state of the community cards list
  ///
  /// In en, this message translates to:
  /// **'No communities in this category yet'**
  String get communitiesEmptyCategory;

  /// Semantics label of the accent plus button on the communities page
  ///
  /// In en, this message translates to:
  /// **'Suggest a community'**
  String get communitiesSuggest;

  /// Community page feed section title
  ///
  /// In en, this message translates to:
  /// **'Feed'**
  String get communityFeed;

  /// Community page feed section action that opens the chat
  ///
  /// In en, this message translates to:
  /// **'write'**
  String get communityWrite;

  /// Community feed empty state title
  ///
  /// In en, this message translates to:
  /// **'Community posts'**
  String get communityFeedEmpty;

  /// Community feed empty state subtitle
  ///
  /// In en, this message translates to:
  /// **'Organizers post in the chat — open it to write'**
  String get communityFeedEmptySub;

  /// Community stat card label
  ///
  /// In en, this message translates to:
  /// **'members'**
  String get communityStatMembers;

  /// Community stat card label for the chat platform
  ///
  /// In en, this message translates to:
  /// **'platform'**
  String get communityStatPlatform;

  /// Community stat card label for the catalog category
  ///
  /// In en, this message translates to:
  /// **'category'**
  String get communityStatCategory;

  /// Semantics label of the community link
  ///
  /// In en, this message translates to:
  /// **'Open chat'**
  String get communityOpenChat;

  /// Platform name for web links
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get communityPlatformWeb;

  /// Schedule header overline
  ///
  /// In en, this message translates to:
  /// **'Week {week} · {parity}'**
  String scheduleWeekOverline(int week, String parity);

  /// Changes banner
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} change this week} other{{count} changes this week}}'**
  String scheduleChangesThisWeek(int count);

  /// Banner action
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get scheduleShow;

  /// Compare banner
  ///
  /// In en, this message translates to:
  /// **'Comparing with {name}'**
  String scheduleCompareWith(String name);

  /// Compare banner
  ///
  /// In en, this message translates to:
  /// **'common windows:'**
  String get scheduleCommonWindows;

  /// Compare banner
  ///
  /// In en, this message translates to:
  /// **'no common windows today'**
  String get scheduleNoCommonWindows;

  /// Compare banner action
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get scheduleCompareOff;

  /// Schedule view segment
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get scheduleViewDay;

  /// Day view link
  ///
  /// In en, this message translates to:
  /// **'← week'**
  String get schedulePrevWeek;

  /// Day view link
  ///
  /// In en, this message translates to:
  /// **'week →'**
  String get scheduleNextWeek;

  /// Day lesson count
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{no classes} =1{{count} class} other{{count} classes}}'**
  String scheduleDayLessons(int count);

  /// Gap row
  ///
  /// In en, this message translates to:
  /// **'break {minutes} min'**
  String scheduleBreakMinutes(int minutes);

  /// Empty day card
  ///
  /// In en, this message translates to:
  /// **'Free day'**
  String get scheduleFreeDayTitle;

  /// Empty day card
  ///
  /// In en, this message translates to:
  /// **'No classes. You can add your own event.'**
  String get scheduleFreeDaySubtitle;

  /// Week view pill
  ///
  /// In en, this message translates to:
  /// **'Compare with a friend'**
  String get scheduleCompareFriend;

  /// Week legend
  ///
  /// In en, this message translates to:
  /// **'Lab'**
  String get scheduleLegendLab;

  /// Week legend
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get scheduleLegendCancel;

  /// Week legend
  ///
  /// In en, this message translates to:
  /// **'tap — add your own'**
  String get scheduleLegendAddOwn;

  /// Month card meta
  ///
  /// In en, this message translates to:
  /// **'{year} · semester {semester}'**
  String scheduleMonthMeta(int year, int semester);

  /// Month stats overline
  ///
  /// In en, this message translates to:
  /// **'THIS MONTH'**
  String get scheduleMonthStatsTitle;

  /// Month stats
  ///
  /// In en, this message translates to:
  /// **'Study days'**
  String get scheduleStudyDays;

  /// Month stats
  ///
  /// In en, this message translates to:
  /// **'Classes'**
  String get scheduleLessonsLabel;

  /// Month stats
  ///
  /// In en, this message translates to:
  /// **'Tests'**
  String get scheduleExamsLabel;

  /// Month legend
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} lecture} other{{count} lectures}}'**
  String scheduleLecturesCount(int count);

  /// Month legend
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} practice} other{{count} practices}}'**
  String schedulePracticesCount(int count);

  /// Month legend
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} lab} other{{count} labs}}'**
  String scheduleLabsCount(int count);

  /// Lesson type short
  ///
  /// In en, this message translates to:
  /// **'LEC'**
  String get lessonShortLecture;

  /// Lesson type short
  ///
  /// In en, this message translates to:
  /// **'PRAC'**
  String get lessonShortPractice;

  /// Lesson type short
  ///
  /// In en, this message translates to:
  /// **'LAB'**
  String get lessonShortLab;

  /// Lesson type short
  ///
  /// In en, this message translates to:
  /// **'PE'**
  String get lessonShortPe;

  /// Lesson type short
  ///
  /// In en, this message translates to:
  /// **'CONS'**
  String get lessonShortConsult;

  /// Lesson type short
  ///
  /// In en, this message translates to:
  /// **'EXAM'**
  String get lessonShortExam;

  /// Lesson type short
  ///
  /// In en, this message translates to:
  /// **'CRED'**
  String get lessonShortCredit;

  /// Lesson type short
  ///
  /// In en, this message translates to:
  /// **'CRS'**
  String get lessonShortCourse;

  /// Lesson type short
  ///
  /// In en, this message translates to:
  /// **'IND'**
  String get lessonShortIndividual;

  /// Lesson type short
  ///
  /// In en, this message translates to:
  /// **'OWN'**
  String get lessonShortOwn;

  /// Lesson row tag
  ///
  /// In en, this message translates to:
  /// **'· cancelled'**
  String get lessonTagCancelled;

  /// Lesson row tag
  ///
  /// In en, this message translates to:
  /// **'· in progress, {minutes} min left'**
  String lessonTagLive(int minutes);

  /// Lesson row tag
  ///
  /// In en, this message translates to:
  /// **'· next'**
  String get lessonTagNext;

  /// Lesson row tag
  ///
  /// In en, this message translates to:
  /// **'· room changed'**
  String get lessonTagMoved;

  /// Lesson row tag
  ///
  /// In en, this message translates to:
  /// **'· new'**
  String get lessonTagNew;

  /// Lesson row meta
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get lessonMetaCancelled;

  /// Lesson row meta
  ///
  /// In en, this message translates to:
  /// **'{type} · {room} instead of {oldRoom}'**
  String lessonMetaMoved(String type, String room, String oldRoom);

  /// Lesson row meta suffix
  ///
  /// In en, this message translates to:
  /// **'finished'**
  String get lessonMetaPast;

  /// Lesson actions sheet
  ///
  /// In en, this message translates to:
  /// **'Open class'**
  String get scheduleActionOpen;

  /// Lesson actions sheet
  ///
  /// In en, this message translates to:
  /// **'Report a mistake'**
  String get scheduleActionReport;

  /// Toast
  ///
  /// In en, this message translates to:
  /// **'Class hidden'**
  String get scheduleLessonHidden;

  /// Changes sheet subtitle
  ///
  /// In en, this message translates to:
  /// **'This week · updated {time}'**
  String scheduleChangesSubtitle(String time);

  /// Changes sheet subtitle
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get scheduleChangesSubtitleWeek;

  /// Change tag
  ///
  /// In en, this message translates to:
  /// **'Moved'**
  String get scheduleChangeTagMoved;

  /// Change tag
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get scheduleChangeTagCancelled;

  /// Change tag
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get scheduleChangeTagNew;

  /// Change tag
  ///
  /// In en, this message translates to:
  /// **'Teacher'**
  String get scheduleChangeTagTeacher;

  /// Change tag
  ///
  /// In en, this message translates to:
  /// **'Room'**
  String get scheduleChangeTagRoom;

  /// Change sub
  ///
  /// In en, this message translates to:
  /// **'added'**
  String get scheduleChangeAdded;

  /// Changes sheet CTA
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get scheduleChangesAck;

  /// Add lesson sheet
  ///
  /// In en, this message translates to:
  /// **'Own class'**
  String get scheduleAddTitle;

  /// Add lesson sheet
  ///
  /// In en, this message translates to:
  /// **'Club, consultation, meeting — it will appear in the schedule'**
  String get scheduleAddSubtitle;

  /// Add lesson sheet
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get scheduleAddName;

  /// Add lesson sheet
  ///
  /// In en, this message translates to:
  /// **'Place (optional)'**
  String get scheduleAddPlace;

  /// Add lesson sheet
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get scheduleAddType;

  /// Add lesson sheet
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get scheduleAddDay;

  /// Add lesson sheet
  ///
  /// In en, this message translates to:
  /// **'Class'**
  String get scheduleAddSlot;

  /// Toast
  ///
  /// In en, this message translates to:
  /// **'Class added to the schedule'**
  String get scheduleAddDone;

  /// Activity type
  ///
  /// In en, this message translates to:
  /// **'Own'**
  String get activityTypeOwn;

  /// Activity type
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get activityTypeEvent;

  /// Activity type
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get activityTypeRetake;

  /// Activity type
  ///
  /// In en, this message translates to:
  /// **'Extra class'**
  String get activityTypeExtra;

  /// Compare sheet
  ///
  /// In en, this message translates to:
  /// **'Compare schedules'**
  String get scheduleCompareTitle;

  /// Compare sheet
  ///
  /// In en, this message translates to:
  /// **'We will show your friend\'s busy slots and common windows'**
  String get scheduleCompareSubtitle;

  /// Toast
  ///
  /// In en, this message translates to:
  /// **'Comparing with {name}'**
  String scheduleCompareStarted(String name);

  /// Compare sheet empty
  ///
  /// In en, this message translates to:
  /// **'No friends with a group yet'**
  String get scheduleCompareNoFriends;

  /// Compare sheet empty
  ///
  /// In en, this message translates to:
  /// **'Add friends — their groups will appear here'**
  String get scheduleCompareNoFriendsHint;

  /// Compare sheet row
  ///
  /// In en, this message translates to:
  /// **'group not set'**
  String get scheduleCompareNoGroup;

  /// Note sheet
  ///
  /// In en, this message translates to:
  /// **'Only you can see it · can be shared with the group'**
  String get scheduleNoteSubtitle;

  /// Note sheet
  ///
  /// In en, this message translates to:
  /// **'What to remember…'**
  String get scheduleNotePlaceholder;

  /// Note sheet
  ///
  /// In en, this message translates to:
  /// **'+ file'**
  String get scheduleNoteAddFile;

  /// Note sheet
  ///
  /// In en, this message translates to:
  /// **'+ board photo'**
  String get scheduleNoteAddBoard;

  /// Note sheet
  ///
  /// In en, this message translates to:
  /// **'#tag'**
  String get scheduleNoteTag;

  /// Toast
  ///
  /// In en, this message translates to:
  /// **'Note saved'**
  String get scheduleNoteSaved;

  /// Remind option
  ///
  /// In en, this message translates to:
  /// **'{minutes} min before'**
  String scheduleRemindIn(int minutes);

  /// Remind option
  ///
  /// In en, this message translates to:
  /// **'1 hour before'**
  String get scheduleRemindHour;

  /// Toast
  ///
  /// In en, this message translates to:
  /// **'Will remind {minutes} min before'**
  String scheduleRemindSet(int minutes);

  /// Share option
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get scheduleShareLink;

  /// Share option
  ///
  /// In en, this message translates to:
  /// **'To calendar'**
  String get scheduleShareCalendar;

  /// Share option
  ///
  /// In en, this message translates to:
  /// **'As image'**
  String get scheduleShareImage;

  /// Toast
  ///
  /// In en, this message translates to:
  /// **'Link copied'**
  String get scheduleLinkCopied;

  /// Filter sheet
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get scheduleFilterTitle;

  /// Filter sheet
  ///
  /// In en, this message translates to:
  /// **'Shown in grey'**
  String get scheduleFilterPastSub;

  /// Filter sheet
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get scheduleFilterCancelled;

  /// Filter sheet
  ///
  /// In en, this message translates to:
  /// **'Struck through'**
  String get scheduleFilterCancelledSub;

  /// Lesson page banner
  ///
  /// In en, this message translates to:
  /// **'Class cancelled'**
  String get lessonCancelledBanner;

  /// Lesson page banner
  ///
  /// In en, this message translates to:
  /// **'Room changed: {from} → {to}'**
  String lessonMovedBanner(String from, String to);

  /// Lesson page card
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get lessonTimeLabel;

  /// Lesson page card
  ///
  /// In en, this message translates to:
  /// **'class {number}'**
  String lessonNumberMeta(int number);

  /// Lesson page card
  ///
  /// In en, this message translates to:
  /// **'on the map'**
  String get lessonOnMap;

  /// Lesson page action
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get lessonFiles;

  /// Lesson page section action
  ///
  /// In en, this message translates to:
  /// **'add'**
  String get lessonMaterialsAdd;

  /// Lesson page section
  ///
  /// In en, this message translates to:
  /// **'How was it?'**
  String get lessonHowWasIt;

  /// Lesson page card
  ///
  /// In en, this message translates to:
  /// **'Group note'**
  String get lessonGroupNote;

  /// Lesson page card
  ///
  /// In en, this message translates to:
  /// **'Nothing yet — share what was important'**
  String get lessonGroupNoteEmpty;

  /// Teacher sheet stat
  ///
  /// In en, this message translates to:
  /// **'rating'**
  String get scheduleTeacherRating;

  /// Teacher sheet stat
  ///
  /// In en, this message translates to:
  /// **'reviews'**
  String get scheduleTeacherReviews;

  /// Teacher sheet stat
  ///
  /// In en, this message translates to:
  /// **'subjects'**
  String get scheduleTeacherSubjects;

  /// Teacher sheet action
  ///
  /// In en, this message translates to:
  /// **'Write'**
  String get scheduleTeacherWrite;

  /// Teacher sheet action
  ///
  /// In en, this message translates to:
  /// **'Leave a review'**
  String get scheduleTeacherReview;

  /// Toast
  ///
  /// In en, this message translates to:
  /// **'No contacts for this teacher yet'**
  String get scheduleTeacherNoContacts;

  /// Semantics
  ///
  /// In en, this message translates to:
  /// **'Export week'**
  String get scheduleWeekExport;

  /// Semantics
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get scheduleFilterSemantics;

  /// Semantics
  ///
  /// In en, this message translates to:
  /// **'Add own class'**
  String get scheduleAddLessonSemantics;

  /// Semantics
  ///
  /// In en, this message translates to:
  /// **'Class actions'**
  String get scheduleMoreSemantics;

  /// Risk badge on grades/attendance cards
  ///
  /// In en, this message translates to:
  /// **'RISK'**
  String get riskBadge;

  /// Grades page title
  ///
  /// In en, this message translates to:
  /// **'Grades'**
  String get gradesTitle;

  /// Grades header refresh button semantics
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get gradesRefresh;

  /// Grades error state title
  ///
  /// In en, this message translates to:
  /// **'Could not load'**
  String get gradesErrorTitle;

  /// Grades error message with the last save date
  ///
  /// In en, this message translates to:
  /// **'Last grades were saved on {date}.'**
  String gradesErrorSaved(String date);

  /// Grades error message without a save date
  ///
  /// In en, this message translates to:
  /// **'No saved grades yet.'**
  String get gradesErrorNoData;

  /// GPA card label
  ///
  /// In en, this message translates to:
  /// **'Personal GPA'**
  String get gradesGpaLabel;

  /// GPA delta over the last month
  ///
  /// In en, this message translates to:
  /// **'{delta} this month'**
  String gradesGpaDelta(String delta);

  /// GPA card right label
  ///
  /// In en, this message translates to:
  /// **'To the raised scholarship'**
  String get gradesScholarshipLabel;

  /// Hint naming the weakest subject
  ///
  /// In en, this message translates to:
  /// **'get {subject} to 4+'**
  String gradesScholarshipHint(String subject);

  /// Hint when GPA is above the scholarship threshold
  ///
  /// In en, this message translates to:
  /// **'threshold reached'**
  String get gradesScholarshipReached;

  /// Current term segment
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get gradesTermCurrent;

  /// Previous term segment
  ///
  /// In en, this message translates to:
  /// **'Sem {n}'**
  String gradesTermSemester(int n);

  /// Grades empty state title
  ///
  /// In en, this message translates to:
  /// **'No subjects yet'**
  String get gradesNoSubjectsTitle;

  /// Grades empty state subtitle
  ///
  /// In en, this message translates to:
  /// **'Pick your group schedule and subjects will appear here'**
  String get gradesNoSubjectsSubtitle;

  /// Grades empty state for a past term
  ///
  /// In en, this message translates to:
  /// **'No grades for this term'**
  String get gradesTermEmpty;

  /// Fallback teacher line
  ///
  /// In en, this message translates to:
  /// **'Teacher not set'**
  String get gradesTeacherUnknown;

  /// Add-mark sheet subtitle
  ///
  /// In en, this message translates to:
  /// **'Add a grade'**
  String get gradesAddMarkSubtitle;

  /// Toast after adding a mark
  ///
  /// In en, this message translates to:
  /// **'Grade {mark} added'**
  String gradesMarkAdded(int mark);

  /// Remove last mark action
  ///
  /// In en, this message translates to:
  /// **'Remove last'**
  String get gradesRemoveLast;

  /// Mark pill semantics
  ///
  /// In en, this message translates to:
  /// **'Grade {mark}'**
  String gradesMarkSemantics(int mark);

  /// Attendance page title
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get attendanceTitle;

  /// Add absence button / sheet title
  ///
  /// In en, this message translates to:
  /// **'Log an absence'**
  String get attendanceAddAbsence;

  /// Attendance stat caption
  ///
  /// In en, this message translates to:
  /// **'personal log'**
  String get attendanceStatSemester;

  /// Attendance stat caption
  ///
  /// In en, this message translates to:
  /// **'absences'**
  String get attendanceStatMissed;

  /// Attendance stat caption
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{subject at risk} other{subjects at risk}}'**
  String attendanceStatRisk(int count);

  /// Weekly bars card title
  ///
  /// In en, this message translates to:
  /// **'By week'**
  String get attendanceWeeksTitle;

  /// Weekly bars range
  ///
  /// In en, this message translates to:
  /// **'{month} → now'**
  String attendanceWeeksRange(String month);

  /// Risk banner text
  ///
  /// In en, this message translates to:
  /// **'{subject}: {count, plural, =1{{count} unexcused absence} other{{count} unexcused absences}}. Estimated attendance is below 70%; check the course requirements with your teacher.'**
  String attendanceRiskBanner(String subject, int count);

  /// Attendance section overline
  ///
  /// In en, this message translates to:
  /// **'By subject'**
  String get attendanceBySubjects;

  /// Absence row text
  ///
  /// In en, this message translates to:
  /// **'Absence · {reason}'**
  String attendanceMissRow(String reason);

  /// Absence reason
  ///
  /// In en, this message translates to:
  /// **'sick (personal record)'**
  String get attendanceReasonSick;

  /// Absence reason
  ///
  /// In en, this message translates to:
  /// **'no reason'**
  String get attendanceReasonNone;

  /// Attach certificate action
  ///
  /// In en, this message translates to:
  /// **'Sick'**
  String get attendanceCertificate;

  /// Remove absence action
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get attendanceRemoveAbsence;

  /// Note under a risky subject
  ///
  /// In en, this message translates to:
  /// **'This is a personal estimate from the available schedule. Ask your teacher about assessment and make-up requirements.'**
  String get attendanceRiskNote;

  /// Attendance empty state title
  ///
  /// In en, this message translates to:
  /// **'No classes yet'**
  String get attendanceNoLessonsTitle;

  /// Attendance empty state subtitle
  ///
  /// In en, this message translates to:
  /// **'Pick your group schedule — stats appear after the first classes'**
  String get attendanceNoLessonsSubtitle;

  /// Absence sheet field label
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get attendanceSheetSubject;

  /// Absence sheet field label
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get attendanceSheetDate;

  /// Absence sheet field label
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get attendanceSheetReason;

  /// Absence sheet CTA
  ///
  /// In en, this message translates to:
  /// **'Log'**
  String get attendanceSheetSubmit;

  /// Toast after logging an absence
  ///
  /// In en, this message translates to:
  /// **'Absence logged'**
  String get attendanceAbsenceAdded;

  /// Expand row semantics
  ///
  /// In en, this message translates to:
  /// **'Show absences for {subject}'**
  String attendanceExpandSemantics(String subject);

  /// Cowork page title
  ///
  /// In en, this message translates to:
  /// **'Coworking'**
  String get coworkTitle;

  /// Cowork venue line
  ///
  /// In en, this message translates to:
  /// **'Personal plan on this device'**
  String get coworkVenue;

  /// Free seats pill
  ///
  /// In en, this message translates to:
  /// **'{count} free'**
  String coworkFree(int count);

  /// Cowork zone
  ///
  /// In en, this message translates to:
  /// **'Quiet'**
  String get coworkZoneQuiet;

  /// Cowork zone
  ///
  /// In en, this message translates to:
  /// **'Common'**
  String get coworkZoneCommon;

  /// Cowork zone
  ///
  /// In en, this message translates to:
  /// **'Meeting rooms'**
  String get coworkZoneMeeting;

  /// Seat map windows strip
  ///
  /// In en, this message translates to:
  /// **'SCHEMATIC LAYOUT'**
  String get coworkWindows;

  /// Legend
  ///
  /// In en, this message translates to:
  /// **'not verified'**
  String get coworkLegendFree;

  /// Legend
  ///
  /// In en, this message translates to:
  /// **'taken'**
  String get coworkLegendTaken;

  /// Legend
  ///
  /// In en, this message translates to:
  /// **'selected'**
  String get coworkLegendMine;

  /// Details row label
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get coworkTimeLabel;

  /// Details time value
  ///
  /// In en, this message translates to:
  /// **'{from} → {until} · {hours} h'**
  String coworkTimeValue(String from, String until, int hours);

  /// Details row label
  ///
  /// In en, this message translates to:
  /// **'Extension'**
  String get coworkExtendLabel;

  /// Extension value before booking
  ///
  /// In en, this message translates to:
  /// **'for your personal plan'**
  String get coworkExtendAvailable;

  /// Extension action
  ///
  /// In en, this message translates to:
  /// **'extend until {until}'**
  String coworkExtendAction(String until);

  /// Extension exhausted
  ///
  /// In en, this message translates to:
  /// **'until closing'**
  String get coworkExtendMax;

  /// Details row label
  ///
  /// In en, this message translates to:
  /// **'Friends nearby'**
  String get coworkFriendsLabel;

  /// No friends nearby
  ///
  /// In en, this message translates to:
  /// **'no recent locations'**
  String get coworkFriendsNone;

  /// Disabled CTA
  ///
  /// In en, this message translates to:
  /// **'Pick a seat'**
  String get coworkPickSeat;

  /// Book CTA
  ///
  /// In en, this message translates to:
  /// **'Save {seat} · until {until}'**
  String coworkBook(String seat, String until);

  /// Cancel CTA
  ///
  /// In en, this message translates to:
  /// **'Remove saved seat'**
  String get coworkCancelBooking;

  /// Toast after booking
  ///
  /// In en, this message translates to:
  /// **'Seat {seat} saved until {until}'**
  String coworkBooked(String seat, String until);

  /// Toast after cancelling
  ///
  /// In en, this message translates to:
  /// **'Saved seat removed'**
  String get coworkBookingCancelled;

  /// Seat cell semantics
  ///
  /// In en, this message translates to:
  /// **'Seat {seat}'**
  String coworkSeatSemantics(String seat);

  /// Map search pill placeholder
  ///
  /// In en, this message translates to:
  /// **'Room, department, canteen'**
  String get mapSearchPlaceholder;

  /// Semantics label of the friends-on-map toggle
  ///
  /// In en, this message translates to:
  /// **'Friends on the map'**
  String get mapFriendsToggle;

  /// Semantics label of the campus chips row
  ///
  /// In en, this message translates to:
  /// **'Campus'**
  String get mapCampusFilter;

  /// Semantics of the sheet chevron when collapsed
  ///
  /// In en, this message translates to:
  /// **'Expand list'**
  String get mapExpandSheet;

  /// Semantics of the sheet chevron when expanded
  ///
  /// In en, this message translates to:
  /// **'Collapse list'**
  String get mapCollapseSheet;

  /// Title of the free rooms sheet
  ///
  /// In en, this message translates to:
  /// **'Free now'**
  String get freeRoomsNowTitle;

  /// Meta line under the free rooms title
  ///
  /// In en, this message translates to:
  /// **'{campus} · until the next class at {time} · {count, plural, =1{{count} room} other{{count} rooms}}'**
  String freeRoomsMeta(String campus, String time, int count);

  /// Meta line when no next class today
  ///
  /// In en, this message translates to:
  /// **'{campus} · no more classes today · {count, plural, =1{{count} room} other{{count} rooms}}'**
  String freeRoomsMetaEndOfDay(String campus, int count);

  /// Badge on the booked room row
  ///
  /// In en, this message translates to:
  /// **'saved'**
  String get freeRoomsYourSeat;

  /// Generic room kind label
  ///
  /// In en, this message translates to:
  /// **'Room'**
  String get freeRoomsKind;

  /// Time left, whole hours
  ///
  /// In en, this message translates to:
  /// **'{hours} h'**
  String freeRoomsLeftHours(int hours);

  /// Time left, hours and minutes
  ///
  /// In en, this message translates to:
  /// **'{hours} h {minutes} min'**
  String freeRoomsLeftHoursMinutes(int hours, int minutes);

  /// Time left, minutes
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String freeRoomsLeftMinutes(int minutes);

  /// Empty state of the free rooms list
  ///
  /// In en, this message translates to:
  /// **'Nothing found in {campus}. Try another campus.'**
  String freeRoomsNothingFound(String campus);

  /// Empty state without campus filter
  ///
  /// In en, this message translates to:
  /// **'Nothing found. Try another query.'**
  String get freeRoomsNothingFoundAll;

  /// Placeholder label on the room sheet photo
  ///
  /// In en, this message translates to:
  /// **'room photo'**
  String get roomPhotoPlaceholder;

  /// Room sheet badge
  ///
  /// In en, this message translates to:
  /// **'free until {time}'**
  String roomFreeUntilBadge(String time);

  /// Room sheet badge when no upcoming class
  ///
  /// In en, this message translates to:
  /// **'free until the end of the day'**
  String get roomFreeEndOfDayBadge;

  /// Room sheet meta line with floor
  ///
  /// In en, this message translates to:
  /// **'{kind} · {campus}, floor {floor}'**
  String roomMetaFloor(String kind, String campus, int floor);

  /// Room sheet meta line without floor
  ///
  /// In en, this message translates to:
  /// **'{kind} · {campus}'**
  String roomMetaNoFloor(String kind, String campus);

  /// Room sheet stat label
  ///
  /// In en, this message translates to:
  /// **'Free for'**
  String get roomStatFreeFor;

  /// Room sheet stat label
  ///
  /// In en, this message translates to:
  /// **'Floor'**
  String get roomStatFloor;

  /// Room sheet stat label
  ///
  /// In en, this message translates to:
  /// **'Building'**
  String get roomStatBuilding;

  /// Room sheet CTA
  ///
  /// In en, this message translates to:
  /// **'Save place'**
  String get roomBook;

  /// Room sheet CTA when booked
  ///
  /// In en, this message translates to:
  /// **'Saved until {time}'**
  String roomBooked(String time);

  /// Toast after booking
  ///
  /// In en, this message translates to:
  /// **'{name} · saved until {time}'**
  String roomBookedToast(String name, String time);

  /// Toast after releasing a booking
  ///
  /// In en, this message translates to:
  /// **'Saved place removed'**
  String get roomReleasedToast;

  /// Semantics of the route circle button
  ///
  /// In en, this message translates to:
  /// **'Show on the floor plan'**
  String get roomRoute;

  /// Toast when a room cannot be located
  ///
  /// In en, this message translates to:
  /// **'{name} is not on the campus floor plans'**
  String roomNotOnPlan(String name);

  /// Badge for a room that is not free now
  ///
  /// In en, this message translates to:
  /// **'busy'**
  String get roomTakenBadge;

  /// Home offline banner
  ///
  /// In en, this message translates to:
  /// **'Offline · showing saved data'**
  String get homeOfflineBanner;

  /// Home greeting before noon; the name follows in accent italic
  ///
  /// In en, this message translates to:
  /// **'Good morning, '**
  String get homeGreetingMorning;

  /// Home greeting before 18:00
  ///
  /// In en, this message translates to:
  /// **'Good afternoon, '**
  String get homeGreetingDay;

  /// Home greeting after 18:00
  ///
  /// In en, this message translates to:
  /// **'Good evening, '**
  String get homeGreetingEvening;

  /// Home status line when the day has no lessons
  ///
  /// In en, this message translates to:
  /// **'no classes'**
  String get homeStatusNoLessons;

  /// Home status line during a lesson
  ///
  /// In en, this message translates to:
  /// **'class {index} of {count} in progress'**
  String homeStatusOngoing(int index, int count);

  /// Home status line: next lesson time
  ///
  /// In en, this message translates to:
  /// **'next at {time}'**
  String homeStatusNext(String time);

  /// Home status line: first lesson time today
  ///
  /// In en, this message translates to:
  /// **'first at {time}'**
  String homeStatusFirst(String time);

  /// Home status line for another day
  ///
  /// In en, this message translates to:
  /// **'starts at {time}'**
  String homeStatusStart(String time);

  /// Home status line when all lessons are over
  ///
  /// In en, this message translates to:
  /// **'done for today'**
  String get homeStatusDone;

  /// Home hero pill before the first lesson
  ///
  /// In en, this message translates to:
  /// **'First class in {minutes} min'**
  String homeHeroFirstIn(int minutes);

  /// Home hero pill during a lesson
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get homeHeroNow;

  /// Home hero pill during a break
  ///
  /// In en, this message translates to:
  /// **'Break · {minutes} min'**
  String homeHeroBreak(int minutes);

  /// Home hero title when lessons are over
  ///
  /// In en, this message translates to:
  /// **'Done for today.'**
  String get homeHeroDoneTitle;

  /// Home hero accent line after the last lesson
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} class behind} other{{count} classes behind}}'**
  String homeHeroDoneLessons(int count);

  /// Home hero tomorrow summary
  ///
  /// In en, this message translates to:
  /// **'Tomorrow {lessons}, first at {time}'**
  String homeHeroTomorrow(String lessons, String time);

  /// Home hero tomorrow summary when tomorrow is free
  ///
  /// In en, this message translates to:
  /// **'No classes tomorrow'**
  String get homeHeroTomorrowFree;

  /// Home hero nearest deadline chip
  ///
  /// In en, this message translates to:
  /// **'Deadline · {left}'**
  String homeHeroDeadlineChip(String left);

  /// Home hero deadline chip when nothing is due
  ///
  /// In en, this message translates to:
  /// **'No deadlines'**
  String get homeHeroDeadlineNone;

  /// Home hero button that selects tomorrow
  ///
  /// In en, this message translates to:
  /// **'Plan for tomorrow'**
  String get homeHeroTomorrowPlan;

  /// Home hero overline for another day
  ///
  /// In en, this message translates to:
  /// **'FIRST CLASS'**
  String get homeHeroFirstLesson;

  /// Home hero free-day title
  ///
  /// In en, this message translates to:
  /// **'No classes.'**
  String get homeHeroFreeTitle;

  /// Home hero free-day body
  ///
  /// In en, this message translates to:
  /// **'Close a deadline, visit the cowork or check the events board.'**
  String get homeHeroFreeBody;

  /// Home who-goes chip label
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} going} other{{count} going}}'**
  String homeWhoGoesCount(int count);

  /// Home who-goes chip label without classmates
  ///
  /// In en, this message translates to:
  /// **'Who is going'**
  String get homeWhoGoesEmpty;

  /// Who-goes sheet title
  ///
  /// In en, this message translates to:
  /// **'Who is going to class'**
  String get homeWhoGoesTitle;

  /// Who-goes sheet subtitle
  ///
  /// In en, this message translates to:
  /// **'{count} of {total}'**
  String homeWhoGoesSubtitle(int count, int total);

  /// Who-goes sheet CTA
  ///
  /// In en, this message translates to:
  /// **'I am going too'**
  String get homeWhoGoesMe;

  /// Who-goes sheet CTA after confirming
  ///
  /// In en, this message translates to:
  /// **'You are going'**
  String get homeWhoGoesMeDone;

  /// Who-goes row status
  ///
  /// In en, this message translates to:
  /// **'going'**
  String get homeWhoGoesGoing;

  /// Who-goes sheet empty text
  ///
  /// In en, this message translates to:
  /// **'Classmates will appear here once they pick your group'**
  String get homeWhoGoesNoClassmates;

  /// Toast after confirming attendance intent
  ///
  /// In en, this message translates to:
  /// **'You are going to class'**
  String get homeGoingToast;

  /// Home break hero free room row
  ///
  /// In en, this message translates to:
  /// **'{room} is free'**
  String homeFreeRoomTitle(String room);

  /// Home break hero free room subtitle
  ///
  /// In en, this message translates to:
  /// **'until {time}'**
  String homeFreeRoomUntil(String time);

  /// Home break hero free rooms fallback subtitle
  ///
  /// In en, this message translates to:
  /// **'find a place for the break'**
  String get homeFreeRoomsSub;

  /// Home status strip streak pill
  ///
  /// In en, this message translates to:
  /// **'{count} days in a row'**
  String homeStreakDays(int count);

  /// Home status strip xp label
  ///
  /// In en, this message translates to:
  /// **'{xp} XP'**
  String homeXp(String xp);

  /// Home status strip deadlines pill
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} deadline} other{{count} deadlines}}'**
  String homeDeadlinesCount(int count);

  /// Home status strip exam pill
  ///
  /// In en, this message translates to:
  /// **'Test in {days} d'**
  String homeExamIn(int days);

  /// Home status strip exam pill on the day
  ///
  /// In en, this message translates to:
  /// **'Test today'**
  String get homeExamToday;

  /// Home quick actions section action
  ///
  /// In en, this message translates to:
  /// **'all services'**
  String get homeAllServices;

  /// Home deadlines section action
  ///
  /// In en, this message translates to:
  /// **'+ add'**
  String get homeAddDeadline;

  /// Home deadlines empty text
  ///
  /// In en, this message translates to:
  /// **'All done. Keep it up.'**
  String get homeDeadlinesAllDone;

  /// Home trending section action
  ///
  /// In en, this message translates to:
  /// **'all'**
  String get homeAllLower;

  /// Home trending row meta
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} reply} other{{count} replies}}'**
  String homeRepliesCount(int count);

  /// Home lesson row meta for a moved lesson
  ///
  /// In en, this message translates to:
  /// **'{type} · {room} instead of {old}'**
  String homeLessonMoved(String type, String room, String old);

  /// Home deadline row right label when done
  ///
  /// In en, this message translates to:
  /// **'done'**
  String get homeDeadlineDone;

  /// Note sheet character counter
  ///
  /// In en, this message translates to:
  /// **'{count} / {max}'**
  String homeNoteChars(int count, int max);

  /// Home header search button semantics
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get homeSearchLabel;

  /// Home clock pill week parity suffix
  ///
  /// In en, this message translates to:
  /// **'· {parity}'**
  String homeWeekParity(String parity);

  /// Notifications sheet header action
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get notificationsReadAll;

  /// Notifications sheet empty state title
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get notificationsEmptyTitle;

  /// Notifications sheet empty state subtitle
  ///
  /// In en, this message translates to:
  /// **'Schedule changes and pushes will show up here'**
  String get notificationsEmptySubtitle;

  /// Notification age: just now
  ///
  /// In en, this message translates to:
  /// **'now'**
  String get notifTimeNow;

  /// Notification age in minutes
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String notifTimeMinutes(int count);

  /// Notification age in hours
  ///
  /// In en, this message translates to:
  /// **'{count} h'**
  String notifTimeHours(int count);

  /// Notification age: yesterday
  ///
  /// In en, this message translates to:
  /// **'yesterday'**
  String get notifTimeYesterday;

  /// Schedule change notification title
  ///
  /// In en, this message translates to:
  /// **'Moved · {subject}'**
  String notifChangeMoved(String subject);

  /// Schedule change notification title
  ///
  /// In en, this message translates to:
  /// **'Cancelled · {subject}'**
  String notifChangeCancelled(String subject);

  /// Schedule change notification title
  ///
  /// In en, this message translates to:
  /// **'New class · {subject}'**
  String notifChangeAdded(String subject);

  /// Schedule change notification title
  ///
  /// In en, this message translates to:
  /// **'New room · {subject}'**
  String notifChangeRoom(String subject);

  /// Schedule change notification title
  ///
  /// In en, this message translates to:
  /// **'New teacher · {subject}'**
  String notifChangeTeacher(String subject);

  /// Schedule change notification detail
  ///
  /// In en, this message translates to:
  /// **'instead of {value}'**
  String notifChangeInsteadOf(String value);

  /// Fallback title for a push without a title
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notifPushDefaultTitle;

  /// Offline banner text
  ///
  /// In en, this message translates to:
  /// **'Offline · showing saved data'**
  String get offlineBannerCached;

  /// Profile level card: rank name and XP
  ///
  /// In en, this message translates to:
  /// **'{rank} · {xp} XP'**
  String profileRankXp(String rank, String xp);

  /// Profile level card: place in group
  ///
  /// In en, this message translates to:
  /// **'#{rank} in group'**
  String profileGroupPlace(int rank);

  /// Profile level card when group rank is unknown
  ///
  /// In en, this message translates to:
  /// **'no place yet'**
  String get profileGroupPlaceUnknown;

  /// Profile level card footer
  ///
  /// In en, this message translates to:
  /// **'{xp} XP to level {level} · streak {days} d.'**
  String profileXpToLevelStreak(String xp, int level, int days);

  /// Rank label for level 1-9
  ///
  /// In en, this message translates to:
  /// **'Shinobi'**
  String get profileRankShinobi;

  /// Rank label for level 10-19
  ///
  /// In en, this message translates to:
  /// **'Chunin'**
  String get profileRankChunin;

  /// Rank label for level 20-29
  ///
  /// In en, this message translates to:
  /// **'Jonin'**
  String get profileRankJonin;

  /// Rank label for level 30+
  ///
  /// In en, this message translates to:
  /// **'Kage'**
  String get profileRankKage;

  /// Profile metric card label
  ///
  /// In en, this message translates to:
  /// **'GPA'**
  String get profileMetricGpa;

  /// Profile metric card label
  ///
  /// In en, this message translates to:
  /// **'attendance'**
  String get profileMetricAttendance;

  /// Profile metric card label: days until next test
  ///
  /// In en, this message translates to:
  /// **'to exam'**
  String get profileMetricExam;

  /// Short day count
  ///
  /// In en, this message translates to:
  /// **'{days} d'**
  String profileDaysShort(int days);

  /// Profile quests section title
  ///
  /// In en, this message translates to:
  /// **'Weekly quests'**
  String get profileWeekQuests;

  /// Profile quests section meta
  ///
  /// In en, this message translates to:
  /// **'until Sunday'**
  String get profileUntilSunday;

  /// Quest reward
  ///
  /// In en, this message translates to:
  /// **'+{xp} XP'**
  String profileQuestXp(int xp);

  /// Quest progress label
  ///
  /// In en, this message translates to:
  /// **'{done}/{total}'**
  String profileQuestProgress(int done, int total);

  /// Profile quests empty state
  ///
  /// In en, this message translates to:
  /// **'No quests are available yet'**
  String get profileQuestsEmpty;

  /// Profile achievements action
  ///
  /// In en, this message translates to:
  /// **'all {count}'**
  String profileAllBadges(int count);

  /// Locked badge card subtitle
  ///
  /// In en, this message translates to:
  /// **'Soon · {percent}%'**
  String profileBadgeSoon(int percent);

  /// Profile achievements empty state
  ///
  /// In en, this message translates to:
  /// **'Your first achievement is close'**
  String get profileBadgesEmpty;

  /// Profile friends row meta
  ///
  /// In en, this message translates to:
  /// **'{count} · {campus} on the map'**
  String profileFriendsMeta(int count, int campus);

  /// Profile row to the pass
  ///
  /// In en, this message translates to:
  /// **'NFC Pass'**
  String get profileStudentCard;

  /// Student card number
  ///
  /// In en, this message translates to:
  /// **'No. {number}'**
  String profileCardNumber(String number);

  /// Edit profile sheet field label
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get profileEditAbout;

  /// Edit profile sheet about placeholder
  ///
  /// In en, this message translates to:
  /// **'A personal note about yourself'**
  String get profileEditAboutHint;

  /// Edit profile sheet field label
  ///
  /// In en, this message translates to:
  /// **'Telegram'**
  String get profileEditTelegram;

  /// Edit profile sheet telegram placeholder
  ///
  /// In en, this message translates to:
  /// **'@username'**
  String get profileEditTelegramHint;

  /// Edit profile sheet name label
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get profileEditName;

  /// Toast after saving the profile
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profileUpdatedToast;

  /// Semantics of the camera badge on the edit-profile avatar
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get profileChangePhoto;

  /// Toast when tapping the camera badge
  ///
  /// In en, this message translates to:
  /// **'Photo upload is coming soon'**
  String get profilePhotoSoon;

  /// Leaderboard scope segment
  ///
  /// In en, this message translates to:
  /// **'Institute'**
  String get leaderboardScopeInstitute;

  /// Leaderboard scope segment
  ///
  /// In en, this message translates to:
  /// **'University'**
  String get leaderboardScopeUniversity;

  /// Leaderboard row XP
  ///
  /// In en, this message translates to:
  /// **'{xp} XP'**
  String leaderboardXp(String xp);

  /// Leaderboard footer hint
  ///
  /// In en, this message translates to:
  /// **'{xp} XP to place {place}. Finish the weekly quests.'**
  String leaderboardHintGap(int place, String xp);

  /// Leaderboard footer hint for top-3
  ///
  /// In en, this message translates to:
  /// **'You are in the top three. Keep the pace!'**
  String get leaderboardHintTop;

  /// Leaderboard empty state
  ///
  /// In en, this message translates to:
  /// **'The rating is empty for now'**
  String get leaderboardEmpty;

  /// Leaderboard error state
  ///
  /// In en, this message translates to:
  /// **'Could not load the rating'**
  String get leaderboardError;

  /// Settings section overline
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearanceSection;

  /// Settings accent colour picker label
  ///
  /// In en, this message translates to:
  /// **'Accent'**
  String get settingsAccentLabel;

  /// Settings widget preview row title
  ///
  /// In en, this message translates to:
  /// **'Lock screen widget'**
  String get settingsLockWidget;

  /// Widget preview overline
  ///
  /// In en, this message translates to:
  /// **'NEXT · {time}'**
  String settingsWidgetNext(String time);

  /// Widget preview tag
  ///
  /// In en, this message translates to:
  /// **'preview'**
  String get settingsWidgetPreview;

  /// Widget preview when there is no upcoming lesson
  ///
  /// In en, this message translates to:
  /// **'No classes'**
  String get settingsWidgetNoLesson;

  /// Settings schedule group row
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get settingsGroup;

  /// Settings toggle
  ///
  /// In en, this message translates to:
  /// **'Show past classes'**
  String get settingsShowPast;

  /// Settings toggle subtitle
  ///
  /// In en, this message translates to:
  /// **'Greyed out, below the current one'**
  String get settingsShowPastSub;

  /// Settings toggle
  ///
  /// In en, this message translates to:
  /// **'Show cancelled'**
  String get settingsShowCancelled;

  /// Settings toggle subtitle
  ///
  /// In en, this message translates to:
  /// **'Struck through'**
  String get settingsShowCancelledSub;

  /// Settings toggle
  ///
  /// In en, this message translates to:
  /// **'Only my subgroup'**
  String get settingsOnlySubgroup;

  /// Settings toggle subtitle
  ///
  /// In en, this message translates to:
  /// **'Hides the other subgroup\'s classes'**
  String get settingsOnlySubgroupSub;

  /// Settings row
  ///
  /// In en, this message translates to:
  /// **'Export to calendar'**
  String get settingsExportCalendar;

  /// Settings export action
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get settingsExportSync;

  /// Toast after calendar export
  ///
  /// In en, this message translates to:
  /// **'Schedule added to the calendar'**
  String get settingsExportDone;

  /// Toast when there is nothing to export
  ///
  /// In en, this message translates to:
  /// **'Pick a schedule first'**
  String get settingsExportNoSchedule;

  /// Settings toggle subtitle
  ///
  /// In en, this message translates to:
  /// **'15 minutes before start'**
  String get settingsNotifyLessonsSub;

  /// Settings toggle
  ///
  /// In en, this message translates to:
  /// **'Deadlines'**
  String get settingsNotifyDeadlines;

  /// Settings toggle subtitle
  ///
  /// In en, this message translates to:
  /// **'A day and an hour before'**
  String get settingsNotifyDeadlinesSub;

  /// Settings toggle subtitle
  ///
  /// In en, this message translates to:
  /// **'Important only'**
  String get settingsNotifyNewsSub;

  /// Settings privacy toggle
  ///
  /// In en, this message translates to:
  /// **'Show me to friends'**
  String get settingsShowToFriends;

  /// Settings privacy toggle subtitle
  ///
  /// In en, this message translates to:
  /// **'Only on campus'**
  String get settingsShowToFriendsSub;

  /// Settings privacy toggle
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get settingsGeo;

  /// Settings privacy toggle subtitle
  ///
  /// In en, this message translates to:
  /// **'Map and rooms'**
  String get settingsGeoSub;

  /// Settings sign-out row
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get settingsSignOutFull;

  /// Settings footer
  ///
  /// In en, this message translates to:
  /// **'Version {version} · build {build}'**
  String settingsVersionBuild(String version, String build);

  /// Settings row to the full notifications page
  ///
  /// In en, this message translates to:
  /// **'All notifications'**
  String get settingsAllNotifications;

  /// Friends hero overline
  ///
  /// In en, this message translates to:
  /// **'Shared gaps today'**
  String get friendsCommonWindowsToday;

  /// Friends hero title
  ///
  /// In en, this message translates to:
  /// **'Free time with friends'**
  String get friendsCompareHeroTitle;

  /// Friends hero subtitle
  ///
  /// In en, this message translates to:
  /// **'From your friend’s group schedule'**
  String get friendsCompareHeroSub;

  /// Friends hero action
  ///
  /// In en, this message translates to:
  /// **'Compare'**
  String get friendsCompare;

  /// Friends filter chip
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get friendsFilterAll;

  /// Friends filter chip
  ///
  /// In en, this message translates to:
  /// **'On the map'**
  String get friendsFilterCampus;

  /// Friends privacy card title
  ///
  /// In en, this message translates to:
  /// **'Location sharing is your choice'**
  String get friendsPrivacyTitle;

  /// Friends privacy card subtitle
  ///
  /// In en, this message translates to:
  /// **'Friends see your last shared location. Manage access in map settings; campus and floor detection are unavailable.'**
  String get friendsPrivacySub;

  /// Friends on-campus filter empty state
  ///
  /// In en, this message translates to:
  /// **'No one is sharing a recent location'**
  String get friendsCampusEmpty;

  /// Toast when a friend cannot be messaged
  ///
  /// In en, this message translates to:
  /// **'{name} has no Telegram handle'**
  String friendsNoTelegram(String name);

  /// Friends page error state
  ///
  /// In en, this message translates to:
  /// **'Could not load friends'**
  String get friendsLoadError;

  /// Semantics of the send button
  ///
  /// In en, this message translates to:
  /// **'Message {name}'**
  String friendsMessage(String name);

  /// Abbreviation inside the 'all sources' circle on the news source rail
  ///
  /// In en, this message translates to:
  /// **'ALL'**
  String get newsSourceAllAbbr;

  /// Toast after saving an article
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get articleSaved;

  /// Join community button
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get communitiesJoin;

  /// Services search pill placeholder
  ///
  /// In en, this message translates to:
  /// **'Find a service, room, person'**
  String get servicesSearchPlaceholder;

  /// Services edit-mode banner
  ///
  /// In en, this message translates to:
  /// **'Star the services you want on Home'**
  String get servicesEditBanner;

  /// Semantics of the star toggle when off
  ///
  /// In en, this message translates to:
  /// **'Add to Home'**
  String get servicesFavoriteAdd;

  /// Semantics of the star toggle when on
  ///
  /// In en, this message translates to:
  /// **'Remove from Home'**
  String get servicesFavoriteRemove;

  /// NFC card title when idle
  ///
  /// In en, this message translates to:
  /// **'Open the turnstile'**
  String get servicesNfcOpenTitle;

  /// NFC card title when active
  ///
  /// In en, this message translates to:
  /// **'Hold near the turnstile'**
  String get servicesNfcActiveTitle;

  /// NFC card subtitle when active
  ///
  /// In en, this message translates to:
  /// **'Active for 30 seconds · tap to cancel'**
  String get servicesNfcActiveSub;

  /// NFC card subtitle with the bound pass id
  ///
  /// In en, this message translates to:
  /// **'Pass no. {id}'**
  String servicesNfcPassSub(String id);

  /// NFC card subtitle when no pass is bound
  ///
  /// In en, this message translates to:
  /// **'Pass not connected · tap to connect'**
  String get servicesNfcConnectSub;

  /// NFC card subtitle when the device has no NFC
  ///
  /// In en, this message translates to:
  /// **'NFC is unavailable on this device'**
  String get servicesNfcUnavailableSub;

  /// Services section title
  ///
  /// In en, this message translates to:
  /// **'Campus'**
  String get servicesSectionCampus;

  /// Services section title
  ///
  /// In en, this message translates to:
  /// **'Studies'**
  String get servicesSectionStudy;

  /// Services row title for the NFC pass
  ///
  /// In en, this message translates to:
  /// **'Pass'**
  String get serviceNfcTitle;

  /// Services row title for the session page
  ///
  /// In en, this message translates to:
  /// **'Exams'**
  String get serviceExamsTitle;

  /// Services row title for the marketplace
  ///
  /// In en, this message translates to:
  /// **'Market'**
  String get serviceMarketTitle;

  /// Services row subtitle
  ///
  /// In en, this message translates to:
  /// **'Rooms and routes'**
  String get serviceMapSub;

  /// Services row subtitle
  ///
  /// In en, this message translates to:
  /// **'Free right now'**
  String get serviceRoomsSub;

  /// Services row subtitle
  ///
  /// In en, this message translates to:
  /// **'Seats and booking'**
  String get serviceCoworkSub;

  /// Services row subtitle
  ///
  /// In en, this message translates to:
  /// **'NFC campus pass'**
  String get serviceNfcSub;

  /// Services row subtitle
  ///
  /// In en, this message translates to:
  /// **'Tasks and due dates'**
  String get serviceDeadlinesSub;

  /// Services row subtitle when no exam is scheduled
  ///
  /// In en, this message translates to:
  /// **'Tests and exams'**
  String get serviceExamsSub;

  /// Services row subtitle with days to the nearest exam
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Test today} =1{Test in {count} day} other{Test in {count} days}}'**
  String serviceExamsInDays(int count);

  /// Services row subtitle
  ///
  /// In en, this message translates to:
  /// **'GPA and semester marks'**
  String get serviceGradesSub;

  /// Services row subtitle
  ///
  /// In en, this message translates to:
  /// **'Absences and stats'**
  String get serviceAttendanceSub;

  /// Services row subtitle
  ///
  /// In en, this message translates to:
  /// **'Group notes'**
  String get serviceNotesSub;

  /// Services row subtitle
  ///
  /// In en, this message translates to:
  /// **'Tickets, solutions, cheat sheets'**
  String get serviceKbSub;

  /// Services row subtitle
  ///
  /// In en, this message translates to:
  /// **'Grant and credits'**
  String get serviceToolsSub;

  /// Services row subtitle
  ///
  /// In en, this message translates to:
  /// **'University channels'**
  String get serviceNewsSub;

  /// Services row subtitle
  ///
  /// In en, this message translates to:
  /// **'Clubs and sections'**
  String get serviceCommunitiesSub;

  /// Services row subtitle
  ///
  /// In en, this message translates to:
  /// **'Who is on campus'**
  String get serviceFriendsSub;

  /// Services row subtitle
  ///
  /// In en, this message translates to:
  /// **'Group votes'**
  String get servicePollsSub;

  /// Services row subtitle
  ///
  /// In en, this message translates to:
  /// **'Events this week'**
  String get serviceEventsSub;

  /// Services row subtitle
  ///
  /// In en, this message translates to:
  /// **'Student listings'**
  String get serviceMarketSub;

  /// Services row subtitle
  ///
  /// In en, this message translates to:
  /// **'Found and lost items'**
  String get serviceLostSub;

  /// Services row subtitle
  ///
  /// In en, this message translates to:
  /// **'Balance and grant'**
  String get serviceWalletSub;

  /// Services row subtitle
  ///
  /// In en, this message translates to:
  /// **'Mini apps'**
  String get serviceAppsSub;

  /// Services row subtitle
  ///
  /// In en, this message translates to:
  /// **'Walk around the campus'**
  String get serviceVirtualTourSub;

  /// Services row subtitle
  ///
  /// In en, this message translates to:
  /// **'Classmates and group'**
  String get servicePeopleSub;

  /// Services row subtitle
  ///
  /// In en, this message translates to:
  /// **'Friends on the map'**
  String get serviceFriendsMapSub;

  /// Services row subtitle
  ///
  /// In en, this message translates to:
  /// **'Build a team'**
  String get serviceTeamFinderSub;

  /// Services row subtitle
  ///
  /// In en, this message translates to:
  /// **'Mentors and advice'**
  String get serviceMentorshipSub;

  /// Services row subtitle for external links
  ///
  /// In en, this message translates to:
  /// **'Opens in the browser'**
  String get serviceExternalSub;

  /// Search sheet field placeholder
  ///
  /// In en, this message translates to:
  /// **'Room, subject, person, service'**
  String get searchSheetPlaceholder;

  /// Search sheet empty state
  ///
  /// In en, this message translates to:
  /// **'Nothing found. Try “A-318” or “calculus”.'**
  String get searchSheetNoResults;

  /// Search result kind
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get searchTagSubject;

  /// Search result kind
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get searchTagService;

  /// Search result subtitle for subjects
  ///
  /// In en, this message translates to:
  /// **'in the schedule'**
  String get searchSubjectInSchedule;

  /// Deadlines hero label
  ///
  /// In en, this message translates to:
  /// **'Completed deadlines'**
  String get deadlinesClosedSemester;

  /// Deadlines hero total
  ///
  /// In en, this message translates to:
  /// **'of {total}'**
  String deadlinesOfTotal(int total);

  /// Deadlines group title
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get deadlinesGroupToday;

  /// Deadline row right label when done
  ///
  /// In en, this message translates to:
  /// **'done'**
  String get deadlineLeftDone;

  /// Deadlines info card title
  ///
  /// In en, this message translates to:
  /// **'Shared group deadlines'**
  String get deadlinesSharedTitle;

  /// Deadlines info card body
  ///
  /// In en, this message translates to:
  /// **'The monitor adds one — everyone sees it. {shared} of {total} are shared.'**
  String deadlinesSharedBody(int shared, int total);

  /// Toast after completing a deadline
  ///
  /// In en, this message translates to:
  /// **'Deadline closed'**
  String get deadlineDoneToast;

  /// Undo action
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// Semantics of the + header button
  ///
  /// In en, this message translates to:
  /// **'Add deadline'**
  String get deadlinesAddSemantics;

  /// Add deadline sheet title
  ///
  /// In en, this message translates to:
  /// **'New deadline'**
  String get addDeadlineTitle;

  /// Add deadline title field placeholder
  ///
  /// In en, this message translates to:
  /// **'What to hand in'**
  String get addDeadlineWhatHint;

  /// Add deadline subject label
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get addDeadlineSubject;

  /// Add deadline due label
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get addDeadlineDue;

  /// Add deadline due pill
  ///
  /// In en, this message translates to:
  /// **'Pick a date'**
  String get addDeadlinePickDate;

  /// Add deadline toggle title
  ///
  /// In en, this message translates to:
  /// **'Shared with the group'**
  String get addDeadlineSharedTitle;

  /// Add deadline toggle subtitle with classmates count
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Visible to {count} person} other{Visible to all {count} people}}'**
  String addDeadlineSharedSub(int count);

  /// Add deadline toggle subtitle without a count
  ///
  /// In en, this message translates to:
  /// **'Everyone in the group will see it'**
  String get addDeadlineSharedSubGeneric;

  /// Toast after creating a deadline
  ///
  /// In en, this message translates to:
  /// **'Deadline added · I\'ll remind you a day before'**
  String get addDeadlineToast;

  /// Exams page title
  ///
  /// In en, this message translates to:
  /// **'Assessment'**
  String get examsTitle;

  /// Exams page header meta
  ///
  /// In en, this message translates to:
  /// **'session in {count} d'**
  String examsSessionIn(int count);

  /// Exams hero badge
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Nearest · today} =1{Nearest · in {count} day} other{Nearest · in {count} days}}'**
  String examsNearestIn(int count);

  /// Exams readiness label
  ///
  /// In en, this message translates to:
  /// **'Readiness'**
  String get examsReadiness;

  /// Exams topics section title
  ///
  /// In en, this message translates to:
  /// **'Topics for the test'**
  String get examsTopicsTitle;

  /// Exams topics section hint
  ///
  /// In en, this message translates to:
  /// **'tick what you\'ve covered'**
  String get examsTopicsHint;

  /// Exams topics empty row
  ///
  /// In en, this message translates to:
  /// **'Add topics — readiness is calculated automatically'**
  String get examsTopicsEmpty;

  /// Exams add-topic row and sheet title
  ///
  /// In en, this message translates to:
  /// **'Add topic'**
  String get examsAddTopic;

  /// Exams add-topic field placeholder
  ///
  /// In en, this message translates to:
  /// **'Topic'**
  String get examsTopicHint;

  /// Semantics of the swipe-to-delete on a topic
  ///
  /// In en, this message translates to:
  /// **'Remove topic'**
  String get examsRemoveTopic;

  /// Exams plan section title
  ///
  /// In en, this message translates to:
  /// **'Study plan'**
  String get examsPlanTitle;

  /// Exams plan rebuild action
  ///
  /// In en, this message translates to:
  /// **'rebuild'**
  String get examsPlanRebuild;

  /// Exams plan empty row
  ///
  /// In en, this message translates to:
  /// **'All topics covered — time to rest'**
  String get examsPlanEmpty;

  /// Exams plan row minutes
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String examsPlanMinutes(int count);

  /// Exams list overline
  ///
  /// In en, this message translates to:
  /// **'All assessments'**
  String get examsAllTitle;

  /// Exams day tile unit
  ///
  /// In en, this message translates to:
  /// **'D'**
  String get examsDaysShort;

  /// Semantics of an exam card
  ///
  /// In en, this message translates to:
  /// **'Show {subject}'**
  String examsSelectSemantics(String subject);

  /// Tools page title
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get toolsPageTitle;

  /// Tools tab
  ///
  /// In en, this message translates to:
  /// **'GPA'**
  String get toolsTabGpa;

  /// Tools tab
  ///
  /// In en, this message translates to:
  /// **'Grant'**
  String get toolsTabGrant;

  /// Tools tab
  ///
  /// In en, this message translates to:
  /// **'Credits'**
  String get toolsTabEcts;

  /// Tools tab
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get toolsTabCommunity;

  /// Tools GPA hero label
  ///
  /// In en, this message translates to:
  /// **'GPA forecast for the session'**
  String get toolsGpaForecast;

  /// Tools GPA hint
  ///
  /// In en, this message translates to:
  /// **'Increased grant · 100%'**
  String get toolsGpaHintAllFives;

  /// Tools GPA hint
  ///
  /// In en, this message translates to:
  /// **'Increased grant possible with ≥ 50% fives'**
  String get toolsGpaHintHalfFives;

  /// Tools GPA hint
  ///
  /// In en, this message translates to:
  /// **'There is a three — base grant only'**
  String get toolsGpaHintThree;

  /// Tools marks card hint
  ///
  /// In en, this message translates to:
  /// **'Tap a mark to change it'**
  String get toolsMarksHint;

  /// Tools marks empty state
  ///
  /// In en, this message translates to:
  /// **'Add your group\'s schedule — subjects will appear here'**
  String get toolsMarksEmpty;

  /// Semantics of a mark tile
  ///
  /// In en, this message translates to:
  /// **'{subject}: mark {mark}'**
  String toolsMarkSemantics(String subject, int mark);

  /// Grant row
  ///
  /// In en, this message translates to:
  /// **'Base'**
  String get toolsGrantBase;

  /// Grant row
  ///
  /// In en, this message translates to:
  /// **'Increased · studies'**
  String get toolsGrantStudy;

  /// Grant row
  ///
  /// In en, this message translates to:
  /// **'Increased · science'**
  String get toolsGrantScience;

  /// Grant row
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get toolsGrantSocial;

  /// Grant row value
  ///
  /// In en, this message translates to:
  /// **'no application'**
  String get toolsGrantNoApplication;

  /// Grant row value
  ///
  /// In en, this message translates to:
  /// **'not eligible'**
  String get toolsGrantNotEligible;

  /// Grant toggle row
  ///
  /// In en, this message translates to:
  /// **'Event participation'**
  String get toolsGrantEvent;

  /// Grant toggle row subtitle
  ///
  /// In en, this message translates to:
  /// **'1 per semester is required'**
  String get toolsGrantEventSub;

  /// Money value
  ///
  /// In en, this message translates to:
  /// **'{amount} ₽'**
  String toolsRubles(String amount);

  /// Positive money value
  ///
  /// In en, this message translates to:
  /// **'+{amount} ₽'**
  String toolsRublesPlus(String amount);

  /// Grant note
  ///
  /// In en, this message translates to:
  /// **'The increased grant needs: no threes, ≥ 50% fives and 1 event. Now — {done} of 3: {rest}.'**
  String toolsGrantNote(int done, String rest);

  /// Grant note when everything is done
  ///
  /// In en, this message translates to:
  /// **'The increased grant needs: no threes, ≥ 50% fives and 1 event. All conditions are met — apply.'**
  String get toolsGrantNoteDone;

  /// Grant note remainder
  ///
  /// In en, this message translates to:
  /// **'fix {subject}'**
  String toolsGrantRestThrees(String subject);

  /// Grant note remainder
  ///
  /// In en, this message translates to:
  /// **'more fives needed'**
  String get toolsGrantRestFives;

  /// Grant note remainder
  ///
  /// In en, this message translates to:
  /// **'attend an event'**
  String get toolsGrantRestEvent;

  /// ECTS card label
  ///
  /// In en, this message translates to:
  /// **'Earned this year'**
  String get toolsEctsEarned;

  /// ECTS card value
  ///
  /// In en, this message translates to:
  /// **'{earned} / {total} cr.'**
  String toolsEctsValue(int earned, int total);

  /// ECTS legend item
  ///
  /// In en, this message translates to:
  /// **'{credits} {subject}'**
  String toolsEctsLegend(int credits, String subject);

  /// Polls header meta
  ///
  /// In en, this message translates to:
  /// **'{count} unanswered'**
  String pollsOpenCount(int count);

  /// Poll card author line for own polls
  ///
  /// In en, this message translates to:
  /// **'Your poll'**
  String get pollsAuthorYou;

  /// Poll card author line
  ///
  /// In en, this message translates to:
  /// **'Community poll'**
  String get pollsAuthorCommunity;

  /// Poll status
  ///
  /// In en, this message translates to:
  /// **'closed'**
  String get pollsStatusClosed;

  /// Poll status
  ///
  /// In en, this message translates to:
  /// **'open'**
  String get pollsStatusOpen;

  /// Poll status with deadline
  ///
  /// In en, this message translates to:
  /// **'until {date}'**
  String pollsStatusUntil(String date);

  /// Poll footer suffix
  ///
  /// In en, this message translates to:
  /// **'you answered'**
  String get pollsYouAnswered;

  /// Toast after voting
  ///
  /// In en, this message translates to:
  /// **'Vote counted'**
  String get pollsVoteCounted;

  /// Events filter chip
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get eventsFilterToday;

  /// Events filter chip
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get eventsFilterFree;

  /// Events filter chip
  ///
  /// In en, this message translates to:
  /// **'Going'**
  String get eventsFilterGoing;

  /// Event price pill
  ///
  /// In en, this message translates to:
  /// **'free'**
  String get eventsFreeLabel;

  /// Event attendees count
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} going} other{{count} going}}'**
  String eventsGoingCount(int count);

  /// RSVP pill when going
  ///
  /// In en, this message translates to:
  /// **'Going ✓'**
  String get eventsGoingChecked;

  /// Empty card for the Going filter
  ///
  /// In en, this message translates to:
  /// **'You are not going anywhere yet'**
  String get eventsEmptyGoingTitle;

  /// Empty card subtitle for the Going filter
  ///
  /// In en, this message translates to:
  /// **'Tap “Going” on an event and it will show up here.'**
  String get eventsEmptyGoingSub;

  /// Empty card for the Today filter
  ///
  /// In en, this message translates to:
  /// **'No events today'**
  String get eventsEmptyTodayTitle;

  /// Toast after RSVP
  ///
  /// In en, this message translates to:
  /// **'Added to your plans'**
  String get eventsToastGoing;

  /// Toast after RSVP removal
  ///
  /// In en, this message translates to:
  /// **'Removed from your plans'**
  String get eventsToastRemoved;

  /// Lost and found segment
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get lostFoundTabAll;

  /// Lost and found segment and tag
  ///
  /// In en, this message translates to:
  /// **'Found'**
  String get lostFoundTabFoundShort;

  /// Lost and found segment and tag
  ///
  /// In en, this message translates to:
  /// **'Looking'**
  String get lostFoundTabLostShort;

  /// Security desk info card title
  ///
  /// In en, this message translates to:
  /// **'Security desk'**
  String get lostFoundSecurityTitle;

  /// Security desk info card subtitle
  ///
  /// In en, this message translates to:
  /// **'Give found documents or valuables to a security staff member'**
  String get lostFoundSecuritySub;

  /// Empty list for the All segment
  ///
  /// In en, this message translates to:
  /// **'No listings yet'**
  String get lostFoundEmptyAll;

  /// Send button semantics
  ///
  /// In en, this message translates to:
  /// **'Contact {name}'**
  String lostFoundContactAuthor(String name);

  /// Wallet balance card overline
  ///
  /// In en, this message translates to:
  /// **'Shuriken balance'**
  String get walletBalanceTitle;

  /// Wallet balance card action
  ///
  /// In en, this message translates to:
  /// **'Top up'**
  String get walletTopUp;

  /// Top-up sheet subtitle
  ///
  /// In en, this message translates to:
  /// **'how to earn shurikens'**
  String get walletTopUpSubtitle;

  /// Wallet summary card
  ///
  /// In en, this message translates to:
  /// **'Income this month'**
  String get walletIncomeMonth;

  /// Wallet summary card
  ///
  /// In en, this message translates to:
  /// **'Spent this month'**
  String get walletSpendMonth;

  /// Wallet summary card subline
  ///
  /// In en, this message translates to:
  /// **'in {month}'**
  String walletForMonth(String month);

  /// Wallet summary card subline
  ///
  /// In en, this message translates to:
  /// **'nothing earned yet'**
  String get walletNoIncome;

  /// Wallet history overline
  ///
  /// In en, this message translates to:
  /// **'Operations'**
  String get walletOperations;

  /// Student card row title
  ///
  /// In en, this message translates to:
  /// **'Pass is active'**
  String get walletPassActive;

  /// Student card row title
  ///
  /// In en, this message translates to:
  /// **'Pass has expired'**
  String get walletPassExpired;

  /// Student card row title
  ///
  /// In en, this message translates to:
  /// **'No pass linked'**
  String get walletPassMissing;

  /// Student card row subtitle
  ///
  /// In en, this message translates to:
  /// **'Student card · until {date}'**
  String walletPassValidUntil(String date);

  /// Student card row subtitle
  ///
  /// In en, this message translates to:
  /// **'Add your student card number in the profile'**
  String get walletPassMissingSub;

  /// Balance card number line
  ///
  /// In en, this message translates to:
  /// **'No. {number}'**
  String walletCardNumber(String number);

  /// Notes filter chip
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get collabNotesFilterAll;

  /// Notes filter chip
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get collabNotesFilterNew;

  /// Notes filter chip
  ///
  /// In en, this message translates to:
  /// **'Mine'**
  String get collabNotesFilterMine;

  /// Notes filter chip
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get collabNotesFilterGroup;

  /// Notes filter chip
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get collabNotesFilterPersonal;

  /// Note kind tile
  ///
  /// In en, this message translates to:
  /// **'LEC'**
  String get collabNotesKindLecture;

  /// Note kind tile
  ///
  /// In en, this message translates to:
  /// **'PRAC'**
  String get collabNotesKindPractice;

  /// Note kind tile
  ///
  /// In en, this message translates to:
  /// **'LAB'**
  String get collabNotesKindLab;

  /// Note kind tile
  ///
  /// In en, this message translates to:
  /// **'DOC'**
  String get collabNotesKindDoc;

  /// Note row subject line
  ///
  /// In en, this message translates to:
  /// **'Personal note'**
  String get collabNotesPersonalLabel;

  /// Note row subject line
  ///
  /// In en, this message translates to:
  /// **'Group note'**
  String get collabNotesGroupLabel;

  /// Notes stats card title
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{You have no notes yet} =1{You maintain {count} note} other{You maintain {count} notes}}'**
  String collabNotesStatsTitle(int count);

  /// Notes stats card subtitle
  ///
  /// In en, this message translates to:
  /// **'Shared notes are visible to the whole group'**
  String get collabNotesStatsSub;

  /// Notes stats card trailing
  ///
  /// In en, this message translates to:
  /// **'{count} new'**
  String collabNotesStatsNew(int count);

  /// Knowledge bank search placeholder
  ///
  /// In en, this message translates to:
  /// **'Subject, tickets, teacher'**
  String get knowledgeSearchHint;

  /// Material downloads count
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} download} other{{count} downloads}}'**
  String knowledgeDownloads(int count);

  /// Material likes
  ///
  /// In en, this message translates to:
  /// **'♥ {count}'**
  String knowledgeLikes(int count);

  /// Material price
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} shuriken} other{{count} shurikens}}'**
  String knowledgePriceShurikens(int count);

  /// Knowledge bank empty search text before the link
  ///
  /// In en, this message translates to:
  /// **'Nothing found. Ask your group — '**
  String get knowledgeEmptySearchText;

  /// Knowledge bank empty search link
  ///
  /// In en, this message translates to:
  /// **'create a request'**
  String get knowledgeCreateRequest;

  /// Shared request text
  ///
  /// In en, this message translates to:
  /// **'Looking for materials: {query}. Does anyone have them?'**
  String knowledgeRequestShareText(String query);

  /// Download icon semantics
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get knowledgeDownload;

  /// Market card action
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get marketWrite;

  /// Market card action for own listings
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get marketManage;

  /// Heart button semantics
  ///
  /// In en, this message translates to:
  /// **'Add to favourites'**
  String get marketFavoriteAdd;

  /// Heart button semantics
  ///
  /// In en, this message translates to:
  /// **'Remove from favourites'**
  String get marketFavoriteRemove;

  /// Accent word inside the login welcome title
  ///
  /// In en, this message translates to:
  /// **'back'**
  String get loginWelcomeBackAccent;

  /// Accent word inside the email sign-in title
  ///
  /// In en, this message translates to:
  /// **'continue'**
  String get authEmailHeaderTitleAccent;

  /// Accent word inside the check-email title
  ///
  /// In en, this message translates to:
  /// **'email'**
  String get authCheckEmailTitleAccent;

  /// Accent word inside the sign-up title
  ///
  /// In en, this message translates to:
  /// **'account'**
  String get authSignUpTitleAccent;

  /// Accent word inside the password reset title
  ///
  /// In en, this message translates to:
  /// **'reset'**
  String get authPasswordResetTitleAccent;

  /// Subtitle of the email sign-in step
  ///
  /// In en, this message translates to:
  /// **'We will send a 6-digit code to your email.'**
  String get authEmailHeaderSubtitle;

  /// Attendance chart section title on the lesson page
  ///
  /// In en, this message translates to:
  /// **'Group attendance'**
  String get lessonAttendanceTitle;

  /// Meta label for the attendance chart on the lesson page
  ///
  /// In en, this message translates to:
  /// **'last 5'**
  String get lessonAttendanceMeta;

  /// Lesson actions sheet row that hides the lesson
  ///
  /// In en, this message translates to:
  /// **'Hide from schedule'**
  String get scheduleActionHide;

  /// Teacher sheet stat label for the office room
  ///
  /// In en, this message translates to:
  /// **'office'**
  String get scheduleTeacherRoom;

  /// No description provided for @roomLocalPlanHint.
  ///
  /// In en, this message translates to:
  /// **'A personal note on this device. It does not reserve the room or guarantee a free seat.'**
  String get roomLocalPlanHint;

  /// No description provided for @roomAvailabilityUnknown.
  ///
  /// In en, this message translates to:
  /// **'Current availability is unknown'**
  String get roomAvailabilityUnknown;

  /// No description provided for @roomRemoveSaved.
  ///
  /// In en, this message translates to:
  /// **'Remove saved place'**
  String get roomRemoveSaved;

  /// No description provided for @mapFriendsOutdoorHint.
  ///
  /// In en, this message translates to:
  /// **'Friends are shown on the campus map. Indoor positions and floors are unknown.'**
  String get mapFriendsOutdoorHint;

  /// No description provided for @coworkLocalPlanHint.
  ///
  /// In en, this message translates to:
  /// **'A personal plan, not a reservation. The layout is schematic; seat availability and queues are not checked.'**
  String get coworkLocalPlanHint;

  /// No description provided for @coworkLocalPlan.
  ///
  /// In en, this message translates to:
  /// **'Personal plan'**
  String get coworkLocalPlan;

  /// No description provided for @coworkSaveError.
  ///
  /// In en, this message translates to:
  /// **'Could not save. Please try again.'**
  String get coworkSaveError;

  /// No description provided for @coworkClosed.
  ///
  /// In en, this message translates to:
  /// **'Choose a seat between 08:00 and 22:00'**
  String get coworkClosed;

  /// No description provided for @communitiesSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get communitiesSave;

  /// No description provided for @communitiesSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get communitiesSaved;

  /// No description provided for @communitiesSavedEmpty.
  ///
  /// In en, this message translates to:
  /// **'Save a community to see it here'**
  String get communitiesSavedEmpty;

  /// No description provided for @homeTrendingEmpty.
  ///
  /// In en, this message translates to:
  /// **'No discussions yet'**
  String get homeTrendingEmpty;

  /// No description provided for @homeFavoritesEmpty.
  ///
  /// In en, this message translates to:
  /// **'Choose quick actions in Services'**
  String get homeFavoritesEmpty;

  /// No description provided for @onboardingFriendsSharingSub.
  ///
  /// In en, this message translates to:
  /// **'Share your location with friends'**
  String get onboardingFriendsSharingSub;

  /// No description provided for @onboardingGeoSystemSettings.
  ///
  /// In en, this message translates to:
  /// **'Location access can be turned off in system settings'**
  String get onboardingGeoSystemSettings;

  /// No description provided for @toolsLocalEstimate.
  ///
  /// In en, this message translates to:
  /// **'Personal estimate saved on this device. Check scholarship amounts and eligibility with your university.'**
  String get toolsLocalEstimate;

  /// No description provided for @toolsNoValue.
  ///
  /// In en, this message translates to:
  /// **'not entered'**
  String get toolsNoValue;

  /// No description provided for @toolsGpaPersonal.
  ///
  /// In en, this message translates to:
  /// **'Your forecast, not an official grade record'**
  String get toolsGpaPersonal;

  /// No description provided for @toolsEctsTarget.
  ///
  /// In en, this message translates to:
  /// **'Credit target'**
  String get toolsEctsTarget;

  /// No description provided for @personalRecordsNotice.
  ///
  /// In en, this message translates to:
  /// **'Personal records on this device. Not official university data.'**
  String get personalRecordsNotice;

  /// No description provided for @attendanceEstimateNotice.
  ///
  /// In en, this message translates to:
  /// **'Attendance is estimated from the schedule and your logged absences, not verified presence.'**
  String get attendanceEstimateNotice;

  /// No description provided for @gradesScholarshipDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'GPA reference: 4.75. This does not establish scholarship eligibility.'**
  String get gradesScholarshipDisclaimer;

  /// No description provided for @profileLocalFieldsNote.
  ///
  /// In en, this message translates to:
  /// **'About and Telegram are saved only on this device and are not visible to other users.'**
  String get profileLocalFieldsNote;

  /// No description provided for @articleSourceChannel.
  ///
  /// In en, this message translates to:
  /// **'News source'**
  String get articleSourceChannel;

  /// No description provided for @deadlineSaved.
  ///
  /// In en, this message translates to:
  /// **'Deadline added'**
  String get deadlineSaved;

  /// No description provided for @scheduleLinkUnavailable.
  ///
  /// In en, this message translates to:
  /// **'A link to this schedule is not available yet. Share text, an image or a calendar instead.'**
  String get scheduleLinkUnavailable;

  /// No description provided for @scheduleReminderLocked.
  ///
  /// In en, this message translates to:
  /// **'This reminder is already scheduled. Changing or cancelling it is not available yet.'**
  String get scheduleReminderLocked;

  /// No description provided for @settingsAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced settings'**
  String get settingsAdvanced;

  /// No description provided for @settingsLessonReactionsSub.
  ///
  /// In en, this message translates to:
  /// **'Reactions next to classes'**
  String get settingsLessonReactionsSub;

  /// No description provided for @settingsWidgetRefreshRequested.
  ///
  /// In en, this message translates to:
  /// **'Refresh requested'**
  String get settingsWidgetRefreshRequested;

  /// No description provided for @identityHandleCheckError.
  ///
  /// In en, this message translates to:
  /// **'Could not check the username. Try again'**
  String get identityHandleCheckError;

  /// No description provided for @authPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPasswordLabel;

  /// No description provided for @authConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get authConfirmPasswordLabel;

  /// No description provided for @settingsWidgetUnsupported.
  ///
  /// In en, this message translates to:
  /// **'The schedule widget is available on Android'**
  String get settingsWidgetUnsupported;

  /// No description provided for @miniAppsReportFailure.
  ///
  /// In en, this message translates to:
  /// **'Could not send the report. Try again.'**
  String get miniAppsReportFailure;

  /// No description provided for @miniAppsRevRestoreFailure.
  ///
  /// In en, this message translates to:
  /// **'Could not restore this version. Try again.'**
  String get miniAppsRevRestoreFailure;

  /// No description provided for @miniAppsTokensFailure.
  ///
  /// In en, this message translates to:
  /// **'Could not update deployment tokens. Try again.'**
  String get miniAppsTokensFailure;

  /// No description provided for @nfcPassMediaUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Background unavailable. Select another file.'**
  String get nfcPassMediaUnavailable;

  /// No description provided for @lessonPairOrdinal.
  ///
  /// In en, this message translates to:
  /// **'Period {number}'**
  String lessonPairOrdinal(int number);

  /// No description provided for @lessonFileKilobytes.
  ///
  /// In en, this message translates to:
  /// **'{size} KB'**
  String lessonFileKilobytes(String size);

  /// No description provided for @lessonFileMegabytes.
  ///
  /// In en, this message translates to:
  /// **'{size} MB'**
  String lessonFileMegabytes(String size);

  /// No description provided for @scheduleShortCancelled.
  ///
  /// In en, this message translates to:
  /// **'CANC'**
  String get scheduleShortCancelled;

  /// No description provided for @pollsCreateError.
  ///
  /// In en, this message translates to:
  /// **'Could not create the poll. Try again.'**
  String get pollsCreateError;

  /// No description provided for @knowledgeUploadError.
  ///
  /// In en, this message translates to:
  /// **'Could not upload the material. Try again.'**
  String get knowledgeUploadError;

  /// No description provided for @knowledgeFileError.
  ///
  /// In en, this message translates to:
  /// **'Could not read this file. Choose a file up to 50 MB.'**
  String get knowledgeFileError;

  /// No description provided for @postDetailCommentsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load comments'**
  String get postDetailCommentsLoadError;

  /// No description provided for @scheduleNoteChecklist.
  ///
  /// In en, this message translates to:
  /// **'Checklist'**
  String get scheduleNoteChecklist;

  /// No description provided for @servicesSectionFirstParty.
  ///
  /// In en, this message translates to:
  /// **'Built for campus'**
  String get servicesSectionFirstParty;

  /// No description provided for @knowledgeSubjectsTitle.
  ///
  /// In en, this message translates to:
  /// **'Subjects'**
  String get knowledgeSubjectsTitle;

  /// No description provided for @knowledgeSubjectsHint.
  ///
  /// In en, this message translates to:
  /// **'Select up to 10 subjects'**
  String get knowledgeSubjectsHint;

  /// No description provided for @knowledgeSubjectsSearch.
  ///
  /// In en, this message translates to:
  /// **'Search subjects'**
  String get knowledgeSubjectsSearch;

  /// No description provided for @knowledgeSubjectsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load subjects'**
  String get knowledgeSubjectsLoadError;

  /// No description provided for @knowledgeSubjectsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No subjects found'**
  String get knowledgeSubjectsEmpty;

  /// No description provided for @knowledgeSubjectsApply.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get knowledgeSubjectsApply;

  /// No description provided for @knowledgeSubjectsFilter.
  ///
  /// In en, this message translates to:
  /// **'Select subjects'**
  String get knowledgeSubjectsFilter;

  /// No description provided for @knowledgeUploadSuccess.
  ///
  /// In en, this message translates to:
  /// **'Material published'**
  String get knowledgeUploadSuccess;

  /// No description provided for @exportSelectedDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get exportSelectedDay;

  /// No description provided for @exportImagePreview.
  ///
  /// In en, this message translates to:
  /// **'Image preview'**
  String get exportImagePreview;

  /// No description provided for @exportImagePages.
  ///
  /// In en, this message translates to:
  /// **'{count} pages · PNG'**
  String exportImagePages(int count);

  /// No description provided for @exportImageHint.
  ///
  /// In en, this message translates to:
  /// **'The full schedule with dates, teachers and rooms. Longer periods are split into pages.'**
  String get exportImageHint;

  /// No description provided for @exportCalendarSafeHint.
  ///
  /// In en, this message translates to:
  /// **'Classes go into a separate calendar. Personal events stay untouched; exporting again updates our entries.'**
  String get exportCalendarSafeHint;

  /// No description provided for @exportCalendarMobileOnly.
  ///
  /// In en, this message translates to:
  /// **'The system calendar is available on mobile. Use an .ics file on this device.'**
  String get exportCalendarMobileOnly;

  /// No description provided for @reminderTimeInvalid.
  ///
  /// In en, this message translates to:
  /// **'Choose a future time before the class starts.'**
  String get reminderTimeInvalid;

  /// No description provided for @compareDayView.
  ///
  /// In en, this message translates to:
  /// **'By day'**
  String get compareDayView;

  /// No description provided for @compareWeekView.
  ///
  /// In en, this message translates to:
  /// **'Week overview'**
  String get compareWeekView;

  /// No description provided for @compareWindowsTitle.
  ///
  /// In en, this message translates to:
  /// **'Time to meet'**
  String get compareWindowsTitle;

  /// No description provided for @compareNoWindows.
  ///
  /// In en, this message translates to:
  /// **'No shared gaps of at least 30 minutes between classes'**
  String get compareNoWindows;

  /// No description provided for @compareWindowsHint.
  ///
  /// In en, this message translates to:
  /// **'Includes classes and events. Gaps are shown only between them.'**
  String get compareWindowsHint;

  /// No description provided for @compareChangeSchedule.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get compareChangeSchedule;

  /// No description provided for @authGuestUpgradeTitle.
  ///
  /// In en, this message translates to:
  /// **'Save your guest account'**
  String get authGuestUpgradeTitle;

  /// No description provided for @authGuestUpgradeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Link an email to keep your schedule, settings and progress.'**
  String get authGuestUpgradeSubtitle;

  /// No description provided for @authGuestUpgradeSendCode.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get authGuestUpgradeSendCode;

  /// No description provided for @authGuestUpgradeVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify email'**
  String get authGuestUpgradeVerify;

  /// No description provided for @authGuestUpgradePassword.
  ///
  /// In en, this message translates to:
  /// **'Set password'**
  String get authGuestUpgradePassword;

  /// No description provided for @authGuestUpgradeDone.
  ///
  /// In en, this message translates to:
  /// **'Account saved'**
  String get authGuestUpgradeDone;

  /// No description provided for @authGuestUpgradeError.
  ///
  /// In en, this message translates to:
  /// **'Could not save the account. Check your details and try again.'**
  String get authGuestUpgradeError;

  /// No description provided for @authGuestExitWarning.
  ///
  /// In en, this message translates to:
  /// **'Signing out permanently loses access to this guest account. Link an email first to keep your data.'**
  String get authGuestExitWarning;

  /// No description provided for @settingsColorCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom color'**
  String get settingsColorCustom;

  /// No description provided for @settingsColorHex.
  ///
  /// In en, this message translates to:
  /// **'HEX'**
  String get settingsColorHex;

  /// No description provided for @settingsColorHue.
  ///
  /// In en, this message translates to:
  /// **'Hue'**
  String get settingsColorHue;

  /// No description provided for @settingsColorSaturation.
  ///
  /// In en, this message translates to:
  /// **'Saturation'**
  String get settingsColorSaturation;

  /// No description provided for @settingsColorBrightness.
  ///
  /// In en, this message translates to:
  /// **'Brightness'**
  String get settingsColorBrightness;

  /// No description provided for @friendsInviteMessage.
  ///
  /// In en, this message translates to:
  /// **'Join me on University Ninja! Install the app to open this invitation and add me as a friend:\n{link}'**
  String friendsInviteMessage(String link);

  /// No description provided for @scheduleSimultaneousLessons.
  ///
  /// In en, this message translates to:
  /// **'{count} simultaneous classes'**
  String scheduleSimultaneousLessons(int count);

  /// No description provided for @authAnyEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Use any email address you own.'**
  String get authAnyEmailHint;

  /// No description provided for @exportCalendarIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Some events have no end time. Choose PNG, text or .ics to keep everything.'**
  String get exportCalendarIncomplete;

  /// No description provided for @exportUnscheduledEventsHint.
  ///
  /// In en, this message translates to:
  /// **'Events without a time remain in images and text. Calendars include only timed or explicitly all-day events.'**
  String get exportUnscheduledEventsHint;

  /// No description provided for @exportAllDay.
  ///
  /// In en, this message translates to:
  /// **'All day'**
  String get exportAllDay;

  /// No description provided for @exportEntriesCount.
  ///
  /// In en, this message translates to:
  /// **'Events: {count}'**
  String exportEntriesCount(int count);

  /// No description provided for @knowledgePurchaseTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock material?'**
  String get knowledgePurchaseTitle;

  /// No description provided for @knowledgePurchaseBody.
  ///
  /// In en, this message translates to:
  /// **'Unlock “{title}” for {price}. Shurikens are charged once; reopening is free.'**
  String knowledgePurchaseBody(String title, String price);

  /// No description provided for @knowledgePurchaseConfirm.
  ///
  /// In en, this message translates to:
  /// **'Unlock and open'**
  String get knowledgePurchaseConfirm;

  /// No description provided for @knowledgePurchaseFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not unlock the material. Check your balance and try again.'**
  String get knowledgePurchaseFailed;

  /// No description provided for @knowledgePurchasePriceChanged.
  ///
  /// In en, this message translates to:
  /// **'The price changed. Open the material again to confirm the new price.'**
  String get knowledgePurchasePriceChanged;

  /// No description provided for @knowledgePurchaseInsufficient.
  ///
  /// In en, this message translates to:
  /// **'Not enough shurikens'**
  String get knowledgePurchaseInsufficient;

  /// Media viewer page counter
  ///
  /// In en, this message translates to:
  /// **'{index} / {total}'**
  String mediaViewerIndex(int index, int total);

  /// No description provided for @mediaViewerDownloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading'**
  String get mediaViewerDownloading;

  /// No description provided for @mediaViewerOpenExternally.
  ///
  /// In en, this message translates to:
  /// **'Open externally'**
  String get mediaViewerOpenExternally;

  /// No description provided for @mediaViewerDownloadFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t download the file'**
  String get mediaViewerDownloadFailed;

  /// No description provided for @mediaViewerSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get mediaViewerSaved;

  /// Home trending row meta
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} like} other{{count} likes}}'**
  String homeLikesCount(int count);

  /// No description provided for @teamFinderCreateOtherRole.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get teamFinderCreateOtherRole;

  /// No description provided for @teamFinderCreateCustomRoleLabel.
  ///
  /// In en, this message translates to:
  /// **'CUSTOM ROLE'**
  String get teamFinderCreateCustomRoleLabel;

  /// No description provided for @teamFinderCreateCustomRoleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. DevOps, Analyst'**
  String get teamFinderCreateCustomRoleHint;

  /// No description provided for @teamFinderCreateCustomRoleHelper.
  ///
  /// In en, this message translates to:
  /// **'Comma-separated adds several roles'**
  String get teamFinderCreateCustomRoleHelper;

  /// No description provided for @teamFinderCreateTitleError.
  ///
  /// In en, this message translates to:
  /// **'Enter a team name'**
  String get teamFinderCreateTitleError;

  /// No description provided for @teamFinderCreateRolesError.
  ///
  /// In en, this message translates to:
  /// **'Pick at least one role'**
  String get teamFinderCreateRolesError;

  /// No description provided for @teamFinderCreateDeadlinePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Pick a date'**
  String get teamFinderCreateDeadlinePlaceholder;

  /// No description provided for @teamFinderRemoveDeadline.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get teamFinderRemoveDeadline;

  /// No description provided for @teamFinderCreateBoostInsufficient.
  ///
  /// In en, this message translates to:
  /// **'Need 50 shurikens, you have {balance}'**
  String teamFinderCreateBoostInsufficient(int balance);

  /// No description provided for @teamFinderEditSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit team'**
  String get teamFinderEditSheetTitle;

  /// No description provided for @teamFinderSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get teamFinderSaveChanges;

  /// No description provided for @teamFinderSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get teamFinderSaving;

  /// No description provided for @teamFinderUpdateError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save changes'**
  String get teamFinderUpdateError;

  /// No description provided for @teamFinderTeamUpdated.
  ///
  /// In en, this message translates to:
  /// **'Changes saved'**
  String get teamFinderTeamUpdated;

  /// No description provided for @teamFinderEditTeam.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get teamFinderEditTeam;

  /// No description provided for @teamFinderCloseTeam.
  ///
  /// In en, this message translates to:
  /// **'Close recruiting'**
  String get teamFinderCloseTeam;

  /// No description provided for @teamFinderReopenTeam.
  ///
  /// In en, this message translates to:
  /// **'Reopen recruiting'**
  String get teamFinderReopenTeam;

  /// No description provided for @teamFinderCloseConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Close recruiting for this team?'**
  String get teamFinderCloseConfirmTitle;

  /// No description provided for @teamFinderCloseConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'The team will disappear from search. Reopen it anytime from «Mine».'**
  String get teamFinderCloseConfirmBody;

  /// No description provided for @teamFinderCloseError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t close recruiting'**
  String get teamFinderCloseError;

  /// No description provided for @teamFinderClosedStatus.
  ///
  /// In en, this message translates to:
  /// **'Recruiting closed'**
  String get teamFinderClosedStatus;

  /// No description provided for @teamFinderSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Team, role, event…'**
  String get teamFinderSearchHint;

  /// No description provided for @teamFinderSearchEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing found'**
  String get teamFinderSearchEmptyTitle;

  /// No description provided for @teamFinderSearchEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try another query or filter'**
  String get teamFinderSearchEmptySubtitle;

  /// No description provided for @teamFinderRolesFilterLabel.
  ///
  /// In en, this message translates to:
  /// **'ROLES'**
  String get teamFinderRolesFilterLabel;

  /// No description provided for @collabNotesSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search notes'**
  String get collabNotesSearchHint;

  /// No description provided for @collabNotesActionRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get collabNotesActionRename;

  /// No description provided for @collabNotesActionVisibility.
  ///
  /// In en, this message translates to:
  /// **'Change visibility'**
  String get collabNotesActionVisibility;

  /// No description provided for @collabNotesRenameTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename note'**
  String get collabNotesRenameTitle;

  /// No description provided for @collabNotesRenameHint.
  ///
  /// In en, this message translates to:
  /// **'Note title'**
  String get collabNotesRenameHint;

  /// No description provided for @collabNotesRenameError.
  ///
  /// In en, this message translates to:
  /// **'Could not rename the note'**
  String get collabNotesRenameError;

  /// No description provided for @collabNotesVisibilityTitle.
  ///
  /// In en, this message translates to:
  /// **'Note visibility'**
  String get collabNotesVisibilityTitle;

  /// No description provided for @collabNotesVisibilityError.
  ///
  /// In en, this message translates to:
  /// **'Could not change visibility'**
  String get collabNotesVisibilityError;

  /// No description provided for @collabNotesReadOnlyBanner.
  ///
  /// In en, this message translates to:
  /// **'View only — you can\'t edit this note'**
  String get collabNotesReadOnlyBanner;

  /// No description provided for @collabNotesOfflineStatus.
  ///
  /// In en, this message translates to:
  /// **'No connection — will save later'**
  String get collabNotesOfflineStatus;

  /// No description provided for @collabNotesConflictResolved.
  ///
  /// In en, this message translates to:
  /// **'Merged changes from another editor'**
  String get collabNotesConflictResolved;

  /// No description provided for @collabNotesCollaboratorsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Note collaborators'**
  String get collabNotesCollaboratorsTooltip;

  /// No description provided for @noteToolbarFormat.
  ///
  /// In en, this message translates to:
  /// **'Formatting'**
  String get noteToolbarFormat;

  /// No description provided for @noteToolbarInsert.
  ///
  /// In en, this message translates to:
  /// **'Insert'**
  String get noteToolbarInsert;

  /// No description provided for @noteLinkInvalidUrl.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid link'**
  String get noteLinkInvalidUrl;

  /// No description provided for @noteDrawingStylusOnly.
  ///
  /// In en, this message translates to:
  /// **'Stylus only'**
  String get noteDrawingStylusOnly;

  /// No description provided for @noteDrawingTouchDraw.
  ///
  /// In en, this message translates to:
  /// **'Draw with touch'**
  String get noteDrawingTouchDraw;

  /// No description provided for @noteDrawingResetView.
  ///
  /// In en, this message translates to:
  /// **'Fit canvas'**
  String get noteDrawingResetView;

  /// No description provided for @noteDrawingColor.
  ///
  /// In en, this message translates to:
  /// **'Color {index}'**
  String noteDrawingColor(int index);

  /// No description provided for @noteDrawingSaveError.
  ///
  /// In en, this message translates to:
  /// **'Could not save drawing'**
  String get noteDrawingSaveError;

  /// No description provided for @noteTextToolsTitle.
  ///
  /// In en, this message translates to:
  /// **'Text actions'**
  String get noteTextToolsTitle;

  /// No description provided for @noteTextToolsDescription.
  ///
  /// In en, this message translates to:
  /// **'Selected text will be sent to the app you choose. Translation and processing depend on the apps installed on your device.'**
  String get noteTextToolsDescription;

  /// No description provided for @noteTextToolsSelectText.
  ///
  /// In en, this message translates to:
  /// **'Select text in your note first'**
  String get noteTextToolsSelectText;

  /// No description provided for @noteTextToolsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'No compatible apps found. You can copy or share the text.'**
  String get noteTextToolsUnavailable;

  /// No description provided for @noteTextToolsLoading.
  ///
  /// In en, this message translates to:
  /// **'Finding apps…'**
  String get noteTextToolsLoading;

  /// No description provided for @noteTextToolsWorking.
  ///
  /// In en, this message translates to:
  /// **'Waiting for the result…'**
  String get noteTextToolsWorking;

  /// No description provided for @noteTextToolsFailure.
  ///
  /// In en, this message translates to:
  /// **'Could not process the text'**
  String get noteTextToolsFailure;

  /// No description provided for @noteTextToolsNoResult.
  ///
  /// In en, this message translates to:
  /// **'The app did not return modified text'**
  String get noteTextToolsNoResult;

  /// No description provided for @noteTextToolsPreview.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get noteTextToolsPreview;

  /// No description provided for @noteTextToolsApply.
  ///
  /// In en, this message translates to:
  /// **'Replace selected text'**
  String get noteTextToolsApply;

  /// No description provided for @noteTextToolsChanged.
  ///
  /// In en, this message translates to:
  /// **'The note or selection changed. You can copy the result.'**
  String get noteTextToolsChanged;

  /// No description provided for @noteTextToolsReadOnly.
  ///
  /// In en, this message translates to:
  /// **'This note is read-only'**
  String get noteTextToolsReadOnly;

  /// No description provided for @noteTextToolsCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get noteTextToolsCopy;

  /// No description provided for @noteTextToolsShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get noteTextToolsShare;

  /// No description provided for @noteTextToolsCopied.
  ///
  /// In en, this message translates to:
  /// **'Text copied'**
  String get noteTextToolsCopied;

  /// No description provided for @noteSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Find in note'**
  String get noteSearchHint;

  /// No description provided for @noteSearchNoMatches.
  ///
  /// In en, this message translates to:
  /// **'No matches'**
  String get noteSearchNoMatches;

  /// No description provided for @noteSearchPrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous match'**
  String get noteSearchPrevious;

  /// No description provided for @noteSearchNext.
  ///
  /// In en, this message translates to:
  /// **'Next match'**
  String get noteSearchNext;

  /// No description provided for @noteOutlineTitle.
  ///
  /// In en, this message translates to:
  /// **'Outline'**
  String get noteOutlineTitle;

  /// No description provided for @noteOutlineEmpty.
  ///
  /// In en, this message translates to:
  /// **'Add headings using formatting to see them here.'**
  String get noteOutlineEmpty;

  /// No description provided for @noteReadingMode.
  ///
  /// In en, this message translates to:
  /// **'Reading mode'**
  String get noteReadingMode;

  /// No description provided for @noteEditingMode.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get noteEditingMode;

  /// No description provided for @noteExportDocument.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get noteExportDocument;

  /// No description provided for @noteExportAttachment.
  ///
  /// In en, this message translates to:
  /// **'Attachment'**
  String get noteExportAttachment;

  /// No description provided for @noteExportError.
  ///
  /// In en, this message translates to:
  /// **'Could not prepare or share the document'**
  String get noteExportError;

  /// No description provided for @noteRecoveryConflict.
  ///
  /// In en, this message translates to:
  /// **'This device has an unsaved draft. The server version has also changed.'**
  String get noteRecoveryConflict;

  /// No description provided for @noteRecoveryReview.
  ///
  /// In en, this message translates to:
  /// **'Choose a version'**
  String get noteRecoveryReview;

  /// No description provided for @noteRecoveryKeepLocal.
  ///
  /// In en, this message translates to:
  /// **'Keep draft'**
  String get noteRecoveryKeepLocal;

  /// No description provided for @noteRecoveryUseServer.
  ///
  /// In en, this message translates to:
  /// **'Use server version'**
  String get noteRecoveryUseServer;

  /// No description provided for @noteRecoveryBody.
  ///
  /// In en, this message translates to:
  /// **'You are viewing the local draft. You can export it before choosing. Keeping the draft will replace the current server version.'**
  String get noteRecoveryBody;

  /// No description provided for @noteToolbarBold.
  ///
  /// In en, this message translates to:
  /// **'Bold'**
  String get noteToolbarBold;

  /// No description provided for @noteToolbarItalic.
  ///
  /// In en, this message translates to:
  /// **'Italic'**
  String get noteToolbarItalic;

  /// No description provided for @noteToolbarUnderline.
  ///
  /// In en, this message translates to:
  /// **'Underline'**
  String get noteToolbarUnderline;

  /// No description provided for @noteToolbarStrike.
  ///
  /// In en, this message translates to:
  /// **'Strikethrough'**
  String get noteToolbarStrike;

  /// No description provided for @noteToolbarHeading1.
  ///
  /// In en, this message translates to:
  /// **'Heading 1'**
  String get noteToolbarHeading1;

  /// No description provided for @noteToolbarHeading2.
  ///
  /// In en, this message translates to:
  /// **'Heading 2'**
  String get noteToolbarHeading2;

  /// No description provided for @noteToolbarHeading3.
  ///
  /// In en, this message translates to:
  /// **'Heading 3'**
  String get noteToolbarHeading3;

  /// No description provided for @noteToolbarBulletList.
  ///
  /// In en, this message translates to:
  /// **'Bulleted list'**
  String get noteToolbarBulletList;

  /// No description provided for @noteToolbarNumberedList.
  ///
  /// In en, this message translates to:
  /// **'Numbered list'**
  String get noteToolbarNumberedList;

  /// No description provided for @noteToolbarChecklist.
  ///
  /// In en, this message translates to:
  /// **'Checklist'**
  String get noteToolbarChecklist;

  /// No description provided for @noteToolbarQuote.
  ///
  /// In en, this message translates to:
  /// **'Quote'**
  String get noteToolbarQuote;

  /// No description provided for @noteToolbarCodeBlock.
  ///
  /// In en, this message translates to:
  /// **'Code block'**
  String get noteToolbarCodeBlock;

  /// No description provided for @noteToolbarLink.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get noteToolbarLink;

  /// No description provided for @noteToolbarDivider.
  ///
  /// In en, this message translates to:
  /// **'Divider'**
  String get noteToolbarDivider;

  /// No description provided for @noteToolbarColor.
  ///
  /// In en, this message translates to:
  /// **'Text colour'**
  String get noteToolbarColor;

  /// No description provided for @noteToolbarHighlight.
  ///
  /// In en, this message translates to:
  /// **'Highlight'**
  String get noteToolbarHighlight;

  /// No description provided for @noteToolbarImage.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get noteToolbarImage;

  /// No description provided for @noteToolbarDrawing.
  ///
  /// In en, this message translates to:
  /// **'Drawing'**
  String get noteToolbarDrawing;

  /// No description provided for @noteToolbarMic.
  ///
  /// In en, this message translates to:
  /// **'Voice input'**
  String get noteToolbarMic;

  /// No description provided for @noteToolbarUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get noteToolbarUndo;

  /// No description provided for @noteToolbarRedo.
  ///
  /// In en, this message translates to:
  /// **'Redo'**
  String get noteToolbarRedo;

  /// No description provided for @noteColorDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get noteColorDefault;

  /// No description provided for @noteVoicePermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Allow microphone access'**
  String get noteVoicePermissionTitle;

  /// No description provided for @noteVoicePermissionBody.
  ///
  /// In en, this message translates to:
  /// **'We use speech recognition to type your note by voice. Audio is processed on-device or by the system service and isn\'t stored.'**
  String get noteVoicePermissionBody;

  /// No description provided for @noteVoicePermissionAllow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get noteVoicePermissionAllow;

  /// No description provided for @noteVoiceListening.
  ///
  /// In en, this message translates to:
  /// **'Listening…'**
  String get noteVoiceListening;

  /// No description provided for @noteVoiceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Voice input isn\'t available on this device'**
  String get noteVoiceUnavailable;

  /// No description provided for @noteVoiceError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t recognise speech'**
  String get noteVoiceError;

  /// No description provided for @noteVoicePermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Microphone access is denied. Enable it in system settings.'**
  String get noteVoicePermissionDenied;

  /// No description provided for @noteDrawingTitle.
  ///
  /// In en, this message translates to:
  /// **'Drawing'**
  String get noteDrawingTitle;

  /// No description provided for @noteDrawingPen.
  ///
  /// In en, this message translates to:
  /// **'Pen'**
  String get noteDrawingPen;

  /// No description provided for @noteDrawingMarker.
  ///
  /// In en, this message translates to:
  /// **'Marker'**
  String get noteDrawingMarker;

  /// No description provided for @noteDrawingEraser.
  ///
  /// In en, this message translates to:
  /// **'Eraser'**
  String get noteDrawingEraser;

  /// No description provided for @noteDrawingUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo stroke'**
  String get noteDrawingUndo;

  /// No description provided for @noteDrawingRedo.
  ///
  /// In en, this message translates to:
  /// **'Redo stroke'**
  String get noteDrawingRedo;

  /// No description provided for @noteDrawingClear.
  ///
  /// In en, this message translates to:
  /// **'Clear canvas'**
  String get noteDrawingClear;

  /// No description provided for @noteDrawingClearConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear the drawing?'**
  String get noteDrawingClearConfirmTitle;

  /// No description provided for @noteDrawingClearConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This can\'t be undone.'**
  String get noteDrawingClearConfirmBody;

  /// No description provided for @noteDrawingInsert.
  ///
  /// In en, this message translates to:
  /// **'Insert'**
  String get noteDrawingInsert;

  /// No description provided for @noteDrawingWidthThin.
  ///
  /// In en, this message translates to:
  /// **'Thin stroke'**
  String get noteDrawingWidthThin;

  /// No description provided for @noteDrawingWidthMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium stroke'**
  String get noteDrawingWidthMedium;

  /// No description provided for @noteDrawingWidthThick.
  ///
  /// In en, this message translates to:
  /// **'Thick stroke'**
  String get noteDrawingWidthThick;

  /// No description provided for @noteDrawingEmpty.
  ///
  /// In en, this message translates to:
  /// **'Draw something first'**
  String get noteDrawingEmpty;

  /// No description provided for @noteLinkTitle.
  ///
  /// In en, this message translates to:
  /// **'Add link'**
  String get noteLinkTitle;

  /// No description provided for @noteLinkUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'URL'**
  String get noteLinkUrlLabel;

  /// No description provided for @noteLinkUrlHint.
  ///
  /// In en, this message translates to:
  /// **'https://example.com'**
  String get noteLinkUrlHint;

  /// No description provided for @noteLinkTextLabel.
  ///
  /// In en, this message translates to:
  /// **'Link text'**
  String get noteLinkTextLabel;

  /// No description provided for @noteLinkTextHint.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get noteLinkTextHint;

  /// No description provided for @noteLinkInsert.
  ///
  /// In en, this message translates to:
  /// **'Add link'**
  String get noteLinkInsert;

  /// No description provided for @noteImageSourceTitle.
  ///
  /// In en, this message translates to:
  /// **'Add image'**
  String get noteImageSourceTitle;

  /// No description provided for @noteImageSourceCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get noteImageSourceCamera;

  /// No description provided for @noteImageSourceGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get noteImageSourceGallery;

  /// No description provided for @noteImageUploadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t upload the image'**
  String get noteImageUploadError;

  /// No description provided for @noteImageUploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading image…'**
  String get noteImageUploading;

  /// No description provided for @serviceWalletShurikensSub.
  ///
  /// In en, this message translates to:
  /// **'Balance and shuriken history'**
  String get serviceWalletShurikensSub;

  /// No description provided for @mentorshipSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Name, group, topic, bio'**
  String get mentorshipSearchHint;

  /// No description provided for @mentorshipSearchEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No one found'**
  String get mentorshipSearchEmptyTitle;

  /// No description provided for @mentorshipSearchEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try a different name or topic'**
  String get mentorshipSearchEmptySubtitle;

  /// No description provided for @mentorshipTopicFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get mentorshipTopicFilterAll;

  /// No description provided for @mentorshipTelegramLabel.
  ///
  /// In en, this message translates to:
  /// **'TELEGRAM'**
  String get mentorshipTelegramLabel;

  /// No description provided for @mentorshipTelegramPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'username'**
  String get mentorshipTelegramPlaceholder;

  /// No description provided for @mentorshipTelegramError.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid Telegram username (5-32 chars: letters, digits, _)'**
  String get mentorshipTelegramError;

  /// No description provided for @mentorshipTelegramButton.
  ///
  /// In en, this message translates to:
  /// **'Telegram'**
  String get mentorshipTelegramButton;

  /// Long-press tooltip on an activity heatmap cell
  ///
  /// In en, this message translates to:
  /// **'{date} · {count, plural, one{{count} action} other{{count} actions}}'**
  String profileActivityTooltip(String date, int count);

  /// Activity heatmap legend, low-intensity side
  ///
  /// In en, this message translates to:
  /// **'less'**
  String get profileActivityLegendLess;

  /// Activity heatmap legend, high-intensity side
  ///
  /// In en, this message translates to:
  /// **'more'**
  String get profileActivityLegendMore;

  /// No description provided for @scheduleLessonLongPressHint.
  ///
  /// In en, this message translates to:
  /// **'Long-press a class to open actions'**
  String get scheduleLessonLongPressHint;

  /// No description provided for @settingsColorHexInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid hex code'**
  String get settingsColorHexInvalid;

  /// No description provided for @deadlinesViewList.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get deadlinesViewList;

  /// No description provided for @deadlinesViewCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get deadlinesViewCalendar;

  /// No description provided for @deadlinesGroupOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get deadlinesGroupOverdue;

  /// No description provided for @deadlinesGroupTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get deadlinesGroupTomorrow;

  /// No description provided for @deadlinesGroupDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get deadlinesGroupDone;

  /// No description provided for @deadlinesOverdueBanner.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} deadline is overdue} other{{count} deadlines are overdue}}'**
  String deadlinesOverdueBanner(int count);

  /// No description provided for @deadlinesPostponeAction.
  ///
  /// In en, this message translates to:
  /// **'Move to tomorrow'**
  String get deadlinesPostponeAction;

  /// No description provided for @deadlinesPostponedToast.
  ///
  /// In en, this message translates to:
  /// **'Moved to tomorrow'**
  String get deadlinesPostponedToast;

  /// No description provided for @deadlinesPostponeError.
  ///
  /// In en, this message translates to:
  /// **'Failed to move deadlines. Try again.'**
  String get deadlinesPostponeError;

  /// No description provided for @deadlineDeleteSemantics.
  ///
  /// In en, this message translates to:
  /// **'Delete deadline'**
  String get deadlineDeleteSemantics;

  /// No description provided for @deadlineDeletedToast.
  ///
  /// In en, this message translates to:
  /// **'Deadline deleted'**
  String get deadlineDeletedToast;

  /// No description provided for @deadlineDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete the deadline. Try again.'**
  String get deadlineDeleteError;

  /// No description provided for @deadlineActionDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get deadlineActionDuplicate;

  /// No description provided for @deadlineEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit deadline'**
  String get deadlineEditTitle;

  /// No description provided for @deadlineUpdatedToast.
  ///
  /// In en, this message translates to:
  /// **'Deadline updated'**
  String get deadlineUpdatedToast;

  /// No description provided for @deadlineDuplicatedToast.
  ///
  /// In en, this message translates to:
  /// **'Deadline duplicated'**
  String get deadlineDuplicatedToast;

  /// No description provided for @deadlineProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'PROGRESS'**
  String get deadlineProgressLabel;

  /// No description provided for @deadlineRemindLeadHour.
  ///
  /// In en, this message translates to:
  /// **'1 hour before'**
  String get deadlineRemindLeadHour;

  /// No description provided for @deadlineRemindLeadDay.
  ///
  /// In en, this message translates to:
  /// **'1 day before'**
  String get deadlineRemindLeadDay;

  /// No description provided for @deadlinesCalendarDayEmpty.
  ///
  /// In en, this message translates to:
  /// **'No deadlines on this day'**
  String get deadlinesCalendarDayEmpty;

  /// No description provided for @deadlineShareMessage.
  ///
  /// In en, this message translates to:
  /// **'{title} — due {when}'**
  String deadlineShareMessage(Object title, Object when);

  /// No description provided for @deadlineActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get deadlineActionsTitle;

  /// No description provided for @roomPhotoAdd.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get roomPhotoAdd;

  /// No description provided for @roomPhotoUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t upload the photo'**
  String get roomPhotoUploadFailed;

  /// No description provided for @roomPhotoUploaded.
  ///
  /// In en, this message translates to:
  /// **'Photo added'**
  String get roomPhotoUploaded;

  /// No description provided for @roomPhotoDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this photo?'**
  String get roomPhotoDeleteConfirmTitle;

  /// No description provided for @roomPhotoDeleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This can\'t be undone.'**
  String get roomPhotoDeleteConfirmMessage;

  /// No description provided for @roomPhotoDeleted.
  ///
  /// In en, this message translates to:
  /// **'Photo deleted'**
  String get roomPhotoDeleted;

  /// No description provided for @roomPhotoDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t delete the photo'**
  String get roomPhotoDeleteFailed;

  /// No description provided for @roomPhotosOfflineMessage.
  ///
  /// In en, this message translates to:
  /// **'Check your connection to see room photos.'**
  String get roomPhotosOfflineMessage;

  /// Room photo caption: author name and relative upload time
  ///
  /// In en, this message translates to:
  /// **'{author} · {date}'**
  String roomPhotoCaption(Object author, Object date);

  /// No description provided for @marketMediaLabel.
  ///
  /// In en, this message translates to:
  /// **'Photos and video'**
  String get marketMediaLabel;

  /// No description provided for @marketMediaHint.
  ///
  /// In en, this message translates to:
  /// **'Up to 6 photos and 1 video. The first photo is the cover.'**
  String get marketMediaHint;

  /// No description provided for @marketAddPhotoAction.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get marketAddPhotoAction;

  /// No description provided for @marketAddVideoAction.
  ///
  /// In en, this message translates to:
  /// **'Add video'**
  String get marketAddVideoAction;

  /// No description provided for @marketRemoveMediaItem.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get marketRemoveMediaItem;

  /// No description provided for @marketCoverBadge.
  ///
  /// In en, this message translates to:
  /// **'Cover'**
  String get marketCoverBadge;

  /// No description provided for @marketMediaLimitError.
  ///
  /// In en, this message translates to:
  /// **'Up to 6 photos and 1 video are allowed'**
  String get marketMediaLimitError;

  /// No description provided for @marketMediaTypeError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t add this file'**
  String get marketMediaTypeError;

  /// No description provided for @marketVideoTooLong.
  ///
  /// In en, this message translates to:
  /// **'The video is longer than 60 seconds'**
  String get marketVideoTooLong;

  /// No description provided for @marketVideoTooLarge.
  ///
  /// In en, this message translates to:
  /// **'The video is larger than 50 MB'**
  String get marketVideoTooLarge;

  /// No description provided for @marketUploadingMedia.
  ///
  /// In en, this message translates to:
  /// **'Uploading media…'**
  String get marketUploadingMedia;

  /// No description provided for @marketTelegramLabel.
  ///
  /// In en, this message translates to:
  /// **'Telegram'**
  String get marketTelegramLabel;

  /// No description provided for @marketTelegramHint.
  ///
  /// In en, this message translates to:
  /// **'username'**
  String get marketTelegramHint;

  /// No description provided for @marketTelegramRequired.
  ///
  /// In en, this message translates to:
  /// **'Add your Telegram so buyers can reach you'**
  String get marketTelegramRequired;

  /// No description provided for @marketTelegramInvalid.
  ///
  /// In en, this message translates to:
  /// **'5 to 32 characters: latin letters, digits, _'**
  String get marketTelegramInvalid;

  /// No description provided for @marketSortNew.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get marketSortNew;

  /// No description provided for @marketSortCheap.
  ///
  /// In en, this message translates to:
  /// **'Cheapest'**
  String get marketSortCheap;

  /// No description provided for @marketEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit listing'**
  String get marketEditTitle;

  /// No description provided for @marketSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get marketSave;

  /// No description provided for @marketSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get marketSaving;

  /// No description provided for @marketEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get marketEdit;

  /// No description provided for @marketArchive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get marketArchive;

  /// No description provided for @marketArchiveConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Archive this listing?'**
  String get marketArchiveConfirmTitle;

  /// No description provided for @marketArchiveConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'It will disappear from the marketplace, its photos and video will be removed.'**
  String get marketArchiveConfirmBody;

  /// No description provided for @marketArchiveError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t archive the listing'**
  String get marketArchiveError;

  /// No description provided for @marketCreateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Listing published'**
  String get marketCreateSuccess;

  /// No description provided for @marketUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Changes saved'**
  String get marketUpdateSuccess;

  /// No description provided for @marketArchiveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Listing archived'**
  String get marketArchiveSuccess;

  /// No description provided for @marketDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Listing deleted'**
  String get marketDeleteSuccess;

  /// No description provided for @marketShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get marketShare;

  /// No description provided for @marketShareText.
  ///
  /// In en, this message translates to:
  /// **'Check out “{title}” on the marketplace'**
  String marketShareText(Object title);

  /// No description provided for @marketFreeToggleLabel.
  ///
  /// In en, this message translates to:
  /// **'Give away for free'**
  String get marketFreeToggleLabel;

  /// No description provided for @teamFinderTeamCreated.
  ///
  /// In en, this message translates to:
  /// **'Team published'**
  String get teamFinderTeamCreated;

  /// No description provided for @deadlineDueInHours.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{in {count}h} other{in {count}h}}'**
  String deadlineDueInHours(int count);

  /// No description provided for @deadlineDueInDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{in {count} day} other{in {count} days}}'**
  String deadlineDueInDays(int count);

  /// No description provided for @deadlineDueInWeeks.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{in {count} week} other{in {count} weeks}}'**
  String deadlineDueInWeeks(int count);

  /// No description provided for @deadlineOverdueByHours.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{overdue by {count}h} other{overdue by {count}h}}'**
  String deadlineOverdueByHours(int count);

  /// No description provided for @deadlineOverdueByDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{overdue by {count}d} other{overdue by {count}d}}'**
  String deadlineOverdueByDays(int count);

  /// No description provided for @eventsFilterPast.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get eventsFilterPast;

  /// No description provided for @eventsViewList.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get eventsViewList;

  /// No description provided for @eventsViewCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get eventsViewCalendar;

  /// No description provided for @eventsDayYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get eventsDayYesterday;

  /// No description provided for @eventsEmptyPastSub.
  ///
  /// In en, this message translates to:
  /// **'No past events yet'**
  String get eventsEmptyPastSub;

  /// No description provided for @eventsCalendarEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing on this day'**
  String get eventsCalendarEmptyTitle;

  /// No description provided for @eventsMineBadge.
  ///
  /// In en, this message translates to:
  /// **'Yours'**
  String get eventsMineBadge;

  /// No description provided for @eventsCreateEndLabel.
  ///
  /// In en, this message translates to:
  /// **'UNTIL'**
  String get eventsCreateEndLabel;

  /// No description provided for @eventsCreateEndPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'No end time'**
  String get eventsCreateEndPlaceholder;

  /// No description provided for @eventsCreateTitleError.
  ///
  /// In en, this message translates to:
  /// **'Enter a title'**
  String get eventsCreateTitleError;

  /// No description provided for @eventsCreateEndBeforeStartError.
  ///
  /// In en, this message translates to:
  /// **'The event can\'t end before it starts'**
  String get eventsCreateEndBeforeStartError;

  /// No description provided for @eventsEditSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit event'**
  String get eventsEditSheetTitle;

  /// No description provided for @eventsSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get eventsSave;

  /// No description provided for @eventsCreateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Event created'**
  String get eventsCreateSuccess;

  /// No description provided for @eventsUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Changes saved'**
  String get eventsUpdateSuccess;

  /// No description provided for @eventsUpdateError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save changes. Try again'**
  String get eventsUpdateError;

  /// No description provided for @eventsDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete event?'**
  String get eventsDeleteConfirmTitle;

  /// No description provided for @eventsDeleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'It will disappear from the board for everyone'**
  String get eventsDeleteConfirmMessage;

  /// No description provided for @eventsDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Event deleted'**
  String get eventsDeleteSuccess;

  /// No description provided for @eventsDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t delete the event. Try again'**
  String get eventsDeleteError;

  /// No description provided for @eventsEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get eventsEdit;

  /// No description provided for @eventsDetailMap.
  ///
  /// In en, this message translates to:
  /// **'On the map'**
  String get eventsDetailMap;

  /// No description provided for @eventsDetailDescriptionEmpty.
  ///
  /// In en, this message translates to:
  /// **'No description'**
  String get eventsDetailDescriptionEmpty;

  /// Group space search field hint
  ///
  /// In en, this message translates to:
  /// **'Search posts'**
  String get groupSpaceSearchHint;

  /// Group space search empty state title
  ///
  /// In en, this message translates to:
  /// **'Nothing found'**
  String get groupSpaceSearchEmpty;

  /// Group post comments sheet title
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get groupSpaceCommentsTitle;

  /// Group post comments empty state
  ///
  /// In en, this message translates to:
  /// **'No comments yet'**
  String get groupSpaceCommentsEmpty;

  /// Group post comment input hint
  ///
  /// In en, this message translates to:
  /// **'Write a comment…'**
  String get groupSpaceCommentHint;

  /// Send comment button semantics label
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get groupSpaceCommentSend;

  /// Comments count on a group post card
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} comment} other{{count} comments}}'**
  String groupSpaceCommentsCount(int count);

  /// Online member count in the group space hero
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} online} other{{count} online}}'**
  String groupSpaceOnlineCount(int count);

  /// Group space quick action: create announcement
  ///
  /// In en, this message translates to:
  /// **'Announcement'**
  String get groupSpaceQuickAnnouncement;

  /// Group space quick action: open shared notes
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get groupSpaceQuickNote;

  /// Group space quick action: add a link
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get groupSpaceQuickLink;

  /// Expand truncated group post text
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get groupSpaceShowFull;

  /// Collapse expanded group post text
  ///
  /// In en, this message translates to:
  /// **'Collapse'**
  String get groupSpaceCollapse;

  /// Group space collab-notes preview empty state
  ///
  /// In en, this message translates to:
  /// **'No shared notes yet'**
  String get groupSpaceNotesPreviewEmpty;

  /// Group space set-my-birthday CTA title
  ///
  /// In en, this message translates to:
  /// **'Add your birthday'**
  String get groupSpaceSetBirthdayCta;

  /// Group space set-my-birthday CTA subtitle
  ///
  /// In en, this message translates to:
  /// **'Groupmates will see a reminder before it'**
  String get groupSpaceSetBirthdaySubtitle;

  /// Group space set-my-birthday date picker title
  ///
  /// In en, this message translates to:
  /// **'Your birthday'**
  String get groupSpaceSetBirthdayTitle;

  /// Group post composer validation error
  ///
  /// In en, this message translates to:
  /// **'Add a title or a body'**
  String get groupSpacePostEmptyError;

  /// Group post composer pin toggle (owner only)
  ///
  /// In en, this message translates to:
  /// **'Pin to the top'**
  String get groupSpacePostPinToggle;

  /// Transfer study group ownership action
  ///
  /// In en, this message translates to:
  /// **'Make an owner'**
  String get studyGroupTransferOwnership;

  /// Transfer ownership confirm dialog title
  ///
  /// In en, this message translates to:
  /// **'Make an owner?'**
  String get studyGroupTransferOwnershipTitle;

  /// Transfer ownership confirm dialog body
  ///
  /// In en, this message translates to:
  /// **'{name} will manage the group instead of you.'**
  String studyGroupTransferOwnershipBody(Object name);

  /// Study group member row more-actions tooltip
  ///
  /// In en, this message translates to:
  /// **'Member tools'**
  String get studyGroupMemberTools;

  /// No description provided for @knowledgeChipBoard.
  ///
  /// In en, this message translates to:
  /// **'Board photos'**
  String get knowledgeChipBoard;

  /// No description provided for @knowledgeChipExtra.
  ///
  /// In en, this message translates to:
  /// **'Extra'**
  String get knowledgeChipExtra;

  /// No description provided for @knowledgeTypeBoard.
  ///
  /// In en, this message translates to:
  /// **'Board photo'**
  String get knowledgeTypeBoard;

  /// No description provided for @knowledgeTypeExtra.
  ///
  /// In en, this message translates to:
  /// **'Extra material'**
  String get knowledgeTypeExtra;

  /// No description provided for @knowledgeLike.
  ///
  /// In en, this message translates to:
  /// **'Like'**
  String get knowledgeLike;

  /// No description provided for @knowledgeSortNew.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get knowledgeSortNew;

  /// No description provided for @knowledgeSortPopular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get knowledgeSortPopular;

  /// No description provided for @knowledgeSubjectsFilterCount.
  ///
  /// In en, this message translates to:
  /// **'Subjects ({count})'**
  String knowledgeSubjectsFilterCount(int count);

  /// No description provided for @collabNotesKindLabel.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get collabNotesKindLabel;

  /// No description provided for @collabNotesKindLectureFull.
  ///
  /// In en, this message translates to:
  /// **'Lecture'**
  String get collabNotesKindLectureFull;

  /// No description provided for @collabNotesKindPracticeFull.
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get collabNotesKindPracticeFull;

  /// No description provided for @collabNotesKindLabFull.
  ///
  /// In en, this message translates to:
  /// **'Lab work'**
  String get collabNotesKindLabFull;

  /// No description provided for @collabNotesKindDocFull.
  ///
  /// In en, this message translates to:
  /// **'Document'**
  String get collabNotesKindDocFull;

  /// No description provided for @knowledgeBatchAddImages.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get knowledgeBatchAddImages;

  /// No description provided for @knowledgeBatchAddFiles.
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get knowledgeBatchAddFiles;

  /// No description provided for @knowledgeBatchAddCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get knowledgeBatchAddCamera;

  /// No description provided for @knowledgeBatchEmpty.
  ///
  /// In en, this message translates to:
  /// **'Add photos or files to publish them together'**
  String get knowledgeBatchEmpty;

  /// No description provided for @knowledgeBatchStatus.
  ///
  /// In en, this message translates to:
  /// **'Uploaded {done} of {total}'**
  String knowledgeBatchStatus(int done, int total);

  /// No description provided for @knowledgeMaterialDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Material'**
  String get knowledgeMaterialDetailTitle;

  /// No description provided for @knowledgeMaterialShareLink.
  ///
  /// In en, this message translates to:
  /// **'Share link'**
  String get knowledgeMaterialShareLink;

  /// No description provided for @knowledgeMaterialDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get knowledgeMaterialDelete;

  /// No description provided for @knowledgeMaterialDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this material? This can\'t be undone.'**
  String get knowledgeMaterialDeleteConfirm;

  /// No description provided for @knowledgeMaterialDeleted.
  ///
  /// In en, this message translates to:
  /// **'Material deleted'**
  String get knowledgeMaterialDeleted;

  /// No description provided for @knowledgeMaterialDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t delete the material'**
  String get knowledgeMaterialDeleteFailed;

  /// No description provided for @knowledgeMaterialAuthor.
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get knowledgeMaterialAuthor;

  /// No description provided for @knowledgeViewGrid.
  ///
  /// In en, this message translates to:
  /// **'Grid view'**
  String get knowledgeViewGrid;

  /// No description provided for @knowledgeViewList.
  ///
  /// In en, this message translates to:
  /// **'List view'**
  String get knowledgeViewList;

  /// No description provided for @knowledgeMaterialDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get knowledgeMaterialDate;

  /// No description provided for @knowledgeMaterialSize.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get knowledgeMaterialSize;

  /// Polls filter: all
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get pollsFilterAll;

  /// Polls filter: active
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get pollsFilterActive;

  /// Polls filter: closed
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get pollsFilterClosed;

  /// Polls filter: mine
  ///
  /// In en, this message translates to:
  /// **'Mine'**
  String get pollsFilterMine;

  /// Polls filter: completed by me
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get pollsFilterVoted;

  /// Poll category filter: all
  ///
  /// In en, this message translates to:
  /// **'All topics'**
  String get pollsCategoryAll;

  /// Poll category
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get pollsCategoryGeneral;

  /// Poll category
  ///
  /// In en, this message translates to:
  /// **'Academic'**
  String get pollsCategoryAcademic;

  /// Poll category
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get pollsCategoryEvents;

  /// Poll category
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get pollsCategoryFeedback;

  /// Poll category
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get pollsCategoryOther;

  /// Polls search field hint
  ///
  /// In en, this message translates to:
  /// **'Search polls'**
  String get pollsSearchHint;

  /// Poll card author fallback
  ///
  /// In en, this message translates to:
  /// **'Anonymous'**
  String get pollsAuthorAnonymous;

  /// Poll card participants count
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} participant} other{{count} participants}}'**
  String pollsParticipantsCount(int count);

  /// Poll card action to take the poll
  ///
  /// In en, this message translates to:
  /// **'Take'**
  String get pollsTakeAction;

  /// Poll card/results action label
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get pollsResultsAction;

  /// Owner actions sheet title
  ///
  /// In en, this message translates to:
  /// **'Manage poll'**
  String get pollsOwnerActions;

  /// Owner action to close a poll
  ///
  /// In en, this message translates to:
  /// **'Close poll'**
  String get pollsCloseAction;

  /// Close poll confirm dialog title
  ///
  /// In en, this message translates to:
  /// **'Close this poll?'**
  String get pollsCloseConfirmTitle;

  /// Close poll confirm dialog body
  ///
  /// In en, this message translates to:
  /// **'No one will be able to answer after this. This cannot be undone.'**
  String get pollsCloseConfirmBody;

  /// Toast after closing a poll
  ///
  /// In en, this message translates to:
  /// **'Poll closed'**
  String get pollsCloseSuccess;

  /// Toast after failing to close a poll
  ///
  /// In en, this message translates to:
  /// **'Failed to close the poll'**
  String get pollsCloseError;

  /// Toast after deleting a poll
  ///
  /// In en, this message translates to:
  /// **'Poll deleted'**
  String get pollsDeleteSuccess;

  /// Marks the option the user picked in results
  ///
  /// In en, this message translates to:
  /// **'Your choice'**
  String get pollsMyChoice;

  /// Results empty state for a question
  ///
  /// In en, this message translates to:
  /// **'No answers yet'**
  String get pollsResultsNoAnswers;

  /// Rating question results average
  ///
  /// In en, this message translates to:
  /// **'Average rating {value}'**
  String pollsRatingAverage(String value);

  /// Rating question responses count
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} response} other{{count} responses}}'**
  String pollsRatingResponses(int count);

  /// Text question answers list title
  ///
  /// In en, this message translates to:
  /// **'Answers'**
  String get pollsTextAnswers;

  /// Runner/creator step counter
  ///
  /// In en, this message translates to:
  /// **'{current} of {total}'**
  String pollsStepCounter(int current, int total);

  /// Runner inline validation error
  ///
  /// In en, this message translates to:
  /// **'This question is required'**
  String get pollsRequiredError;

  /// Runner/creator next step button
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get pollsNext;

  /// Runner submit answers button
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get pollsSubmit;

  /// Toast after submitting poll answers
  ///
  /// In en, this message translates to:
  /// **'Your answers were saved'**
  String get pollsRunnerSuccess;

  /// Runner text question input hint
  ///
  /// In en, this message translates to:
  /// **'Type your answer…'**
  String get pollsTextAnswerHint;

  /// Runner rating chip semantics label
  ///
  /// In en, this message translates to:
  /// **'Rating {value}'**
  String pollsRatingOption(int value);

  /// Creator wizard step: basics
  ///
  /// In en, this message translates to:
  /// **'Basics'**
  String get pollsStepBasics;

  /// Creator wizard step: questions
  ///
  /// In en, this message translates to:
  /// **'Questions'**
  String get pollsStepQuestions;

  /// Creator wizard step: preview
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get pollsStepPreview;

  /// Creator wizard title field hint
  ///
  /// In en, this message translates to:
  /// **'Poll title'**
  String get pollsTitleHint;

  /// Creator wizard description field hint
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get pollsDescriptionHint;

  /// Creator wizard category field label
  ///
  /// In en, this message translates to:
  /// **'Topic'**
  String get pollsCategoryLabel;

  /// Creator wizard add question button
  ///
  /// In en, this message translates to:
  /// **'Add question'**
  String get pollsAddQuestion;

  /// Creator wizard remove question action
  ///
  /// In en, this message translates to:
  /// **'Remove question'**
  String get pollsRemoveQuestion;

  /// Creator wizard question index label
  ///
  /// In en, this message translates to:
  /// **'Question {number}'**
  String pollsQuestionNumber(int number);

  /// Poll question kind
  ///
  /// In en, this message translates to:
  /// **'Single choice'**
  String get pollsQuestionKindSingle;

  /// Poll question kind
  ///
  /// In en, this message translates to:
  /// **'Multiple choice'**
  String get pollsQuestionKindMultiple;

  /// Poll question kind
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get pollsQuestionKindText;

  /// Poll question kind
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get pollsQuestionKindRating;

  /// Creator wizard required toggle
  ///
  /// In en, this message translates to:
  /// **'Required question'**
  String get pollsQuestionRequired;

  /// Creator wizard reorder question up
  ///
  /// In en, this message translates to:
  /// **'Move up'**
  String get pollsMoveUp;

  /// Creator wizard reorder question down
  ///
  /// In en, this message translates to:
  /// **'Move down'**
  String get pollsMoveDown;

  /// Creator wizard results visibility setting
  ///
  /// In en, this message translates to:
  /// **'Who can see results'**
  String get pollsResultsVisibility;

  /// Results visibility: always
  ///
  /// In en, this message translates to:
  /// **'Everyone, right away'**
  String get pollsResultsVisibilityAlways;

  /// Results visibility: after vote
  ///
  /// In en, this message translates to:
  /// **'After answering'**
  String get pollsResultsVisibilityAfterVote;

  /// Results visibility: after close
  ///
  /// In en, this message translates to:
  /// **'After the poll closes'**
  String get pollsResultsVisibilityAfterClose;

  /// Creator wizard allow change toggle
  ///
  /// In en, this message translates to:
  /// **'Allow changing the answer'**
  String get pollsAllowChange;

  /// Creator wizard closing date setting
  ///
  /// In en, this message translates to:
  /// **'Closing date'**
  String get pollsClosesAt;

  /// Creator wizard closing date: none
  ///
  /// In en, this message translates to:
  /// **'No deadline'**
  String get pollsClosesAtNone;

  /// Creator wizard closing date: pick
  ///
  /// In en, this message translates to:
  /// **'Pick a date'**
  String get pollsClosesAtPick;

  /// Creator wizard preview validation
  ///
  /// In en, this message translates to:
  /// **'Add at least one question'**
  String get pollsPreviewEmptyQuestions;

  /// Creator wizard title validation
  ///
  /// In en, this message translates to:
  /// **'Enter a poll title'**
  String get pollsTitleRequired;

  /// Creator wizard question validation
  ///
  /// In en, this message translates to:
  /// **'Enter the question text'**
  String get pollsQuestionTextRequired;

  /// Creator wizard options validation
  ///
  /// In en, this message translates to:
  /// **'Add at least two options'**
  String get pollsQuestionOptionsRequired;

  /// Polls empty state for a non-default filter
  ///
  /// In en, this message translates to:
  /// **'No polls match this filter'**
  String get pollsEmptyFiltered;

  /// Polls empty state for a search query
  ///
  /// In en, this message translates to:
  /// **'Nothing found for “{query}”'**
  String pollsEmptySearch(String query);

  /// No description provided for @pollsLoadMore.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get pollsLoadMore;

  /// No description provided for @pollsChangeAnswers.
  ///
  /// In en, this message translates to:
  /// **'Change answers'**
  String get pollsChangeAnswers;

  /// No description provided for @pollsResultsHidden.
  ///
  /// In en, this message translates to:
  /// **'Results are not available yet'**
  String get pollsResultsHidden;

  /// No description provided for @pollsEmptyQuestions.
  ///
  /// In en, this message translates to:
  /// **'This poll has no questions'**
  String get pollsEmptyQuestions;

  /// No description provided for @pollsQuestionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} question} other{{count} questions}}'**
  String pollsQuestionsCount(num count);

  /// No description provided for @pollsClosesFuture.
  ///
  /// In en, this message translates to:
  /// **'Choose a future closing time'**
  String get pollsClosesFuture;

  /// No description provided for @pollsDistinctOptionsRequired.
  ///
  /// In en, this message translates to:
  /// **'Add at least two distinct options and choose a non-empty correct answer for a quiz'**
  String get pollsDistinctOptionsRequired;

  /// No description provided for @pollsCorrectAnswer.
  ///
  /// In en, this message translates to:
  /// **'Correct answer'**
  String get pollsCorrectAnswer;

  /// Creator wizard question text field hint
  ///
  /// In en, this message translates to:
  /// **'Question text'**
  String get pollsQuestionTextHint;

  /// Title of the sheet with promo banner dismiss options
  ///
  /// In en, this message translates to:
  /// **'Hide this offer'**
  String get promoHideSheetTitle;

  /// Subtitle of the promo dismiss sheet
  ///
  /// In en, this message translates to:
  /// **'You can bring partner offers back in the home screen settings.'**
  String get promoHideSheetSubtitle;

  /// Snooze option measured in days
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{Hide for {count} day} other{Hide for {count} days}}'**
  String promoSnoozeDays(int count);

  /// Snooze option measured in hours
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{Hide for {count} hour} other{Hide for {count} hours}}'**
  String promoSnoozeHours(int count);

  /// Permanent dismiss option for a promo banner
  ///
  /// In en, this message translates to:
  /// **'Don\'t show again'**
  String get promoHideForever;

  /// Toast after hiding a promo banner forever
  ///
  /// In en, this message translates to:
  /// **'Hidden. Partner offers can be re-enabled in home settings.'**
  String get promoHiddenToast;

  /// Header title of the promo details page
  ///
  /// In en, this message translates to:
  /// **'How to earn'**
  String get promoDetailsTitle;

  /// Empty state when a promo slug is unknown
  ///
  /// In en, this message translates to:
  /// **'This offer is no longer available'**
  String get promoNotFound;

  /// Toast when a promo link fails to launch
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the link'**
  String get promoOpenLinkError;

  /// Default title of the promo contact card
  ///
  /// In en, this message translates to:
  /// **'Questions?'**
  String get promoContactTitle;

  /// Semantics label for the promo Telegram contact button
  ///
  /// In en, this message translates to:
  /// **'Message on Telegram'**
  String get promoContactTelegram;

  /// Action label on the promo contact card
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get promoWrite;

  /// Fallback title for a promo facts section
  ///
  /// In en, this message translates to:
  /// **'Key facts'**
  String get promoSectionFacts;

  /// Fallback title for a promo steps section
  ///
  /// In en, this message translates to:
  /// **'How to start'**
  String get promoSectionSteps;

  /// Fallback title for a promo checklist section
  ///
  /// In en, this message translates to:
  /// **'What you need'**
  String get promoSectionChecklist;

  /// Fallback title for a promo FAQ section
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get promoSectionFaq;

  /// Fallback title for a promo links section
  ///
  /// In en, this message translates to:
  /// **'Useful links'**
  String get promoSectionLinks;

  /// Home content toggle that shows or hides promo banners
  ///
  /// In en, this message translates to:
  /// **'Partner offers'**
  String get settingsShowPromoBanners;

  /// No description provided for @friendsStudentsTab.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get friendsStudentsTab;

  /// No description provided for @friendsStudentsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No students on the map yet'**
  String get friendsStudentsEmptyTitle;

  /// No description provided for @friendsStudentsEmptySub.
  ///
  /// In en, this message translates to:
  /// **'Students appear here when they choose to share with everyone. You can browse without sharing your own location.'**
  String get friendsStudentsEmptySub;

  /// No description provided for @friendsStudentsSub.
  ///
  /// In en, this message translates to:
  /// **'Only students who chose to share with everyone are shown. Locations may be approximate.'**
  String get friendsStudentsSub;

  /// No description provided for @friendsVisStudents.
  ///
  /// In en, this message translates to:
  /// **'Everyone'**
  String get friendsVisStudents;

  /// No description provided for @friendsVisStudentsSub.
  ///
  /// In en, this message translates to:
  /// **'Any signed-in student can see your profile and location without adding you as a friend. Visibility continues until you hide yourself or turn sharing off.'**
  String get friendsVisStudentsSub;

  /// No description provided for @friendsVisFriendsSub.
  ///
  /// In en, this message translates to:
  /// **'Only accepted friends can see your location. Your profile will not appear on the student map.'**
  String get friendsVisFriendsSub;

  /// No description provided for @friendsPublicProfile.
  ///
  /// In en, this message translates to:
  /// **'Shares with all students'**
  String get friendsPublicProfile;

  /// No description provided for @friendsBackgroundTitle.
  ///
  /// In en, this message translates to:
  /// **'Location updates'**
  String get friendsBackgroundTitle;

  /// No description provided for @friendsBackgroundMobileSub.
  ///
  /// In en, this message translates to:
  /// **'On phones, background updates require location permission and may be limited by battery saving. Force-closing the app or restarting the device can stop sharing; open the app to resume.'**
  String get friendsBackgroundMobileSub;

  /// No description provided for @friendsBackgroundForegroundSub.
  ///
  /// In en, this message translates to:
  /// **'On this platform, your location updates while the app is open and active. Sharing stops when it is closed or suspended.'**
  String get friendsBackgroundForegroundSub;

  /// No description provided for @friendsBackgroundActive.
  ///
  /// In en, this message translates to:
  /// **'Background location is active'**
  String get friendsBackgroundActive;

  /// No description provided for @friendsBackgroundInactive.
  ///
  /// In en, this message translates to:
  /// **'Background location is not active'**
  String get friendsBackgroundInactive;

  /// No description provided for @friendsLocationRetry.
  ///
  /// In en, this message translates to:
  /// **'Enable location access'**
  String get friendsLocationRetry;

  /// No description provided for @friendsMapPeopleCount.
  ///
  /// In en, this message translates to:
  /// **'On the map: {count}'**
  String friendsMapPeopleCount(int count);

  /// No description provided for @friendsLocationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Location is unavailable. You can still browse students on the map.'**
  String get friendsLocationUnavailable;

  /// No description provided for @friendsLocationPublishFailed.
  ///
  /// In en, this message translates to:
  /// **'Your latest location could not be shared. Check your connection; updates will retry automatically.'**
  String get friendsLocationPublishFailed;

  /// No description provided for @friendsLocationServiceDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are turned off on your device. The map remains available.'**
  String get friendsLocationServiceDisabled;

  /// No description provided for @friendsLocationUnsupported.
  ///
  /// In en, this message translates to:
  /// **'This device cannot provide your location. You can still browse the map.'**
  String get friendsLocationUnsupported;

  /// No description provided for @friendsLocationLocating.
  ///
  /// In en, this message translates to:
  /// **'Finding your location…'**
  String get friendsLocationLocating;

  /// No description provided for @friendsLocationForegroundActive.
  ///
  /// In en, this message translates to:
  /// **'Updates while the app is active'**
  String get friendsLocationForegroundActive;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

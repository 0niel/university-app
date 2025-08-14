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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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

  /// Message for desktop users about maps
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

  /// Error message for sponsors loading
  ///
  /// In en, this message translates to:
  /// **'Error loading sponsors'**
  String get errorLoadingSponsors;

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
  /// **'MIREA Map'**
  String get mireaMap;

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

  /// App title
  ///
  /// In en, this message translates to:
  /// **'RTU MIREA App'**
  String get rtuMireaApp;

  /// New Year holidays title
  ///
  /// In en, this message translates to:
  /// **'New Year holidays'**
  String get newYearHolidays;

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

  /// Desktop empty schedule title
  ///
  /// In en, this message translates to:
  /// **'No schedule selected'**
  String get noScheduleSelected;

  /// Desktop empty schedule subtitle
  ///
  /// In en, this message translates to:
  /// **'Select a group, teacher or classroom to view schedule'**
  String get selectEntityToSeeSchedule;

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
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ru'].contains(locale.languageCode);

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

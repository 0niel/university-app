// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get scheduleAppBarTitle => 'Schedule';

  @override
  String get loadingError => 'Loading error';

  @override
  String get imageViewer => 'Image viewer';

  @override
  String get selectDate => 'Select date';

  @override
  String get selectDates => 'Select dates';

  @override
  String get enableComparisonMode => 'Enable comparison mode';

  @override
  String get disableComparisonMode => 'Disable comparison mode';

  @override
  String get compareSchedules => 'Compare schedules';

  @override
  String get noClassesToday => 'No classes today';

  @override
  String get selectTime => 'Select time';

  @override
  String get clear => 'Clear';

  @override
  String get month => 'Month';

  @override
  String get week => 'Week';

  @override
  String get apply => 'Apply';

  @override
  String get previousDay => 'Previous day';

  @override
  String get nextDay => 'Next day';

  @override
  String get today => 'Today';

  @override
  String get refreshData => 'Refresh data';

  @override
  String get scheduleComparison => 'Schedule comparison';

  @override
  String get scheduleAnalytics => 'Schedule analytics';

  @override
  String get allClassesList => 'All classes list';

  @override
  String get scheduleNotSelected => 'Schedule not selected';

  @override
  String get findSchedule => 'Find schedule';

  @override
  String get scheduleForSelectedDay => 'Schedule for selected day';

  @override
  String get tomorrow => 'tomorrow';

  @override
  String get showEmptyClasses => 'Show empty classes';

  @override
  String get emptyClasses => 'Empty classes';

  @override
  String get analytics => 'Analytics';

  @override
  String get weekend => 'Weekend';

  @override
  String get noClassesThisDay => 'No classes this day';

  @override
  String get canRestOrStudy => 'You can rest or do independent work';

  @override
  String get goToAnotherDay => 'Go to another day';

  @override
  String classesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: 'classes', few: 'classes', one: 'class');
    return '$_temp0';
  }

  @override
  String get noClass => 'No class';

  @override
  String get displaySettings => 'Display settings';

  @override
  String get showCommentIndicators => 'Show comment indicators';

  @override
  String get compactCardMode => 'Compact card mode';

  @override
  String get lecture => 'Lecture';

  @override
  String get laboratory => 'Laboratory';

  @override
  String get practice => 'Practice';

  @override
  String get exam => 'Exam';

  @override
  String get consultation => 'Consultation';

  @override
  String get credit => 'Credit';

  @override
  String get unknown => 'Unknown';

  @override
  String get lessonType => 'Lesson type';

  @override
  String get individual => 'Individual';

  @override
  String get physicalEducation => 'Physical Education';

  @override
  String get courseWork => 'Course Work';

  @override
  String get courseProject => 'Course Project';

  @override
  String get mapsOnlyOnMobile => 'Maps are only available on mobile devices';

  @override
  String get scheduleAnalyticsTitle => 'Schedule Analytics';

  @override
  String get scheduleAnalyticsDescription => 'Statistics and analysis of your academic schedule';

  @override
  String get loadByDays => 'Load by days';

  @override
  String get lessonTypes => 'Lesson types';

  @override
  String get teachers => 'Teachers';

  @override
  String get classrooms => 'Classrooms';

  @override
  String get noDataForAnalytics => 'No data for analytics';

  @override
  String get selectAnotherSchedule => 'Select another schedule or check for classes';

  @override
  String get exportData => 'Export data';

  @override
  String get fullReportWithCharts => 'Full report with all charts';

  @override
  String get dataInTableFormat => 'Data in table format';

  @override
  String get shareImage => 'Share image';

  @override
  String get currentOrAllCharts => 'Current chart or all';

  @override
  String get export => 'Export';

  @override
  String get monday => 'Monday';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get thursday => 'Thursday';

  @override
  String get friday => 'Friday';

  @override
  String get scheduleChanges => 'Schedule changes';

  @override
  String get calendar => 'Calendar';

  @override
  String get scheduleLoadingError => 'Error loading schedule';

  @override
  String get addSchedulesForComparison => 'Add schedules for comparison';

  @override
  String get buildRoute => 'Build route';

  @override
  String get mySchedules => 'My schedules';

  @override
  String get createSchedule => 'Create schedule';

  @override
  String get addClass => 'Add class';

  @override
  String get classesList => 'Classes list';

  @override
  String get classLabel => 'Class';

  @override
  String get open => 'Open';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get editSchedule => 'Edit schedule';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get deleteSchedule => 'Delete schedule';

  @override
  String deleteScheduleConfirmation(String scheduleName) {
    return 'Are you sure you want to delete schedule \"$scheduleName\"?';
  }

  @override
  String get createNewClass => 'Create new class';

  @override
  String get noAddedClasses => 'No added classes';

  @override
  String get deleteClass => 'Delete class';

  @override
  String deleteClassConfirmation(String subject) {
    return 'Are you sure you want to delete class \"$subject\" from schedule?';
  }

  @override
  String get start => 'Start';

  @override
  String get end => 'End';

  @override
  String get endTimeMustBeAfterStart => 'End time must be after start time';

  @override
  String get classNumber => 'Class number';

  @override
  String get none => 'None';

  @override
  String get groups => 'Groups';

  @override
  String get noTeachersSelected => 'No teachers selected';

  @override
  String get addTeacher => 'Add teacher';

  @override
  String get add => 'Add';

  @override
  String get selectAtLeastOneDate => 'Select at least one date';

  @override
  String get addAtLeastOneClassroom => 'Add at least one classroom or make the class online';

  @override
  String get noSelectedDates => 'No selected dates';

  @override
  String get selectDatesButton => 'Select dates';

  @override
  String get noSelectedClassrooms => 'No selected classrooms';

  @override
  String get addClassroom => 'Add classroom';

  @override
  String get noGroupsSelected => 'No groups selected';

  @override
  String get addGroup => 'Add group';

  @override
  String get exampleClassNames => 'Example class names:';

  @override
  String get textCopied => 'Text copied!';

  @override
  String failedToOpenImage(String error) {
    return 'Failed to open image: $error';
  }

  @override
  String get loginFailed => 'Login failed';

  @override
  String get next => 'Next';

  @override
  String get errorLoadingSponsors => 'Error loading sponsors';

  @override
  String get login => 'Login';

  @override
  String get loginToContinue => 'Login to continue';

  @override
  String get deleteScheduleTitle => 'Delete schedule';

  @override
  String get deleteScheduleMessage => 'Are you sure you want to delete this schedule?';

  @override
  String get makeActive => 'Make active';

  @override
  String get comment => 'Comment';

  @override
  String get schedules => 'Schedules';

  @override
  String get loadingSchedules => 'Loading schedules...';

  @override
  String get addedClass => 'Added class:';

  @override
  String get createNewSchedule => 'Create new schedule';

  @override
  String get selectSchedule => 'Select schedule:';

  @override
  String classAddedToSchedule(String scheduleName) {
    return 'Class added to schedule \"$scheduleName\"';
  }

  @override
  String get legends => 'Legends';

  @override
  String get maxThreeSchedules => 'Maximum 3 schedules for comparison';

  @override
  String get university => 'University';

  @override
  String get search => 'Search';

  @override
  String get error => 'Error';

  @override
  String get searchFailed => 'Failed to perform search';

  @override
  String get enterCommentText => 'Enter comment text...';

  @override
  String get remove => 'Remove';

  @override
  String get noAvailableSchedules => 'No available schedules';

  @override
  String get scheduleDeleted => 'Schedule deleted';

  @override
  String get deleteScheduleConfirmationDialog => 'Are you sure you want to delete this schedule?';

  @override
  String get active => 'Active';

  @override
  String get comments => 'Comments';

  @override
  String get activate => 'Activate';

  @override
  String get group => 'Group';

  @override
  String get teacher => 'Teacher';

  @override
  String get classroom => 'Classroom';

  @override
  String get schedule => 'Schedule';

  @override
  String get commentDeleted => 'Comment deleted';

  @override
  String get commentSaved => 'Comment saved';

  @override
  String get scheduleComment => 'Schedule comment';

  @override
  String get addOrEditNote => 'Add or edit a note to the schedule';

  @override
  String get editComment => 'Edit comment';

  @override
  String get addComment => 'Add comment';

  @override
  String get addSchedule => 'Add schedule';

  @override
  String get activeSchedule => 'Active schedule';

  @override
  String get goToView => 'Go to view';

  @override
  String get noAddedGroups => 'No added groups';

  @override
  String get addGroupToSeeSchedule => 'Add a group to see its schedule';

  @override
  String get noAddedTeachers => 'No added teachers';

  @override
  String get addTeacherToSeeSchedule => 'Add a teacher to see their schedule';

  @override
  String get noAddedClassrooms => 'No added classrooms';

  @override
  String get addClassroomToSeeSchedule => 'Add a classroom to see its schedule';

  @override
  String get failedToLoadSchedules => 'Failed to load schedules';

  @override
  String get checkInternetConnection => 'Check your internet connection';

  @override
  String get enterJsonString => 'Please enter JSON string';

  @override
  String get enterJsonStringPlaceholder => 'Enter JSON string...';

  @override
  String get tabs => 'Tabs';

  @override
  String get scheduleChangesTitle => 'Schedule changes';

  @override
  String get loadByDaysChart => 'Load by days';

  @override
  String get lessonTypesChart => 'Lesson types';

  @override
  String get teachersChart => 'Teachers';

  @override
  String get classroomsChart => 'Classrooms';

  @override
  String get fullReportWithAllCharts => 'Full report with all charts';

  @override
  String get dataInTableFormatExport => 'Data in table format';

  @override
  String get shareImageExport => 'Share image';

  @override
  String get currentOrAllChartsExport => 'Current chart or all';

  @override
  String get totalClasses => 'Total classes';

  @override
  String get forEntirePeriod => 'For the entire period';

  @override
  String get averagePerDay => 'Average per day';

  @override
  String get academicLoad => 'Academic load';

  @override
  String get maximumPerDay => 'Maximum per day';

  @override
  String get busiestDay => 'Busiest day';

  @override
  String get showEmptyClassesSettings => 'Show empty classes';

  @override
  String get showCommentIndicatorsSettings => 'Show comment indicators';

  @override
  String get compactCardModeSettings => 'Compact card mode';

  @override
  String get holiday => 'Holiday';

  @override
  String get selectExisting => 'Select existing';

  @override
  String get createNew => 'Create new';

  @override
  String get scheduleName => 'Schedule name';

  @override
  String get scheduleNamePlaceholder => 'For example: My main schedule';

  @override
  String get descriptionOptional => 'Description (optional)';

  @override
  String get addScheduleDescription => 'Add schedule description';

  @override
  String get openSchedule => 'Open';

  @override
  String get selectWeek => 'Select week';

  @override
  String get quickWayToWeek => 'Quick way to go to a specific week';

  @override
  String get selectUpToFourSchedules => 'Select up to 4 schedules to compare them by days';

  @override
  String get addToSchedule => 'Add to schedule';

  @override
  String get enterLessonComment => 'Enter a comment for the class...';

  @override
  String get noOwnSchedules => 'You don\'t have your own schedules yet';

  @override
  String get createCustomSchedule => 'Create a custom schedule by adding classes from different available schedules';

  @override
  String get scheduleCreation => 'Schedule creation';

  @override
  String get enterNameAndDescription => 'Enter name and description for the new schedule';

  @override
  String get scheduleNameLabel => 'Schedule name';

  @override
  String get scheduleNameExample => 'For example: My schedule';

  @override
  String get descriptionOptionalLabel => 'Description (optional)';

  @override
  String get addScheduleDescriptionPlaceholder => 'Add schedule description';

  @override
  String get editScheduleTitle => 'Edit schedule';

  @override
  String get classesListTitle => 'Classes list';

  @override
  String addNewClassToSchedule(String scheduleName) {
    return 'You can add a new class to schedule $scheduleName';
  }

  @override
  String get offline => 'Offline';

  @override
  String get online => 'Online';

  @override
  String get subjectName => 'Subject name';

  @override
  String get enterSubjectName => 'Enter subject name';

  @override
  String get teacherFullName => 'Teacher full name';

  @override
  String get teacherNameExample => 'For example: Ivanov Ivan Ivanovich';

  @override
  String get endTimeMustBeAfterStartTime => 'End time must be after start time';

  @override
  String get selectAtLeastOneDateError => 'Select at least one date';

  @override
  String get addAtLeastOneClassroomError => 'Add at least one classroom or make the class online';

  @override
  String get selectDatesButtonText => 'Select dates';

  @override
  String get onlineClassLink => 'Online class link';

  @override
  String get enterConnectionUrl => 'Enter connection URL';

  @override
  String classroomNumber(String name) {
    return 'Classroom $name';
  }

  @override
  String get classroomExample => 'For example: A-123';

  @override
  String get campusNameOptional => 'Campus name (optional)';

  @override
  String get campusExample => 'For example: B-78';

  @override
  String get addClassroomDialog => 'Add classroom';

  @override
  String get groupName => 'Group name';

  @override
  String get groupNameExample => 'For example: IKBO-01-21';

  @override
  String get addGroupDialog => 'Add group';

  @override
  String get retry => 'Retry';

  @override
  String get resetFilter => 'Reset filter';

  @override
  String get supportOurService => 'Support our service';

  @override
  String get leaveAd => 'Leave ad';

  @override
  String get disable => 'Disable';

  @override
  String errorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get map => 'Map';

  @override
  String get tryAgain => 'Try again';

  @override
  String get announcement => 'Announcement';

  @override
  String get contact => 'Contact';

  @override
  String copiedToClipboard(String title) {
    return '$title copied to clipboard';
  }

  @override
  String get post => 'Post';

  @override
  String get errorLoadingPost => 'Error loading post';

  @override
  String get errorLoadingContributors => 'Error loading contributors';

  @override
  String get relatedArticles => 'Related articles';

  @override
  String get failedToLoadArticle => 'Failed to load article';

  @override
  String get shareFailed => 'Failed to share';

  @override
  String get trending => 'Trending';

  @override
  String get slideshow => 'Slideshow';

  @override
  String get enterSearchQuery => 'Enter a search query';

  @override
  String get failedToLoadMoreContent => 'Failed to load more content';

  @override
  String get searchHistory => 'History';

  @override
  String get enterScheduleName => 'Enter name';

  @override
  String get nameTooLong => 'Name is too long';

  @override
  String get createAndAddClass => 'Create and add class';

  @override
  String get addToSelectedSchedule => 'Add to selected schedule';

  @override
  String get mireaMap => 'MIREA Map';

  @override
  String get findNeededClassroom => 'Find the needed classroom';

  @override
  String get nfcPass => 'NFC Pass';

  @override
  String get passForUniversityEntry => 'Pass for university entry';

  @override
  String get cloudMireaNinja => 'Cloud Mirea Ninja';

  @override
  String get mireaNinja => 'Mirea Ninja';

  @override
  String get mostPopularUnofficialChat => 'Most popular unofficial chat';

  @override
  String get kisDepartment => 'KIS Department';

  @override
  String get corporateInformationSystems => 'Corporate Information Systems Department';

  @override
  String get ippoDepartment => 'IPPO Department';

  @override
  String get instrumentalAndAppliedSoftware => 'Instrumental and Applied Software Department';

  @override
  String get competitiveProgrammingMirea => 'Competitive Programming MIREA';

  @override
  String get competitiveProgrammingDescription =>
      'Various news and updates on competitive programming at MIREA are published here';

  @override
  String get personalAccount => 'Personal Account';

  @override
  String get accessToGradesAndServices => 'Access to grades, applications and other services';

  @override
  String get openAction => 'Open';

  @override
  String get educationalPortal => 'Educational Portal';

  @override
  String get accessToCoursesAndMaterials => 'Access to courses and materials';

  @override
  String get goToAction => 'Go to';

  @override
  String get electronicJournal => 'Electronic Journal';

  @override
  String get attendanceCheckSchedule => 'Attendance check, schedule';

  @override
  String get library => 'Library';

  @override
  String get freeSoftware => 'Free Software';

  @override
  String get cyberzone => 'Cyberzone';

  @override
  String get handbook => 'Handbook';

  @override
  String get scholarships => 'Scholarships';

  @override
  String get militaryRegistration => 'Military Registration';

  @override
  String get dormitories => 'Dormitories';

  @override
  String get studentOffice => 'Student Office';

  @override
  String get certificatesDocumentsQuestions => 'Certificates, documents, questions';

  @override
  String get careerCenter => 'Career Center';

  @override
  String get vacanciesAndInternships => 'Vacancies and internships';

  @override
  String get initiativeService => 'Initiative Service';

  @override
  String get ideasAndSuggestions => 'Ideas and suggestions';

  @override
  String get virtualTour => 'Virtual Tour';

  @override
  String get interactiveUniversityTour => 'Interactive tour of university buildings';

  @override
  String get startupAccelerator => 'Startup Accelerator';

  @override
  String get startupSupport => 'Startup and entrepreneurial ideas support';

  @override
  String get corporatePortal => 'Corporate Portal';

  @override
  String get accessForTeachersAndStaff => 'Access for teachers and staff';

  @override
  String get mainServices => 'Main services';

  @override
  String get studentLife => 'Student life';

  @override
  String get useful => 'Useful';

  @override
  String get createAccount => 'Create account';

  @override
  String get createAccountTitle => 'Create an account';

  @override
  String get createAccountDescription =>
      'We offer you to create a free account in our cloud storage so you can store your files and documents!';

  @override
  String get cloudStorageDescription =>
      'On cloud.mirea.ninja you can store up to 10 GB for free (quota can be expanded in the telegram bot), as well as share files and edit documents online together with classmates.';

  @override
  String get searchPlaceholder => 'Search';

  @override
  String get searchInAnnouncements => 'Search in announcements...';

  @override
  String get itemName => 'Item name';

  @override
  String get itemNameExample => 'For example: Keys with keychain';

  @override
  String get description => 'Description';

  @override
  String get itemDescription => 'Details about the item, where and when it was found/lost...';

  @override
  String get telegram => 'Telegram';

  @override
  String get phone => 'Phone';

  @override
  String get leaveFeedback => 'Leave feedback';

  @override
  String get yourEmail => 'Your email';

  @override
  String get enterEmail => 'Enter email';

  @override
  String get whatHappened => 'What happened?';

  @override
  String get feedbackPlaceholder => 'When I press \"X\" \"Y\" happens';

  @override
  String get exportToCalendar => 'Export to calendar';

  @override
  String get scheduleExported => 'Schedule exported';

  @override
  String get failedToExportSchedule => 'Failed to export schedule';

  @override
  String get exportSettings => 'Export settings';

  @override
  String get emojiInLessonTypes => 'Emoji in lesson types';

  @override
  String get emojiExample => 'Example: \"📚 Lecture\" instead of \"Lecture\"';

  @override
  String get shortLessonTypeNames => 'Short lesson type names';

  @override
  String get shortNamesExample => 'Example: \"Lec.\" instead of \"Lecture\"';

  @override
  String get preview => 'Preview';

  @override
  String get fullTypeName => 'Full type name';

  @override
  String get shortTypeName => 'Short type name';

  @override
  String get subjectSelection => 'Subject selection';

  @override
  String get standardReminders => 'Standard reminders';

  @override
  String get cardSettings => 'Card settings';

  @override
  String get codeFromEmail => 'Code from email';

  @override
  String get news => 'News';

  @override
  String get services => 'Services';

  @override
  String get profile => 'Profile';

  @override
  String get aboutApp => 'About app';

  @override
  String get settings => 'Settings';

  @override
  String get findScheduleForClassroom => 'You can quickly find a schedule for this classroom using schedule search.';

  @override
  String get rtuMireaApp => 'RTU MIREA App';

  @override
  String get newYearHolidays => 'New Year holidays';

  @override
  String get winterVacation => 'Winter vacation';

  @override
  String get defenderOfFatherlandDay => 'Defender of the Fatherland Day';

  @override
  String get internationalWomensDay => 'International Women\'s Day';

  @override
  String get springAndLaborDay => 'Spring and Labor Day';

  @override
  String get victoryDay => 'Victory Day';

  @override
  String get russiaDay => 'Russia Day';

  @override
  String get nationalUnityDay => 'National Unity Day';

  @override
  String get newYear => 'New Year';

  @override
  String get total => 'Total';

  @override
  String get lectures => 'Lectures';

  @override
  String get practicals => 'Practicals';

  @override
  String get labs => 'Labs';

  @override
  String get justNow => 'just now';

  @override
  String get status => 'Status';

  @override
  String phoneContact(String phoneNumber) {
    return 'Phone: $phoneNumber';
  }

  @override
  String lessonsOnDay(String day) {
    return 'Lessons on $day';
  }

  @override
  String get todayLower => 'today';

  @override
  String get tomorrowLower => 'tomorrow';

  @override
  String get showEmptyLessonsTooltip => 'Show empty classes';

  @override
  String get emptyLessons => 'Empty classes';

  @override
  String get analyticsShort => 'Analytics';

  @override
  String get dayOff => 'Day off';

  @override
  String get noLessonsThatDay => 'No classes on this day';

  @override
  String get noLessonsThatDayShort => 'No classes this day!';

  @override
  String get restSuggestion => 'You can rest or do self-study';

  @override
  String windowGap(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count classes', one: '$count class');
    return 'Gap: $_temp0';
  }

  @override
  String get noScheduleSelected => 'No schedule selected';

  @override
  String get selectEntityToSeeSchedule => 'Select a group, teacher or classroom to view schedule';

  @override
  String get errorLoadingSchedule => 'Error loading schedule';

  @override
  String get manageComparisons => 'Manage comparisons';

  @override
  String get selectUpTo4Schedules => 'Select up to 4 schedules to compare by days';

  @override
  String get noUpcomingLessons => 'No upcoming classes';

  @override
  String get noUpcomingLessonsDescription =>
      'No classes are scheduled in the near future. Switch to the calendar to view other days.';

  @override
  String get switchToCalendar => 'Switch to calendar';

  @override
  String get lecturesShort => 'Lect.';

  @override
  String get practiceShort => 'Pract.';

  @override
  String get labsShort => 'Lab.';

  @override
  String get legend => 'Legend';

  @override
  String get laboratoryWork => 'Laboratory';

  @override
  String get scheduleLoadError => 'An error occurred while fetching the schedule. Please try again.';

  @override
  String get selectSchedulesForComparison => 'Select schedules for comparison (up to 3)';

  @override
  String deleteScheduleConfirm(String name) {
    return 'Are you sure you want to delete \"$name\"?';
  }

  @override
  String deleteClassConfirm(String subject) {
    return 'Are you sure you want to delete \"$subject\" from the schedule?';
  }

  @override
  String get commentTooLong => 'Comment is too long';

  @override
  String get addOneClassroomOrOnline => 'Add at least one classroom or make the class online';

  @override
  String get createClass => 'Create class';

  @override
  String get editClass => 'Edit class';

  @override
  String get startTime => 'Start';

  @override
  String get endTime => 'End';

  @override
  String get lessonNumber => 'Lesson number';

  @override
  String get teacherFullNameHint => 'e.g. Ivanov Ivan Ivanovich';

  @override
  String get enterTeacherFullName => 'Enter teacher full name';

  @override
  String get onlineLessonUrl => 'Online lesson URL';

  @override
  String get enterUrl => 'Enter URL';

  @override
  String get classroomNumberHint => 'e.g. A-123';

  @override
  String get enterClassroomNumber => 'Enter classroom number';

  @override
  String get enterGroupName => 'Enter group name';

  @override
  String get basic => 'Basic';

  @override
  String get dates => 'Dates';

  @override
  String get place => 'Place';

  @override
  String get create => 'Create';

  @override
  String get addDate => 'Add date';

  @override
  String get lessonDeliveryType => 'Lesson delivery type';

  @override
  String get noClassroomsSelected => 'No classrooms selected';

  @override
  String get back => 'Back';
}

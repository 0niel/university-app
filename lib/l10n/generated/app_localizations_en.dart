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
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'classes',
      few: 'classes',
      one: 'class',
    );
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
  String get lessonTypeIndividualShort => 'Self-study';

  @override
  String get lessonTypeCourseWorkShort => 'Course work';

  @override
  String get lessonTypeCourseProjectShort => 'Course project';

  @override
  String get mapsOnlyOnMobile => 'Maps are only available on mobile devices';

  @override
  String get scheduleAnalyticsTitle => 'Schedule Analytics';

  @override
  String get scheduleAnalyticsDescription =>
      'Statistics and analysis of your academic schedule';

  @override
  String get loadByDays => 'Load by days';

  @override
  String get lessonTypes => 'Lesson types';

  @override
  String get teachers => 'Teachers';

  @override
  String get searchScopeCommunity => 'Posts';

  @override
  String get searchSectionPosts => 'Group posts';

  @override
  String get searchGlobalHint => 'Class, person, room, post…';

  @override
  String get searchCoachTitle => 'Global search';

  @override
  String get searchCoachBody =>
      'The same icon lives in the header of every root screen: Home · Schedule · Feed · People · Services.';

  @override
  String get searchCoachGesture =>
      'Plus a gesture: swipe down on Home and Schedule';

  @override
  String get searchScopeAll => 'All';

  @override
  String get searchScopeClasses => 'Classes';

  @override
  String get searchScopeClassrooms => 'Rooms';

  @override
  String searchTrendingTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count searches this week',
      one: '$count search this week',
    );
    return '$_temp0';
  }

  @override
  String get searchRecent => 'Recent';

  @override
  String get searchTrendingNow => 'Trending now';

  @override
  String get searchBestMatch => 'Best match';

  @override
  String searchMoreResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count more results',
      one: '$count more result',
    );
    return '$_temp0';
  }

  @override
  String get searchNoResults => 'Nothing found';

  @override
  String get searchNoResultsHint => 'Try another query or scope';

  @override
  String get searchTagGroup => 'Group';

  @override
  String get searchTagTeacher => 'Teacher';

  @override
  String get searchTagClassroom => 'Room';

  @override
  String get searchTagPerson => 'Student';

  @override
  String get searchTagPost => 'Post';

  @override
  String get classrooms => 'Classrooms';

  @override
  String get noDataForAnalytics => 'No data for analytics';

  @override
  String get selectAnotherSchedule =>
      'Select another schedule or check for classes';

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
  String get addAtLeastOneClassroom =>
      'Add at least one classroom or make the class online';

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
  String get errorLoadingAds => 'Error loading ads';

  @override
  String get login => 'Login';

  @override
  String get loginToContinue => 'Login to continue';

  @override
  String get deleteScheduleTitle => 'Delete schedule';

  @override
  String get deleteScheduleMessage =>
      'Are you sure you want to delete this schedule?';

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
  String get all => 'All';

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
  String get deleteScheduleConfirmationDialog =>
      'Are you sure you want to delete this schedule?';

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
  String get scheduleActiveBadge => 'Active';

  @override
  String get deleteScheduleAction => 'Delete schedule';

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
  String get selectUpToFourSchedules =>
      'Select up to 4 schedules to compare them by days';

  @override
  String get addToSchedule => 'Add to schedule';

  @override
  String get enterLessonComment => 'Enter a comment for the class...';

  @override
  String get noOwnSchedules => 'You don\'t have your own schedules yet';

  @override
  String get createCustomSchedule =>
      'Create a custom schedule by adding classes from different available schedules';

  @override
  String get scheduleCreation => 'Schedule creation';

  @override
  String get enterNameAndDescription =>
      'Enter name and description for the new schedule';

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
  String get addAtLeastOneClassroomError =>
      'Add at least one classroom or make the class online';

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
  String contributorCommitsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count commits',
      one: '$count commit',
    );
    return '$_temp0';
  }

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
  String get campusMap => 'Campus map';

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
  String get corporateInformationSystems =>
      'Corporate Information Systems Department';

  @override
  String get ippoDepartment => 'IPPO Department';

  @override
  String get instrumentalAndAppliedSoftware =>
      'Instrumental and Applied Software Department';

  @override
  String get competitiveProgrammingMirea => 'Competitive Programming MIREA';

  @override
  String get competitiveProgrammingDescription =>
      'Various news and updates on competitive programming at MIREA are published here';

  @override
  String get personalAccount => 'Personal Account';

  @override
  String get accessToGradesAndServices =>
      'Access to grades, applications and other services';

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
  String get certificatesDocumentsQuestions =>
      'Certificates, documents, questions';

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
  String get interactiveUniversityTour =>
      'Interactive tour of university buildings';

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
  String get itemDescription =>
      'Details about the item, where and when it was found/lost...';

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
  String get findScheduleForClassroom =>
      'You can quickly find a schedule for this classroom using schedule search.';

  @override
  String get newYearHolidays => 'New Year holidays';

  @override
  String get orthodoxChristmas => 'Orthodox Christmas';

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
  String get topicsLoading => 'Loading discussion…';

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
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count classes',
      one: '$count class',
    );
    return 'Gap: $_temp0';
  }

  @override
  String lessonPeriodWord(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'classes',
      one: 'class',
    );
    return '$_temp0';
  }

  @override
  String get noScheduleSelected => 'No schedule selected';

  @override
  String get selectEntityToSeeSchedule =>
      'Select a group, teacher or classroom to view schedule';

  @override
  String get noActiveGroupTitle => 'No active group set';

  @override
  String get noActiveGroupSubtitle =>
      'Download a schedule for at least one group to see the calendar.';

  @override
  String get errorLoadingSchedule => 'Error loading schedule';

  @override
  String get manageComparisons => 'Manage comparisons';

  @override
  String get selectUpTo4Schedules =>
      'Select up to 4 schedules to compare by days';

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
  String get scheduleLoadError =>
      'An error occurred while fetching the schedule. Please try again.';

  @override
  String get selectSchedulesForComparison =>
      'Select schedules for comparison (up to 3)';

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
  String get addOneClassroomOrOnline =>
      'Add at least one classroom or make the class online';

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

  @override
  String get scheduleLessonsTitle => 'Classes';

  @override
  String get busyDayBadge => 'Busy day';

  @override
  String studyWeekBadge(int week, String parity) {
    return 'Week $week · $parity';
  }

  @override
  String studyWeekNumber(int week) {
    return 'Week $week';
  }

  @override
  String get weekParityEvenFull => 'even';

  @override
  String get weekParityOddFull => 'odd';

  @override
  String get weekParityNumerator => 'numerator';

  @override
  String get weekParityDenominator => 'denominator';

  @override
  String campusesCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count buildings',
      one: '$count building',
    );
    return '$_temp0';
  }

  @override
  String minutesShort(int minutes) {
    return '$minutes min';
  }

  @override
  String get homeOngoingShort => 'ongoing';

  @override
  String get backToToday => '← today';

  @override
  String get offlineFromCache => 'No connection — schedule from cache';

  @override
  String updatedAtTime(String time) {
    return 'updated $time';
  }

  @override
  String get liveNow => 'Now';

  @override
  String get more => 'More';

  @override
  String get notifications => 'Notifications';

  @override
  String get share => 'Share';

  @override
  String get reset => 'Reset';

  @override
  String get done => 'Done';

  @override
  String get noData => 'No data';

  @override
  String get todayLabel => 'today';

  @override
  String get tomorrowLabel => 'tomorrow';

  @override
  String get yesterdayLabel => 'yesterday';

  @override
  String minutesAgo(int count) {
    return '$count min ago';
  }

  @override
  String hoursAgo(int count) {
    return '$count h ago';
  }

  @override
  String daysAgo(int count) {
    return '$count d ago';
  }

  @override
  String lessonsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count classes',
      one: '$count class',
      zero: 'no classes',
    );
    return '$_temp0';
  }

  @override
  String activitiesCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count activities',
      one: '$count activity',
    );
    return '$_temp0';
  }

  @override
  String windowsCountSuffix(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count windows',
      one: '$count window',
    );
    return '+$_temp0';
  }

  @override
  String eventsCountSuffix(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count events',
      one: '$count event',
    );
    return '+$_temp0';
  }

  @override
  String get scheduleQuickActions => 'Quick actions';

  @override
  String get scheduleActionsTitle => 'Manage schedule';

  @override
  String get scheduleActionsImportant => 'Important';

  @override
  String get scheduleActionsTools => 'Tools';

  @override
  String get scheduleActionsSettings => 'Settings and sharing';

  @override
  String get mySchedulesSubtitle => 'Create or open your own schedule';

  @override
  String get changesTitle => 'Changes';

  @override
  String get changesSubtitle => 'Moves, cancellations and substitutions';

  @override
  String get compareTitle => 'Compare';

  @override
  String get compareSubtitle => 'Find shared windows with another schedule';

  @override
  String get sessionTitle => 'Exams';

  @override
  String get sessionSubtitle => 'Countdown to your exams';

  @override
  String get analyticsTitle => 'Analytics';

  @override
  String get analyticsSubtitle => 'Load by days and lesson types';

  @override
  String get exportScheduleTitle => 'Export schedule';

  @override
  String get exportScheduleSubtitle => 'Sync classes with any calendar';

  @override
  String get filtersTitle => 'Filters';

  @override
  String get filtersSubtitle => 'What to show in the schedule';

  @override
  String get viewList => 'List';

  @override
  String get viewDay => 'Day';

  @override
  String get viewWeek => 'Week';

  @override
  String get viewMonth => 'Month';

  @override
  String get filterAll => 'All';

  @override
  String get filterLectures => 'Lectures';

  @override
  String get filterSeminars => 'Seminars';

  @override
  String get filterLabs => 'Labs';

  @override
  String get filterExams => 'Exams';

  @override
  String get filterLabsFull => 'Laboratory classes';

  @override
  String get filterExamsFull => 'Credits and exams';

  @override
  String get filterWordAll => 'classes';

  @override
  String get filterWordLectures => 'lectures';

  @override
  String get filterWordSeminars => 'seminars';

  @override
  String get filterWordLabs => 'labs';

  @override
  String get filterWordExams => 'exams';

  @override
  String pastTodaySummary(String lessons) {
    return 'Passed today: $lessons';
  }

  @override
  String get hidePastLessons => 'Hide passed';

  @override
  String xpAmount(int xp) {
    return '+$xp XP';
  }

  @override
  String windowMinutes(int minutes) {
    return 'Window $minutes min';
  }

  @override
  String get gapCoffeeHint => '· coffee';

  @override
  String get freeClassrooms => 'Free classrooms';

  @override
  String endOfDay(String time) {
    return 'End of day — $time';
  }

  @override
  String endOfDayPotential(int xp) {
    return 'potential +$xp XP';
  }

  @override
  String get swipeCoachMark => 'Swipe a class left — note, reminder, route';

  @override
  String get swipeActionsLabel => 'Actions';

  @override
  String nextInMinutes(int minutes) {
    return 'Next · in $minutes min';
  }

  @override
  String nextInHours(String hours) {
    return 'Next · in $hours h';
  }

  @override
  String minutesLeft(int minutes) {
    return '$minutes min left';
  }

  @override
  String get classroomNotSpecified => 'Room not specified';

  @override
  String get prepHintLab => 'For class: laptop and lab materials';

  @override
  String get prepHintExam => 'Review the key exam questions';

  @override
  String get prepHintCourse => 'Check your course-work plan';

  @override
  String get calloutCancelled => 'Class cancelled';

  @override
  String calloutMoved(String time) {
    return 'Class moved: was $time';
  }

  @override
  String calloutRoomChanged(String rooms) {
    return 'Room changed: was $rooms';
  }

  @override
  String calloutTeacherChanged(String teachers) {
    return 'Teacher substituted: $teachers';
  }

  @override
  String get calloutAdded => 'Class added';

  @override
  String emptyFilterTitle(String filter) {
    return 'No $filter on this day';
  }

  @override
  String get emptyFilterSubtitle => 'Try another day or reset the filter';

  @override
  String get liveActionChat => 'Chat';

  @override
  String get liveActionRecord => 'Record';

  @override
  String friendsInClass(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$name and $count others in class',
      one: '$name and 1 other in class',
      zero: '$name is in class',
    );
    return '$_temp0';
  }

  @override
  String get noLessonsShort => 'No classes';

  @override
  String get weekendTitle => 'Weekend!';

  @override
  String get weekendShort => 'Weekend';

  @override
  String get scheduleTransferredDayOff => 'Transferred day off';

  @override
  String get scheduleTransferredWorkday => 'Transferred workday';

  @override
  String scheduleTransferCalendarPending(int year) {
    return 'Day-off transfers for $year have not been published yet';
  }

  @override
  String get scheduleWeekHoldLesson => 'Hold to expand class details';

  @override
  String scheduleWeekHoldToExpand(int count) {
    return '$count more · hold';
  }

  @override
  String get scheduleWeekHoldToCollapse => 'All classes · hold to collapse';

  @override
  String get whatToDo => 'What to do?';

  @override
  String get noLessonsSelectedDay => 'No classes on the selected day';

  @override
  String get dayOffTitle => 'No classes today';

  @override
  String get dayOffWithActivities =>
      'No classes, but you have planned activities.';

  @override
  String get dayOffFree => 'No classes. Plan your own things.';

  @override
  String get addActivity => 'Add activity';

  @override
  String nearestLessonText(String day, String time, String subject) {
    return 'No classes. Nearest — $day at $time, $subject.';
  }

  @override
  String get goToMonday => 'To Monday';

  @override
  String get goToToday => 'Today';

  @override
  String get previousMonth => 'Previous month';

  @override
  String get nextMonth => 'Next month';

  @override
  String get previousWeek => 'Previous week';

  @override
  String get nextWeek => 'Next week';

  @override
  String get legendLessons => 'Classes';

  @override
  String get legendHoliday => 'Public holiday';

  @override
  String get legendRetake => 'Retake';

  @override
  String get legendEvent => 'Event';

  @override
  String get weekdayMonday => 'Monday';

  @override
  String get weekdayTuesday => 'Tuesday';

  @override
  String get weekdayWednesday => 'Wednesday';

  @override
  String get weekdayThursday => 'Thursday';

  @override
  String get weekdayFriday => 'Friday';

  @override
  String get weekdaySaturday => 'Saturday';

  @override
  String get weekdaySunday => 'Sunday';

  @override
  String get weekdayShortMon => 'Mon';

  @override
  String get weekdayShortTue => 'Tue';

  @override
  String get weekdayShortWed => 'Wed';

  @override
  String get weekdayShortThu => 'Thu';

  @override
  String get weekdayShortFri => 'Fri';

  @override
  String get weekdayShortSat => 'Sat';

  @override
  String get weekdayShortSun => 'Sun';

  @override
  String get exportPeriodToday => 'Today';

  @override
  String get exportPeriodWeek => 'Week';

  @override
  String get exportPeriodSemester => 'Semester';

  @override
  String get exportWhereSection => 'Where';

  @override
  String get exportOptionsSection => 'Options';

  @override
  String get exportSystemCalendar => 'System calendar';

  @override
  String get exportSystemCalendarSub => 'added to the device calendar';

  @override
  String get exportGoogleCalendar => 'Google Calendar';

  @override
  String get exportGoogleCalendarSub => 'via the device calendar';

  @override
  String get exportIcsFile => '.ics file';

  @override
  String get exportIcsFileSub => 'one-off, no updates';

  @override
  String get exportPng => 'PNG image';

  @override
  String get exportPngSub => 'for stories / save to photos';

  @override
  String get exportReminders => 'Reminders';

  @override
  String get exportRemindersSub => '15 minutes before class';

  @override
  String get exportAutoUpdate => 'Auto-update';

  @override
  String get exportAutoUpdateSub => 'picks up schedule changes';

  @override
  String get exportIncludeRooms => 'Include room and campus';

  @override
  String get exportActionToday => 'Export today';

  @override
  String get exportActionWeek => 'Export week';

  @override
  String get exportActionSemester => 'Export semester';

  @override
  String get exportFormatSoon =>
      'This format is coming soon — using the device calendar for now';

  @override
  String exportStarted(String lessons) {
    return 'Exporting $lessons to the calendar';
  }

  @override
  String get filtersLessonTypes => 'Lesson types';

  @override
  String get filtersDisplaySection => 'Display';

  @override
  String get filtersShowGaps => 'Show windows';

  @override
  String get filtersShowGapsSub => 'breaks between classes';

  @override
  String get filtersPastLessons => 'Past classes';

  @override
  String get filtersPastLessonsSub => 'collapse automatically';

  @override
  String get filtersHiddenSection => 'Hidden classes';

  @override
  String get filtersHiddenHint => 'Tap to bring a class back to the schedule';

  @override
  String get filtersRestore => 'Restore';

  @override
  String get classActionsTitle => 'Class actions';

  @override
  String get classActionRate => 'Rate the class';

  @override
  String get classActionRateSub => 'reaction for the group';

  @override
  String get classActionNote => 'Add a note';

  @override
  String get classActionRoute => 'Build a route';

  @override
  String get classActionRemind => 'Remind';

  @override
  String get classActionRemindSub => '15 min before';

  @override
  String get classActionShare => 'Share the class';

  @override
  String get classActionHide => 'Hide from schedule';

  @override
  String get reactionSheetTitle => 'How was the class?';

  @override
  String get reactionFire => 'Fire';

  @override
  String get reactionBrain => 'Useful';

  @override
  String get reactionLove => 'Top';

  @override
  String get reactionSad => 'Sad';

  @override
  String get reactionFlushed => 'Surprised';

  @override
  String get reactionSick => 'Disgusting';

  @override
  String get reactionPoo => 'Awful';

  @override
  String get reactionThinking => 'Hard';

  @override
  String get reactionSleepy => 'Boring';

  @override
  String get reactionSkull => 'Rough';

  @override
  String get reactionMindblown => 'Blast';

  @override
  String get reactionRespect => 'Respect';

  @override
  String get anonymously => 'Anonymously';

  @override
  String get anonymouslySub => 'your name won\'t be shown to the group';

  @override
  String get reactionSend => 'Send';

  @override
  String reactionSent(String emoji) {
    return 'Reaction sent $emoji';
  }

  @override
  String get reactionRemoved => 'Reaction removed';

  @override
  String get reactionAdded => 'Reaction added!';

  @override
  String get reminderSheetTitle => 'Remind';

  @override
  String get reminder15Min => '15 minutes before';

  @override
  String get reminder15MinSub => 'enough time to walk';

  @override
  String get reminder5Min => '5 minutes before';

  @override
  String get reminder5MinSub => 'if you\'re already nearby';

  @override
  String get reminderMorning => 'In the morning of the class day';

  @override
  String get reminderMorningSub => 'at 08:00';

  @override
  String get reminderSet => 'Set reminder';

  @override
  String get reminderSetSuccess => 'Reminder set';

  @override
  String reminderAtTime(String time) {
    return 'at $time';
  }

  @override
  String get reminderWhenSection => 'When';

  @override
  String get reminderHowSection => 'How';

  @override
  String get reminderCustom => 'Custom time';

  @override
  String get reminderCustomHint => 'pick a time';

  @override
  String reminderCustomAt(String time) {
    return 'at $time';
  }

  @override
  String get reminderPush => 'Push notification';

  @override
  String get reminderRoute => 'With route to the classroom';

  @override
  String get reminderTraffic => 'Account for traffic';

  @override
  String get reminderTrafficSub => 'leave earlier if it\'s far';

  @override
  String get reminderSuccessTitle => 'Reminder set';

  @override
  String reminderSuccessBody(String time) {
    return 'We\'ll remind you at $time';
  }

  @override
  String reminderSuccessBodyRoute(String time, String room) {
    return 'We\'ll remind you at $time with a route to $room';
  }

  @override
  String get hideLessonTitle => 'Hide the class?';

  @override
  String hideLessonBody(String subject) {
    return '“$subject” will disappear from the schedule. You can bring it back in Filters.';
  }

  @override
  String get hideLessonAllSubject => 'Hide all classes of this subject';

  @override
  String get hideLessonAction => 'Hide';

  @override
  String get hideLessonDone => 'Class hidden from the schedule';

  @override
  String get sessionScheduleTitle => 'Exam schedule';

  @override
  String get sessionNoExams => 'No exams or credits in the schedule yet.';

  @override
  String get sessionNoExamsTitle => 'No exams';

  @override
  String get sessionUntilFirstExam => 'Until the first exam';

  @override
  String get sessionNoPlannedExams => 'no planned exams';

  @override
  String sessionHeroSubtitle(String subject, String date) {
    return 'days · $subject · $date';
  }

  @override
  String get sessionExamsCredits => 'exams · credits';

  @override
  String get sessionReadinessLabel => 'readiness';

  @override
  String get sessionDaysTotal => 'days total';

  @override
  String get sessionDaysShort => 'days';

  @override
  String get sessionReadiness => 'Readiness';

  @override
  String sessionStudyPlanText(String subject, int percent) {
    return 'Today — $subject (2 h). Readiness is only $percent%';
  }

  @override
  String get compareYou => 'You';

  @override
  String get compareMySchedule => 'My schedule';

  @override
  String get comparePick => 'Pick a schedule';

  @override
  String get comparePickGroup => 'Pick a group';

  @override
  String get compareFriend => 'friend';

  @override
  String get compareTapToPick => 'tap to pick';

  @override
  String get compareEmptyHint =>
      'Add a friend\'s schedule to see shared windows and classes you attend together.';

  @override
  String get compareNoLessonsBoth => 'No classes for either of you this day';

  @override
  String compareCommonWindow(String from, String to) {
    return 'Shared window $from–$to — both free. Coffee?';
  }

  @override
  String get compareBothFree => 'Both free';

  @override
  String get compareFreeCell => 'free';

  @override
  String get compareTogether => 'together';

  @override
  String get comparePickerTitle => 'Compare with whom?';

  @override
  String get comparePickerDescription => 'Find your friend\'s group';

  @override
  String get comparePickerHint => 'IKBO-09-22…';

  @override
  String get compareLoadError => 'Couldn\'t load the group schedule';

  @override
  String get changesPushBanner => 'Push on any change in your schedule';

  @override
  String get changesEmptyTitle => 'No changes yet';

  @override
  String get changesEmptySubtitle =>
      'When classes get moved, cancelled or rescheduled — it all shows up here.';

  @override
  String changeMovedTitle(String subject) {
    return '$subject moved';
  }

  @override
  String changeMovedDescription(String from, String to) {
    return 'was $from → now $to';
  }

  @override
  String changeCancelledTitle(String subject) {
    return '$subject cancelled';
  }

  @override
  String changeCancelledDescription(String time) {
    return 'the $time class will not take place';
  }

  @override
  String changeAddedTitle(String subject) {
    return 'Class added: $subject';
  }

  @override
  String get changeTeacherTitle => 'Teacher substituted';

  @override
  String get changeRoomTitle => 'Room changed';

  @override
  String get analyticsHoursPerWeek => 'hours/week';

  @override
  String get analyticsAvgPerDay => 'avg classes/day';

  @override
  String get analyticsLoadByDay => 'Load by day';

  @override
  String analyticsOverloadedDay(String day, String hours) {
    return '$day is overloaded — $hours hours';
  }

  @override
  String get analyticsBalancedWeek => 'The week is balanced';

  @override
  String get analyticsByType => 'By lesson type';

  @override
  String analyticsInsightLightTitle(String day) {
    return 'Best morning — $day';
  }

  @override
  String analyticsInsightLightSub(String hours) {
    return 'only $hours h of classes, you can sleep in';
  }

  @override
  String analyticsInsightWindowsTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count windows a week',
      one: '$count window a week',
    );
    return '$_temp0';
  }

  @override
  String analyticsInsightWindowsSub(String hours) {
    return '$hours h between classes in total';
  }

  @override
  String get analyticsNoSchedule => 'Pick a schedule to see analytics.';

  @override
  String analyticsShareText(String hours, String avg) {
    return 'My week: $hours hours of classes, on average $avg classes a day';
  }

  @override
  String get createScheduleTitle => 'Create schedule';

  @override
  String get createScheduleHeadline => 'How shall we fill the schedule?';

  @override
  String get createScheduleSubtitle =>
      'Pick a convenient way — everything can be adjusted later';

  @override
  String get createWayGroupTitle => 'Find your group';

  @override
  String get createWayGroupDescription =>
      'We\'ll pull the schedule automatically';

  @override
  String get createWayFastBadge => 'fast';

  @override
  String get createWaySearchTitle => 'Teacher or classroom';

  @override
  String get createWaySearchDescription => 'Any schedule by name';

  @override
  String get createWayScanTitle => 'Scan a schedule photo';

  @override
  String get createWayScanDescription => 'Recognise the timetable from a photo';

  @override
  String get createWayScanSoon => 'Schedule scanning is coming soon';

  @override
  String get createWayManualTitle => 'Fill in manually';

  @override
  String get createWayManualDescription => 'Add classes one by one';

  @override
  String get createWayCopyTitle => 'Copy from a groupmate';

  @override
  String get createWayCopyDescription => 'Via an invite link';

  @override
  String get createWayCopySoon => 'Invite links are coming soon';

  @override
  String get openMySchedules => 'Open my schedules';

  @override
  String get openMySchedulesSubtitle => 'Hand-made schedules';

  @override
  String get editScheduleSwipeHint => 'Drag to reorder · swipe left to delete';

  @override
  String get editScheduleEmptyDay => 'No classes this day — add the first one';

  @override
  String get editScheduleNotFound => 'Schedule not found';

  @override
  String homeGreeting(String name) {
    return 'Hi, $name';
  }

  @override
  String get homeNinja => 'ninja';

  @override
  String get homeStudent => 'Student';

  @override
  String get homePass => 'Pass';

  @override
  String get homeOngoingNow => 'ONGOING NOW';

  @override
  String homeUntil(String time) {
    return 'until $time';
  }

  @override
  String get homeNextLabel => 'NEXT';

  @override
  String homeInMinutes(int minutes) {
    return 'in $minutes min';
  }

  @override
  String get homeShurikens => 'Shurikens';

  @override
  String get homeStreak => 'Streak';

  @override
  String homeDaysShort(int days) {
    return '$days d';
  }

  @override
  String homeHoursShort(int hours) {
    return '$hours h';
  }

  @override
  String get homeRoomsFree => 'free';

  @override
  String get homeKnowledgeBank => 'Knowledge bank';

  @override
  String get homeBalance => 'Balance';

  @override
  String get homeOpen => 'open';

  @override
  String get homeGrades => 'Grades';

  @override
  String get homeDeadlines => 'Deadlines';

  @override
  String homeBurningCount(int count) {
    return '$count burning';
  }

  @override
  String homeActiveShort(int count) {
    return '$count active';
  }

  @override
  String get homePeople => 'People';

  @override
  String get homeCreateArrow => 'Create →';

  @override
  String homeAllArrow(int count) {
    return 'All $count →';
  }

  @override
  String homeNearDontMiss(int count) {
    return '$count near · don\'\'t miss';
  }

  @override
  String get homeNoDeadlines => 'No deadlines — take a breather';

  @override
  String get homeScheduleArrow => 'Schedule →';

  @override
  String homeClassesLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count classes left',
      one: '$count class left',
    );
    return '$_temp0';
  }

  @override
  String get homeNoMoreToday => 'No more classes today';

  @override
  String get homeTrending => 'Trending';

  @override
  String get homeFeedArrow => 'Feed →';

  @override
  String get homeAllClassesDone => 'That\'\'s all for today';

  @override
  String get homeOpenWeek => 'open week schedule';

  @override
  String get homeOverdue => 'overdue';

  @override
  String get homeNextTag => 'Next';

  @override
  String get homeCreditTag => 'Credit';

  @override
  String homeDueToday(String time) {
    return 'today $time';
  }

  @override
  String homeDueTomorrow(String time) {
    return 'tomorrow $time';
  }

  @override
  String scheduleUpdatedChanges(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Schedule updated: $count changes',
      one: 'Schedule updated: $count change',
    );
    return '$_temp0';
  }

  @override
  String get scheduleActionFailed =>
      'Couldn\'\'t do that — has the time already passed?';

  @override
  String get lessonEditorCreateTitle => 'New class';

  @override
  String get lessonEditorEditTitle => 'Edit class';

  @override
  String get lessonEditorStepBasic => 'General';

  @override
  String get lessonEditorStepDates => 'Dates';

  @override
  String get lessonEditorStepLocation => 'Location';

  @override
  String get lessonEditorStepPreview => 'Preview';

  @override
  String get lessonEditorSubjectName => 'Subject name';

  @override
  String get lessonEditorSubjectHint => 'Enter the subject name';

  @override
  String get lessonEditorSubjectLabel => 'Subject';

  @override
  String get lessonEditorTypeLabel => 'Class type';

  @override
  String get lessonEditorTimeLabel => 'Time';

  @override
  String get lessonEditorRoomLabel => 'Classroom';

  @override
  String get lessonEditorTeacherLabel => 'Teacher';

  @override
  String get lessonEditorDatesLabel => 'Dates';

  @override
  String get lessonEditorNotSet => 'Not set';

  @override
  String lessonEditorDatesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dates',
      one: '$count date',
    );
    return '$_temp0';
  }

  @override
  String get lessonEditorColorLabel => 'Color';

  @override
  String get lessonEditorRepeatLabel => 'Repeat';

  @override
  String get lessonEditorRepeatEvery => 'Every week';

  @override
  String get lessonEditorRepeatEven => 'Every even week';

  @override
  String get lessonEditorRepeatOdd => 'Every odd week';

  @override
  String get lessonEditorRepeatEveryShort => 'Every';

  @override
  String get lessonEditorRepeatEvenShort => 'Even';

  @override
  String get lessonEditorRepeatOddShort => 'Odd';

  @override
  String get lessonEditorRepeatManual => 'Pick dates manually';

  @override
  String get lessonEditorReminderTitle => 'Reminder';

  @override
  String lessonEditorReminderLead(int minutes) {
    return '$minutes min before';
  }

  @override
  String get customScheduleDefaultName => 'My schedule';

  @override
  String get pickerTimeTitle => 'Time';

  @override
  String get pickerTimeRangeTitle => 'Class time';

  @override
  String get pickerStart => 'Start';

  @override
  String get pickerEnd => 'End';

  @override
  String get pickerDateTitle => 'Date';

  @override
  String get pickerDatesTitle => 'Dates';

  @override
  String get pickerToday => 'Today';

  @override
  String get pickerTomorrow => 'Tomorrow';

  @override
  String get pickerNextWeek => 'In a week';

  @override
  String pickerSelectedCount(int count) {
    return 'Selected: $count';
  }

  @override
  String get pickerClear => 'Clear';

  @override
  String get pickerSearchHint => 'Search or type manually';

  @override
  String pickerAddManually(String query) {
    return 'Add “$query”';
  }

  @override
  String get pickerNothingFound => 'Nothing found';

  @override
  String get lessonEditorClassroomSearchHint => 'e.g. А-220';

  @override
  String get lessonEditorTeacherSearchHint => 'e.g. Ivanov';

  @override
  String get lessonTypeLectureName => 'Lecture';

  @override
  String get lessonTypeSeminarName => 'Seminar';

  @override
  String get lessonTypeLabName => 'Lab';

  @override
  String get lessonTypeCreditName => 'Credit';

  @override
  String get lessonTypeExamName => 'Exam';

  @override
  String get lessonEditorEndAfterStart =>
      'End time must be later than the start time';

  @override
  String get lessonEditorRepeat => 'Repeat';

  @override
  String get lessonEditorRepeatSoon =>
      'Repeat configuration will be available in future versions.';

  @override
  String get lessonEditorSelectDateError => 'Select at least one date';

  @override
  String get lessonEditorClassroomError =>
      'Add at least one classroom or make the class online';

  @override
  String get lessonEditorAddClassroom => 'Add classroom';

  @override
  String get lessonEditorClassroomNumber => 'Classroom number';

  @override
  String get lessonEditorClassroomHint => 'e.g. A-123';

  @override
  String get lessonEditorClassroomNumberError => 'Enter the classroom number';

  @override
  String get lessonEditorCampusName => 'Campus name (optional)';

  @override
  String get lessonEditorCampusHint => 'e.g. V-78';

  @override
  String get lessonEditorAddGroup => 'Add group';

  @override
  String get lessonEditorGroupName => 'Group name';

  @override
  String get lessonEditorGroupHint => 'e.g. IKBO-01-21';

  @override
  String get lessonEditorGroupError => 'Enter the group name';

  @override
  String get lessonEditorAddTeacher => 'Add teacher';

  @override
  String get lessonEditorTeacherName => 'Teacher full name';

  @override
  String get lessonEditorTeacherHint => 'e.g. Ivanov Ivan Ivanovich';

  @override
  String get lessonEditorTeacherError => 'Enter the teacher full name';

  @override
  String get customSchedulesCreateTitle => 'New schedule';

  @override
  String get customSchedulesCreateDesc =>
      'Enter a name and description for the new schedule';

  @override
  String get customSchedulesEditTitle => 'Edit schedule';

  @override
  String get customSchedulesEditDesc =>
      'Change the schedule name or description';

  @override
  String get customSchedulesLessonsTitle => 'Class list';

  @override
  String customSchedulesLessonsDesc(String name) {
    return 'Manage classes in the «$name» schedule';
  }

  @override
  String get customSchedulesEmptyTitle => 'You don\'\'t have any schedules yet';

  @override
  String get customSchedulesEmptyDesc =>
      'Create your own schedule by adding classes from different available schedules';

  @override
  String get customSchedulesCreate => 'Create schedule';

  @override
  String get customSchedulesCreateSubtitle => 'A new empty schedule';

  @override
  String get customSchedulesSearchTitle => 'Search schedules';

  @override
  String get customSchedulesSearchSubtitle => 'Search a schedule by name';

  @override
  String customSchedulesMyCount(int count) {
    return 'My schedules ($count)';
  }

  @override
  String customSchedulesLessonsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count classes',
      one: '$count class',
    );
    return '$_temp0';
  }

  @override
  String customSchedulesUpdated(String time) {
    return 'Updated $time';
  }

  @override
  String get customSchedulesEmpty => 'Empty schedule';

  @override
  String get customSchedulesUnknown => 'Unknown';

  @override
  String customSchedulesDaysAgo(int days) {
    return '$days d ago';
  }

  @override
  String customSchedulesHoursAgo(int hours) {
    return '$hours h ago';
  }

  @override
  String customSchedulesMinutesAgo(int minutes) {
    return '$minutes min ago';
  }

  @override
  String get customSchedulesJustNow => 'Just now';

  @override
  String get customSchedulesOpen => 'Open';

  @override
  String get customSchedulesRename => 'Rename';

  @override
  String get customSchedulesNameLabel => 'Schedule name';

  @override
  String get customSchedulesNameHint => 'e.g. My schedule';

  @override
  String get customSchedulesNameRequired => 'Enter a name';

  @override
  String get customSchedulesNameTooLong => 'Name is too long';

  @override
  String get customSchedulesDescLabel => 'Description (optional)';

  @override
  String get customSchedulesDescHint => 'Add a schedule description';

  @override
  String get customSchedulesSaveChanges => 'Save changes';

  @override
  String get customSchedulesAddLesson => 'Create a new class';

  @override
  String get customSchedulesNoLessons => 'No classes added';

  @override
  String get customSchedulesNoLessonsHint =>
      'Create the first class for this schedule';

  @override
  String customSchedulesClassroomLabel(String rooms) {
    return 'Classroom: $rooms';
  }

  @override
  String get lessonDetailsRoomToClass => 'To the room';

  @override
  String get lessonDetailsMaterials => 'Materials';

  @override
  String get lessonDetailsSignInReact => 'Sign in to react';

  @override
  String get lessonDetailsReviewTitle => 'Class review';

  @override
  String get lessonDetailsNoteTitle => 'Class note';

  @override
  String get lessonDetailsRoomCoordsMissing => 'Room coordinates not found';

  @override
  String get lessonDetailsRecordingSoon =>
      'Class recording will arrive after integration';

  @override
  String get lessonDetailsAddToSchedule => 'Add to schedule';

  @override
  String get lessonDetailsLiveNow => 'Live now';

  @override
  String get lessonDetailsEnded => 'Ended';

  @override
  String lessonDetailsPairNumber(String number) {
    return 'class $number';
  }

  @override
  String get lessonDetailsRoomNotSpecified => 'Room not specified';

  @override
  String get lessonDetailsTypeNote => 'Notes';

  @override
  String get lessonDetailsTypeBoard => 'Board photo';

  @override
  String get lessonDetailsTypeTask => 'Task';

  @override
  String get lessonDetailsTypeExtra => 'Extra material';

  @override
  String get lessonDetailsFile => 'file';

  @override
  String get lessonDetailsJustNow => 'now';

  @override
  String lessonDetailsMinutesShort(int minutes) {
    return '$minutes min';
  }

  @override
  String lessonDetailsHoursShort(int hours) {
    return '$hours h';
  }

  @override
  String get lessonDetailsYesterday => 'yesterday';

  @override
  String get lessonDetailsStatusLive => 'LIVE';

  @override
  String get lessonDetailsStatusPast => 'PAST';

  @override
  String get lessonDetailsStatusSoon => 'SOON';

  @override
  String get lessonDetailsRecord => 'Record';

  @override
  String get lessonDetailsNote => 'Note';

  @override
  String get lessonDetailsRoute => 'Route';

  @override
  String get lessonDetailsTeacherFallback => 'Lecturer';

  @override
  String get lessonDetailsTeacherProfile => 'profile and reviews';

  @override
  String lessonDetailsAllCount(int count) {
    return 'All $count';
  }

  @override
  String get lessonDetailsPeersTitle => 'With you in class';

  @override
  String lessonDetailsPeersFriends(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count friends in your group',
      one: '1 friend in your group',
      zero: 'No friends in this group yet',
    );
    return '$_temp0';
  }

  @override
  String get lessonDetailsGroupsTitle => 'Stream groups';

  @override
  String lessonDetailsGroupsMore(int count) {
    return '+$count';
  }

  @override
  String lessonDetailsMaterialsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count materials',
      one: '$count material',
    );
    return '$_temp0';
  }

  @override
  String get lessonDetailsLoadFailed => 'Couldn\'\'t load materials';

  @override
  String get lessonDetailsTapRetry => 'Tap to retry';

  @override
  String get lessonDetailsNoMaterialsYet => 'No materials yet';

  @override
  String get lessonDetailsUploadHint => 'Upload notes or a board photo';

  @override
  String get lessonDetailsOpenFailed => 'Couldn\'\'t open the material';

  @override
  String get lessonDetailsMaterialToClass => 'Material for the class';

  @override
  String get lessonDetailsUpload => 'Upload';

  @override
  String get lessonDetailsMaterialsPage => 'Class materials';

  @override
  String get lessonDetailsNewestFirst => 'newest first';

  @override
  String get lessonDetailsCheckConnection =>
      'Check the connection and try again';

  @override
  String get lessonDetailsContributePre => 'Upload notes or a board photo — ';

  @override
  String get lessonDetailsContributePost => ' and the group\'\'s thanks';

  @override
  String get lessonDetailsShurikensReward => '+30 shurikens';

  @override
  String get lessonDetailsEmptyMaterialsTitle =>
      'Class materials will appear here';

  @override
  String get lessonDetailsEmptyMaterialsSub =>
      'Be the first to upload a file or board photo';

  @override
  String lessonDetailsVotesAnon(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count votes · can be anonymous',
      one: '$count vote · can be anonymous',
    );
    return '$_temp0';
  }

  @override
  String get lessonDetailsGroupReactions => 'Group reactions';

  @override
  String get lessonDetailsLeaveReview => 'Leave a class review';

  @override
  String get lessonDetailsSignInReview => 'Sign in to leave a review';

  @override
  String get lessonDetailsReviewHint => 'What was useful, hard or important?';

  @override
  String get lessonDetailsAnonymous => 'Anonymous';

  @override
  String get lessonDetailsSaving => 'Saving…';

  @override
  String get lessonDetailsSubmitReview => 'Leave a review';

  @override
  String get lessonDetailsNoteHint => 'Class note';

  @override
  String get noteEditorTitle => 'Note';

  @override
  String get noteEditorDone => 'Done';

  @override
  String noteEditorBound(String room) {
    return 'Pinned to the class · $room';
  }

  @override
  String get noteEditorPlaceholder =>
      '…add thoughts, a photo of the board or by voice';

  @override
  String get noteShareWithGroup => 'Share with classmates';

  @override
  String noteShareWithGroupSub(String group) {
    return 'appears in the $group space';
  }

  @override
  String get noteShareWithGroupGeneric => 'appears in the group space';

  @override
  String get noteSavedIndicator => 'saved';

  @override
  String get noteSharedToGroup => 'Note shared with the group';

  @override
  String get lessonDetailsFileTooLarge => 'File is larger than 50 MB';

  @override
  String get lessonDetailsPickFileFirst => 'Pick a file or photo';

  @override
  String get lessonDetailsAddTitle => 'Add a material title';

  @override
  String get lessonDetailsSignInUpload => 'Sign in and try uploading again';

  @override
  String get lessonDetailsCamera => 'Camera';

  @override
  String get lessonDetailsGallery => 'Gallery';

  @override
  String get lessonDetailsFiles => 'Files';

  @override
  String get lessonDetailsTypeHeader => 'TYPE';

  @override
  String get lessonDetailsTitleLabel => 'Title';

  @override
  String get lessonDetailsTitleHint => 'Backprop notes';

  @override
  String get lessonDetailsPublicTitle => 'Available to the whole group';

  @override
  String get lessonDetailsPublicSub => 'otherwise — only you';

  @override
  String get lessonDetailsRewardPre => 'We\'\'ll award ';

  @override
  String get lessonDetailsUploading => 'Uploading…';

  @override
  String get lessonDetailsUploadMaterial => 'Upload material';

  @override
  String get lessonDetailsPickFileOrPhoto => 'Pick a file or photo';

  @override
  String get lessonDetailsDropHint => 'PDF, board photo, laptop · up to 50 MB';

  @override
  String get teacherProfileReviewTitle => 'Teacher review';

  @override
  String get teacherProfileShare => 'Share';

  @override
  String teacherProfileReviewsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reviews',
      one: '$count review',
    );
    return '$_temp0';
  }

  @override
  String get teacherProfileNoReviewsInline => 'no reviews yet';

  @override
  String get teacherProfileClarity => 'Clarity';

  @override
  String get teacherProfileLoyalty => 'Loyalty';

  @override
  String get teacherProfileUsefulness => 'Usefulness';

  @override
  String get teacherProfileSubjects => 'Teaches';

  @override
  String get teacherProfileReviews => 'Reviews';

  @override
  String get teacherProfileEmptyTitle => 'No reviews yet';

  @override
  String get teacherProfileEmptySub =>
      'Be the first — you\'\'ll help other students';

  @override
  String get teacherProfileLeaveReview => 'Leave a review';

  @override
  String get teacherProfileReviewHint =>
      'Explains complex things in simple words…';

  @override
  String get teacherProfileAnonymous => 'Anonymous';

  @override
  String get teacherProfileSaving => 'Saving…';

  @override
  String get teacherProfilePublish => 'Publish review';

  @override
  String get feedTitle => 'Feed';

  @override
  String get feedLoadCategoriesError => 'Couldn\'\'t load categories';

  @override
  String get feedLoadError => 'Couldn\'\'t load the news feed';

  @override
  String get feedLoadMoreError => 'Couldn\'\'t load more news';

  @override
  String get feedEmptyTitle => 'Nothing here yet';

  @override
  String get feedEmptyDescription =>
      'This feed has no posts yet. Check back later — news arrives automatically.';

  @override
  String get feedSourcesTitle => 'Channels';

  @override
  String get navHome => 'Home';

  @override
  String get navSchedule => 'Classes';

  @override
  String get navMap => 'Map';

  @override
  String get navServices => 'Services';

  @override
  String get navProfile => 'Profile';

  @override
  String mapRoomTitle(String name) {
    return 'Room $name';
  }

  @override
  String get authSignInTitle => 'Sign in';

  @override
  String get authSignInSubtitle => 'Sign in to continue';

  @override
  String get authContinueWithEmail => 'Continue with email';

  @override
  String get authSignInFailed => 'Couldn\'\'t sign in';

  @override
  String get authEmailHeaderTitle => 'Sign in to continue';

  @override
  String get authYourEmail => 'Your email';

  @override
  String get authInvalidEmail => 'Invalid email address';

  @override
  String get authNext => 'Next';

  @override
  String authUniversityEmailHint(String domains) {
    return 'Use a university address from one of these domains: $domains';
  }

  @override
  String get authEmailLinkFailed => 'Couldn\'\'t send the sign-in link';

  @override
  String get authSignUpTitle => 'Create account';

  @override
  String authSignUpSubtitle(String domains) {
    return 'Sign up with your university address: $domains';
  }

  @override
  String get authSignUpButton => 'Sign up';

  @override
  String get authSignUpFailed => 'Couldn\'\'t sign up. Try again.';

  @override
  String authEmailDomainError(String domains) {
    return 'Use an address from one of these domains: $domains';
  }

  @override
  String authPasswordMinLength(int count) {
    return 'At least $count characters';
  }

  @override
  String get authPasswordsDontMatch => 'Passwords don\'\'t match';

  @override
  String get authPasswordResetTitle => 'Password reset';

  @override
  String get authPasswordResetSubtitle =>
      'Enter your email — we\'\'ll send a recovery link.';

  @override
  String get authPasswordResetButton => 'Send link';

  @override
  String get authPasswordResetSent =>
      'Password reset email sent. Check your inbox.';

  @override
  String get authPasswordResetFailed =>
      'Couldn\'\'t send the email. Try again.';

  @override
  String get authCheckEmailTitle => 'Check your email';

  @override
  String authCheckEmailSubtitle(String email) {
    return 'We sent a 6-digit code to $email. Enter it below to confirm your email.';
  }

  @override
  String get authCodeFromEmail => 'Code from the email';

  @override
  String get authCheckingCode => 'Checking the code…';

  @override
  String get authInvalidCode =>
      'Invalid or expired code. Check it and try again.';

  @override
  String get authInvalidCredentials => 'Invalid email or password.';

  @override
  String get authGuestUnavailable =>
      'Couldn\'\'t sign in as a guest. Try again later.';

  @override
  String get settingsAmoledTitle => 'AMOLED';

  @override
  String get settingsAmoledSubtitle => 'True-black dark theme for OLED screens';

  @override
  String get scheduleDiffTitle => 'Schedule updates';

  @override
  String scheduleDiffFoundChanges(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Found $count changes in your schedule',
      one: 'Found $count change in your schedule',
    );
    return '$_temp0';
  }

  @override
  String get scheduleDiffNewLessons => 'New lessons';

  @override
  String scheduleDiffAddedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Added $count lessons',
      one: 'Added $count lesson',
    );
    return '$_temp0';
  }

  @override
  String get scheduleDiffChanges => 'Changes';

  @override
  String scheduleDiffModifiedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Modified $count lessons',
      one: 'Modified $count lesson',
    );
    return '$_temp0';
  }

  @override
  String get scheduleDiffRemovedLessons => 'Removed lessons';

  @override
  String scheduleDiffRemovedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Removed $count lessons',
      one: 'Removed $count lesson',
    );
    return '$_temp0';
  }

  @override
  String get scheduleDiffNewLabel => 'New';

  @override
  String get scheduleDiffModifiedLabel => 'Modified';

  @override
  String get scheduleDiffRemovedLabel => 'Removed';

  @override
  String get scheduleDiffKindNew => 'NEW';

  @override
  String get scheduleDiffKindModified => 'MODIFIED';

  @override
  String get scheduleDiffKindRemoved => 'REMOVED';

  @override
  String get scheduleDiffFieldLessonType => 'Lesson type';

  @override
  String get scheduleDiffFieldTime => 'Time';

  @override
  String get scheduleDiffFieldNumber => 'Class number';

  @override
  String get scheduleDiffFieldTeachers => 'Teachers';

  @override
  String get scheduleDiffFieldClassrooms => 'Rooms';

  @override
  String get scheduleDiffFieldDates => 'Dates';

  @override
  String get scheduleDiffFieldGroups => 'Groups';

  @override
  String get aboutAppDescription =>
      'This app and all its services are 100% free and open source. We welcome any suggestions and feedback, and we are happy about any contribution to the project!';

  @override
  String get aboutAppContributors => 'Project contributors';

  @override
  String get communityCategoryGeneral => 'General';

  @override
  String get communityCategoryInstitutes => 'Institutes';

  @override
  String get communityCategorySports => 'Sports';

  @override
  String get communityCategoryCreative => 'Creative';

  @override
  String get communityCategoryCompetitive => 'Competitive programming';

  @override
  String get communityCategoryScience => 'Science';

  @override
  String get communityCategoryVolunteering => 'Volunteering';

  @override
  String get communityCategoryEntertainment => 'Entertainment';

  @override
  String get communitiesTitle => 'Communities';

  @override
  String get communitiesSubtitle => 'catalog of MIREA chats and channels';

  @override
  String get communitiesSearchHint => 'Search communities…';

  @override
  String get communitiesSearchHintInline => 'Find a channel or chat…';

  @override
  String get communitiesAll => 'All';

  @override
  String get communitiesGroupStudy => 'Study';

  @override
  String get communitiesGroupInterests => 'Interests';

  @override
  String get communitiesGroupLife => 'Life';

  @override
  String get communitiesSectionStudy => 'Academic';

  @override
  String get communitiesSectionInterests => 'By interest';

  @override
  String get communitiesSectionLife => 'Life';

  @override
  String get communitiesSuggestTitle => 'Know a cool chat?';

  @override
  String get communitiesSuggestSubtitle => 'Add it to the catalog';

  @override
  String get communitiesNotFound => 'No communities found';

  @override
  String get communitiesTryFilters => 'Try changing the filters';

  @override
  String get communitiesFavorites => 'Featured';

  @override
  String communitiesMembersCount(String count) {
    return '$count members';
  }

  @override
  String friendsMeters(int meters) {
    return '$meters m';
  }

  @override
  String friendsKm(String km) {
    return '$km km';
  }

  @override
  String get friendsJustNow => 'now';

  @override
  String friendsMinutesShort(int minutes) {
    return '$minutes min';
  }

  @override
  String friendsHoursShort(int hours) {
    return '$hours h';
  }

  @override
  String friendsDaysShort(int days) {
    return '$days d';
  }

  @override
  String get friendsGhostMode => 'Ghost mode';

  @override
  String get friendsGhostModeOff => 'Turn off ghost mode';

  @override
  String friendsOnMapLive(int count) {
    return '$count on the map · live';
  }

  @override
  String get friendsRequests => 'Friend requests';

  @override
  String get friendsAddFriend => 'Add friend';

  @override
  String get friendsAddTitle => 'Add friends';

  @override
  String get friendsClose => 'Close';

  @override
  String get friendsGeoDenied =>
      'No location access — friends can\'\'t see you. Enable it in settings.';

  @override
  String get friendsMyLocation => 'My location';

  @override
  String get friendsGeoSharing => 'Location sharing';

  @override
  String get friendsTitle => 'Friends';

  @override
  String get friendsAddShort => '+ Add';

  @override
  String get friendsEmptyTitle => 'No one yet';

  @override
  String get friendsEmptySub =>
      'Add friends — see them on the map in real time';

  @override
  String get friendsStatusHidden => 'hidden';

  @override
  String get friendsStatusLive => 'on the map · live';

  @override
  String get friendsStatusRecent => 'seen recently';

  @override
  String get friendsStatusGeoOff => 'location off';

  @override
  String get friendsWriteTelegram => 'Message on Telegram';

  @override
  String get friendsRemove => 'Remove from friends';

  @override
  String get friendsShareGeo => 'Share my location';

  @override
  String get friendsShareGeoSub => 'updates while Friends on the map is open';

  @override
  String get friendsPrivacySyncError =>
      'The server did not confirm your privacy settings. Location publishing is stopped on this device — retry the sync.';

  @override
  String get friendsGhostSub => 'temporarily hide from everyone';

  @override
  String get friendsWhoSeesExact => 'WHO SEES MY EXACT LOCATION';

  @override
  String get friendsVisAll => 'All friends';

  @override
  String get friendsVisClose => 'Close friends only';

  @override
  String get friendsVisCloseSub => 'others see the building';

  @override
  String get friendsVisNone => 'No one';

  @override
  String get friendsVisNoneSub => 'you\'\'re not on the map';

  @override
  String get friendsPrecisionHeader => 'PRECISION FOR OTHERS';

  @override
  String get friendsPrecisionExact => 'Exact';

  @override
  String get friendsPrecisionCampus => 'Building';

  @override
  String get friendsPrecisionCity => 'City';

  @override
  String get friendsAutoOffHeader => 'AUTOMATICALLY TURN OFF';

  @override
  String get friendsAutoOffCampus => 'When I leave campus';

  @override
  String get friendsAutoOffNight => 'At night · 22:00–08:00';

  @override
  String get friendsAutoOffNever => 'Don\'\'t turn off';

  @override
  String get friendsSearchHint => 'Name, @handle or group';

  @override
  String get friendsMyQr => 'My QR code';

  @override
  String get friendsMyQrSub => 'show it to get added';

  @override
  String get friendsMyQrHint =>
      'Show this code to a friend — they point their camera and add you';

  @override
  String get friendsShareLink => 'Share link';

  @override
  String get friendsNoneFound => 'No one found';

  @override
  String get friendsNoneFoundSub => 'Try another name or group';

  @override
  String get friendsFromGroup => 'FROM YOUR GROUP';

  @override
  String get friendsYourGroup => 'your group';

  @override
  String friendsAddWholeGroup(int count) {
    return 'Add the whole group · $count';
  }

  @override
  String get friendsInFriends => 'friends';

  @override
  String get friendsRequestSent => 'request sent';

  @override
  String get friendsAddBare => 'Add';

  @override
  String get friendsScan => 'Scan';

  @override
  String get friendsScanSub => 'a friend\'\'s QR nearby';

  @override
  String get friendsScanTitle => 'Scan QR code';

  @override
  String get friendsScanInstruction =>
      'Point the camera at a friend\'\'s QR code';

  @override
  String get friendsScanInvalid => 'This isn\'\'t a Mirea Ninja friend code';

  @override
  String get friendsScanCameraError =>
      'Couldn\'\'t open the camera. Check the permission in settings.';

  @override
  String friendsFromGroupNamed(String group) {
    return 'From your group $group';
  }

  @override
  String get friendsNotYetFriends => 'not friends yet';

  @override
  String get friendsMayKnow => 'You may know';

  @override
  String friendsMutual(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mutual friends',
      one: '1 mutual friend',
    );
    return '$_temp0';
  }

  @override
  String get friendsInviteTelegram => 'Invite from Telegram';

  @override
  String get friendsInviteTelegramSub => 'send an invite link';

  @override
  String get friendsNoRequests => 'No requests';

  @override
  String get friendsNoRequestsSub =>
      'When someone adds you — it\'\'ll show here';

  @override
  String get friendsAccept => 'Accept';

  @override
  String get friendsDecline => 'Decline';

  @override
  String get friendsYou => 'You';

  @override
  String get lostFoundCatTech => 'Tech';

  @override
  String get lostFoundCatDocs => 'Documents';

  @override
  String get lostFoundCatKeys => 'Keys';

  @override
  String get lostFoundCatCloth => 'Clothing';

  @override
  String get lostFoundCatOther => 'Other';

  @override
  String get lostFoundJustNow => 'just now';

  @override
  String lostFoundMinutesAgo(int minutes) {
    return '$minutes min ago';
  }

  @override
  String lostFoundHoursAgo(int hours) {
    return '$hours h ago';
  }

  @override
  String lostFoundDaysAgo(int days) {
    return '$days d ago';
  }

  @override
  String lostFoundFoundBy(String name) {
    return 'found by $name';
  }

  @override
  String lostFoundLostBy(String name) {
    return 'lost by $name';
  }

  @override
  String get lostFoundTagFound => 'found';

  @override
  String get lostFoundTagSearching => 'searching';

  @override
  String get lostFoundBusy => 'One sec…';

  @override
  String get lostFoundFoundOwner => 'Owner found — move to \"Lost\"';

  @override
  String get lostFoundFoundItem => 'Item found — move to \"Found\"';

  @override
  String get lostFoundDelete => 'Delete listing';

  @override
  String lostFoundCall(String phone) {
    return 'Call $phone';
  }

  @override
  String get lostFoundContactUnavailable =>
      'The author chose not to share contact details';

  @override
  String get lostFoundContactConsent =>
      'Show my contact details to students at my university';

  @override
  String get lostFoundPhoneHint => 'Phone number (optional)';

  @override
  String get lostFoundDeleteConfirmTitle => 'Delete this listing?';

  @override
  String get lostFoundDeleteConfirmBody =>
      'The listing and its photos will be removed permanently.';

  @override
  String get lostFoundCleanupWarning =>
      'The listing was deleted, but some photos could not be cleaned up yet';

  @override
  String get lostFoundContactOpenError => 'Could not open this contact';

  @override
  String get lostFoundImageError =>
      'Use up to 5 JPEG, PNG, or WebP images, 8 MB each';

  @override
  String get lostFoundContact => 'Contact';

  @override
  String get lostFoundReportTitle => 'Report an item';

  @override
  String get lostFoundReportSub =>
      'students at your university will see the listing';

  @override
  String get lostFoundReport => 'Report';

  @override
  String get lostFoundTitle => 'Lost & Found';

  @override
  String lostFoundItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count listings',
      one: '$count listing',
    );
    return '$_temp0';
  }

  @override
  String get lostFoundSearch => 'Search';

  @override
  String get lostFoundSearchHint => 'What are we looking for?…';

  @override
  String lostFoundTabFound(int count) {
    return 'Found · $count';
  }

  @override
  String lostFoundTabLost(int count) {
    return 'Lost · $count';
  }

  @override
  String get lostFoundLoadError => 'Couldn\'\'t load listings';

  @override
  String get lostFoundLoadErrorSub => 'Pull down to try again';

  @override
  String get lostFoundEmptyFound => 'No found items yet';

  @override
  String get lostFoundEmptyLost => 'No lost items yet';

  @override
  String get lostFoundEmptySub =>
      'Found or lost something? Report it — we\'\'ll help find the owner';

  @override
  String get lostFoundStatusFoundMe => 'Found';

  @override
  String get lostFoundStatusLostMe => 'Lost';

  @override
  String get lostFoundTitleHint => 'What\'\'s the item? E.g. \"AirPods Pro\"';

  @override
  String get lostFoundLocationHint => 'Where? E.g. \"G-407, under the desk\"';

  @override
  String get lostFoundDetailsHint => 'Details: marks, when, circumstances…';

  @override
  String get lostFoundTelegramHint => 'Telegram to contact, e.g. @ninja';

  @override
  String get lostFoundPhotosLabel => 'Photos';

  @override
  String get lostFoundPublishing => 'Publishing…';

  @override
  String get lostFoundPublish => 'Publish';

  @override
  String get lostFoundPublishError =>
      'Could not publish the listing. Please try again';

  @override
  String get lostFoundActionError => 'Something went wrong. Please try again';

  @override
  String get servicesConfigure => 'Configure';

  @override
  String get servicesEditDone => 'Done';

  @override
  String get servicesConfigureHint =>
      'Tap a service to pin it. Press and drag to move it.';

  @override
  String get servicesMoveEarlier => 'Move earlier';

  @override
  String get servicesMoveLater => 'Move later';

  @override
  String get servicesSearchHint => 'Find a service or link';

  @override
  String get servicesSectionPinned => 'Pinned';

  @override
  String get servicesPinnedEmptyHint =>
      'Turn on Configure and tap a service to pin it here';

  @override
  String get servicesSectionAll => 'All services';

  @override
  String get servicesNowTitle => 'Right now';

  @override
  String get servicesNowSessionToday => 'Exam today — good luck!';

  @override
  String servicesNowSessionInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Session in $count days',
      one: 'Session in $count day',
    );
    return '$_temp0';
  }

  @override
  String servicesNowShurikens(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count shurikens',
      one: '$count shuriken',
    );
    return '$_temp0';
  }

  @override
  String get servicesBuildLabel => 'Your own mini-app';

  @override
  String get servicesBuildTitle =>
      'Build a service and share it with the university';

  @override
  String get servicesBuildSubtitle =>
      'TypeScript SDK · 5 minutes to your first deploy';

  @override
  String get servicesTabMain => 'Home';

  @override
  String get servicesTabDigital => 'Digital university';

  @override
  String get servicesSectionImportant => 'Important';

  @override
  String get servicesSectionCommunity => 'Community';

  @override
  String get servicesSectionMain => 'Main services';

  @override
  String get servicesSectionStudentLife => 'Student life';

  @override
  String get servicesSectionUseful => 'Useful';

  @override
  String get servicesFriendsMap => 'Friends on the map';

  @override
  String get servicesWallet => 'Wallet';

  @override
  String get servicesKnowledgeBank => 'Knowledge bank';

  @override
  String get servicesEvents => 'Events';

  @override
  String get servicesTeamFinder => 'Team finder';

  @override
  String get servicesMentorship => 'Mentorship';

  @override
  String get servicesMarketplace => 'Marketplace';

  @override
  String get servicesNotes => 'Notes';

  @override
  String get servicesMap => 'Map';

  @override
  String get deadlinesTitle => 'Deadlines';

  @override
  String get deadlinesFabLabel => 'Deadline';

  @override
  String get deadlinesCalendarTooltip => 'Calendar';

  @override
  String get createDeadlineTitle => 'Create deadline';

  @override
  String get createDeadlineButton => 'Create deadline';

  @override
  String deadlinesOnFire(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count on fire',
      one: '$count on fire',
    );
    return '$_temp0';
  }

  @override
  String deadlinesActive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count active',
      one: '$count active',
    );
    return '$_temp0';
  }

  @override
  String get deadlinesFilterAll => 'All';

  @override
  String get deadlinesFilterHot => 'Hot';

  @override
  String get deadlinesFilterMine => 'Personal';

  @override
  String get deadlinesFilterGroup => 'From group';

  @override
  String get deadlinesFilterDone => 'Done';

  @override
  String get deadlinesGroupWeek => 'This week';

  @override
  String get deadlinesGroupLater => 'Later';

  @override
  String get deadlinesEmptyTitle => 'No deadlines';

  @override
  String get deadlinesEmptySubtitle =>
      'Add your first one and keep your progress on track';

  @override
  String get deadlineToday => 'today';

  @override
  String get deadlineTomorrow => 'tomorrow';

  @override
  String get deadlineOverdue => 'overdue';

  @override
  String deadlineLeftHours(int count) {
    return '$count h';
  }

  @override
  String deadlineLeftDays(int count) {
    return '$count d';
  }

  @override
  String deadlineLeftWeeks(int count) {
    return '$count w';
  }

  @override
  String get deadlineDone => 'done';

  @override
  String get deadlineSourceMine => 'personal';

  @override
  String get deadlineSourceGroup => 'from group';

  @override
  String get deadlineSourceProf => 'from teacher';

  @override
  String get deadlineTitleHint => 'What to do?';

  @override
  String get deadlineSubjectHint => 'Subject (optional)';

  @override
  String get deadlineDateLabel => 'Date';

  @override
  String get deadlineTimeLabel => 'Time';

  @override
  String get deadlineQuickToday => 'Today';

  @override
  String get deadlineQuickTomorrow => 'Tomorrow';

  @override
  String get deadlineQuickWeek => 'In a week';

  @override
  String get deadlineQuickSession => 'By exams';

  @override
  String get deadlinePriorityLabel => 'PRIORITY';

  @override
  String get deadlinePriorityLow => 'Low';

  @override
  String get deadlinePriorityMedium => 'Medium';

  @override
  String get deadlinePriorityUrgent => 'Urgent';

  @override
  String get deadlineRemindTitle => 'Remind in advance';

  @override
  String get deadlineRemindSubtitle => 'a day before and 2 hours before';

  @override
  String get deadlineShareTitle => 'Share with group';

  @override
  String get deadlineShareSubtitle => 'all your groupmates will see it';

  @override
  String get deadlineSaving => 'Saving…';

  @override
  String get deadlinesLoadError => 'Could not load deadlines';

  @override
  String get deadlinesLoadErrorSubtitle =>
      'Check your connection and try again';

  @override
  String get deadlinesCreateError =>
      'Could not create the deadline. Try again.';

  @override
  String get deadlinesUpdateError =>
      'Could not update the deadline. Try again.';

  @override
  String get deadlinesRefreshError =>
      'Could not refresh the list. The current data may be outdated.';

  @override
  String get deadlinePastError => 'Choose a future date and time';

  @override
  String get deadlineMarkDone => 'Mark as done';

  @override
  String get deadlineMarkActive => 'Mark as active';

  @override
  String get loginWelcomeBack => 'Welcome back';

  @override
  String get loginSubtitle => 'Sign in with your account';

  @override
  String get loginEmailPlaceholder => 'name@example.com';

  @override
  String get loginEmailError => 'Enter a valid email address';

  @override
  String loginPasswordError(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'At least $count characters',
      one: 'At least $count character',
    );
    return '$_temp0';
  }

  @override
  String get loginForgotPassword => 'Forgot password?';

  @override
  String get loginSubmit => 'Sign in';

  @override
  String get loginOr => 'or';

  @override
  String get loginProviderElk => 'ELK MIREA';

  @override
  String get loginProviderGosuslugi => 'Gosuslugi';

  @override
  String get loginComingSoon => 'Coming soon';

  @override
  String get loginNoAccount => 'No account? ';

  @override
  String get loginGuest => 'Continue as guest';

  @override
  String get loginWithCode => 'Sign in with a code';

  @override
  String get loginGenericError =>
      'Couldn\'t sign in. Check your details and try again.';

  @override
  String get miniAppsTitle => 'Mini apps';

  @override
  String miniAppsSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count apps',
      one: '$count app',
      zero: 'no apps yet',
    );
    return '$_temp0';
  }

  @override
  String get miniAppsSearch => 'Search';

  @override
  String get miniAppsSearchHint => 'Search mini apps';

  @override
  String get miniAppsCreate => 'Create';

  @override
  String get miniAppsModeration => 'Moderation';

  @override
  String get miniAppsMyApps => 'My apps';

  @override
  String get miniAppsCatalogSection => 'Catalog';

  @override
  String get miniAppsEmptyTitle => 'No mini apps yet';

  @override
  String get miniAppsEmptySubtitle =>
      'Be the first: build a mini app on Stac JSON and publish it for all students';

  @override
  String get miniAppsNothingFound => 'Nothing found';

  @override
  String get miniAppsNothingFoundSubtitle =>
      'Try a different query or category';

  @override
  String miniAppsLaunches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count launches',
      one: '$count launch',
      zero: 'no launches',
    );
    return '$_temp0';
  }

  @override
  String get miniAppsOpen => 'Open';

  @override
  String get miniAppsAbout => 'About & rating';

  @override
  String get miniAppsHide => 'Hide from my catalog';

  @override
  String get miniAppsUnhide => 'Show in my catalog';

  @override
  String get miniAppsReport => 'Report';

  @override
  String get miniAppsAlreadyReported => 'Report sent';

  @override
  String get miniAppsReportTitle => 'Report mini app';

  @override
  String get miniAppsReportSubtitle => 'moderators will review it shortly';

  @override
  String get miniAppsReportDetailsHint => 'What is wrong? (optional)';

  @override
  String get miniAppsReportSend => 'Send report';

  @override
  String get miniAppsReportSending => 'Sending...';

  @override
  String get miniAppsReportSent => 'Report sent. Thank you!';

  @override
  String get miniAppsRate => 'Your rating';

  @override
  String get miniAppsDelete => 'Delete app';

  @override
  String get miniAppsCategoryAll => 'All';

  @override
  String get miniAppsCategoryStudy => 'Study';

  @override
  String get miniAppsCategoryCampus => 'Campus';

  @override
  String get miniAppsCategoryTools => 'Tools';

  @override
  String get miniAppsCategoryFun => 'Fun';

  @override
  String get miniAppsCategorySocial => 'Social';

  @override
  String get miniAppsCategoryOther => 'Other';

  @override
  String get miniAppsStatusDraft => 'Draft';

  @override
  String get miniAppsStatusPending => 'In review';

  @override
  String get miniAppsStatusPublished => 'Published';

  @override
  String get miniAppsStatusRejected => 'Rejected';

  @override
  String get miniAppsStatusSuspended => 'Suspended';

  @override
  String get miniAppsReasonSpam => 'Spam';

  @override
  String get miniAppsReasonInappropriate => 'Inappropriate';

  @override
  String get miniAppsReasonBroken => 'Broken';

  @override
  String get miniAppsReasonScam => 'Scam';

  @override
  String get miniAppsReasonPrivacy => 'Privacy';

  @override
  String get miniAppsReasonOther => 'Other';

  @override
  String get miniAppsRunnerNotFound => 'App not found';

  @override
  String get miniAppsRunnerNotFoundSubtitle =>
      'It may have been unpublished or removed';

  @override
  String get miniAppsRunnerError => 'Couldn\'t render the screen';

  @override
  String get miniAppsReload => 'Reload';

  @override
  String get miniAppsClose => 'Close app';

  @override
  String get miniAppsSubmitTitle => 'New mini app';

  @override
  String get miniAppsSubmitSubtitle => 'publishes after moderation';

  @override
  String get miniAppsSubmitNameHint => 'App name';

  @override
  String get miniAppsSubmitSlugHint => 'slug (latin, digits, dashes)';

  @override
  String get miniAppsSubmitDescriptionHint =>
      'Short description for the catalog';

  @override
  String get miniAppsSubmitCategory => 'Category';

  @override
  String get miniAppsSubmitSource => 'Screens source';

  @override
  String get miniAppsSubmitSourceSubtitle => 'hosted JSON or your own server';

  @override
  String get miniAppsSourceHosted => 'JSON in app';

  @override
  String get miniAppsSourceRemote => 'My server';

  @override
  String get miniAppsSubmitEntryPathHint => 'Entry path, e.g. /';

  @override
  String get miniAppsSubmitJsonHint => 'Stac screen JSON';

  @override
  String get miniAppsSubmitPreview => 'Preview';

  @override
  String get miniAppsSubmitSend => 'Submit for review';

  @override
  String get miniAppsSubmitSending => 'Submitting...';

  @override
  String get miniAppsSubmitDraft => 'Save as draft';

  @override
  String get miniAppsSubmitSuccess =>
      'Submitted! The app will appear after moderation.';

  @override
  String get miniAppsSubmitInvalidJson =>
      'Screen JSON is invalid — check the syntax';

  @override
  String get miniAppsSubmitInvalidFields =>
      'Check the name, slug and origin URL (https only)';

  @override
  String get miniAppsSubmitFailure =>
      'Couldn\'t submit. The slug may be taken.';

  @override
  String get miniAppsModerationTitle => 'Moderation';

  @override
  String get miniAppsModerationSubtitle => 'submissions and reports';

  @override
  String get miniAppsModerationEmpty => 'Queue is empty';

  @override
  String get miniAppsModerationEmptySubtitle =>
      'No pending apps or open reports';

  @override
  String get miniAppsModerationPending => 'Awaiting review';

  @override
  String get miniAppsModerationPendingSubtitle =>
      'tap a card to preview the app';

  @override
  String get miniAppsModerationReported => 'Reported';

  @override
  String get miniAppsModerationReportedSubtitle => 'apps with open reports';

  @override
  String get miniAppsModerationNotesHint => 'Notes for the author (optional)';

  @override
  String get miniAppsModerationConfirm => 'Confirm';

  @override
  String get miniAppsApprove => 'Approve';

  @override
  String get miniAppsRejectAction => 'Reject';

  @override
  String get miniAppsSuspend => 'Suspend';

  @override
  String get miniAppsRestore => 'Restore';

  @override
  String get miniAppsDismissReports => 'Dismiss reports';

  @override
  String get profileLoadErrorTitle => 'Failed to load profile';

  @override
  String get profileLoadErrorMessage =>
      'Check your connection and try again. Schedule and notes are available offline.';

  @override
  String get profileStudentFallback => 'Student';

  @override
  String profileCourseLabel(int course) {
    return '$course course';
  }

  @override
  String get profileLinkCopied => 'Profile copied';

  @override
  String get profileQuestsOfDay => 'Daily quests';

  @override
  String profileQuestsCountdown(int xp) {
    return 'until midnight · +$xp XP';
  }

  @override
  String get profileGroupLeaderboard => 'Group leaderboard';

  @override
  String get profileAchievements => 'Achievements';

  @override
  String get profileMaxRank => 'max rank';

  @override
  String profileLevel(int level) {
    return 'Level $level';
  }

  @override
  String profileXpOfLevel(int current, int total) {
    return '$current / $total XP';
  }

  @override
  String profileRankNextXp(int xp, String rank) {
    return '$xp XP to $rank';
  }

  @override
  String get profileStatStreakDays => 'day streak';

  @override
  String get profileStatBadges => 'achievements';

  @override
  String get profileBadgesSection => 'Achievements';

  @override
  String get profileStatGroupRank => 'rank in group';

  @override
  String get profileBadgeUnlocked => 'New achievement';

  @override
  String get profileBadgeEarned => 'Earned';

  @override
  String get profileBadgeLocked => 'Locked';

  @override
  String get profileSectionLoadFailed => 'Couldn\'t load this section';

  @override
  String get profileShopTitle => 'Shuriken shop';

  @override
  String get profileShopSubtitle => 'Icons, themes, emoji packs';

  @override
  String get profileShopComingSoon => 'Coming soon';

  @override
  String get profileAccount => 'Account';

  @override
  String get profileSignOut => 'Sign out';

  @override
  String get profileSignOutConfirm => 'Sign out?';

  @override
  String profileStreakDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days ',
      one: '$days day ',
    );
    return '$_temp0';
  }

  @override
  String get profileStreakWord => 'streak';

  @override
  String get profileStreakHint => 'Keep your streak every day';

  @override
  String profileStreakRecord(int record, int more) {
    String _temp0 = intl.Intl.pluralLogic(
      record,
      locale: localeName,
      other: '$record days',
      one: '$record day',
    );
    return 'Record $_temp0 · $more more to beat it';
  }

  @override
  String get profileStreakRecordBeaten => 'Your personal best!';

  @override
  String profileStreakDaysAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days ago',
      one: '$days day ago',
    );
    return '$_temp0';
  }

  @override
  String get profileStreakToday => 'today';

  @override
  String get ninjaPathTitle => 'Ninja path';

  @override
  String get ninjaPathTabBadges => 'Badges';

  @override
  String get ninjaPathTabQuests => 'Quests';

  @override
  String get ninjaPathTabRating => 'Rating';

  @override
  String get ninjaPathLoadError => 'Loading error';

  @override
  String get ninjaPathToday => 'Today';

  @override
  String get ninjaPathThisWeek => 'This week';

  @override
  String get ninjaPathNoData => 'No data';

  @override
  String get ninjaPathScopeGroup => 'Group';

  @override
  String get ninjaPathScopeCourse => 'Stream';

  @override
  String get ninjaPathScopeFaculty => 'Institute';

  @override
  String get ninjaPathScopeAll => 'All uni';

  @override
  String ninjaRankRow(int level) {
    return 'Level $level · Rank';
  }

  @override
  String get ninjaRankBadges => 'badges';

  @override
  String get ninjaRankStreak => 'day streak';

  @override
  String get ninjaRankShurikens => 'shurikens';

  @override
  String miniAppsConsentTitle(String name) {
    return '$name requests access';
  }

  @override
  String get miniAppsConsentSubtitle => 'you choose what the developer sees';

  @override
  String get miniAppsConsentBody =>
      'This mini app is run by a third-party developer. Choose what to share — everything below is optional, the app works either way.';

  @override
  String get miniAppsConsentFootnote =>
      'Your password and session are never shared. Without grants the developer only sees an anonymous ID. You can change this anytime in the app menu.';

  @override
  String get miniAppsConsentAllow => 'Allow selected';

  @override
  String get miniAppsConsentDenyAll => 'Share nothing';

  @override
  String get miniAppsPermissionsSection => 'Data permissions';

  @override
  String get miniAppsSubmitPermissions => 'Requested data';

  @override
  String get miniAppsSubmitPermissionsSubtitle =>
      'users will be asked for consent on first launch';

  @override
  String get miniAppsPermIdentity => 'User ID';

  @override
  String get miniAppsPermIdentityDesc => 'Stable identifier of your account';

  @override
  String get miniAppsPermEmail => 'Email';

  @override
  String get miniAppsPermEmailDesc => 'Your university email address';

  @override
  String get miniAppsPermProfile => 'Name and course';

  @override
  String get miniAppsPermProfileDesc => 'Full name and current course';

  @override
  String get miniAppsPermGroup => 'Academic group';

  @override
  String get miniAppsPermGroupDesc => 'Your group code, e.g. ABCD-01-23';

  @override
  String get toolsTitle => 'Links';

  @override
  String get toolsSearchHint => 'Search links';

  @override
  String get toolsSearchClose => 'Close search';

  @override
  String get toolsCommunitySection => 'App community';

  @override
  String get toolsCommunitySectionSubtitle => 'an open-source student project';

  @override
  String get toolsCardGithubSubtitle => 'Source code on GitHub';

  @override
  String get toolsCardChatTitle => 'App chat';

  @override
  String get toolsCardChatSubtitle => 'Telegram @mirea_ninja_chat';

  @override
  String get toolsCardRoadmapTitle => 'Roadmap';

  @override
  String get toolsCardRoadmapSubtitle => 'What\'s in progress and next';

  @override
  String get toolsCardBugTitle => 'Report a bug';

  @override
  String get toolsCardBugSubtitle => 'Straight to the GitHub tracker';

  @override
  String toolsContributorsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count students are building this app',
      one: '$count student is building this app',
    );
    return '$_temp0';
  }

  @override
  String get toolsContributorsLoading => 'Loading contributors…';

  @override
  String get toolsBecomeContributor => 'Become a contributor';

  @override
  String get toolsGroupStudy => 'Study';

  @override
  String get toolsGroupGov => 'Government services';

  @override
  String get toolsGroupCommunity => 'Community';

  @override
  String get toolsLinkEducationalPortal => 'Educational portal';

  @override
  String get toolsLinkLibrary => 'Electronic library';

  @override
  String get toolsLinkAntiplagiat => 'Anti-plagiarism';

  @override
  String get toolsLinkModeus => 'Modeus';

  @override
  String get toolsLinkGosuslugi => 'Gosuslugi';

  @override
  String get toolsLinkSber => 'SberBank scholarship';

  @override
  String get toolsLinkTroika => 'Troika card';

  @override
  String get toolsLinkNewsChannel => '@mirea_news';

  @override
  String get toolsLinkCtfTeam => '@ctf_keeper';

  @override
  String get toolsServiceTitle => 'Links';

  @override
  String get freeRoomsSubtitle => 'by the live schedule';

  @override
  String get freeRoomsRefresh => 'Refresh';

  @override
  String get freeRoomsAllBuildings => 'All buildings';

  @override
  String get freeRoomsSummaryLabel => 'rooms free right now';

  @override
  String freeRoomsNow(String time) {
    return 'now $time';
  }

  @override
  String get freeRoomsEmptyTitle => 'No free rooms';

  @override
  String get freeRoomsEmptySub => 'Every room is busy — try again later';

  @override
  String get freeRoomsUntilEndOfDay => 'until end of day';

  @override
  String freeRoomsFreeUntil(String time) {
    return 'until $time';
  }

  @override
  String freeRoomsCampus(String campus) {
    return 'campus $campus';
  }

  @override
  String get knowledgeTitle => 'Knowledge bank';

  @override
  String knowledgeSubtitle(int count) {
    return '$count materials from students';
  }

  @override
  String get knowledgeUpload => 'Upload';

  @override
  String get knowledgeUploadTitle => 'Upload material';

  @override
  String get knowledgeUploadSubtitle => 'share your notes — earn shurikens';

  @override
  String get knowledgeChipAll => 'All';

  @override
  String get knowledgeChipNotes => 'Notes';

  @override
  String get knowledgeChipTickets => 'Tickets';

  @override
  String get knowledgeChipSolutions => 'Solutions';

  @override
  String get knowledgeChipCheats => 'Cheatsheets';

  @override
  String get knowledgeTypeNote => 'Note';

  @override
  String get knowledgeTypeExam => 'Tickets';

  @override
  String get knowledgeTypeTask => 'Solutions';

  @override
  String get knowledgeTypeCheat => 'Cheatsheet';

  @override
  String get knowledgeBalanceHint =>
      'your balance — paid materials deduct shurikens';

  @override
  String get knowledgeEmptyTitle => 'Nothing here yet';

  @override
  String get knowledgeEmptySub =>
      'Upload the first note — earn shurikens for every download';

  @override
  String get knowledgeTopAuthors => 'Top authors';

  @override
  String get knowledgeMaterialNoAttachment => 'No attachment';

  @override
  String get knowledgeMaterialRepublishRequired => 'Needs re-upload';

  @override
  String knowledgePages(int n) {
    return '$n pp.';
  }

  @override
  String knowledgeAuthorStats(int downloads, int materials) {
    return '$downloads · $materials mat.';
  }

  @override
  String get knowledgeUploadTypeLabel => 'TYPE';

  @override
  String get knowledgeUploadFilePrompt => 'Drop a file or pick one';

  @override
  String get knowledgeUploadFileHint => 'PDF, DOCX, photo · up to 50 MB';

  @override
  String knowledgeUploadFileSize(String size) {
    return '$size MB';
  }

  @override
  String get knowledgeUploadTitleHint => 'Title (ML lecture notes…)';

  @override
  String get knowledgeUploadSubjectHint => 'Subject';

  @override
  String get knowledgeUploadPriceLabel => 'Price';

  @override
  String get knowledgeUploadDecreasePrice => 'Decrease price';

  @override
  String get knowledgeUploadIncreasePrice => 'Increase price';

  @override
  String get knowledgeUploadPriceHint => '0 — free · you get 70%';

  @override
  String get knowledgeUploadAnonymous => 'Anonymous';

  @override
  String knowledgeUploadReward(int amount) {
    return 'We\'ll award +$amount shurikens for the material';
  }

  @override
  String get knowledgeUploadPublishing => 'Uploading…';

  @override
  String get knowledgeUploadPublish => 'Publish';

  @override
  String get walletTitle => 'Wallet';

  @override
  String get walletBalanceLabel => 'BALANCE';

  @override
  String get walletStreakDays => 'days streak';

  @override
  String get walletInGroup => 'in group';

  @override
  String get walletLevel => 'level';

  @override
  String get walletExplainer =>
      'Shurikens are points for activity. Spend them inside the app.';

  @override
  String get walletExplainerNoCash => 'They cannot be withdrawn for cash.';

  @override
  String get walletTabEarn => 'Earn';

  @override
  String get walletTabSpend => 'Spend';

  @override
  String get walletTabHistory => 'History';

  @override
  String get walletEarnLiveTag => 'now';

  @override
  String get walletEarnAttendTitle => 'Attend classes';

  @override
  String get walletEarnAttendDesc => 'geolocation check-in';

  @override
  String get walletEarnAttendPer => 'per class';

  @override
  String get walletEarnStreakTitle => 'Keep your streak';

  @override
  String get walletEarnStreakDesc => 'every day in a row';

  @override
  String get walletEarnStreakPer => 'grows';

  @override
  String get walletEarnUploadTitle => 'Upload notes';

  @override
  String get walletEarnUploadDesc => 'to the Knowledge Bank';

  @override
  String get walletEarnUploadPer => 'per material';

  @override
  String get walletEarnDownloadTitle => 'Your material gets downloaded';

  @override
  String get walletEarnDownloadDesc => '70% of the price to the author';

  @override
  String get walletEarnDownloadPer => 'per download';

  @override
  String get walletEarnLikeTitle => 'Likes on materials';

  @override
  String get walletEarnLikeDesc => 'community ratings';

  @override
  String get walletEarnLikePer => 'per ★';

  @override
  String get walletEarnQuestTitle => 'Complete quests';

  @override
  String get walletEarnQuestDesc => 'daily and weekly';

  @override
  String get walletEarnQuestPer => 'per quest';

  @override
  String get walletEarnChatTitle => 'Help in chats';

  @override
  String get walletEarnChatDesc => 'accepted answers';

  @override
  String get walletEarnChatPer => 'per answer';

  @override
  String get walletEarnFoundTitle => 'Return a found item';

  @override
  String get walletEarnFoundDesc => 'via Lost & Found';

  @override
  String get walletEarnFoundPer => 'per item';

  @override
  String get walletEarnReferralTitle => 'Invite a friend';

  @override
  String get walletEarnReferralDesc => 'by referral link';

  @override
  String get walletEarnReferralPer => 'per friend';

  @override
  String get walletSpendSectionTitle => 'Spend inside the app';

  @override
  String get walletSpendPartnersLater => 'Partner rewards are coming later.';

  @override
  String get walletSpendMaterialsTitle => 'Materials in the Knowledge Bank';

  @override
  String get walletSpendMaterialsDesc => 'notes, tickets, solutions';

  @override
  String get walletSpendMaterialsCost => 'from 10';

  @override
  String get walletSpendBoostTitle => 'Boost a post in the feed';

  @override
  String get walletSpendBoostDesc => 'show it to more people';

  @override
  String get walletSpendBoostCost => '50';

  @override
  String get walletSpendThemesTitle => 'App themes and icons';

  @override
  String get walletSpendThemesDesc => 'customization';

  @override
  String get walletSpendProTitle => 'Ninja Pro for a month';

  @override
  String get walletSpendProDesc => 'no ads and perks';

  @override
  String get walletHistoryEmptyTitle => 'History is empty';

  @override
  String get walletHistoryEmptySub =>
      'Complete quests and spend shurikens — every operation will show up here';

  @override
  String walletHistoryToday(String time) {
    return 'today $time';
  }

  @override
  String walletHistoryYesterday(String time) {
    return 'yesterday $time';
  }

  @override
  String get marketTitle => 'Market';

  @override
  String marketSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'buy-sell among your own · $count lots',
      one: 'buy-sell among your own · $count lot',
    );
    return '$_temp0';
  }

  @override
  String get marketCatAll => 'All';

  @override
  String get marketCatBooks => 'Textbooks';

  @override
  String get marketCatTech => 'Tech';

  @override
  String get marketCatCloth => 'Clothes';

  @override
  String get marketCatFree => 'Free';

  @override
  String get marketCatOther => 'Other';

  @override
  String get marketFree => 'Free';

  @override
  String get priceFree => 'Free';

  @override
  String marketPrice(String price) {
    return '$price₽';
  }

  @override
  String get marketSold => 'sold';

  @override
  String get marketYesterday => 'yesterday';

  @override
  String get marketEmptyTitle => 'Nothing here yet';

  @override
  String get marketEmptySub =>
      'List your first item — textbooks and tech get snapped up fast';

  @override
  String get marketSell => 'Sell';

  @override
  String get marketSellTitle => 'Sell an item';

  @override
  String get marketSellSubtitle => 'every student will see the listing';

  @override
  String get marketTitleHint => 'What are you selling?';

  @override
  String get marketPriceHint => 'Price, ₽';

  @override
  String get marketDescriptionHint =>
      'Description (condition, where to pick up…)';

  @override
  String get marketPublish => 'Publish';

  @override
  String get marketPublishing => 'Publishing…';

  @override
  String get marketLoadError => 'Couldn\'t load the marketplace';

  @override
  String get marketLoadErrorSubtitle => 'Check your connection and try again.';

  @override
  String get marketRefreshError => 'Couldn\'t refresh listings';

  @override
  String get marketCreateError => 'Couldn\'t publish the listing';

  @override
  String get marketMutationError => 'Couldn\'t update the listing';

  @override
  String get marketDelete => 'Delete listing';

  @override
  String get marketDeleteConfirmTitle => 'Delete this listing?';

  @override
  String get marketDeleteConfirmBody =>
      'It will disappear from the marketplace permanently.';

  @override
  String get marketMarkSold => 'Mark as sold';

  @override
  String get marketMarkAvailable => 'Mark as available';

  @override
  String get marketDetailsTitle => 'Listing details';

  @override
  String get marketContactSeller => 'Message seller on Telegram';

  @override
  String get marketContactUnavailable => 'Seller contact isn\'t available';

  @override
  String get marketTelegramOpenError => 'Couldn\'t open Telegram';

  @override
  String get marketDescriptionEmpty => 'The seller didn\'t add a description.';

  @override
  String get marketSellerFallback => 'Student';

  @override
  String get marketContactConsent => 'Show my Telegram handle';

  @override
  String get marketContactConsentHint =>
      'Only students from your university can see it. You can publish without contact details.';

  @override
  String get marketPriceInvalid => 'Enter a price greater than zero';

  @override
  String marketPriceHintWithCurrency(String currency) {
    return 'Price, $currency';
  }

  @override
  String get marketOpenDetails => 'Open listing details';

  @override
  String get onboardingTagline =>
      'Schedule, map, grades and community — all in one pocket.';

  @override
  String get onboardingSignInMirea => 'Sign in with MIREA';

  @override
  String get onboardingGroupTitle => 'Your group';

  @override
  String get onboardingGroupHint => 'Start typing your group code';

  @override
  String get onboardingGroupSearchHint => 'Group code…';

  @override
  String get onboardingGroupEmpty => 'No groups found';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingPermTitle => 'Last touch';

  @override
  String get onboardingPermSubtitle => 'Allow these and the app opens up fully';

  @override
  String get onboardingPermNotificationsTitle => 'Notifications';

  @override
  String get onboardingPermNotificationsDesc =>
      'reminders about classes and changes';

  @override
  String get onboardingPermLocationTitle => 'Location';

  @override
  String get onboardingPermLocationDesc => 'campus navigation';

  @override
  String get onboardingPermNote =>
      'Change anytime in Settings. We don\'t share your data.';

  @override
  String get onboardingPermCta => 'Let\'s go';

  @override
  String get settingsAppTour => 'App tour';

  @override
  String get tourNavTitle => 'Five sections, one bar';

  @override
  String get tourNavBody =>
      'Home, schedule, campus map, services and your profile. Tap the active tab again to jump back to the top.';

  @override
  String get tourSearchTitle => 'Search the whole campus';

  @override
  String get tourSearchBody =>
      'Classes, lecturers, rooms, people and discussions — from the header of every root screen.';

  @override
  String get tourDaysTitle => 'Your week at a glance';

  @override
  String get tourDaysBody =>
      'Pick a day here, or swipe the board below left and right. Dots show how loaded the day is.';

  @override
  String get tourBoardTitle => 'What is happening now';

  @override
  String get tourBoardBody =>
      'The current or next class with its timer, room and the timeline of the whole day.';

  @override
  String get tourServicesTitle => 'Shortcuts you use daily';

  @override
  String get tourServicesBody =>
      'Campus pass, map and the rest — one tap away. You choose what lives here in settings.';

  @override
  String get tourScheduleViewsTitle => 'Day, week, month';

  @override
  String get tourScheduleViewsBody =>
      'Three ways to read the schedule. Switch anytime — the selected day follows you.';

  @override
  String get tourScheduleWeekTitle => 'Swipe through weeks';

  @override
  String get tourScheduleWeekBody =>
      'Swipe the strip for other weeks and tap a date to open it.';

  @override
  String get tourCatalogTitle => 'Every service in one list';

  @override
  String get tourCatalogBody =>
      'Search the catalog and drag the tiles you need into the pinned row.';

  @override
  String get tourProfileTitle => 'Your ninja path';

  @override
  String get tourProfileBody =>
      'Experience, streaks and achievements grow as you attend and use the app.';

  @override
  String get tourDoneTitle => 'That is the tour';

  @override
  String get tourDoneBody =>
      'Take it again anytime: Profile → Settings → App tour.';

  @override
  String get tourNext => 'Next';

  @override
  String get tourBack => 'Back';

  @override
  String get tourSkip => 'Skip';

  @override
  String get tourFinish => 'Done';

  @override
  String tourProgress(int current, int total) {
    return '$current of $total';
  }

  @override
  String get miniAppsSubmitAddScreen => 'Add screen';

  @override
  String get miniAppsSubmitScreenPathHint => 'Screen path, e.g. /stats';

  @override
  String get miniAppsSubmitRemoveScreen => 'Remove screen';

  @override
  String get miniAppsSubmitInvalidScreens =>
      'Check screens: paths must be unique latin paths and include /';

  @override
  String get peopleTitle => 'People';

  @override
  String get peopleLoadError => 'Couldn’t load people';

  @override
  String get peopleLoadErrorSubtitle => 'Check your connection and try again.';

  @override
  String get peopleGroupLoadError => 'Could not check your group';

  @override
  String get peopleGroupLoadErrorSubtitle =>
      'We will not create another group until your current membership is restored. Try again.';

  @override
  String get peoplePartialLoadError =>
      'Some people data could not be refreshed. Showing the latest available data.';

  @override
  String get peopleActionError =>
      'Couldn’t complete the action. Please try again.';

  @override
  String get lessonEditorSubjectRequired => 'Enter a subject name.';

  @override
  String get lessonEditorInvalidTimeRange =>
      'The lesson must end after it starts.';

  @override
  String get lessonEditorDuplicateError =>
      'An identical lesson already exists.';

  @override
  String get lessonEditorScheduleMissing =>
      'This schedule or lesson is no longer available.';

  @override
  String get lessonEditorSaveError =>
      'Couldn’t save the lesson. Please try again.';

  @override
  String get customScheduleSyncInProgress => 'Syncing schedules';

  @override
  String get customScheduleSyncInProgressSubtitle =>
      'Saving the latest version to your account.';

  @override
  String get customScheduleSyncPending => 'Changes saved on this device';

  @override
  String get customScheduleSyncPendingSubtitle =>
      'Cloud backup will start shortly.';

  @override
  String get customScheduleSyncOffline => 'Cloud backup is pending';

  @override
  String get customScheduleSyncOfflineSubtitle =>
      'Your schedules are safe on this device. Retry when you’re online.';

  @override
  String get customScheduleSyncConflict => 'A newer cloud version was detected';

  @override
  String get customScheduleSyncConflictSubtitle =>
      'Your local changes were kept. Retry to reconcile the versions.';

  @override
  String get peopleRequestSent => 'Friend request sent';

  @override
  String peopleTabFriends(int count) {
    return 'Friends · $count';
  }

  @override
  String peopleTabGroup(int count) {
    return 'My group · $count';
  }

  @override
  String peopleRequestsLabel(int count) {
    return 'Requests · $count';
  }

  @override
  String get peopleLiveNow => 'Live now';

  @override
  String get peopleAllFriends => 'All friends';

  @override
  String get peopleEmptyFriendsTitle => 'No friends yet';

  @override
  String get peopleEmptyFriendsSub =>
      'Add classmates — see them on the map and in activity';

  @override
  String get peopleFindFriends => 'Find friends';

  @override
  String get peopleMapTitle => 'Friends on the map';

  @override
  String get peopleMapOpen => 'Open the friends map';

  @override
  String peopleFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count friends online',
      one: '1 friend online',
    );
    return '$_temp0';
  }

  @override
  String get peopleOnline => 'online';

  @override
  String get peopleGroupTitle => 'My group';

  @override
  String peopleGroupCourse(int count) {
    return '$count year';
  }

  @override
  String peopleGroupPeople(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count people',
      one: '1 person',
    );
    return '$_temp0';
  }

  @override
  String peopleGroupInFriends(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count in friends',
      one: '1 in friends',
    );
    return '$_temp0';
  }

  @override
  String get peopleGroupSpaceTitle => 'Group space';

  @override
  String get peopleGroupSpaceSub => 'notes · links · birthdays';

  @override
  String get peopleEmptyGroupTitle => 'Group is still empty';

  @override
  String get peopleEmptyGroupSub =>
      'Classmates will appear here automatically once they open the app';

  @override
  String get peopleGroupList => 'Group list';

  @override
  String get peoplePrivacyNote =>
      'Classmates appear here automatically. You share location and activity only with those you\'\'ve added as friends.';

  @override
  String get peopleTagYou => 'it\'\'s you';

  @override
  String get peopleTagFriend => 'friend';

  @override
  String get peopleTagRequest => 'request';

  @override
  String get peopleAddToFriends => 'Add';

  @override
  String groupSpaceHeaderSubtitleGroup(String group) {
    return '$group · just us';
  }

  @override
  String get groupSpaceHeaderSubtitle => 'just us';

  @override
  String get groupSpaceMyGroup => 'My group';

  @override
  String groupSpaceMembers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count people',
      one: '1 person',
    );
    return '$_temp0';
  }

  @override
  String get groupSpaceAddTelegramTitle => 'Telegram link';

  @override
  String get groupSpaceAddLinkTitle => 'Add link';

  @override
  String get groupSpaceAddTelegramSubtitle =>
      'no chat in the app — only in Telegram';

  @override
  String groupSpaceAddLinkSubtitleGroup(String group) {
    return 'the whole group $group will see it';
  }

  @override
  String get groupSpaceAddLinkSubtitle => 'the whole group will see it';

  @override
  String get groupSpaceAnnouncementSheetTitle => 'Group announcement';

  @override
  String get groupSpaceNoteSheetTitle => 'Share a note';

  @override
  String get groupSpaceSectionAnnouncement => 'Headman\'\'s announcement';

  @override
  String get groupSpaceSectionLinks => 'Useful links';

  @override
  String get groupSpaceSectionNotes => 'Group notes';

  @override
  String get groupSpaceSectionBirthdays => 'Birthdays coming up';

  @override
  String get groupSpaceActionNew => '+ New';

  @override
  String get groupSpaceActionAdd => '+ Add';

  @override
  String get groupSpaceOpen => 'Open';

  @override
  String get groupSpaceAddTelegramRow =>
      'Add a link to the group chat in Telegram';

  @override
  String get groupSpaceAnnouncementEmpty =>
      'No announcements yet — the headman can write the first one';

  @override
  String get groupSpaceLinksEmpty =>
      'Add a drive with lectures, a duty schedule or class recordings';

  @override
  String get groupSpaceNotesPlaceholder => 'Share your notes with the group…';

  @override
  String get groupSpaceNotePinned => 'pinned';

  @override
  String groupSpaceLinkAddedBy(String name) {
    return 'added by $name';
  }

  @override
  String get groupSpaceBirthdayToday => 'today';

  @override
  String get groupSpaceBirthdayTomorrow => 'tomorrow';

  @override
  String groupSpaceBirthdayInDays(int days) {
    return 'in $days d';
  }

  @override
  String get groupSpaceBirthdayYou => 'You';

  @override
  String groupSpaceTimeMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String groupSpaceTimeHours(int hours) {
    return '$hours h';
  }

  @override
  String get groupSpaceTimeYesterday => 'yesterday';

  @override
  String groupSpaceTimeDays(int days) {
    return '$days d';
  }

  @override
  String get groupSpaceLinkSheetWhereLabel => 'WHERE IT LEADS';

  @override
  String get groupSpaceLinkSheetHandleLabel => 'HANDLE OR LINK';

  @override
  String get groupSpaceLinkSheetUrlLabel => 'LINK';

  @override
  String get groupSpaceLinkSheetTitleLabel => 'NAME';

  @override
  String get groupSpaceLinkSheetCategoryLabel => 'CATEGORY';

  @override
  String get groupSpaceLinkSheetTgHint => 't.me/ikbo09_chat';

  @override
  String get groupSpaceLinkSheetUrlHint => 'drive.google.com/…';

  @override
  String get groupSpaceLinkSheetTitleHintTg => 'Group chat';

  @override
  String get groupSpaceLinkSheetTitleHint => 'Drive with ML lectures';

  @override
  String get groupSpaceLinkRecognized => 'recognized automatically';

  @override
  String get groupSpaceLinkCheck => 'Check';

  @override
  String get groupSpaceLinkPrivacyNote =>
      'Mirea Ninja does not store messages. All chats stay in Telegram, and classmates will see the link.';

  @override
  String get groupSpaceTgDestChat => 'Group chat';

  @override
  String get groupSpaceTgDestProfile => 'My profile';

  @override
  String get groupSpaceTgDestChannel => 'Channel';

  @override
  String get groupSpaceCatStudy => 'Study';

  @override
  String get groupSpaceCatDrive => 'Drive';

  @override
  String get groupSpaceCatDuty => 'Duty';

  @override
  String get groupSpaceCatRecords => 'Recordings';

  @override
  String get groupSpaceCatOther => 'Other';

  @override
  String get groupSpaceRecognizedDrive => 'Google Drive · folder';

  @override
  String get groupSpaceRecognizedDocs => 'Google Docs';

  @override
  String get groupSpaceRecognizedTelegram => 'Telegram';

  @override
  String get groupSpaceRecognizedLms => 'LMS MIREA';

  @override
  String get groupSpaceRecognizedGithub => 'GitHub';

  @override
  String get groupSpaceRecognizedYoutube => 'YouTube';

  @override
  String get groupSpaceSaving => 'Saving…';

  @override
  String get groupSpaceSaveTelegram => 'Save link';

  @override
  String get groupSpaceSaveLink => 'Add to group';

  @override
  String get groupSpacePostTitleHintAnnouncement => 'What happened?';

  @override
  String get groupSpacePostTitleHintNote => 'Note title';

  @override
  String get groupSpacePostBodyHint => 'Details (optional)';

  @override
  String get groupSpacePublishing => 'Publishing…';

  @override
  String get groupSpacePublish => 'Publish';

  @override
  String get postDetailTitle => 'Post';

  @override
  String get postDetailLoadError => 'Couldn\'t load the post';

  @override
  String postDetailComments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count comments',
      one: '1 comment',
      zero: 'Comments',
    );
    return '$_temp0';
  }

  @override
  String get postDetailNoComments => 'No comments yet';

  @override
  String get teamFinderTitle => 'Find a team';

  @override
  String get teamFinderSubtitle => 'hackathons · projects · coursework';

  @override
  String get teamFinderCreateCta => 'Build a team';

  @override
  String get teamFinderFilterAll => 'All';

  @override
  String get teamFinderFilterMine => 'Mine';

  @override
  String get teamFinderKindHackathon => 'Hackathon';

  @override
  String get teamFinderKindProject => 'Project';

  @override
  String get teamFinderKindStudy => 'Study';

  @override
  String get teamFinderFilterHackathons => 'Hackathons';

  @override
  String get teamFinderFilterProjects => 'Projects';

  @override
  String get teamFinderFilterStudy => 'Study';

  @override
  String get teamFinderEmptyTitle => 'No teams yet';

  @override
  String get teamFinderEmptySubtitle =>
      'Build your own — for a hackathon, coursework or a pet project';

  @override
  String get teamFinderApplicationSent => 'Application sent';

  @override
  String get teamFinderApplySheetTitle => 'Apply';

  @override
  String teamFinderApplicationsSheetTitle(String team) {
    return 'Applications · $team';
  }

  @override
  String get teamFinderCreateSheetTitle => 'Build a team';

  @override
  String get teamFinderCreateSheetSubtitle =>
      'we\'ll find people for your task';

  @override
  String get teamFinderTagBurning => 'burning';

  @override
  String get teamFinderTagTop => 'top';

  @override
  String teamFinderDeadlineUntil(String date) {
    return 'until $date';
  }

  @override
  String teamFinderLookingForRole(String role) {
    return 'looking for: $role';
  }

  @override
  String teamFinderMembersOf(int count, int capacity) {
    return '$count/$capacity on the team';
  }

  @override
  String teamFinderApplicationsCount(int count) {
    return 'Applications · $count';
  }

  @override
  String get teamFinderNoApplications => 'No applications';

  @override
  String get teamFinderOnTeam => 'On the team';

  @override
  String get teamFinderApplied => 'Application sent';

  @override
  String get teamFinderFull => 'No spots';

  @override
  String get teamFinderApply => 'Apply';

  @override
  String get teamFinderCreateNameLabel => 'NAME';

  @override
  String get teamFinderCreateNameHint => 'Campus app for students';

  @override
  String get teamFinderCreateDescriptionLabel => 'DESCRIPTION';

  @override
  String get teamFinderCreateDescriptionHint =>
      'We have a backend and an idea. Building it over the weekend…';

  @override
  String get teamFinderCreateRolesLabel => 'WHO I\'M LOOKING FOR';

  @override
  String get teamFinderRoleFrontend => 'Frontend';

  @override
  String get teamFinderRoleMl => 'ML';

  @override
  String get teamFinderRoleDesign => 'Design';

  @override
  String get teamFinderRoleBackend => 'Backend';

  @override
  String get teamFinderRoleMarketing => 'Marketing';

  @override
  String teamFinderRoleSelected(String role) {
    return '$role';
  }

  @override
  String get teamFinderCreateSizeLabel => 'Team size';

  @override
  String get teamFinderCreateDeadlineLabel => 'Deadline';

  @override
  String get teamFinderCreateDeadlineEmpty =>
      'we\'ll mark it as \"burning\" closer to the date';

  @override
  String get teamFinderCreateBoostTitle => 'Boost to top for 50 shurikens';

  @override
  String get teamFinderCreateBoostSubtitle => 'people see it first all day';

  @override
  String get teamFinderPublishing => 'Publishing…';

  @override
  String get teamFinderPublish => 'Publish';

  @override
  String teamFinderApplyMembersInfo(int count, int capacity, String roles) {
    return '$count/$capacity on the team$roles';
  }

  @override
  String teamFinderApplyNeededRoles(String roles) {
    return ' · need $roles';
  }

  @override
  String teamFinderApplyDeadline(String date) {
    return 'deadline by $date';
  }

  @override
  String get teamFinderApplyRoleLabel => 'FOR WHICH ROLE';

  @override
  String get teamFinderApplyAboutLabel => 'A FEW WORDS ABOUT YOU';

  @override
  String get teamFinderApplyAboutHint =>
      'Built 3 projects in React, I have a portfolio…';

  @override
  String get teamFinderApplyPreviewLabel => 'WHAT THE AUTHOR SEES';

  @override
  String get teamFinderApplyYou => 'You';

  @override
  String teamFinderApplyYouNamed(String name) {
    return 'You · $name';
  }

  @override
  String get teamFinderApplyAttachProfile => 'Attach profile and group';

  @override
  String get teamFinderSending => 'Sending…';

  @override
  String get teamFinderSendApplication => 'Send application';

  @override
  String get teamFinderApplicationsEmptyTitle => 'No applications yet';

  @override
  String get teamFinderApplicationsEmptySubtitle =>
      'Boost your team to the top — more people will see it';

  @override
  String get teamFinderWriteTelegram => 'Message on Telegram';

  @override
  String get mentorshipTitle => 'Mentorship';

  @override
  String mentorshipHeaderSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mentors',
      one: '$count mentor',
    );
    return 'seniors help juniors · $_temp0';
  }

  @override
  String get mentorshipMyProfileTitle => 'My mentor profile';

  @override
  String get mentorshipBecomeTitle => 'Become a mentor';

  @override
  String get mentorshipBecomeSubtitle =>
      'help juniors — earn shurikens and reputation';

  @override
  String get mentorshipRequestSheetTitle => 'Request to a mentor';

  @override
  String get mentorshipRequestSent => 'Request sent';

  @override
  String get mentorshipYouAreMentor => 'You\'re a mentor';

  @override
  String get mentorshipBecomeCta => 'Become a mentor';

  @override
  String get mentorshipEditHint => 'edit topics or profile';

  @override
  String get mentorshipBecomeHint => 'Help out and earn shurikens + reputation';

  @override
  String get mentorshipRequestsToYou => 'REQUESTS TO YOU';

  @override
  String get mentorshipEmptyTitle => 'No mentors yet';

  @override
  String get mentorshipEmptySubtitle =>
      'Be the first — help junior years with studies and careers';

  @override
  String mentorshipCourse(int course) {
    return 'year $course';
  }

  @override
  String get mentorshipItsYou => 'it\'s you';

  @override
  String get mentorshipEditProfile => 'Edit profile';

  @override
  String get mentorshipNoHandle => 'handle not set';

  @override
  String get mentorshipTopicMl => 'ML';

  @override
  String get mentorshipTopicPython => 'Python';

  @override
  String get mentorshipTopicCareer => 'Career';

  @override
  String get mentorshipTopicDesign => 'Design';

  @override
  String get mentorshipTopicFrontend => 'Frontend';

  @override
  String get mentorshipTopicCybersec => 'Cybersec';

  @override
  String get mentorshipLevelCourse3 => '3rd year';

  @override
  String get mentorshipLevelCourse4 => '4th year';

  @override
  String get mentorshipLevelMaster => 'Master\'s';

  @override
  String get mentorshipFormatOnline => 'Online call';

  @override
  String get mentorshipFormatCampus => 'In person on campus';

  @override
  String get mentorshipFormatChat => 'Chat only';

  @override
  String get mentorshipRewardTitle => '≈ 80 shurikens per session';

  @override
  String get mentorshipRewardSubtitle => '+ a «Mentor» badge on your profile';

  @override
  String get mentorshipTopicsLabel => 'WHAT YOU\'RE GOOD AT';

  @override
  String get mentorshipLevelLabel => 'YOUR LEVEL';

  @override
  String get mentorshipFormatLabel => 'FORMAT';

  @override
  String get mentorshipPriceTitle => 'Session price';

  @override
  String get mentorshipPriceSubtitle => 'in shurikens · can be free';

  @override
  String get mentorshipBioHint => 'About you: how you can help…';

  @override
  String get mentorshipSaving => 'Saving…';

  @override
  String get mentorshipSave => 'Save';

  @override
  String get mentorshipQuit => 'Stop being a mentor';

  @override
  String mentorshipSessionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sessions',
      one: '$count session',
    );
    return '$_temp0';
  }

  @override
  String get mentorshipTopicLabel => 'TOPIC';

  @override
  String get mentorshipWhenLabel => 'WHEN WORKS FOR YOU';

  @override
  String get mentorshipWhenTonight => 'Tonight';

  @override
  String get mentorshipWhenTonightHint => 'after 18:00';

  @override
  String get mentorshipWhenTomorrow => 'Tomorrow afternoon';

  @override
  String get mentorshipWhenWeek => 'This week';

  @override
  String get mentorshipWhenShortTonight => 'tonight';

  @override
  String get mentorshipWhenShortTomorrow => 'tomorrow afternoon';

  @override
  String get mentorshipWhenShortWeek => 'this week';

  @override
  String get mentorshipMessageLabel => 'MESSAGE';

  @override
  String get mentorshipMessageHint =>
      'Hi! I\'m stuck on backprop in my coursework…';

  @override
  String get mentorshipFreeSession => 'This session is free';

  @override
  String mentorshipPaidSession(int price) {
    return '$price shurikens will be reserved after the request is accepted';
  }

  @override
  String get mentorshipSendRequest => 'Send request';

  @override
  String get mentorshipReplyTelegram => 'Reply on Telegram';

  @override
  String get mentorshipLoadError => 'Could not load mentors';

  @override
  String get mentorshipLoadErrorSubtitle =>
      'Check your connection and try again.';

  @override
  String get mentorshipRefreshError => 'Could not refresh mentorship data';

  @override
  String get mentorshipRequestsError => 'Could not load mentorship requests';

  @override
  String get mentorshipRequestsErrorSubtitle =>
      'Mentor profiles are still available.';

  @override
  String get mentorshipInvalidHandle => 'This Telegram username is invalid';

  @override
  String get mentorshipOpenTelegramError => 'Could not open Telegram';

  @override
  String get mentorshipRequestActionError => 'Could not update the request';

  @override
  String get mentorshipProfileSaveError => 'Could not save the mentor profile';

  @override
  String get mentorshipProfileDeleteError =>
      'Could not disable the mentor profile';

  @override
  String get mentorshipQuitConfirmTitle => 'Stop being a mentor?';

  @override
  String get mentorshipQuitConfirmBody =>
      'Your profile will disappear from the mentor list.';

  @override
  String get mentorshipDecreasePrice => 'Decrease session price';

  @override
  String get mentorshipIncreasePrice => 'Increase session price';

  @override
  String get mentorshipRequestError => 'Could not send the request';

  @override
  String get mentorshipOutgoingRequests => 'YOUR REQUESTS';

  @override
  String get mentorshipAcceptRequest => 'Accept';

  @override
  String get mentorshipDeclineRequest => 'Decline';

  @override
  String get mentorshipCancelRequest => 'Cancel request';

  @override
  String get mentorshipCancelConfirmTitle => 'Cancel this request?';

  @override
  String get mentorshipCancelConfirmBody =>
      'The request will close and any reserved shurikens will be returned to the student. The session will not count as completed.';

  @override
  String get mentorshipCancelConfirmAction => 'Cancel request';

  @override
  String get mentorshipConfirmComplete => 'Confirm session complete';

  @override
  String get mentorshipWaitingConfirmation =>
      'Waiting for the other participant';

  @override
  String get mentorshipCompleted => 'Session completed';

  @override
  String get mentorshipDeclined => 'Request declined';

  @override
  String get mentorshipCancelled => 'Request cancelled';

  @override
  String get miniAppsPermNotifications => 'Notifications';

  @override
  String get miniAppsPermNotificationsDesc =>
      'Push messages from the developer (max 2 per day)';

  @override
  String get miniAppsPermLocation => 'Location';

  @override
  String get miniAppsPermLocationDesc =>
      'Your device coordinates, when the app asks';

  @override
  String get miniAppsPermCamera => 'Camera';

  @override
  String get miniAppsPermCameraDesc => 'Take photos and scan codes';

  @override
  String get miniAppsPermFiles => 'Files';

  @override
  String get miniAppsPermFilesDesc => 'Attach a file you choose';

  @override
  String get miniAppsPermCalendar => 'Calendar';

  @override
  String get miniAppsPermCalendarDesc => 'Add events to your device calendar';

  @override
  String get miniAppsScopeNotNow => 'Not now';

  @override
  String get miniAppsScanTitle => 'Scanner';

  @override
  String get miniAppsScanInstruction => 'Point the camera at a code';

  @override
  String get miniAppsScanCameraError => 'Could not open the camera';

  @override
  String get miniAppsSortTitle => 'Sort';

  @override
  String get miniAppsSortPopular => 'Popular';

  @override
  String get miniAppsSortNew => 'New';

  @override
  String get miniAppsSortTop => 'Top rated';

  @override
  String get miniAppsRecents => 'Recently opened';

  @override
  String get miniAppsFeature => 'Feature in catalog';

  @override
  String get miniAppsUnfeature => 'Remove from featured';

  @override
  String get miniAppsQr => 'QR code';

  @override
  String get miniAppsShare => 'Share';

  @override
  String get miniAppsQrHint => 'Scan with a camera to open this mini app';

  @override
  String get miniAppsStatsTitle => 'Statistics';

  @override
  String miniAppsStatsRangeDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'last $days days',
      one: 'last day',
    );
    return '$_temp0';
  }

  @override
  String miniAppsStatsDaysShort(int days) {
    return '${days}d';
  }

  @override
  String get miniAppsStatsLaunches => 'Launches';

  @override
  String get miniAppsStatsUsers => 'Users';

  @override
  String get miniAppsStatsRating => 'Rating';

  @override
  String get miniAppsStatsEmpty => 'No data yet';

  @override
  String get miniAppsStatsEmptySubtitle =>
      'Stats appear after the first launches';

  @override
  String get miniAppsRevTitle => 'Version history';

  @override
  String get miniAppsRevSubtitle => 'last 20 screen snapshots';

  @override
  String get miniAppsRevCurrent => 'current';

  @override
  String get miniAppsRevFirst => 'first version';

  @override
  String get miniAppsRevNoChanges => 'no screen changes';

  @override
  String get miniAppsRevEmpty => 'No revisions yet';

  @override
  String get miniAppsRevRestore => 'Restore';

  @override
  String get miniAppsTokensTitle => 'Deploy tokens';

  @override
  String get miniAppsTokensSubtitle => 'for the deploy and push HTTP API';

  @override
  String get miniAppsTokensBody =>
      'Tokens let you deploy hosted screens from CI and send pushes via the HTTP API. The value is shown only once — store it safely.';

  @override
  String get miniAppsTokensFresh => 'Copy now — it will not be shown again:';

  @override
  String get miniAppsTokensCopy => 'Copy token';

  @override
  String get miniAppsTokensCopied => 'Token copied';

  @override
  String get miniAppsTokensCreate => 'Create token';

  @override
  String get miniAppsTokensRevoke => 'Revoke';

  @override
  String get miniAppsTokensLimit => 'Token limit reached (5)';

  @override
  String get miniAppsTokensNeverUsed => 'never used';

  @override
  String get miniAppsTokensUsed => 'in use';

  @override
  String get miniAppsSecretTitle => 'Signing secret';

  @override
  String get miniAppsSecretSubtitle => 'verify proxy requests on your server';

  @override
  String get miniAppsSecretBody =>
      'The proxy signs every request to your server with this secret (HMAC-SHA256). Verify it to be sure a request really came from Mirea Ninja. Shown once on generation — store it as NINJA_SECRET.';

  @override
  String get miniAppsSecretFresh => 'Copy now — it will not be shown again:';

  @override
  String get miniAppsSecretCopy => 'Copy secret';

  @override
  String get miniAppsSecretCopied => 'Secret copied';

  @override
  String get miniAppsSecretGenerate => 'Generate secret';

  @override
  String get miniAppsSecretRotate => 'Rotate secret';

  @override
  String get miniAppsSecretDisable => 'Disable signing';

  @override
  String get miniAppsSecretNone => 'No secret yet';

  @override
  String miniAppsSecretActive(String fingerprint) {
    return 'Active · $fingerprint';
  }

  @override
  String get miniAppsSecretPrevActive => 'Previous secret still accepted';

  @override
  String get miniAppsSecretRotateHint =>
      'After rotating, the old secret keeps working for 24 h (sent as X-MireaNinja-Signature-Prev) — update your server within that window.';

  @override
  String get miniAppsSecretFailure => 'Could not update the secret';

  @override
  String get miniAppsTplTitle => 'Templates';

  @override
  String get miniAppsTplSubtitle => 'ready multi-screen starters';

  @override
  String get miniAppsTplList => 'List + details';

  @override
  String get miniAppsTplChecklist => 'Checklist (storage)';

  @override
  String get miniAppsTplPoll => 'Poll';

  @override
  String get miniAppsTplReplaceTitle => 'Replace screens?';

  @override
  String get miniAppsTplReplaceBody =>
      'The template will overwrite your current screen JSON.';

  @override
  String miniAppsSubmitUnknownTypes(String types) {
    return 'Warning, unknown types: $types. They will render as empty widgets.';
  }

  @override
  String get collabNotesTitle => 'Notes';

  @override
  String get collabNotesSubtitle => 'shared group notes · autosave';

  @override
  String get collabNotesEmptyTitle => 'Nothing here yet';

  @override
  String get collabNotesEmptySubtitle =>
      'Create the first note — the whole group can edit it';

  @override
  String get collabNotesCreateTitle => 'New note';

  @override
  String get collabNotesCreateSubtitle =>
      'the whole group will be able to edit it';

  @override
  String collabNotesUpdated(String time) {
    return 'updated $time';
  }

  @override
  String collabNotesUpdatedAutosave(String time) {
    return 'updated $time · autosave';
  }

  @override
  String get collabNotesTitleExampleHint => 'e.g. “ML lecture 7”';

  @override
  String get collabNotesCreating => 'Creating…';

  @override
  String get collabNotesCreate => 'Create';

  @override
  String get collabNotesTitleHint => 'Title';

  @override
  String get collabNotesBodyHint => 'Start writing the note…';

  @override
  String get collabNotesDeleteTitle => 'Delete note?';

  @override
  String get collabNotesDeleteBody => 'It will disappear for the whole group.';

  @override
  String get collabNotesCancel => 'Cancel';

  @override
  String get collabNotesDelete => 'Delete';

  @override
  String collabNotesEditorHeader(String title) {
    return 'Note · $title';
  }

  @override
  String get collabNotesPresenceSolo => 'only you';

  @override
  String collabNotesPresenceEditing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count editing now',
      one: '$count editing now',
    );
    return '$_temp0';
  }

  @override
  String get collabNotesToolbarEdit => 'Edit';

  @override
  String get collabNotesToolbarSave => 'Save';

  @override
  String get collabNotesNinja => 'Ninja';

  @override
  String get collabNotesLoadError => 'Could not load notes';

  @override
  String get collabNotesLoadErrorSubtitle =>
      'Check your connection and try again.';

  @override
  String get collabNotesRefreshError => 'Could not refresh notes';

  @override
  String get collabNotesCreateError => 'Could not create the note';

  @override
  String get collabNotesSaving => 'Saving…';

  @override
  String get collabNotesSaved => 'Saved';

  @override
  String get collabNotesUnsaved => 'Unsaved changes';

  @override
  String get collabNotesSaveError =>
      'Could not save the note. Your text is still here.';

  @override
  String get collabNotesConflict =>
      'This note changed elsewhere. Your text is still here.';

  @override
  String get collabNotesDeleteError => 'Could not delete the note';

  @override
  String get collabNotesDiscardTitle => 'Leave without saving?';

  @override
  String get collabNotesDiscardBody => 'Your unsaved text will be lost.';

  @override
  String get collabNotesStay => 'Keep editing';

  @override
  String get collabNotesDiscard => 'Leave without saving';

  @override
  String get eventsTitle => 'Events';

  @override
  String get eventsSubtitle => 'what\'s happening on campus';

  @override
  String get eventsCreateCta => 'Event';

  @override
  String get eventsFilterAll => 'All';

  @override
  String get eventsCategoryCareer => 'Career';

  @override
  String get eventsCategorySport => 'Sport';

  @override
  String get eventsCategoryArt => 'Arts';

  @override
  String get eventsCategorySci => 'Science';

  @override
  String get eventsCategoryOther => 'Other';

  @override
  String get eventsEmptyTitle => 'Nothing here yet';

  @override
  String get eventsEmptySubtitle =>
      'Create the first event — the board is shared across the whole university';

  @override
  String get eventsSectionUpcoming => 'Upcoming';

  @override
  String get eventsFeaturedTag => 'Featured event';

  @override
  String get eventsGoingYes => 'You\'re going';

  @override
  String get eventsGoingShort => 'Going';

  @override
  String get eventsRsvp => 'I\'ll go';

  @override
  String get eventsCreateSheetTitle => 'New event';

  @override
  String get eventsCreateSheetSubtitle => 'everyone in the app will see it';

  @override
  String get eventsCreatePreviewTitle => 'Event title';

  @override
  String get eventsCreatePreviewHint => 'this is how it appears on the board ↑';

  @override
  String get eventsCreateCoverLabel => 'COVER';

  @override
  String get eventsCreateNameLabel => 'TITLE';

  @override
  String get eventsCreateNameHint =>
      'Workshop: build your own app in one evening';

  @override
  String get eventsCreateCategoryLabel => 'CATEGORY';

  @override
  String get eventsCreateWhenLabel => 'WHEN';

  @override
  String get eventsCreateWhereLabel => 'WHERE';

  @override
  String get eventsCreatePlaceHint => 'Room I-301';

  @override
  String get eventsCreateDescriptionHint =>
      'What\'s on: agenda, speakers, who it\'s for…';

  @override
  String get eventsCreating => 'Creating…';

  @override
  String get eventsCreate => 'Create event';

  @override
  String get eventsLoadError => 'Couldn\'t load events';

  @override
  String get eventsLoadErrorSub => 'Check your connection and try again';

  @override
  String get eventsCreateError =>
      'Couldn\'t create the event. Please try again';

  @override
  String get eventsRsvpError => 'Couldn\'t update your RSVP. Please try again';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeAuto => 'Auto';

  @override
  String get settingsAccent => 'Institute accent';

  @override
  String get settingsAccentSubtitle =>
      'One color for buttons, navigation and active controls';

  @override
  String get settingsAccentBlue => 'Sky blue';

  @override
  String get settingsAccentViolet => 'Violet';

  @override
  String get settingsAccentYellow => 'Amber';

  @override
  String get settingsAccentRed => 'Red';

  @override
  String get settingsAccentGreen => 'Green';

  @override
  String get settingsLessonColors => 'Lesson type colors';

  @override
  String get settingsLessonColorsSubtitle =>
      'Choose a restrained color that identifies this lesson type in the schedule';

  @override
  String get settingsLessonColorGreen => 'Green';

  @override
  String get settingsLessonColorBlue => 'Blue';

  @override
  String get settingsLessonColorViolet => 'Violet';

  @override
  String get settingsLessonColorAmber => 'Amber';

  @override
  String get settingsLessonColorRed => 'Red';

  @override
  String get settingsLessonColorGray => 'Gray';

  @override
  String get settingsPrivacy => 'Privacy';

  @override
  String get settingsWhoSeesProfile => 'Profile visibility';

  @override
  String get settingsWhoSeesProfileValue => 'Group only';

  @override
  String get settingsAnonymousReactions => 'Anonymous reactions';

  @override
  String get settingsAnonymousReactionsValue => 'Enabled';

  @override
  String get settingsBiometricsPass => 'Biometrics for the pass';

  @override
  String get settingsNfcEmulation => 'NFC pass at the turnstile';

  @override
  String get settingsNfcEmulationSub =>
      'Tap your phone to the turnstile. Turn off if another app handles it';

  @override
  String get settingsMyGroup => 'My group';

  @override
  String get settingsSubgroup => 'Subgroup';

  @override
  String get settingsSubgroupValue => 'Subgroup 2';

  @override
  String get settingsWeekParity => 'Week parity';

  @override
  String get settingsWeekParityValue => 'auto by date';

  @override
  String get settingsHideElectives => 'Hide electives';

  @override
  String get settingsHomeAndWidgets => 'Home and widgets';

  @override
  String get settingsDataAndLanguage => 'Data and language';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageValue => 'Russian';

  @override
  String get settingsSync => 'Sync';

  @override
  String get settingsSyncValue => 'Wi-Fi + network';

  @override
  String get settingsClearCache => 'Clear cache';

  @override
  String get settingsClearCacheValue => '48 MB';

  @override
  String get settingsCacheCleared => 'Cache cleared';

  @override
  String get settingsExportSchedule => 'Export schedule';

  @override
  String get settingsExportScheduleValue => '.ics calendar';

  @override
  String get settingsExportScheduleHint => 'Open it on the Classes screen';

  @override
  String get settingsManageAccount => 'Manage account';

  @override
  String get settingsLessonReactions => 'Lesson reactions';

  @override
  String get settingsVisibilityEveryone => 'Everyone';

  @override
  String get settingsVisibilityGroup => 'Group only';

  @override
  String get settingsVisibilityNobody => 'Nobody';

  @override
  String get settingsVisibilitySheetSubtitle =>
      'Choose who can find you in search and suggestions.';

  @override
  String get biometricFaceId => 'Face ID';

  @override
  String get biometricFingerprint => 'Fingerprint';

  @override
  String get biometricUnavailable => 'Unavailable';

  @override
  String get biometricOff => 'Off';

  @override
  String get passLockTitle => 'Pass locked';

  @override
  String get passLockSubtitle => 'Confirm it\'s you to show the pass.';

  @override
  String get passLockReason => 'Confirm it\'s you to open the pass';

  @override
  String get passUnlock => 'Unlock';

  @override
  String get settingsHomeContentTitle => 'What\'s on home';

  @override
  String get settingsHomeContentSubtitle => 'Show or hide home sections.';

  @override
  String get homeSectionSmartChips => 'Quick actions';

  @override
  String get homeSectionDeadlines => 'Deadlines';

  @override
  String get homeSectionToday => 'Today\'s schedule';

  @override
  String get homeSectionTrending => 'Discussions';

  @override
  String get settingsWidgetSheetSubtitle =>
      'The schedule widget shows your active schedule and the current class. Add it from the home screen.';

  @override
  String get settingsWidgetRefresh => 'Refresh widget';

  @override
  String get settingsWidgetRefreshed => 'Widget updated';

  @override
  String get settingsLanguageSystem => 'System';

  @override
  String get settingsLanguageRu => 'Russian';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get settingsSupportEyebrow => 'OPEN-SOURCE';

  @override
  String get settingsSupportTitle => 'Support the project';

  @override
  String get settingsSupportSubtitle =>
      'Mirea Ninja is built by students. Star it on GitHub or send a PR.';

  @override
  String get settingsSupportCta => 'Open GitHub';

  @override
  String get accountEmailLabel => 'Email';

  @override
  String get accountGuest => 'Guest account';

  @override
  String get accountChangePassword => 'Change password';

  @override
  String get accountChangePasswordSub => 'We\'ll email a reset code';

  @override
  String get accountResetSent => 'Password reset email sent';

  @override
  String get accountResetError => 'Couldn\'t send the email. Try again.';

  @override
  String get accountDelete => 'Delete account';

  @override
  String get accountDeleteConfirmTitle => 'Delete account?';

  @override
  String get accountDeleteConfirmBody =>
      'This permanently deletes your account and data. This can\'t be undone.';

  @override
  String get accountDeleteAction => 'Delete';

  @override
  String get accountDeleteError => 'Couldn\'t delete the account. Try again.';

  @override
  String get settingsSyncAlways => 'Wi-Fi + mobile';

  @override
  String get settingsSyncWifiOnly => 'Wi-Fi only';

  @override
  String get settingsSyncManual => 'Manual only';

  @override
  String get settingsSyncSheetSubtitle =>
      'When the schedule may refresh over the network.';

  @override
  String get settingsFooter => 'Mirea Ninja · made with in Moscow';

  @override
  String get settingsNotifyClasses => 'Class reminders';

  @override
  String get settingsNotifyClassesSub => '15 min before';

  @override
  String get settingsNotifyScheduleChanges => 'Schedule changes';

  @override
  String get settingsNotifyScheduleChangesSub => 'instantly';

  @override
  String get settingsNotifyReactions => 'Reactions and replies';

  @override
  String get settingsNotifyReactionsSub => 'quiet hours 22:00 → 8:00';

  @override
  String get settingsNotifyUniversityNews => 'University news';

  @override
  String get settingsNotifyUniversityNewsSub => 'morning digest';

  @override
  String get settingsNotifyCommunityEvents => 'Community events';

  @override
  String get settingsHomeContent => 'What\'s on home';

  @override
  String get settingsQuickServices => 'Quick services';

  @override
  String settingsQuickServicesValue(int count) {
    return 'Pinned: $count';
  }

  @override
  String get settingsHomeContentAll => 'all sections';

  @override
  String get settingsHomeContentNone => 'nothing';

  @override
  String get settingsScreenWidgets => 'Screen widgets';

  @override
  String get settingsNotificationsOn => 'on';

  @override
  String get settingsNotificationsOff => 'off';

  @override
  String get settingsNinjaMascot => 'Ninja mascot';

  @override
  String get settingsCompactMode => 'Compact mode';

  @override
  String get settingsProBanner => 'NINJA PRO';

  @override
  String get settingsProTitle => 'Themes and no ads';

  @override
  String get settingsProPrice => '149₽/mo · first month free for students';

  @override
  String get settingsProTry => 'Try it';

  @override
  String settingsAboutVersion(String version) {
    return 'v $version · open-source';
  }

  @override
  String get settingsAboutDescription =>
      'Made by students for students. PRs welcome';

  @override
  String get settingsNotificationsPushTitle => 'Push notifications';

  @override
  String get settingsNotificationsPushSub => 'All notifications from the app';

  @override
  String get settingsNotificationsScheduleSection => 'Schedule';

  @override
  String get settingsNotificationsScheduleTitle => 'Schedule changes';

  @override
  String get settingsNotificationsScheduleSub =>
      'Cancellation, reschedule, room change';

  @override
  String get settingsNotificationsGamificationSection => 'Gamification';

  @override
  String get settingsNotificationsQuestsTitle => 'Quest reminders';

  @override
  String get settingsNotificationsQuestsSub => 'Daily quests by midnight';

  @override
  String get settingsNotificationsAchievementsTitle => 'New achievements';

  @override
  String get settingsNotificationsAchievementsSub => 'When a badge unlocks';

  @override
  String get settingsNotificationsLeaderboardTitle => 'Leaderboard updates';

  @override
  String get settingsNotificationsLeaderboardSub =>
      'Who overtook you on the leaderboard';

  @override
  String get settingsNfcTitle => 'NFC pass setup';

  @override
  String get settingsNfcDescription =>
      'Personalize the look of your pass by choosing an image or video for the background';

  @override
  String get settingsScheduleManageTooltip => 'Manage schedule';

  @override
  String get nfcPassTapHint => 'Hold your phone\nto the turnstile';

  @override
  String get nfcPassActiveStatus => 'Active';

  @override
  String get nfcPassIdLabel => 'ID';

  @override
  String get nfcPassDeviceLabel => 'Device';

  @override
  String get nfcPassNotConnectedTitle => 'Pass not connected';

  @override
  String get nfcPassNotConnectedDescription =>
      'Connect your NFC pass to walk through MIREA turnstiles with your phone.';

  @override
  String get nfcPassConnectButton => 'Connect pass';

  @override
  String get nfcPassUnbindButton => 'Unbind device';

  @override
  String get nfcPassUnbindConfirmTitle => 'Unbind the pass?';

  @override
  String get nfcPassUnbindConfirmDescription =>
      'The pass will stop working on this device. You can connect it again at any time.';

  @override
  String get nfcPassCodeSheetTitle => 'Code from the email';

  @override
  String get nfcPassCodeSheetDescription =>
      'The attendance service sent a code to the email linked to your student account. Enter it below.';

  @override
  String get nfcPassCheckEmailTitle => 'Check your email';

  @override
  String get nfcPassCheckEmailDescription =>
      'We\'ve sent a confirmation code to your student account email. Enter it to bind the pass.';

  @override
  String get nfcPassEnterCodeButton => 'Enter code';

  @override
  String get nfcPassErrorTitle => 'Something went wrong';

  @override
  String get nfcPassErrorDescription =>
      'We couldn\'t load your pass. Check your connection and try again.';

  @override
  String get nfcPassHowItWorksTitle => 'How it works';

  @override
  String get nfcPassStep1 => 'Connect the pass through the attendance journal';

  @override
  String get nfcPassStep2 => 'Confirm the binding with the code from the email';

  @override
  String get nfcPassStep3 =>
      'Hold the phone to the turnstile like a regular pass';

  @override
  String get nfcPassMediaTitle => 'Background media';

  @override
  String get nfcPassMediaDescription =>
      'Choose an image or video for the pass card background';

  @override
  String get nfcPassMediaSelect => 'Choose';

  @override
  String get nfcPassMediaChange => 'Change';

  @override
  String get nfcPassMediaRemove => 'Remove';

  @override
  String get nfcPassPreviewTitle => 'Preview';

  @override
  String get nfcPassPreviewImageHint => 'Card with an image';

  @override
  String get nfcPassPreviewVideoHint => 'Card with a video';

  @override
  String get nfcPassDefaultBackground => 'Default background';

  @override
  String get nfcPassInfoTitle => 'Pass details';

  @override
  String get nfcPassIdField => 'Pass ID';

  @override
  String get nfcPassStatusField => 'Status';

  @override
  String get pollsTitle => 'Polls';

  @override
  String pollsSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'vote on what matters · $count polls',
      one: 'vote on what matters · $count poll',
    );
    return '$_temp0';
  }

  @override
  String get pollsServiceTitle => 'Polls';

  @override
  String get pollsCreate => 'Create';

  @override
  String get pollsCreating => 'Creating…';

  @override
  String get pollsCreateTitle => 'New poll';

  @override
  String get pollsCancel => 'Cancel';

  @override
  String get pollsTypeSingle => 'Single';

  @override
  String get pollsTypeMultiple => 'Multiple';

  @override
  String get pollsTypeQuiz => 'Quiz';

  @override
  String get pollsQuestionHint => 'Ask a question…';

  @override
  String get pollsOptionsLabel => 'Options';

  @override
  String pollsOptionHint(int number) {
    return 'Option $number';
  }

  @override
  String get pollsAddOption => 'Add option';

  @override
  String get pollsRemoveOption => 'Remove option';

  @override
  String get pollsSettings => 'Settings';

  @override
  String get pollsAnonymous => 'Anonymous poll';

  @override
  String get pollsAnonymousSub => 'no one sees who voted how';

  @override
  String get pollsShowResults => 'Show results right away';

  @override
  String get pollsExpiry => 'Ends in';

  @override
  String get pollsExpiryNone => 'No limit';

  @override
  String get pollsExpiry24h => '24 hours';

  @override
  String get pollsExpiry3d => '3 days';

  @override
  String get pollsExpiry7d => '7 days';

  @override
  String get pollsVote => 'Vote';

  @override
  String pollsVotesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count votes',
      one: '$count vote',
      zero: 'No votes',
    );
    return '$_temp0';
  }

  @override
  String pollsSharePercent(int percent) {
    return '$percent%';
  }

  @override
  String get pollsTagEnded => 'ended';

  @override
  String get pollsTagAnonymous => 'anonymous';

  @override
  String get pollsTagQuiz => 'quiz';

  @override
  String get pollsEmptyTitle => 'No polls yet';

  @override
  String get pollsEmptySub => 'Be the first to ask the community a question.';

  @override
  String get pollsDeleteConfirmTitle => 'Delete poll?';

  @override
  String get pollsDeleteConfirmBody =>
      'This poll and all its votes will be removed.';

  @override
  String get pollsDelete => 'Delete';

  @override
  String get pollsDeleteCancel => 'Cancel';

  @override
  String get schedulesTitle => 'Schedules';

  @override
  String get scheduleHubPrimarySection => 'Primary';

  @override
  String get scheduleHubGroupsSection => 'Groups';

  @override
  String get scheduleHubTeachersSection => 'Teachers';

  @override
  String get scheduleHubClassroomsSection => 'Classrooms';

  @override
  String get scheduleHubMineBadge => 'MINE';

  @override
  String get scheduleHubLiveLesson => 'class now';

  @override
  String scheduleHubNowSubject(String subject) {
    return 'Now: $subject';
  }

  @override
  String scheduleHubLessonUntil(String time) {
    return 'until $time';
  }

  @override
  String scheduleHubRemaining(int minutes) {
    return '$minutes min left';
  }

  @override
  String scheduleHubNextSubject(String subject) {
    return 'Next: $subject';
  }

  @override
  String scheduleHubNextAt(String time) {
    return 'at $time';
  }

  @override
  String get scheduleHubNoLessonsToday => 'No classes today';

  @override
  String scheduleHubLessonsToday(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count classes today',
      one: '$count class today',
      zero: 'day off today',
    );
    return '$_temp0';
  }

  @override
  String scheduleHubUpdatedAgo(String time) {
    return 'updated $time';
  }

  @override
  String get scheduleHubAgoNow => 'now';

  @override
  String scheduleHubAgoMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String scheduleHubAgoHours(int hours) {
    return '$hours h';
  }

  @override
  String scheduleHubAgoDays(int days) {
    return '$days d';
  }

  @override
  String get scheduleHubEmptyTitle => 'No schedules yet';

  @override
  String get scheduleHubEmptySubtitle =>
      'Add a group, teacher or classroom to see its schedule';

  @override
  String get scheduleHubAllSchedules => 'All schedules';

  @override
  String get scheduleHubAllSchedulesSubtitle => 'Switch, add or reorder';

  @override
  String get scheduleRemovedToast => 'Schedule removed';

  @override
  String get addScheduleTitle => 'Add schedule';

  @override
  String get addScheduleTabGroup => 'Group';

  @override
  String get addScheduleTabTeacher => 'Teacher';

  @override
  String get addScheduleTabClassroom => 'Classroom';

  @override
  String get addScheduleSearchGroupHint => 'Group number, e.g. ИКБО-09-22';

  @override
  String get addScheduleSearchTeacherHint => 'Teacher last name';

  @override
  String get addScheduleSearchClassroomHint => 'Classroom, e.g. А-220';

  @override
  String addScheduleFound(int count) {
    return 'Found · $count';
  }

  @override
  String get addScheduleAdded => 'added';

  @override
  String get addScheduleAddAction => 'add';

  @override
  String get addScheduleCreateTitle => 'Create your own from scratch';

  @override
  String get addScheduleCreateSubtitle =>
      'no group, teacher or classroom needed';

  @override
  String get addScheduleNotFound => 'Didn\'t find it?';

  @override
  String get addScheduleStartTyping => 'Start typing to search';

  @override
  String get addScheduleNoResults => 'Nothing found';

  @override
  String get editSchedulesTitle => 'Edit';

  @override
  String get editSchedulesHint => 'Drag to reorder · tap minus to unsubscribe';

  @override
  String get studyGroupTitle => 'My group';

  @override
  String studyGroupMembersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count members',
      one: '1 member',
      zero: 'no members',
    );
    return '$_temp0';
  }

  @override
  String get studyGroupNoGroupTitle => 'You\'re not in a group yet';

  @override
  String get studyGroupNoGroupSubtitle =>
      'Create a study group or join an existing one to unlock the group space.';

  @override
  String get studyGroupCreateCta => 'Create a group';

  @override
  String get studyGroupJoinByCodeCta => 'Join by code';

  @override
  String get studyGroupDiscoverCta => 'Find a group';

  @override
  String get studyGroupManage => 'Manage group';

  @override
  String get studyGroupInvitesSection => 'Invitations';

  @override
  String get studyGroupInviteJoin => 'Join';

  @override
  String get studyGroupInviteDismiss => 'Dismiss';

  @override
  String get studyGroupMembersSection => 'Members';

  @override
  String get studyGroupOwnerTag => 'Owner';

  @override
  String get studyGroupYouTag => 'You';

  @override
  String studyGroupOwnerName(String name) {
    return 'owner $name';
  }

  @override
  String get studyGroupAccept => 'Accept';

  @override
  String get studyGroupDecline => 'Decline';

  @override
  String get studyGroupRemove => 'Remove';

  @override
  String get studyGroupRemoveMemberTitle => 'Remove member?';

  @override
  String studyGroupRemoveMemberBody(String name) {
    return '$name will lose access to the group space.';
  }

  @override
  String studyGroupRequestsSection(int count) {
    return 'Join requests ($count)';
  }

  @override
  String get studyGroupInviteAction => 'Invite to the group';

  @override
  String get studyGroupInviteTitle => 'Invite to the group';

  @override
  String get studyGroupInviteSubtitle => 'Find a student by name or @handle';

  @override
  String get studyGroupInviteSearchHint => 'Name or @handle';

  @override
  String get studyGroupInviteSend => 'Invite';

  @override
  String get studyGroupInviteSent => 'Invited';

  @override
  String get studyGroupInviteError =>
      'Couldn\'t invite. They may already be in a group.';

  @override
  String get studyGroupInviteNoneFound => 'No one found';

  @override
  String get studyGroupInviteNoneFoundSub => 'Try another name or @handle';

  @override
  String get studyGroupInviteByLink => 'Or share the code or invite link';

  @override
  String get studyGroupShareCode => 'Group code';

  @override
  String studyGroupShareCodeText(String name, String code, String link) {
    return 'Join the group «$name» in Mirea Ninja. Code: $code\n$link';
  }

  @override
  String get studyGroupCodeCopied => 'Code copied';

  @override
  String get studyGroupCreateTitle => 'New study group';

  @override
  String get studyGroupCreateSubtitle =>
      'You\'ll be the owner. One person — one group.';

  @override
  String get studyGroupCreateButton => 'Create';

  @override
  String get studyGroupCreating => 'Creating…';

  @override
  String get studyGroupCreateError => 'Couldn\'t create the group';

  @override
  String get studyGroupNameHint => 'Name, e.g. IKBO-09-22';

  @override
  String get studyGroupDescriptionHint => 'Description (optional)';

  @override
  String get studyGroupDiscoverableLabel =>
      'Show in the catalog (others can request to join)';

  @override
  String get studyGroupJoinTitle => 'Join by code';

  @override
  String get studyGroupJoinSubtitle =>
      'Enter the invite code the group owner shared';

  @override
  String get studyGroupCodeHint => 'Code, e.g. MNMN6T';

  @override
  String get studyGroupJoinButton => 'Join';

  @override
  String get studyGroupJoining => 'Joining…';

  @override
  String get studyGroupJoinError => 'Couldn\'t join. Check the code.';

  @override
  String studyGroupJoinedToast(String name) {
    return 'You joined «$name»';
  }

  @override
  String get studyGroupLeave => 'Leave group';

  @override
  String get studyGroupLeaveTitle => 'Leave the group?';

  @override
  String get studyGroupLeaveBody => 'You\'ll lose access to the group space.';

  @override
  String get studyGroupDelete => 'Delete group';

  @override
  String get studyGroupDeleteTitle => 'Delete the group?';

  @override
  String get studyGroupDeleteBody =>
      'The group, its links, announcements and shared notes will be permanently deleted.';

  @override
  String get studyGroupCancel => 'Cancel';

  @override
  String get studyGroupGenericError => 'Something went wrong';

  @override
  String get studyGroupDiscoverTitle => 'Group catalog';

  @override
  String get studyGroupDiscoverSubtitle =>
      'Find a group and send the owner a request';

  @override
  String get studyGroupDiscoverSearchHint => 'Name or code';

  @override
  String get studyGroupDiscoverEmptyTitle => 'Nothing found';

  @override
  String get studyGroupDiscoverEmptySubtitle => 'Try another name or code';

  @override
  String get studyGroupRequestJoin => 'Request';

  @override
  String get studyGroupRequested => 'Request sent';

  @override
  String get studyGroupRequestError => 'Couldn\'t send the request';

  @override
  String get collabNotesVisibilityLabel => 'Who can see it';

  @override
  String get collabNotesVisibilityGroup => 'Whole group';

  @override
  String get collabNotesVisibilityPersonal => 'Only me';

  @override
  String get collabNotesPersonalBadge => 'Personal';

  @override
  String get collabNotesNeedGroup => 'Join a group to share notes with it';

  @override
  String get teamFinderExpired => 'Expired';

  @override
  String get teamFinderDeleteTeam => 'Delete team';

  @override
  String get teamFinderLeaveTeam => 'Leave team';

  @override
  String get teamFinderWithdrawApplication => 'Withdraw application';

  @override
  String get teamFinderLoadError => 'Couldn\'t load teams';

  @override
  String get teamFinderLoadErrorSubtitle =>
      'Check your connection and try again.';

  @override
  String get teamFinderCreateError => 'Couldn\'t create the team';

  @override
  String get teamFinderDecreaseCapacity => 'Decrease team size';

  @override
  String get teamFinderIncreaseCapacity => 'Increase team size';

  @override
  String get teamFinderApplyError => 'Couldn\'t send the application';

  @override
  String get teamFinderApplyAttachProfileHint =>
      'The owner will see your Telegram handle and group. Your name is always included in the application.';

  @override
  String get teamFinderContactHidden => 'Contact hidden';

  @override
  String get teamFinderAccepting => 'Accepting…';

  @override
  String get teamFinderAcceptApplication => 'Accept';

  @override
  String get teamFinderRejectApplication => 'Reject';

  @override
  String get teamFinderTelegramUnavailable =>
      'Telegram contact isn\'t available';

  @override
  String get teamFinderApplicationsLoadError => 'Couldn\'t load applications';

  @override
  String get teamFinderApplicationsLoadErrorSubtitle =>
      'Check your connection and try again.';

  @override
  String get teamFinderApplicationActionError =>
      'Couldn\'t update the application';

  @override
  String get teamFinderTelegramOpenError => 'Couldn\'t open Telegram';

  @override
  String get teamFinderWithdrawConfirmTitle => 'Withdraw the application?';

  @override
  String get teamFinderWithdrawConfirmBody =>
      'The team owner will no longer see it. You can apply again later.';

  @override
  String get teamFinderLeaveConfirmTitle => 'Leave the team?';

  @override
  String get teamFinderLeaveConfirmBody =>
      'Your spot will become available to another applicant.';

  @override
  String get teamFinderDeleteConfirmTitle => 'Delete the team?';

  @override
  String get teamFinderDeleteConfirmBody =>
      'The team and all pending applications will be permanently deleted.';

  @override
  String get teamFinderLeaveError => 'Couldn\'t leave the team';

  @override
  String get teamFinderDeleteError => 'Couldn\'t delete the team';

  @override
  String get teamFinderRefreshError => 'Couldn\'t refresh teams';

  @override
  String get identityNameLabel => 'Full name';

  @override
  String get identityNameHint => 'Ivan Ivanov';

  @override
  String get identityHandleLabel => 'Nickname';

  @override
  String get identityHandleHint => 'ivan_99';

  @override
  String get identityHandleHelp =>
      '3–20 chars: latin letters, digits, underscore';

  @override
  String get identityHandleAvailable => 'Nickname is available';

  @override
  String get identityHandleTaken => 'This nickname is already taken';

  @override
  String get identityHandleInvalid => 'Only latin letters, digits and _ (3–20)';

  @override
  String get identitySaving => 'Saving…';

  @override
  String get identitySaveError => 'Couldn\'t save. Try again later.';

  @override
  String get onboardingIdentityTitle => 'Tell us about you';

  @override
  String get onboardingIdentitySubtitle =>
      'Your name and nickname are visible to groupmates and friends';

  @override
  String get profileIdentityRow => 'Name & nickname';

  @override
  String get profileEditIdentityTitle => 'Name & nickname';

  @override
  String get profileEditIdentitySubtitle => 'Visible to groupmates and friends';

  @override
  String get profileEditSave => 'Save';

  @override
  String get profileIdentitySaved => 'Saved';

  @override
  String get articleImage => 'Article image';

  @override
  String get loadingContent => 'Loading content';

  @override
  String get mapBuildingLabel => 'Building';

  @override
  String get mapChangeBuildingHint => 'Pull the panel up to change building';

  @override
  String mapFloorNumber(int number) {
    return 'Floor $number';
  }

  @override
  String mapFloorsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count floors',
      one: '$count floor',
    );
    return '$_temp0';
  }

  @override
  String get mapFloorSelection => 'Floor selection';

  @override
  String get mapFitFloorPlan => 'Fit floor plan';

  @override
  String get mapWholeFloor => 'Whole floor';

  @override
  String get mapZoomIn => 'Zoom in';

  @override
  String get mapZoomOut => 'Zoom out';

  @override
  String get mapOpeningFloor => 'Opening floor';

  @override
  String get mapFindRoom => 'Find a room';

  @override
  String get mapFindRoomHint =>
      'Search this floor and jump straight to the room';

  @override
  String get mapRoomSearchHint => 'Room number or name';

  @override
  String get mapNoRoomsTitle => 'No rooms found on this floor';

  @override
  String get mapNoRoomsMessage => 'Try another room number or name';

  @override
  String get mapInteractiveLabel => 'Interactive floor map';

  @override
  String get mapInteractiveHint => 'Pan the map, pinch or double tap to zoom';

  @override
  String get onboardingWelcomeTitle => 'University\nin one tap';

  @override
  String get onboardingWelcomeTitleAccent => 'tap';

  @override
  String get onboardingWelcomeLead =>
      'Classes, deadlines, free rooms and your pass — no extra tabs.';

  @override
  String get onboardingFeatureScheduleTitle => 'Schedule with changes';

  @override
  String get onboardingFeatureScheduleSub =>
      'Reschedules and swaps — right in your feed';

  @override
  String get onboardingFeatureRoomsTitle => 'Free rooms nearby';

  @override
  String get onboardingFeatureRoomsSub => 'Where to study during a break';

  @override
  String get onboardingFeatureFriendsTitle => 'Friends on campus';

  @override
  String get onboardingFeatureFriendsSub =>
      'Shared gaps and who is where right now';

  @override
  String get onboardingStart => 'Get started';

  @override
  String get onboardingHaveAccount => 'I already have an account';

  @override
  String get onboardingGroupLead =>
      'Your schedule will load automatically. You can change it in Settings.';

  @override
  String get onboardingGroupPlaceholder => 'ИКБО-01-24';

  @override
  String get onboardingGroupNotFound =>
      'Group not found. Check the spelling or ';

  @override
  String get onboardingGroupNotFoundAction => 'create your own schedule';

  @override
  String get onboardingGroupNotFoundSuffix => '.';

  @override
  String get onboardingContinue => 'Continue';

  @override
  String get onboardingSettingsTitle => 'A couple of settings';

  @override
  String get onboardingSettingsLead => 'You can change everything later.';

  @override
  String get onboardingPushSub => 'Classes, deadlines, changes';

  @override
  String get onboardingGeoTitle => 'Location on campus';

  @override
  String get onboardingGeoSub => 'For the map and free rooms';

  @override
  String get onboardingFriendsTitle => 'Show me to friends';

  @override
  String get onboardingFriendsSub => 'Only while you are on campus';

  @override
  String get onboardingPushDenied =>
      'Allow notifications in the system settings';

  @override
  String get onboardingGeoDenied =>
      'Allow location access in the system settings';

  @override
  String get onboardingSettingsSaveError =>
      'Couldn\'t save the setting. Try again.';

  @override
  String onboardingWelcomeToast(String group) {
    return 'Welcome, $group';
  }

  @override
  String onboardingStepSemantics(int step, int total) {
    return 'Step $step of $total';
  }

  @override
  String newsTimeMinutes(int count) {
    return '$count min';
  }

  @override
  String newsTimeHours(int count) {
    return '$count h';
  }

  @override
  String get newsTimeYesterday => 'yesterday';

  @override
  String newsTimeDays(int count) {
    return '$count d';
  }

  @override
  String get newsTimeNow => 'now';

  @override
  String get newsSourcesSemantics => 'News sources';

  @override
  String articleTimeAgo(String time) {
    return '$time ago';
  }

  @override
  String get articleUnsaved => 'Removed from saved';

  @override
  String get articleRemoveFromSaved => 'Remove from saved';

  @override
  String get articleSourceOfficial => 'Official channel';

  @override
  String get articleSourceTelegram => 'Telegram channel';

  @override
  String get articleSourceRss => 'RSS feed';

  @override
  String articleSourceSubscribers(String count) {
    return '$count subscribers';
  }

  @override
  String get articleSourceSubscribed => 'Following';

  @override
  String get articleSourceSubscribe => 'Follow';

  @override
  String articleSourceFollowedToast(String name) {
    return 'You follow $name';
  }

  @override
  String get articleSourceUnfollowedToast => 'Unfollowed';

  @override
  String get storyRead => 'Read';

  @override
  String get storyClose => 'Close';

  @override
  String get storyPrevious => 'Previous story';

  @override
  String get storyNext => 'Next story';

  @override
  String get storyEmpty => 'No stories from this source yet';

  @override
  String get communitiesMine => 'Mine';

  @override
  String get communitiesRecommended => 'Recommended';

  @override
  String get communitiesMember => 'You are a member';

  @override
  String communitiesJoinedToast(String name) {
    return 'Welcome to $name';
  }

  @override
  String get communitiesLeftToast => 'You left the community';

  @override
  String get communitiesMineEmpty => 'Join a community and it will appear here';

  @override
  String get communitiesEmptyCategory => 'No communities in this category yet';

  @override
  String get communitiesSuggest => 'Suggest a community';

  @override
  String get communityFeed => 'Feed';

  @override
  String get communityWrite => 'write';

  @override
  String get communityFeedEmpty => 'Community posts';

  @override
  String get communityFeedEmptySub =>
      'Organizers post in the chat — open it to write';

  @override
  String get communityStatMembers => 'members';

  @override
  String get communityStatPlatform => 'platform';

  @override
  String get communityStatCategory => 'category';

  @override
  String get communityOpenChat => 'Open chat';

  @override
  String get communityPlatformWeb => 'Website';

  @override
  String scheduleWeekOverline(int week, String parity) {
    return 'Week $week · $parity';
  }

  @override
  String scheduleChangesThisWeek(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count changes this week',
      one: '$count change this week',
    );
    return '$_temp0';
  }

  @override
  String get scheduleShow => 'Show';

  @override
  String scheduleCompareWith(String name) {
    return 'Comparing with $name';
  }

  @override
  String get scheduleCommonWindows => 'common windows:';

  @override
  String get scheduleNoCommonWindows => 'no common windows today';

  @override
  String get scheduleCompareOff => 'Off';

  @override
  String get scheduleViewDay => 'Day';

  @override
  String get schedulePrevWeek => '← week';

  @override
  String get scheduleNextWeek => 'week →';

  @override
  String scheduleDayLessons(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count classes',
      one: '$count class',
      zero: 'no classes',
    );
    return '$_temp0';
  }

  @override
  String scheduleBreakMinutes(int minutes) {
    return 'break $minutes min';
  }

  @override
  String get scheduleFreeDayTitle => 'Free day';

  @override
  String get scheduleFreeDaySubtitle =>
      'No classes. You can add your own event.';

  @override
  String get scheduleCompareFriend => 'Compare with a friend';

  @override
  String get scheduleLegendLab => 'Lab';

  @override
  String get scheduleLegendCancel => 'Cancelled';

  @override
  String get scheduleLegendAddOwn => 'tap — add your own';

  @override
  String scheduleMonthMeta(int year, int semester) {
    return '$year · semester $semester';
  }

  @override
  String get scheduleMonthStatsTitle => 'THIS MONTH';

  @override
  String get scheduleStudyDays => 'Study days';

  @override
  String get scheduleLessonsLabel => 'Classes';

  @override
  String get scheduleExamsLabel => 'Tests';

  @override
  String scheduleLecturesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lectures',
      one: '$count lecture',
    );
    return '$_temp0';
  }

  @override
  String schedulePracticesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count practices',
      one: '$count practice',
    );
    return '$_temp0';
  }

  @override
  String scheduleLabsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count labs',
      one: '$count lab',
    );
    return '$_temp0';
  }

  @override
  String get lessonShortLecture => 'LEC';

  @override
  String get lessonShortPractice => 'PRAC';

  @override
  String get lessonShortLab => 'LAB';

  @override
  String get lessonShortPe => 'PE';

  @override
  String get lessonShortConsult => 'CONS';

  @override
  String get lessonShortExam => 'EXAM';

  @override
  String get lessonShortCredit => 'CRED';

  @override
  String get lessonShortCourse => 'CRS';

  @override
  String get lessonShortIndividual => 'IND';

  @override
  String get lessonShortOwn => 'OWN';

  @override
  String get lessonTagCancelled => '· cancelled';

  @override
  String lessonTagLive(int minutes) {
    return '· in progress, $minutes min left';
  }

  @override
  String get lessonTagNext => '· next';

  @override
  String get lessonTagMoved => '· room changed';

  @override
  String get lessonTagNew => '· new';

  @override
  String get lessonMetaCancelled => 'Cancelled';

  @override
  String lessonMetaMoved(String type, String room, String oldRoom) {
    return '$type · $room instead of $oldRoom';
  }

  @override
  String get lessonMetaPast => 'finished';

  @override
  String get scheduleActionOpen => 'Open class';

  @override
  String get scheduleActionReport => 'Report a mistake';

  @override
  String get scheduleLessonHidden => 'Class hidden';

  @override
  String scheduleChangesSubtitle(String time) {
    return 'This week · updated $time';
  }

  @override
  String get scheduleChangesSubtitleWeek => 'This week';

  @override
  String get scheduleChangeTagMoved => 'Moved';

  @override
  String get scheduleChangeTagCancelled => 'Cancelled';

  @override
  String get scheduleChangeTagNew => 'New';

  @override
  String get scheduleChangeTagTeacher => 'Teacher';

  @override
  String get scheduleChangeTagRoom => 'Room';

  @override
  String get scheduleChangeAdded => 'added';

  @override
  String get scheduleChangesAck => 'Got it';

  @override
  String get scheduleAddTitle => 'Own class';

  @override
  String get scheduleAddSubtitle =>
      'Club, consultation, meeting — it will appear in the schedule';

  @override
  String get scheduleAddName => 'Title';

  @override
  String get scheduleAddPlace => 'Place (optional)';

  @override
  String get scheduleAddType => 'Type';

  @override
  String get scheduleAddDay => 'Day';

  @override
  String get scheduleAddSlot => 'Class';

  @override
  String get scheduleAddDone => 'Class added to the schedule';

  @override
  String get activityTypeOwn => 'Own';

  @override
  String get activityTypeEvent => 'Event';

  @override
  String get activityTypeRetake => 'Retake';

  @override
  String get activityTypeExtra => 'Extra class';

  @override
  String get scheduleCompareTitle => 'Compare schedules';

  @override
  String get scheduleCompareSubtitle =>
      'We will show your friend\'s busy slots and common windows';

  @override
  String scheduleCompareStarted(String name) {
    return 'Comparing with $name';
  }

  @override
  String get scheduleCompareNoFriends => 'No friends with a group yet';

  @override
  String get scheduleCompareNoFriendsHint =>
      'Add friends — their groups will appear here';

  @override
  String get scheduleCompareNoGroup => 'group not set';

  @override
  String get scheduleNoteSubtitle =>
      'Only you can see it · can be shared with the group';

  @override
  String get scheduleNotePlaceholder => 'What to remember…';

  @override
  String get scheduleNoteAddFile => '+ file';

  @override
  String get scheduleNoteAddBoard => '+ board photo';

  @override
  String get scheduleNoteTag => '#tag';

  @override
  String get scheduleNoteSaved => 'Note saved';

  @override
  String scheduleRemindIn(int minutes) {
    return '$minutes min before';
  }

  @override
  String get scheduleRemindHour => '1 hour before';

  @override
  String scheduleRemindSet(int minutes) {
    return 'Will remind $minutes min before';
  }

  @override
  String get scheduleShareLink => 'Link';

  @override
  String get scheduleShareCalendar => 'To calendar';

  @override
  String get scheduleShareImage => 'As image';

  @override
  String get scheduleLinkCopied => 'Link copied';

  @override
  String get scheduleFilterTitle => 'Show';

  @override
  String get scheduleFilterPastSub => 'Shown in grey';

  @override
  String get scheduleFilterCancelled => 'Cancelled';

  @override
  String get scheduleFilterCancelledSub => 'Struck through';

  @override
  String get lessonCancelledBanner => 'Class cancelled';

  @override
  String lessonMovedBanner(String from, String to) {
    return 'Room changed: $from → $to';
  }

  @override
  String get lessonTimeLabel => 'Time';

  @override
  String lessonNumberMeta(int number) {
    return 'class $number';
  }

  @override
  String get lessonOnMap => 'on the map';

  @override
  String get lessonFiles => 'Files';

  @override
  String get lessonMaterialsAdd => 'add';

  @override
  String get lessonHowWasIt => 'How was it?';

  @override
  String get lessonGroupNote => 'Group note';

  @override
  String get lessonGroupNoteEmpty => 'Nothing yet — share what was important';

  @override
  String get scheduleTeacherRating => 'rating';

  @override
  String get scheduleTeacherReviews => 'reviews';

  @override
  String get scheduleTeacherSubjects => 'subjects';

  @override
  String get scheduleTeacherWrite => 'Write';

  @override
  String get scheduleTeacherReview => 'Leave a review';

  @override
  String get scheduleTeacherNoContacts => 'No contacts for this teacher yet';

  @override
  String get scheduleWeekExport => 'Export week';

  @override
  String get scheduleFilterSemantics => 'Filters';

  @override
  String get scheduleAddLessonSemantics => 'Add own class';

  @override
  String get scheduleMoreSemantics => 'Class actions';

  @override
  String get riskBadge => 'RISK';

  @override
  String get gradesTitle => 'Grades';

  @override
  String get gradesRefresh => 'Refresh';

  @override
  String get gradesErrorTitle => 'Could not load';

  @override
  String gradesErrorSaved(String date) {
    return 'Last grades were saved on $date.';
  }

  @override
  String get gradesErrorNoData => 'No saved grades yet.';

  @override
  String get gradesGpaLabel => 'Personal GPA';

  @override
  String gradesGpaDelta(String delta) {
    return '$delta this month';
  }

  @override
  String get gradesScholarshipLabel => 'To the raised scholarship';

  @override
  String gradesScholarshipHint(String subject) {
    return 'get $subject to 4+';
  }

  @override
  String get gradesScholarshipReached => 'threshold reached';

  @override
  String get gradesTermCurrent => 'Current';

  @override
  String gradesTermSemester(int n) {
    return 'Sem $n';
  }

  @override
  String get gradesNoSubjectsTitle => 'No subjects yet';

  @override
  String get gradesNoSubjectsSubtitle =>
      'Pick your group schedule and subjects will appear here';

  @override
  String get gradesTermEmpty => 'No grades for this term';

  @override
  String get gradesTeacherUnknown => 'Teacher not set';

  @override
  String get gradesAddMarkSubtitle => 'Add a grade';

  @override
  String gradesMarkAdded(int mark) {
    return 'Grade $mark added';
  }

  @override
  String get gradesRemoveLast => 'Remove last';

  @override
  String gradesMarkSemantics(int mark) {
    return 'Grade $mark';
  }

  @override
  String get attendanceTitle => 'Attendance';

  @override
  String get attendanceAddAbsence => 'Log an absence';

  @override
  String get attendanceStatSemester => 'personal log';

  @override
  String get attendanceStatMissed => 'absences';

  @override
  String attendanceStatRisk(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'subjects at risk',
      one: 'subject at risk',
    );
    return '$_temp0';
  }

  @override
  String get attendanceWeeksTitle => 'By week';

  @override
  String attendanceWeeksRange(String month) {
    return '$month → now';
  }

  @override
  String attendanceRiskBanner(String subject, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count unexcused absences',
      one: '$count unexcused absence',
    );
    return '$subject: $_temp0. Estimated attendance is below 70%; check the course requirements with your teacher.';
  }

  @override
  String get attendanceBySubjects => 'By subject';

  @override
  String attendanceMissRow(String reason) {
    return 'Absence · $reason';
  }

  @override
  String get attendanceReasonSick => 'sick (personal record)';

  @override
  String get attendanceReasonNone => 'no reason';

  @override
  String get attendanceCertificate => 'Sick';

  @override
  String get attendanceRemoveAbsence => 'Remove';

  @override
  String get attendanceRiskNote =>
      'This is a personal estimate from the available schedule. Ask your teacher about assessment and make-up requirements.';

  @override
  String get attendanceNoLessonsTitle => 'No classes yet';

  @override
  String get attendanceNoLessonsSubtitle =>
      'Pick your group schedule — stats appear after the first classes';

  @override
  String get attendanceSheetSubject => 'Subject';

  @override
  String get attendanceSheetDate => 'Date';

  @override
  String get attendanceSheetReason => 'Reason';

  @override
  String get attendanceSheetSubmit => 'Log';

  @override
  String get attendanceAbsenceAdded => 'Absence logged';

  @override
  String attendanceExpandSemantics(String subject) {
    return 'Show absences for $subject';
  }

  @override
  String get coworkTitle => 'Coworking';

  @override
  String get coworkVenue => 'Personal plan on this device';

  @override
  String coworkFree(int count) {
    return '$count free';
  }

  @override
  String get coworkZoneQuiet => 'Quiet';

  @override
  String get coworkZoneCommon => 'Common';

  @override
  String get coworkZoneMeeting => 'Meeting rooms';

  @override
  String get coworkWindows => 'SCHEMATIC LAYOUT';

  @override
  String get coworkLegendFree => 'not verified';

  @override
  String get coworkLegendTaken => 'taken';

  @override
  String get coworkLegendMine => 'selected';

  @override
  String get coworkTimeLabel => 'Time';

  @override
  String coworkTimeValue(String from, String until, int hours) {
    return '$from → $until · $hours h';
  }

  @override
  String get coworkExtendLabel => 'Extension';

  @override
  String get coworkExtendAvailable => 'for your personal plan';

  @override
  String coworkExtendAction(String until) {
    return 'extend until $until';
  }

  @override
  String get coworkExtendMax => 'until closing';

  @override
  String get coworkFriendsLabel => 'Friends nearby';

  @override
  String get coworkFriendsNone => 'no recent locations';

  @override
  String get coworkPickSeat => 'Pick a seat';

  @override
  String coworkBook(String seat, String until) {
    return 'Save $seat · until $until';
  }

  @override
  String get coworkCancelBooking => 'Remove saved seat';

  @override
  String coworkBooked(String seat, String until) {
    return 'Seat $seat saved until $until';
  }

  @override
  String get coworkBookingCancelled => 'Saved seat removed';

  @override
  String coworkSeatSemantics(String seat) {
    return 'Seat $seat';
  }

  @override
  String get mapSearchPlaceholder => 'Room, department, canteen';

  @override
  String get mapFriendsToggle => 'Friends on the map';

  @override
  String get mapCampusFilter => 'Campus';

  @override
  String get mapExpandSheet => 'Expand list';

  @override
  String get mapCollapseSheet => 'Collapse list';

  @override
  String get freeRoomsNowTitle => 'Free now';

  @override
  String freeRoomsMeta(String campus, String time, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rooms',
      one: '$count room',
    );
    return '$campus · until the next class at $time · $_temp0';
  }

  @override
  String freeRoomsMetaEndOfDay(String campus, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rooms',
      one: '$count room',
    );
    return '$campus · no more classes today · $_temp0';
  }

  @override
  String get freeRoomsYourSeat => 'saved';

  @override
  String get freeRoomsKind => 'Room';

  @override
  String freeRoomsLeftHours(int hours) {
    return '$hours h';
  }

  @override
  String freeRoomsLeftHoursMinutes(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String freeRoomsLeftMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String freeRoomsNothingFound(String campus) {
    return 'Nothing found in $campus. Try another campus.';
  }

  @override
  String get freeRoomsNothingFoundAll => 'Nothing found. Try another query.';

  @override
  String get roomPhotoPlaceholder => 'room photo';

  @override
  String roomFreeUntilBadge(String time) {
    return 'free until $time';
  }

  @override
  String get roomFreeEndOfDayBadge => 'free until the end of the day';

  @override
  String roomMetaFloor(String kind, String campus, int floor) {
    return '$kind · $campus, floor $floor';
  }

  @override
  String roomMetaNoFloor(String kind, String campus) {
    return '$kind · $campus';
  }

  @override
  String get roomStatFreeFor => 'Free for';

  @override
  String get roomStatFloor => 'Floor';

  @override
  String get roomStatBuilding => 'Building';

  @override
  String get roomBook => 'Save place';

  @override
  String roomBooked(String time) {
    return 'Saved until $time';
  }

  @override
  String roomBookedToast(String name, String time) {
    return '$name · saved until $time';
  }

  @override
  String get roomReleasedToast => 'Saved place removed';

  @override
  String get roomRoute => 'Show on the floor plan';

  @override
  String roomNotOnPlan(String name) {
    return '$name is not on the campus floor plans';
  }

  @override
  String get roomTakenBadge => 'busy';

  @override
  String get homeOfflineBanner => 'Offline · showing saved data';

  @override
  String get homeGreetingMorning => 'Good morning, ';

  @override
  String get homeGreetingDay => 'Good afternoon, ';

  @override
  String get homeGreetingEvening => 'Good evening, ';

  @override
  String get homeStatusNoLessons => 'no classes';

  @override
  String homeStatusOngoing(int index, int count) {
    return 'class $index of $count in progress';
  }

  @override
  String homeStatusNext(String time) {
    return 'next at $time';
  }

  @override
  String homeStatusFirst(String time) {
    return 'first at $time';
  }

  @override
  String homeStatusStart(String time) {
    return 'starts at $time';
  }

  @override
  String get homeStatusDone => 'done for today';

  @override
  String homeHeroFirstIn(int minutes) {
    return 'First class in $minutes min';
  }

  @override
  String get homeHeroNow => 'In progress';

  @override
  String homeHeroBreak(int minutes) {
    return 'Break · $minutes min';
  }

  @override
  String get homeHeroDoneTitle => 'Done for today.';

  @override
  String homeHeroDoneLessons(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count classes behind',
      one: '$count class behind',
    );
    return '$_temp0';
  }

  @override
  String homeHeroTomorrow(String lessons, String time) {
    return 'Tomorrow $lessons, first at $time';
  }

  @override
  String get homeHeroTomorrowFree => 'No classes tomorrow';

  @override
  String homeHeroDeadlineChip(String left) {
    return 'Deadline · $left';
  }

  @override
  String get homeHeroDeadlineNone => 'No deadlines';

  @override
  String get homeHeroTomorrowPlan => 'Plan for tomorrow';

  @override
  String get homeHeroFirstLesson => 'FIRST CLASS';

  @override
  String get homeHeroFreeTitle => 'No classes.';

  @override
  String get homeHeroFreeBody =>
      'Close a deadline, visit the cowork or check the events board.';

  @override
  String homeWhoGoesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count going',
      one: '$count going',
    );
    return '$_temp0';
  }

  @override
  String get homeWhoGoesEmpty => 'Who is going';

  @override
  String get homeWhoGoesTitle => 'Who is going to class';

  @override
  String homeWhoGoesSubtitle(int count, int total) {
    return '$count of $total';
  }

  @override
  String get homeWhoGoesMe => 'I am going too';

  @override
  String get homeWhoGoesMeDone => 'You are going';

  @override
  String get homeWhoGoesGoing => 'going';

  @override
  String get homeWhoGoesNoClassmates =>
      'Classmates will appear here once they pick your group';

  @override
  String get homeGoingToast => 'You are going to class';

  @override
  String homeFreeRoomTitle(String room) {
    return '$room is free';
  }

  @override
  String homeFreeRoomUntil(String time) {
    return 'until $time';
  }

  @override
  String get homeFreeRoomsSub => 'find a place for the break';

  @override
  String homeStreakDays(int count) {
    return '$count days in a row';
  }

  @override
  String homeXp(String xp) {
    return '$xp XP';
  }

  @override
  String homeDeadlinesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count deadlines',
      one: '$count deadline',
    );
    return '$_temp0';
  }

  @override
  String homeExamIn(int days) {
    return 'Test in $days d';
  }

  @override
  String get homeExamToday => 'Test today';

  @override
  String get homeAllServices => 'all services';

  @override
  String get homeAddDeadline => '+ add';

  @override
  String get homeDeadlinesAllDone => 'All done. Keep it up.';

  @override
  String get homeAllLower => 'all';

  @override
  String homeRepliesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count replies',
      one: '$count reply',
    );
    return '$_temp0';
  }

  @override
  String homeLessonMoved(String type, String room, String old) {
    return '$type · $room instead of $old';
  }

  @override
  String get homeDeadlineDone => 'done';

  @override
  String homeNoteChars(int count, int max) {
    return '$count / $max';
  }

  @override
  String get homeSearchLabel => 'Search';

  @override
  String homeWeekParity(String parity) {
    return '· $parity';
  }

  @override
  String get notificationsReadAll => 'Mark all read';

  @override
  String get notificationsEmptyTitle => 'No notifications yet';

  @override
  String get notificationsEmptySubtitle =>
      'Schedule changes and pushes will show up here';

  @override
  String get notifTimeNow => 'now';

  @override
  String notifTimeMinutes(int count) {
    return '$count min';
  }

  @override
  String notifTimeHours(int count) {
    return '$count h';
  }

  @override
  String get notifTimeYesterday => 'yesterday';

  @override
  String notifChangeMoved(String subject) {
    return 'Moved · $subject';
  }

  @override
  String notifChangeCancelled(String subject) {
    return 'Cancelled · $subject';
  }

  @override
  String notifChangeAdded(String subject) {
    return 'New class · $subject';
  }

  @override
  String notifChangeRoom(String subject) {
    return 'New room · $subject';
  }

  @override
  String notifChangeTeacher(String subject) {
    return 'New teacher · $subject';
  }

  @override
  String notifChangeInsteadOf(String value) {
    return 'instead of $value';
  }

  @override
  String get notifPushDefaultTitle => 'Notification';

  @override
  String get offlineBannerCached => 'Offline · showing saved data';

  @override
  String profileRankXp(String rank, String xp) {
    return '$rank · $xp XP';
  }

  @override
  String profileGroupPlace(int rank) {
    return '#$rank in group';
  }

  @override
  String get profileGroupPlaceUnknown => 'no place yet';

  @override
  String profileXpToLevelStreak(String xp, int level, int days) {
    return '$xp XP to level $level · streak $days d.';
  }

  @override
  String get profileRankShinobi => 'Shinobi';

  @override
  String get profileRankChunin => 'Chunin';

  @override
  String get profileRankJonin => 'Jonin';

  @override
  String get profileRankKage => 'Kage';

  @override
  String get profileMetricGpa => 'GPA';

  @override
  String get profileMetricAttendance => 'attendance';

  @override
  String get profileMetricExam => 'to exam';

  @override
  String profileDaysShort(int days) {
    return '$days d';
  }

  @override
  String get profileWeekQuests => 'Weekly quests';

  @override
  String get profileUntilSunday => 'until Sunday';

  @override
  String profileQuestXp(int xp) {
    return '+$xp XP';
  }

  @override
  String profileQuestProgress(int done, int total) {
    return '$done/$total';
  }

  @override
  String get profileQuestsEmpty => 'No quests are available yet';

  @override
  String profileAllBadges(int count) {
    return 'all $count';
  }

  @override
  String profileBadgeSoon(int percent) {
    return 'Soon · $percent%';
  }

  @override
  String get profileBadgesEmpty => 'Your first achievement is close';

  @override
  String profileFriendsMeta(int count, int campus) {
    return '$count · $campus on the map';
  }

  @override
  String get profileStudentCard => 'NFC Pass';

  @override
  String profileCardNumber(String number) {
    return 'No. $number';
  }

  @override
  String get profileEditAbout => 'About';

  @override
  String get profileEditAboutHint => 'A personal note about yourself';

  @override
  String get profileEditTelegram => 'Telegram';

  @override
  String get profileEditTelegramHint => '@username';

  @override
  String get profileEditName => 'Name';

  @override
  String get profileUpdatedToast => 'Profile updated';

  @override
  String get profileChangePhoto => 'Change photo';

  @override
  String get profilePhotoSoon => 'Photo upload is coming soon';

  @override
  String get leaderboardScopeInstitute => 'Institute';

  @override
  String get leaderboardScopeUniversity => 'University';

  @override
  String leaderboardXp(String xp) {
    return '$xp XP';
  }

  @override
  String leaderboardHintGap(int place, String xp) {
    return '$xp XP to place $place. Finish the weekly quests.';
  }

  @override
  String get leaderboardHintTop => 'You are in the top three. Keep the pace!';

  @override
  String get leaderboardEmpty => 'The rating is empty for now';

  @override
  String get leaderboardError => 'Could not load the rating';

  @override
  String get settingsAppearanceSection => 'Appearance';

  @override
  String get settingsAccentLabel => 'Accent';

  @override
  String get settingsLockWidget => 'Lock screen widget';

  @override
  String settingsWidgetNext(String time) {
    return 'NEXT · $time';
  }

  @override
  String get settingsWidgetPreview => 'preview';

  @override
  String get settingsWidgetNoLesson => 'No classes';

  @override
  String get settingsGroup => 'Group';

  @override
  String get settingsShowPast => 'Show past classes';

  @override
  String get settingsShowPastSub => 'Greyed out, below the current one';

  @override
  String get settingsShowCancelled => 'Show cancelled';

  @override
  String get settingsShowCancelledSub => 'Struck through';

  @override
  String get settingsOnlySubgroup => 'Only my subgroup';

  @override
  String get settingsOnlySubgroupSub => 'Hides the other subgroup\'s classes';

  @override
  String get settingsExportCalendar => 'Export to calendar';

  @override
  String get settingsExportSync => 'Sync';

  @override
  String get settingsExportDone => 'Schedule added to the calendar';

  @override
  String get settingsExportNoSchedule => 'Pick a schedule first';

  @override
  String get settingsNotifyLessonsSub => '15 minutes before start';

  @override
  String get settingsNotifyDeadlines => 'Deadlines';

  @override
  String get settingsNotifyDeadlinesSub => 'A day and an hour before';

  @override
  String get settingsNotifyNewsSub => 'Important only';

  @override
  String get settingsShowToFriends => 'Show me to friends';

  @override
  String get settingsShowToFriendsSub => 'Only on campus';

  @override
  String get settingsGeo => 'Location';

  @override
  String get settingsGeoSub => 'Map and rooms';

  @override
  String get settingsSignOutFull => 'Sign out';

  @override
  String settingsVersionBuild(String version, String build) {
    return 'Version $version · build $build';
  }

  @override
  String get settingsAllNotifications => 'All notifications';

  @override
  String get friendsCommonWindowsToday => 'Shared gaps today';

  @override
  String get friendsCompareHeroTitle => 'Free time with friends';

  @override
  String get friendsCompareHeroSub => 'From your friend’s group schedule';

  @override
  String get friendsCompare => 'Compare';

  @override
  String get friendsFilterAll => 'All';

  @override
  String get friendsFilterCampus => 'On the map';

  @override
  String get friendsPrivacyTitle => 'Location sharing is your choice';

  @override
  String get friendsPrivacySub =>
      'Friends see your last shared location. Manage access in map settings; campus and floor detection are unavailable.';

  @override
  String get friendsCampusEmpty => 'No one is sharing a recent location';

  @override
  String friendsNoTelegram(String name) {
    return '$name has no Telegram handle';
  }

  @override
  String get friendsLoadError => 'Could not load friends';

  @override
  String friendsMessage(String name) {
    return 'Message $name';
  }

  @override
  String get newsSourceAllAbbr => 'ALL';

  @override
  String get articleSaved => 'Saved';

  @override
  String get communitiesJoin => 'Join';

  @override
  String get servicesSearchPlaceholder => 'Find a service, room, person';

  @override
  String get servicesEditBanner => 'Star the services you want on Home';

  @override
  String get servicesFavoriteAdd => 'Add to Home';

  @override
  String get servicesFavoriteRemove => 'Remove from Home';

  @override
  String get servicesNfcOpenTitle => 'Open the turnstile';

  @override
  String get servicesNfcActiveTitle => 'Hold near the turnstile';

  @override
  String get servicesNfcActiveSub => 'Active for 30 seconds · tap to cancel';

  @override
  String servicesNfcPassSub(String id) {
    return 'Pass no. $id';
  }

  @override
  String get servicesNfcConnectSub => 'Pass not connected · tap to connect';

  @override
  String get servicesNfcUnavailableSub => 'NFC is unavailable on this device';

  @override
  String get servicesSectionCampus => 'Campus';

  @override
  String get servicesSectionStudy => 'Studies';

  @override
  String get serviceNfcTitle => 'Pass';

  @override
  String get serviceExamsTitle => 'Exams';

  @override
  String get serviceMarketTitle => 'Market';

  @override
  String get serviceMapSub => 'Rooms and routes';

  @override
  String get serviceRoomsSub => 'Free right now';

  @override
  String get serviceCoworkSub => 'Seats and booking';

  @override
  String get serviceNfcSub => 'NFC campus pass';

  @override
  String get serviceDeadlinesSub => 'Tasks and due dates';

  @override
  String get serviceExamsSub => 'Tests and exams';

  @override
  String serviceExamsInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Test in $count days',
      one: 'Test in $count day',
      zero: 'Test today',
    );
    return '$_temp0';
  }

  @override
  String get serviceGradesSub => 'GPA and semester marks';

  @override
  String get serviceAttendanceSub => 'Absences and stats';

  @override
  String get serviceNotesSub => 'Group notes';

  @override
  String get serviceKbSub => 'Tickets, solutions, cheat sheets';

  @override
  String get serviceToolsSub => 'Grant and credits';

  @override
  String get serviceNewsSub => 'University channels';

  @override
  String get serviceCommunitiesSub => 'Clubs and sections';

  @override
  String get serviceFriendsSub => 'Who is on campus';

  @override
  String get servicePollsSub => 'Group votes';

  @override
  String get serviceEventsSub => 'Events this week';

  @override
  String get serviceMarketSub => 'Student listings';

  @override
  String get serviceLostSub => 'Found and lost items';

  @override
  String get serviceWalletSub => 'Balance and grant';

  @override
  String get serviceAppsSub => 'Mini apps';

  @override
  String get serviceVirtualTourSub => 'Walk around the campus';

  @override
  String get servicePeopleSub => 'Classmates and group';

  @override
  String get serviceFriendsMapSub => 'Friends on the map';

  @override
  String get serviceTeamFinderSub => 'Build a team';

  @override
  String get serviceMentorshipSub => 'Mentors and advice';

  @override
  String get serviceExternalSub => 'Opens in the browser';

  @override
  String get searchSheetPlaceholder => 'Room, subject, person, service';

  @override
  String get searchSheetNoResults =>
      'Nothing found. Try “A-318” or “calculus”.';

  @override
  String get searchTagSubject => 'Subject';

  @override
  String get searchTagService => 'Service';

  @override
  String get searchSubjectInSchedule => 'in the schedule';

  @override
  String get deadlinesClosedSemester => 'Completed deadlines';

  @override
  String deadlinesOfTotal(int total) {
    return 'of $total';
  }

  @override
  String get deadlinesGroupToday => 'Today';

  @override
  String get deadlineLeftDone => 'done';

  @override
  String get deadlinesSharedTitle => 'Shared group deadlines';

  @override
  String deadlinesSharedBody(int shared, int total) {
    return 'The monitor adds one — everyone sees it. $shared of $total are shared.';
  }

  @override
  String get deadlineDoneToast => 'Deadline closed';

  @override
  String get undo => 'Undo';

  @override
  String get deadlinesAddSemantics => 'Add deadline';

  @override
  String get addDeadlineTitle => 'New deadline';

  @override
  String get addDeadlineWhatHint => 'What to hand in';

  @override
  String get addDeadlineSubject => 'Subject';

  @override
  String get addDeadlineDue => 'Due';

  @override
  String get addDeadlinePickDate => 'Pick a date';

  @override
  String get addDeadlineSharedTitle => 'Shared with the group';

  @override
  String addDeadlineSharedSub(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Visible to all $count people',
      one: 'Visible to $count person',
    );
    return '$_temp0';
  }

  @override
  String get addDeadlineSharedSubGeneric => 'Everyone in the group will see it';

  @override
  String get addDeadlineToast =>
      'Deadline added · I\'ll remind you a day before';

  @override
  String get examsTitle => 'Assessment';

  @override
  String examsSessionIn(int count) {
    return 'session in $count d';
  }

  @override
  String examsNearestIn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nearest · in $count days',
      one: 'Nearest · in $count day',
      zero: 'Nearest · today',
    );
    return '$_temp0';
  }

  @override
  String get examsReadiness => 'Readiness';

  @override
  String get examsTopicsTitle => 'Topics for the test';

  @override
  String get examsTopicsHint => 'tick what you\'ve covered';

  @override
  String get examsTopicsEmpty =>
      'Add topics — readiness is calculated automatically';

  @override
  String get examsAddTopic => 'Add topic';

  @override
  String get examsTopicHint => 'Topic';

  @override
  String get examsRemoveTopic => 'Remove topic';

  @override
  String get examsPlanTitle => 'Study plan';

  @override
  String get examsPlanRebuild => 'rebuild';

  @override
  String get examsPlanEmpty => 'All topics covered — time to rest';

  @override
  String examsPlanMinutes(int count) {
    return '$count min';
  }

  @override
  String get examsAllTitle => 'All assessments';

  @override
  String get examsDaysShort => 'D';

  @override
  String examsSelectSemantics(String subject) {
    return 'Show $subject';
  }

  @override
  String get toolsPageTitle => 'Tools';

  @override
  String get toolsTabGpa => 'GPA';

  @override
  String get toolsTabGrant => 'Grant';

  @override
  String get toolsTabEcts => 'Credits';

  @override
  String get toolsTabCommunity => 'Community';

  @override
  String get toolsGpaForecast => 'GPA forecast for the session';

  @override
  String get toolsGpaHintAllFives => 'Increased grant · 100%';

  @override
  String get toolsGpaHintHalfFives =>
      'Increased grant possible with ≥ 50% fives';

  @override
  String get toolsGpaHintThree => 'There is a three — base grant only';

  @override
  String get toolsMarksHint => 'Tap a mark to change it';

  @override
  String get toolsMarksEmpty =>
      'Add your group\'s schedule — subjects will appear here';

  @override
  String toolsMarkSemantics(String subject, int mark) {
    return '$subject: mark $mark';
  }

  @override
  String get toolsGrantBase => 'Base';

  @override
  String get toolsGrantStudy => 'Increased · studies';

  @override
  String get toolsGrantScience => 'Increased · science';

  @override
  String get toolsGrantSocial => 'Social';

  @override
  String get toolsGrantNoApplication => 'no application';

  @override
  String get toolsGrantNotEligible => 'not eligible';

  @override
  String get toolsGrantEvent => 'Event participation';

  @override
  String get toolsGrantEventSub => '1 per semester is required';

  @override
  String toolsRubles(String amount) {
    return '$amount ₽';
  }

  @override
  String toolsRublesPlus(String amount) {
    return '+$amount ₽';
  }

  @override
  String toolsGrantNote(int done, String rest) {
    return 'The increased grant needs: no threes, ≥ 50% fives and 1 event. Now — $done of 3: $rest.';
  }

  @override
  String get toolsGrantNoteDone =>
      'The increased grant needs: no threes, ≥ 50% fives and 1 event. All conditions are met — apply.';

  @override
  String toolsGrantRestThrees(String subject) {
    return 'fix $subject';
  }

  @override
  String get toolsGrantRestFives => 'more fives needed';

  @override
  String get toolsGrantRestEvent => 'attend an event';

  @override
  String get toolsEctsEarned => 'Earned this year';

  @override
  String toolsEctsValue(int earned, int total) {
    return '$earned / $total cr.';
  }

  @override
  String toolsEctsLegend(int credits, String subject) {
    return '$credits $subject';
  }

  @override
  String pollsOpenCount(int count) {
    return '$count unanswered';
  }

  @override
  String get pollsAuthorYou => 'Your poll';

  @override
  String get pollsAuthorCommunity => 'Community poll';

  @override
  String get pollsStatusClosed => 'closed';

  @override
  String get pollsStatusOpen => 'open';

  @override
  String pollsStatusUntil(String date) {
    return 'until $date';
  }

  @override
  String get pollsYouAnswered => 'you answered';

  @override
  String get pollsVoteCounted => 'Vote counted';

  @override
  String get eventsFilterToday => 'Today';

  @override
  String get eventsFilterFree => 'Free';

  @override
  String get eventsFilterGoing => 'Going';

  @override
  String get eventsFreeLabel => 'free';

  @override
  String eventsGoingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count going',
      one: '$count going',
    );
    return '$_temp0';
  }

  @override
  String get eventsGoingChecked => 'Going ✓';

  @override
  String get eventsEmptyGoingTitle => 'You are not going anywhere yet';

  @override
  String get eventsEmptyGoingSub =>
      'Tap “Going” on an event and it will show up here.';

  @override
  String get eventsEmptyTodayTitle => 'No events today';

  @override
  String get eventsToastGoing => 'Added to your plans';

  @override
  String get eventsToastRemoved => 'Removed from your plans';

  @override
  String get lostFoundTabAll => 'All';

  @override
  String get lostFoundTabFoundShort => 'Found';

  @override
  String get lostFoundTabLostShort => 'Looking';

  @override
  String get lostFoundSecurityTitle => 'Security desk';

  @override
  String get lostFoundSecuritySub =>
      'Give found documents or valuables to a security staff member';

  @override
  String get lostFoundEmptyAll => 'No listings yet';

  @override
  String lostFoundContactAuthor(String name) {
    return 'Contact $name';
  }

  @override
  String get walletBalanceTitle => 'Shuriken balance';

  @override
  String get walletTopUp => 'Top up';

  @override
  String get walletTopUpSubtitle => 'how to earn shurikens';

  @override
  String get walletIncomeMonth => 'Income this month';

  @override
  String get walletSpendMonth => 'Spent this month';

  @override
  String walletForMonth(String month) {
    return 'in $month';
  }

  @override
  String get walletNoIncome => 'nothing earned yet';

  @override
  String get walletOperations => 'Operations';

  @override
  String get walletPassActive => 'Pass is active';

  @override
  String get walletPassExpired => 'Pass has expired';

  @override
  String get walletPassMissing => 'No pass linked';

  @override
  String walletPassValidUntil(String date) {
    return 'Student card · until $date';
  }

  @override
  String get walletPassMissingSub =>
      'Add your student card number in the profile';

  @override
  String walletCardNumber(String number) {
    return 'No. $number';
  }

  @override
  String get collabNotesFilterAll => 'All';

  @override
  String get collabNotesFilterNew => 'New';

  @override
  String get collabNotesFilterMine => 'Mine';

  @override
  String get collabNotesFilterGroup => 'Group';

  @override
  String get collabNotesFilterPersonal => 'Personal';

  @override
  String get collabNotesKindLecture => 'LEC';

  @override
  String get collabNotesKindPractice => 'PRAC';

  @override
  String get collabNotesKindLab => 'LAB';

  @override
  String get collabNotesKindDoc => 'DOC';

  @override
  String get collabNotesPersonalLabel => 'Personal note';

  @override
  String get collabNotesGroupLabel => 'Group note';

  @override
  String collabNotesStatsTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'You maintain $count notes',
      one: 'You maintain $count note',
      zero: 'You have no notes yet',
    );
    return '$_temp0';
  }

  @override
  String get collabNotesStatsSub =>
      'Shared notes are visible to the whole group';

  @override
  String collabNotesStatsNew(int count) {
    return '$count new';
  }

  @override
  String get knowledgeSearchHint => 'Subject, tickets, teacher';

  @override
  String knowledgeDownloads(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count downloads',
      one: '$count download',
    );
    return '$_temp0';
  }

  @override
  String knowledgeLikes(int count) {
    return '♥ $count';
  }

  @override
  String knowledgePriceShurikens(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count shurikens',
      one: '$count shuriken',
    );
    return '$_temp0';
  }

  @override
  String get knowledgeEmptySearchText => 'Nothing found. Ask your group — ';

  @override
  String get knowledgeCreateRequest => 'create a request';

  @override
  String knowledgeRequestShareText(String query) {
    return 'Looking for materials: $query. Does anyone have them?';
  }

  @override
  String get knowledgeDownload => 'Download';

  @override
  String get marketWrite => 'Message';

  @override
  String get marketManage => 'Manage';

  @override
  String get marketFavoriteAdd => 'Add to favourites';

  @override
  String get marketFavoriteRemove => 'Remove from favourites';

  @override
  String get loginWelcomeBackAccent => 'back';

  @override
  String get authEmailHeaderTitleAccent => 'continue';

  @override
  String get authCheckEmailTitleAccent => 'email';

  @override
  String get authSignUpTitleAccent => 'account';

  @override
  String get authPasswordResetTitleAccent => 'reset';

  @override
  String get authEmailHeaderSubtitle =>
      'We will send a 6-digit code to your email.';

  @override
  String get lessonAttendanceTitle => 'Group attendance';

  @override
  String get lessonAttendanceMeta => 'last 5';

  @override
  String get scheduleActionHide => 'Hide from schedule';

  @override
  String get scheduleTeacherRoom => 'office';

  @override
  String get roomLocalPlanHint =>
      'A personal note on this device. It does not reserve the room or guarantee a free seat.';

  @override
  String get roomAvailabilityUnknown => 'Current availability is unknown';

  @override
  String get roomRemoveSaved => 'Remove saved place';

  @override
  String get mapFriendsOutdoorHint =>
      'Friends are shown on the campus map. Indoor positions and floors are unknown.';

  @override
  String get coworkLocalPlanHint =>
      'A personal plan, not a reservation. The layout is schematic; seat availability and queues are not checked.';

  @override
  String get coworkLocalPlan => 'Personal plan';

  @override
  String get coworkSaveError => 'Could not save. Please try again.';

  @override
  String get coworkClosed => 'Choose a seat between 08:00 and 22:00';

  @override
  String get communitiesSave => 'Save';

  @override
  String get communitiesSaved => 'Saved';

  @override
  String get communitiesSavedEmpty => 'Save a community to see it here';

  @override
  String get homeTrendingEmpty => 'No discussions yet';

  @override
  String get homeFavoritesEmpty => 'Choose quick actions in Services';

  @override
  String get onboardingFriendsSharingSub => 'Share your location with friends';

  @override
  String get onboardingGeoSystemSettings =>
      'Location access can be turned off in system settings';

  @override
  String get toolsLocalEstimate =>
      'Personal estimate saved on this device. Check scholarship amounts and eligibility with your university.';

  @override
  String get toolsNoValue => 'not entered';

  @override
  String get toolsGpaPersonal => 'Your forecast, not an official grade record';

  @override
  String get toolsEctsTarget => 'Credit target';

  @override
  String get personalRecordsNotice =>
      'Personal records on this device. Not official university data.';

  @override
  String get attendanceEstimateNotice =>
      'Attendance is estimated from the schedule and your logged absences, not verified presence.';

  @override
  String get gradesScholarshipDisclaimer =>
      'GPA reference: 4.75. This does not establish scholarship eligibility.';

  @override
  String get profileLocalFieldsNote =>
      'About and Telegram are saved only on this device and are not visible to other users.';

  @override
  String get articleSourceChannel => 'News source';

  @override
  String get deadlineSaved => 'Deadline added';

  @override
  String get scheduleLinkUnavailable =>
      'A link to this schedule is not available yet. Share text, an image or a calendar instead.';

  @override
  String get scheduleReminderLocked =>
      'This reminder is already scheduled. Changing or cancelling it is not available yet.';

  @override
  String get settingsAdvanced => 'Advanced settings';

  @override
  String get settingsLessonReactionsSub => 'Reactions next to classes';

  @override
  String get settingsWidgetRefreshRequested => 'Refresh requested';

  @override
  String get identityHandleCheckError =>
      'Could not check the username. Try again';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authConfirmPasswordLabel => 'Confirm password';

  @override
  String get settingsWidgetUnsupported =>
      'The schedule widget is available on Android';

  @override
  String get miniAppsReportFailure => 'Could not send the report. Try again.';

  @override
  String get miniAppsRevRestoreFailure =>
      'Could not restore this version. Try again.';

  @override
  String get miniAppsTokensFailure =>
      'Could not update deployment tokens. Try again.';

  @override
  String get nfcPassMediaUnavailable =>
      'Background unavailable. Select another file.';

  @override
  String lessonPairOrdinal(int number) {
    return 'Period $number';
  }

  @override
  String lessonFileKilobytes(String size) {
    return '$size KB';
  }

  @override
  String lessonFileMegabytes(String size) {
    return '$size MB';
  }

  @override
  String get scheduleShortCancelled => 'CANC';

  @override
  String get pollsCreateError => 'Could not create the poll. Try again.';

  @override
  String get knowledgeUploadError =>
      'Could not upload the material. Try again.';

  @override
  String get knowledgeFileError =>
      'Could not read this file. Choose a file up to 50 MB.';

  @override
  String get postDetailCommentsLoadError => 'Couldn\'t load comments';

  @override
  String get scheduleNoteChecklist => 'Checklist';

  @override
  String get servicesSectionFirstParty => 'Built for campus';

  @override
  String get knowledgeSubjectsTitle => 'Subjects';

  @override
  String get knowledgeSubjectsHint => 'Select up to 10 subjects';

  @override
  String get knowledgeSubjectsSearch => 'Search subjects';

  @override
  String get knowledgeSubjectsLoadError => 'Could not load subjects';

  @override
  String get knowledgeSubjectsEmpty => 'No subjects found';

  @override
  String get knowledgeSubjectsApply => 'Done';

  @override
  String get knowledgeSubjectsFilter => 'Select subjects';

  @override
  String get knowledgeUploadSuccess => 'Material published';

  @override
  String get exportSelectedDay => 'Day';

  @override
  String get exportImagePreview => 'Image preview';

  @override
  String exportImagePages(int count) {
    return '$count pages · PNG';
  }

  @override
  String get exportImageHint =>
      'The full schedule with dates, teachers and rooms. Longer periods are split into pages.';

  @override
  String get exportCalendarSafeHint =>
      'Classes go into a separate calendar. Personal events stay untouched; exporting again updates our entries.';

  @override
  String get exportCalendarMobileOnly =>
      'The system calendar is available on mobile. Use an .ics file on this device.';

  @override
  String get reminderTimeInvalid =>
      'Choose a future time before the class starts.';

  @override
  String get compareDayView => 'By day';

  @override
  String get compareWeekView => 'Week overview';

  @override
  String get compareWindowsTitle => 'Time to meet';

  @override
  String get compareNoWindows =>
      'No shared gaps of at least 30 minutes between classes';

  @override
  String get compareWindowsHint =>
      'Includes classes and events. Gaps are shown only between them.';

  @override
  String get compareChangeSchedule => 'Change';

  @override
  String get authGuestUpgradeTitle => 'Save your guest account';

  @override
  String get authGuestUpgradeSubtitle =>
      'Link an email to keep your schedule, settings and progress.';

  @override
  String get authGuestUpgradeSendCode => 'Send code';

  @override
  String get authGuestUpgradeVerify => 'Verify email';

  @override
  String get authGuestUpgradePassword => 'Set password';

  @override
  String get authGuestUpgradeDone => 'Account saved';

  @override
  String get authGuestUpgradeError =>
      'Could not save the account. Check your details and try again.';

  @override
  String get authGuestExitWarning =>
      'Signing out permanently loses access to this guest account. Link an email first to keep your data.';

  @override
  String get settingsColorCustom => 'Custom color';

  @override
  String get settingsColorHex => 'HEX';

  @override
  String get settingsColorHue => 'Hue';

  @override
  String get settingsColorSaturation => 'Saturation';

  @override
  String get settingsColorBrightness => 'Brightness';

  @override
  String friendsInviteMessage(String link) {
    return 'Join me on University Ninja! Install the app to open this invitation and add me as a friend:\n$link';
  }

  @override
  String scheduleSimultaneousLessons(int count) {
    return '$count simultaneous classes';
  }

  @override
  String get authAnyEmailHint => 'Use any email address you own.';

  @override
  String get exportCalendarIncomplete =>
      'Some events have no end time. Choose PNG, text or .ics to keep everything.';

  @override
  String get exportUnscheduledEventsHint =>
      'Events without a time remain in images and text. Calendars include only timed or explicitly all-day events.';

  @override
  String get exportAllDay => 'All day';

  @override
  String exportEntriesCount(int count) {
    return 'Events: $count';
  }

  @override
  String get knowledgePurchaseTitle => 'Unlock material?';

  @override
  String knowledgePurchaseBody(String title, String price) {
    return 'Unlock “$title” for $price. Shurikens are charged once; reopening is free.';
  }

  @override
  String get knowledgePurchaseConfirm => 'Unlock and open';

  @override
  String get knowledgePurchaseFailed =>
      'Could not unlock the material. Check your balance and try again.';

  @override
  String get knowledgePurchasePriceChanged =>
      'The price changed. Open the material again to confirm the new price.';

  @override
  String get knowledgePurchaseInsufficient => 'Not enough shurikens';
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get scheduleAppBarTitle => 'Расписание';

  @override
  String get loadingError => 'Ошибка загрузки';

  @override
  String get imageViewer => 'Просмотр изображений';

  @override
  String get selectDate => 'Выберите дату';

  @override
  String get selectDates => 'Выберите даты';

  @override
  String get enableComparisonMode => 'Включить режим сравнения';

  @override
  String get disableComparisonMode => 'Выключить режим сравнения';

  @override
  String get compareSchedules => 'Сравнить расписания';

  @override
  String get noClassesToday => 'Нет пар в этот день';

  @override
  String get selectTime => 'Выберите время';

  @override
  String get clear => 'Очистить';

  @override
  String get month => 'Месяц';

  @override
  String get week => 'Неделя';

  @override
  String get apply => 'Применить';

  @override
  String get previousDay => 'Предыдущий день';

  @override
  String get nextDay => 'Следующий день';

  @override
  String get today => 'Сегодня';

  @override
  String get refreshData => 'Обновить данные';

  @override
  String get scheduleComparison => 'Сравнение расписаний';

  @override
  String get scheduleAnalytics => 'Аналитика расписания';

  @override
  String get allClassesList => 'Список всех пар';

  @override
  String get scheduleNotSelected => 'Расписание не выбрано';

  @override
  String get findSchedule => 'Найти расписание';

  @override
  String get scheduleForSelectedDay => 'Расписание занятий на выбранный день';

  @override
  String get tomorrow => 'завтра';

  @override
  String get showEmptyClasses => 'Показывать пустые пары';

  @override
  String get emptyClasses => 'Пустые пары';

  @override
  String get analytics => 'Аналитика';

  @override
  String get weekend => 'Выходной';

  @override
  String get noClassesThisDay => 'Нет занятий в этот день';

  @override
  String get canRestOrStudy =>
      'Можно отдохнуть или заняться самостоятельной работой';

  @override
  String get goToAnotherDay => 'Перейти к другому дню';

  @override
  String classesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'пар',
      few: 'пары',
      one: 'пара',
    );
    return '$_temp0';
  }

  @override
  String get noClass => 'Нет занятия';

  @override
  String get displaySettings => 'Настройки отображения';

  @override
  String get showCommentIndicators => 'Показывать индикаторы комментариев';

  @override
  String get compactCardMode => 'Компактный режим карточек';

  @override
  String get lecture => 'Лекция';

  @override
  String get laboratory => 'Лабораторная';

  @override
  String get practice => 'Практика';

  @override
  String get exam => 'Экзамен';

  @override
  String get consultation => 'Консультация';

  @override
  String get credit => 'Зачет';

  @override
  String get unknown => 'Неизвестно';

  @override
  String get lessonType => 'Тип занятия';

  @override
  String get individual => 'Индивидуальная';

  @override
  String get physicalEducation => 'Физкультура';

  @override
  String get courseWork => 'Курсовая работа';

  @override
  String get courseProject => 'Курсовой проект';

  @override
  String get mapsOnlyOnMobile =>
      'Карты доступны только на мобильных устройствах';

  @override
  String get scheduleAnalyticsTitle => 'Аналитика расписания';

  @override
  String get scheduleAnalyticsDescription =>
      'Статистика и анализ вашего учебного расписания';

  @override
  String get loadByDays => 'Загрузка по дням';

  @override
  String get lessonTypes => 'Типы занятий';

  @override
  String get teachers => 'Преподаватели';

  @override
  String get classrooms => 'Аудитории';

  @override
  String get noDataForAnalytics => 'Нет данных для аналитики';

  @override
  String get selectAnotherSchedule =>
      'Выберите другое расписание или проверьте наличие занятий';

  @override
  String get exportData => 'Экспорт данных';

  @override
  String get fullReportWithCharts => 'Полный отчет со всеми графиками';

  @override
  String get dataInTableFormat => 'Данные в табличном формате';

  @override
  String get shareImage => 'Поделиться изображением';

  @override
  String get currentOrAllCharts => 'Текущим графиком или всеми';

  @override
  String get export => 'Экспорт';

  @override
  String get monday => 'Понедельник';

  @override
  String get tuesday => 'Вторник';

  @override
  String get wednesday => 'Среда';

  @override
  String get thursday => 'Четверг';

  @override
  String get friday => 'Пятница';

  @override
  String get scheduleChanges => 'Изменения в расписании';

  @override
  String get calendar => 'Календарь';

  @override
  String get scheduleLoadingError => 'Ошибка при загрузке расписания';

  @override
  String get addSchedulesForComparison => 'Добавьте расписания для сравнения';

  @override
  String get buildRoute => 'Построить маршрут';

  @override
  String get mySchedules => 'Мои расписания';

  @override
  String get createSchedule => 'Создать расписание';

  @override
  String get addClass => 'Добавить пару';

  @override
  String get classesList => 'Список пар';

  @override
  String get classLabel => 'Пара';

  @override
  String get open => 'Открыть';

  @override
  String get edit => 'Редактировать';

  @override
  String get delete => 'Удалить';

  @override
  String get editSchedule => 'Редактирование расписания';

  @override
  String get cancel => 'Отмена';

  @override
  String get save => 'Сохранить';

  @override
  String get deleteSchedule => 'Удаление расписания';

  @override
  String deleteScheduleConfirmation(String scheduleName) {
    return 'Вы уверены, что хотите удалить расписание \"$scheduleName\"?';
  }

  @override
  String get createNewClass => 'Создать новую пару';

  @override
  String get noAddedClasses => 'Нет добавленных пар';

  @override
  String get deleteClass => 'Удаление пары';

  @override
  String deleteClassConfirmation(String subject) {
    return 'Вы уверены, что хотите удалить пару \"$subject\" из расписания?';
  }

  @override
  String get start => 'Начало';

  @override
  String get end => 'Конец';

  @override
  String get endTimeMustBeAfterStart =>
      'Время окончания должно быть позже времени начала';

  @override
  String get classNumber => 'Номер пары';

  @override
  String get none => 'Нет';

  @override
  String get groups => 'Группы';

  @override
  String get noTeachersSelected => 'Преподаватели не выбраны';

  @override
  String get addTeacher => 'Добавить преподавателя';

  @override
  String get add => 'Добавить';

  @override
  String get selectAtLeastOneDate => 'Выберите хотя бы одну дату проведения';

  @override
  String get addAtLeastOneClassroom =>
      'Добавьте хотя бы одну аудиторию или сделайте занятие онлайн';

  @override
  String get noSelectedDates => 'Нет выбранных дат';

  @override
  String get selectDatesButton => 'Выбрать даты';

  @override
  String get noSelectedClassrooms => 'Нет выбранных аудиторий';

  @override
  String get addClassroom => 'Добавить аудиторию';

  @override
  String get noGroupsSelected => 'Группы не выбраны';

  @override
  String get addGroup => 'Добавить группу';

  @override
  String get exampleClassNames => 'Пример названий пар:';

  @override
  String get textCopied => 'Текст скопирован!';

  @override
  String failedToOpenImage(String error) {
    return 'Не удалось открыть изображение: $error';
  }

  @override
  String get loginFailed => 'Ошибка входа';

  @override
  String get next => 'Далее';

  @override
  String get errorLoadingSponsors => 'Ошибка при загрузке спонсоров';

  @override
  String get login => 'Войти';

  @override
  String get loginToContinue => 'Войдите для продолжения';

  @override
  String get deleteScheduleTitle => 'Удаление расписания';

  @override
  String get deleteScheduleMessage =>
      'Вы уверены, что хотите удалить это расписание?';

  @override
  String get makeActive => 'Сделать активным';

  @override
  String get comment => 'Комментарий';

  @override
  String get schedules => 'Расписания';

  @override
  String get loadingSchedules => 'Загрузка расписаний...';

  @override
  String get addedClass => 'Добавляемая пара:';

  @override
  String get createNewSchedule => 'Создать новое расписание';

  @override
  String get selectSchedule => 'Выберите расписание:';

  @override
  String classAddedToSchedule(String scheduleName) {
    return 'Пара добавлена в расписание \"$scheduleName\"';
  }

  @override
  String get legends => 'Обозначения';

  @override
  String get maxThreeSchedules => 'Максимум 3 расписания для сравнения';

  @override
  String get university => 'Университет';

  @override
  String get search => 'Поиск';

  @override
  String get all => 'Все';

  @override
  String get error => 'Ошибка';

  @override
  String get searchFailed => 'Не удалось выполнить поиск';

  @override
  String get enterCommentText => 'Введите текст комментария...';

  @override
  String get remove => 'Удалить';

  @override
  String get noAvailableSchedules => 'Нет доступных расписаний';

  @override
  String get scheduleDeleted => 'Расписание удалено';

  @override
  String get deleteScheduleConfirmationDialog =>
      'Вы уверены, что хотите удалить это расписание?';

  @override
  String get active => 'Активен';

  @override
  String get comments => 'Комментарии';

  @override
  String get activate => 'Активировать';

  @override
  String get group => 'Группа';

  @override
  String get teacher => 'Преподаватель';

  @override
  String get classroom => 'Аудитория';

  @override
  String get schedule => 'Расписание';

  @override
  String get commentDeleted => 'Комментарий удален';

  @override
  String get commentSaved => 'Комментарий сохранен';

  @override
  String get scheduleComment => 'Комментарий к расписанию';

  @override
  String get addOrEditNote =>
      'Добавьте или отредактируйте заметку к расписанию';

  @override
  String get editComment => 'Редактировать комментарий';

  @override
  String get addComment => 'Добавить комментарий';

  @override
  String get addSchedule => 'Добавить расписание';

  @override
  String get activeSchedule => 'Активное расписание';

  @override
  String get goToView => 'Перейти к просмотру';

  @override
  String get noAddedGroups => 'Нет добавленных групп';

  @override
  String get addGroupToSeeSchedule =>
      'Добавьте группу, чтобы видеть её расписание';

  @override
  String get noAddedTeachers => 'Нет добавленных преподавателей';

  @override
  String get addTeacherToSeeSchedule =>
      'Добавьте преподавателя, чтобы видеть его расписание';

  @override
  String get noAddedClassrooms => 'Нет добавленных аудиторий';

  @override
  String get addClassroomToSeeSchedule =>
      'Добавьте аудиторию, чтобы видеть её расписание';

  @override
  String get failedToLoadSchedules => 'Не удалось загрузить расписания';

  @override
  String get checkInternetConnection => 'Проверьте подключение к интернету';

  @override
  String get enterJsonString => 'Пожалуйста, введите JSON строку';

  @override
  String get enterJsonStringPlaceholder => 'Введите JSON строку...';

  @override
  String get tabs => 'Вкладки';

  @override
  String get scheduleChangesTitle => 'Изменения в расписании';

  @override
  String get loadByDaysChart => 'Загрузка по дням';

  @override
  String get lessonTypesChart => 'Типы занятий';

  @override
  String get teachersChart => 'Преподаватели';

  @override
  String get classroomsChart => 'Аудитории';

  @override
  String get fullReportWithAllCharts => 'Полный отчет со всеми графиками';

  @override
  String get dataInTableFormatExport => 'Данные в табличном формате';

  @override
  String get shareImageExport => 'Поделиться изображением';

  @override
  String get currentOrAllChartsExport => 'Текущим графиком или всеми';

  @override
  String get totalClasses => 'Общее количество пар';

  @override
  String get forEntirePeriod => 'За весь период';

  @override
  String get averagePerDay => 'Среднее в день';

  @override
  String get academicLoad => 'Учебная нагрузка';

  @override
  String get maximumPerDay => 'Максимум в день';

  @override
  String get busiestDay => 'Самый загруженный день';

  @override
  String get showEmptyClassesSettings => 'Показывать пустые пары';

  @override
  String get showCommentIndicatorsSettings =>
      'Показывать индикаторы комментариев';

  @override
  String get compactCardModeSettings => 'Компактный режим карточек';

  @override
  String get holiday => 'Выходной';

  @override
  String get selectExisting => 'В существующее';

  @override
  String get createNew => 'Новое';

  @override
  String get scheduleName => 'Название расписания';

  @override
  String get scheduleNamePlaceholder => 'Например: Моё основное расписание';

  @override
  String get descriptionOptional => 'Описание (необязательно)';

  @override
  String get addScheduleDescription => 'Добавьте описание расписания';

  @override
  String get openSchedule => 'Открыть';

  @override
  String get selectWeek => 'Выберите неделю';

  @override
  String get quickWayToWeek => 'Быстрый способ перейти к определённой неделе';

  @override
  String get selectUpToFourSchedules =>
      'Выберите до 4-х расписаний, чтобы сравнить их по дням';

  @override
  String get addToSchedule => 'Добавить в расписание';

  @override
  String get enterLessonComment => 'Введите комментарий к занятию...';

  @override
  String get noOwnSchedules => 'У вас пока нет своих расписаний';

  @override
  String get createCustomSchedule =>
      'Создайте собственное расписание, добавляя в него пары из разных доступных расписаний';

  @override
  String get scheduleCreation => 'Создание расписания';

  @override
  String get enterNameAndDescription =>
      'Введите название и описание для нового расписания';

  @override
  String get scheduleNameLabel => 'Название расписания';

  @override
  String get scheduleNameExample => 'Например: Моё расписание';

  @override
  String get descriptionOptionalLabel => 'Описание (необязательно)';

  @override
  String get addScheduleDescriptionPlaceholder =>
      'Добавьте описание расписания';

  @override
  String get editScheduleTitle => 'Редактирование расписания';

  @override
  String get classesListTitle => 'Список пар';

  @override
  String addNewClassToSchedule(String scheduleName) {
    return 'Вы можете добавить новую пару в расписание $scheduleName';
  }

  @override
  String get offline => 'Оффлайн';

  @override
  String get online => 'Онлайн';

  @override
  String get subjectName => 'Название предмета';

  @override
  String get enterSubjectName => 'Введите название предмета';

  @override
  String get teacherFullName => 'ФИО преподавателя';

  @override
  String get teacherNameExample => 'Например: Иванов Иван Иванович';

  @override
  String get endTimeMustBeAfterStartTime =>
      'Время окончания должно быть позже времени начала';

  @override
  String get selectAtLeastOneDateError =>
      'Выберите хотя бы одну дату проведения';

  @override
  String get addAtLeastOneClassroomError =>
      'Добавьте хотя бы одну аудиторию или сделайте занятие онлайн';

  @override
  String get selectDatesButtonText => 'Выбрать даты';

  @override
  String get onlineClassLink => 'Ссылка на онлайн занятие';

  @override
  String get enterConnectionUrl => 'Введите URL для подключения';

  @override
  String classroomNumber(String name) {
    return 'Аудитория $name';
  }

  @override
  String get classroomExample => 'Например: А-123';

  @override
  String get campusNameOptional => 'Название кампуса (опционально)';

  @override
  String get campusExample => 'Например: В-78';

  @override
  String get addClassroomDialog => 'Добавить аудиторию';

  @override
  String get groupName => 'Название группы';

  @override
  String get groupNameExample => 'Например: ИКБО-01-21';

  @override
  String get addGroupDialog => 'Добавить группу';

  @override
  String get retry => 'Повторить';

  @override
  String get resetFilter => 'Сбросить фильтр';

  @override
  String get supportOurService => 'Поддержите наш сервис';

  @override
  String get leaveAd => 'Оставить';

  @override
  String get disable => 'Отключить';

  @override
  String errorWithMessage(String message) {
    return 'Ошибка: $message';
  }

  @override
  String get map => 'Карта';

  @override
  String get tryAgain => 'Попробовать снова';

  @override
  String get announcement => 'Объявление';

  @override
  String get contact => 'Связаться';

  @override
  String copiedToClipboard(String title) {
    return '$title скопирован в буфер обмена';
  }

  @override
  String get post => 'Пост';

  @override
  String get errorLoadingPost => 'Ошибка при загрузке поста';

  @override
  String get errorLoadingContributors => 'Ошибка при загрузке контрибьюторов';

  @override
  String get relatedArticles => 'Похожие статьи';

  @override
  String get failedToLoadArticle => 'Не удалось загрузить статью';

  @override
  String get shareFailed => 'Ошибка при попытке поделиться';

  @override
  String get trending => 'Популярное';

  @override
  String get slideshow => 'Слайд-шоу';

  @override
  String get enterSearchQuery => 'Введите запрос для поиска';

  @override
  String get failedToLoadMoreContent => 'Не удалось загрузить больше контента';

  @override
  String get searchHistory => 'История';

  @override
  String get enterScheduleName => 'Введите название';

  @override
  String get nameTooLong => 'Слишком длинное название';

  @override
  String get createAndAddClass => 'Создать и добавить пару';

  @override
  String get addToSelectedSchedule => 'Добавить в выбранное расписание';

  @override
  String get mireaMap => 'Карта МИРЭА';

  @override
  String get findNeededClassroom => 'Найди нужный кабинет';

  @override
  String get nfcPass => 'NFC-пропуск';

  @override
  String get passForUniversityEntry => 'Пропуск для входа в университет';

  @override
  String get cloudMireaNinja => 'Cloud Mirea Ninja';

  @override
  String get mireaNinja => 'Mirea Ninja';

  @override
  String get mostPopularUnofficialChat => 'Самый популярный неофициальный чат';

  @override
  String get kisDepartment => 'Кафедра КИС';

  @override
  String get corporateInformationSystems =>
      'Кафедра Корпоративных информационных систем';

  @override
  String get ippoDepartment => 'Кафедра ИППО';

  @override
  String get instrumentalAndAppliedSoftware =>
      'Кафедра Инструментального и прикладного программного обеспечения';

  @override
  String get competitiveProgrammingMirea => 'Спортивное программирование МИРЭА';

  @override
  String get competitiveProgrammingDescription =>
      'Здесь публикуются различные новости и апдейты по олимпиадному программированию в МИРЭА';

  @override
  String get personalAccount => 'Личный кабинет';

  @override
  String get accessToGradesAndServices =>
      'Доступ к оценкам, заявлениям и другим сервисам';

  @override
  String get openAction => 'Открыть';

  @override
  String get educationalPortal => 'Учебный портал';

  @override
  String get accessToCoursesAndMaterials => 'Доступ к курсам и материалам';

  @override
  String get goToAction => 'Перейти';

  @override
  String get electronicJournal => 'Электронный журнал';

  @override
  String get attendanceCheckSchedule => 'Проверка посещаемости, расписание';

  @override
  String get library => 'Библиотека';

  @override
  String get freeSoftware => 'Бесплатное ПО';

  @override
  String get cyberzone => 'Киберзона';

  @override
  String get handbook => 'Справочник';

  @override
  String get scholarships => 'Стипендии';

  @override
  String get militaryRegistration => 'Воинский учет';

  @override
  String get dormitories => 'Общежития';

  @override
  String get studentOffice => 'Студенческий офис';

  @override
  String get certificatesDocumentsQuestions => 'Справки, документы, вопросы';

  @override
  String get careerCenter => 'Центр карьеры';

  @override
  String get vacanciesAndInternships => 'Вакансии и стажировки';

  @override
  String get initiativeService => 'Сервис инициатив';

  @override
  String get ideasAndSuggestions => 'Идеи и предложения';

  @override
  String get virtualTour => 'Виртуальный тур';

  @override
  String get interactiveUniversityTour =>
      'Интерактивная экскурсия по корпусам университета';

  @override
  String get startupAccelerator => 'Стартап-акселератор';

  @override
  String get startupSupport => 'Поддержка стартапов и предпринимательских идей';

  @override
  String get corporatePortal => 'Корпоративный портал';

  @override
  String get accessForTeachersAndStaff =>
      'Доступ для преподавателей и сотрудников';

  @override
  String get mainServices => 'Основные сервисы';

  @override
  String get studentLife => 'Студенческая жизнь';

  @override
  String get useful => 'Полезное';

  @override
  String get createAccount => 'Создать аккаунт';

  @override
  String get createAccountTitle => 'Создайте аккаунт';

  @override
  String get createAccountDescription =>
      'Мы предлагаем вам бесплатно создать аккаунт в нашем облачном хранилище, чтобы вы могли хранить свои файлы и документы!';

  @override
  String get cloudStorageDescription =>
      'На cloud.mirea.ninja вы можете хранить до 10 ГБ бесплатно (квоту можно расширить в телеграм боте), а также делиться файлами и онлайн редактировать документы вместе с одногруппниками.';

  @override
  String get searchPlaceholder => 'Поиск';

  @override
  String get searchInAnnouncements => 'Поиск по объявлениям...';

  @override
  String get itemName => 'Название';

  @override
  String get itemNameExample => 'Например: Ключи с брелоком';

  @override
  String get description => 'Описание';

  @override
  String get itemDescription =>
      'Подробности о предмете, где и когда был найден/утерян...';

  @override
  String get telegram => 'Телеграм';

  @override
  String get phone => 'Телефон';

  @override
  String get leaveFeedback => 'Оставить отзыв';

  @override
  String get yourEmail => 'Ваш email';

  @override
  String get enterEmail => 'Введите email';

  @override
  String get whatHappened => 'Что случилось?';

  @override
  String get feedbackPlaceholder => 'Когда я нажимаю \"Х\" происходит \"У\"';

  @override
  String get exportToCalendar => 'Экспорт в календарь';

  @override
  String get scheduleExported => 'Расписание экспортировано';

  @override
  String get failedToExportSchedule => 'Не удалось экспортировать расписание';

  @override
  String get exportSettings => 'Настройки экспорта';

  @override
  String get emojiInLessonTypes => 'Эмодзи в типах пар';

  @override
  String get emojiExample => 'Пример: \"📚 Лекция\" вместо \"Лекция\"';

  @override
  String get shortLessonTypeNames => 'Короткие названия типов';

  @override
  String get shortNamesExample => 'Пример: \"Лек.\" вместо \"Лекция\"';

  @override
  String get preview => 'Предпросмотр';

  @override
  String get fullTypeName => 'Полное название типа';

  @override
  String get shortTypeName => 'Сокращенное название типа';

  @override
  String get subjectSelection => 'Выбор предметов';

  @override
  String get standardReminders => 'Стандартные напоминания';

  @override
  String get cardSettings => 'Настройки карточки';

  @override
  String get codeFromEmail => 'Код из письма';

  @override
  String get news => 'Новости';

  @override
  String get services => 'Сервисы';

  @override
  String get profile => 'Профиль';

  @override
  String get aboutApp => 'О приложении';

  @override
  String get settings => 'Настройки';

  @override
  String get findScheduleForClassroom =>
      'Вы можете быстро найти расписание для этой аудитории, используя поиск по расписанию.';

  @override
  String get newYearHolidays => 'Новогодние праздники';

  @override
  String get winterVacation => 'Зимние каникулы';

  @override
  String get defenderOfFatherlandDay => 'День защитника Отечества';

  @override
  String get internationalWomensDay => 'Международный женский день';

  @override
  String get springAndLaborDay => 'Праздник Весны и Труда';

  @override
  String get victoryDay => 'День Победы';

  @override
  String get russiaDay => 'День России';

  @override
  String get nationalUnityDay => 'День народного единства';

  @override
  String get newYear => 'Новый год';

  @override
  String get total => 'Всего';

  @override
  String get lectures => 'Лекции';

  @override
  String get practicals => 'Практ.';

  @override
  String get labs => 'Лаб.';

  @override
  String get justNow => 'только что';

  @override
  String get status => 'Статус';

  @override
  String phoneContact(String phoneNumber) {
    return 'Телефон: $phoneNumber';
  }

  @override
  String lessonsOnDay(String day) {
    return 'Занятия на $day';
  }

  @override
  String get todayLower => 'сегодня';

  @override
  String get tomorrowLower => 'завтра';

  @override
  String get showEmptyLessonsTooltip => 'Показывать пустые пары';

  @override
  String get emptyLessons => 'Пустые пары';

  @override
  String get analyticsShort => 'Аналитика';

  @override
  String get dayOff => 'Выходной';

  @override
  String get noLessonsThatDay => 'Нет занятий в этот день';

  @override
  String get noLessonsThatDayShort => 'Пар в этот день нет!';

  @override
  String get restSuggestion =>
      'Можно отдохнуть или заняться самостоятельной работой';

  @override
  String windowGap(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count пар',
      many: '$count пар',
      few: '$count пары',
      one: '$count пара',
    );
    return 'Окно: $_temp0';
  }

  @override
  String get noScheduleSelected => 'Расписание не выбрано';

  @override
  String get selectEntityToSeeSchedule =>
      'Выберите группу, преподавателя или аудиторию, чтобы увидеть расписание';

  @override
  String get errorLoadingSchedule => 'Ошибка при загрузке расписания';

  @override
  String get manageComparisons => 'Управление сравнениями';

  @override
  String get selectUpTo4Schedules =>
      'Выберите до 4-х расписаний, чтобы сравнить их по дням';

  @override
  String get noUpcomingLessons => 'Нет предстоящих занятий';

  @override
  String get noUpcomingLessonsDescription =>
      'В ближайшее время занятия не запланированы. Переключитесь на календарь, чтобы посмотреть расписание за другие дни.';

  @override
  String get switchToCalendar => 'Переключиться на календарь';

  @override
  String get lecturesShort => 'Лек.';

  @override
  String get practiceShort => 'Практ.';

  @override
  String get labsShort => 'Лаб.';

  @override
  String get legend => 'Обозначения';

  @override
  String get laboratoryWork => 'Лабораторная';

  @override
  String get scheduleLoadError =>
      'Во время получения расписания произошла ошибка. Попробуйте повторить попытку.';

  @override
  String get selectSchedulesForComparison =>
      'Выберите расписания для сравнения (до 3)';

  @override
  String deleteScheduleConfirm(String name) {
    return 'Вы уверены, что хотите удалить расписание \"$name\"?';
  }

  @override
  String deleteClassConfirm(String subject) {
    return 'Вы уверены, что хотите удалить пару \"$subject\" из расписания?';
  }

  @override
  String get commentTooLong => 'Слишком длинный комментарий';

  @override
  String get addOneClassroomOrOnline =>
      'Добавьте хотя бы одну аудиторию или сделайте занятие онлайн';

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

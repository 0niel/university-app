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
  String get lessonTypeIndividualShort => 'Сам. работа';

  @override
  String get lessonTypeCourseWorkShort => 'Курс. раб.';

  @override
  String get lessonTypeCourseProjectShort => 'Курс. проект';

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
  String get searchScopeCommunity => 'Сообщ.';

  @override
  String get searchSectionPosts => 'Посты группы';

  @override
  String get searchGlobalHint => 'Пара, человек, аудитория, пост…';

  @override
  String get searchCoachTitle => 'Глобальный поиск';

  @override
  String get searchCoachBody =>
      'Одна и та же иконка в шапке каждого корневого экрана: Главная · Пары · Лента · Люди · Сервисы.';

  @override
  String get searchCoachGesture => 'Плюс жест: свайп вниз на Главной и в Парах';

  @override
  String get searchScopeAll => 'Всё';

  @override
  String get searchScopeClasses => 'Пары';

  @override
  String get searchScopeClassrooms => 'Аудит.';

  @override
  String searchTrendingTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count запросов за неделю',
      few: '$count запроса за неделю',
      one: '$count запрос за неделю',
    );
    return '$_temp0';
  }

  @override
  String get searchRecent => 'Недавнее';

  @override
  String get searchTrendingNow => 'Часто ищут сейчас';

  @override
  String get searchBestMatch => 'Лучшее совпадение';

  @override
  String searchMoreResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count результатов',
      few: '$count результата',
      one: '$count результат',
    );
    return 'Ещё $_temp0';
  }

  @override
  String get searchNoResults => 'Ничего не нашлось';

  @override
  String get searchNoResultsHint => 'Попробуй другой запрос или смени фильтр';

  @override
  String get searchTagGroup => 'Группа';

  @override
  String get searchTagTeacher => 'Преподаватель';

  @override
  String get searchTagClassroom => 'Аудитория';

  @override
  String get searchTagPerson => 'Студент';

  @override
  String get searchTagPost => 'Пост';

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
  String get errorLoadingAds => 'Ошибка при загрузке рекламы';

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
  String get scheduleActiveBadge => 'Активно';

  @override
  String get deleteScheduleAction => 'Удалить расписание';

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
  String contributorCommitsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count коммита',
      many: '$count коммитов',
      few: '$count коммита',
      one: '$count коммит',
    );
    return '$_temp0';
  }

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
  String get campusMap => 'Карта кампуса';

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
  String get orthodoxChristmas => 'Рождество Христово';

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
  String get topicsLoading => 'Загружаем обсуждение…';

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
  String lessonPeriodWord(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'пар',
      many: 'пар',
      few: 'пары',
      one: 'пара',
    );
    return '$_temp0';
  }

  @override
  String get noScheduleSelected => 'Расписание не выбрано';

  @override
  String get selectEntityToSeeSchedule =>
      'Выберите группу, преподавателя или аудиторию, чтобы увидеть расписание';

  @override
  String get noActiveGroupTitle => 'Не установлена активная группа';

  @override
  String get noActiveGroupSubtitle =>
      'Скачайте расписание по крайней мере для одной группы, чтобы отобразить календарь.';

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
  String get createClass => 'Создать пару';

  @override
  String get editClass => 'Редактировать пару';

  @override
  String get startTime => 'Начало';

  @override
  String get endTime => 'Конец';

  @override
  String get lessonNumber => 'Номер пары';

  @override
  String get teacherFullNameHint => 'Например: Иванов Иван Иванович';

  @override
  String get enterTeacherFullName => 'Введите ФИО преподавателя';

  @override
  String get onlineLessonUrl => 'Ссылка на онлайн-занятие';

  @override
  String get enterUrl => 'Введите ссылку';

  @override
  String get classroomNumberHint => 'Например: А-123';

  @override
  String get enterClassroomNumber => 'Введите номер аудитории';

  @override
  String get enterGroupName => 'Введите название группы';

  @override
  String get basic => 'Основное';

  @override
  String get dates => 'Даты';

  @override
  String get place => 'Место';

  @override
  String get create => 'Создать';

  @override
  String get addDate => 'Добавить дату';

  @override
  String get lessonDeliveryType => 'Формат проведения занятия';

  @override
  String get noClassroomsSelected => 'Аудитории не выбраны';

  @override
  String get back => 'Назад';

  @override
  String get scheduleLessonsTitle => 'Пары';

  @override
  String get busyDayBadge => 'Загруженный день';

  @override
  String studyWeekBadge(int week, String parity) {
    return 'Неделя $week · $parity';
  }

  @override
  String studyWeekNumber(int week) {
    return 'Неделя $week';
  }

  @override
  String get weekParityEvenFull => 'чётная';

  @override
  String get weekParityOddFull => 'нечётная';

  @override
  String get weekParityNumerator => 'числитель';

  @override
  String get weekParityDenominator => 'знаменатель';

  @override
  String campusesCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count корпуса',
      many: '$count корпусов',
      few: '$count корпуса',
      one: '$count корпус',
    );
    return '$_temp0';
  }

  @override
  String minutesShort(int minutes) {
    return '$minutes мин';
  }

  @override
  String get homeOngoingShort => 'идёт';

  @override
  String get backToToday => '← сегодня';

  @override
  String get offlineFromCache => 'Нет сети — расписание из кэша';

  @override
  String updatedAtTime(String time) {
    return 'обновлено $time';
  }

  @override
  String get liveNow => 'Сейчас';

  @override
  String get more => 'Ещё';

  @override
  String get notifications => 'Уведомления';

  @override
  String get share => 'Поделиться';

  @override
  String get reset => 'Сбросить';

  @override
  String get done => 'Готово';

  @override
  String get noData => 'Нет данных';

  @override
  String get todayLabel => 'сегодня';

  @override
  String get tomorrowLabel => 'завтра';

  @override
  String get yesterdayLabel => 'вчера';

  @override
  String minutesAgo(int count) {
    return '$count мин назад';
  }

  @override
  String hoursAgo(int count) {
    return '$count ч назад';
  }

  @override
  String daysAgo(int count) {
    return '$count дн назад';
  }

  @override
  String lessonsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count пары',
      many: '$count пар',
      few: '$count пары',
      one: '$count пара',
      zero: 'нет пар',
    );
    return '$_temp0';
  }

  @override
  String activitiesCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count активности',
      many: '$count активностей',
      few: '$count активности',
      one: '$count активность',
    );
    return '$_temp0';
  }

  @override
  String windowsCountSuffix(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count окна',
      many: '$count окон',
      few: '$count окна',
      one: '$count окно',
    );
    return '+$_temp0';
  }

  @override
  String eventsCountSuffix(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count события',
      many: '$count событий',
      few: '$count события',
      one: '$count событие',
    );
    return '+$_temp0';
  }

  @override
  String get scheduleQuickActions => 'Быстрые действия';

  @override
  String get scheduleActionsTitle => 'Управление расписанием';

  @override
  String get scheduleActionsImportant => 'Важное';

  @override
  String get scheduleActionsTools => 'Инструменты';

  @override
  String get scheduleActionsSettings => 'Настройка и обмен';

  @override
  String get mySchedulesSubtitle => 'Создать или открыть своё расписание';

  @override
  String get changesTitle => 'Изменения';

  @override
  String get changesSubtitle => 'Переносы, отмены и замены в расписании';

  @override
  String get compareTitle => 'Сравнить';

  @override
  String get compareSubtitle => 'Найти общие окна с другим расписанием';

  @override
  String get sessionTitle => 'Сессия';

  @override
  String get sessionSubtitle => 'Обратный отсчёт до экзаменов';

  @override
  String get analyticsTitle => 'Аналитика';

  @override
  String get analyticsSubtitle => 'Нагрузка по дням и типам занятий';

  @override
  String get exportScheduleTitle => 'Экспорт расписания';

  @override
  String get exportScheduleSubtitle => 'Синхронизируй пары с любым календарём';

  @override
  String get filtersTitle => 'Фильтры';

  @override
  String get filtersSubtitle => 'Что показывать в расписании';

  @override
  String get viewList => 'Список';

  @override
  String get viewDay => 'День';

  @override
  String get viewWeek => 'Неделя';

  @override
  String get viewMonth => 'Месяц';

  @override
  String get filterAll => 'Всё';

  @override
  String get filterLectures => 'Лекции';

  @override
  String get filterSeminars => 'Семинары';

  @override
  String get filterLabs => 'Лабы';

  @override
  String get filterExams => 'Зачёты';

  @override
  String get filterLabsFull => 'Лабораторные';

  @override
  String get filterExamsFull => 'Зачёты и экзамены';

  @override
  String get filterWordAll => 'пар';

  @override
  String get filterWordLectures => 'лекций';

  @override
  String get filterWordSeminars => 'семинаров';

  @override
  String get filterWordLabs => 'лаб';

  @override
  String get filterWordExams => 'зачётов';

  @override
  String pastTodaySummary(String lessons) {
    return 'Прошло сегодня: $lessons';
  }

  @override
  String get hidePastLessons => 'Скрыть прошедшие';

  @override
  String xpAmount(int xp) {
    return '+$xp XP';
  }

  @override
  String windowMinutes(int minutes) {
    return 'Окно $minutes мин';
  }

  @override
  String get gapCoffeeHint => '· кофе';

  @override
  String get freeClassrooms => 'Свободные аудитории';

  @override
  String endOfDay(String time) {
    return 'Конец дня — $time';
  }

  @override
  String endOfDayPotential(int xp) {
    return 'потенциал +$xp XP';
  }

  @override
  String get swipeCoachMark =>
      'Смахни пару влево — заметка, напоминание, маршрут';

  @override
  String get swipeActionsLabel => 'Действия';

  @override
  String nextInMinutes(int minutes) {
    return 'Далее · через $minutes мин';
  }

  @override
  String nextInHours(String hours) {
    return 'Далее · через $hours ч';
  }

  @override
  String minutesLeft(int minutes) {
    return 'ещё $minutes мин';
  }

  @override
  String get classroomNotSpecified => 'Аудитория не указана';

  @override
  String get prepHintLab => 'К паре: ноутбук и материалы лабы';

  @override
  String get prepHintExam => 'Повтори ключевые вопросы к зачёту';

  @override
  String get prepHintCourse => 'Проверь план курсовой перед парой';

  @override
  String get calloutCancelled => 'Пара отменена';

  @override
  String calloutMoved(String time) {
    return 'Пара перенесена: было $time';
  }

  @override
  String calloutRoomChanged(String rooms) {
    return 'Кабинет изменён: было $rooms';
  }

  @override
  String calloutTeacherChanged(String teachers) {
    return 'Замена преподавателя: $teachers';
  }

  @override
  String get calloutAdded => 'Пара добавлена';

  @override
  String emptyFilterTitle(String filter) {
    return 'Нет $filter в этот день';
  }

  @override
  String get emptyFilterSubtitle => 'Попробуй другой день или сбрось фильтр';

  @override
  String get liveActionChat => 'Чат';

  @override
  String get liveActionRecord => 'Запись';

  @override
  String friendsInClass(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$name и ещё $count на паре',
      zero: '$name на паре',
    );
    return '$_temp0';
  }

  @override
  String get noLessonsShort => 'Пар нет';

  @override
  String get weekendTitle => 'Выходной!';

  @override
  String get weekendShort => 'Выходной';

  @override
  String get scheduleTransferredDayOff => 'Перенесённый выходной';

  @override
  String get scheduleTransferredWorkday => 'Рабочий день по переносу';

  @override
  String scheduleTransferCalendarPending(int year) {
    return 'Переносы выходных на $year год ещё не опубликованы';
  }

  @override
  String get scheduleWeekHoldLesson =>
      'Удерживайте, чтобы раскрыть детали пары';

  @override
  String scheduleWeekHoldToExpand(int count) {
    return 'Ещё $count · удерживайте';
  }

  @override
  String get scheduleWeekHoldToCollapse =>
      'Все пары · удерживайте, чтобы свернуть';

  @override
  String get whatToDo => 'Чем занять?';

  @override
  String get noLessonsSelectedDay => 'На выбранный день пар нет';

  @override
  String get dayOffTitle => 'Сегодня без пар';

  @override
  String get dayOffWithActivities =>
      'Учебных занятий нет. Но есть запланированные активности.';

  @override
  String get dayOffFree =>
      'Учебных занятий нет. Можно спокойно планировать свои дела.';

  @override
  String get addActivity => 'Добавить активность';

  @override
  String nearestLessonText(String day, String time, String subject) {
    return 'Пар нет. Ближайшая — в $day в $time, $subject.';
  }

  @override
  String get goToMonday => 'К понедельнику';

  @override
  String get goToToday => 'К сегодня';

  @override
  String get previousMonth => 'Предыдущий месяц';

  @override
  String get nextMonth => 'Следующий месяц';

  @override
  String get previousWeek => 'Предыдущая неделя';

  @override
  String get nextWeek => 'Следующая неделя';

  @override
  String get legendLessons => 'Пары';

  @override
  String get legendRetake => 'Пересдача';

  @override
  String get legendEvent => 'Событие';

  @override
  String get weekdayMonday => 'понедельник';

  @override
  String get weekdayTuesday => 'вторник';

  @override
  String get weekdayWednesday => 'среда';

  @override
  String get weekdayThursday => 'четверг';

  @override
  String get weekdayFriday => 'пятница';

  @override
  String get weekdaySaturday => 'суббота';

  @override
  String get weekdaySunday => 'воскресенье';

  @override
  String get weekdayShortMon => 'Пн';

  @override
  String get weekdayShortTue => 'Вт';

  @override
  String get weekdayShortWed => 'Ср';

  @override
  String get weekdayShortThu => 'Чт';

  @override
  String get weekdayShortFri => 'Пт';

  @override
  String get weekdayShortSat => 'Сб';

  @override
  String get weekdayShortSun => 'Вс';

  @override
  String get exportPeriodToday => 'Сегодня';

  @override
  String get exportPeriodWeek => 'Неделя';

  @override
  String get exportPeriodSemester => 'Семестр';

  @override
  String get exportWhereSection => 'Куда';

  @override
  String get exportOptionsSection => 'Опции';

  @override
  String get exportSystemCalendar => 'Системный календарь';

  @override
  String get exportSystemCalendarSub => 'добавится в календарь устройства';

  @override
  String get exportGoogleCalendar => 'Google Календарь';

  @override
  String get exportGoogleCalendarSub => 'через календарь устройства';

  @override
  String get exportIcsFile => 'Файл .ics';

  @override
  String get exportIcsFileSub => 'разово, без обновлений';

  @override
  String get exportPng => 'Картинка PNG';

  @override
  String get exportPngSub => 'для сторис / сохранить в фото';

  @override
  String get exportReminders => 'Напоминания';

  @override
  String get exportRemindersSub => 'за 15 минут до пары';

  @override
  String get exportAutoUpdate => 'Авто-обновление';

  @override
  String get exportAutoUpdateSub => 'подтянет изменения расписания';

  @override
  String get exportIncludeRooms => 'Добавлять аудиторию и корпус';

  @override
  String get exportActionToday => 'Экспортировать сегодня';

  @override
  String get exportActionWeek => 'Экспортировать неделю';

  @override
  String get exportActionSemester => 'Экспортировать семестр';

  @override
  String get exportFormatSoon =>
      'Экспорт в этот формат скоро появится — пока используем календарь устройства';

  @override
  String exportStarted(String lessons) {
    return 'Экспортируем $lessons в календарь';
  }

  @override
  String get filtersLessonTypes => 'Типы пар';

  @override
  String get filtersDisplaySection => 'Отображение';

  @override
  String get filtersShowGaps => 'Показывать окна';

  @override
  String get filtersShowGapsSub => 'перерывы между парами';

  @override
  String get filtersPastLessons => 'Прошедшие пары';

  @override
  String get filtersPastLessonsSub => 'свернуть автоматически';

  @override
  String get filtersHiddenSection => 'Скрытые пары';

  @override
  String get filtersHiddenHint => 'Нажми, чтобы вернуть пару в расписание';

  @override
  String get filtersRestore => 'Вернуть';

  @override
  String get classActionsTitle => 'Действия с парой';

  @override
  String get classActionRate => 'Оценить пару';

  @override
  String get classActionRateSub => 'реакция для группы';

  @override
  String get classActionNote => 'Добавить заметку';

  @override
  String get classActionRoute => 'Построить маршрут';

  @override
  String get classActionRemind => 'Напомнить';

  @override
  String get classActionRemindSub => 'за 15 мин';

  @override
  String get classActionShare => 'Поделиться парой';

  @override
  String get classActionHide => 'Скрыть из расписания';

  @override
  String get reactionSheetTitle => 'Как пара?';

  @override
  String get reactionFire => 'Огонь';

  @override
  String get reactionBrain => 'Полезно';

  @override
  String get reactionLove => 'Топ';

  @override
  String get reactionSad => 'Грустно';

  @override
  String get reactionFlushed => 'Неожиданно';

  @override
  String get reactionSick => 'Противно';

  @override
  String get reactionPoo => 'Ужасно';

  @override
  String get reactionThinking => 'Сложно';

  @override
  String get reactionSleepy => 'Скучно';

  @override
  String get reactionSkull => 'Тяжко';

  @override
  String get reactionMindblown => 'Взрыв';

  @override
  String get reactionRespect => 'Уважение';

  @override
  String get anonymously => 'Анонимно';

  @override
  String get anonymouslySub => 'имя не покажут в группе';

  @override
  String get reactionSend => 'Отправить';

  @override
  String reactionSent(String emoji) {
    return 'Реакция отправлена $emoji';
  }

  @override
  String get reactionRemoved => 'Реакция удалена';

  @override
  String get reactionAdded => 'Реакция добавлена!';

  @override
  String get reminderSheetTitle => 'Напомнить';

  @override
  String get reminder15Min => 'За 15 минут';

  @override
  String get reminder15MinSub => 'успеешь дойти';

  @override
  String get reminder5Min => 'За 5 минут';

  @override
  String get reminder5MinSub => 'если уже рядом';

  @override
  String get reminderMorning => 'Утром в день пары';

  @override
  String get reminderMorningSub => 'в 08:00';

  @override
  String get reminderSet => 'Поставить напоминание';

  @override
  String get reminderSetSuccess => 'Напоминание установлено';

  @override
  String reminderAtTime(String time) {
    return 'в $time';
  }

  @override
  String get reminderWhenSection => 'За сколько';

  @override
  String get reminderHowSection => 'Как';

  @override
  String get reminderCustom => 'Своё время';

  @override
  String get reminderCustomHint => 'выбрать время';

  @override
  String reminderCustomAt(String time) {
    return 'в $time';
  }

  @override
  String get reminderPush => 'Пуш-уведомление';

  @override
  String get reminderRoute => 'С маршрутом до аудитории';

  @override
  String get reminderTraffic => 'Учитывать пробки';

  @override
  String get reminderTrafficSub => 'выйти раньше, если далеко';

  @override
  String get reminderSuccessTitle => 'Напоминание стоит';

  @override
  String reminderSuccessBody(String time) {
    return 'Напомним в $time';
  }

  @override
  String reminderSuccessBodyRoute(String time, String room) {
    return 'Напомним в $time с маршрутом до $room';
  }

  @override
  String get hideLessonTitle => 'Скрыть пару?';

  @override
  String hideLessonBody(String subject) {
    return '«$subject» исчезнет из расписания. Вернуть можно в фильтрах.';
  }

  @override
  String get hideLessonAllSubject => 'Скрывать все пары этого предмета';

  @override
  String get hideLessonAction => 'Скрыть';

  @override
  String get hideLessonDone => 'Пара скрыта из расписания';

  @override
  String get sessionScheduleTitle => 'Расписание сессии';

  @override
  String get sessionNoExams => 'Экзаменов и зачётов в расписании пока нет.';

  @override
  String get sessionNoExamsTitle => 'Экзаменов нет';

  @override
  String get sessionUntilFirstExam => 'До первого экзамена';

  @override
  String get sessionNoPlannedExams => 'нет запланированных экзаменов';

  @override
  String sessionHeroSubtitle(String subject, String date) {
    return 'дней · $subject · $date';
  }

  @override
  String get sessionExamsCredits => 'экз · зачёты';

  @override
  String get sessionReadinessLabel => 'готовность';

  @override
  String get sessionDaysTotal => 'дней всего';

  @override
  String get sessionDaysShort => 'дней';

  @override
  String get sessionReadiness => 'Готовность';

  @override
  String sessionStudyPlanText(String subject, int percent) {
    return 'Сегодня — $subject (2 ч). Готовность всего $percent%';
  }

  @override
  String get compareYou => 'Ты';

  @override
  String get compareMySchedule => 'Моё расписание';

  @override
  String get comparePick => 'Выбрать расписание';

  @override
  String get comparePickGroup => 'Выбери группу';

  @override
  String get compareFriend => 'друг';

  @override
  String get compareTapToPick => 'нажми, чтобы выбрать';

  @override
  String get compareEmptyHint =>
      'Добавь расписание друга — увидишь общие окна и пары, на которых вы вместе.';

  @override
  String get compareNoLessonsBoth => 'В этот день пар нет у вас обоих';

  @override
  String compareCommonWindow(String from, String to) {
    return 'Общее окно $from–$to — оба свободны. Кофе?';
  }

  @override
  String get compareBothFree => 'Оба свободны';

  @override
  String get compareFreeCell => 'свободно';

  @override
  String get compareTogether => 'вместе';

  @override
  String get comparePickerTitle => 'С кем сравнить?';

  @override
  String get comparePickerDescription => 'Найди группу друга';

  @override
  String get comparePickerHint => 'ИКБО-09-22…';

  @override
  String get compareLoadError => 'Не удалось загрузить расписание группы';

  @override
  String get changesPushBanner => 'Пуш при любом изменении в твоём расписании';

  @override
  String get changesEmptyTitle => 'Изменений пока нет';

  @override
  String get changesEmptySubtitle =>
      'Когда пары перенесут, отменят или поменяют аудиторию — всё появится здесь.';

  @override
  String changeMovedTitle(String subject) {
    return '$subject перенесена';
  }

  @override
  String changeMovedDescription(String from, String to) {
    return 'было $from → стало $to';
  }

  @override
  String changeCancelledTitle(String subject) {
    return '$subject отменена';
  }

  @override
  String changeCancelledDescription(String time) {
    return 'пара в $time не состоится';
  }

  @override
  String changeAddedTitle(String subject) {
    return 'Добавлена пара: $subject';
  }

  @override
  String get changeTeacherTitle => 'Замена преподавателя';

  @override
  String get changeRoomTitle => 'Смена аудитории';

  @override
  String get analyticsHoursPerWeek => 'часов/нед';

  @override
  String get analyticsAvgPerDay => 'ср. пар/день';

  @override
  String get analyticsLoadByDay => 'Нагрузка по дням';

  @override
  String analyticsOverloadedDay(String day, String hours) {
    return '$day перегружен — $hours часов';
  }

  @override
  String get analyticsBalancedWeek => 'Неделя сбалансирована';

  @override
  String get analyticsByType => 'По типу занятий';

  @override
  String analyticsInsightLightTitle(String day) {
    return 'Лучшее утро — $day';
  }

  @override
  String analyticsInsightLightSub(String hours) {
    return 'всего $hours ч пар, можно выспаться';
  }

  @override
  String analyticsInsightWindowsTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count окна за неделю',
      many: '$count окон за неделю',
      few: '$count окна за неделю',
      one: '$count окно за неделю',
    );
    return '$_temp0';
  }

  @override
  String analyticsInsightWindowsSub(String hours) {
    return 'итого $hours ч между парами';
  }

  @override
  String get analyticsNoSchedule =>
      'Выбери расписание, чтобы увидеть аналитику.';

  @override
  String analyticsShareText(String hours, String avg) {
    return 'Моя неделя: $hours часов пар, в среднем $avg пар в день';
  }

  @override
  String get createScheduleTitle => 'Создать расписание';

  @override
  String get createScheduleHeadline => 'Как заполним расписание?';

  @override
  String get createScheduleSubtitle =>
      'Выбери удобный способ — потом всё можно поправить';

  @override
  String get createWayGroupTitle => 'Найти свою группу';

  @override
  String get createWayGroupDescription => 'Подтянем расписание автоматически';

  @override
  String get createWayFastBadge => 'быстро';

  @override
  String get createWaySearchTitle => 'Преподаватель или аудитория';

  @override
  String get createWaySearchDescription => 'Любое расписание по названию';

  @override
  String get createWayScanTitle => 'Сканировать фото расписания';

  @override
  String get createWayScanDescription => 'Распознаем таблицу с парами по фото';

  @override
  String get createWayScanSoon => 'Скан расписания скоро появится';

  @override
  String get createWayManualTitle => 'Заполнить вручную';

  @override
  String get createWayManualDescription => 'Добавлять пары по одной';

  @override
  String get createWayCopyTitle => 'Скопировать у одногруппника';

  @override
  String get createWayCopyDescription => 'По ссылке-приглашению';

  @override
  String get createWayCopySoon => 'Ссылки-приглашения скоро появятся';

  @override
  String get openMySchedules => 'Открыть мои расписания';

  @override
  String get openMySchedulesSubtitle => 'Созданные вручную расписания';

  @override
  String get editScheduleSwipeHint =>
      'Перетащи для сортировки · смахни для удаления';

  @override
  String get editScheduleEmptyDay => 'На этот день пар нет — добавь первую';

  @override
  String get editScheduleNotFound => 'Расписание не найдено';

  @override
  String homeGreeting(String name) {
    return 'Привет, $name';
  }

  @override
  String get homeNinja => 'ниндзя';

  @override
  String get homeStudent => 'Студент';

  @override
  String get homePass => 'Пропуск';

  @override
  String get homeOngoingNow => 'ИДЁТ СЕЙЧАС';

  @override
  String homeUntil(String time) {
    return 'до $time';
  }

  @override
  String get homeNextLabel => 'СЛЕД.';

  @override
  String homeInMinutes(int minutes) {
    return 'через $minutes мин';
  }

  @override
  String get homeShurikens => 'Сюрикены';

  @override
  String get homeStreak => 'Стрик';

  @override
  String homeDaysShort(int days) {
    return '$days дн';
  }

  @override
  String homeHoursShort(int hours) {
    return '$hours ч';
  }

  @override
  String get homeRoomsFree => 'свободные';

  @override
  String get homeKnowledgeBank => 'Банк знаний';

  @override
  String get homeBalance => 'Баланс';

  @override
  String get homeOpen => 'открыть';

  @override
  String get homeGrades => 'Оценки';

  @override
  String get homeDeadlines => 'Дедлайны';

  @override
  String homeBurningCount(int count) {
    return '$count горит';
  }

  @override
  String homeActiveShort(int count) {
    return '$count актив.';
  }

  @override
  String get homePeople => 'Люди';

  @override
  String get homeCreateArrow => 'Создать →';

  @override
  String homeAllArrow(int count) {
    return 'Все $count →';
  }

  @override
  String homeNearDontMiss(int count) {
    return '$count близких · не прогадай';
  }

  @override
  String get homeNoDeadlines => 'Дедлайнов нет — можно выдохнуть';

  @override
  String get homeScheduleArrow => 'Расписание →';

  @override
  String homeClassesLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'осталось $count пары',
      many: 'осталось $count пар',
      few: 'осталось $count пары',
      one: 'осталась $count пара',
    );
    return '$_temp0';
  }

  @override
  String get homeNoMoreToday => 'Сегодня пар больше нет';

  @override
  String get homeTrending => 'Обсуждаемое';

  @override
  String get homeFeedArrow => 'Лента →';

  @override
  String get homeAllClassesDone => 'Пары на сегодня всё';

  @override
  String get homeOpenWeek => 'открыть расписание недели';

  @override
  String get homeOverdue => 'просрочен';

  @override
  String get homeNextTag => 'Следующая';

  @override
  String get homeCreditTag => 'Зачёт';

  @override
  String homeDueToday(String time) {
    return 'сегодня $time';
  }

  @override
  String homeDueTomorrow(String time) {
    return 'завтра $time';
  }

  @override
  String scheduleUpdatedChanges(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Расписание обновлено: $count изменений',
      many: 'Расписание обновлено: $count изменений',
      few: 'Расписание обновлено: $count изменения',
      one: 'Расписание обновлено: $count изменение',
    );
    return '$_temp0';
  }

  @override
  String get scheduleActionFailed => 'Не получилось — время уже прошло?';

  @override
  String get lessonEditorCreateTitle => 'Новая пара';

  @override
  String get lessonEditorEditTitle => 'Редактирование пары';

  @override
  String get lessonEditorStepBasic => 'Основное';

  @override
  String get lessonEditorStepDates => 'Даты';

  @override
  String get lessonEditorStepLocation => 'Место';

  @override
  String get lessonEditorStepPreview => 'Превью';

  @override
  String get lessonEditorSubjectName => 'Название предмета';

  @override
  String get lessonEditorSubjectHint => 'Введите название предмета';

  @override
  String get lessonEditorSubjectLabel => 'Предмет';

  @override
  String get lessonEditorTypeLabel => 'Тип занятия';

  @override
  String get lessonEditorTimeLabel => 'Время';

  @override
  String get lessonEditorRoomLabel => 'Аудитория';

  @override
  String get lessonEditorTeacherLabel => 'Преподаватель';

  @override
  String get lessonEditorDatesLabel => 'Даты';

  @override
  String get lessonEditorNotSet => 'Не выбрано';

  @override
  String lessonEditorDatesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count даты',
      many: '$count дат',
      few: '$count даты',
      one: '$count дата',
    );
    return '$_temp0';
  }

  @override
  String get lessonEditorColorLabel => 'Цвет';

  @override
  String get lessonEditorRepeatLabel => 'Повтор';

  @override
  String get lessonEditorRepeatEvery => 'Каждую неделю';

  @override
  String get lessonEditorRepeatEven => 'Каждую чётную неделю';

  @override
  String get lessonEditorRepeatOdd => 'Каждую нечётную неделю';

  @override
  String get lessonEditorRepeatEveryShort => 'Каждую';

  @override
  String get lessonEditorRepeatEvenShort => 'Чётная';

  @override
  String get lessonEditorRepeatOddShort => 'Нечётная';

  @override
  String get lessonEditorRepeatManual => 'Настроить даты вручную';

  @override
  String get lessonEditorReminderTitle => 'Напоминание';

  @override
  String lessonEditorReminderLead(int minutes) {
    return 'за $minutes мин';
  }

  @override
  String get customScheduleDefaultName => 'Моё расписание';

  @override
  String get pickerTimeTitle => 'Время';

  @override
  String get pickerTimeRangeTitle => 'Время пары';

  @override
  String get pickerStart => 'Начало';

  @override
  String get pickerEnd => 'Конец';

  @override
  String get pickerDateTitle => 'Дата';

  @override
  String get pickerDatesTitle => 'Даты';

  @override
  String get pickerToday => 'Сегодня';

  @override
  String get pickerTomorrow => 'Завтра';

  @override
  String get pickerNextWeek => 'Через неделю';

  @override
  String pickerSelectedCount(int count) {
    return 'Выбрано: $count';
  }

  @override
  String get pickerClear => 'Очистить';

  @override
  String get pickerSearchHint => 'Поиск или ввод вручную';

  @override
  String pickerAddManually(String query) {
    return 'Добавить «$query»';
  }

  @override
  String get pickerNothingFound => 'Ничего не найдено';

  @override
  String get lessonEditorClassroomSearchHint => 'Например: А-220';

  @override
  String get lessonEditorTeacherSearchHint => 'Например: Иванов И. И.';

  @override
  String get lessonTypeLectureName => 'Лекция';

  @override
  String get lessonTypeSeminarName => 'Семинар';

  @override
  String get lessonTypeLabName => 'Лаба';

  @override
  String get lessonTypeCreditName => 'Зачёт';

  @override
  String get lessonTypeExamName => 'Экзамен';

  @override
  String get lessonEditorEndAfterStart =>
      'Время окончания должно быть позже времени начала';

  @override
  String get lessonEditorRepeat => 'Повторение';

  @override
  String get lessonEditorRepeatSoon =>
      'Функция настройки повторений будет доступна в будущих версиях.';

  @override
  String get lessonEditorSelectDateError =>
      'Выберите хотя бы одну дату проведения';

  @override
  String get lessonEditorClassroomError =>
      'Добавьте хотя бы одну аудиторию или сделайте занятие онлайн';

  @override
  String get lessonEditorAddClassroom => 'Добавить аудиторию';

  @override
  String get lessonEditorClassroomNumber => 'Номер аудитории';

  @override
  String get lessonEditorClassroomHint => 'Например: А-123';

  @override
  String get lessonEditorClassroomNumberError => 'Введите номер аудитории';

  @override
  String get lessonEditorCampusName => 'Название кампуса (опционально)';

  @override
  String get lessonEditorCampusHint => 'Например: В-78';

  @override
  String get lessonEditorAddGroup => 'Добавить группу';

  @override
  String get lessonEditorGroupName => 'Название группы';

  @override
  String get lessonEditorGroupHint => 'Например: ИКБО-01-21';

  @override
  String get lessonEditorGroupError => 'Введите название группы';

  @override
  String get lessonEditorAddTeacher => 'Добавить преподавателя';

  @override
  String get lessonEditorTeacherName => 'ФИО преподавателя';

  @override
  String get lessonEditorTeacherHint => 'Например: Иванов Иван Иванович';

  @override
  String get lessonEditorTeacherError => 'Введите ФИО преподавателя';

  @override
  String get customSchedulesCreateTitle => 'Создание расписания';

  @override
  String get customSchedulesCreateDesc =>
      'Введите название и описание для нового расписания';

  @override
  String get customSchedulesEditTitle => 'Редактирование расписания';

  @override
  String get customSchedulesEditDesc =>
      'Измените название или описание расписания';

  @override
  String get customSchedulesLessonsTitle => 'Список пар';

  @override
  String customSchedulesLessonsDesc(String name) {
    return 'Управление парами в расписании «$name»';
  }

  @override
  String get customSchedulesEmptyTitle => 'У вас пока нет своих расписаний';

  @override
  String get customSchedulesEmptyDesc =>
      'Создайте собственное расписание, добавляя в него пары из разных доступных расписаний';

  @override
  String get customSchedulesCreate => 'Создать расписание';

  @override
  String get customSchedulesCreateSubtitle => 'Новое пустое расписание';

  @override
  String get customSchedulesSearchTitle => 'Поиск расписания';

  @override
  String get customSchedulesSearchSubtitle => 'Поиск расписания по названию';

  @override
  String customSchedulesMyCount(int count) {
    return 'Мои расписания ($count)';
  }

  @override
  String customSchedulesLessonsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count пары',
      many: '$count пар',
      few: '$count пары',
      one: '$count пара',
    );
    return '$_temp0';
  }

  @override
  String customSchedulesUpdated(String time) {
    return 'Обновлено $time';
  }

  @override
  String get customSchedulesEmpty => 'Пустое расписание';

  @override
  String get customSchedulesUnknown => 'Неизвестно';

  @override
  String customSchedulesDaysAgo(int days) {
    return '$days дн. назад';
  }

  @override
  String customSchedulesHoursAgo(int hours) {
    return '$hours ч. назад';
  }

  @override
  String customSchedulesMinutesAgo(int minutes) {
    return '$minutes мин. назад';
  }

  @override
  String get customSchedulesJustNow => 'Только что';

  @override
  String get customSchedulesOpen => 'Открыть';

  @override
  String get customSchedulesRename => 'Переименовать';

  @override
  String get customSchedulesNameLabel => 'Название расписания';

  @override
  String get customSchedulesNameHint => 'Например: Моё расписание';

  @override
  String get customSchedulesNameRequired => 'Введите название';

  @override
  String get customSchedulesNameTooLong => 'Слишком длинное название';

  @override
  String get customSchedulesDescLabel => 'Описание (необязательно)';

  @override
  String get customSchedulesDescHint => 'Добавьте описание расписания';

  @override
  String get customSchedulesSaveChanges => 'Сохранить изменения';

  @override
  String get customSchedulesAddLesson => 'Создать новую пару';

  @override
  String get customSchedulesNoLessons => 'Нет добавленных пар';

  @override
  String get customSchedulesNoLessonsHint =>
      'Создайте первую пару для этого расписания';

  @override
  String customSchedulesClassroomLabel(String rooms) {
    return 'Аудитория: $rooms';
  }

  @override
  String get lessonDetailsRoomToClass => 'К аудитории';

  @override
  String get lessonDetailsMaterials => 'Материалы';

  @override
  String get lessonDetailsSignInReact => 'Войдите, чтобы оставить реакцию';

  @override
  String get lessonDetailsReviewTitle => 'Отзыв о паре';

  @override
  String get lessonDetailsNoteTitle => 'Заметка к паре';

  @override
  String get lessonDetailsRoomCoordsMissing =>
      'Координаты аудитории не найдены';

  @override
  String get lessonDetailsRecordingSoon =>
      'Запись пары появится после подключения';

  @override
  String get lessonDetailsAddToSchedule => 'Добавить в расписание';

  @override
  String get lessonDetailsLiveNow => 'Идёт сейчас';

  @override
  String get lessonDetailsEnded => 'Закончилась';

  @override
  String lessonDetailsPairNumber(String number) {
    return '$number пара';
  }

  @override
  String get lessonDetailsRoomNotSpecified => 'Аудитория не указана';

  @override
  String get lessonDetailsTypeNote => 'Конспект';

  @override
  String get lessonDetailsTypeBoard => 'Фото доски';

  @override
  String get lessonDetailsTypeTask => 'Задание';

  @override
  String get lessonDetailsTypeExtra => 'Доп. материал';

  @override
  String get lessonDetailsFile => 'файл';

  @override
  String get lessonDetailsJustNow => 'сейчас';

  @override
  String lessonDetailsMinutesShort(int minutes) {
    return '$minutes мин';
  }

  @override
  String lessonDetailsHoursShort(int hours) {
    return '$hours ч';
  }

  @override
  String get lessonDetailsYesterday => 'вчера';

  @override
  String get lessonDetailsStatusLive => 'ИДЁТ';

  @override
  String get lessonDetailsStatusPast => 'ПРОШЛА';

  @override
  String get lessonDetailsStatusSoon => 'СКОРО';

  @override
  String get lessonDetailsRecord => 'Запись';

  @override
  String get lessonDetailsNote => 'Заметка';

  @override
  String get lessonDetailsRoute => 'Маршрут';

  @override
  String get lessonDetailsTeacherFallback => 'Преподаватель';

  @override
  String get lessonDetailsTeacherProfile => 'профиль и отзывы';

  @override
  String lessonDetailsAllCount(int count) {
    return 'Все $count';
  }

  @override
  String get lessonDetailsPeersTitle => 'С тобой на паре';

  @override
  String lessonDetailsPeersFriends(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count друзей в группе',
      many: '$count друзей в группе',
      few: '$count друга в группе',
      one: '$count друг в группе',
      zero: 'Пока нет друзей в группе',
    );
    return '$_temp0';
  }

  @override
  String get lessonDetailsGroupsTitle => 'Группы потока';

  @override
  String lessonDetailsGroupsMore(int count) {
    return '+$count';
  }

  @override
  String lessonDetailsMaterialsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count материала',
      many: '$count материалов',
      few: '$count материала',
      one: '$count материал',
    );
    return '$_temp0';
  }

  @override
  String get lessonDetailsLoadFailed => 'Не удалось загрузить материалы';

  @override
  String get lessonDetailsTapRetry => 'Нажми, чтобы повторить';

  @override
  String get lessonDetailsNoMaterialsYet => 'Материалов пока нет';

  @override
  String get lessonDetailsUploadHint => 'Залей конспект или фото доски';

  @override
  String get lessonDetailsOpenFailed => 'Не удалось открыть материал';

  @override
  String get lessonDetailsMaterialToClass => 'Материал к паре';

  @override
  String get lessonDetailsUpload => 'Залить';

  @override
  String get lessonDetailsMaterialsPage => 'Материалы пары';

  @override
  String get lessonDetailsNewestFirst => 'сначала новые';

  @override
  String get lessonDetailsCheckConnection =>
      'Проверь соединение и попробуй ещё раз';

  @override
  String get lessonDetailsContributePre => 'Залей конспект или фото доски — ';

  @override
  String get lessonDetailsContributePost => ' и спасибо группы';

  @override
  String get lessonDetailsShurikensReward => '+30 сюрикенов';

  @override
  String get lessonDetailsEmptyMaterialsTitle => 'Здесь будут материалы пары';

  @override
  String get lessonDetailsEmptyMaterialsSub =>
      'Загрузи файл или фото доски первым';

  @override
  String lessonDetailsVotesAnon(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count голоса · можно анонимно',
      many: '$count голосов · можно анонимно',
      few: '$count голоса · можно анонимно',
      one: '$count голос · можно анонимно',
    );
    return '$_temp0';
  }

  @override
  String get lessonDetailsGroupReactions => 'Реакции группы';

  @override
  String get lessonDetailsLeaveReview => 'Оставить отзыв о паре';

  @override
  String get lessonDetailsSignInReview => 'Войдите, чтобы оставить отзыв';

  @override
  String get lessonDetailsReviewHint =>
      'Что полезного, сложного или важного было?';

  @override
  String get lessonDetailsAnonymous => 'Анонимно';

  @override
  String get lessonDetailsSaving => 'Сохраняем…';

  @override
  String get lessonDetailsSubmitReview => 'Оставить отзыв';

  @override
  String get lessonDetailsNoteHint => 'Заметка к паре';

  @override
  String get noteEditorTitle => 'Заметка';

  @override
  String get noteEditorDone => 'Готово';

  @override
  String noteEditorBound(String room) {
    return 'Привязано к паре · $room';
  }

  @override
  String get noteEditorPlaceholder => '…добавь мысли, фото доски или голосом';

  @override
  String get noteShareWithGroup => 'Поделиться с одногруппниками';

  @override
  String noteShareWithGroupSub(String group) {
    return 'появится в пространстве $group';
  }

  @override
  String get noteShareWithGroupGeneric => 'появится в пространстве группы';

  @override
  String get noteSavedIndicator => 'сохр.';

  @override
  String get noteSharedToGroup => 'Заметка в пространстве группы';

  @override
  String get lessonDetailsFileTooLarge => 'Файл больше 50 МБ';

  @override
  String get lessonDetailsPickFileFirst => 'Выбери файл или фото';

  @override
  String get lessonDetailsAddTitle => 'Добавь название материала';

  @override
  String get lessonDetailsSignInUpload =>
      'Войдите и попробуйте загрузить ещё раз';

  @override
  String get lessonDetailsCamera => 'Камера';

  @override
  String get lessonDetailsGallery => 'Галерея';

  @override
  String get lessonDetailsFiles => 'Файлы';

  @override
  String get lessonDetailsTypeHeader => 'ТИП';

  @override
  String get lessonDetailsTitleLabel => 'Название';

  @override
  String get lessonDetailsTitleHint => 'Конспект backprop';

  @override
  String get lessonDetailsPublicTitle => 'Доступно всей группе';

  @override
  String get lessonDetailsPublicSub => 'иначе — только тебе';

  @override
  String get lessonDetailsRewardPre => 'За материал начислим ';

  @override
  String get lessonDetailsUploading => 'Загружаем…';

  @override
  String get lessonDetailsUploadMaterial => 'Загрузить материал';

  @override
  String get lessonDetailsPickFileOrPhoto => 'Выбрать файл или фото';

  @override
  String get lessonDetailsDropHint => 'PDF, фото доски, ноутбук · до 50 МБ';

  @override
  String get teacherProfileReviewTitle => 'Отзыв о преподе';

  @override
  String get teacherProfileShare => 'Поделиться';

  @override
  String teacherProfileReviewsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count отзыва',
      many: '$count отзывов',
      few: '$count отзыва',
      one: '$count отзыв',
    );
    return '$_temp0';
  }

  @override
  String get teacherProfileNoReviewsInline => 'отзывов пока нет';

  @override
  String get teacherProfileClarity => 'Понятность';

  @override
  String get teacherProfileLoyalty => 'Лояльность';

  @override
  String get teacherProfileUsefulness => 'Польза';

  @override
  String get teacherProfileSubjects => 'Ведёт предметы';

  @override
  String get teacherProfileReviews => 'Отзывы';

  @override
  String get teacherProfileEmptyTitle => 'Отзывов пока нет';

  @override
  String get teacherProfileEmptySub =>
      'Оставь первый — поможешь другим студентам';

  @override
  String get teacherProfileLeaveReview => 'Оставить отзыв';

  @override
  String get teacherProfileReviewHint => 'Объясняет сложное простыми словами…';

  @override
  String get teacherProfileAnonymous => 'Анонимно';

  @override
  String get teacherProfileSaving => 'Сохраняем…';

  @override
  String get teacherProfilePublish => 'Опубликовать отзыв';

  @override
  String get feedTitle => 'Лента';

  @override
  String get feedLoadCategoriesError => 'Не удалось загрузить категории';

  @override
  String get feedLoadError => 'Не удалось загрузить ленту новостей';

  @override
  String get feedLoadMoreError => 'Не удалось загрузить больше новостей';

  @override
  String get feedEmptyTitle => 'Пока пусто';

  @override
  String get feedEmptyDescription =>
      'В этой ленте ещё нет публикаций. Загляните позже — новости появляются автоматически.';

  @override
  String get feedSourcesTitle => 'Каналы';

  @override
  String get navHome => 'Главная';

  @override
  String get navSchedule => 'Пары';

  @override
  String get navMap => 'Карта';

  @override
  String get navServices => 'Сервисы';

  @override
  String get navProfile => 'Профиль';

  @override
  String mapRoomTitle(String name) {
    return 'Аудитория $name';
  }

  @override
  String get authSignInTitle => 'Вход';

  @override
  String get authSignInSubtitle => 'Войдите, чтобы продолжить';

  @override
  String get authContinueWithEmail => 'Продолжить с почтой';

  @override
  String get authSignInFailed => 'Не удалось войти';

  @override
  String get authEmailHeaderTitle => 'Войдите, чтобы продолжить';

  @override
  String get authYourEmail => 'Ваш email';

  @override
  String get authInvalidEmail => 'Недопустимый адрес электронной почты';

  @override
  String get authNext => 'Далее';

  @override
  String authUniversityEmailHint(String domains) {
    return 'Используйте университетский адрес одного из доменов: $domains';
  }

  @override
  String get authEmailLinkFailed => 'Не удалось отправить ссылку для входа';

  @override
  String get authSignUpTitle => 'Создать аккаунт';

  @override
  String authSignUpSubtitle(String domains) {
    return 'Зарегистрируйтесь с университетским адресом: $domains';
  }

  @override
  String get authSignUpButton => 'Зарегистрироваться';

  @override
  String get authSignUpFailed =>
      'Не удалось зарегистрироваться. Попробуйте ещё раз.';

  @override
  String authEmailDomainError(String domains) {
    return 'Используйте адрес одного из доменов: $domains';
  }

  @override
  String authPasswordMinLength(int count) {
    return 'Минимум $count символов';
  }

  @override
  String get authPasswordsDontMatch => 'Пароли не совпадают';

  @override
  String get authPasswordResetTitle => 'Сброс пароля';

  @override
  String get authPasswordResetSubtitle =>
      'Введите email — мы отправим ссылку для восстановления доступа.';

  @override
  String get authPasswordResetButton => 'Отправить ссылку';

  @override
  String get authPasswordResetSent =>
      'Письмо для сброса пароля отправлено. Проверьте почту.';

  @override
  String get authPasswordResetFailed =>
      'Не удалось отправить письмо. Попробуйте ещё раз.';

  @override
  String get authCheckEmailTitle => 'Проверьте почту';

  @override
  String authCheckEmailSubtitle(String email) {
    return 'Мы отправили 6-значный код на $email. Введите его ниже, чтобы подтвердить почту.';
  }

  @override
  String get authCodeFromEmail => 'Код из письма';

  @override
  String get authCheckingCode => 'Проверяем код…';

  @override
  String get authInvalidCode =>
      'Неверный или просроченный код. Проверьте и попробуйте ещё раз.';

  @override
  String get authInvalidCredentials => 'Неверный email или пароль.';

  @override
  String get authGuestUnavailable =>
      'Не удалось войти как гость. Попробуйте позже.';

  @override
  String get settingsAmoledTitle => 'AMOLED';

  @override
  String get settingsAmoledSubtitle =>
      'Чисто чёрный фон тёмной темы для OLED-экранов';

  @override
  String get scheduleDiffTitle => 'Обновления расписания';

  @override
  String scheduleDiffFoundChanges(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Найдено $count изменений в вашем расписании',
      few: 'Найдено $count изменения в вашем расписании',
      one: 'Найдено $count изменение в вашем расписании',
    );
    return '$_temp0';
  }

  @override
  String get scheduleDiffNewLessons => 'Новые занятия';

  @override
  String scheduleDiffAddedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Добавлено $count занятий',
      few: 'Добавлено $count занятия',
      one: 'Добавлено $count занятие',
    );
    return '$_temp0';
  }

  @override
  String get scheduleDiffChanges => 'Изменения';

  @override
  String scheduleDiffModifiedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Изменено $count занятий',
      few: 'Изменено $count занятия',
      one: 'Изменено $count занятие',
    );
    return '$_temp0';
  }

  @override
  String get scheduleDiffRemovedLessons => 'Удалённые занятия';

  @override
  String scheduleDiffRemovedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Удалено $count занятий',
      few: 'Удалено $count занятия',
      one: 'Удалено $count занятие',
    );
    return '$_temp0';
  }

  @override
  String get scheduleDiffNewLabel => 'Новые';

  @override
  String get scheduleDiffModifiedLabel => 'Изменены';

  @override
  String get scheduleDiffRemovedLabel => 'Удалены';

  @override
  String get scheduleDiffKindNew => 'НОВОЕ';

  @override
  String get scheduleDiffKindModified => 'ИЗМЕНЕНО';

  @override
  String get scheduleDiffKindRemoved => 'УДАЛЕНО';

  @override
  String get scheduleDiffFieldLessonType => 'Тип занятия';

  @override
  String get scheduleDiffFieldTime => 'Время';

  @override
  String get scheduleDiffFieldNumber => 'Номер пары';

  @override
  String get scheduleDiffFieldTeachers => 'Преподаватели';

  @override
  String get scheduleDiffFieldClassrooms => 'Аудитории';

  @override
  String get scheduleDiffFieldDates => 'Даты';

  @override
  String get scheduleDiffFieldGroups => 'Группы';

  @override
  String get aboutAppDescription =>
      'Это приложение и все относящиеся к нему сервисы являются 100% бесплатными и Open Source продуктами. Мы с огромным удовольствием примем любые ваши предложения и сообщения, а также мы рады любому вашему участию в проекте!';

  @override
  String get aboutAppContributors => 'Участники проекта';

  @override
  String get communityCategoryGeneral => 'Общие';

  @override
  String get communityCategoryInstitutes => 'Институты';

  @override
  String get communityCategorySports => 'Спорт';

  @override
  String get communityCategoryCreative => 'Творчество';

  @override
  String get communityCategoryCompetitive =>
      'Соревновательное программирование';

  @override
  String get communityCategoryScience => 'Наука';

  @override
  String get communityCategoryVolunteering => 'Волонтёрство';

  @override
  String get communityCategoryEntertainment => 'Развлечения';

  @override
  String get communitiesTitle => 'Сообщества';

  @override
  String get communitiesSubtitle => 'каталог чатов и каналов МИРЭА';

  @override
  String get communitiesSearchHint => 'Поиск сообществ...';

  @override
  String get communitiesSearchHintInline => 'Найти канал или чат…';

  @override
  String get communitiesAll => 'Все';

  @override
  String get communitiesGroupStudy => 'Учёба';

  @override
  String get communitiesGroupInterests => 'Интересы';

  @override
  String get communitiesGroupLife => 'Жизнь';

  @override
  String get communitiesSectionStudy => 'Учебные';

  @override
  String get communitiesSectionInterests => 'По интересам';

  @override
  String get communitiesSectionLife => 'Жизнь';

  @override
  String get communitiesSuggestTitle => 'Знаешь крутой чат?';

  @override
  String get communitiesSuggestSubtitle => 'Добавь в каталог';

  @override
  String get communitiesNotFound => 'Сообщества не найдены';

  @override
  String get communitiesTryFilters => 'Попробуйте изменить фильтры';

  @override
  String get communitiesFavorites => 'Избранные';

  @override
  String communitiesMembersCount(String count) {
    return '$count участников';
  }

  @override
  String friendsMeters(int meters) {
    return '$meters м';
  }

  @override
  String friendsKm(String km) {
    return '$km км';
  }

  @override
  String get friendsJustNow => 'сейчас';

  @override
  String friendsMinutesShort(int minutes) {
    return '$minutes мин';
  }

  @override
  String friendsHoursShort(int hours) {
    return '$hours ч';
  }

  @override
  String friendsDaysShort(int days) {
    return '$days дн';
  }

  @override
  String get friendsGhostMode => 'Режим призрака';

  @override
  String get friendsGhostModeOff => 'Выключить режим призрака';

  @override
  String friendsOnMapLive(int count) {
    return '$count на карте · live';
  }

  @override
  String get friendsRequests => 'Заявки в друзья';

  @override
  String get friendsAddFriend => 'Добавить друга';

  @override
  String get friendsAddTitle => 'Добавить друзей';

  @override
  String get friendsClose => 'Закрыть';

  @override
  String get friendsGeoDenied =>
      'Нет доступа к геопозиции — друзья тебя не видят. Включи в настройках.';

  @override
  String get friendsMyLocation => 'Моя позиция';

  @override
  String get friendsGeoSharing => 'Шеринг геопозиции';

  @override
  String get friendsTitle => 'Друзья';

  @override
  String get friendsAddShort => '+ Добавить';

  @override
  String get friendsEmptyTitle => 'Пока никого';

  @override
  String get friendsEmptySub =>
      'Добавь друзей — увидишь их на карте в реальном времени';

  @override
  String get friendsStatusHidden => 'скрылся';

  @override
  String get friendsStatusLive => 'на карте · live';

  @override
  String get friendsStatusRecent => 'был(а) недавно';

  @override
  String get friendsStatusGeoOff => 'гео выключено';

  @override
  String get friendsWriteTelegram => 'Написать в Telegram';

  @override
  String get friendsRemove => 'Удалить из друзей';

  @override
  String get friendsShareGeo => 'Делиться геопозицией';

  @override
  String get friendsShareGeoSub =>
      'обновляется, пока открыт экран карты друзей';

  @override
  String get friendsPrivacySyncError =>
      'Сервер не подтвердил настройки приватности. Геопубликация на устройстве остановлена — повтори синхронизацию.';

  @override
  String get friendsGhostSub => 'временно скрыться от всех';

  @override
  String get friendsWhoSeesExact => 'КТО ВИДИТ МОЮ ТОЧНУЮ ГЕО';

  @override
  String get friendsVisAll => 'Все друзья';

  @override
  String get friendsVisClose => 'Только близкие';

  @override
  String get friendsVisCloseSub => 'остальные видят корпус';

  @override
  String get friendsVisNone => 'Никто';

  @override
  String get friendsVisNoneSub => 'тебя нет на карте';

  @override
  String get friendsPrecisionHeader => 'ТОЧНОСТЬ ДЛЯ ОСТАЛЬНЫХ';

  @override
  String get friendsPrecisionExact => 'Точно';

  @override
  String get friendsPrecisionCampus => 'Корпус';

  @override
  String get friendsPrecisionCity => 'Город';

  @override
  String get friendsAutoOffHeader => 'АВТОМАТИЧЕСКИ ВЫКЛЮЧАТЬ';

  @override
  String get friendsAutoOffCampus => 'Когда ухожу с кампуса';

  @override
  String get friendsAutoOffNight => 'Ночью · 22:00–08:00';

  @override
  String get friendsAutoOffNever => 'Не выключать';

  @override
  String get friendsSearchHint => 'Имя, @ник или группа';

  @override
  String get friendsMyQr => 'Мой QR-код';

  @override
  String get friendsMyQrSub => 'покажи, чтобы добавили';

  @override
  String get friendsMyQrHint =>
      'Покажи этот код другу — он наведёт камеру и добавит тебя';

  @override
  String get friendsShareLink => 'Поделиться ссылкой';

  @override
  String get friendsNoneFound => 'Никого не нашли';

  @override
  String get friendsNoneFoundSub => 'Попробуй другое имя или группу';

  @override
  String get friendsFromGroup => 'ИЗ ТВОЕЙ ГРУППЫ';

  @override
  String get friendsYourGroup => 'твоя группа';

  @override
  String friendsAddWholeGroup(int count) {
    return 'Добавить всю группу · $count чел.';
  }

  @override
  String get friendsInFriends => 'в друзьях';

  @override
  String get friendsRequestSent => 'заявка отправлена';

  @override
  String get friendsAddBare => 'Добавить';

  @override
  String get friendsScan => 'Сканировать';

  @override
  String get friendsScanSub => 'QR друга рядом';

  @override
  String get friendsScanTitle => 'Сканировать QR-код';

  @override
  String get friendsScanInstruction => 'Наведи камеру на QR-код друга';

  @override
  String get friendsScanInvalid => 'Это не код друга Mirea Ninja';

  @override
  String get friendsScanCameraError =>
      'Не удалось открыть камеру. Проверь доступ в настройках.';

  @override
  String friendsFromGroupNamed(String group) {
    return 'Из твоей группы $group';
  }

  @override
  String get friendsNotYetFriends => 'ещё не в друзьях';

  @override
  String get friendsMayKnow => 'Возможно, вы знакомы';

  @override
  String friendsMutual(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count общих друзей',
      few: '$count общих друга',
      one: '1 общий друг',
    );
    return '$_temp0';
  }

  @override
  String get friendsInviteTelegram => 'Позвать из Telegram';

  @override
  String get friendsInviteTelegramSub => 'отправь ссылку-приглашение';

  @override
  String get friendsNoRequests => 'Заявок нет';

  @override
  String get friendsNoRequestsSub =>
      'Когда кто-то добавит тебя — появится здесь';

  @override
  String get friendsAccept => 'Принять';

  @override
  String get friendsDecline => 'Отклонить';

  @override
  String get friendsYou => 'Ты';

  @override
  String get lostFoundCatTech => 'Техника';

  @override
  String get lostFoundCatDocs => 'Документы';

  @override
  String get lostFoundCatKeys => 'Ключи';

  @override
  String get lostFoundCatCloth => 'Одежда';

  @override
  String get lostFoundCatOther => 'Другое';

  @override
  String get lostFoundJustNow => 'только что';

  @override
  String lostFoundMinutesAgo(int minutes) {
    return '$minutes мин назад';
  }

  @override
  String lostFoundHoursAgo(int hours) {
    return '$hours ч назад';
  }

  @override
  String lostFoundDaysAgo(int days) {
    return '$days д назад';
  }

  @override
  String lostFoundFoundBy(String name) {
    return 'нашёл·ла $name';
  }

  @override
  String lostFoundLostBy(String name) {
    return 'потерял·а $name';
  }

  @override
  String get lostFoundTagFound => 'нашли';

  @override
  String get lostFoundTagSearching => 'ищут';

  @override
  String get lostFoundBusy => 'Секунду…';

  @override
  String get lostFoundFoundOwner => 'Хозяин нашёлся — в «Потеряли»';

  @override
  String get lostFoundFoundItem => 'Вещь нашлась — в «Нашли»';

  @override
  String get lostFoundDelete => 'Удалить объявление';

  @override
  String lostFoundCall(String phone) {
    return 'Позвонить $phone';
  }

  @override
  String get lostFoundContactUnavailable =>
      'Автор не разрешил показывать контакты';

  @override
  String get lostFoundContactConsent =>
      'Показать мои контакты студентам моего университета';

  @override
  String get lostFoundPhoneHint => 'Телефон (необязательно)';

  @override
  String get lostFoundDeleteConfirmTitle => 'Удалить объявление?';

  @override
  String get lostFoundDeleteConfirmBody =>
      'Объявление и его фотографии будут удалены безвозвратно.';

  @override
  String get lostFoundCleanupWarning =>
      'Объявление удалено, но некоторые фотографии пока не удалось очистить';

  @override
  String get lostFoundContactOpenError => 'Не удалось открыть контакт';

  @override
  String get lostFoundImageError =>
      'Добавьте до 5 изображений JPEG, PNG или WebP размером до 8 МБ';

  @override
  String get lostFoundContact => 'Связаться';

  @override
  String get lostFoundReportTitle => 'Сообщить о вещи';

  @override
  String get lostFoundReportSub =>
      'объявление увидят студенты вашего университета';

  @override
  String get lostFoundReport => 'Сообщить';

  @override
  String get lostFoundTitle => 'Бюро находок';

  @override
  String lostFoundItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count объявления',
      many: '$count объявлений',
      few: '$count объявления',
      one: '$count объявление',
    );
    return '$_temp0';
  }

  @override
  String get lostFoundSearch => 'Поиск';

  @override
  String get lostFoundSearchHint => 'Что ищем?…';

  @override
  String lostFoundTabFound(int count) {
    return 'Нашли · $count';
  }

  @override
  String lostFoundTabLost(int count) {
    return 'Потеряли · $count';
  }

  @override
  String get lostFoundLoadError => 'Не удалось загрузить объявления';

  @override
  String get lostFoundLoadErrorSub => 'Потяни вниз, чтобы попробовать ещё раз';

  @override
  String get lostFoundEmptyFound => 'Находок пока нет';

  @override
  String get lostFoundEmptyLost => 'Потерь пока нет';

  @override
  String get lostFoundEmptySub =>
      'Нашёл или потерял вещь? Сообщи — поможем найти хозяина';

  @override
  String get lostFoundStatusFoundMe => 'Нашёл';

  @override
  String get lostFoundStatusLostMe => 'Потерял';

  @override
  String get lostFoundTitleHint => 'Что за вещь? Например, «AirPods Pro»';

  @override
  String get lostFoundLocationHint => 'Где? Например, «Г-407, под партой»';

  @override
  String get lostFoundDetailsHint => 'Детали: приметы, когда, обстоятельства…';

  @override
  String get lostFoundTelegramHint => 'Telegram для связи, например @ninja';

  @override
  String get lostFoundPhotosLabel => 'Фото';

  @override
  String get lostFoundPublishing => 'Публикуем…';

  @override
  String get lostFoundPublish => 'Опубликовать';

  @override
  String get lostFoundPublishError =>
      'Не удалось опубликовать. Попробуйте ещё раз';

  @override
  String get lostFoundActionError =>
      'Не удалось выполнить действие. Попробуйте ещё раз';

  @override
  String get servicesConfigure => 'Настроить';

  @override
  String get servicesEditDone => 'Готово';

  @override
  String get servicesConfigureHint =>
      'Нажмите на сервис, чтобы закрепить. Зажмите и перетащите, чтобы переместить.';

  @override
  String get servicesMoveEarlier => 'Переместить раньше';

  @override
  String get servicesMoveLater => 'Переместить позже';

  @override
  String get servicesSearchHint => 'Найти сервис или ссылку';

  @override
  String get servicesSectionPinned => 'Закреплённые';

  @override
  String get servicesPinnedEmptyHint =>
      'Включите «Настроить» и нажмите на сервис, чтобы закрепить';

  @override
  String get servicesSectionAll => 'Все сервисы';

  @override
  String get servicesNowTitle => 'Сейчас актуально';

  @override
  String get servicesNowSessionToday => 'Сегодня экзамен — ни пуха!';

  @override
  String servicesNowSessionInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Сессия через $count дней',
      few: 'Сессия через $count дня',
      one: 'Сессия через $count день',
    );
    return '$_temp0';
  }

  @override
  String servicesNowShurikens(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count сюрикенов',
      few: '$count сюрикена',
      one: '$count сюрикен',
    );
    return '$_temp0';
  }

  @override
  String get servicesBuildLabel => 'Свой mini-app';

  @override
  String get servicesBuildTitle => 'Сделай сервис и поделись с универом';

  @override
  String get servicesBuildSubtitle =>
      'SDK на TypeScript · 5 минут до первого деплоя';

  @override
  String get servicesTabMain => 'Главная';

  @override
  String get servicesTabDigital => 'Цифровой университет';

  @override
  String get servicesSectionImportant => 'Важные';

  @override
  String get servicesSectionCommunity => 'Сообщество';

  @override
  String get servicesSectionMain => 'Основные сервисы';

  @override
  String get servicesSectionStudentLife => 'Студенческая жизнь';

  @override
  String get servicesSectionUseful => 'Полезное';

  @override
  String get servicesFriendsMap => 'Друзья на карте';

  @override
  String get servicesWallet => 'Кошелёк';

  @override
  String get servicesKnowledgeBank => 'Банк знаний';

  @override
  String get servicesEvents => 'Афиша';

  @override
  String get servicesTeamFinder => 'Поиск команды';

  @override
  String get servicesMentorship => 'Менторство';

  @override
  String get servicesMarketplace => 'Барахолка';

  @override
  String get servicesNotes => 'Конспекты';

  @override
  String get servicesMap => 'Карта';

  @override
  String get deadlinesTitle => 'Дедлайны';

  @override
  String get deadlinesFabLabel => 'Дедлайн';

  @override
  String get deadlinesCalendarTooltip => 'Календарь';

  @override
  String get createDeadlineTitle => 'Создать дедлайн';

  @override
  String get createDeadlineButton => 'Создать дедлайн';

  @override
  String deadlinesOnFire(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count горит',
      many: '$count горит',
      few: '$count горит',
      one: '$count горит',
    );
    return '$_temp0';
  }

  @override
  String deadlinesActive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count активных',
      many: '$count активных',
      few: '$count активных',
      one: '$count активный',
    );
    return '$_temp0';
  }

  @override
  String get deadlinesFilterAll => 'Все';

  @override
  String get deadlinesFilterHot => 'Горит';

  @override
  String get deadlinesFilterMine => 'Личные';

  @override
  String get deadlinesFilterGroup => 'От группы';

  @override
  String get deadlinesFilterDone => 'Сделано';

  @override
  String get deadlinesGroupWeek => 'На этой неделе';

  @override
  String get deadlinesGroupLater => 'Позже';

  @override
  String get deadlinesEmptyTitle => 'Дедлайнов нет';

  @override
  String get deadlinesEmptySubtitle =>
      'Добавь первый — и держи прогресс под контролем';

  @override
  String get deadlineToday => 'сегодня';

  @override
  String get deadlineTomorrow => 'завтра';

  @override
  String get deadlineOverdue => 'просрочен';

  @override
  String deadlineLeftHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ч',
      many: '$count ч',
      few: '$count ч',
      one: '$count ч',
    );
    return '$_temp0';
  }

  @override
  String deadlineLeftDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дн',
      many: '$count дн',
      few: '$count дн',
      one: '$count дн',
    );
    return '$_temp0';
  }

  @override
  String deadlineLeftWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count нед',
      many: '$count нед',
      few: '$count нед',
      one: '$count нед',
    );
    return '$_temp0';
  }

  @override
  String get deadlineDone => 'сдано';

  @override
  String get deadlineSourceMine => 'личный';

  @override
  String get deadlineSourceGroup => 'от группы';

  @override
  String get deadlineSourceProf => 'от препода';

  @override
  String get deadlineTitleHint => 'Что сделать?';

  @override
  String get deadlineSubjectHint => 'Предмет (необязательно)';

  @override
  String get deadlineDateLabel => 'Дата';

  @override
  String get deadlineTimeLabel => 'Время';

  @override
  String get deadlineQuickToday => 'Сегодня';

  @override
  String get deadlineQuickTomorrow => 'Завтра';

  @override
  String get deadlineQuickWeek => 'Через неделю';

  @override
  String get deadlineQuickSession => 'К сессии';

  @override
  String get deadlinePriorityLabel => 'ПРИОРИТЕТ';

  @override
  String get deadlinePriorityLow => 'Низкий';

  @override
  String get deadlinePriorityMedium => 'Средний';

  @override
  String get deadlinePriorityUrgent => 'Срочно';

  @override
  String get deadlineRemindTitle => 'Напомнить заранее';

  @override
  String get deadlineRemindSubtitle => 'за день и за 2 часа';

  @override
  String get deadlineShareTitle => 'Поделиться с группой';

  @override
  String get deadlineShareSubtitle => 'увидят все одногруппники';

  @override
  String get deadlineSaving => 'Сохраняем…';

  @override
  String get deadlinesLoadError => 'Не удалось загрузить дедлайны';

  @override
  String get deadlinesLoadErrorSubtitle =>
      'Проверь соединение и попробуй снова';

  @override
  String get deadlinesCreateError =>
      'Не удалось создать дедлайн. Попробуй ещё раз.';

  @override
  String get deadlinesUpdateError =>
      'Не удалось обновить дедлайн. Попробуй ещё раз.';

  @override
  String get deadlinesRefreshError =>
      'Не удалось обновить список. Текущие данные могут быть устаревшими.';

  @override
  String get deadlinePastError => 'Выбери дату и время в будущем';

  @override
  String get deadlineMarkDone => 'Отметить выполненным';

  @override
  String get deadlineMarkActive => 'Вернуть в активные';

  @override
  String get loginWelcomeBack => 'С возвращением';

  @override
  String get loginSubtitle => 'Войди, используя свой аккаунт (НЕ ЛКС МИРЭА)';

  @override
  String get loginEmailPlaceholder => 'student@university.example';

  @override
  String get loginEmailError => 'Используйте разрешённый университетский email';

  @override
  String loginPasswordError(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Минимум $count символов',
      many: 'Минимум $count символов',
      few: 'Минимум $count символа',
      one: 'Минимум $count символ',
    );
    return '$_temp0';
  }

  @override
  String get loginForgotPassword => 'Забыл пароль?';

  @override
  String get loginSubmit => 'Войти';

  @override
  String get loginOr => 'или';

  @override
  String get loginProviderElk => 'ЕЛК МИРЭА';

  @override
  String get loginProviderGosuslugi => 'Госуслуги';

  @override
  String get loginComingSoon => 'Скоро';

  @override
  String get loginNoAccount => 'Нет аккаунта? ';

  @override
  String get loginGuest => 'Войти как гость';

  @override
  String get loginWithCode => 'Войти по коду';

  @override
  String get loginGenericError =>
      'Не удалось войти. Проверьте данные и попробуйте снова.';

  @override
  String get miniAppsTitle => 'Мини-аппы';

  @override
  String miniAppsSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count приложений',
      few: '$count приложения',
      one: '$count приложение',
      zero: 'пока нет приложений',
    );
    return '$_temp0';
  }

  @override
  String get miniAppsSearch => 'Поиск';

  @override
  String get miniAppsSearchHint => 'Поиск мини-аппов';

  @override
  String get miniAppsCreate => 'Создать';

  @override
  String get miniAppsModeration => 'Модерация';

  @override
  String get miniAppsMyApps => 'Мои приложения';

  @override
  String get miniAppsCatalogSection => 'Каталог';

  @override
  String get miniAppsEmptyTitle => 'Мини-аппов пока нет';

  @override
  String get miniAppsEmptySubtitle =>
      'Стань первым: собери мини-апп на Stac JSON и опубликуй его для всех студентов';

  @override
  String get miniAppsNothingFound => 'Ничего не нашлось';

  @override
  String get miniAppsNothingFoundSubtitle =>
      'Попробуй другой запрос или категорию';

  @override
  String miniAppsLaunches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count запусков',
      few: '$count запуска',
      one: '$count запуск',
      zero: 'нет запусков',
    );
    return '$_temp0';
  }

  @override
  String get miniAppsOpen => 'Открыть';

  @override
  String get miniAppsAbout => 'О приложении и оценка';

  @override
  String get miniAppsHide => 'Скрыть из моего каталога';

  @override
  String get miniAppsUnhide => 'Показать в каталоге';

  @override
  String get miniAppsReport => 'Пожаловаться';

  @override
  String get miniAppsAlreadyReported => 'Жалоба отправлена';

  @override
  String get miniAppsReportTitle => 'Жалоба на мини-апп';

  @override
  String get miniAppsReportSubtitle =>
      'модераторы рассмотрят её в ближайшее время';

  @override
  String get miniAppsReportDetailsHint => 'Что не так? (необязательно)';

  @override
  String get miniAppsReportSend => 'Отправить жалобу';

  @override
  String get miniAppsReportSending => 'Отправляем...';

  @override
  String get miniAppsReportSent => 'Жалоба отправлена. Спасибо!';

  @override
  String get miniAppsRate => 'Твоя оценка';

  @override
  String get miniAppsDelete => 'Удалить приложение';

  @override
  String get miniAppsCategoryAll => 'Все';

  @override
  String get miniAppsCategoryStudy => 'Учёба';

  @override
  String get miniAppsCategoryCampus => 'Кампус';

  @override
  String get miniAppsCategoryTools => 'Инструменты';

  @override
  String get miniAppsCategoryFun => 'Развлечения';

  @override
  String get miniAppsCategorySocial => 'Общение';

  @override
  String get miniAppsCategoryOther => 'Другое';

  @override
  String get miniAppsStatusDraft => 'Черновик';

  @override
  String get miniAppsStatusPending => 'На проверке';

  @override
  String get miniAppsStatusPublished => 'Опубликован';

  @override
  String get miniAppsStatusRejected => 'Отклонён';

  @override
  String get miniAppsStatusSuspended => 'Заморожен';

  @override
  String get miniAppsReasonSpam => 'Спам';

  @override
  String get miniAppsReasonInappropriate => 'Неприемлемое';

  @override
  String get miniAppsReasonBroken => 'Не работает';

  @override
  String get miniAppsReasonScam => 'Мошенничество';

  @override
  String get miniAppsReasonPrivacy => 'Приватность';

  @override
  String get miniAppsReasonOther => 'Другое';

  @override
  String get miniAppsRunnerNotFound => 'Приложение не найдено';

  @override
  String get miniAppsRunnerNotFoundSubtitle =>
      'Возможно, его сняли с публикации или удалили';

  @override
  String get miniAppsRunnerError => 'Не удалось отрисовать экран';

  @override
  String get miniAppsReload => 'Перезагрузить';

  @override
  String get miniAppsClose => 'Закрыть приложение';

  @override
  String get miniAppsSubmitTitle => 'Новый мини-апп';

  @override
  String get miniAppsSubmitSubtitle => 'публикуется после модерации';

  @override
  String get miniAppsSubmitNameHint => 'Название приложения';

  @override
  String get miniAppsSubmitSlugHint => 'slug (латиница, цифры, дефисы)';

  @override
  String get miniAppsSubmitDescriptionHint => 'Короткое описание для каталога';

  @override
  String get miniAppsSubmitCategory => 'Категория';

  @override
  String get miniAppsSubmitSource => 'Источник экранов';

  @override
  String get miniAppsSubmitSourceSubtitle => 'JSON у нас или твой сервер';

  @override
  String get miniAppsSourceHosted => 'JSON в приложении';

  @override
  String get miniAppsSourceRemote => 'Мой сервер';

  @override
  String get miniAppsSubmitEntryPathHint => 'Стартовый путь, например /';

  @override
  String get miniAppsSubmitJsonHint => 'JSON экрана Stac';

  @override
  String get miniAppsSubmitPreview => 'Предпросмотр';

  @override
  String get miniAppsSubmitSend => 'Отправить на модерацию';

  @override
  String get miniAppsSubmitSending => 'Отправляем...';

  @override
  String get miniAppsSubmitDraft => 'Сохранить черновик';

  @override
  String get miniAppsSubmitSuccess =>
      'Отправлено! Приложение появится после модерации.';

  @override
  String get miniAppsSubmitInvalidJson =>
      'JSON экрана некорректен — проверь синтаксис';

  @override
  String get miniAppsSubmitInvalidFields =>
      'Проверь название, slug и адрес сервера (только https)';

  @override
  String get miniAppsSubmitFailure =>
      'Не получилось отправить. Возможно, slug уже занят.';

  @override
  String get miniAppsModerationTitle => 'Модерация';

  @override
  String get miniAppsModerationSubtitle => 'заявки и жалобы';

  @override
  String get miniAppsModerationEmpty => 'Очередь пуста';

  @override
  String get miniAppsModerationEmptySubtitle =>
      'Нет заявок на проверку и открытых жалоб';

  @override
  String get miniAppsModerationPending => 'Ждут проверки';

  @override
  String get miniAppsModerationPendingSubtitle =>
      'тапни по карточке, чтобы открыть превью';

  @override
  String get miniAppsModerationReported => 'С жалобами';

  @override
  String get miniAppsModerationReportedSubtitle =>
      'приложения с открытыми жалобами';

  @override
  String get miniAppsModerationNotesHint =>
      'Комментарий автору (необязательно)';

  @override
  String get miniAppsModerationConfirm => 'Подтвердить';

  @override
  String get miniAppsApprove => 'Одобрить';

  @override
  String get miniAppsRejectAction => 'Отклонить';

  @override
  String get miniAppsSuspend => 'Заморозить';

  @override
  String get miniAppsRestore => 'Восстановить';

  @override
  String get miniAppsDismissReports => 'Снять жалобы';

  @override
  String get profileLoadErrorTitle => 'Не удалось загрузить профиль';

  @override
  String get profileLoadErrorMessage =>
      'Проверь соединение и попробуй ещё раз. Расписание и заметки доступны офлайн.';

  @override
  String get profileStudentFallback => 'Студент';

  @override
  String profileCourseLabel(int course) {
    return '$course курс';
  }

  @override
  String get profileLinkCopied => 'Профиль скопирован';

  @override
  String get profileQuestsOfDay => 'Квесты дня';

  @override
  String profileQuestsCountdown(int xp) {
    return 'до полуночи · +$xp XP';
  }

  @override
  String get profileGroupLeaderboard => 'Лидерборд группы';

  @override
  String get profileAchievements => 'Достижения';

  @override
  String get profileMaxRank => 'максимальный ранг';

  @override
  String profileLevel(int level) {
    return 'Уровень $level';
  }

  @override
  String profileXpOfLevel(int current, int total) {
    return '$current / $total XP';
  }

  @override
  String profileRankNextXp(int xp, String rank) {
    return '$xp до $rank';
  }

  @override
  String get profileStatStreakDays => 'дней подряд';

  @override
  String get profileStatBadges => 'достижений';

  @override
  String get profileBadgesSection => 'Достижения';

  @override
  String get profileStatGroupRank => 'место в группе';

  @override
  String get profileBadgeUnlocked => 'Новое достижение';

  @override
  String get profileBadgeEarned => 'Получено';

  @override
  String get profileBadgeLocked => 'Пока закрыто';

  @override
  String get profileSectionLoadFailed => 'Не удалось загрузить раздел';

  @override
  String get profileShopTitle => 'Магазин сюрикенов';

  @override
  String get profileShopSubtitle => 'Иконки, темы, эмодзи-паки';

  @override
  String get profileShopComingSoon => 'Скоро откроется';

  @override
  String get profileAccount => 'Аккаунт';

  @override
  String get profileSignOut => 'Выйти';

  @override
  String get profileSignOutConfirm => 'Выйти?';

  @override
  String profileStreakDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дней ',
      many: '$days дней ',
      few: '$days дня ',
      one: '$days день ',
    );
    return '$_temp0';
  }

  @override
  String get profileStreakWord => 'стрик';

  @override
  String get profileStreakHint => 'Держи стрик каждый день';

  @override
  String profileStreakRecord(int record, int more) {
    String _temp0 = intl.Intl.pluralLogic(
      record,
      locale: localeName,
      other: '$record дней',
      many: '$record дней',
      few: '$record дня',
      one: '$record день',
    );
    return 'Рекорд $_temp0 · ещё $more — и побьёшь';
  }

  @override
  String get profileStreakRecordBeaten => 'Это твой личный рекорд!';

  @override
  String profileStreakDaysAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дн. назад',
      many: '$days дн. назад',
      few: '$days дня назад',
      one: '$days день назад',
    );
    return '$_temp0';
  }

  @override
  String get profileStreakToday => 'сегодня';

  @override
  String get ninjaPathTitle => 'Путь ниндзя';

  @override
  String get ninjaPathTabBadges => 'Ачивки';

  @override
  String get ninjaPathTabQuests => 'Квесты';

  @override
  String get ninjaPathTabRating => 'Рейтинг';

  @override
  String get ninjaPathLoadError => 'Ошибка загрузки';

  @override
  String get ninjaPathToday => 'Сегодня';

  @override
  String get ninjaPathThisWeek => 'Эта неделя';

  @override
  String get ninjaPathNoData => 'Нет данных';

  @override
  String get ninjaPathScopeGroup => 'Группа';

  @override
  String get ninjaPathScopeCourse => 'Поток';

  @override
  String get ninjaPathScopeFaculty => 'Институт';

  @override
  String get ninjaPathScopeAll => 'Весь универ';

  @override
  String ninjaRankRow(int level) {
    return 'Уровень $level · Ранг';
  }

  @override
  String get ninjaRankBadges => 'ачивок';

  @override
  String get ninjaRankStreak => 'дней стрик';

  @override
  String get ninjaRankShurikens => 'сюрикена';

  @override
  String miniAppsConsentTitle(String name) {
    return '$name запрашивает доступ';
  }

  @override
  String get miniAppsConsentSubtitle => 'ты решаешь, что увидит разработчик';

  @override
  String get miniAppsConsentBody =>
      'Этот мини-апп делает сторонний разработчик. Выбери, чем поделиться — всё ниже необязательно, апп будет работать в любом случае.';

  @override
  String get miniAppsConsentFootnote =>
      'Пароль и сессия не передаются никогда. Без разрешений разработчик видит только анонимный ID. Изменить выбор можно в любой момент в меню аппа.';

  @override
  String get miniAppsConsentAllow => 'Разрешить выбранное';

  @override
  String get miniAppsConsentDenyAll => 'Ничего не передавать';

  @override
  String get miniAppsPermissionsSection => 'Доступ к данным';

  @override
  String get miniAppsSubmitPermissions => 'Запрашиваемые данные';

  @override
  String get miniAppsSubmitPermissionsSubtitle =>
      'пользователи дадут согласие при первом запуске';

  @override
  String get miniAppsPermIdentity => 'ID пользователя';

  @override
  String get miniAppsPermIdentityDesc =>
      'Постоянный идентификатор твоего аккаунта';

  @override
  String get miniAppsPermEmail => 'Email';

  @override
  String get miniAppsPermEmailDesc => 'Твоя университетская почта';

  @override
  String get miniAppsPermProfile => 'Имя и курс';

  @override
  String get miniAppsPermProfileDesc => 'ФИО и номер курса';

  @override
  String get miniAppsPermGroup => 'Учебная группа';

  @override
  String get miniAppsPermGroupDesc => 'Код твоей группы, например БСБО-01-23';

  @override
  String get toolsTitle => 'Ссылки';

  @override
  String get toolsSearchHint => 'Поиск ссылок';

  @override
  String get toolsSearchClose => 'Закрыть поиск';

  @override
  String get toolsCommunitySection => 'Сообщество приложения';

  @override
  String get toolsCommunitySectionSubtitle => 'open-source проект студентов';

  @override
  String get toolsCardGithubSubtitle => 'Исходный код на GitHub';

  @override
  String get toolsCardChatTitle => 'Чат приложения';

  @override
  String get toolsCardChatSubtitle => 'Telegram @mirea_ninja_chat';

  @override
  String get toolsCardRoadmapTitle => 'Roadmap';

  @override
  String get toolsCardRoadmapSubtitle => 'Что в работе и что дальше';

  @override
  String get toolsCardBugTitle => 'Сообщить о баге';

  @override
  String get toolsCardBugSubtitle => 'Прямо в трекер GitHub';

  @override
  String toolsContributorsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count студентов делают это приложение',
      many: '$count студентов делают это приложение',
      few: '$count студента делают это приложение',
      one: '$count студент делает это приложение',
    );
    return '$_temp0';
  }

  @override
  String get toolsContributorsLoading => 'Загружаем участников…';

  @override
  String get toolsBecomeContributor => 'Стать контрибом';

  @override
  String get toolsGroupStudy => 'Учёба';

  @override
  String get toolsGroupGov => 'Госсервисы';

  @override
  String get toolsGroupCommunity => 'Сообщество';

  @override
  String get toolsLinkEducationalPortal => 'Образовательный портал';

  @override
  String get toolsLinkLibrary => 'Электронная библиотека';

  @override
  String get toolsLinkAntiplagiat => 'Антиплагиат';

  @override
  String get toolsLinkModeus => 'Modeus';

  @override
  String get toolsLinkGosuslugi => 'Госуслуги';

  @override
  String get toolsLinkSber => 'Стипендия Сбер';

  @override
  String get toolsLinkTroika => 'Карта Тройка';

  @override
  String get toolsLinkNewsChannel => '@mirea_news';

  @override
  String get toolsLinkCtfTeam => '@ctf_keeper';

  @override
  String get toolsServiceTitle => 'Ссылки';

  @override
  String get freeRoomsSubtitle => 'по живому расписанию';

  @override
  String get freeRoomsRefresh => 'Обновить';

  @override
  String get freeRoomsAllBuildings => 'Все корпуса';

  @override
  String get freeRoomsSummaryLabel => 'аудиторий свободно сейчас';

  @override
  String freeRoomsNow(String time) {
    return 'сейчас $time';
  }

  @override
  String get freeRoomsEmptyTitle => 'Свободных нет';

  @override
  String get freeRoomsEmptySub => 'Все аудитории заняты — попробуй позже';

  @override
  String get freeRoomsUntilEndOfDay => 'до конца дня';

  @override
  String freeRoomsFreeUntil(String time) {
    return 'до $time';
  }

  @override
  String freeRoomsCampus(String campus) {
    return 'кампус $campus';
  }

  @override
  String get knowledgeTitle => 'Банк знаний';

  @override
  String knowledgeSubtitle(int count) {
    return '$count материалов от студентов';
  }

  @override
  String get knowledgeUpload => 'Залить';

  @override
  String get knowledgeUploadTitle => 'Залить материал';

  @override
  String get knowledgeUploadSubtitle => 'делись конспектами — получай сюрикены';

  @override
  String get knowledgeChipAll => 'Всё';

  @override
  String get knowledgeChipNotes => 'Конспекты';

  @override
  String get knowledgeChipTickets => 'Билеты';

  @override
  String get knowledgeChipSolutions => 'Решения';

  @override
  String get knowledgeChipCheats => 'Шпоры';

  @override
  String get knowledgeTypeNote => 'Конспект';

  @override
  String get knowledgeTypeExam => 'Билеты';

  @override
  String get knowledgeTypeTask => 'Решения';

  @override
  String get knowledgeTypeCheat => 'Шпора';

  @override
  String get knowledgeBalanceHint =>
      'твой баланс — платные материалы списывают сюрикены';

  @override
  String get knowledgeEmptyTitle => 'Пока пусто';

  @override
  String get knowledgeEmptySub =>
      'Залей первый конспект — получишь сюрикены за каждое скачивание';

  @override
  String get knowledgeTopAuthors => 'Топ авторов';

  @override
  String get knowledgeMaterialNoAttachment => 'Без вложения';

  @override
  String get knowledgeMaterialRepublishRequired => 'Нужно загрузить заново';

  @override
  String knowledgePages(int n) {
    return '$n стр';
  }

  @override
  String knowledgeAuthorStats(int downloads, int materials) {
    return '$downloads · $materials мат.';
  }

  @override
  String get knowledgeUploadTypeLabel => 'ТИП';

  @override
  String get knowledgeUploadFilePrompt => 'Перетащи файл или выбери';

  @override
  String get knowledgeUploadFileHint => 'PDF, DOCX, фото · до 50 МБ';

  @override
  String knowledgeUploadFileSize(String size) {
    return '$size МБ';
  }

  @override
  String get knowledgeUploadTitleHint => 'Название (Конспект лекций по ML…)';

  @override
  String get knowledgeUploadSubjectHint => 'Предмет';

  @override
  String get knowledgeUploadPriceLabel => 'Цена';

  @override
  String get knowledgeUploadDecreasePrice => 'Уменьшить цену';

  @override
  String get knowledgeUploadIncreasePrice => 'Увеличить цену';

  @override
  String get knowledgeUploadPriceHint => '0 — бесплатно · ты получишь 70%';

  @override
  String get knowledgeUploadAnonymous => 'Анонимно';

  @override
  String knowledgeUploadReward(int amount) {
    return 'За материал начислим +$amount сюрикенов';
  }

  @override
  String get knowledgeUploadPublishing => 'Заливаем…';

  @override
  String get knowledgeUploadPublish => 'Опубликовать';

  @override
  String get walletTitle => 'Кошелёк';

  @override
  String get walletBalanceLabel => 'БАЛАНС';

  @override
  String get walletStreakDays => 'дней стрик';

  @override
  String get walletInGroup => 'в группе';

  @override
  String get walletLevel => 'уровень';

  @override
  String get walletExplainer =>
      'Сюрикены — очки за активность. Трать их внутри приложения.';

  @override
  String get walletExplainerNoCash => 'Не выводятся в деньги.';

  @override
  String get walletTabEarn => 'Заработать';

  @override
  String get walletTabSpend => 'Потратить';

  @override
  String get walletTabHistory => 'История';

  @override
  String get walletEarnLiveTag => 'сейчас';

  @override
  String get walletEarnAttendTitle => 'Посещай пары';

  @override
  String get walletEarnAttendDesc => 'отметка по геолокации';

  @override
  String get walletEarnAttendPer => 'за пару';

  @override
  String get walletEarnStreakTitle => 'Держи стрик';

  @override
  String get walletEarnStreakDesc => 'каждый день подряд';

  @override
  String get walletEarnStreakPer => 'растёт';

  @override
  String get walletEarnUploadTitle => 'Залей конспект';

  @override
  String get walletEarnUploadDesc => 'в Банк знаний';

  @override
  String get walletEarnUploadPer => 'за материал';

  @override
  String get walletEarnDownloadTitle => 'Твой материал качают';

  @override
  String get walletEarnDownloadDesc => '70% от цены автору';

  @override
  String get walletEarnDownloadPer => 'за скачивание';

  @override
  String get walletEarnLikeTitle => 'Лайки на материалы';

  @override
  String get walletEarnLikeDesc => 'оценки сообщества';

  @override
  String get walletEarnLikePer => 'за ★';

  @override
  String get walletEarnQuestTitle => 'Закрывай квесты';

  @override
  String get walletEarnQuestDesc => 'дневные и недельные';

  @override
  String get walletEarnQuestPer => 'за квест';

  @override
  String get walletEarnChatTitle => 'Помогай в чатах';

  @override
  String get walletEarnChatDesc => 'отмеченные ответы';

  @override
  String get walletEarnChatPer => 'за ответ';

  @override
  String get walletEarnFoundTitle => 'Верни находку';

  @override
  String get walletEarnFoundDesc => 'через Бюро находок';

  @override
  String get walletEarnFoundPer => 'за вещь';

  @override
  String get walletEarnReferralTitle => 'Позови друга';

  @override
  String get walletEarnReferralDesc => 'по реф-ссылке';

  @override
  String get walletEarnReferralPer => 'за друга';

  @override
  String get walletSpendSectionTitle => 'Тратить в приложении';

  @override
  String get walletSpendPartnersLater => 'Партнёрские награды появятся позже.';

  @override
  String get walletSpendMaterialsTitle => 'Материалы в Банке знаний';

  @override
  String get walletSpendMaterialsDesc => 'конспекты, билеты, решения';

  @override
  String get walletSpendMaterialsCost => 'от 10';

  @override
  String get walletSpendBoostTitle => 'Буст поста в ленте';

  @override
  String get walletSpendBoostDesc => 'покажем большему числу';

  @override
  String get walletSpendBoostCost => '50';

  @override
  String get walletSpendThemesTitle => 'Темы и иконки приложения';

  @override
  String get walletSpendThemesDesc => 'кастомизация';

  @override
  String get walletSpendProTitle => 'Ninja Pro на месяц';

  @override
  String get walletSpendProDesc => 'без рекламы и бонусы';

  @override
  String get walletHistoryEmptyTitle => 'История пуста';

  @override
  String get walletHistoryEmptySub =>
      'Закрывай квесты и трать сюрикены — все операции появятся здесь';

  @override
  String walletHistoryToday(String time) {
    return 'сегодня $time';
  }

  @override
  String walletHistoryYesterday(String time) {
    return 'вчера $time';
  }

  @override
  String get marketTitle => 'Барахолка';

  @override
  String marketSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'купи-продай среди своих · $count лотов',
      many: 'купи-продай среди своих · $count лотов',
      few: 'купи-продай среди своих · $count лота',
      one: 'купи-продай среди своих · $count лот',
    );
    return '$_temp0';
  }

  @override
  String get marketCatAll => 'Всё';

  @override
  String get marketCatBooks => 'Учебники';

  @override
  String get marketCatTech => 'Техника';

  @override
  String get marketCatCloth => 'Одежда';

  @override
  String get marketCatFree => 'Даром';

  @override
  String get marketCatOther => 'Разное';

  @override
  String get marketFree => 'Даром';

  @override
  String get priceFree => 'Бесплатно';

  @override
  String marketPrice(String price) {
    return '$price₽';
  }

  @override
  String get marketSold => 'продано';

  @override
  String get marketYesterday => 'вчера';

  @override
  String get marketEmptyTitle => 'Пока пусто';

  @override
  String get marketEmptySub =>
      'Выложи первую вещь — учебники и технику разбирают быстро';

  @override
  String get marketSell => 'Продать';

  @override
  String get marketSellTitle => 'Продать вещь';

  @override
  String get marketSellSubtitle => 'объявление увидят все студенты';

  @override
  String get marketTitleHint => 'Что продаёшь?';

  @override
  String get marketPriceHint => 'Цена, ₽';

  @override
  String get marketDescriptionHint => 'Описание (состояние, где забрать…)';

  @override
  String get marketPublish => 'Выложить';

  @override
  String get marketPublishing => 'Публикуем…';

  @override
  String get marketLoadError => 'Не удалось загрузить барахолку';

  @override
  String get marketLoadErrorSubtitle =>
      'Проверьте подключение и попробуйте снова.';

  @override
  String get marketRefreshError => 'Не удалось обновить объявления';

  @override
  String get marketCreateError => 'Не удалось опубликовать объявление';

  @override
  String get marketMutationError => 'Не удалось обновить объявление';

  @override
  String get marketDelete => 'Удалить объявление';

  @override
  String get marketDeleteConfirmTitle => 'Удалить объявление?';

  @override
  String get marketDeleteConfirmBody => 'Оно навсегда исчезнет из барахолки.';

  @override
  String get marketMarkSold => 'Отметить проданным';

  @override
  String get marketMarkAvailable => 'Снова доступно';

  @override
  String get marketDetailsTitle => 'Объявление';

  @override
  String get marketContactSeller => 'Написать продавцу в Telegram';

  @override
  String get marketContactUnavailable => 'Контакт продавца недоступен';

  @override
  String get marketTelegramOpenError => 'Не удалось открыть Telegram';

  @override
  String get marketDescriptionEmpty => 'Продавец не добавил описание.';

  @override
  String get marketSellerFallback => 'Студент';

  @override
  String get marketContactConsent => 'Показать мой Telegram';

  @override
  String get marketContactConsentHint =>
      'Его увидят только студенты вашего университета. Объявление можно разместить и без контакта.';

  @override
  String get marketPriceInvalid => 'Укажите цену больше нуля';

  @override
  String marketPriceHintWithCurrency(String currency) {
    return 'Цена, $currency';
  }

  @override
  String get marketOpenDetails => 'Открыть объявление';

  @override
  String get onboardingTagline =>
      'Расписание, карта, оценки и сообщество — всё в одном кармане.';

  @override
  String get onboardingSignInMirea => 'Войти через MIREA';

  @override
  String get onboardingGroupTitle => 'Твоя группа';

  @override
  String get onboardingGroupHint => 'Начни вводить шифр группы';

  @override
  String get onboardingGroupSearchHint => 'Шифр группы…';

  @override
  String get onboardingGroupEmpty => 'Группы не найдены';

  @override
  String get onboardingNext => 'Далее';

  @override
  String get onboardingSkip => 'Пропустить';

  @override
  String get onboardingPermTitle => 'Последний штрих';

  @override
  String get onboardingPermSubtitle =>
      'Разреши — и приложение раскроется полностью';

  @override
  String get onboardingPermNotificationsTitle => 'Уведомления';

  @override
  String get onboardingPermNotificationsDesc =>
      'напоминания о парах и изменениях';

  @override
  String get onboardingPermLocationTitle => 'Геолокация';

  @override
  String get onboardingPermLocationDesc => 'навигация по кампусу';

  @override
  String get onboardingPermNote =>
      'Меняй в любой момент в Настройках. Мы не передаём данные третьим лицам.';

  @override
  String get onboardingPermCta => 'Поехали';

  @override
  String get settingsAppTour => 'Обучение по приложению';

  @override
  String get tourNavTitle => 'Пять разделов';

  @override
  String get tourNavBody =>
      'Главная, расписание, карта кампуса, сервисы и профиль. Нажми на активную вкладку ещё раз, чтобы вернуться наверх.';

  @override
  String get tourSearchTitle => 'Поиск по всему кампусу';

  @override
  String get tourSearchBody =>
      'Пары, преподаватели, аудитории, люди и обсуждения — из шапки любого корневого экрана.';

  @override
  String get tourDaysTitle => 'Неделя под рукой';

  @override
  String get tourDaysBody =>
      'Выбирай день здесь или свайпай доску ниже. Точки показывают загрузку дня.';

  @override
  String get tourBoardTitle => 'Что происходит сейчас';

  @override
  String get tourBoardBody =>
      'Текущая или ближайшая пара с таймером, аудиторией и таймлайном всего дня.';

  @override
  String get tourServicesTitle => 'Быстрые сервисы';

  @override
  String get tourServicesBody =>
      'Пропуск, карта и остальное — в одно касание. Что здесь живёт, решаешь ты в настройках.';

  @override
  String get tourScheduleViewsTitle => 'День, неделя, месяц';

  @override
  String get tourScheduleViewsBody =>
      'Три режима расписания. Переключай когда угодно — выбранный день переезжает с тобой.';

  @override
  String get tourScheduleWeekTitle => 'Листай недели';

  @override
  String get tourScheduleWeekBody =>
      'Свайпай полоску, чтобы увидеть другие недели, и нажми на дату, чтобы открыть день.';

  @override
  String get tourCatalogTitle => 'Все сервисы в одном списке';

  @override
  String get tourCatalogBody =>
      'Ищи по каталогу и перетаскивай нужные плитки в закреплённые.';

  @override
  String get tourProfileTitle => 'Твой путь ниндзя';

  @override
  String get tourProfileBody =>
      'Опыт, серия дней и достижения растут вместе с учёбой.';

  @override
  String get tourDoneTitle => 'Вот и всё';

  @override
  String get tourDoneBody =>
      'Обучение можно пройти заново: Профиль → Настройки → Обучение по приложению.';

  @override
  String get tourNext => 'Далее';

  @override
  String get tourBack => 'Назад';

  @override
  String get tourSkip => 'Пропустить';

  @override
  String get tourFinish => 'Готово';

  @override
  String tourProgress(int current, int total) {
    return '$current из $total';
  }

  @override
  String get miniAppsSubmitAddScreen => 'Добавить экран';

  @override
  String get miniAppsSubmitScreenPathHint => 'Путь экрана, например /stats';

  @override
  String get miniAppsSubmitRemoveScreen => 'Удалить экран';

  @override
  String get miniAppsSubmitInvalidScreens =>
      'Проверь экраны: пути латиницей, без повторов и обязательно с /';

  @override
  String get peopleTitle => 'Люди';

  @override
  String get peopleLoadError => 'Не удалось загрузить людей';

  @override
  String get peopleLoadErrorSubtitle =>
      'Проверьте подключение и попробуйте снова.';

  @override
  String get peopleGroupLoadError => 'Не удалось проверить вашу группу';

  @override
  String get peopleGroupLoadErrorSubtitle =>
      'Мы не будем создавать новую группу, пока не восстановим текущее членство. Попробуйте ещё раз.';

  @override
  String get peoplePartialLoadError =>
      'Часть данных не обновилась. Показываем последние доступные данные.';

  @override
  String get peopleActionError =>
      'Не удалось выполнить действие. Попробуйте ещё раз.';

  @override
  String get lessonEditorSubjectRequired => 'Введите название предмета.';

  @override
  String get lessonEditorInvalidTimeRange =>
      'Занятие должно заканчиваться позже, чем начинается.';

  @override
  String get lessonEditorDuplicateError => 'Такое занятие уже существует.';

  @override
  String get lessonEditorScheduleMissing =>
      'Расписание или занятие больше недоступно.';

  @override
  String get lessonEditorSaveError =>
      'Не удалось сохранить занятие. Попробуйте ещё раз.';

  @override
  String get customScheduleSyncInProgress => 'Синхронизируем расписания';

  @override
  String get customScheduleSyncInProgressSubtitle =>
      'Сохраняем последнюю версию в аккаунте.';

  @override
  String get customScheduleSyncPending => 'Изменения сохранены на устройстве';

  @override
  String get customScheduleSyncPendingSubtitle =>
      'Облачная копия обновится через несколько секунд.';

  @override
  String get customScheduleSyncOffline => 'Облачная копия ожидает сеть';

  @override
  String get customScheduleSyncOfflineSubtitle =>
      'Расписания сохранены на устройстве. Повторите при подключении к сети.';

  @override
  String get customScheduleSyncConflict =>
      'В облаке найдена более новая версия';

  @override
  String get customScheduleSyncConflictSubtitle =>
      'Локальные изменения сохранены. Повторите, чтобы согласовать версии.';

  @override
  String get peopleRequestSent => 'Заявка в друзья отправлена';

  @override
  String peopleTabFriends(int count) {
    return 'Друзья · $count';
  }

  @override
  String peopleTabGroup(int count) {
    return 'Моя группа · $count';
  }

  @override
  String peopleRequestsLabel(int count) {
    return 'Заявки · $count';
  }

  @override
  String get peopleLiveNow => 'Сейчас на связи';

  @override
  String get peopleAllFriends => 'Все друзья';

  @override
  String get peopleEmptyFriendsTitle => 'Пока без друзей';

  @override
  String get peopleEmptyFriendsSub =>
      'Добавь одногруппников — увидишь их на карте и в активности';

  @override
  String get peopleFindFriends => 'Найти друзей';

  @override
  String get peopleMapTitle => 'Друзья на карте';

  @override
  String get peopleMapOpen => 'Открыть карту друзей';

  @override
  String peopleFriendsOnline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count друзей онлайн',
      many: '$count друзей онлайн',
      few: '$count друга онлайн',
      one: '$count друг онлайн',
    );
    return '$_temp0';
  }

  @override
  String get peopleOnline => 'онлайн';

  @override
  String get peopleGroupTitle => 'Моя группа';

  @override
  String peopleGroupCourse(int count) {
    return '$count курс';
  }

  @override
  String peopleGroupPeople(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count человек',
      many: '$count человек',
      few: '$count человека',
      one: '$count человек',
    );
    return '$_temp0';
  }

  @override
  String peopleGroupInFriends(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count в друзьях',
      many: '$count в друзьях',
      few: '$count в друзьях',
      one: '$count в друзьях',
    );
    return '$_temp0';
  }

  @override
  String get peopleGroupSpaceTitle => 'Пространство группы';

  @override
  String get peopleGroupSpaceSub => 'заметки · ссылки · дни рождения';

  @override
  String get peopleEmptyGroupTitle => 'Группа пока пустая';

  @override
  String get peopleEmptyGroupSub =>
      'Одногруппники появятся здесь автоматически, как только зайдут в приложение';

  @override
  String get peopleGroupList => 'Список группы';

  @override
  String get peoplePrivacyNote =>
      'Одногруппники появляются здесь автоматически. Геопозицией и активностью делишься только с теми, кого добавил в друзья.';

  @override
  String get peopleTagYou => 'это ты';

  @override
  String get peopleTagFriend => 'друг';

  @override
  String get peopleTagRequest => 'заявка';

  @override
  String get peopleAddToFriends => 'В друзья';

  @override
  String groupSpaceHeaderSubtitleGroup(String group) {
    return '$group · только свои';
  }

  @override
  String get groupSpaceHeaderSubtitle => 'только свои';

  @override
  String get groupSpaceMyGroup => 'Моя группа';

  @override
  String groupSpaceMembers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count человек',
      many: '$count человек',
      few: '$count человека',
      one: '$count человек',
    );
    return '$_temp0';
  }

  @override
  String get groupSpaceAddTelegramTitle => 'Ссылка на Telegram';

  @override
  String get groupSpaceAddLinkTitle => 'Добавить ссылку';

  @override
  String get groupSpaceAddTelegramSubtitle =>
      'общение не в приложении — только в Telegram';

  @override
  String groupSpaceAddLinkSubtitleGroup(String group) {
    return 'увидит вся группа $group';
  }

  @override
  String get groupSpaceAddLinkSubtitle => 'увидит вся группа';

  @override
  String get groupSpaceAnnouncementSheetTitle => 'Объявление группе';

  @override
  String get groupSpaceNoteSheetTitle => 'Поделиться заметкой';

  @override
  String get groupSpaceSectionAnnouncement => 'Объявление старосты';

  @override
  String get groupSpaceSectionLinks => 'Полезные ссылки';

  @override
  String get groupSpaceSectionNotes => 'Заметки группы';

  @override
  String get groupSpaceSectionBirthdays => 'Скоро дни рождения';

  @override
  String get groupSpaceActionNew => '+ Новое';

  @override
  String get groupSpaceActionAdd => '+ Добавить';

  @override
  String get groupSpaceOpen => 'Открыть';

  @override
  String get groupSpaceAddTelegramRow =>
      'Добавить ссылку на чат группы в Telegram';

  @override
  String get groupSpaceAnnouncementEmpty =>
      'Объявлений пока нет — староста может написать первое';

  @override
  String get groupSpaceLinksEmpty =>
      'Добавь диск с лекциями, таблицу дежурств или записи пар';

  @override
  String get groupSpaceNotesPlaceholder => 'Поделись конспектом с группой…';

  @override
  String get groupSpaceNotePinned => 'закреп';

  @override
  String groupSpaceLinkAddedBy(String name) {
    return 'добавил $name';
  }

  @override
  String get groupSpaceBirthdayToday => 'сегодня';

  @override
  String get groupSpaceBirthdayTomorrow => 'завтра';

  @override
  String groupSpaceBirthdayInDays(int days) {
    return 'через $days дн';
  }

  @override
  String get groupSpaceBirthdayYou => 'Ты';

  @override
  String groupSpaceTimeMinutes(int minutes) {
    return '$minutes мин';
  }

  @override
  String groupSpaceTimeHours(int hours) {
    return '$hours ч';
  }

  @override
  String get groupSpaceTimeYesterday => 'вчера';

  @override
  String groupSpaceTimeDays(int days) {
    return '$days дн';
  }

  @override
  String get groupSpaceLinkSheetWhereLabel => 'КУДА ВЕДЁТ';

  @override
  String get groupSpaceLinkSheetHandleLabel => 'НИК ИЛИ ССЫЛКА';

  @override
  String get groupSpaceLinkSheetUrlLabel => 'ССЫЛКА';

  @override
  String get groupSpaceLinkSheetTitleLabel => 'НАЗВАНИЕ';

  @override
  String get groupSpaceLinkSheetCategoryLabel => 'КАТЕГОРИЯ';

  @override
  String get groupSpaceLinkSheetTgHint => 't.me/ikbo09_chat';

  @override
  String get groupSpaceLinkSheetUrlHint => 'drive.google.com/…';

  @override
  String get groupSpaceLinkSheetTitleHintTg => 'Чат группы';

  @override
  String get groupSpaceLinkSheetTitleHint => 'Диск с лекциями по ML';

  @override
  String get groupSpaceLinkRecognized => 'распознали автоматически';

  @override
  String get groupSpaceLinkCheck => 'Проверить';

  @override
  String get groupSpaceLinkPrivacyNote =>
      'Mirea Ninja не хранит переписку. Все сообщения — в Telegram, ссылку увидят одногруппники.';

  @override
  String get groupSpaceTgDestChat => 'Чат группы';

  @override
  String get groupSpaceTgDestProfile => 'Мой профиль';

  @override
  String get groupSpaceTgDestChannel => 'Канал';

  @override
  String get groupSpaceCatStudy => 'Учёба';

  @override
  String get groupSpaceCatDrive => 'Диск';

  @override
  String get groupSpaceCatDuty => 'Дежурства';

  @override
  String get groupSpaceCatRecords => 'Записи';

  @override
  String get groupSpaceCatOther => 'Прочее';

  @override
  String get groupSpaceRecognizedDrive => 'Google Drive · папка';

  @override
  String get groupSpaceRecognizedDocs => 'Google Документы';

  @override
  String get groupSpaceRecognizedTelegram => 'Telegram';

  @override
  String get groupSpaceRecognizedLms => 'LMS МИРЭА';

  @override
  String get groupSpaceRecognizedGithub => 'GitHub';

  @override
  String get groupSpaceRecognizedYoutube => 'YouTube';

  @override
  String get groupSpaceSaving => 'Сохраняем…';

  @override
  String get groupSpaceSaveTelegram => 'Сохранить ссылку';

  @override
  String get groupSpaceSaveLink => 'Добавить в группу';

  @override
  String get groupSpacePostTitleHintAnnouncement => 'Что случилось?';

  @override
  String get groupSpacePostTitleHintNote => 'Заголовок заметки';

  @override
  String get groupSpacePostBodyHint => 'Подробности (необязательно)';

  @override
  String get groupSpacePublishing => 'Публикуем…';

  @override
  String get groupSpacePublish => 'Опубликовать';

  @override
  String get postDetailTitle => 'Пост';

  @override
  String get postDetailLoadError => 'Не удалось загрузить пост';

  @override
  String postDetailComments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count комментария',
      many: '$count комментариев',
      few: '$count комментария',
      one: '$count комментарий',
      zero: 'Комментарии',
    );
    return '$_temp0';
  }

  @override
  String get postDetailNoComments => 'Пока нет комментариев';

  @override
  String get teamFinderTitle => 'Поиск команды';

  @override
  String get teamFinderSubtitle => 'хакатоны · проекты · курсовые';

  @override
  String get teamFinderCreateCta => 'Собрать команду';

  @override
  String get teamFinderFilterAll => 'Всё';

  @override
  String get teamFinderFilterMine => 'Мои';

  @override
  String get teamFinderKindHackathon => 'Хакатон';

  @override
  String get teamFinderKindProject => 'Проект';

  @override
  String get teamFinderKindStudy => 'Учёба';

  @override
  String get teamFinderFilterHackathons => 'Хакатоны';

  @override
  String get teamFinderFilterProjects => 'Проекты';

  @override
  String get teamFinderFilterStudy => 'Учёба';

  @override
  String get teamFinderEmptyTitle => 'Команд пока нет';

  @override
  String get teamFinderEmptySubtitle =>
      'Собери свою — на хакатон, курсач или пет-проект';

  @override
  String get teamFinderApplicationSent => 'Отклик отправлен';

  @override
  String get teamFinderApplySheetTitle => 'Откликнуться';

  @override
  String teamFinderApplicationsSheetTitle(String team) {
    return 'Отклики · $team';
  }

  @override
  String get teamFinderCreateSheetTitle => 'Собрать команду';

  @override
  String get teamFinderCreateSheetSubtitle => 'найдём людей под твою задачу';

  @override
  String get teamFinderTagBurning => 'горит';

  @override
  String get teamFinderTagTop => 'в топе';

  @override
  String teamFinderDeadlineUntil(String date) {
    return 'до $date';
  }

  @override
  String teamFinderLookingForRole(String role) {
    return 'ищу: $role';
  }

  @override
  String teamFinderMembersOf(int count, int capacity) {
    return '$count/$capacity в команде';
  }

  @override
  String teamFinderApplicationsCount(int count) {
    return 'Отклики · $count';
  }

  @override
  String get teamFinderNoApplications => 'Откликов нет';

  @override
  String get teamFinderOnTeam => 'В команде';

  @override
  String get teamFinderApplied => 'Отклик отправлен';

  @override
  String get teamFinderFull => 'Мест нет';

  @override
  String get teamFinderApply => 'Откликнуться';

  @override
  String get teamFinderCreateNameLabel => 'НАЗВАНИЕ';

  @override
  String get teamFinderCreateNameHint => 'Приложение для кампуса';

  @override
  String get teamFinderCreateDescriptionLabel => 'ОПИСАНИЕ';

  @override
  String get teamFinderCreateDescriptionHint =>
      'Есть бэкенд и идея. Делаем за выходные…';

  @override
  String get teamFinderCreateRolesLabel => 'КОГО ИЩУ';

  @override
  String get teamFinderRoleFrontend => 'Frontend';

  @override
  String get teamFinderRoleMl => 'ML';

  @override
  String get teamFinderRoleDesign => 'Дизайн';

  @override
  String get teamFinderRoleBackend => 'Backend';

  @override
  String get teamFinderRoleMarketing => 'Маркетинг';

  @override
  String teamFinderRoleSelected(String role) {
    return '$role';
  }

  @override
  String get teamFinderCreateSizeLabel => 'Размер команды';

  @override
  String get teamFinderCreateDeadlineLabel => 'Дедлайн';

  @override
  String get teamFinderCreateDeadlineEmpty =>
      'покажем как «горит» ближе к сроку';

  @override
  String get teamFinderCreateBoostTitle => 'Поднять в топ за 50 сюрикенов';

  @override
  String get teamFinderCreateBoostSubtitle => 'увидят первыми весь день';

  @override
  String get teamFinderPublishing => 'Публикуем…';

  @override
  String get teamFinderPublish => 'Опубликовать';

  @override
  String teamFinderApplyMembersInfo(int count, int capacity, String roles) {
    return '$count/$capacity в команде$roles';
  }

  @override
  String teamFinderApplyNeededRoles(String roles) {
    return ' · нужен $roles';
  }

  @override
  String teamFinderApplyDeadline(String date) {
    return 'дедлайн до $date';
  }

  @override
  String get teamFinderApplyRoleLabel => 'НА КАКУЮ РОЛЬ';

  @override
  String get teamFinderApplyAboutLabel => 'ПАРА СЛОВ О СЕБЕ';

  @override
  String get teamFinderApplyAboutHint =>
      'Сделал 3 проекта на React, есть портфолио…';

  @override
  String get teamFinderApplyPreviewLabel => 'ЧТО УВИДИТ АВТОР';

  @override
  String get teamFinderApplyYou => 'Ты';

  @override
  String teamFinderApplyYouNamed(String name) {
    return 'Ты · $name';
  }

  @override
  String get teamFinderApplyAttachProfile => 'Приложить профиль и группу';

  @override
  String get teamFinderSending => 'Отправляем…';

  @override
  String get teamFinderSendApplication => 'Отправить отклик';

  @override
  String get teamFinderApplicationsEmptyTitle => 'Откликов пока нет';

  @override
  String get teamFinderApplicationsEmptySubtitle =>
      'Подними команду в топ — увидят больше людей';

  @override
  String get teamFinderWriteTelegram => 'Написать в Telegram';

  @override
  String get mentorshipTitle => 'Менторство';

  @override
  String mentorshipHeaderSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ментора',
      many: '$count менторов',
      few: '$count ментора',
      one: '$count ментор',
    );
    return 'старшие помогают младшим · $_temp0';
  }

  @override
  String get mentorshipMyProfileTitle => 'Мой профиль ментора';

  @override
  String get mentorshipBecomeTitle => 'Стать ментором';

  @override
  String get mentorshipBecomeSubtitle =>
      'помогай младшим — получай сюрикены и репутацию';

  @override
  String get mentorshipRequestSheetTitle => 'Запрос ментору';

  @override
  String get mentorshipRequestSent => 'Запрос отправлен';

  @override
  String get mentorshipYouAreMentor => 'Ты ментор';

  @override
  String get mentorshipBecomeCta => 'Стань ментором';

  @override
  String get mentorshipEditHint => 'изменить темы или профиль';

  @override
  String get mentorshipBecomeHint =>
      'Помогай и зарабатывай сюрикены + репутацию';

  @override
  String get mentorshipRequestsToYou => 'ЗАПРОСЫ ТЕБЕ';

  @override
  String get mentorshipEmptyTitle => 'Менторов пока нет';

  @override
  String get mentorshipEmptySubtitle =>
      'Стань первым — помогай младшим курсам с учёбой и карьерой';

  @override
  String mentorshipCourse(int course) {
    return '$course курс';
  }

  @override
  String get mentorshipItsYou => 'это ты';

  @override
  String get mentorshipEditProfile => 'Редактировать профиль';

  @override
  String get mentorshipNoHandle => 'ник не указан';

  @override
  String get mentorshipTopicMl => 'ML';

  @override
  String get mentorshipTopicPython => 'Python';

  @override
  String get mentorshipTopicCareer => 'Карьера';

  @override
  String get mentorshipTopicDesign => 'Дизайн';

  @override
  String get mentorshipTopicFrontend => 'Frontend';

  @override
  String get mentorshipTopicCybersec => 'Кибербез';

  @override
  String get mentorshipLevelCourse3 => '3 курс';

  @override
  String get mentorshipLevelCourse4 => '4 курс';

  @override
  String get mentorshipLevelMaster => 'Магистр';

  @override
  String get mentorshipFormatOnline => 'Онлайн-созвон';

  @override
  String get mentorshipFormatCampus => 'Очно на кампусе';

  @override
  String get mentorshipFormatChat => 'Только переписка';

  @override
  String get mentorshipRewardTitle => '≈ 80 сюрикенов за сессию';

  @override
  String get mentorshipRewardSubtitle => '+ значок «Ментор» в профиле';

  @override
  String get mentorshipTopicsLabel => 'В ЧЁМ ШАРИШЬ';

  @override
  String get mentorshipLevelLabel => 'ТВОЙ УРОВЕНЬ';

  @override
  String get mentorshipFormatLabel => 'ФОРМАТ';

  @override
  String get mentorshipPriceTitle => 'Цена сессии';

  @override
  String get mentorshipPriceSubtitle => 'в сюрикенах · можно бесплатно';

  @override
  String get mentorshipBioHint => 'О себе: чем можешь помочь…';

  @override
  String get mentorshipSaving => 'Сохраняем…';

  @override
  String get mentorshipSave => 'Сохранить';

  @override
  String get mentorshipQuit => 'Перестать быть ментором';

  @override
  String mentorshipSessionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count сессии',
      many: '$count сессий',
      few: '$count сессии',
      one: '$count сессия',
    );
    return '$_temp0';
  }

  @override
  String get mentorshipTopicLabel => 'ТЕМА';

  @override
  String get mentorshipWhenLabel => 'КОГДА УДОБНО';

  @override
  String get mentorshipWhenTonight => 'Сегодня вечером';

  @override
  String get mentorshipWhenTonightHint => 'после 18:00';

  @override
  String get mentorshipWhenTomorrow => 'Завтра днём';

  @override
  String get mentorshipWhenWeek => 'На этой неделе';

  @override
  String get mentorshipWhenShortTonight => 'сегодня вечером';

  @override
  String get mentorshipWhenShortTomorrow => 'завтра днём';

  @override
  String get mentorshipWhenShortWeek => 'на этой неделе';

  @override
  String get mentorshipMessageLabel => 'СООБЩЕНИЕ';

  @override
  String get mentorshipMessageHint =>
      'Привет! Не получается backprop в курсовой…';

  @override
  String get mentorshipFreeSession => 'Эта сессия бесплатна';

  @override
  String mentorshipPaidSession(int price) {
    return '$price сюрикенов будут зарезервированы после принятия заявки';
  }

  @override
  String get mentorshipSendRequest => 'Отправить запрос';

  @override
  String get mentorshipReplyTelegram => 'Ответить в Telegram';

  @override
  String get mentorshipLoadError => 'Не удалось загрузить менторов';

  @override
  String get mentorshipLoadErrorSubtitle =>
      'Проверьте соединение и попробуйте снова.';

  @override
  String get mentorshipRefreshError => 'Не удалось обновить раздел менторства';

  @override
  String get mentorshipRequestsError => 'Не удалось загрузить заявки';

  @override
  String get mentorshipRequestsErrorSubtitle =>
      'Профили менторов по-прежнему доступны.';

  @override
  String get mentorshipInvalidHandle =>
      'Некорректное имя пользователя Telegram';

  @override
  String get mentorshipOpenTelegramError => 'Не удалось открыть Telegram';

  @override
  String get mentorshipRequestActionError => 'Не удалось обновить заявку';

  @override
  String get mentorshipProfileSaveError =>
      'Не удалось сохранить профиль ментора';

  @override
  String get mentorshipProfileDeleteError =>
      'Не удалось отключить профиль ментора';

  @override
  String get mentorshipQuitConfirmTitle => 'Перестать быть ментором?';

  @override
  String get mentorshipQuitConfirmBody =>
      'Профиль исчезнет из списка менторов.';

  @override
  String get mentorshipDecreasePrice => 'Уменьшить стоимость сессии';

  @override
  String get mentorshipIncreasePrice => 'Увеличить стоимость сессии';

  @override
  String get mentorshipRequestError => 'Не удалось отправить заявку';

  @override
  String get mentorshipOutgoingRequests => 'ВАШИ ЗАЯВКИ';

  @override
  String get mentorshipAcceptRequest => 'Принять';

  @override
  String get mentorshipDeclineRequest => 'Отклонить';

  @override
  String get mentorshipCancelRequest => 'Отменить заявку';

  @override
  String get mentorshipCancelConfirmTitle => 'Отменить заявку?';

  @override
  String get mentorshipCancelConfirmBody =>
      'Заявка будет закрыта, а зарезервированные сюрикены вернутся студенту. Сессия не будет засчитана.';

  @override
  String get mentorshipCancelConfirmAction => 'Отменить заявку';

  @override
  String get mentorshipConfirmComplete => 'Подтвердить завершение сессии';

  @override
  String get mentorshipWaitingConfirmation =>
      'Ждём подтверждения второго участника';

  @override
  String get mentorshipCompleted => 'Сессия завершена';

  @override
  String get mentorshipDeclined => 'Заявка отклонена';

  @override
  String get mentorshipCancelled => 'Заявка отменена';

  @override
  String get miniAppsPermNotifications => 'Уведомления';

  @override
  String get miniAppsPermNotificationsDesc =>
      'Пуши от разработчика аппа (не больше 2 в день)';

  @override
  String get miniAppsPermLocation => 'Геолокация';

  @override
  String get miniAppsPermLocationDesc =>
      'Координаты устройства, когда апп их запросит';

  @override
  String get miniAppsPermCamera => 'Камера';

  @override
  String get miniAppsPermCameraDesc => 'Снимать фото и сканировать коды';

  @override
  String get miniAppsPermFiles => 'Файлы';

  @override
  String get miniAppsPermFilesDesc => 'Прикрепить выбранный тобой файл';

  @override
  String get miniAppsPermCalendar => 'Календарь';

  @override
  String get miniAppsPermCalendarDesc =>
      'Добавлять события в календарь устройства';

  @override
  String get miniAppsScopeNotNow => 'Не сейчас';

  @override
  String get miniAppsScanTitle => 'Сканер';

  @override
  String get miniAppsScanInstruction => 'Наведите камеру на код';

  @override
  String get miniAppsScanCameraError => 'Не удалось открыть камеру';

  @override
  String get miniAppsSortTitle => 'Сортировка';

  @override
  String get miniAppsSortPopular => 'Популярные';

  @override
  String get miniAppsSortNew => 'Новые';

  @override
  String get miniAppsSortTop => 'Топ';

  @override
  String get miniAppsRecents => 'Недавно открывали';

  @override
  String get miniAppsFeature => 'В подборку';

  @override
  String get miniAppsUnfeature => 'Убрать из подборки';

  @override
  String get miniAppsQr => 'QR-код';

  @override
  String get miniAppsShare => 'Поделиться';

  @override
  String get miniAppsQrHint => 'Наведи камеру, чтобы открыть этот мини-апп';

  @override
  String get miniAppsStatsTitle => 'Статистика';

  @override
  String miniAppsStatsRangeDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'за последние $days дней',
      many: 'за последние $days дней',
      few: 'за последние $days дня',
      one: 'за последний день',
    );
    return '$_temp0';
  }

  @override
  String miniAppsStatsDaysShort(int days) {
    return '$days дн.';
  }

  @override
  String get miniAppsStatsLaunches => 'Запуски';

  @override
  String get miniAppsStatsUsers => 'Пользователи';

  @override
  String get miniAppsStatsRating => 'Рейтинг';

  @override
  String get miniAppsStatsEmpty => 'Пока нет данных';

  @override
  String get miniAppsStatsEmptySubtitle =>
      'Статистика появится после первых запусков';

  @override
  String get miniAppsRevTitle => 'История версий';

  @override
  String get miniAppsRevSubtitle => 'последние 20 снимков экранов';

  @override
  String get miniAppsRevCurrent => 'текущая';

  @override
  String get miniAppsRevFirst => 'первая версия';

  @override
  String get miniAppsRevNoChanges => 'экраны не менялись';

  @override
  String get miniAppsRevEmpty => 'Ревизий пока нет';

  @override
  String get miniAppsRevRestore => 'Вернуть';

  @override
  String get miniAppsTokensTitle => 'Deploy-токены';

  @override
  String get miniAppsTokensSubtitle => 'для HTTP API деплоя и пушей';

  @override
  String get miniAppsTokensBody =>
      'Токены позволяют деплоить hosted-экраны из CI и слать пуши через HTTP API. Значение показывается один раз — сохрани его надёжно.';

  @override
  String get miniAppsTokensFresh => 'Скопируй сейчас — больше не покажем:';

  @override
  String get miniAppsTokensCopy => 'Скопировать токен';

  @override
  String get miniAppsTokensCopied => 'Токен скопирован';

  @override
  String get miniAppsTokensCreate => 'Создать токен';

  @override
  String get miniAppsTokensRevoke => 'Отозвать';

  @override
  String get miniAppsTokensLimit => 'Лимит токенов исчерпан (5)';

  @override
  String get miniAppsTokensNeverUsed => 'не использовался';

  @override
  String get miniAppsTokensUsed => 'используется';

  @override
  String get miniAppsSecretTitle => 'Секрет подписи';

  @override
  String get miniAppsSecretSubtitle =>
      'проверка запросов прокси на твоём сервере';

  @override
  String get miniAppsSecretBody =>
      'Прокси подписывает каждый запрос к твоему серверу этим секретом (HMAC-SHA256). Проверяй подпись, чтобы убедиться, что запрос действительно от Mirea Ninja. Показывается один раз при генерации — сохрани как NINJA_SECRET.';

  @override
  String get miniAppsSecretFresh => 'Скопируй сейчас — больше не покажем:';

  @override
  String get miniAppsSecretCopy => 'Скопировать секрет';

  @override
  String get miniAppsSecretCopied => 'Секрет скопирован';

  @override
  String get miniAppsSecretGenerate => 'Сгенерировать секрет';

  @override
  String get miniAppsSecretRotate => 'Сменить секрет';

  @override
  String get miniAppsSecretDisable => 'Отключить подпись';

  @override
  String get miniAppsSecretNone => 'Секрет ещё не создан';

  @override
  String miniAppsSecretActive(String fingerprint) {
    return 'Активен · $fingerprint';
  }

  @override
  String get miniAppsSecretPrevActive => 'Прошлый секрет ещё принимается';

  @override
  String get miniAppsSecretRotateHint =>
      'После смены прошлый секрет работает ещё 24 ч (шлётся как X-MireaNinja-Signature-Prev) — обнови сервер за это время.';

  @override
  String get miniAppsSecretFailure => 'Не удалось обновить секрет';

  @override
  String get miniAppsTplTitle => 'Шаблоны';

  @override
  String get miniAppsTplSubtitle => 'готовые мультистраничные заготовки';

  @override
  String get miniAppsTplList => 'Список + детали';

  @override
  String get miniAppsTplChecklist => 'Чеклист (storage)';

  @override
  String get miniAppsTplPoll => 'Опрос';

  @override
  String get miniAppsTplReplaceTitle => 'Заменить экраны?';

  @override
  String get miniAppsTplReplaceBody =>
      'Шаблон перезапишет текущий JSON экранов.';

  @override
  String miniAppsSubmitUnknownTypes(String types) {
    return 'Внимание, неизвестные типы: $types. Они отрисуются пустыми виджетами.';
  }

  @override
  String get collabNotesTitle => 'Конспекты';

  @override
  String get collabNotesSubtitle => 'общие заметки группы · автосейв';

  @override
  String get collabNotesEmptyTitle => 'Пока пусто';

  @override
  String get collabNotesEmptySubtitle =>
      'Создай первый конспект — править сможет вся группа';

  @override
  String get collabNotesCreateTitle => 'Новый конспект';

  @override
  String get collabNotesCreateSubtitle => 'его сможет править вся группа';

  @override
  String collabNotesUpdated(String time) {
    return 'обновлено $time';
  }

  @override
  String collabNotesUpdatedAutosave(String time) {
    return 'обновлено $time · автосейв';
  }

  @override
  String get collabNotesTitleExampleHint => 'Например, «ML лекция 7»';

  @override
  String get collabNotesCreating => 'Создаём…';

  @override
  String get collabNotesCreate => 'Создать';

  @override
  String get collabNotesTitleHint => 'Название';

  @override
  String get collabNotesBodyHint => 'Начни писать конспект…';

  @override
  String get collabNotesDeleteTitle => 'Удалить конспект?';

  @override
  String get collabNotesDeleteBody => 'Он пропадёт у всей группы.';

  @override
  String get collabNotesCancel => 'Отмена';

  @override
  String get collabNotesDelete => 'Удалить';

  @override
  String collabNotesEditorHeader(String title) {
    return 'Конспект · $title';
  }

  @override
  String get collabNotesPresenceSolo => 'только ты';

  @override
  String collabNotesPresenceEditing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count редактируют сейчас',
      many: '$count редактируют сейчас',
      few: '$count редактируют сейчас',
      one: '$count редактирует сейчас',
    );
    return '$_temp0';
  }

  @override
  String get collabNotesToolbarEdit => 'Редактировать';

  @override
  String get collabNotesToolbarSave => 'Сохранить';

  @override
  String get collabNotesNinja => 'Ниндзя';

  @override
  String get collabNotesLoadError => 'Не удалось загрузить конспекты';

  @override
  String get collabNotesLoadErrorSubtitle =>
      'Проверьте соединение и попробуйте снова.';

  @override
  String get collabNotesRefreshError => 'Не удалось обновить конспекты';

  @override
  String get collabNotesCreateError => 'Не удалось создать конспект';

  @override
  String get collabNotesSaving => 'Сохраняем…';

  @override
  String get collabNotesSaved => 'Сохранено';

  @override
  String get collabNotesUnsaved => 'Есть несохранённые изменения';

  @override
  String get collabNotesSaveError =>
      'Не удалось сохранить конспект. Текст остался в редакторе.';

  @override
  String get collabNotesConflict =>
      'Конспект изменили в другом редакторе. Ваш текст остался здесь.';

  @override
  String get collabNotesDeleteError => 'Не удалось удалить конспект';

  @override
  String get collabNotesDiscardTitle => 'Выйти без сохранения?';

  @override
  String get collabNotesDiscardBody => 'Несохранённый текст будет потерян.';

  @override
  String get collabNotesStay => 'Продолжить редактирование';

  @override
  String get collabNotesDiscard => 'Выйти без сохранения';

  @override
  String get eventsTitle => 'Афиша';

  @override
  String get eventsSubtitle => 'что происходит в универе';

  @override
  String get eventsCreateCta => 'Событие';

  @override
  String get eventsFilterAll => 'Всё';

  @override
  String get eventsCategoryCareer => 'Карьера';

  @override
  String get eventsCategorySport => 'Спорт';

  @override
  String get eventsCategoryArt => 'Творчество';

  @override
  String get eventsCategorySci => 'Наука';

  @override
  String get eventsCategoryOther => 'Другое';

  @override
  String get eventsEmptyTitle => 'Пока ничего нет';

  @override
  String get eventsEmptySubtitle =>
      'Создай первое событие — афиша общая для всего универа';

  @override
  String get eventsSectionUpcoming => 'Ближайшие';

  @override
  String get eventsFeaturedTag => 'Главное событие';

  @override
  String get eventsGoingYes => 'Ты идёшь';

  @override
  String get eventsGoingShort => 'Иду';

  @override
  String get eventsRsvp => 'Пойду';

  @override
  String get eventsCreateSheetTitle => 'Новое событие';

  @override
  String get eventsCreateSheetSubtitle => 'увидят все в приложении';

  @override
  String get eventsCreatePreviewTitle => 'Название события';

  @override
  String get eventsCreatePreviewHint => 'так увидят в афише ↑';

  @override
  String get eventsCreateCoverLabel => 'ОБЛОЖКА';

  @override
  String get eventsCreateNameLabel => 'НАЗВАНИЕ';

  @override
  String get eventsCreateNameHint => 'Воркшоп: своё приложение за вечер';

  @override
  String get eventsCreateCategoryLabel => 'КАТЕГОРИЯ';

  @override
  String get eventsCreateWhenLabel => 'КОГДА';

  @override
  String get eventsCreateWhereLabel => 'ГДЕ';

  @override
  String get eventsCreatePlaceHint => 'Аудитория И-301';

  @override
  String get eventsCreateDescriptionHint =>
      'Что будет: программа, спикеры, для кого…';

  @override
  String get eventsCreating => 'Создаём…';

  @override
  String get eventsCreate => 'Создать событие';

  @override
  String get eventsLoadError => 'Не удалось загрузить события';

  @override
  String get eventsLoadErrorSub => 'Проверь соединение и попробуй ещё раз';

  @override
  String get eventsCreateError =>
      'Не удалось создать событие. Попробуй ещё раз';

  @override
  String get eventsRsvpError => 'Не удалось обновить участие. Попробуй ещё раз';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsAppearance => 'Внешний вид';

  @override
  String get settingsTheme => 'Тема';

  @override
  String get settingsThemeDark => 'Тёмная';

  @override
  String get settingsThemeLight => 'Светлая';

  @override
  String get settingsThemeAuto => 'Авто';

  @override
  String get settingsAccent => 'Акцент института';

  @override
  String get settingsAccentSubtitle =>
      'Единый цвет кнопок, навигации и активных элементов';

  @override
  String get settingsAccentBlue => 'Голубой';

  @override
  String get settingsAccentViolet => 'Фиолетовый';

  @override
  String get settingsAccentYellow => 'Янтарный';

  @override
  String get settingsAccentRed => 'Красный';

  @override
  String get settingsAccentGreen => 'Зелёный';

  @override
  String get settingsLessonColors => 'Цвета типов занятий';

  @override
  String get settingsLessonColorsSubtitle =>
      'Выберите спокойный цвет, по которому тип занятия будет узнаваться в расписании';

  @override
  String get settingsLessonColorGreen => 'Зелёный';

  @override
  String get settingsLessonColorBlue => 'Синий';

  @override
  String get settingsLessonColorViolet => 'Фиолетовый';

  @override
  String get settingsLessonColorAmber => 'Янтарный';

  @override
  String get settingsLessonColorRed => 'Красный';

  @override
  String get settingsLessonColorGray => 'Серый';

  @override
  String get settingsPrivacy => 'Приватность';

  @override
  String get settingsWhoSeesProfile => 'Видимость профиля';

  @override
  String get settingsWhoSeesProfileValue => 'Только группа';

  @override
  String get settingsAnonymousReactions => 'Анонимные реакции';

  @override
  String get settingsAnonymousReactionsValue => 'Включены';

  @override
  String get settingsBiometricsPass => 'Биометрия для пропуска';

  @override
  String get settingsNfcEmulation => 'NFC-пропуск на турникете';

  @override
  String get settingsNfcEmulationSub =>
      'Прикладывайте телефон к турникету. Выключите, если турникетом управляет другое приложение';

  @override
  String get settingsMyGroup => 'Моя группа';

  @override
  String get settingsSubgroup => 'Подгруппа';

  @override
  String get settingsSubgroupValue => '2 подгруппа';

  @override
  String get settingsWeekParity => 'Чётность недели';

  @override
  String get settingsWeekParityValue => 'авто по дате';

  @override
  String get settingsHideElectives => 'Скрыть факультативы';

  @override
  String get settingsHomeAndWidgets => 'Главная и виджеты';

  @override
  String get settingsDataAndLanguage => 'Данные и язык';

  @override
  String get settingsLanguage => 'Язык';

  @override
  String get settingsLanguageValue => 'Русский';

  @override
  String get settingsSync => 'Синхронизация';

  @override
  String get settingsSyncValue => 'Wi-Fi + сеть';

  @override
  String get settingsClearCache => 'Очистить кэш';

  @override
  String get settingsClearCacheValue => '48 МБ';

  @override
  String get settingsCacheCleared => 'Кэш очищен';

  @override
  String get settingsExportSchedule => 'Экспорт расписания';

  @override
  String get settingsExportScheduleValue => '.ics календарь';

  @override
  String get settingsExportScheduleHint => 'Откройте на экране «Пары»';

  @override
  String get settingsManageAccount => 'Управление аккаунтом';

  @override
  String get settingsLessonReactions => 'Реакции на парах';

  @override
  String get settingsVisibilityEveryone => 'Все';

  @override
  String get settingsVisibilityGroup => 'Только группа';

  @override
  String get settingsVisibilityNobody => 'Никто';

  @override
  String get settingsVisibilitySheetSubtitle =>
      'Кто может найти вас в поиске и рекомендациях.';

  @override
  String get biometricFaceId => 'Face ID';

  @override
  String get biometricFingerprint => 'Отпечаток';

  @override
  String get biometricUnavailable => 'Недоступно';

  @override
  String get biometricOff => 'Выключено';

  @override
  String get passLockTitle => 'Пропуск заблокирован';

  @override
  String get passLockSubtitle =>
      'Подтвердите, что это вы, чтобы показать пропуск.';

  @override
  String get passLockReason => 'Подтвердите, что это вы, чтобы открыть пропуск';

  @override
  String get passUnlock => 'Разблокировать';

  @override
  String get settingsHomeContentTitle => 'Что на главной';

  @override
  String get settingsHomeContentSubtitle =>
      'Показывайте или скрывайте блоки на главной.';

  @override
  String get homeSectionSmartChips => 'Быстрые действия';

  @override
  String get homeSectionDeadlines => 'Дедлайны';

  @override
  String get homeSectionToday => 'Расписание на сегодня';

  @override
  String get homeSectionTrending => 'Обсуждения';

  @override
  String get settingsWidgetSheetSubtitle =>
      'Виджет показывает активное расписание и текущую пару. Добавьте его с главного экрана.';

  @override
  String get settingsWidgetRefresh => 'Обновить виджет';

  @override
  String get settingsWidgetRefreshed => 'Виджет обновлён';

  @override
  String get settingsLanguageSystem => 'Системный';

  @override
  String get settingsLanguageRu => 'Русский';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get settingsSupportEyebrow => 'OPEN-SOURCE';

  @override
  String get settingsSupportTitle => 'Поддержать проект';

  @override
  String get settingsSupportSubtitle =>
      'Mirea Ninja делают студенты. Поставьте звезду на GitHub или пришлите PR.';

  @override
  String get settingsSupportCta => 'Открыть GitHub';

  @override
  String get accountEmailLabel => 'Почта';

  @override
  String get accountGuest => 'Гостевой аккаунт';

  @override
  String get accountChangePassword => 'Сменить пароль';

  @override
  String get accountChangePasswordSub => 'Пришлём код для сброса на почту';

  @override
  String get accountResetSent => 'Письмо для сброса пароля отправлено';

  @override
  String get accountResetError =>
      'Не удалось отправить письмо. Попробуйте ещё раз.';

  @override
  String get accountDelete => 'Удалить аккаунт';

  @override
  String get accountDeleteConfirmTitle => 'Удалить аккаунт?';

  @override
  String get accountDeleteConfirmBody =>
      'Аккаунт и данные будут удалены навсегда. Отменить нельзя.';

  @override
  String get accountDeleteAction => 'Удалить';

  @override
  String get accountDeleteError =>
      'Не удалось удалить аккаунт. Попробуйте ещё раз.';

  @override
  String get settingsSyncAlways => 'Wi-Fi + сеть';

  @override
  String get settingsSyncWifiOnly => 'Только Wi-Fi';

  @override
  String get settingsSyncManual => 'Только вручную';

  @override
  String get settingsSyncSheetSubtitle => 'Когда обновлять расписание из сети.';

  @override
  String get settingsFooter => 'Mirea Ninja';

  @override
  String get settingsNotifyClasses => 'Напоминать о парах';

  @override
  String get settingsNotifyClassesSub => 'за 15 мин';

  @override
  String get settingsNotifyScheduleChanges => 'Изменения в расписании';

  @override
  String get settingsNotifyScheduleChangesSub => 'мгновенно';

  @override
  String get settingsNotifyReactions => 'Реакции и ответы';

  @override
  String get settingsNotifyReactionsSub => 'тишина 22:00 → 8:00';

  @override
  String get settingsNotifyUniversityNews => 'Новости университета';

  @override
  String get settingsNotifyUniversityNewsSub => 'дайджест по утрам';

  @override
  String get settingsNotifyCommunityEvents => 'События сообщества';

  @override
  String get settingsHomeContent => 'Что на главной';

  @override
  String get settingsQuickServices => 'Быстрые сервисы';

  @override
  String settingsQuickServicesValue(int count) {
    return 'Закреплено: $count';
  }

  @override
  String get settingsHomeContentAll => 'все разделы';

  @override
  String get settingsHomeContentNone => 'ничего';

  @override
  String get settingsScreenWidgets => 'Виджеты экрана';

  @override
  String get settingsNotificationsOn => 'включены';

  @override
  String get settingsNotificationsOff => 'выключены';

  @override
  String get settingsNinjaMascot => 'Маскот ниндзя';

  @override
  String get settingsCompactMode => 'Компактный режим';

  @override
  String get settingsProBanner => 'NINJA PRO';

  @override
  String get settingsProTitle => 'Темы и без рекламы';

  @override
  String get settingsProPrice => '149₽/мес · студентам первый месяц бесплатно';

  @override
  String get settingsProTry => 'Попробовать';

  @override
  String settingsAboutVersion(String version) {
    return 'v $version · open-source';
  }

  @override
  String get settingsAboutDescription =>
      'Сделано студентами для студентов. PR-ы приветствуются';

  @override
  String get settingsNotificationsPushTitle => 'Push-уведомления';

  @override
  String get settingsNotificationsPushSub => 'Все уведомления от приложения';

  @override
  String get settingsNotificationsScheduleSection => 'Расписание';

  @override
  String get settingsNotificationsScheduleTitle => 'Изменения расписания';

  @override
  String get settingsNotificationsScheduleSub =>
      'Отмена, перенос, замена аудитории';

  @override
  String get settingsNotificationsGamificationSection => 'Геймификация';

  @override
  String get settingsNotificationsQuestsTitle => 'Напоминания о квестах';

  @override
  String get settingsNotificationsQuestsSub => 'Дневные квесты к полуночи';

  @override
  String get settingsNotificationsAchievementsTitle => 'Новые ачивки';

  @override
  String get settingsNotificationsAchievementsSub =>
      'Когда разблокируется значок';

  @override
  String get settingsNotificationsLeaderboardTitle => 'Обновления рейтинга';

  @override
  String get settingsNotificationsLeaderboardSub =>
      'Кто тебя обогнал в лидерборде';

  @override
  String get settingsNfcTitle => 'Настройка NFC-пропуска';

  @override
  String get settingsNfcDescription =>
      'Персонализируйте внешний вид вашего пропуска, выбрав изображение или видео для фона';

  @override
  String get settingsScheduleManageTooltip => 'Управление расписанием';

  @override
  String get nfcPassTapHint => 'Приложите телефон\nк турникету';

  @override
  String get nfcPassActiveStatus => 'Активен';

  @override
  String get nfcPassIdLabel => 'ID';

  @override
  String get nfcPassDeviceLabel => 'Устройство';

  @override
  String get nfcPassNotConnectedTitle => 'Пропуск не подключён';

  @override
  String get nfcPassNotConnectedDescription =>
      'Подключите NFC-пропуск, чтобы проходить через турникеты МИРЭА с телефоном.';

  @override
  String get nfcPassConnectButton => 'Подключить пропуск';

  @override
  String get nfcPassUnbindButton => 'Отвязать устройство';

  @override
  String get nfcPassUnbindConfirmTitle => 'Отвязать пропуск?';

  @override
  String get nfcPassUnbindConfirmDescription =>
      'Пропуск перестанет работать на этом устройстве. Вы сможете подключить его снова в любой момент.';

  @override
  String get nfcPassCodeSheetTitle => 'Код из письма';

  @override
  String get nfcPassCodeSheetDescription =>
      'Сервис журнала отправил код на почту, привязанную к студенческому аккаунту. Введите его ниже.';

  @override
  String get nfcPassCheckEmailTitle => 'Проверьте почту';

  @override
  String get nfcPassCheckEmailDescription =>
      'Мы отправили код подтверждения на почту вашего студенческого аккаунта. Введите его, чтобы привязать пропуск.';

  @override
  String get nfcPassEnterCodeButton => 'Ввести код';

  @override
  String get nfcPassErrorTitle => 'Что-то пошло не так';

  @override
  String get nfcPassErrorDescription =>
      'Не удалось загрузить пропуск. Проверьте соединение и попробуйте снова.';

  @override
  String get nfcPassHowItWorksTitle => 'Как это работает';

  @override
  String get nfcPassStep1 => 'Подключите пропуск через журнал посещаемости';

  @override
  String get nfcPassStep2 => 'Подтвердите привязку кодом из письма';

  @override
  String get nfcPassStep3 =>
      'Прикладывайте телефон к турникету как обычный пропуск';

  @override
  String get nfcPassMediaTitle => 'Медиафайл';

  @override
  String get nfcPassMediaDescription =>
      'Выберите изображение или видео для фона карточки пропуска';

  @override
  String get nfcPassMediaSelect => 'Выбрать';

  @override
  String get nfcPassMediaChange => 'Изменить';

  @override
  String get nfcPassMediaRemove => 'Удалить';

  @override
  String get nfcPassPreviewTitle => 'Предпросмотр';

  @override
  String get nfcPassPreviewImageHint => 'Карточка с изображением';

  @override
  String get nfcPassPreviewVideoHint => 'Карточка с видео';

  @override
  String get nfcPassDefaultBackground => 'Стандартный фон';

  @override
  String get nfcPassInfoTitle => 'Информация о пропуске';

  @override
  String get nfcPassIdField => 'ID пропуска';

  @override
  String get nfcPassStatusField => 'Статус';

  @override
  String get pollsTitle => 'Опросы';

  @override
  String pollsSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'голосуй за важное · $count опросов',
      many: 'голосуй за важное · $count опросов',
      few: 'голосуй за важное · $count опроса',
      one: 'голосуй за важное · $count опрос',
    );
    return '$_temp0';
  }

  @override
  String get pollsServiceTitle => 'Опросы';

  @override
  String get pollsCreate => 'Создать';

  @override
  String get pollsCreating => 'Создаём…';

  @override
  String get pollsCreateTitle => 'Новый опрос';

  @override
  String get pollsCancel => 'Отмена';

  @override
  String get pollsTypeSingle => 'Один';

  @override
  String get pollsTypeMultiple => 'Несколько';

  @override
  String get pollsTypeQuiz => 'Квиз';

  @override
  String get pollsQuestionHint => 'Задайте вопрос…';

  @override
  String get pollsOptionsLabel => 'Варианты';

  @override
  String pollsOptionHint(int number) {
    return 'Вариант $number';
  }

  @override
  String get pollsAddOption => 'Добавить вариант';

  @override
  String get pollsRemoveOption => 'Удалить вариант';

  @override
  String get pollsSettings => 'Настройки';

  @override
  String get pollsAnonymous => 'Анонимный опрос';

  @override
  String get pollsAnonymousSub => 'не видно кто как голосовал';

  @override
  String get pollsShowResults => 'Показывать результаты сразу';

  @override
  String get pollsExpiry => 'Завершить через';

  @override
  String get pollsExpiryNone => 'Без срока';

  @override
  String get pollsExpiry24h => '24 часа';

  @override
  String get pollsExpiry3d => '3 дня';

  @override
  String get pollsExpiry7d => '7 дней';

  @override
  String get pollsVote => 'Голосовать';

  @override
  String pollsVotesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count голосов',
      many: '$count голосов',
      few: '$count голоса',
      one: '$count голос',
      zero: 'Нет голосов',
    );
    return '$_temp0';
  }

  @override
  String pollsSharePercent(int percent) {
    return '$percent%';
  }

  @override
  String get pollsTagEnded => 'завершён';

  @override
  String get pollsTagAnonymous => 'анонимный';

  @override
  String get pollsTagQuiz => 'квиз';

  @override
  String get pollsEmptyTitle => 'Опросов пока нет';

  @override
  String get pollsEmptySub => 'Задайте сообществу вопрос первым.';

  @override
  String get pollsDeleteConfirmTitle => 'Удалить опрос?';

  @override
  String get pollsDeleteConfirmBody => 'Опрос и все его голоса будут удалены.';

  @override
  String get pollsDelete => 'Удалить';

  @override
  String get pollsDeleteCancel => 'Отмена';

  @override
  String get schedulesTitle => 'Расписания';

  @override
  String get scheduleHubPrimarySection => 'Основное';

  @override
  String get scheduleHubGroupsSection => 'Группы';

  @override
  String get scheduleHubTeachersSection => 'Преподаватели';

  @override
  String get scheduleHubClassroomsSection => 'Аудитории';

  @override
  String get scheduleHubMineBadge => 'МОЁ';

  @override
  String get scheduleHubLiveLesson => 'идёт пара';

  @override
  String scheduleHubNowSubject(String subject) {
    return 'Сейчас: $subject';
  }

  @override
  String scheduleHubLessonUntil(String time) {
    return 'до $time';
  }

  @override
  String scheduleHubRemaining(int minutes) {
    return 'ост. $minutes мин';
  }

  @override
  String scheduleHubNextSubject(String subject) {
    return 'Следующая: $subject';
  }

  @override
  String scheduleHubNextAt(String time) {
    return 'в $time';
  }

  @override
  String get scheduleHubNoLessonsToday => 'Сегодня пар нет';

  @override
  String scheduleHubLessonsToday(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count пары сегодня',
      many: '$count пар сегодня',
      few: '$count пары сегодня',
      one: '$count пара сегодня',
      zero: 'сегодня выходной',
    );
    return '$_temp0';
  }

  @override
  String scheduleHubUpdatedAgo(String time) {
    return 'обновлено $time';
  }

  @override
  String get scheduleHubAgoNow => 'сейчас';

  @override
  String scheduleHubAgoMinutes(int minutes) {
    return '$minutes мин';
  }

  @override
  String scheduleHubAgoHours(int hours) {
    return '$hours ч';
  }

  @override
  String scheduleHubAgoDays(int days) {
    return '$days дн';
  }

  @override
  String get scheduleHubEmptyTitle => 'Пока нет расписаний';

  @override
  String get scheduleHubEmptySubtitle =>
      'Добавьте группу, преподавателя или аудиторию, чтобы видеть их расписание';

  @override
  String get scheduleHubAllSchedules => 'Все расписания';

  @override
  String get scheduleHubAllSchedulesSubtitle =>
      'Переключить, добавить или отсортировать';

  @override
  String get scheduleRemovedToast => 'Расписание удалено';

  @override
  String get addScheduleTitle => 'Добавить расписание';

  @override
  String get addScheduleTabGroup => 'Группа';

  @override
  String get addScheduleTabTeacher => 'Препод.';

  @override
  String get addScheduleTabClassroom => 'Аудитория';

  @override
  String get addScheduleSearchGroupHint => 'Номер группы, напр. ИКБО-09-22';

  @override
  String get addScheduleSearchTeacherHint => 'Фамилия преподавателя';

  @override
  String get addScheduleSearchClassroomHint => 'Аудитория, напр. А-220';

  @override
  String addScheduleFound(int count) {
    return 'Найдено · $count';
  }

  @override
  String get addScheduleAdded => 'добавлено';

  @override
  String get addScheduleAddAction => 'добавить';

  @override
  String get addScheduleCreateTitle => 'Создать своё с нуля';

  @override
  String get addScheduleCreateSubtitle =>
      'без привязки к группе, преподу или аудитории';

  @override
  String get addScheduleNotFound => 'Не нашёл?';

  @override
  String get addScheduleStartTyping => 'Начните вводить для поиска';

  @override
  String get addScheduleNoResults => 'Ничего не найдено';

  @override
  String get editSchedulesTitle => 'Изменить';

  @override
  String get editSchedulesHint =>
      'Перетащи для сортировки · нажми минус — чтобы отписаться';

  @override
  String get studyGroupTitle => 'Моя группа';

  @override
  String studyGroupMembersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count участников',
      many: '$count участников',
      few: '$count участника',
      one: '1 участник',
      zero: 'нет участников',
    );
    return '$_temp0';
  }

  @override
  String get studyGroupNoGroupTitle => 'Вы пока не в группе';

  @override
  String get studyGroupNoGroupSubtitle =>
      'Создайте учебную группу или вступите в существующую, чтобы открыть пространство группы.';

  @override
  String get studyGroupCreateCta => 'Создать группу';

  @override
  String get studyGroupJoinByCodeCta => 'Вступить по коду';

  @override
  String get studyGroupDiscoverCta => 'Найти группу';

  @override
  String get studyGroupManage => 'Управление группой';

  @override
  String get studyGroupInvitesSection => 'Приглашения';

  @override
  String get studyGroupInviteJoin => 'Вступить';

  @override
  String get studyGroupInviteDismiss => 'Отклонить';

  @override
  String get studyGroupMembersSection => 'Участники';

  @override
  String get studyGroupOwnerTag => 'Владелец';

  @override
  String get studyGroupYouTag => 'Вы';

  @override
  String studyGroupOwnerName(String name) {
    return 'владелец $name';
  }

  @override
  String get studyGroupAccept => 'Принять';

  @override
  String get studyGroupDecline => 'Отклонить';

  @override
  String get studyGroupRemove => 'Удалить';

  @override
  String get studyGroupRemoveMemberTitle => 'Удалить участника?';

  @override
  String studyGroupRemoveMemberBody(String name) {
    return '$name потеряет доступ к пространству группы.';
  }

  @override
  String studyGroupRequestsSection(int count) {
    return 'Заявки на вступление ($count)';
  }

  @override
  String get studyGroupInviteAction => 'Пригласить';

  @override
  String get studyGroupInviteTitle => 'Пригласить в группу';

  @override
  String get studyGroupInviteSubtitle => 'Найдите студента по имени или @нику';

  @override
  String get studyGroupInviteSearchHint => 'Имя или @ник';

  @override
  String get studyGroupInviteSend => 'Пригласить';

  @override
  String get studyGroupInviteSent => 'Приглашён';

  @override
  String get studyGroupInviteError =>
      'Не удалось пригласить. Возможно, человек уже в группе.';

  @override
  String get studyGroupInviteNoneFound => 'Никого не нашли';

  @override
  String get studyGroupInviteNoneFoundSub => 'Попробуйте другое имя или @ник';

  @override
  String get studyGroupInviteByLink =>
      'Или поделитесь кодом или ссылкой-приглашением';

  @override
  String get studyGroupShareCode => 'Код группы';

  @override
  String studyGroupShareCodeText(String name, String code, String link) {
    return 'Вступай в группу «$name» в Mirea Ninja. Код: $code\n$link';
  }

  @override
  String get studyGroupCodeCopied => 'Код скопирован';

  @override
  String get studyGroupCreateTitle => 'Создание группы';

  @override
  String get studyGroupCreateSubtitle =>
      'Вы станете владельцем. У одного человека — одна группа.';

  @override
  String get studyGroupCreateButton => 'Создать';

  @override
  String get studyGroupCreating => 'Создаём…';

  @override
  String get studyGroupCreateError => 'Не удалось создать группу';

  @override
  String get studyGroupNameHint => 'Название, напр. ИКБО-09-22';

  @override
  String get studyGroupDescriptionHint => 'Описание (необязательно)';

  @override
  String get studyGroupDiscoverableLabel =>
      'Видна в каталоге (можно подать заявку)';

  @override
  String get studyGroupJoinTitle => 'Вступить по коду';

  @override
  String get studyGroupJoinSubtitle =>
      'Введите код приглашения, который дал владелец группы';

  @override
  String get studyGroupCodeHint => 'Код, напр. MNMN6T';

  @override
  String get studyGroupJoinButton => 'Вступить';

  @override
  String get studyGroupJoining => 'Вступаем…';

  @override
  String get studyGroupJoinError => 'Не удалось вступить. Проверьте код.';

  @override
  String studyGroupJoinedToast(String name) {
    return 'Вы вступили в «$name»';
  }

  @override
  String get studyGroupLeave => 'Выйти из группы';

  @override
  String get studyGroupLeaveTitle => 'Выйти из группы?';

  @override
  String get studyGroupLeaveBody =>
      'Вы потеряете доступ к пространству группы.';

  @override
  String get studyGroupDelete => 'Удалить группу';

  @override
  String get studyGroupDeleteTitle => 'Удалить группу?';

  @override
  String get studyGroupDeleteBody =>
      'Группа, её ссылки, объявления и общие заметки будут удалены безвозвратно.';

  @override
  String get studyGroupCancel => 'Отмена';

  @override
  String get studyGroupGenericError => 'Что-то пошло не так';

  @override
  String get studyGroupDiscoverTitle => 'Каталог групп';

  @override
  String get studyGroupDiscoverSubtitle =>
      'Найдите группу и подайте заявку владельцу';

  @override
  String get studyGroupDiscoverSearchHint => 'Название или код';

  @override
  String get studyGroupDiscoverEmptyTitle => 'Ничего не нашлось';

  @override
  String get studyGroupDiscoverEmptySubtitle =>
      'Попробуйте другое название или код';

  @override
  String get studyGroupRequestJoin => 'Подать заявку';

  @override
  String get studyGroupRequested => 'Заявка отправлена';

  @override
  String get studyGroupRequestError => 'Не удалось отправить заявку';

  @override
  String get collabNotesVisibilityLabel => 'Кто видит заметку';

  @override
  String get collabNotesVisibilityGroup => 'Вся группа';

  @override
  String get collabNotesVisibilityPersonal => 'Только я';

  @override
  String get collabNotesPersonalBadge => 'Личная';

  @override
  String get collabNotesNeedGroup =>
      'Вступите в группу, чтобы делиться заметками';

  @override
  String get teamFinderExpired => 'Срок истёк';

  @override
  String get teamFinderDeleteTeam => 'Удалить команду';

  @override
  String get teamFinderLeaveTeam => 'Выйти из команды';

  @override
  String get teamFinderWithdrawApplication => 'Отозвать отклик';

  @override
  String get teamFinderLoadError => 'Не удалось загрузить команды';

  @override
  String get teamFinderLoadErrorSubtitle =>
      'Проверьте подключение и попробуйте снова.';

  @override
  String get teamFinderCreateError => 'Не удалось создать команду';

  @override
  String get teamFinderDecreaseCapacity => 'Уменьшить размер команды';

  @override
  String get teamFinderIncreaseCapacity => 'Увеличить размер команды';

  @override
  String get teamFinderApplyError => 'Не удалось отправить отклик';

  @override
  String get teamFinderApplyAttachProfileHint =>
      'Автор увидит ваш Telegram и группу. Имя всегда прикладывается к отклику.';

  @override
  String get teamFinderContactHidden => 'Контакт скрыт';

  @override
  String get teamFinderAccepting => 'Принимаем…';

  @override
  String get teamFinderAcceptApplication => 'Принять';

  @override
  String get teamFinderRejectApplication => 'Отклонить';

  @override
  String get teamFinderTelegramUnavailable => 'Контакт Telegram недоступен';

  @override
  String get teamFinderApplicationsLoadError => 'Не удалось загрузить отклики';

  @override
  String get teamFinderApplicationsLoadErrorSubtitle =>
      'Проверьте подключение и попробуйте снова.';

  @override
  String get teamFinderApplicationActionError => 'Не удалось обновить отклик';

  @override
  String get teamFinderTelegramOpenError => 'Не удалось открыть Telegram';

  @override
  String get teamFinderWithdrawConfirmTitle => 'Отозвать отклик?';

  @override
  String get teamFinderWithdrawConfirmBody =>
      'Автор команды больше не увидит его. Позже можно откликнуться снова.';

  @override
  String get teamFinderLeaveConfirmTitle => 'Выйти из команды?';

  @override
  String get teamFinderLeaveConfirmBody =>
      'Ваше место станет доступно другому кандидату.';

  @override
  String get teamFinderDeleteConfirmTitle => 'Удалить команду?';

  @override
  String get teamFinderDeleteConfirmBody =>
      'Команда и все ожидающие отклики будут удалены безвозвратно.';

  @override
  String get teamFinderLeaveError => 'Не удалось выйти из команды';

  @override
  String get teamFinderDeleteError => 'Не удалось удалить команду';

  @override
  String get teamFinderRefreshError => 'Не удалось обновить команды';

  @override
  String get identityNameLabel => 'ФИО';

  @override
  String get identityNameHint => 'Иван Иванов';

  @override
  String get identityHandleLabel => 'Ник';

  @override
  String get identityHandleHint => 'ivan_99';

  @override
  String get identityHandleHelp => '3–20 символов: латиница, цифры, _';

  @override
  String get identityHandleAvailable => 'Ник свободен';

  @override
  String get identityHandleTaken => 'Этот ник уже занят';

  @override
  String get identityHandleInvalid => 'Только латиница, цифры и _ (3–20)';

  @override
  String get identitySaving => 'Сохраняем…';

  @override
  String get identitySaveError => 'Не удалось сохранить. Попробуйте позже.';

  @override
  String get onboardingIdentityTitle => 'Расскажите о себе';

  @override
  String get onboardingIdentitySubtitle =>
      'Имя и ник увидят одногруппники и друзья';

  @override
  String get profileIdentityRow => 'Имя и ник';

  @override
  String get profileEditIdentityTitle => 'Имя и ник';

  @override
  String get profileEditIdentitySubtitle => 'Видно одногруппникам и друзьям';

  @override
  String get profileEditSave => 'Сохранить';

  @override
  String get profileIdentitySaved => 'Сохранено';

  @override
  String get articleImage => 'Изображение в статье';

  @override
  String get loadingContent => 'Загрузка';

  @override
  String get mapBuildingLabel => 'Корпус';

  @override
  String get mapChangeBuildingHint =>
      'Потяните панель вверх, чтобы сменить корпус';

  @override
  String mapFloorNumber(int number) {
    return '$number этаж';
  }

  @override
  String mapFloorsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count этажа',
      many: '$count этажей',
      few: '$count этажа',
      one: '$count этаж',
    );
    return '$_temp0';
  }

  @override
  String get mapFloorSelection => 'Выбор этажа';

  @override
  String get mapFitFloorPlan => 'Показать весь этаж';

  @override
  String get mapWholeFloor => 'Весь этаж';

  @override
  String get mapZoomIn => 'Приблизить карту';

  @override
  String get mapZoomOut => 'Отдалить карту';

  @override
  String get mapOpeningFloor => 'Открываем этаж';

  @override
  String get mapFindRoom => 'Найти аудиторию';

  @override
  String get mapFindRoomHint =>
      'Поиск по текущему этажу с быстрым переходом на карте';

  @override
  String get mapRoomSearchHint => 'Номер или название аудитории';

  @override
  String get mapNoRoomsTitle => 'На этом этаже ничего не найдено';

  @override
  String get mapNoRoomsMessage => 'Попробуйте другой номер или название';

  @override
  String get mapInteractiveLabel => 'Интерактивная карта этажа';

  @override
  String get mapInteractiveHint =>
      'Перемещайте карту, масштабируйте щипком или двойным касанием';
}

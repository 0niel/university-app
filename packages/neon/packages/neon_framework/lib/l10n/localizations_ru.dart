import 'package:intl/intl.dart' as intl;

import 'localizations.dart';

/// The translations for Russian (`ru`).
class NeonLocalizationsRu extends NeonLocalizations {
  NeonLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get nextcloud => 'Nextcloud';

  @override
  String get nextcloudLogo => 'Логотип Nextcloud';

  @override
  String appImplementationName(String app) {
    String _temp0 = intl.Intl.selectLogic(
      app,
      {
        'nextcloud': 'Nextcloud',
        'core': 'Сервер',
        'dashboard': 'Дашборд',
        'files': 'Файлы',
        'news': 'Новости',
        'notes': 'Заметки',
        'notifications': 'Уведомления',
        'other': '',
      },
    );
    return '$_temp0';
  }

  @override
  String get loginAgain => 'Войти снова';

  @override
  String get loginOpenAgain => 'Открыть снова';

  @override
  String get loginSwitchToBrowserWindow =>
      'Пожалуйста, переключитесь на вкладку браузера, которая только что открылась и продолжите там';

  @override
  String get loginWorksWith => 'работает с';

  @override
  String get loginUsingQRcode => 'Вход по QR-коду';

  @override
  String get loginUsingServerAddress => 'Вход с помощью адреса сервера';

  @override
  String get loginCheckingServerVersion => 'Проверка версии сервера';

  @override
  String loginSupportedServerVersion(String version) {
    return 'Поддерживаемая версия сервера: $version';
  }

  @override
  String loginUnsupportedServerVersion(String version) {
    return 'Неподдерживаемая версия сервера: $version';
  }

  @override
  String get loginCheckingMaintenanceMode => 'Проверка режима обслуживания';

  @override
  String get loginMaintenanceModeEnabled => 'Режим обслуживания активен';

  @override
  String get loginMaintenanceModeDisabled => 'Режим обслуживания отключен';

  @override
  String get loginCheckingAccount => 'Проверка аккаунта';

  @override
  String get errorCredentialsForAccountNoLongerMatch => 'Данные для входа в этот аккаунт больше не подходят';

  @override
  String get errorServerHadAProblemProcessingYourRequest =>
      'Сервер столкнулся с проблемой при обработке вашего запроса. Вы можете попробовать снова';

  @override
  String get errorSomethingWentWrongTryAgainLater => 'Что-то пошло не так. Пожалуйста, попробуйте позже';

  @override
  String get errorUnableToReachServer => 'Невозможно связаться с сервером';

  @override
  String errorUnableToReachServerAt(String url) {
    return 'Невозможно связаться с сервером по адресу $url';
  }

  @override
  String get errorConnectionTimedOut => 'Время соединения истекло';

  @override
  String get errorNoCompatibleNextcloudAppsFound =>
      'Совместимые приложения Nextcloud не найдены.\nМы работаем над добавлением новых приложений!';

  @override
  String get errorServerInMaintenanceMode =>
      'Сервер находится в режиме обслуживания. Попробуйте позже или свяжитесь с администратором сервера.';

  @override
  String errorMissingPermission(String name) {
    return 'Недостает разрешения для $name';
  }

  @override
  String errorUnsupportedAppVersions(String names) {
    return 'Извините, версии следующих приложений на вашем экземпляре Nextcloud не поддерживаются. \n $names \n Пожалуйста, свяжитесь с вашим администратором для устранения проблем.';
  }

  @override
  String get errorEmptyField => 'Это поле не может быть пустым';

  @override
  String get errorInvalidURL => 'Некорректный URL';

  @override
  String get errorInvalidQRcode => 'Некорректный QR-код';

  @override
  String errorRouteNotFound(String route) {
    return 'Путь не найден: $route';
  }

  @override
  String get errorDialog => 'Произшла ошибка';

  @override
  String get actionYes => 'Да';

  @override
  String get actionNo => 'Нет';

  @override
  String get actionClose => 'Закрыть';

  @override
  String get actionRetry => 'Повторить';

  @override
  String get actionShowSlashHide => 'Показать/Скрыть';

  @override
  String get actionExit => 'Выход';

  @override
  String get actionContinue => 'Продолжить';

  @override
  String get actionCancel => 'Отмена';

  @override
  String get firstLaunchGoToSettingsToEnablePushNotifications =>
      'Перейдите в настройки, чтобы включить push-уведомления';

  @override
  String get nextPushSupported => 'NextPush поддерживается!';

  @override
  String get nextPushSupportedText =>
      'NextPush — это FOSS-способ получения push-уведомлений с использованием протокола UnifiedPush через экземпляр Nextcloud.\nВы можете установить NextPush из магазина приложений F-Droid.';

  @override
  String get nextPushSupportedInstall => 'Установить NextPush';

  @override
  String get search => 'Поиск';

  @override
  String get searchCancel => 'Отменить поиск';

  @override
  String get searchNoResults => 'Нет результатов поиска';

  @override
  String get settings => 'Настройки';

  @override
  String get settingsApps => 'Приложения';

  @override
  String get settingsAccount => 'Аккаунт';

  @override
  String get settingsAccountManage => 'Управление аккаунтами';

  @override
  String get settingsExport => 'Экспорт настроек';

  @override
  String get settingsImport => 'Импорт настроек';

  @override
  String get settingsReset => 'Сбросить настройки?';

  @override
  String get settingsImportWrongFileExtension =>
      'Импорт настроек имеет неверное расширение файла (должно быть .json.base64)';

  @override
  String get settingsResetAll => 'Сбросить все настройки';

  @override
  String get settingsResetAllConfirmation => 'Вы действительно хотите сбросить все настройки?';

  @override
  String get settingsResetAllExplanation => 'Это сбросит все настройки к их значениям по умолчанию.';

  @override
  String settingsResetFor(String name) {
    return 'Сбросить все настройки для $name';
  }

  @override
  String get settingsResetForExplanation => 'Это сбросит настройки вашего аккаунта к значениям по умолчанию.';

  @override
  String get settingsResetForClientExplanation => 'Это сбросит все настройки приложения к значениям по умолчанию.';

  @override
  String settingsResetForConfirmation(String name) {
    return 'Вы действительно хотите сбросить все настройки для $name?';
  }

  @override
  String get optionsCategoryGeneral => 'Общие';

  @override
  String get optionsCategoryTheme => 'Тема';

  @override
  String get optionsCategoryPushNotifications => 'Push-уведомления';

  @override
  String get optionsCategoryOther => 'Другое';

  @override
  String get optionsCategoryAccounts => 'Аккаунты';

  @override
  String get optionsCategoryStartup => 'Запуск';

  @override
  String get optionsCategoryNavigation => 'Навигация';

  @override
  String get optionsSortOrderAscending => 'По возрастанию';

  @override
  String get optionsSortOrderDescending => 'По убыванию';

  @override
  String get globalOptionsThemeMode => 'Режим темы';

  @override
  String get globalOptionsThemeModeLight => 'Светлая';

  @override
  String get globalOptionsThemeModeDark => 'Темная';

  @override
  String get globalOptionsThemeModeAutomatic => 'Автоматически';

  @override
  String get globalOptionsThemeOLEDAsDark => 'OLED-тема как темная тема';

  @override
  String get globalOptionsThemeUseNextcloudTheme => 'Использовать тему Nextcloud';

  @override
  String get globalOptionsThemeCustomBackground => 'Пользовательский фон';

  @override
  String get globalOptionsPushNotificationsEnabled => 'Включены';

  @override
  String get globalOptionsPushNotificationsEnabledDisabledNotice =>
      'Не найден распределитель UnifiedPush или вы запретили показ уведомлений. Пожалуйста, перейдите в настройки приложения и разрешите уведомления, а затем перейдите на https://unifiedpush.org/users/distributors и настройте любого из перечисленных распределителей. Затем снова откройте приложение, и вы сможете включить уведомления';

  @override
  String get globalOptionsPushNotificationsDistributor => 'Распределитель UnifiedPush';

  @override
  String get globalOptionsPushNotificationsDistributorGotifyUP => 'Gotify-UP (FOSS)';

  @override
  String get globalOptionsPushNotificationsDistributorFirebaseEmbedded => 'Firebase (проприетарный)';

  @override
  String get globalOptionsPushNotificationsDistributorNtfy => 'ntfy (FOSS)';

  @override
  String get globalOptionsPushNotificationsDistributorFCMUP => 'FCM-UP (проприетарный)';

  @override
  String get globalOptionsPushNotificationsDistributorNextPush => 'NextPush (FOSS)';

  @override
  String get globalOptionsPushNotificationsDistributorNoProvider2Push => 'NoProvider2Push (FOSS)';

  @override
  String get globalOptionsPushNotificationsDistributorConversations => 'Conversations';

  @override
  String get globalOptionsStartupMinimized => 'Запуск свернутым';

  @override
  String get globalOptionsStartupMinimizeInsteadOfExit => 'Свернуть вместо выхода';

  @override
  String get globalOptionsAccountsRememberLastUsedAccount => 'Запоминать последний использованный аккаунт';

  @override
  String get globalOptionsAccountsInitialAccount => 'Начальный аккаунт';

  @override
  String get globalOptionsAccountsAdd => 'Добавить аккаунт';

  @override
  String get globalOptionsNavigationMode => 'Режим навигации';

  @override
  String get globalOptionsNavigationModeDrawer => 'Шторка';

  @override
  String get globalOptionsNavigationModeDrawerAlwaysVisible => 'Drawer always visible';

  @override
  String get accountOptionsRemove => 'Удалить аккаунт';

  @override
  String accountOptionsRemoveConfirm(String id) {
    return 'Вы уверены, что хотите удалить аккаунт $id?';
  }

  @override
  String get accountOptionsCategoryStorageInfo => 'Информация о хранилище';

  @override
  String accountOptionsQuotaUsedOf(String used, String total, String relative) {
    return '$used использовано из $total ($relative%)';
  }

  @override
  String get accountOptionsInitialApp => 'Приложение для первоначального показа ';

  @override
  String get accountOptionsAutomatic => 'Автоматически';

  @override
  String get licenses => 'Лицензии';

  @override
  String get sourceCode => 'Исходный код';

  @override
  String get issueTracker => 'Сообщить о баге или запросить функцию';

  @override
  String get relativeTimeNow => 'сейчас';

  @override
  String relativeTimePast(String time) {
    return '$time назад';
  }

  @override
  String relativeTimeFuture(String time) {
    return 'через $time';
  }

  @override
  String relativeTimeMinutes(int time) {
    String _temp0 = intl.Intl.pluralLogic(
      time,
      locale: localeName,
      other: 'минут',
      few: 'минуты',
      one: 'минута',
    );
    return '$time $_temp0';
  }

  @override
  String relativeTimeHours(int time) {
    String _temp0 = intl.Intl.pluralLogic(
      time,
      locale: localeName,
      other: 'часов',
      few: 'часа',
      one: 'час',
    );
    return '$time $_temp0';
  }

  @override
  String relativeTimeDays(int time) {
    String _temp0 = intl.Intl.pluralLogic(
      time,
      locale: localeName,
      other: 'дней',
      few: 'дня',
      one: 'день',
    );
    return '$time $_temp0';
  }

  @override
  String relativeTimeYears(int time) {
    String _temp0 = intl.Intl.pluralLogic(
      time,
      locale: localeName,
      other: 'лет',
      few: 'года',
      one: 'год',
    );
    return '$time $_temp0';
  }
}

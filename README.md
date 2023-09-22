# rtu-mirea-app
[![Codemagic build status](https://api.codemagic.io/apps/650ddff0d58153d281f375fe/650ddff0d58153d281f375fd/status_badge.svg)](https://codemagic.io/apps/650ddff0d58153d281f375fe/650ddff0d58153d281f375fd/latest_build)

Это мобильное приложение с полностью открытым исходным кодом для студентов и преподавателей РТУ МИРЭА.
<p float="left">
  <a href="https://play.google.com/store/apps/details?id=ninja.mirea.mireaapp"><img src="https://user-images.githubusercontent.com/51058739/130847046-edf8906f-02dc-4c13-87e5-9872651d606f.png" width="128" /></a>
   <a href="https://apps.apple.com/ru/app/ninja-mirea/id1582508025" width="128" /><img src="https://user-images.githubusercontent.com/51058739/130931786-3e21e740-358d-4708-8cab-3a0108bc619b.png" width="128" /></a>
</p>

# Скриншоты
<p float="left">
  <img src="https://github.com/mirea-ninja/rtu-mirea-mobile/assets/51058739/0306ec8f-c6cd-49c2-a3eb-043a3bf9e1ce" width="150" />
  <img src="https://github.com/mirea-ninja/rtu-mirea-mobile/assets/51058739/e57e07fa-3e55-40fd-bac0-393b460f2925" width="150" />
  <img src="https://github.com/mirea-ninja/rtu-mirea-mobile/assets/51058739/c1010e39-2eb5-4e9f-acba-81bd2368b174" width="150" />
  <img src="https://github.com/mirea-ninja/rtu-mirea-mobile/assets/51058739/72f8fdf2-05b8-4cb0-8834-d3cef30fa899" width="150" />
  <img src="https://github.com/mirea-ninja/rtu-mirea-mobile/assets/121052717/64ae1e7f-19e4-473c-a3f0-93ae64439551" width="150" />
 </p>
 <p float="left">
  <img src="https://github.com/mirea-ninja/rtu-mirea-mobile/assets/51058739/2cb09f12-9185-47f5-9125-3f5afa1b52be" width="150" />
  <img src="https://github.com/mirea-ninja/rtu-mirea-mobile/assets/51058739/f0df7fc8-f3f5-4706-84f8-6d16041f5337" width="150" />
  <img src="https://github.com/mirea-ninja/rtu-mirea-mobile/assets/51058739/b8929457-b8b5-4a56-8e34-15afe6350de0" width="150" />
  <img src="https://github.com/mirea-ninja/rtu-mirea-mobile/assets/51058739/a477c6c2-3082-49d3-ab65-dac371ab3b11" width="150" />
  <img src="https://github.com/mirea-ninja/rtu-mirea-mobile/assets/121052717/73476d7c-eeda-47ef-8f81-80c4a95c0ca5" width="150" />
</p>

# Самостоятельная сборка проекта
1. Установите стабильную версию Flutter для своей операционной системы, используя [руководство на странице документации](https://docs.flutter.dev/get-started/install). 
2. Установить зависимости пакетов:
```
flutter pub get
```
3. Откройте эмулятор устройства, а затем запустите проект, выполнив команду:
```
flutter run
```
4. Используйте одну из этих команд для сборки проекта:
```
flutter build apk
flutter build ios
flutter build appbundle
```
5. Если возникнут какие-либо проблемы при выполнении предыдущих действий, выполните приведенную ниже команду для анализа и устанения неполадок:
```
flutter doctor
```

## Генерация кода
Пакеты **freezed** и **auto_route** генерируют код для API моделей данных и навигации.
Используйте флаг [watch], чтобы следить за изменениями в файловой системе и перестраивать код при необходимости.
```
flutter packages pub run build_runner watch --delete-conflicting-outputs
```

Если вы хотите, чтобы генератор запустился один раз и завершил работу, используйте
```
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## Конфигурация Firebase Analytics
1. Зарегистрируйте приложение в [Firebase](https://console.firebase.google.com/).
2. Выполните шаги для генерации `firebase_options.dart` файла с помощью [FlutterFire CLI](https://firebase.flutter.dev/docs/cli).
3. Firebase Analytics для Android не поддерживает Dart-only конфигурацию. Как только ваше приложение для Android будет зарегистрировано в Firebase, загрузите файл конфигурации с консоли Firebase (файл называется `google-services.json`). Добавьте этот файл в каталог `android/app`.
4. Проект готов для использования с Firebase Analytics и Crashlytics.

## Переменные окружения
Приложение использует переменные среды времени компиляции для хранения конфиденциальных данных, таких как ключи API и токены. 

Эти переменные должны передаваться при запуске или сборке приложения с помощью аргумента `--dart-define` или установленной переменной окружения. Если вам нужно передать несколько пар ключ-значение, просто определите --dart-define несколько раз.

### Переменные приложения:
- `SENTRY_DSN` - DSN для отправки отчетов об ошибках в Sentry.
- `LK_CLIENT_ID` - ID клиента для авторизации в Личном кабинете с помощью OAuth2.
- `LK_CLIENT_SECRET` - Секретный ключ клиента для авторизации в Личном кабинете с помощью OAuth2.

**Пример:**
```bash
flutter run --dart-define=SENTRY_DSN=YOUR_DSN --dart-define=LK_CLIENT_ID=YOUR_CLIENT_ID --dart-define=LK_CLIENT_SECRET=YOUR_CLIENT_SECRET
```


## При ошибках
**Исключения платформы**
1. flutter clean
2. flutter pub get
3. flutter run

**Любое исключение пакета (зависимости)**
- Удалите pubspec.lock файл

Выполните следующие команды:
1. flutter clean
2. flutter pub cache repair
3. flutter pub get
4. flutter run

# Установка
Следить за актуальностью приложения и скачать готовый билд вы можете на [странице релизов](https://github.com/Ninja-Official/rtu-mirea-mobile/releases) этого репозитория.

# Ваше участие
Это приложение и все относящиеся к нему сервисы являются **100% бесплатными** и **Open Source** продуктами. Мы с огромным удовольствием примем любые ваши предложения и сообщения, а также мы рады любому вашему участию в проекте! Перед тем как принять участие в развитии проекта:
1. Ознакомьтесь с нашим [CONTRIBUTING.MD](https://github.com/Ninja-Official/rtu-mirea-mobile/blob/master/CONTRIBUTING.md), в котором описано то, как должны вести себя участники проекта.
2. Уважайте других участников, обсуждайте идеи, а не личности, ознакомьтесь с [кодексом поведения](https://github.com/Ninja-Official/rtu-mirea-mobile/blob/master/CODE_OF_CONDUCT.md).
3. Не знаете, над чем вы хотите работать? Ознакомьтесь с нашей [дорожной картой](https://github.com/Ninja-Official/rtu-mirea-mobile/projects/1).

### Разработчики

<a href="https://github.com/mirea-ninja/rtu-mirea-mobile/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=mirea-ninja/rtu-mirea-mobile" />
</a>

### Благодарности
* Спасибо **Ивану Лаптеву**, заведующему [RTUITLab](https://rtuitlab.dev/), за его неоценимый вклад в развитие этого проекта
* Спасибо **Анне Степушкиной**, заместителю председателя по работе со студентами ИПТИП, за её невероятную помощь в разработке карт зданий для нашего приложения

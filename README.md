# rtu-mirea-app

Это мобильное приложение с полностью открытым исходным кодом для студентов и преподавателей РТУ МИРЭА.
<p float="left">
  <a href="https://play.google.com/store/apps/details?id=ninja.mirea.mireaapp"><img src="https://user-images.githubusercontent.com/51058739/130847046-edf8906f-02dc-4c13-87e5-9872651d606f.png" width="128" /></a>
   <a href="https://apps.apple.com/ru/app/ninja-mirea/id1582508025" width="128" /><img src="https://user-images.githubusercontent.com/51058739/130931786-3e21e740-358d-4708-8cab-3a0108bc619b.png" width="128" /></a>
</p>

# Скриншоты
<p float="left">
  <img src="https://user-images.githubusercontent.com/51058739/130845744-9cc1b085-cd9f-4e02-9a54-40c213b076a7.jpg" width="150" />
  <img src="https://user-images.githubusercontent.com/51058739/130845737-15fe67ce-0893-4d42-86d7-f739aa981c14.jpg" width="150" />
  <img src="https://user-images.githubusercontent.com/51058739/130845743-1d2fb68f-27d8-468d-ac1c-5249cc5bcbae.jpg" width="150" /> 
  <img src="https://user-images.githubusercontent.com/51058739/130845914-5658f14a-e946-4f0e-ae05-fc10292643ca.jpg" width="150" /> 
</p>

# Самостоятельная сборка проекта
1. Установите стабильную версию Flutter 2.8.1 для своей операционной системы, используя [руководство на странице документации](https://docs.flutter.dev/get-started/install). 
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

## Конфигурация Firebase Analytics и Crashlytics
1. Зарегистрируйте приложение в [Firebase](https://console.firebase.google.com/).
1. Выполните шаги для генерации `firebase_options.dart` файла с помощью [FlutterFire CLI](https://firebase.flutter.dev/docs/cli).
2. Firebase Analytics для Android не поддерживает Dart-only конфигурацию. Как только ваше приложение для Android будет зарегистрировано в Firebase, загрузите файл конфигурации с консоли Firebase (файл называется `google-services.json`). Добавьте этот файл в каталог `android/app`.
3. Проект готов для использования с Firebase Analytics и Crashlytics.

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

# Примите участие
Это приложение и все относящиеся к нему сервисы являются **100% бесплатными** и **Open Source** продуктами. Мы с огромным удовольствием примем любые ваши предложения и сообщения, а также мы рады любому вашему участию в проекте! Перед тем как принять участие в развитии проекта:
1. Ознакомьтесь с нашим [CONTRIBUTING.MD](https://github.com/Ninja-Official/rtu-mirea-mobile/blob/master/CONTRIBUTING.md), в котором описано то, как должны вести себя участники проекта.
2. Уважайте других участников, обсуждайте идеи, а не личности, ознакомьтесь с [кодексом поведения](https://github.com/Ninja-Official/rtu-mirea-mobile/blob/master/CODE_OF_CONDUCT.md).
3. Не знаете, над чем вы хотите работать? Ознакомьтесь с нашей [дорожной картой](https://github.com/Ninja-Official/rtu-mirea-mobile/projects/1).

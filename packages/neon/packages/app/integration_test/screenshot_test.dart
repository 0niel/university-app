import 'package:app/apps.dart';
import 'package:app/branding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:neon_files/src/widgets/actions.dart';
import 'package:neon_framework/models.dart';
import 'package:neon_framework/neon.dart';
import 'package:neon_framework/settings.dart';
import 'package:nextcloud/core.dart' as core;
import 'package:nextcloud/news.dart' as news;
import 'package:nextcloud/nextcloud.dart';
import 'package:nextcloud/notes.dart' as notes;
import 'package:nextcloud/notifications.dart' as notifications;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_io/io.dart';

Future<void> runTestApp(
  WidgetTester tester,
  IntegrationTestWidgetsFlutterBinding binding, {
  Account? account,
}) async {
  await runNeon(
    appImplementations: appImplementations,
    theme: neonTheme,
    bindingOverride: binding,
    account: account,
    firstLaunchDisabled: true,
    nextPushDisabled: true,
  );
  await tester.pumpAndSettle();
}

Future<void> openDrawer(WidgetTester tester) async {
  await tester.tap(find.byTooltip('Open navigation menu'));
  await tester.pumpAndSettle();
}

Future<void> switchPage(WidgetTester tester, String name) async {
  await openDrawer(tester);
  await tester.tap(find.text(name).last);
  await tester.pumpAndSettle();
}

Future<void> prepareScreenshot(WidgetTester tester, IntegrationTestWidgetsFlutterBinding binding) async {
  await binding.convertFlutterSurfaceToImage();
  await tester.pumpAndSettle();
}

Future<Account> getAccount(String username) async {
  final host = Uri(scheme: 'http', host: '10.0.2.2');
  final appPassword = (await NextcloudClient(
    host,
    loginName: username,
    password: username,
  ).core.appPassword.getAppPassword())
      .body
      .ocs
      .data
      .apppassword;
  return Account(
    serverURL: host,
    username: username,
    password: appPassword,
  );
}

Future<void> main() async {
  // The screenshots are pretty annoying on Android. See https://github.com/flutter/flutter/issues/92381

  assert(Platform.isAndroid, 'Screenshots need to be taken on Android');

  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late Account account;

  setUpAll(() async {
    account = await getAccount('demo');
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('login', (tester) async {
    await runTestApp(
      tester,
      binding,
    );
    await prepareScreenshot(tester, binding);
    await binding.takeScreenshot('login_server_selection');
  });

  testWidgets('home', (tester) async {
    await runTestApp(
      tester,
      binding,
      account: account,
    );
    await openDrawer(tester);
    await tester.pumpAndSettle();
    await tester.pump();
    await prepareScreenshot(tester, binding);
    await binding.takeScreenshot('home_drawer');
  });

  testWidgets('files', (tester) async {
    await runTestApp(
      tester,
      binding,
      account: account,
    );
    await prepareScreenshot(tester, binding);
    await binding.takeScreenshot('files_root');

    // Show Photos folder
    await tester.tap(find.text('Photos'));
    await tester.pumpAndSettle();
    await tester.pump();

    await binding.takeScreenshot('files_photos');

    // Show file actions
    await tester.tap(find.text('Photos'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(PopupMenuButton<FilesFileAction>).first);
    await tester.pumpAndSettle();

    await binding.takeScreenshot('files_actions');

    // Show details page
    await tester.tap(find.text('Details'));
    await tester.pumpAndSettle();

    await binding.takeScreenshot('files_details');

    // Show create dialog
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    await binding.takeScreenshot('files_create');
  });

  testWidgets('news', (tester) async {
    const wikipediaFeedURL = 'https://en.wikipedia.org/w/api.php?action=featuredfeed&feed=featured&feedformat=atom';
    const nasaFeedURL = 'https://www.nasa.gov/rss/dyn/breaking_news.rss';

    final folder = await account.client.news.createFolder(name: 'test');
    await account.client.news.addFeed(
      url: nasaFeedURL,
      folderId: folder.body.folders.single.id,
    );

    await runTestApp(
      tester,
      binding,
      account: account,
    );
    await prepareScreenshot(tester, binding);
    await switchPage(tester, 'News');

    // Show folders
    await tester.tap(find.byIcon(Icons.folder));
    await tester.pumpAndSettle();

    await binding.takeScreenshot('news_folders_list');

    // Add Wikipedia feed
    await tester.tap(find.byIcon(Icons.rss_feed));
    await tester.pumpAndSettle();
    await tester.pump();
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    await binding.takeScreenshot('news_feed_add');

    // Finish adding Wikipedia feed
    await tester.enterText(find.byType(TextFormField), wikipediaFeedURL);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    await tester.pump();

    await binding.takeScreenshot('news_feeds_list');

    // Open feed
    await tester.tap(find.text('NASA Breaking News'));
    await tester.pumpAndSettle();

    await binding.takeScreenshot('news_feed_articles_list');

    // Show unread articles
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.newspaper));
    await tester.pumpAndSettle();

    // Star two articles
    await tester.tap(find.byIcon(Icons.star_outline).at(0));
    await tester.tap(find.byIcon(Icons.star_outline).at(1));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 3));

    await binding.takeScreenshot('news_articles_unread_list');

    // Show starred articles
    await tester.tap(find.text('Unread'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Starred').last);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 3));

    await binding.takeScreenshot('news_articles_starred_list');
  });

  testWidgets('notes', (tester) async {
    await account.client.notes.createNote(
      title: 'Wishlist',
      category: 'Financial',
    );

    await runTestApp(
      tester,
      binding,
      account: account,
    );
    await prepareScreenshot(tester, binding);
    await switchPage(tester, 'Notes');

    // Create note
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'Grocery');
    await tester.pumpAndSettle();
    await tester.tap(find.byType(TextFormField).last);
    await tester.pumpAndSettle();

    await binding.takeScreenshot('notes_note_create');

    // Finish creating note
    await tester.enterText(find.byType(TextFormField).last, 'Financial');
    await tester.pumpAndSettle();
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 3));

    // Star note
    await tester.tap(find.byIcon(Icons.star_outline).first);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 3));

    await binding.takeScreenshot('notes_notes_list');

    // Edit note
    await tester.tap(find.text('Grocery'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '- Bread\n- Water\n- Apples');
    await tester.pumpAndSettle();
    await tester.pump(); // Needed for the text to actually show up

    await binding.takeScreenshot('notes_note_edit');

    // Show note preview
    await tester.tap(find.byIcon(Icons.visibility));
    await tester.pumpAndSettle();

    await binding.takeScreenshot('notes_note_preview');

    // Show categories
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(MdiIcons.tag).last);
    await tester.pumpAndSettle();

    await binding.takeScreenshot('notes_categories_list');
  });

  testWidgets('notifications', (tester) async {
    await (await getAccount('admin')).client.notifications.api.generateNotification(
          userId: account.username,
          shortMessage: 'Notifications demo',
          longMessage: 'This is a notifications demo of the Neon app',
        );

    await runTestApp(
      tester,
      binding,
      account: account,
    );
    await prepareScreenshot(tester, binding);
    await tester.tap(find.byTooltip('Notifications'));
    await tester.pumpAndSettle();

    await tester.pumpAndSettle();
    await tester.pump();

    await binding.takeScreenshot('notifications_list');
  });

  testWidgets('settings', (tester) async {
    await runTestApp(
      tester,
      binding,
      account: account,
    );
    await prepareScreenshot(tester, binding);
    await switchPage(tester, 'Settings');

    // Open Files settings
    await tester.tap(find.text('Files'));
    await tester.pumpAndSettle();

    await binding.takeScreenshot('settings_app_files');

    // Open News settings
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    await tester.tap(find.text('News'));
    await tester.pumpAndSettle();

    await binding.takeScreenshot('settings_app_news');

    // Open Notes settings
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Notes'));
    await tester.pumpAndSettle();

    await binding.takeScreenshot('settings_app_notes');

    // Go back to main page
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    await binding.takeScreenshot('settings_light');

    // Change to dark theme
    await tester.tap(find.text('Automatic'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dark').last);
    await tester.pumpAndSettle();

    await binding.takeScreenshot('settings_dark');

    // Enable OLED theme
    await tester.tap(find.byType(SwitchListTile).first);
    await tester.pumpAndSettle();

    await binding.takeScreenshot('settings_oled');

    // Change to back to light theme
    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Light').last);
    await tester.pumpAndSettle();

    // Scroll down to accounts
    await tester.drag(find.byType(SettingsList).first, const Offset(0, -10000));
    await tester.pumpAndSettle();

    await binding.takeScreenshot('settings_accounts');

    // Go to account settings
    await tester.tap(find.text('demo@10.0.2.2:80'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Automatic'));
    await tester.pumpAndSettle();

    await binding.takeScreenshot('settings_account');
  });
}

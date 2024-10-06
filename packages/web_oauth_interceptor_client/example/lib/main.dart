import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web_oauth_interceptor_client/web_oauth_interceptor_client.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
  }

  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final WebOAuthInterceptorClient oauthClient = WebOAuthInterceptorClient(
    oauthUrl: "https://online-edu.mirea.ru/login/index.php",
    expectedRedirectUrls: ["https://online-edu.mirea.ru/my/"],
    buttonSelectors: {
      'loginButton': '#loginButton',
    },
    formSelectors: {
      'usernameField': '#username',
      'passwordField': '#password',
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OAuth Interceptor Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await oauthClient.initiateOAuthFlow(context);
          },
          child: const Text("Start OAuth Flow"),
        ),
      ),
    );
  }
}

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
  final OAuthInterceptorClient oauthClient = OAuthInterceptorClient(
    oauthUrl:
        'https://attendance.mirea.ru/api/auth/login?redirectUri=https%3A%2F%2Fattendance-app.mirea.ru&rememberMe=True',
    expectedRedirectUrls: ['https://attendance-app.mirea.ru/'],
    specialCookieName: '.AspNetCore.Cookies',
    onLoginSuccess: (data) {
      print('Login success! Data: ${data.specialCookieValue}');
    },
    onLoginError: (String error) {
      print('Login failure! Error: $error');
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
            await oauthClient.initiateOAuthFlow();
          },
          child: const Text("Start OAuth Flow"),
        ),
      ),
    );
  }
}

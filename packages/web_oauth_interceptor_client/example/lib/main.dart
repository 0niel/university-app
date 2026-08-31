import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web_oauth_interceptor_client/web_oauth_interceptor_client.dart';

Future<void> main() async {
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
  final OAuthInterceptorClient _oauthClient = OAuthInterceptorClient(
    oauthUrl:
        'https://auth.university.example/oauth/authorize?redirect_uri=https%3A%2F%2Fapp.university.example%2Fauth%2Fcallback',
    expectedRedirectUrls: ['https://app.university.example/auth/callback'],
    specialCookieName: 'session',
    onLoginSuccess: (_) => debugPrint('OAuth login completed.'),
    onLoginError: (_) => debugPrint('OAuth login failed.'),
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
            await _oauthClient.initiateOAuthFlow();
          },
          child: const Text('Start OAuth Flow'),
        ),
      ),
    );
  }
}

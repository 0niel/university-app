# Web OAuth Interceptor Client

Internal Flutter package for OAuth flows rendered in an
`flutter_inappwebview` browser. It detects an allow-listed redirect URI,
collects the configured authentication cookie, and returns a minimal
`LoginSuccessData` result to the caller.

## Use

Configure the package with URLs that your application controls. A callback
matches only when its scheme, host, port, path, and configured query parameters
match the expected redirect URL. Never pass untrusted redirect URLs.

```dart
final browser = WebOAuthInterceptorClient(
  oauthUrl: authorizationUrl,
  expectedRedirectUrls: [redirectUri],
  specialCookieName: 'session',
  onLoginSuccess: completeLogin,
  onLoginError: showLoginError,
);

await browser.openUrlRequest(
  urlRequest: URLRequest(url: WebUri(authorizationUrl)),
);
```

`AutoFillConfig` is optional and should only be used for credentials the user
explicitly chose to store. The package does not log tokens, cookies, or full
OAuth URLs.

## Development

Run the package checks from this directory:

```sh
flutter test
dart analyze lib test
```

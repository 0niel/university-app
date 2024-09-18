import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

enum WaitUntil { load, domcontentloaded }

class WebAutomationFramework {
  static Future<Browser> launch() async {
    WidgetsFlutterBinding.ensureInitialized();
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
    }
    return Browser._();
  }
}

class Browser {
  Browser._() {
    _defaultBrowserContext = BrowserContext._(this, false);
    _browserContexts.add(_defaultBrowserContext);
  }
  late BrowserContext _defaultBrowserContext;
  final Set<BrowserContext> _browserContexts = {};
  bool _isClosed = false;

  bool isClosed() {
    return _isClosed;
  }

  Future<Page> newPage() async {
    if (_isClosed) {
      throw Exception('Browser is closed!');
    }
    final page = Page._(_defaultBrowserContext);
    _defaultBrowserContext._pages.add(page);
    return page;
  }

  List<Page> pages() {
    return List.from(_defaultBrowserContext._pages);
  }

  BrowserContext defaultBrowserContext() {
    return _defaultBrowserContext;
  }

  BrowserContext createIncognitoBrowserContext() {
    assert(!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS);

    final incognitoBrowserContext = BrowserContext._(this, true);
    _browserContexts.add(incognitoBrowserContext);
    return incognitoBrowserContext;
  }

  Future<String> userAgent() async {
    return InAppWebViewController.getDefaultUserAgent();
  }

  Future<void> close() async {
    if (_isClosed) {
      return;
    }
    _isClosed = true;
    for (final browserContext in _browserContexts) {
      await browserContext.close();
    }
    _browserContexts.clear();
  }
}

class BrowserContext {
  BrowserContext._(this._browser, this._isIncognito);
  final Browser _browser;
  final bool _isIncognito;
  final Set<Page> _pages = {};
  final Map<String, Set<PermissionResourceType>> _permissionMap = {};
  bool _isClosed = false;

  bool isClosed() {
    return _isClosed;
  }

  Future<Page> newPage() async {
    if (_isClosed) {
      throw Exception('BrowserContext is closed!');
    }
    final page = Page._(this);
    _pages.add(page);
    await page._pageCreated.future;
    return page;
  }

  List<Page> pages() {
    return List.from(_pages);
  }

  void overridePermissions({required String origin, required Set<PermissionResourceType> permissions}) {
    _permissionMap[origin] = permissions;
  }

  void clearPermissionOverrides() {
    _permissionMap.clear();
  }

  Future<void> close() async {
    if (_isClosed) {
      return;
    }
    _isClosed = true;
    for (final page in _pages) {
      await page.close();
    }
    _pages.clear();
  }
}

class _WaitForRequestCompleter {
  _WaitForRequestCompleter({this.url, this.predicate});
  String? url;
  Future<bool> Function(URLRequest request)? predicate;
  Completer<URLRequest> completer = Completer<URLRequest>();
}

class _WaitForResponseCompleter {
  _WaitForResponseCompleter({this.url, this.predicate});
  String? url;
  Future<bool> Function(URLResponse response)? predicate;
  Completer<URLResponse> completer = Completer<URLResponse>();
}

class Page {
  Page._(this._browserContext) {
    _webView = InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri('about:blank')),
      initialSettings: InAppWebViewSettings(
        incognito: _browserContext._isIncognito,
        javaScriptCanOpenWindowsAutomatically: true,
        supportMultipleWindows: true,
      ),
      initialUserScripts: UnmodifiableListView([
        UserScript(
          source: """
        window.addEventListener('DOMContentLoaded', function(event) {
          window.flutter_inappwebview.callHandler('DOMContentLoaded', window.location.href);
        });
        """,
          injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
        ),
      ]),
      onWebViewCreated: (controller) {
        _controller = controller;
        controller.addJavaScriptHandler(
          handlerName: 'DOMContentLoaded',
          callback: (arguments) {
            final url = arguments[0] as String;
            if (!_domContentLoaded.isCompleted) {
              _domContentLoaded.complete(url);
            }
            onDOMContentLoaded?.call(url);
          },
        );
      },
      onLoadStart: (controller, url) {
        _resetLoadingState();
        if (!_newNavigationStarted.isCompleted) {
          _newNavigationStarted.complete();
          _newNavigationStarted = Completer<void>();
        }
        if (!_pageStarted.isCompleted) {
          _pageStarted.complete(url?.toString());
        }
      },
      onLoadStop: (controller, url) {
        if (!_pageCreated.isCompleted) {
          _pageCreated.complete();
        }
        if (!_domContentLoaded.isCompleted) {
          _domContentLoaded.complete(url?.toString());
        }
        if (!_pageLoaded.isCompleted) {
          _pageLoaded.complete(url?.toString());
        }
        onLoad?.call(url?.toString());
      },
      onReceivedError: (controller, request, error) async {
        final isForMainFrame = request.isForMainFrame ?? false;
        final url = request.url.toString();
        if (isForMainFrame) {
          if (!_pageStarted.isCompleted) {
            _pageStarted.complete(url);
          }
          if (error.type != WebResourceErrorType.CANCELLED) {
            if (!_domContentLoaded.isCompleted) {
              _domContentLoaded.completeError(error);
            }
            if (!_pageLoaded.isCompleted) {
              _pageLoaded.completeError(error);
            }
          } else {
            if (!_domContentLoaded.isCompleted) {
              _domContentLoaded.complete(url);
            }
            if (!_pageLoaded.isCompleted) {
              _pageLoaded.complete(url);
            }
            onLoad?.call(url);
          }
        }
        onError?.call(request, error);
      },
      onReceivedHttpAuthRequest: (controller, challenge) async {
        final credentials = _credentials;
        if (credentials != null) {
          return HttpAuthResponse(
            action: HttpAuthResponseAction.PROCEED,
            username: credentials.username,
            password: credentials.password,
            permanentPersistence: true,
          );
        }
        return HttpAuthResponse();
      },
      onConsoleMessage: (controller, consoleMessage) async {
        await onConsole?.call(consoleMessage);
      },
      onNavigationResponse: (controller, navigationResponse) async {
        final response = navigationResponse.response;
        if (!_pageResponse.isCompleted && navigationResponse.isForMainFrame && response != null) {
          _pageResponse.complete(response);
        }
        if (response != null && navigationResponse.isForMainFrame) {
          final url = response.url?.toString();
          final completerToRemove = [];
          for (final waitForResponseCompleter in _waitForResponseCompleters) {
            final completer = waitForResponseCompleter.completer;
            final predicate = waitForResponseCompleter.predicate;
            if (!completer.isCompleted) {
              if (url != null && waitForResponseCompleter.url == url) {
                completer.complete(response);
              } else if (predicate != null && await predicate(response)) {
                completer.complete(response);
              }
              if (completer.isCompleted) {
                completerToRemove.add(waitForResponseCompleter);
              }
            }
          }
          _waitForResponseCompleters.removeWhere(completerToRemove.contains);
        }
        if (onResponse != null) {
          return await onResponse?.call(navigationResponse);
        }
        return NavigationResponseAction.ALLOW;
      },
      onPermissionRequest: (controller, permissionRequest) async {
        final permissions = _browserContext._permissionMap[permissionRequest.origin.toString()];
        if (permissions != null) {
          final resources = permissionRequest.resources.where(permissions.contains).toList();
          return PermissionResponse(action: PermissionResponseAction.GRANT, resources: resources);
        }
        return PermissionResponse();
      },
      shouldOverrideUrlLoading: (controller, navigationAction) async {
        final request = navigationAction.request;
        final url = request.url?.toString();
        if (url != null && navigationAction.isForMainFrame) {
          final completerToRemove = [];
          for (final waitForRequestCompleter in _waitForRequestCompleters) {
            final completer = waitForRequestCompleter.completer;
            final predicate = waitForRequestCompleter.predicate;
            if (!completer.isCompleted) {
              if (waitForRequestCompleter.url == url) {
                completer.complete(request);
              } else if (predicate != null && await predicate(request)) {
                completer.complete(request);
              }
              if (completer.isCompleted) {
                completerToRemove.add(waitForRequestCompleter);
              }
            }
          }
          _waitForRequestCompleters.removeWhere(completerToRemove.contains);
        }
        if (onNavigation != null) {
          return await onNavigation?.call(navigationAction);
        }
        return NavigationActionPolicy.ALLOW;
      },
      shouldInterceptRequest: (controller, request) async {
        if (!_requestInterceptionEnabled || onRequest == null) {
          return null;
        }
        return await onRequest?.call(request);
      },
      onCloseWindow: (controller) {
        onClose?.call();
      },
      onCreateWindow: (controller, createWindowAction) async {
        if (onPopup != null) {
          return await onPopup?.call(createWindowAction);
        }
        return false;
      },
      onJsAlert: (controller, jsAlertRequest) async {
        return await onAlertDialog?.call(jsAlertRequest);
      },
      onJsConfirm: (controller, jsConfirmRequest) async {
        return await onConfirmDialog?.call(jsConfirmRequest);
      },
      onJsPrompt: (controller, jsPromptRequest) async {
        return await onPromptDialog?.call(jsPromptRequest);
      },
      onJsBeforeUnload: (controller, jsBeforeUnloadRequest) async {
        return await onBeforeUnloadDialog?.call(jsBeforeUnloadRequest);
      },
    );
  }

  Widget? get widget => _webView;

  final BrowserContext _browserContext;
  bool _isClosed = false;
  InAppWebView? _webView;
  InAppWebViewController? _controller;
  final Completer<void> _pageCreated = Completer<void>();
  Completer<void> _newNavigationStarted = Completer<void>();
  Completer<String?> _pageStarted = Completer<String?>();
  Completer<String?> _pageLoaded = Completer<String?>();
  Completer<String?> _domContentLoaded = Completer<String?>();
  Completer<URLResponse?> _pageResponse = Completer<URLResponse?>();
  Credentials? _credentials;
  final List<UserScript> _userScripts = [];
  bool _requestInterceptionEnabled = false;
  final List<_WaitForRequestCompleter> _waitForRequestCompleters = [];
  final List<_WaitForResponseCompleter> _waitForResponseCompleters = [];

  Future<void> Function(ConsoleMessage consoleMessage)? onConsole;

  Future<void> Function(String? url)? onLoad;

  Future<void> Function(String? url)? onDOMContentLoaded;

  Future<void> Function(WebResourceRequest request, WebResourceError error)? onError;

  Future<NavigationActionPolicy?> Function(NavigationAction navigationAction)? onNavigation;

  Future<WebResourceResponse?> Function(WebResourceRequest request)? onRequest;

  Future<void> Function()? onClose;

  Future<NavigationResponseAction?> Function(NavigationResponse navigationResponse)? onResponse;

  Future<bool?> Function(CreateWindowAction createWindowAction)? onPopup;

  Future<JsAlertResponse?> Function(JsAlertRequest jsAlertRequest)? onAlertDialog;

  Future<JsConfirmResponse?> Function(JsConfirmRequest jsConfirmRequest)? onConfirmDialog;

  Future<JsPromptResponse?> Function(JsPromptRequest jsPromptRequest)? onPromptDialog;

  Future<JsBeforeUnloadResponse?> Function(JsBeforeUnloadRequest jsBeforeUnloadRequest)? onBeforeUnloadDialog;

  void _resetLoadingState() {
    if (!_pageStarted.isCompleted) {
      _pageStarted.complete(null);
    }
    _pageStarted = Completer<String?>();

    if (!_domContentLoaded.isCompleted) {
      _domContentLoaded.complete(null);
    }
    _domContentLoaded = Completer<String?>();

    if (!_pageLoaded.isCompleted) {
      _pageLoaded.complete(null);
    }
    _pageLoaded = Completer<String?>();

    if (!_pageResponse.isCompleted) {
      _pageResponse.complete(null);
    }
    _pageResponse = Completer<URLResponse?>();
  }

  Browser browser() {
    return _browserContext._browser;
  }

  BrowserContext browserContext() {
    return _browserContext;
  }

  bool isClosed() {
    return _isClosed;
  }

  Future<URLResponse?> goto({required String url, int? timeout, WaitUntil? waitUntil, String? referer}) async {
    if (_isClosed) {
      throw Exception('Page is closed!');
    }
    await _controller?.stopLoading();
    _resetLoadingState();
    _controller?.loadUrl(
      urlRequest: URLRequest(
        url: WebUri(url),
        headers: referer != null ? {'Referer': referer} : null,
        timeoutInterval: timeout?.toDouble(),
      ),
    );
    await _pageStarted.future;
    if (waitUntil == WaitUntil.domcontentloaded) {
      await _domContentLoaded.future;
    } else {
      await _pageLoaded.future;
    }
    return _pageResponse.isCompleted ? await _pageResponse.future : null;
  }

  Future<void> type({required String selector, required String text}) async {
    if (_isClosed) {
      throw Exception('Page is closed!');
    }
    final result = await _controller?.evaluateJavascript(
      source: """
    (function() {
      var element = document.querySelector('$selector');
      if (element != null) {
        var text = JSON.parse('${jsonEncode(text)}');
        element.focus();
        for (var char of text) {
          var key = {
            'key': char
          };
          element.dispatchEvent(new KeyboardEvent('keydown', key));
          element.dispatchEvent(new KeyboardEvent('input', key));
          element.dispatchEvent(new KeyboardEvent('keyup', key));
          if ('value' in element) {
            element.value += char;
          }
        }
        return true;
      }
      return false;
    })();
    """,
    );
    if (result != true) {
      throw Exception('No element found for selector "$selector"');
    }
  }

  Future<void> waitForSelector({required String selector, int? polling}) async {
    if (_isClosed) {
      throw Exception('Page is closed!');
    }
    while (await _controller?.evaluateJavascript(source: "document.querySelector('$selector') != null;") != true) {
      if (_controller == null) {
        return;
      }
      // wait a little bit before checking again
      await Future.delayed(Duration(milliseconds: polling ?? 100));
    }
  }

  Future<URLResponse?> waitForNavigation({WaitUntil? waitUntil}) async {
    if (_isClosed) {
      throw Exception('Page is closed!');
    }
    await _newNavigationStarted.future;
    if (waitUntil == WaitUntil.domcontentloaded) {
      await _domContentLoaded.future;
    } else {
      await _pageLoaded.future;
    }
    return _pageResponse.isCompleted ? await _pageResponse.future : null;
  }

  Future<void> waitForFunction({required String source, int? polling}) async {
    if (_isClosed) {
      throw Exception('Page is closed!');
    }
    while (await _controller?.evaluateJavascript(source: source) != true) {
      if (_controller == null) {
        return;
      }
      await Future.delayed(Duration(milliseconds: polling ?? 100));
    }
  }

  Future<URLRequest> waitForRequest({String? url, Future<bool> Function(URLRequest request)? predicate}) async {
    if (_isClosed) {
      throw Exception('Page is closed!');
    }
    assert(url != null || predicate != null);

    final waitForRequestCompleter = _WaitForRequestCompleter(url: url, predicate: predicate);
    _waitForRequestCompleters.add(waitForRequestCompleter);
    return waitForRequestCompleter.completer.future;
  }

  Future<URLResponse> waitForResponse({String? url, Future<bool> Function(URLResponse response)? predicate}) async {
    if (_isClosed) {
      throw Exception('Page is closed!');
    }
    assert(url != null || predicate != null);

    final waitForResponseCompleter = _WaitForResponseCompleter(url: url, predicate: predicate);
    _waitForResponseCompleters.add(waitForResponseCompleter);
    return waitForResponseCompleter.completer.future;
  }

  Future<void> click({required String selector}) async {
    if (_isClosed) {
      throw Exception('Page is closed!');
    }
    final result = await _controller?.evaluateJavascript(
      source: """
    (function() {
      var element = document.querySelector('$selector');
      if (element != null) {
        element.scrollIntoView();
        element.click();
        return true;
      }
      return false;
    })();
    """,
    );
    if (result != true) {
      throw Exception('No element found for selector "$selector"');
    }
  }

  Future<void> tap({required String selector}) async {
    if (_isClosed) {
      throw Exception('Page is closed!');
    }
    final result = await _controller?.evaluateJavascript(
      source: """
    (function() {
      var element = document.querySelector('$selector');
      if (element != null) {
        element.scrollIntoView();
        var touchstartEvent = new TouchEvent('touchstart');
        element.dispatchEvent(touchstartEvent);
        var touchendEvent = new TouchEvent('touchend');
        element.dispatchEvent(touchendEvent);
        return true;
      }
      return false;
    })();
    """,
    );
    if (result != true) {
      throw Exception('No element found for selector "$selector"');
    }
  }

  Future<void> hover({required String selector}) async {
    if (_isClosed) {
      throw Exception('Page is closed!');
    }
    final result = await _controller?.evaluateJavascript(
      source: """
    (function() {
      var element = document.querySelector('$selector');
      if (element != null) {
        var mouseoverEvent = new Event('mouseover');
        element.dispatchEvent(mouseoverEvent);
        return true;
      }
      return false;
    })();
    """,
    );
    if (result != true) {
      throw Exception('No element found for selector "$selector"');
    }
  }

  Future<void> focus({required String selector}) async {
    if (_isClosed) {
      throw Exception('Page is closed!');
    }
    final result = await _controller?.evaluateJavascript(
      source: """
    (function() {
      var element = document.querySelector('$selector');
      if (element != null) {
        element.focus();
        return true;
      }
      return false;
    })();
    """,
    );
    if (result != true) {
      throw Exception('No element found for selector "$selector"');
    }
  }

  Future<dynamic> evaluate({required String source}) async {
    if (_isClosed) {
      throw Exception('Page is closed!');
    }
    return await _controller?.evaluateJavascript(source: source);
  }

  Future<CallAsyncJavaScriptResult?> evaluateAsync({
    required String functionBody,
    Map<String, dynamic> arguments = const <String, dynamic>{},
  }) async {
    if (_isClosed) {
      throw Exception('Page is closed!');
    }
    return await _controller?.callAsyncJavaScript(functionBody: functionBody, arguments: arguments);
  }

  Future<void> evaluateOnNewDocument({required String source}) async {
    if (_isClosed) {
      throw Exception('Page is closed!');
    }
    final userScript = UserScript(source: source, injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START);
    _userScripts.add(userScript);
    _controller?.addUserScript(userScript: userScript);
  }

  Future<void> exposeFunction({required String name, required dynamic Function(List<dynamic>) function}) async {
    if (_isClosed) {
      throw Exception('Page is closed!');
    }
    final source = """
    (function() {
      window['$name'] = function() {
        return window.flutter_inappwebview.callHandler('$name', ...arguments);
      };
    })();
    """;
    _controller?.addJavaScriptHandler(handlerName: name, callback: function);
    await _controller?.evaluateJavascript(source: source);
    final userScript = UserScript(source: source, injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START);
    await _controller?.addUserScript(userScript: userScript);
  }

  Future<URLResponse?> goBack({WaitUntil? waitUntil}) async {
    if (_isClosed) {
      throw Exception('Page is closed!');
    }
    final canGoBack = await _controller?.canGoBack() ?? false;
    if (canGoBack) {
      _resetLoadingState();
      _controller?.goBack();
      await _pageStarted.future;
      if (waitUntil == WaitUntil.domcontentloaded) {
        await _domContentLoaded.future;
      } else {
        await _pageLoaded.future;
      }
      return _pageResponse.isCompleted ? await _pageResponse.future : null;
    }
    return null;
  }

  Future<URLResponse?> goForward({WaitUntil? waitUntil}) async {
    if (_isClosed) {
      throw Exception('Page is closed!');
    }
    final canGoBack = await _controller?.canGoForward() ?? false;
    if (canGoBack) {
      _resetLoadingState();
      _controller?.goForward();
      await _pageStarted.future;
      if (waitUntil == WaitUntil.domcontentloaded) {
        await _domContentLoaded.future;
      } else {
        await _pageLoaded.future;
      }
      return _pageResponse.isCompleted ? await _pageResponse.future : null;
    }
    return null;
  }

  Future<URLResponse?> reload({WaitUntil? waitUntil}) async {
    if (_isClosed) {
      throw Exception('Page is closed!');
    }
    _resetLoadingState();
    _controller?.reload();
    await _pageStarted.future;
    if (waitUntil == WaitUntil.domcontentloaded) {
      await _domContentLoaded.future;
    } else {
      await _pageLoaded.future;
    }
    return _pageResponse.isCompleted ? await _pageResponse.future : null;
  }

  Future<String?> title() async {
    if (_isClosed) {
      throw Exception('Page is closed!');
    }
    return _controller?.getTitle();
  }

  Future<String?> url() async {
    if (_isClosed) {
      throw Exception('Page is closed!');
    }
    return (await _controller?.getUrl())?.toString();
  }

  Future<String?> content() async {
    if (_isClosed) {
      throw Exception('Page is closed!');
    }
    return await _controller?.getHtml();
  }

  void authenticate(Credentials credentials) {
    if (_isClosed) {
      throw Exception('Page is closed!');
    }
    _credentials = credentials;
  }

  Future<void> addScriptTag({String? content, String? id, String? path, String? type, String? url}) async {
    if (_isClosed) {
      throw Exception('Page is closed!');
    }
    if (path != null) {
      content = await rootBundle.loadString(path);
      url = null;
    }
    await _controller?.evaluateJavascript(
      source: """
    (function() {
      var script = document.createElement('script');
      script.id = ${id != null ? '"$id"' : 'null'};
      script.src = ${url != null ? '"$url"' : 'null'};
      script.type = ${type != null ? '"$type"' : 'null'};
      script.innerHTML = ${content != null ? jsonEncode(content) : ''};
      document.body.appendChild(script);
    })();
    """,
    );
  }

  Future<void> addStyleTag({String? content, String? path, String? url}) async {
    if (_isClosed) {
      throw Exception('Page is closed!');
    }
    if (path != null) {
      content = await rootBundle.loadString(path);
      url = null;
    }
    if (url != null) {
      await _controller?.evaluateJavascript(
        source: """
    (function() {
      var link = document.createElement('link');
      link.rel = 'stylesheet';
      link.src = '"$url"';
      document.head.appendChild(link);
    })();
    """,
      );
    } else {
      await _controller?.evaluateJavascript(
        source: """
    (function() {
      var style = document.createElement('style');
      style.type = 'text/css';
      style.innerHTML = ${content != null ? jsonEncode(content) : ''};
      document.head.appendChild(style);
    })();
    """,
      );
    }
  }

  Future<void> setUserAgent(String userAgent) async {
    if (_isClosed) {
      throw Exception('Page is closed!');
    }
    await _controller?.setSettings(settings: InAppWebViewSettings(userAgent: userAgent));
  }

  Future<void> setViewport(Viewport viewport) async {
    if (_isClosed) {
      throw Exception('Page is closed!');
    }
    //await _webView?.setSize(Size(viewport.width, viewport.height));
    final isMobile = viewport.isMobile;
    if (isMobile != null) {
      _controller?.setSettings(
        settings: InAppWebViewSettings(
          preferredContentMode: isMobile ? UserPreferredContentMode.MOBILE : UserPreferredContentMode.DESKTOP,
        ),
      );
    }
  }

  Future<Set<Cookie>> cookies(Set<String>? urls) async {
    if (_isClosed) {
      throw Exception('Page is closed!');
    }
    if (urls == null || urls.isEmpty) {
      final currentUrl = await url();
      if (currentUrl != null) {
        urls = {currentUrl};
      }
    }
    final cookieManager = CookieManager.instance();
    final cookies = <Cookie>{};
    for (final url in urls!) {
      final urlCookies = await cookieManager.getCookies(url: WebUri(url), webViewController: _controller);
      cookies.addAll(urlCookies);
    }
    return cookies;
  }

  Future<void> deleteCookies(Set<Cookie> cookies) async {
    if (_isClosed) {
      throw Exception('Page is closed!');
    }
    final currentUrl = await url();
    if (currentUrl == null) {
      return;
    }
    final cookieManager = CookieManager.instance();
    for (final cookie in cookies) {
      await cookieManager.deleteCookie(
        url: WebUri(currentUrl),
        name: cookie.name,
        domain: cookie.domain,
        path: cookie.path ?? '/',
        webViewController: _controller,
      );
    }
  }

  Future<Uint8List?> createPDF(PDFConfiguration? options) async {
    if (_isClosed) {
      throw Exception('Page is closed!');
    }
    return await _controller?.createPdf(pdfConfiguration: options);
  }

  Future<void> setCookies(Set<Cookie> cookies) async {
    if (_isClosed) {
      throw Exception('Page is closed!');
    }
    final currentUrl = await url();
    if (currentUrl == null) {
      throw Exception('No valid URL available to set cookies.');
    }
    final cookieManager = CookieManager.instance();

    for (final cookie in cookies) {
      await cookieManager.setCookie(
        url: WebUri(currentUrl),
        name: cookie.name,
        value: cookie.value as String,
        domain: cookie.domain,
        path: cookie.path ?? '/',
        webViewController: _controller,
      );
    }
  }

  Future<Uint8List?> screenshot(ScreenshotConfiguration? options) async {
    if (_isClosed) {
      throw Exception('Page is closed!');
    }
    return await _controller?.takeScreenshot(screenshotConfiguration: options);
  }

  Future<void> emulate(Device device) async {
    if (_isClosed) {
      throw Exception('Page is closed!');
    }
    await setUserAgent(device.userAgent);
    await setViewport(device.viewport);
  }

  Future<void> setJavaScriptEnabled(bool enabled) async {
    if (_isClosed) {
      throw Exception('Page is closed!');
    }
    await _controller?.setSettings(settings: InAppWebViewSettings(javaScriptEnabled: enabled));
  }

  Future<bool?> isJavaScriptEnabled() async {
    if (_isClosed) {
      throw Exception('Page is closed!');
    }
    return (await _controller?.getSettings())?.javaScriptEnabled;
  }

  Future<void> setOfflineMode(bool enabled) async {
    if (_isClosed) {
      throw Exception('Page is closed!');
    }
    await _controller?.setSettings(settings: InAppWebViewSettings(networkAvailable: !enabled));
  }

  void setRequestInterception(bool enabled) {
    if (_isClosed) {
      throw Exception('Page is closed!');
    }
    _requestInterceptionEnabled = enabled;
  }

  Future<void> close() async {
    if (_isClosed) {
      return;
    }
    _isClosed = true;
    _resetLoadingState();
    _userScripts.clear();
    _waitForRequestCompleters.clear();
    _waitForResponseCompleters.clear();
    onConsole = null;
    onLoad = null;
    onDOMContentLoaded = null;
    onError = null;
    onRequest = null;
    onResponse = null;
    onClose = null;
    onPopup = null;
    onAlertDialog = null;
    onConfirmDialog = null;
    onPromptDialog = null;
    onBeforeUnloadDialog = null;
    _controller = null;
    _webView = null;
  }
}

class Credentials {
  Credentials(this.username, this.password);
  String username;
  String password;
}

class Viewport {
  Viewport({required this.height, required this.width, this.isMobile});
  double height;
  double width;
  bool? isMobile;
}

class Device {
  Device({required this.userAgent, required this.viewport});
  String userAgent;
  Viewport viewport;
}

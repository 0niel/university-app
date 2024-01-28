import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:neon_framework/widgets.dart';
import 'package:neon_news/l10n/localizations.dart';
import 'package:neon_news/src/blocs/article.dart';
import 'package:neon_news/src/blocs/articles.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsArticlePage extends StatefulWidget {
  const NewsArticlePage({
    required this.bloc,
    required this.articlesBloc,
    required this.useWebView,
    this.bodyData,
    this.url,
    super.key,
  })  : assert(useWebView || bodyData != null, 'bodyData has to be set when not using a WebView'),
        assert(!useWebView || url != null, 'url has to be set when using a WebView');

  final NewsArticleBloc bloc;
  final NewsArticlesBloc articlesBloc;
  final bool useWebView;
  final String? bodyData;
  final String? url;

  @override
  State<NewsArticlePage> createState() => _NewsArticlePageState();
}

class _NewsArticlePageState extends State<NewsArticlePage> {
  WebViewController? _webviewController;
  Timer? _markAsReadTimer;
  bool loading = false;

  @override
  void initState() {
    super.initState();

    widget.bloc.errors.listen((error) {
      NeonError.showSnackbar(context, error);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(WakelockPlus.enable());
    });

    if (widget.useWebView) {
      _webviewController = WebViewController()
        // ignore: discarded_futures
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        // ignore: discarded_futures
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (_) {
              setState(() {
                loading = true;
              });
            },
            onPageFinished: (_) async {
              setState(() {
                loading = false;
              });
              await _startMarkAsReadTimer();
            },
          ),
        )
        // ignore: discarded_futures
        ..loadRequest(Uri.parse(widget.url!));
    } else {
      unawaited(_startMarkAsReadTimer());
    }
  }

  @override
  void dispose() {
    _cancelMarkAsReadTimer();

    super.dispose();
  }

  Future<void> _startMarkAsReadTimer() async {
    if (await widget.bloc.unread.first) {
      if (widget.articlesBloc.options.articleDisableMarkAsReadTimeoutOption.value) {
        widget.bloc.markArticleAsRead();
      } else {
        _markAsReadTimer = Timer(const Duration(seconds: 3), () async {
          if (await widget.bloc.unread.first) {
            widget.bloc.markArticleAsRead();
          }
        });
      }
    }
  }

  void _cancelMarkAsReadTimer() {
    if (_markAsReadTimer != null) {
      _markAsReadTimer!.cancel();
      _markAsReadTimer = null;
    }
  }

  Future<String> _getURL() async {
    if (_webviewController != null) {
      return (await _webviewController!.currentUrl())!;
    }

    return widget.url!;
  }

  @override
  Widget build(BuildContext context) => BackButtonListener(
        onBackButtonPressed: () async {
          if (_webviewController != null && await _webviewController!.canGoBack()) {
            await _webviewController!.goBack();
            return true;
          }

          unawaited(WakelockPlus.disable());

          return false;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            actions: [
              if (loading)
                const SizedBox.square(
                  dimension: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              StreamBuilder<bool>(
                stream: widget.bloc.starred,
                builder: (context, starredSnapshot) {
                  final starred = starredSnapshot.data ?? false;
                  return IconButton(
                    onPressed: () async {
                      if (starred) {
                        widget.bloc.unstarArticle();
                      } else {
                        widget.bloc.starArticle();
                      }
                    },
                    tooltip: starred
                        ? NewsLocalizations.of(context).articleUnstar
                        : NewsLocalizations.of(context).articleStar,
                    icon: Icon(starred ? Icons.star : Icons.star_outline),
                  );
                },
              ),
              StreamBuilder<bool>(
                stream: widget.bloc.unread,
                builder: (context, unreadSnapshot) {
                  final unread = unreadSnapshot.data ?? false;
                  return IconButton(
                    onPressed: () async {
                      if (unread) {
                        widget.bloc.markArticleAsRead();
                      } else {
                        widget.bloc.markArticleAsUnread();
                      }
                    },
                    tooltip: unread
                        ? NewsLocalizations.of(context).articleMarkRead
                        : NewsLocalizations.of(context).articleMarkUnread,
                    icon: Icon(unread ? MdiIcons.email : MdiIcons.emailMarkAsUnread),
                  );
                },
              ),
              if (widget.url != null) ...[
                IconButton(
                  onPressed: () async {
                    await launchUrlString(
                      await _getURL(),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  tooltip: NewsLocalizations.of(context).articleOpenLink,
                  icon: const Icon(Icons.open_in_new),
                ),
                IconButton(
                  onPressed: () async {
                    await Share.share(await _getURL());
                  },
                  tooltip: NewsLocalizations.of(context).articleShare,
                  icon: const Icon(Icons.share),
                ),
              ],
            ],
          ),
          body: SafeArea(
            child: widget.useWebView
                ? WebViewWidget(
                    controller: _webviewController!,
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(10),
                    child: Html(
                      data: widget.bodyData,
                      onLinkTap: (url, attributes, element) async {
                        if (url != null) {
                          await launchUrlString(
                            url,
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      },
                    ),
                  ),
          ),
        ),
      );
}

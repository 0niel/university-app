import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollDirection;
import 'package:rtu_mirea_app/feed/view/feed_view.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/search/search.dart';

part 'feed_header.dart';

class NewsFeedPage extends StatefulWidget {
  const NewsFeedPage({super.key});

  @override
  State<NewsFeedPage> createState() => _NewsFeedPageState();
}

class _NewsFeedPageState extends State<NewsFeedPage> {
  bool _headerVisible = true;

  void _onScrollNotification(ScrollNotification notification) {
    if (notification.metrics.axis != Axis.vertical) return;
    if (notification is UserScrollNotification) {
      final visible = switch (notification.direction) {
        ScrollDirection.reverse => false,
        ScrollDirection.forward => true,
        ScrollDirection.idle => notification.metrics.pixels <= 0,
      };
      if (visible != _headerVisible) {
        setState(() => _headerVisible = visible);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final reduceMotion =
        (MediaQuery.maybeDisableAnimationsOf(context) ?? false) ||
        (MediaQuery.maybeAccessibleNavigationOf(context) ?? false);
    return Scaffold(
      backgroundColor: colors.canvas,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ClipRect(
              child: AnimatedAlign(
                alignment: Alignment.topCenter,
                heightFactor: _headerVisible ? 1 : 0,
                duration: reduceMotion
                    ? Duration.zero
                    : const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                child: const _FeedHeader(),
              ),
            ),
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  _onScrollNotification(notification);
                  return false;
                },
                child: const FeedView(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

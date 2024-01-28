import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:neon_framework/blocs.dart';
import 'package:neon_framework/sort_box.dart';
import 'package:neon_framework/utils.dart';
import 'package:neon_framework/widgets.dart';
import 'package:neon_news/l10n/localizations.dart';
import 'package:neon_news/src/blocs/news.dart';
import 'package:neon_news/src/options.dart';
import 'package:neon_news/src/pages/feed.dart';
import 'package:neon_news/src/sort/feeds.dart';
import 'package:neon_news/src/widgets/dialog.dart';
import 'package:neon_news/src/widgets/feed_icon.dart';
import 'package:neon_news/utils/dialog.dart';
import 'package:nextcloud/news.dart' as news;

class NewsFeedsView extends StatelessWidget {
  const NewsFeedsView({
    required this.bloc,
    this.folderID,
    super.key,
  });

  final NewsBloc bloc;
  final int? folderID;

  @override
  Widget build(BuildContext context) => ResultBuilder<BuiltList<news.Folder>>.behaviorSubject(
        subject: bloc.folders,
        builder: (context, folders) => ResultBuilder<BuiltList<news.Feed>>.behaviorSubject(
          subject: bloc.feeds,
          builder: (context, feeds) => SortBoxBuilder<FeedsSortProperty, news.Feed>(
            sortBox: feedsSortBox,
            sortProperty: bloc.options.feedsSortPropertyOption,
            sortBoxOrder: bloc.options.feedsSortBoxOrderOption,
            input:
                folders.hasData ? feeds.data?.where((f) => folderID == null || f.folderId == folderID).toList() : null,
            builder: (context, sorted) => NeonListView(
              scrollKey: 'news-feeds',
              isLoading: feeds.isLoading || folders.isLoading,
              error: feeds.error ?? folders.error,
              onRefresh: bloc.refresh,
              itemCount: sorted.length,
              itemBuilder: (context, index) => _buildFeed(
                context,
                sorted[index],
                folders.requireData,
              ),
            ),
          ),
        ),
      );

  Widget _buildFeed(
    BuildContext context,
    news.Feed feed,
    BuiltList<news.Folder> folders,
  ) =>
      ListTile(
        title: Text(
          feed.title,
          style: feed.unreadCount! == 0
              ? Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).disabledColor)
              : null,
        ),
        subtitle: feed.unreadCount! > 0
            ? Text(NewsLocalizations.of(context).articlesUnread(feed.unreadCount!))
            : const SizedBox(),
        leading: NewsFeedIcon(feed: feed),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (feed.updateErrorCount > 0)
              IconButton(
                onPressed: () async => showAdaptiveDialog<void>(
                  context: context,
                  builder: (context) => NewsFeedUpdateErrorDialog(
                    feed: feed,
                  ),
                ),
                tooltip: NewsLocalizations.of(context).feedShowErrorMessage,
                iconSize: 30,
                icon: Text(
                  feed.updateErrorCount.toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            PopupMenuButton<NewsFeedAction>(
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: NewsFeedAction.showURL,
                  child: Text(NewsLocalizations.of(context).feedShowURL),
                ),
                PopupMenuItem(
                  value: NewsFeedAction.delete,
                  child: Text(NewsLocalizations.of(context).actionDelete),
                ),
                PopupMenuItem(
                  value: NewsFeedAction.rename,
                  child: Text(NewsLocalizations.of(context).actionRename),
                ),
                if (folders.isNotEmpty)
                  PopupMenuItem(
                    value: NewsFeedAction.move,
                    child: Text(NewsLocalizations.of(context).actionMove),
                  ),
              ],
              onSelected: (action) async {
                switch (action) {
                  case NewsFeedAction.showURL:
                    await showAdaptiveDialog<void>(
                      context: context,
                      builder: (context) => NewsFeedShowURLDialog(
                        feed: feed,
                      ),
                    );
                  case NewsFeedAction.delete:
                    if (!context.mounted) {
                      return;
                    }
                    final result = await showDeleteFeedDialog(context, feed);

                    if (result) {
                      bloc.removeFeed(feed.id);
                    }
                  case NewsFeedAction.rename:
                    if (!context.mounted) {
                      return;
                    }
                    final result = await showRenameDialog(
                      context: context,
                      title: NewsLocalizations.of(context).feedRename,
                      initialValue: feed.title,
                    );
                    if (result != null) {
                      bloc.renameFeed(feed.id, result);
                    }
                  case NewsFeedAction.move:
                    if (!context.mounted) {
                      return;
                    }
                    final result = await showAdaptiveDialog<int?>(
                      context: context,
                      builder: (context) => NewsMoveFeedDialog(
                        folders: folders,
                        feed: feed,
                      ),
                    );
                    if (result != null && result != feed.folderId) {
                      bloc.moveFeed(feed.id, result);
                    }
                }
              },
            ),
          ],
        ),
        onLongPress: () {
          if (feed.unreadCount! > 0) {
            bloc.markFeedAsRead(feed.id);
          }
        },
        onTap: () async {
          await Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) => NewsFeedPage(
                bloc: bloc,
                feed: feed,
              ),
            ),
          );
        },
      );
}

enum NewsFeedAction {
  showURL,
  delete,
  rename,
  move,
}

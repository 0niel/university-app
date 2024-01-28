import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neon_framework/blocs.dart';
import 'package:neon_framework/utils.dart';
import 'package:neon_framework/widgets.dart';
import 'package:neon_news/l10n/localizations.dart';
import 'package:neon_news/src/blocs/news.dart';
import 'package:neon_news/src/widgets/folder_select.dart';
import 'package:nextcloud/news.dart' as news;

/// A dialog for adding a news feed by url.
///
/// When created a record with `(String url, int? folderId)` will be popped.
class NewsAddFeedDialog extends StatefulWidget {
  /// Creates a new add feed dialog.
  const NewsAddFeedDialog({
    required this.bloc,
    this.folderID,
    super.key,
  });

  /// The active client bloc.
  final NewsBloc bloc;

  /// The initial id of the folder the feed is in.
  final int? folderID;

  @override
  State<NewsAddFeedDialog> createState() => _NewsAddFeedDialogState();
}

class _NewsAddFeedDialogState extends State<NewsAddFeedDialog> {
  final formKey = GlobalKey<FormState>();
  final controller = TextEditingController();

  news.Folder? folder;

  void submit() {
    if (formKey.currentState!.validate()) {
      Navigator.of(context).pop((controller.text, widget.folderID ?? folder?.id));
    }
  }

  @override
  void initState() {
    super.initState();

    unawaited(
      Clipboard.getData(Clipboard.kTextPlain).then((clipboardContent) {
        if (clipboardContent != null && clipboardContent.text != null) {
          final uri = Uri.tryParse(clipboardContent.text!);
          if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
            controller.text = clipboardContent.text!;
          }
        }
      }),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final urlField = Form(
      key: formKey,
      child: TextFormField(
        autofocus: true,
        controller: controller,
        decoration: const InputDecoration(
          hintText: 'https://...',
        ),
        keyboardType: TextInputType.url,
        validator: (input) => validateHttpUrl(context, input),
        onFieldSubmitted: (_) {
          submit();
        },
        autofillHints: const [AutofillHints.url],
      ),
    );

    final folderSelector = ResultBuilder<BuiltList<news.Folder>>.behaviorSubject(
      subject: widget.bloc.folders,
      builder: (context, folders) {
        if (folders.hasError) {
          return Center(
            child: NeonError(
              folders.error,
              onRetry: widget.bloc.refresh,
            ),
          );
        }
        if (!folders.hasData) {
          return Center(
            child: NeonLinearProgressIndicator(
              visible: folders.isLoading,
            ),
          );
        }

        return NewsFolderSelect(
          folders: folders.requireData,
          value: folder,
          onChanged: (f) {
            setState(() {
              folder = f;
            });
          },
        );
      },
    );

    return NeonDialog(
      title: Text(NewsLocalizations.of(context).feedAdd),
      content: Material(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            urlField,
            const SizedBox(height: 8),
            folderSelector,
          ],
        ),
      ),
      actions: [
        NeonDialogAction(
          isDefaultAction: true,
          onPressed: submit,
          child: Text(
            NewsLocalizations.of(context).feedAdd,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

/// A dialog for displaying the url of a news feed.
class NewsFeedShowURLDialog extends StatelessWidget {
  /// Creates a new display url dialog.
  const NewsFeedShowURLDialog({
    required this.feed,
    super.key,
  });

  /// The feed to display the url for.
  final news.Feed feed;

  @override
  Widget build(BuildContext context) => NeonDialog(
        title: Text(feed.url),
        actions: [
          NeonDialogAction(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              NeonLocalizations.of(context).actionClose,
              textAlign: TextAlign.end,
            ),
          ),
          NeonDialogAction(
            isDefaultAction: true,
            onPressed: () async {
              await Clipboard.setData(
                ClipboardData(
                  text: feed.url,
                ),
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(NewsLocalizations.of(context).feedCopiedURL),
                  ),
                );
                Navigator.of(context).pop();
              }
            },
            child: Text(
              NewsLocalizations.of(context).feedCopyURL,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      );
}

class NewsFeedUpdateErrorDialog extends StatelessWidget {
  const NewsFeedUpdateErrorDialog({
    required this.feed,
    super.key,
  });

  final news.Feed feed;

  @override
  Widget build(BuildContext context) => NeonDialog(
        title: Text(feed.lastUpdateError!),
        actions: [
          NeonDialogAction(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              NeonLocalizations.of(context).actionClose,
              textAlign: TextAlign.end,
            ),
          ),
          NeonDialogAction(
            isDefaultAction: true,
            onPressed: () async {
              await Clipboard.setData(
                ClipboardData(
                  text: feed.lastUpdateError!,
                ),
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(NewsLocalizations.of(context).feedCopiedErrorMessage),
                  ),
                );
                Navigator.of(context).pop();
              }
            },
            child: Text(
              NewsLocalizations.of(context).feedCopyErrorMessage,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      );
}

/// A dialog for moving a news feed by into a different folder.
///
/// When moved the id of the new folder will be popped.
class NewsMoveFeedDialog extends StatefulWidget {
  /// Creates a new move feed dialog.
  const NewsMoveFeedDialog({
    required this.folders,
    required this.feed,
    super.key,
  });

  /// The list of available folders.
  final BuiltList<news.Folder> folders;

  /// The feed to move.
  final news.Feed feed;

  @override
  State<NewsMoveFeedDialog> createState() => _NewsMoveFeedDialogState();
}

class _NewsMoveFeedDialogState extends State<NewsMoveFeedDialog> {
  final formKey = GlobalKey<FormState>();

  news.Folder? folder;

  void submit() {
    if (formKey.currentState!.validate()) {
      Navigator.of(context).pop(folder?.id);
    }
  }

  @override
  void initState() {
    folder = widget.folders.singleWhereOrNull((folder) => folder.id == widget.feed.folderId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) => NeonDialog(
        title: Text(NewsLocalizations.of(context).feedMove),
        content: Material(
          child: Form(
            key: formKey,
            child: NewsFolderSelect(
              folders: widget.folders,
              value: folder,
              onChanged: (f) {
                setState(() {
                  folder = f;
                });
              },
            ),
          ),
        ),
        actions: [
          NeonDialogAction(
            isDefaultAction: true,
            onPressed: submit,
            child: Text(
              NewsLocalizations.of(context).feedMove,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      );
}

/// A [NeonDialog] that shows for renaming creating a new folder.
///
/// Use `showFolderCreateDialog` to display this dialog.
///
/// When submitted the folder name will be popped as a `String`.
class NewsCreateFolderDialog extends StatefulWidget {
  /// Creates a new NeonDialog for creating a folder.
  const NewsCreateFolderDialog({
    super.key,
  });

  @override
  State<NewsCreateFolderDialog> createState() => _NewsCreateFolderDialogState();
}

class _NewsCreateFolderDialogState extends State<NewsCreateFolderDialog> {
  final formKey = GlobalKey<FormState>();
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void submit() {
    if (formKey.currentState!.validate()) {
      Navigator.of(context).pop(controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = Material(
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: NewsLocalizations.of(context).folderCreateName,
        ),
        autofocus: true,
        validator: (input) => validateNotEmpty(context, input),
        onFieldSubmitted: (_) {
          submit();
        },
      ),
    );

    return NeonDialog(
      title: Text(NewsLocalizations.of(context).folderCreate),
      content: Form(
        key: formKey,
        child: content,
      ),
      actions: [
        NeonDialogAction(
          isDefaultAction: true,
          onPressed: submit,
          child: Text(
            NewsLocalizations.of(context).folderCreate,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

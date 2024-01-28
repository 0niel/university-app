import 'package:flutter/material.dart';
import 'package:neon_news/src/blocs/news.dart';
import 'package:neon_news/src/widgets/feed_floating_action_button.dart';
import 'package:neon_news/src/widgets/folder_view.dart';
import 'package:nextcloud/news.dart' as news;

class NewsFolderPage extends StatelessWidget {
  const NewsFolderPage({
    required this.bloc,
    required this.folder,
    super.key,
  });

  final NewsBloc bloc;
  final news.Folder folder;

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(folder.name),
        ),
        body: SafeArea(
          child: NewsFolderView(
            bloc: bloc,
            folder: folder,
          ),
        ),
        floatingActionButton: NewsFeedFloatingActionButton(
          bloc: bloc,
          folderID: folder.id,
        ),
      );
}

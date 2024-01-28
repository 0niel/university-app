import 'package:flutter/material.dart';
import 'package:neon_framework/blocs.dart';
import 'package:neon_framework/utils.dart';
import 'package:neon_news/src/blocs/articles.dart';
import 'package:neon_news/src/blocs/news.dart';
import 'package:neon_news/src/options.dart';
import 'package:neon_news/src/widgets/articles_view.dart';
import 'package:neon_news/src/widgets/feeds_view.dart';
import 'package:nextcloud/news.dart' as news;

class NewsFolderView extends StatefulWidget {
  const NewsFolderView({
    required this.bloc,
    required this.folder,
    super.key,
  });

  final NewsBloc bloc;
  final news.Folder folder;

  @override
  State<NewsFolderView> createState() => _NewsFolderViewState();
}

class _NewsFolderViewState extends State<NewsFolderView> {
  late final option = widget.bloc.options.defaultFolderViewTypeOption;
  late DefaultFolderViewType _viewType = option.value;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: DropdownButton<DefaultFolderViewType>(
              isExpanded: true,
              value: _viewType,
              items: option.values.keys
                  .map(
                    (key) => DropdownMenuItem<DefaultFolderViewType>(
                      value: key,
                      child: Text(option.values[key]!(context)),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _viewType = value!;
                });
              },
            ),
          ),
          Expanded(
            child: _viewType == DefaultFolderViewType.articles
                ? NewsArticlesView(
                    bloc: NewsArticlesBloc(
                      widget.bloc,
                      widget.bloc.options,
                      NeonProvider.of<AccountsBloc>(context).activeAccount.value!,
                      id: widget.folder.id,
                      listType: ListType.folder,
                    ),
                    newsBloc: widget.bloc,
                  )
                : NewsFeedsView(
                    bloc: widget.bloc,
                    folderID: widget.folder.id,
                  ),
          ),
        ],
      );
}

import 'package:discourse_repository/discourse_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:flutter_html_video/flutter_html_video.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/discourse_post_overview/bloc/post_overview_bloc.dart';
import 'package:app_ui/app_ui.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DiscoursePostOverviewPageView extends StatelessWidget {
  const DiscoursePostOverviewPageView({required this.postId, super.key});

  final int postId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Пост'),
      ),
      body: BlocProvider<PostOverviewBloc>(
        create: (context) => PostOverviewBloc(
          discourseRepository: context.read<DiscourseRepository>(),
        )..add(PostRequested(postId: postId)),
        child: const _PostOverview(),
      ),
    );
  }
}

class _PostOverview extends StatelessWidget {
  const _PostOverview();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostOverviewBloc, PostOverviewState>(
      builder: (context, state) {
        if (state.status == PostOverviewStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.status == PostOverviewStatus.loaded) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundImage: NetworkImage(
                          'https://mirea.ninja/${state.post!.avatarTemplate.replaceAll('{size}', '100')}',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(state.post!.username, style: AppTextStyle.title),
                      const Spacer(),
                      Text(DateFormat('dd.MM.yyyy HH:mm').format(DateTime.parse(state.post!.createdAt)),
                          style: AppTextStyle.bodyBold),
                    ],
                  ),
                  Html(
                    data: state.post!.cooked,
                    extensions: const [
                      TableHtmlExtension(),
                      VideoHtmlExtension(),
                    ],
                    style: {
                      "h1": Style(
                        color: Theme.of(context).extension<AppColors>()!.active,
                        fontStyle: AppTextStyle.h1.fontStyle,
                        fontSize: FontSize(24),
                        lineHeight: const LineHeight(1.5),
                      ),
                      "h2": Style(
                        color: Theme.of(context).extension<AppColors>()!.active,
                        fontStyle: AppTextStyle.h2.fontStyle,
                        fontSize: FontSize(20),
                        lineHeight: const LineHeight(1.5),
                      ),
                      "h3": Style(
                        color: Theme.of(context).extension<AppColors>()!.active,
                        fontStyle: AppTextStyle.h3.fontStyle,
                        fontSize: FontSize(18),
                        lineHeight: const LineHeight(1.5),
                      ),
                      "h4": Style(
                        color: Theme.of(context).extension<AppColors>()!.active,
                        fontStyle: AppTextStyle.h4.fontStyle,
                        fontSize: FontSize(16),
                        lineHeight: const LineHeight(1.5),
                      ),
                      "h5": Style(
                        color: Theme.of(context).extension<AppColors>()!.active,
                        fontStyle: AppTextStyle.h5.fontStyle,
                        fontSize: FontSize(14),
                        lineHeight: const LineHeight(1.5),
                      ),
                      "h6": Style(
                        color: Theme.of(context).extension<AppColors>()!.active,
                        fontStyle: AppTextStyle.h6.fontStyle,
                        fontSize: FontSize(12),
                        lineHeight: const LineHeight(1.5),
                      ),
                      "body": Style(
                        color: Theme.of(context).extension<AppColors>()!.active,
                        fontStyle: AppTextStyle.bodyRegular
                            .copyWith(
                              color: Theme.of(context).extension<AppColors>()!.active,
                            )
                            .fontStyle,
                        fontSize: FontSize(16),
                        lineHeight: const LineHeight(1.5),
                      ),
                      "a": Style(
                        color: Theme.of(context).extension<AppColors>()!.colorful03,
                        fontStyle: AppTextStyle.bodyRegular.fontStyle,
                        fontSize: FontSize(16),
                        lineHeight: const LineHeight(1.5),
                      ),
                      "p": Style(
                        color: Theme.of(context).extension<AppColors>()!.active,
                        fontStyle: AppTextStyle.bodyRegular
                            .copyWith(
                              color: Theme.of(context).extension<AppColors>()!.active,
                            )
                            .fontStyle,
                        fontSize: FontSize(16),
                        lineHeight: const LineHeight(1.5),
                      ),
                    },
                    onLinkTap: (String? url, Map<String, String> attributes, _) {
                      if (url != null) {
                        launchUrlString(url, mode: LaunchMode.externalApplication);
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        } else if (state.status == PostOverviewStatus.failure) {
          return const Center(
            child: Text('Ошибка при загрузке поста'),
          );
        } else {
          return const Center(
            child: Text('Ошибка при загрузке поста'),
          );
        }
      },
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:discourse_repository/discourse_repository.dart';
import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';
import 'package:url_launcher/url_launcher_string.dart';

class TopicCard extends StatelessWidget {
  const TopicCard({super.key, required this.topic, this.author});

  final Topic topic;
  final User? author;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 320,
        maxWidth: MediaQuery.of(context).size.width - 64,
      ),
      child: Card(
        child: PlatformInkWell(
          onTap: () {
            launchUrlString('https://mirea.ninja/t/${topic.id}');
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: 128,
                      child: topic.imageUrl != null
                          ? CachedNetworkImage(
                              imageUrl: topic.imageUrl!,
                              placeholder: (context, url) => const ImagePlaceholder(),
                              errorWidget: (context, url, error) => const ImagePlaceholder(),
                              imageBuilder: (context, imageProvider) => Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFFFB8E0),
                                    Color(0xFFBE9EFF),
                                    Color(0xFF88C0FC),
                                    Color(0xFF86FF99),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Assets.icons.imagePlaceholder.svg(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                        'https://mirea.ninja/${author?.avatarTemplate.replaceAll('{size}', '64')}',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            topic.title,
                            style: AppTextStyle.titleM,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  topic.excerpt ?? '',
                                  style: AppTextStyle.body,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Column(
                                    children: [
                                      Icon(
                                        Icons.remove_red_eye_rounded,
                                        color: Theme.of(context).extension<AppColors>()!.deactive,
                                      ),
                                      Text(
                                        topic.views.toString(),
                                        style: AppTextStyle.captionS
                                            .copyWith(color: Theme.of(context).extension<AppColors>()!.deactive),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 4),
                                  Column(
                                    children: [
                                      Icon(
                                        Icons.favorite_rounded,
                                        color: Theme.of(context).extension<AppColors>()!.deactive,
                                      ),
                                      Text(
                                        topic.likeCount.toString(),
                                        style: AppTextStyle.captionS
                                            .copyWith(color: Theme.of(context).extension<AppColors>()!.deactive),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

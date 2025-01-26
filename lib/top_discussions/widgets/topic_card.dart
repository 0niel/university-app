import 'package:cached_network_image/cached_network_image.dart';
import 'package:discourse_repository/discourse_repository.dart';
import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_ui/app_ui.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'dart:math' as math;

class TopicCard extends StatefulWidget {
  const TopicCard({super.key, required this.topic, this.author});

  final Topic topic;
  final User? author;

  @override
  State<TopicCard> createState() => _TopicCardState();
}

class _TopicCardState extends State<TopicCard> {
  @override
  Widget build(BuildContext context) {
    final availableWidth = MediaQuery.of(context).size.width - 64;
    final cardMinWidth = math.min(320, availableWidth);

    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: cardMinWidth.toDouble(),
        maxWidth: availableWidth,
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 2,
        child: PlatformInkWell(
          onTap: () {
            launchUrlString('https://mirea.ninja/t/${widget.topic.id}');
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopicImage(),
                const SizedBox(height: 12),
                _buildAuthorInfo(),
                const SizedBox(height: 6),
                Text(
                  widget.topic.excerpt ?? '',
                  style: AppTextStyle.body,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                _buildTopicStats(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopicImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 128,
        width: double.infinity,
        child: widget.topic.imageUrl != null
            ? CachedNetworkImage(
                imageUrl: widget.topic.imageUrl!,
                placeholder: (context, url) => const ImagePlaceholder(),
                errorWidget: (context, url, error) => const ImagePlaceholder(),
                fit: BoxFit.cover,
              )
            : Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
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
                    width: 48,
                    height: 48,
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildAuthorInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundImage: widget.author != null
              ? CachedNetworkImageProvider(
                  'https://mirea.ninja/${widget.author!.avatarTemplate.replaceAll('{size}', '64')}',
                )
              : null,
          radius: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.topic.title,
                style: AppTextStyle.titleM,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (widget.author != null)
                Text(
                  widget.author!.username,
                  style: AppTextStyle.captionS.copyWith(
                    color: Theme.of(context).extension<AppColors>()!.deactive,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTopicStats() {
    return Row(
      children: [
        Text(
          DateFormat.yMMMd().format(DateTime.parse(widget.topic.createdAt)),
          style: AppTextStyle.captionS.copyWith(
            color: Theme.of(context).extension<AppColors>()!.deactive,
          ),
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _IconStat(
              icon: Icons.remove_red_eye_rounded,
              count: widget.topic.views,
            ),
            const SizedBox(width: 16),
            _IconStat(
              icon: Icons.favorite_rounded,
              count: widget.topic.likeCount,
            ),
          ],
        ),
      ],
    );
  }
}

class _IconStat extends StatelessWidget {
  const _IconStat({
    required this.icon,
    required this.count,
  });

  final IconData icon;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: Theme.of(context).extension<AppColors>()!.deactive,
        ),
        const SizedBox(width: 4),
        Text(
          '$count',
          style: AppTextStyle.captionS.copyWith(
            color: Theme.of(context).extension<AppColors>()!.deactive,
          ),
        ),
      ],
    );
  }
}

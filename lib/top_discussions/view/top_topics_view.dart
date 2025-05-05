import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:discourse_repository/discourse_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/top_discussions/bloc/discourse_bloc.dart';

class TopTopicsView extends StatelessWidget {
  const TopTopicsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DiscourseBloc>(
      create:
          (context) =>
              DiscourseBloc(discourseRepository: context.read<DiscourseRepository>())
                ..add(const DiscourseTopTopicsLoadRequest()),
      child: const _TopTopicsView(),
    );
  }
}

class _TopTopicsView extends StatelessWidget {
  const _TopTopicsView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscourseBloc, DiscourseState>(
      builder: (context, state) {
        if (state.status == DiscourseStatus.loaded) {
          final top = state.topTopics?.topicList.topics.take(15).toList() ?? [];

          return top.isNotEmpty
              ? SizedBox(
                height: 210,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(left: 16, right: 8, bottom: 4),
                  itemCount: top.length,
                  itemBuilder: (context, index) {
                    final topic = top[index];
                    final author = state.topTopics?.users.firstWhereOrNull(
                      (user) => topic.posters.first['user_id'] == user.id,
                    );

                    return _buildDiscussionCard(
                      context,
                      title: topic.title,
                      votes: topic.likeCount,
                      comments: topic.postsCount - 1, // Subtract 1 for the original post
                      author: author?.username ?? 'Unknown',
                      timeAgo: _getTimeAgo(topic.lastPostedAt == null ? null : DateTime.tryParse(topic.lastPostedAt)),
                      avatarUrl: _getAvatarUrl(author),
                      url: 'https://mirea.ninja/t/${topic.id}',
                    );
                  },
                ),
              )
              : const SizedBox.shrink();
        } else if (state.status == DiscourseStatus.loading) {
          return SizedBox(
            height: 210,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(left: 16, right: 8, bottom: 4),
              itemCount: 5,
              itemBuilder: (context, index) {
                return _buildSkeletonCard(context);
              },
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  String _getTimeAgo(DateTime? dateTime) {
    if (dateTime == null) return '';

    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) {
      return '${difference.inDays} д. назад';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ч. назад';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} мин. назад';
    } else {
      return 'только что';
    }
  }

  String _getAvatarUrl(User? user) {
    if (user == null || user.avatarTemplate.isEmpty) {
      return 'https://mirea.ninja/letter_avatar_proxy/v4/letter/u/5f9b8f/48.png';
    }

    // Replace {size} with actual size
    return 'https://mirea.ninja/${user.avatarTemplate.replaceAll('{size}', '48')}';
  }

  Widget _buildSkeletonCard(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: isDarkMode ? colors.background02 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 16, backgroundColor: colors.background03.withOpacity(0.3)),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100,
                      height: 14,
                      decoration: BoxDecoration(
                        color: colors.background03.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 60,
                      height: 12,
                      decoration: BoxDecoration(
                        color: colors.background03.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 16,
                    decoration: BoxDecoration(
                      color: colors.background03.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 16,
                    decoration: BoxDecoration(
                      color: colors.background03.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 100,
                    height: 16,
                    decoration: BoxDecoration(
                      color: colors.background03.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 50,
                  height: 24,
                  decoration: BoxDecoration(
                    color: colors.background03.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 50,
                  height: 24,
                  decoration: BoxDecoration(
                    color: colors.background03.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscussionCard(
    BuildContext context, {
    required String title,
    required int votes,
    required int comments,
    required String author,
    required String timeAgo,
    required String avatarUrl,
    required String url,
  }) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 12),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: Ink(
          decoration: BoxDecoration(
            color: isDarkMode ? colors.background02 : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: InkWell(
            onTap: () => launchUrlString(url, mode: LaunchMode.externalApplication),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Author info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: NetworkImage(avatarUrl),
                        backgroundColor: colors.primary.withOpacity(0.1),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(author, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                          Text(timeAgo, style: TextStyle(fontSize: 12, color: colors.deactive)),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Discussion title
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colors.active, height: 1.3),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Stats row
                  Row(
                    children: [
                      // Vote count
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: votes > 0 ? Colors.green.withOpacity(0.1) : colors.background03.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              votes >= 0 ? Icons.thumb_up : Icons.thumb_down,
                              size: 14,
                              color: votes >= 0 ? Colors.green : Colors.red,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              votes.abs().toString(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: votes >= 0 ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Comments count
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: colors.background03.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.chat_bubble_outline_rounded, size: 14, color: colors.deactive),
                            const SizedBox(width: 4),
                            Text(
                              comments.toString(),
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colors.deactive),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // Go button
                      Icon(Icons.arrow_forward_ios_rounded, size: 14, color: colors.primary),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

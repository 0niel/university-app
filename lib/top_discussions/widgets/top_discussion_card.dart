import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class TopDiscussionCard extends StatelessWidget {
  const TopDiscussionCard({
    super.key,
    required this.title,
    required this.url,
    required this.votes,
    this.commentCount,
    this.avatarUrl,
    this.author,
    this.timeAgo,
    this.onTap,
    this.launchMode = LaunchMode.externalApplication,
  });

  final String title;
  final String url;
  final int votes;
  final int? commentCount;
  final String? avatarUrl;
  final String? author;
  final String? timeAgo;
  final VoidCallback? onTap;
  final LaunchMode launchMode;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: colors.background02,
      child: PlatformInkWell(
        onTap:
            onTap ??
            () {
              final Uri uri = Uri.parse(url);
              launchUrl(uri, mode: launchMode);
            },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Topic title and votes
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Vote count
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          votes > 0 ? Colors.green : (votes < 0 ? Colors.red : colors.background03),
                          votes > 0
                              ? Colors.green.withOpacity(0.7)
                              : (votes < 0 ? Colors.red.withOpacity(0.7) : colors.background03.withOpacity(0.7)),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color:
                              votes > 0
                                  ? Colors.green.withOpacity(0.2)
                                  : (votes < 0 ? Colors.red.withOpacity(0.2) : Colors.transparent),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      votes.toString(),
                      style: AppTextStyle.bodyBold.copyWith(color: votes != 0 ? Colors.white : colors.active),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Title
                  Expanded(
                    child: Text(
                      title,
                      style: AppTextStyle.bodyL.copyWith(color: colors.active, fontWeight: FontWeight.w600),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Author info and stats
              Row(
                children: [
                  // Author avatar
                  if (avatarUrl != null)
                    Container(
                      width: 28,
                      height: 28,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: colors.background03, width: 1),
                        boxShadow: [
                          BoxShadow(color: colors.active.withOpacity(0.08), blurRadius: 2, offset: const Offset(0, 1)),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          avatarUrl!,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => Container(
                                color: colors.primary.withOpacity(0.2),
                                child: Icon(Icons.person, size: 16, color: colors.primary),
                              ),
                        ),
                      ),
                    ),

                  // Author name
                  if (author != null)
                    Text(
                      author!,
                      style: AppTextStyle.captionL.copyWith(color: colors.active, fontWeight: FontWeight.w500),
                    ),

                  // Time ago
                  if (timeAgo != null) ...[
                    const Text(' • ', style: TextStyle(color: Colors.grey)),
                    Text(timeAgo!, style: AppTextStyle.captionL.copyWith(color: colors.deactive)),
                  ],

                  const Spacer(),

                  // Comments count
                  if (commentCount != null) ...[
                    Icon(Icons.chat_bubble_outline, size: 16, color: colors.deactive),
                    const SizedBox(width: 4),
                    Text(commentCount.toString(), style: AppTextStyle.captionL.copyWith(color: colors.deactive)),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.05, end: 0, duration: 350.ms, curve: Curves.easeOutQuad);
  }
}

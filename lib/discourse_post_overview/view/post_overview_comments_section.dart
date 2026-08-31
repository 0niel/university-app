import 'package:app_ui/app_ui.dart';
import 'package:community_repository/community_repository.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/discourse_post_overview/view/post_overview_comment_tile.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class PostOverviewCommentsSection extends StatelessWidget {
  const PostOverviewCommentsSection({
    required this.comments,
    super.key,
  });

  final List<DiscoursePostComment> comments;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;

    return Column(
      crossAxisAlignment: .start,
      spacing: 16,
      children: [
        Text(
          context.l10n.postDetailComments(comments.length),
          style: NinjaText.title.copyWith(color: colors.ink),
        ),
        if (comments.isEmpty)
          Text(
            context.l10n.postDetailNoComments,
            style: NinjaText.body.copyWith(color: colors.muted),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: comments.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) =>
                PostOverviewCommentTile(comment: comments[index]),
          ),
      ],
    );
  }
}

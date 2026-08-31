part of 'teacher_profile_page.dart';

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});

  final TeacherReview review;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Container(
      padding: const .all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: .circular(NinjaRadius.card),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            spacing: 10,
            children: [
              AppAvatar(name: review.authorName, size: 32),
              Expanded(
                child: Text(
                  review.authorName,
                  style: NinjaText.body.copyWith(color: colors.ink),
                ),
              ),
              Text(
                '★' * review.average.round(),
                style: NinjaText.subtext.copyWith(color: colors.brandInk),
              ),
            ],
          ),
          if (review.body.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              review.body,
              style: NinjaText.subtext.copyWith(
                color: colors.muted,
                height: 1.45,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

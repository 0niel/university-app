part of 'poll_card.dart';

class _PollTags extends StatelessWidget {
  const _PollTags({required this.poll});

  final Poll poll;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.ninja;
    final labels = <String>[
      if (poll.pollType == .quiz) l10n.pollsTagQuiz,
      if (poll.isAnonymous) l10n.pollsTagAnonymous,
      if (poll.hasEnded) l10n.pollsTagEnded,
    ];
    if (labels.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        labels.join('  ·  '),
        style: NinjaText.microLabel.copyWith(
          color: poll.hasEnded ? colors.muted : colors.brandInk,
        ),
      ),
    );
  }
}

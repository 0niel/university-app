import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:app_ui/app_ui.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';

class LessonReactionDisplay extends StatelessWidget {
  const LessonReactionDisplay({super.key, required this.reactionSummary, this.maxVisibleReactions = 3});

  final LessonReactionSummary reactionSummary;
  final int maxVisibleReactions;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final sortedReactions = reactionSummary.reactionCounts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    if (sortedReactions.isEmpty) {
      return const SizedBox.shrink();
    }

    final visibleReactions = sortedReactions.take(maxVisibleReactions).toList();
    final remainingCount = reactionSummary.totalReactions - visibleReactions.fold(0, (sum, entry) => sum + entry.value);

    return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: colors.surface.withOpacity(0.95),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.background03, width: 1),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Display reaction emojis
              ...visibleReactions.map((entry) {
                final isUserReaction = reactionSummary.userReaction == entry.key;
                return _ReactionChip(reactionType: entry.key, count: entry.value, isUserReaction: isUserReaction);
              }),

              // Show count of remaining reactions if any
              if (remainingCount > 0)
                Container(
                  margin: const EdgeInsets.only(left: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: colors.background03, borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    '+$remainingCount',
                    style: AppTextStyle.captionS.copyWith(color: colors.deactive, fontWeight: FontWeight.w600),
                  ),
                ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: const Duration(milliseconds: 300))
        .slideY(begin: 0.2, end: 0, duration: const Duration(milliseconds: 300));
  }
}

class _ReactionChip extends StatefulWidget {
  const _ReactionChip({required this.reactionType, required this.count, required this.isUserReaction});

  final ReactionType reactionType;
  final int count;
  final bool isUserReaction;

  @override
  State<_ReactionChip> createState() => _ReactionChipState();
}

class _ReactionChipState extends State<_ReactionChip> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.elasticOut));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_ReactionChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.count != widget.count) {
      _pulseController.forward().then((_) {
        _pulseController.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            margin: const EdgeInsets.only(right: 2),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: widget.isUserReaction ? colors.primary.withOpacity(0.15) : colors.background03,
              borderRadius: BorderRadius.circular(10),
              border: widget.isUserReaction ? Border.all(color: colors.primary, width: 1) : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.reactionType.emoji, style: const TextStyle(fontSize: 12)),
                if (widget.count > 1) ...[
                  const SizedBox(width: 2),
                  Text(
                    widget.count.toString(),
                    style: AppTextStyle.captionS.copyWith(
                      color: widget.isUserReaction ? colors.primary : colors.deactive,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class LessonReactionFloatingDisplay extends StatelessWidget {
  const LessonReactionFloatingDisplay({super.key, required this.reactionSummary});

  final LessonReactionSummary reactionSummary;

  @override
  Widget build(BuildContext context) {
    if (reactionSummary.totalReactions == 0) {
      return const SizedBox.shrink();
    }

    return Positioned(top: 8, right: 8, child: LessonReactionDisplay(reactionSummary: reactionSummary));
  }
}

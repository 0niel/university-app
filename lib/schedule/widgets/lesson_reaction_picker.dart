import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:app_ui/app_ui.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';

class LessonReactionPicker extends StatefulWidget {
  const LessonReactionPicker({
    super.key,
    required this.onReactionSelected,
    required this.currentReaction,
    required this.onDismiss,
  });

  final Function(ReactionType) onReactionSelected;
  final ReactionType? currentReaction;
  final VoidCallback onDismiss;

  @override
  State<LessonReactionPicker> createState() => _LessonReactionPickerState();
}

class _LessonReactionPickerState extends State<LessonReactionPicker> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _slideController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _slideController = AnimationController(duration: const Duration(milliseconds: 150), vsync: this);

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack));

    _scaleController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _handleReactionTap(ReactionType reactionType) {
    widget.onReactionSelected(reactionType);
    _dismiss();
  }

  void _dismiss() {
    _scaleController.reverse().then((_) {
      widget.onDismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return GestureDetector(
      onTap: _dismiss,
      child: Container(
        color: Colors.black26,
        child: Center(
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 10)),
                        ],
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.85, maxHeight: 60),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children:
                                ReactionType.values.map((reactionType) {
                                  final isSelected = widget.currentReaction == reactionType;
                                  final index = ReactionType.values.indexOf(reactionType);

                                  return _ReactionButton(
                                    reactionType: reactionType,
                                    isSelected: isSelected,
                                    onTap: () => _handleReactionTap(reactionType),
                                    delay: Duration(milliseconds: index * 30),
                                  );
                                }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ReactionButton extends StatefulWidget {
  const _ReactionButton({
    required this.reactionType,
    required this.isSelected,
    required this.onTap,
    required this.delay,
  });

  final ReactionType reactionType;
  final bool isSelected;
  final VoidCallback onTap;
  final Duration delay;

  @override
  State<_ReactionButton> createState() => _ReactionButtonState();
}

class _ReactionButtonState extends State<_ReactionButton> with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(duration: const Duration(milliseconds: 150), vsync: this);
    _bounceAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut));
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _bounceController.forward().then((_) {
      _bounceController.reverse();
    });
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return AnimatedBuilder(
          animation: _bounceAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _bounceAnimation.value,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: GestureDetector(
                  onTap: _handleTap,
                  onTapDown: (_) {
                    setState(() => _isHovered = true);
                  },
                  onTapUp: (_) {
                    setState(() => _isHovered = false);
                  },
                  onTapCancel: () {
                    setState(() => _isHovered = false);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color:
                          widget.isSelected
                              ? colors.primary.withOpacity(0.1)
                              : _isHovered
                              ? colors.background03
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(22),
                      border: widget.isSelected ? Border.all(color: colors.primary, width: 2) : null,
                    ),
                    child: Center(child: Text(widget.reactionType.emoji, style: const TextStyle(fontSize: 22))),
                  ),
                ),
              ),
            );
          },
        )
        .animate(delay: widget.delay)
        .slideY(begin: 0.5, end: 0, duration: const Duration(milliseconds: 300), curve: Curves.easeOutBack)
        .fade(begin: 0, end: 1, duration: const Duration(milliseconds: 200));
  }
}

class ReactionOverlay extends StatelessWidget {
  const ReactionOverlay({super.key, required this.onReactionSelected, required this.currentReaction});

  final Function(ReactionType) onReactionSelected;
  final ReactionType? currentReaction;

  static void show(
    BuildContext context, {
    required Function(ReactionType) onReactionSelected,
    ReactionType? currentReaction,
  }) {
    final overlay = OverlayEntry(
      builder: (context) => ReactionOverlay(onReactionSelected: onReactionSelected, currentReaction: currentReaction),
    );

    Overlay.of(context).insert(overlay);

    // Auto-dismiss after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (overlay.mounted) {
        overlay.remove();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LessonReactionPicker(
      onReactionSelected: onReactionSelected,
      currentReaction: currentReaction,
      onDismiss: () {
        Navigator.of(context).pop();
      },
    );
  }
}

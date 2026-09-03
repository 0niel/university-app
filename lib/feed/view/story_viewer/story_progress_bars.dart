import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';

class StoryProgressBars extends StatelessWidget {
  const StoryProgressBars({
    required this.count,
    required this.index,
    required this.progress,
    super.key,
  });

  final int count;
  final int index;
  final Animation<double> progress;

  @override
  Widget build(BuildContext context) {
    final white = context.colors.white;
    return AnimatedBuilder(
      animation: progress,
      builder: (context, _) => Row(
        children: [
          for (var i = 0; i < count; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.xxs),
                child: SizedBox(
                  height: 3,
                  child: ColoredBox(
                    color: white.withValues(alpha: .3),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: i < index
                          ? 1
                          : i == index
                          ? progress.value.clamp(0, 1)
                          : 0,
                      child: ColoredBox(color: white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';

class AvatarStackSkeleton extends StatelessWidget {
  const AvatarStackSkeleton({super.key});

  static const _count = 6;
  static const _size = 32.0;
  static const _overlap = 8.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const step = _size - _overlap;
    const width = _size + (_count - 1) * step;

    return SizedBox(
      height: _size,
      width: width,
      child: Stack(
        children: [
          for (var i = 0; i < _count; i++)
            Positioned(
              left: i * step,
              child: Container(
                padding: const .all(2),
                decoration: BoxDecoration(
                  shape: .circle,
                  color: colors.surface,
                ),
                child: const NinjaSkeleton(
                  width: _size - 4,
                  height: _size - 4,
                  radius: (_size - 4) / 2,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

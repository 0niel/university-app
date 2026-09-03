import 'package:app_ui/app_ui.dart';
import 'package:community_repository/community_repository.dart';
import 'package:flutter/widgets.dart';

class AvatarStack extends StatelessWidget {
  const AvatarStack({required this.contributors, super.key});

  final List<Contributor> contributors;

  static const _maxVisible = 7;
  static const _size = 32.0;
  static const _ring = 2.0;
  static const _overlap = 8.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const step = _size - _overlap;

    return LayoutBuilder(
      builder: (context, constraints) {
        double widthFor(int count) {
          final rest = contributors.length - count;
          return _size + (count - 1) * step + (rest > 0 ? step : 0);
        }

        var count = contributors.length < _maxVisible
            ? contributors.length
            : _maxVisible;
        while (count > 1 && widthFor(count) > constraints.maxWidth) {
          count--;
        }

        final visible = contributors.take(count).toList();
        final rest = contributors.length - count;

        Widget ringed(Widget child) => Container(
          padding: const EdgeInsets.all(_ring),
          decoration: BoxDecoration(color: colors.surface, shape: .circle),
          child: child,
        );

        return SizedBox(
          height: _size,
          width: widthFor(count),
          child: Stack(
            children: [
              for (final (index, contributor) in visible.indexed)
                Positioned(
                  left: index * step,
                  child: ringed(
                    AppAvatar(
                      name: contributor.login,
                      size: _size - _ring * 2,
                      imageUrl: contributor.avatarUrl,
                    ),
                  ),
                ),
              if (rest > 0)
                Positioned(
                  left: visible.length * step,
                  child: ringed(
                    Container(
                      width: _size - _ring * 2,
                      height: _size - _ring * 2,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: .circle,
                        color: colors.surface2,
                      ),
                      child: Text(
                        '+$rest',
                        style: AppText.captionStrong.copyWith(
                          color: colors.muted,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

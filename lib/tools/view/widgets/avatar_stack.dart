import 'package:app_ui/app_ui.dart';
import 'package:community_repository/community_repository.dart';
import 'package:flutter/material.dart';

class AvatarStack extends StatelessWidget {
  const AvatarStack({required this.contributors, super.key});

  final List<Contributor> contributors;

  static const _maxVisible = 7;
  static const _size = 32.0;
  static const _overlap = 8.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
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

        return SizedBox(
          height: _size,
          width: widthFor(count),
          child: Stack(
            children: [
              for (var i = 0; i < visible.length; i++)
                Positioned(
                  left: i * step,
                  child: Container(
                    padding: const .all(2),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      shape: .circle,
                    ),
                    child: CircleAvatar(
                      radius: (_size - 4) / 2,
                      backgroundColor: colors.surfaceAlt,
                      backgroundImage: visible[i].avatarUrl.isNotEmpty
                          ? NetworkImage(visible[i].avatarUrl)
                          : null,
                    ),
                  ),
                ),
              if (rest > 0)
                Positioned(
                  left: visible.length * step,
                  child: Container(
                    width: _size,
                    height: _size,
                    alignment: Alignment.center,
                    padding: const .all(2),
                    decoration: BoxDecoration(
                      shape: .circle,
                      color: colors.surface,
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: .circle,
                        color: colors.surfaceAlt,
                      ),
                      child: Text(
                        '+$rest',
                        style: NinjaText.helper.copyWith(
                          color: colors.mutedDark,
                          fontWeight: .w600,
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

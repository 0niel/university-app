import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/common/utils/ninja_initials.dart';

part 'ring.dart';

class TeamAvatarStack extends StatelessWidget {
  const TeamAvatarStack({
    required this.names,
    super.key,
    this.emptySlots = 0,
    this.size = 28,
  });

  final List<String> names;
  final int emptySlots;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox(
      height: size + 4,
      child: Stack(
        children: [
          for (final (i, name) in names.indexed)
            Padding(
              padding: .only(left: i * (size - 8)),
              child: _Ring(
                color: colors.surface,
                child: NinjaAvatar(initials: ninjaInitials(name), size: size),
              ),
            ),
          for (var i = 0; i < emptySlots; i++)
            Padding(
              padding: .only(left: (names.length + i) * (size - 8)),
              child: _Ring(
                color: colors.surface,
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: .circle,
                    color: colors.surface2,
                  ),
                  child: Center(
                    child: AppLineIconWidget(
                      .plus,
                      size: 12,
                      color: colors.muted,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:schedule_repository/schedule_repository.dart';

class GroupResultRow extends StatelessWidget {
  const GroupResultRow({
    required this.group,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final Group group;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final duration = NinjaMotion.of(context, NinjaMotion.fast);
    return AppPressable(
      onTap: onTap,
      pressedScale: 1,
      semanticsLabel: group.name,
      semanticsButton: true,
      semanticsSelected: selected,
      child: AnimatedContainer(
        duration: duration,
        curve: NinjaMotion.enter,
        constraints: const BoxConstraints(
          minHeight: AppControlSize.touchTarget,
        ),
        padding: const EdgeInsets.fromLTRB(18, 15, 18, 15),
        color: selected ? colors.tint : colors.surface,
        child: Row(
          children: [
            Expanded(
              child: Text(
                group.name,
                style: AppText.headline.copyWith(color: colors.ink),
              ),
            ),
            const SizedBox(width: 12),
            AnimatedContainer(
              duration: duration,
              curve: NinjaMotion.enter,
              width: 22,
              height: 22,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? colors.accent : colors.surface2,
                shape: BoxShape.circle,
              ),
              child: AppCheckMark(size: 12, color: colors.onAccent),
            ),
          ],
        ),
      ),
    );
  }
}

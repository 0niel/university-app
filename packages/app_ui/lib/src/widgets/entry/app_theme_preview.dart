import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:app_ui/src/widgets/app_press_state.dart';
import 'package:flutter/material.dart';

class AppThemePreview extends StatelessWidget {
  const AppThemePreview({
    required this.label,
    required this.selected,
    required this.onPressed,
    super.key,
    this.dark = false,
    this.system = false,
  });

  final String label;
  final bool selected;
  final VoidCallback? onPressed;
  final bool dark;
  final bool system;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final preview = dark ? AppColors.dark : AppColors.light;
    return Semantics(
      selected: selected,
      child: AppPressState(
        onTap: onPressed,
        enabled: onPressed != null,
        semanticsLabel: label,
        semanticsButton: true,
        builder: (context, {required pressed}) => Column(
          children: [
            Container(
              height: 104,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: preview.canvas,
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(
                  color: selected ? colors.ink : colors.line,
                  width: selected ? 2 : 1,
                ),
              ),
              child: Stack(
                children: [
                  if (system)
                    Positioned.fill(
                      child: Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: FractionallySizedBox(
                          widthFactor: .5,
                          heightFactor: 1,
                          child: ColoredBox(color: AppColors.dark.canvas),
                        ),
                      ),
                    ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Container(
                          width: 24,
                          height: 5,
                          decoration: BoxDecoration(
                            color: preview.muted,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 27,
                        decoration: BoxDecoration(
                          color: preview.surface2,
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                      const SizedBox(height: 7),
                      Container(
                        height: 15,
                        decoration: BoxDecoration(
                          color: preview.surface2,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ],
                  ),
                  if (selected)
                    PositionedDirectional(
                      end: 0,
                      bottom: 0,
                      child: Container(
                        width: 22,
                        height: 22,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: colors.ink,
                          shape: BoxShape.circle,
                        ),
                        child: AppLineIconWidget(
                          AppLineIcon.check,
                          size: 13,
                          color: colors.canvas,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppText.captionStrong
                  .copyWith(color: selected ? colors.ink : colors.muted),
            ),
          ],
        ),
      ),
    );
  }
}

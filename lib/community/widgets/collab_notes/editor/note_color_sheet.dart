import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

List<Color> noteKitTones(BuildContext context) {
  final colors = context.colors;
  return [
    colors.ink,
    colors.accent,
    colors.lecture,
    colors.lab,
    colors.practice,
    colors.exam,
  ];
}

Future<Color?> showNoteColorSheet(
  BuildContext context, {
  required String title,
}) {
  return showAppSheet<Color?>(
    context,
    title: title,
    child: const _NoteColorSheet(),
  );
}

class _NoteColorSheet extends StatelessWidget {
  const _NoteColorSheet();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tones = noteKitTones(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: [
            AppPressable(
              onTap: () => Navigator.of(context).pop(),
              semanticsButton: true,
              semanticsLabel: context.l10n.noteColorDefault,
              child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.surface2,
                  shape: BoxShape.circle,
                ),
                child: AppLineIconWidget(
                  AppLineIcon.close,
                  size: 16,
                  color: colors.muted,
                ),
              ),
            ),
            for (final tone in tones)
              AppPressable(
                onTap: () => Navigator.of(context).pop(tone),
                semanticsButton: true,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: tone,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }
}

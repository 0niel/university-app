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

class NoteColorSelection {
  const NoteColorSelection(this.color);

  final Color? color;
}

Future<NoteColorSelection?> showNoteColorSheet(
  BuildContext context, {
  required String title,
  Color? initialColor,
}) {
  return showAppSheet<NoteColorSelection>(
    context,
    title: title,
    child: _NoteColorSheet(initialColor: initialColor),
  );
}

class _NoteColorSheet extends StatefulWidget {
  const _NoteColorSheet({required this.initialColor});

  final Color? initialColor;

  @override
  State<_NoteColorSheet> createState() => _NoteColorSheetState();
}

class _NoteColorSheetState extends State<_NoteColorSheet> {
  late Color? _color = widget.initialColor;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppColorPalette(
          value: _color?.toARGB32() ?? 0,
          swatches: {
            for (final tone in noteKitTones(context)) tone.toARGB32(),
          }.toList(),
          onChanged: (value) => setState(() => _color = Color(value)),
          customLabel: l10n.settingsColorCustom,
          hexLabel: l10n.settingsColorHex,
          hexInvalidLabel: l10n.settingsColorHexInvalid,
        ),
        const SizedBox(height: AppSpacing.sm),
        AppButton.text(
          label: l10n.noteColorDefault,
          onPressed: () =>
              Navigator.of(context).pop(const NoteColorSelection(null)),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppButton.primary(
          label: l10n.done,
          expanded: true,
          onPressed: () =>
              Navigator.of(context).pop(NoteColorSelection(_color)),
        ),
      ],
    );
  }
}

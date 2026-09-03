import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class LessonColorEditor extends StatelessWidget {
  const LessonColorEditor({
    required this.color,
    required this.onSaved,
    super.key,
    this.defaultColor,
    this.swatches,
    this.markedValues = const <int>{},
  });

  final Color color;
  final ValueChanged<int> onSaved;
  final int? defaultColor;
  final List<int>? swatches;
  final Set<int> markedValues;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final defaultColor = this.defaultColor;
    return AppColorPalette(
      value: color.toARGB32(),
      onChanged: onSaved,
      customLabel: l10n.settingsColorCustom,
      hexLabel: l10n.settingsColorHex,
      hexInvalidLabel: l10n.settingsColorHexInvalid,
      swatches: swatches ?? kAppColorPaletteSwatches,
      markedValues: markedValues,
      defaultValue: defaultColor,
      resetLabel: defaultColor == null ? null : l10n.reset,
    );
  }
}

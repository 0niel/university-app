import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/ninja/widgets/ninja_checkbox.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/widgets/app_overline.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:app_ui/src/widgets/buttons/app_button.dart';
import 'package:app_ui/src/widgets/forms/app_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const List<int> kAppColorPaletteSwatches = <int>[
  0xFFFCA5A5,
  0xFFEF4444,
  0xFFB91C1C,
  0xFFFDBA74,
  0xFFF97316,
  0xFFC2410C,
  0xFFFCD34D,
  0xFFF59E0B,
  0xFFB45309,
  0xFF86EFAC,
  0xFF22C55E,
  0xFF15803D,
  0xFF5EEAD4,
  0xFF14B8A6,
  0xFF0F766E,
  0xFF67E8F9,
  0xFF06B6D4,
  0xFF0E7490,
  0xFF93C5FD,
  0xFF3B82F6,
  0xFF1D4ED8,
  0xFFA5B4FC,
  0xFF6366F1,
  0xFF4338CA,
  0xFFC4B5FD,
  0xFF8B5CF6,
  0xFF6D28D9,
  0xFFF9A8D4,
  0xFFEC4899,
  0xFFBE185D,
];

String appColorHexOf(int value) =>
    value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase();

class AppColorPalette extends StatefulWidget {
  const AppColorPalette({
    required this.value,
    required this.onChanged,
    required this.customLabel,
    required this.hexLabel,
    required this.hexInvalidLabel,
    super.key,
    this.swatches = kAppColorPaletteSwatches,
    this.markedValues = const <int>{},
    this.defaultValue,
    this.resetLabel,
    this.swatchSemanticsLabel,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final List<int> swatches;
  final Set<int> markedValues;
  final int? defaultValue;
  final String customLabel;
  final String? resetLabel;
  final String hexLabel;
  final String hexInvalidLabel;
  final String Function(int color)? swatchSemanticsLabel;

  @override
  State<AppColorPalette> createState() => _AppColorPaletteState();
}

class _AppColorPaletteState extends State<AppColorPalette> {
  late final TextEditingController _hex = TextEditingController(
    text: appColorHexOf(widget.value),
  );
  var _hexError = false;

  @override
  void didUpdateWidget(covariant AppColorPalette oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _parsedHex != widget.value) {
      _hex.text = appColorHexOf(widget.value);
      _hexError = false;
    }
  }

  @override
  void dispose() {
    _hex.dispose();
    super.dispose();
  }

  int? get _parsedHex {
    final text = _hex.text;
    if (text.length != 6) return null;
    final parsed = int.tryParse(text, radix: 16);
    return parsed == null ? null : 0xFF000000 | parsed;
  }

  void _submitHex(String text) {
    final parsed = text.length == 6 ? int.tryParse(text, radix: 16) : null;
    setState(() => _hexError = parsed == null);
    if (parsed != null) widget.onChanged(0xFF000000 | parsed);
  }

  void _selectSwatch(int color) {
    setState(() {
      _hexError = false;
      _hex.text = appColorHexOf(color);
    });
    widget.onChanged(color);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final defaultValue = widget.defaultValue;
    final resetLabel = widget.resetLabel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          spacing: AppSpacing.xxs,
          runSpacing: AppSpacing.xxs,
          children: [
            for (final swatch in widget.swatches)
              _AppColorSwatch(
                key: ValueKey('app-color-swatch-$swatch'),
                color: Color(swatch),
                selected: swatch == widget.value,
                marked: widget.markedValues.contains(swatch),
                semanticsLabel: widget.swatchSemanticsLabel?.call(swatch) ??
                    '#${appColorHexOf(swatch)}',
                onTap: () => _selectSwatch(swatch),
              ),
          ],
        ),
        AppOverline(widget.customLabel),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: AppInputField(
                key: const ValueKey('app-color-hex-field'),
                controller: _hex,
                label: widget.hexLabel,
                showClear: false,
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[a-fA-F0-9]')),
                  LengthLimitingTextInputFormatter(6),
                ],
                errorText: _hexError ? widget.hexInvalidLabel : null,
                onChanged: _submitHex,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Container(
              key: const ValueKey('app-color-hex-preview'),
              width: AppControlSize.field,
              height: AppControlSize.field,
              decoration: BoxDecoration(
                color: Color(_parsedHex ?? widget.value),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: colors.line),
              ),
            ),
          ],
        ),
        if (defaultValue != null && resetLabel != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: AppButton.text(
              key: const ValueKey('app-color-reset'),
              label: resetLabel,
              size: AppButtonSize.small,
              onPressed: widget.value == defaultValue
                  ? null
                  : () => _selectSwatch(defaultValue),
            ),
          ),
        ],
      ],
    );
  }
}

class _AppColorSwatch extends StatelessWidget {
  const _AppColorSwatch({
    required this.color,
    required this.selected,
    required this.marked,
    required this.onTap,
    required this.semanticsLabel,
    super.key,
  });

  final Color color;
  final bool selected;
  final bool marked;
  final VoidCallback onTap;
  final String semanticsLabel;

  static const double _diameter = 32;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final checkColor =
        color.computeLuminance() > .55 ? colors.ink : colors.white;

    return AppPressable(
      onTap: onTap,
      semanticsLabel: semanticsLabel,
      semanticsSelected: selected,
      child: SizedBox.square(
        dimension: AppControlSize.touchTarget,
        child: Center(
          child: Container(
            width: _diameter,
            height: _diameter,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border:
                  selected ? Border.all(color: colors.accent, width: 2) : null,
            ),
            child: selected
                ? AppCheckMark(size: 14, color: checkColor, strokeWidth: 2.4)
                : marked
                    ? Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: colors.canvas,
                            shape: BoxShape.circle,
                            border: Border.all(color: colors.ink, width: 1.4),
                          ),
                        ),
                      )
                    : null,
          ),
        ),
      ),
    );
  }
}

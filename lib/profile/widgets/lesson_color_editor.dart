import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class LessonColorEditor extends StatefulWidget {
  const LessonColorEditor({
    required this.color,
    required this.onSaved,
    super.key,
  });

  final Color color;
  final ValueChanged<int> onSaved;

  @override
  State<LessonColorEditor> createState() => _LessonColorEditorState();
}

class _LessonColorEditorState extends State<LessonColorEditor> {
  late HSVColor _color;
  late final TextEditingController _hex;
  var _validHex = true;

  @override
  void initState() {
    super.initState();
    _color = HSVColor.fromColor(widget.color).withAlpha(1);
    _hex = TextEditingController(text: _hexValue);
  }

  String get _hexValue =>
      _color.toColor().toARGB32().toRadixString(16).substring(2).toUpperCase();

  @override
  void dispose() {
    _hex.dispose();
    super.dispose();
  }

  void _setColor(HSVColor value) {
    setState(() {
      _color = value;
      _validHex = true;
      _hex.text = _hexValue;
    });
  }

  void _setHex(String value) {
    final parsed = value.length == 6 ? int.tryParse(value, radix: 16) : null;
    setState(() {
      _validHex = parsed != null;
      if (parsed != null) {
        _color = HSVColor.fromColor(Color(0xFF000000 | parsed));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            const height = 160.0;
            void select(Offset position) => _setColor(
              _color
                  .withSaturation(
                    (position.dx / constraints.maxWidth).clamp(0, 1),
                  )
                  .withValue((1 - position.dy / height).clamp(0, 1)),
            );
            return ExcludeSemantics(
              child: GestureDetector(
                key: const ValueKey('lesson-color-plane'),
                onPanDown: (details) => select(details.localPosition),
                onPanUpdate: (details) => select(details.localPosition),
                child: SizedBox(
                  height: height,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.card),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white,
                                HSVColor.fromAHSV(
                                  1,
                                  _color.hue,
                                  1,
                                  1,
                                ).toColor(),
                              ],
                            ),
                          ),
                        ),
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black],
                            ),
                          ),
                        ),
                        Positioned(
                          left: (_color.saturation * constraints.maxWidth - 10)
                              .clamp(0, constraints.maxWidth - 20),
                          top: ((1 - _color.value) * height - 10).clamp(
                            0,
                            height - 20,
                          ),
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: _color.toColor(),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: const [
                                BoxShadow(blurRadius: 2, color: Colors.black54),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: AppSpacing.md),
        _slider(
          l10n.settingsColorHue,
          _color.hue,
          360,
          (value) => _setColor(_color.withHue(value)),
        ),
        _slider(
          l10n.settingsColorSaturation,
          _color.saturation,
          1,
          (value) => _setColor(_color.withSaturation(value)),
        ),
        _slider(
          l10n.settingsColorBrightness,
          _color.value,
          1,
          (value) => _setColor(_color.withValue(value)),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: AppInputField(
                key: const ValueKey('lesson-color-hex'),
                controller: _hex,
                label: l10n.settingsColorHex,
                showClear: false,
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[a-fA-F0-9]')),
                  LengthLimitingTextInputFormatter(6),
                ],
                onChanged: _setHex,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: _color.toColor(),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: context.colors.line),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.screen),
        AppButton.primary(
          key: const ValueKey('lesson-color-save'),
          label: l10n.save,
          expanded: true,
          onPressed: _validHex
              ? () => widget.onSaved(_color.toColor().toARGB32())
              : null,
        ),
      ],
    );
  }

  Widget _slider(
    String label,
    double value,
    double max,
    ValueChanged<double> onChanged,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(label, style: AppText.caption.copyWith(color: context.colors.muted)),
      Slider(
        value: value,
        max: max,
        activeColor: _color.toColor(),
        semanticFormatterCallback: (value) => '${(value / max * 100).round()}%',
        onChanged: onChanged,
      ),
    ],
  );
}

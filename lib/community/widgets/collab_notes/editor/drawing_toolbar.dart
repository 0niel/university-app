import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor/drawing_tool.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class DrawingToolbar extends StatelessWidget {
  const DrawingToolbar({
    required this.tool,
    required this.onToolChanged,
    required this.color,
    required this.palette,
    required this.onColorChanged,
    required this.strokeWidth,
    required this.onStrokeWidthChanged,
    required this.canUndo,
    required this.canRedo,
    required this.onUndo,
    required this.onRedo,
    required this.onClear,
    required this.stylusOnly,
    required this.onStylusOnlyChanged,
    required this.onResetView,
    this.enabled = true,
    super.key,
  });

  final DrawingTool tool;
  final ValueChanged<DrawingTool> onToolChanged;
  final Color color;
  final List<Color> palette;
  final ValueChanged<Color> onColorChanged;
  final DrawingStrokeWidth strokeWidth;
  final ValueChanged<DrawingStrokeWidth> onStrokeWidthChanged;
  final bool canUndo;
  final bool canRedo;
  final VoidCallback onUndo;
  final VoidCallback onRedo;
  final VoidCallback onClear;
  final bool stylusOnly;
  final ValueChanged<bool> onStylusOnlyChanged;
  final VoidCallback onResetView;
  final bool enabled;

  Widget _button(
    AppLineIcon icon,
    String label,
    VoidCallback? onTap, {
    bool selected = false,
  }) => Semantics(
    selected: selected,
    child: AppIconButton(
      icon: AppLineIconWidget(icon, size: 20),
      tooltip: label,
      tone: selected ? AppIconButtonTone.tonal : AppIconButtonTone.plain,
      onPressed: enabled ? onTap : null,
    ),
  );

  Widget _strip(List<Widget> children) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(mainAxisSize: MainAxisSize.min, children: children),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tools = [
      _button(
        AppLineIcon.pencil,
        l10n.noteDrawingPen,
        () => onToolChanged(.pen),
        selected: tool == .pen,
      ),
      _button(
        AppLineIcon.brush,
        l10n.noteDrawingMarker,
        () => onToolChanged(.marker),
        selected: tool == .marker,
      ),
      _button(
        AppLineIcon.eraser,
        l10n.noteDrawingEraser,
        () => onToolChanged(.eraser),
        selected: tool == .eraser,
      ),
      _button(
        AppLineIcon.lock,
        stylusOnly ? l10n.noteDrawingStylusOnly : l10n.noteDrawingTouchDraw,
        () => onStylusOnlyChanged(!stylusOnly),
        selected: stylusOnly,
      ),
      _button(AppLineIcon.view, l10n.noteDrawingResetView, onResetView),
    ];
    final actions = [
      _button(AppLineIcon.undo, l10n.noteDrawingUndo, canUndo ? onUndo : null),
      _button(AppLineIcon.redo, l10n.noteDrawingRedo, canRedo ? onRedo : null),
      _button(
        AppLineIcon.trash,
        l10n.noteDrawingClear,
        canUndo ? onClear : null,
      ),
    ];
    final paletteControls = [
      for (final (index, entry) in palette.indexed)
        Semantics(
          selected: entry.toARGB32() == color.toARGB32(),
          child: AppIconButton(
            tooltip: l10n.noteDrawingColor(index + 1),
            tone: entry.toARGB32() == color.toARGB32()
                ? AppIconButtonTone.tonal
                : AppIconButtonTone.plain,
            onPressed: enabled ? () => onColorChanged(entry) : null,
            icon: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(color: entry, shape: BoxShape.circle),
            ),
          ),
        ),
      const SizedBox(width: AppSpacing.md),
      for (final width in DrawingStrokeWidth.values)
        Semantics(
          selected: width == strokeWidth,
          child: AppIconButton(
            tooltip: switch (width) {
              DrawingStrokeWidth.thin => l10n.noteDrawingWidthThin,
              DrawingStrokeWidth.medium => l10n.noteDrawingWidthMedium,
              DrawingStrokeWidth.thick => l10n.noteDrawingWidthThick,
            },
            tone: width == strokeWidth
                ? AppIconButtonTone.tonal
                : AppIconButtonTone.plain,
            onPressed: enabled ? () => onStrokeWidthChanged(width) : null,
            icon: Container(
              width: 6.0 + width.index * 4,
              height: 6.0 + width.index * 4,
              decoration: BoxDecoration(
                color: context.colors.ink,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 1000) {
            return Row(
              children: [
                ...tools,
                const Spacer(),
                ...paletteControls,
                const Spacer(),
                ...actions,
              ],
            );
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(child: _strip(tools)),
                  ...actions,
                ],
              ),
              _strip(paletteControls),
            ],
          );
        },
      ),
    );
  }
}

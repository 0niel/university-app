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

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
            children: [
              for (final entry in palette)
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: _ColorSwatch(
                    color: entry,
                    selected: entry.toARGB32() == color.toARGB32(),
                    onTap: () => onColorChanged(entry),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
          child: Row(
            children: [
              _ToolButton(
                icon: AppLineIcon.pencil,
                selected: tool == .pen,
                semanticsLabel: l10n.noteDrawingPen,
                onTap: () => onToolChanged(.pen),
              ),
              const SizedBox(width: AppSpacing.sm),
              _ToolButton(
                icon: AppLineIcon.brush,
                selected: tool == .marker,
                semanticsLabel: l10n.noteDrawingMarker,
                onTap: () => onToolChanged(.marker),
              ),
              const SizedBox(width: AppSpacing.sm),
              _ToolButton(
                icon: AppLineIcon.eraser,
                selected: tool == .eraser,
                semanticsLabel: l10n.noteDrawingEraser,
                onTap: () => onToolChanged(.eraser),
              ),
              const SizedBox(width: AppSpacing.md),
              for (final width in DrawingStrokeWidth.values)
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: _WidthDot(
                    diameter: 6 + width.index * 4,
                    selected: width == strokeWidth,
                    semanticsLabel: switch (width) {
                      DrawingStrokeWidth.thin => l10n.noteDrawingWidthThin,
                      DrawingStrokeWidth.medium => l10n.noteDrawingWidthMedium,
                      DrawingStrokeWidth.thick => l10n.noteDrawingWidthThick,
                    },
                    onTap: () => onStrokeWidthChanged(width),
                  ),
                ),
              const Spacer(),
              _ActionIcon(
                icon: AppLineIcon.undo,
                enabled: canUndo,
                semanticsLabel: l10n.noteDrawingUndo,
                onTap: onUndo,
              ),
              const SizedBox(width: AppSpacing.xs),
              _ActionIcon(
                icon: AppLineIcon.redo,
                enabled: canRedo,
                semanticsLabel: l10n.noteDrawingRedo,
                onTap: onRedo,
              ),
              const SizedBox(width: AppSpacing.xs),
              _ActionIcon(
                icon: AppLineIcon.trash,
                enabled: true,
                destructive: true,
                semanticsLabel: l10n.noteDrawingClear,
                onTap: onClear,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      semanticsButton: true,
      semanticsSelected: selected,
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? context.colors.surface2 : null,
          shape: BoxShape.circle,
        ),
        child: Container(
          width: selected ? 22 : 18,
          height: selected ? 22 : 18,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ),
    );
  }
}

class _ToolButton extends StatelessWidget {
  const _ToolButton({
    required this.icon,
    required this.selected,
    required this.semanticsLabel,
    required this.onTap,
  });

  final AppLineIcon icon;
  final bool selected;
  final String semanticsLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppPressable(
      onTap: onTap,
      semanticsButton: true,
      semanticsSelected: selected,
      semanticsLabel: semanticsLabel,
      child: Container(
        width: AppControlSize.iconButton,
        height: AppControlSize.iconButton,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? colors.tint : colors.surface2,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: AppLineIconWidget(
          icon,
          size: 19,
          color: selected ? colors.accent : colors.ink,
        ),
      ),
    );
  }
}

class _WidthDot extends StatelessWidget {
  const _WidthDot({
    required this.diameter,
    required this.selected,
    required this.semanticsLabel,
    required this.onTap,
  });

  final double diameter;
  final bool selected;
  final String semanticsLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppPressable(
      onTap: onTap,
      semanticsButton: true,
      semanticsSelected: selected,
      semanticsLabel: semanticsLabel,
      child: Container(
        width: AppControlSize.iconButtonSmall,
        height: AppControlSize.iconButtonSmall,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? colors.tint : colors.surface2,
          shape: BoxShape.circle,
        ),
        child: Container(
          width: diameter,
          height: diameter,
          decoration: BoxDecoration(
            color: selected ? colors.accent : colors.muted,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({
    required this.icon,
    required this.enabled,
    required this.semanticsLabel,
    required this.onTap,
    this.destructive = false,
  });

  final AppLineIcon icon;
  final bool enabled;
  final bool destructive;
  final String semanticsLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tint = !enabled
        ? colors.muted2
        : (destructive ? colors.exam : colors.ink);
    return AppPressable(
      onTap: enabled ? onTap : null,
      semanticsButton: true,
      semanticsLabel: semanticsLabel,
      child: Container(
        width: AppControlSize.iconButtonSmall,
        height: AppControlSize.iconButtonSmall,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors.surface2,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: AppLineIconWidget(icon, size: 17, color: tint),
      ),
    );
  }
}

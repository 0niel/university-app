import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';

class NoteToolbarButton extends StatelessWidget {
  const NoteToolbarButton({
    required this.icon,
    required this.semanticsLabel,
    required this.onTap,
    super.key,
    this.active = false,
    this.destructive = false,
    this.enabled = true,
  });

  final AppLineIcon icon;
  final String semanticsLabel;
  final VoidCallback? onTap;
  final bool active;
  final bool destructive;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final disabled = !enabled || onTap == null;
    final tint = disabled
        ? colors.muted2
        : (destructive ? colors.exam : (active ? colors.accent : colors.ink));
    return AppPressable(
      onTap: disabled ? null : onTap,
      semanticsButton: true,
      semanticsLabel: semanticsLabel,
      semanticsSelected: active,
      pressedScale: 0.92,
      child: Container(
        width: AppControlSize.iconButtonCompact,
        height: AppControlSize.iconButtonCompact,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? colors.tint : colors.surface2,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: AppLineIconWidget(icon, size: 18, color: tint),
      ),
    );
  }
}

class NoteToolbarGap extends StatelessWidget {
  const NoteToolbarGap({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      child: SizedBox(
        width: 1,
        height: 20,
        child: ColoredBox(color: context.colors.line),
      ),
    );
  }
}

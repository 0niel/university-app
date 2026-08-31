import 'package:app_ui/src/ninja/ninja_colors.dart';
import 'package:app_ui/src/ninja/ninja_text.dart';
import 'package:app_ui/src/ninja/surfaces/ninja_glyph.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/widgets.dart';

class NinjaAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NinjaAppBar({
    required this.title,
    super.key,
    this.actions = const <NinjaAppBarAction>[],
  })  : _inner = false,
        onBack = null,
        backSemanticLabel = null,
        actionLabel = null,
        onAction = null;
  const NinjaAppBar.inner({
    required this.title,
    super.key,
    this.onBack,
    this.backSemanticLabel,
    this.actionLabel,
    this.onAction,
  })  : _inner = true,
        actions = const <NinjaAppBarAction>[];
  final String title;
  final List<NinjaAppBarAction> actions;
  final VoidCallback? onBack;
  final String? backSemanticLabel;
  final String? actionLabel;
  final VoidCallback? onAction;

  final bool _inner;

  @override
  Size get preferredSize => Size.fromHeight(_inner ? 56 : 72);

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return ColoredBox(
      color: colors.canvas,
      child: SafeArea(
        bottom: false,
        child: _inner ? _buildInner(colors) : _buildRoot(colors),
      ),
    );
  }

  Widget _buildRoot(NinjaColors colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: NinjaText.appBarTitle.copyWith(color: colors.ink),
            ),
          ),
          for (final action in actions) ...[
            const SizedBox(width: 8),
            _NinjaAppBarActionButton(action: action),
          ],
        ],
      ),
    );
  }

  Widget _buildInner(NinjaColors colors) {
    final label = actionLabel;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(
        children: [
          if (onBack != null) ...[
            Semantics(
              button: true,
              label: backSemanticLabel,
              child: AppPressable(
                onTap: onBack,
                child: SizedBox(
                  width: 44,
                  height: 44,
                  child: Center(
                    child: NinjaGlyphIcon(
                      NinjaGlyph.arrowLeft,
                      size: 20,
                      color: colors.ink,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
          ],
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: NinjaText.headline.copyWith(color: colors.ink),
            ),
          ),
          if (label != null) ...[
            const SizedBox(width: 12),
            Semantics(
              button: true,
              enabled: onAction != null,
              child: AppPressable(
                onTap: onAction,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 44),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Center(
                      child: Text(
                        label,
                        style: TextStyle(
                          fontFamily: NinjaText.family,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: colors.brandInk,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class NinjaAppBarAction {
  const NinjaAppBarAction({
    required this.icon,
    this.onPressed,
    this.hasBadge = false,
    this.semanticLabel,
  });
  final Widget icon;
  final VoidCallback? onPressed;
  final bool hasBadge;
  final String? semanticLabel;
}

class _NinjaAppBarActionButton extends StatelessWidget {
  const _NinjaAppBarActionButton({required this.action});

  final NinjaAppBarAction action;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Semantics(
      button: true,
      label: action.semanticLabel,
      child: AppPressable(
        onTap: action.onPressed,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.surfaceAlt,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: IconTheme(
                    data: IconThemeData(size: 18, color: colors.ink),
                    child: Center(child: action.icon),
                  ),
                ),
              ),
              if (action.hasBadge)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: colors.canvas,
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: colors.scarlet,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

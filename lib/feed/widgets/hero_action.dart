part of 'feed_hero_post.dart';

class _HeroAction extends StatelessWidget {
  const _HeroAction({
    required this.label,
    required this.onPressed,
    this.solid = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool solid;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: label,
      child: AppPressable(
        onTap: onPressed,
        child: Container(
          constraints: const BoxConstraints(minHeight: 48),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: solid
                ? colors.onAccentSoft
                : Colors.white.withValues(alpha: .55),
            borderRadius: BorderRadius.circular(NinjaRadius.pill),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: NinjaText.button.copyWith(
              color: solid ? colors.accentSoft : colors.onAccentSoft,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';

class CommunityJoinButton extends StatelessWidget {
  const CommunityJoinButton({
    required this.label,
    required this.joined,
    required this.onTap,
    super.key,
    this.expanded = true,
  });

  final String label;
  final bool joined;
  final VoidCallback onTap;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppPressState(
      onTap: onTap,
      semanticsLabel: label,
      semanticsButton: true,
      semanticsSelected: joined,
      builder: (context, {required pressed}) => Opacity(
        opacity: !joined && pressed ? .82 : 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxxs),
          child: AnimatedContainer(
            key: const Key('community_saveSurface'),
            duration: NinjaMotion.base,
            curve: NinjaMotion.enter,
            constraints: const BoxConstraints(minHeight: 42),
            width: expanded ? double.infinity : null,
            alignment: Alignment.center,
            padding: expanded
                ? null
                : const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            decoration: BoxDecoration(
              color: joined
                  ? (pressed ? colors.canvas : colors.surface2)
                  : colors.accent,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: AppText.sans(
                expanded ? 14 : 13.5,
                FontWeight.w700,
              ).copyWith(color: joined ? colors.ink : colors.onAccent),
            ),
          ),
        ),
      ),
    );
  }
}

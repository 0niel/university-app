part of '../compare_page.dart';

class _PersonCard extends StatelessWidget {
  const _PersonCard({
    required this.label,
    required this.subtitle,
    this.muted = false,
  });

  final String label;
  final String subtitle;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return NinjaScheduleSurface(
      child: Row(
        spacing: 12,
        children: [
          NinjaAvatar(initials: _compareInitials(label)),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              spacing: 2,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: NinjaText.body.copyWith(
                    color: muted ? colors.muted : colors.ink,
                    fontWeight: .w600,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: NinjaText.helper.copyWith(color: colors.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

part of 'profile_page.dart';

class _ProfileIdentity extends StatelessWidget {
  const _ProfileIdentity({required this.name, required this.meta});

  final String name;
  final String meta;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final largeText = MediaQuery.textScalerOf(context).scale(1) >= 1.5;
    final avatar = Container(
      width: 64,
      height: 64,
      padding: const .all(3),
      decoration: BoxDecoration(color: colors.brand, shape: .circle),
      child: NinjaAvatar(initials: ninjaInitials(name), size: 58),
    );
    final identity = Column(
      crossAxisAlignment: largeText ? .center : .start,
      children: [
        Text(
          name,
          maxLines: 3,
          overflow: .ellipsis,
          textAlign: largeText ? .center : .start,
          style: NinjaText.display.copyWith(color: colors.ink),
        ),
        if (meta.isNotEmpty) ...[
          const SizedBox(height: 5),
          Text(
            meta,
            maxLines: 3,
            overflow: .ellipsis,
            textAlign: largeText ? .center : .start,
            style: NinjaText.subtext.copyWith(color: colors.mutedDark),
          ),
        ],
      ],
    );
    return Padding(
      padding: const .fromLTRB(
        NinjaMetrics.screenPadding,
        10,
        NinjaMetrics.screenPadding,
        2,
      ),
      child: largeText
          ? Column(children: [avatar, const SizedBox(height: 14), identity])
          : Row(
              children: [
                avatar,
                const SizedBox(width: 14),
                Expanded(child: identity),
              ],
            ),
    );
  }
}

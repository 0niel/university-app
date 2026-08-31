part of 'ninja_community_catalog_skeleton.dart';

class _CommunityCatalogSkeletonRow extends StatelessWidget {
  const _CommunityCatalogSkeletonRow({required this.showDescription});

  final bool showDescription;

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final titleHeight = (12 * textScale).clamp(12.0, 22.0);
    final detailHeight = (10 * textScale).clamp(10.0, 18.0);
    return Padding(
      padding: const .fromLTRB(
        NinjaMetrics.screenPadding,
        0,
        NinjaMetrics.screenPadding,
        10,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.ninja.surface,
          borderRadius: .circular(NinjaRadius.card),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: (16 * textScale).clamp(16.0, 22.0),
          ),
          child: Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: context.ninja.brandTint,
                  borderRadius: .circular(NinjaRadius.control),
                ),
                child: const SizedBox.square(
                  dimension: 44,
                  child: Center(child: NinjaSkeleton.avatar(size: 22)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    NinjaSkeleton.bar(
                      height: titleHeight,
                      widthFactor: 0.58,
                    ),
                    const SizedBox(height: 6),
                    NinjaSkeleton.bar(
                      height: detailHeight,
                      widthFactor: showDescription ? 0.88 : 0.38,
                    ),
                    if (showDescription) ...[
                      const SizedBox(height: 5),
                      NinjaSkeleton.bar(
                        height: detailHeight,
                        widthFactor: 0.62,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const NinjaSkeleton.avatar(size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

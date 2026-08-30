part of 'map_skeleton.dart';

class _MapPanelSkeleton extends StatelessWidget {
  const _MapPanelSkeleton({required this.layout});

  final MapPanelLayout layout;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: layout.collapsedExtent,
      minChildSize: layout.collapsedExtent,
      maxChildSize: layout.expandedExtent,
      snap: true,
      snapSizes: [layout.collapsedExtent, layout.expandedExtent],
      builder: (context, scrollController) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: context.ninja.surface,
            borderRadius: const .vertical(
              top: Radius.circular(NinjaRadius.card),
            ),
          ),
          child: ListView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            padding: const .fromLTRB(
              NinjaMetrics.screenPadding,
              8,
              NinjaMetrics.screenPadding,
              24,
            ),
            children: const [
              Center(
                child: NinjaSkeleton(
                  width: 34,
                  height: 4,
                  radius: NinjaRadius.pill,
                ),
              ),
              SizedBox(height: 10),
              NinjaSkeleton(height: 72, radius: NinjaRadius.card),
              SizedBox(height: 12),
              NinjaSkeleton(width: 176, height: 52, radius: NinjaRadius.pill),
            ],
          ),
        );
      },
    );
  }
}

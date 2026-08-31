part of '../events_skeleton.dart';

class _NinjaEventSkeletonCard extends StatelessWidget {
  const _NinjaEventSkeletonCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        NinjaMetrics.screenPadding,
        0,
        NinjaMetrics.screenPadding,
        10,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.ninja.surface,
          borderRadius: BorderRadius.circular(NinjaRadius.card),
        ),
        child: child,
      ),
    );
  }
}

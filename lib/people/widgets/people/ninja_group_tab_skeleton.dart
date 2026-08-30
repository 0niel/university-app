part of '../people_widgets.dart';

class NinjaGroupTabSkeleton extends StatelessWidget {
  const NinjaGroupTabSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const .only(top: 10, bottom: 96),
      children: [
        const Padding(
          padding: .symmetric(horizontal: NinjaMetrics.screenPadding),
          child: Row(
            spacing: 12,
            children: [
              NinjaSkeleton(width: 44, height: 44, radius: 14),
              Expanded(
                child: Column(
                  spacing: 6,
                  crossAxisAlignment: .start,
                  children: [
                    NinjaSkeleton.bar(height: 16, widthFactor: 0.6),
                    NinjaSkeleton.bar(height: 11, widthFactor: 0.4),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Padding(
          padding: const .symmetric(horizontal: NinjaMetrics.screenPadding),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.ninja.surface,
              borderRadius: .circular(NinjaRadius.card),
            ),
            child: const Padding(
              padding: .symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  NinjaSkeleton(width: 28, height: 28, radius: 9),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      spacing: 5,
                      children: [
                        NinjaSkeleton.bar(widthFactor: 0.48),
                        NinjaSkeleton.bar(height: 9, widthFactor: 0.3),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),
        const Padding(
          padding: .symmetric(horizontal: NinjaMetrics.screenPadding),
          child: NinjaSkeleton.bar(height: 22, widthFactor: 0.36),
        ),
        const SizedBox(height: 10),
        for (var index = 0; index < 6; index++)
          Padding(
            padding: const .fromLTRB(
              NinjaMetrics.screenPadding,
              0,
              NinjaMetrics.screenPadding,
              8,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: context.ninja.surface,
                borderRadius: .circular(NinjaRadius.card),
              ),
              child: const Padding(
                padding: .symmetric(horizontal: 14, vertical: 13),
                child: PersonRowSkeleton(trailingTag: true),
              ),
            ),
          ),
      ],
    );
  }
}

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
          padding: .symmetric(horizontal: AppSpacing.screen),
          child: Row(
            spacing: 12,
            children: [
              NinjaSkeleton(width: 44, height: 44, radius: AppRadius.tile),
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
          padding: const .symmetric(horizontal: AppSpacing.screen),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: .circular(AppRadius.card),
            ),
            child: const Padding(
              padding: .symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  NinjaSkeleton(
                    width: 28,
                    height: 28,
                    radius: AppRadius.skeleton,
                  ),
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
          padding: .symmetric(horizontal: AppSpacing.screen),
          child: NinjaSkeleton.bar(height: 22, widthFactor: 0.36),
        ),
        const SizedBox(height: 10),
        for (var index = 0; index < 6; index++)
          Padding(
            padding: const .fromLTRB(
              AppSpacing.screen,
              0,
              AppSpacing.screen,
              8,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: .circular(AppRadius.card),
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

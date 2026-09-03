part of '../people_widgets.dart';

class NinjaFriendsTabSkeleton extends StatelessWidget {
  const NinjaFriendsTabSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const .only(top: 10, bottom: 96),
      children: [
        Padding(
          padding: const .symmetric(horizontal: AppSpacing.screen),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: .circular(AppRadius.card),
            ),
            child: const Padding(
              padding: .fromLTRB(16, 14, 12, 14),
              child: Row(
                children: [
                  NinjaSkeleton(width: 44, height: 44, radius: AppRadius.tile),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      spacing: 6,
                      crossAxisAlignment: .start,
                      children: [
                        NinjaSkeleton.bar(height: 14, widthFactor: 0.55),
                        NinjaSkeleton.bar(height: 11, widthFactor: 0.38),
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
                child: PersonRowSkeleton(trailingLastSeen: true),
              ),
            ),
          ),
      ],
    );
  }
}

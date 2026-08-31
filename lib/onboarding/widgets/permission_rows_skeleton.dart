part of '../view/onboarding_page.dart';

class _PermissionRowsSkeleton extends StatelessWidget {
  const _PermissionRowsSkeleton({required this.rows, super.key});

  final int rows;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return NinjaSkeletonGroup(
      semanticsLabel: context.l10n.loadingContent,
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          for (var index = 0; index < rows; index++) ...[
            if (index != 0) const SizedBox(height: 10),
            DecoratedBox(
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: .circular(NinjaRadius.card),
              ),
              child: const Padding(
                padding: .fromLTRB(16, 14, 16, 14),
                child: Row(
                  crossAxisAlignment: .start,
                  children: [
                    NinjaSkeleton.avatar(),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          SizedBox(
                            height: 19,
                            child: Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: NinjaSkeleton.bar(
                                height: 14,
                                widthFactor: 0.42,
                              ),
                            ),
                          ),
                          SizedBox(height: 3),
                          SizedBox(
                            height: 17,
                            child: Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: NinjaSkeleton.bar(
                                height: 11,
                                widthFactor: 0.68,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Padding(
                      padding: .only(top: 9),
                      child: NinjaSkeleton.avatar(size: 26),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

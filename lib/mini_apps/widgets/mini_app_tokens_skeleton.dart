import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class MiniAppTokensSkeleton extends StatelessWidget {
  const MiniAppTokensSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return NinjaSkeletonGroup(
      semanticsLabel: context.l10n.loadingContent,
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        children: [
          for (var index = 0; index < 3; index++)
            Container(
              margin: const .only(bottom: 8),
              padding: const .all(14),
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(AppRadius.card),
              ),
              child: const Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      spacing: 6,
                      children: [
                        NinjaSkeleton(width: 110, height: 13),
                        NinjaSkeleton(width: 70, height: 11),
                      ],
                    ),
                  ),
                  NinjaSkeleton(
                    width: 40,
                    height: 40,
                    radius: AppRadius.iconTile,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

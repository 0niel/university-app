import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class MiniAppSecretSkeleton extends StatelessWidget {
  const MiniAppSecretSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return NinjaSkeletonGroup(
      semanticsLabel: context.l10n.loadingContent,
      child: const Padding(
        padding: .symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: .start,
          spacing: 6,
          children: [
            NinjaSkeleton(width: 180, height: 13),
            NinjaSkeleton(width: 90, height: 11),
          ],
        ),
      ),
    );
  }
}

import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class ServicesGridSkeleton extends StatelessWidget {
  const ServicesGridSkeleton({super.key});

  @override
  Widget build(BuildContext context) => NinjaSkeletonGroup(
    semanticsLabel: context.l10n.loadingContent,
    child: LayoutBuilder(
      builder: (context, constraints) => AppAdaptiveGrid(
        children: [
          for (
            var index = 0;
            index <
                AppAdaptiveGrid.columnsFor(context, constraints.maxWidth) * 2;
            index++
          )
            const AppActionTile.skeleton(),
        ],
      ),
    ),
  );
}

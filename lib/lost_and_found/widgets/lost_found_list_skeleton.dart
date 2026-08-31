import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/lost_and_found/widgets/lost_found_item_skeleton.dart';

class LostFoundListSkeleton extends StatelessWidget {
  const LostFoundListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final singleColumn = MediaQuery.widthOf(context) < 360 || textScale >= 1.3;
    final extent = textScale >= 1.8 ? 290.0 : 238.0;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: NinjaMetrics.screenPadding,
      ),
      child: Column(
        children: [
          if (singleColumn)
            for (var index = 0; index < 3; index++)
              Padding(
                padding: EdgeInsets.only(
                  bottom: index == 2 ? 0 : AppSpacing.gap,
                ),
                child: SizedBox(
                  height: extent,
                  child: const LostFoundItemSkeleton(),
                ),
              )
          else
            for (var row = 0; row < 3; row++)
              Padding(
                padding: EdgeInsets.only(bottom: row == 2 ? 0 : AppSpacing.gap),
                child: Row(
                  spacing: AppSpacing.gap,
                  children: [
                    for (var column = 0; column < 2; column++)
                      Expanded(
                        child: SizedBox(
                          height: extent,
                          child: const LostFoundItemSkeleton(),
                        ),
                      ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}

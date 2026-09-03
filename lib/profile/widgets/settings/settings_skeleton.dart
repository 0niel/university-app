import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class SettingsSkeleton extends StatelessWidget {
  const SettingsSkeleton({
    required this.rowCounts,
    super.key,
    this.identity = false,
  });

  const SettingsSkeleton.settings({Key? key})
    : this(key: key, identity: true, rowCounts: const [4, 1, 4, 1]);

  const SettingsSkeleton.notifications({Key? key})
    : this(key: key, rowCounts: const [1, 1, 3]);

  final List<int> rowCounts;
  final bool identity;

  @override
  Widget build(BuildContext context) {
    final grow = (MediaQuery.textScalerOf(context).scale(1) - 1).clamp(0, 1);
    final rowHeight = 54 + grow * 30;
    return NinjaSkeletonGroup(
      semanticsLabel: context.l10n.loadingContent,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const .fromLTRB(
          AppSpacing.screen,
          8,
          AppSpacing.screen,
          32,
        ),
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            if (identity) ...[
              NinjaSkeleton(
                height: 80 + grow * 40,
                radius: AppRadius.card,
              ),
              const SizedBox(height: AppSpacing.fieldGap),
              const NinjaSkeleton(height: 54, radius: AppRadius.field),
            ],
            for (final count in rowCounts) ...[
              const SizedBox(height: AppSpacing.sheetBottom),
              const NinjaSkeleton.bar(height: 19, widthFactor: .38),
              const SizedBox(height: AppSpacing.sm),
              NinjaSkeleton(
                height: rowHeight * count + 8,
                radius: AppRadius.card,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

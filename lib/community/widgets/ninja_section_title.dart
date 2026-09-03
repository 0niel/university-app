import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class NinjaSectionTitle extends StatelessWidget {
  const NinjaSectionTitle({
    required this.title,
    super.key,
    this.count,
    this.topPadding = 28,
  });

  final String title;
  final int? count;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screen,
        topPadding,
        AppSpacing.screen,
        4,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.title.copyWith(color: colors.ink),
            ),
          ),
          if (count case final value?) ...[
            const SizedBox(width: 10),
            Text(
              '$value',
              style: AppText.tabular(
                AppText.subtext.copyWith(color: colors.muted),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

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
    final colors = context.ninja;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        NinjaMetrics.screenPadding,
        topPadding,
        NinjaMetrics.screenPadding,
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
              style: NinjaText.title.copyWith(color: colors.ink),
            ),
          ),
          if (count case final value?) ...[
            const SizedBox(width: 10),
            Text(
              '$value',
              style: NinjaText.tabular(
                NinjaText.subtext.copyWith(color: colors.mutedDark),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

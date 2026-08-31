import 'package:app_ui/src/ninja/ninja_colors.dart';
import 'package:app_ui/src/ninja/ninja_text.dart';
import 'package:flutter/widgets.dart';

class NinjaDisplayHeader extends StatelessWidget {
  const NinjaDisplayHeader({
    required this.title,
    super.key,
    this.summary,
    this.padding = const EdgeInsets.fromLTRB(
      NinjaMetrics.screenPadding,
      14,
      NinjaMetrics.screenPadding,
      0,
    ),
  });

  final String title;
  final String? summary;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final summary = this.summary;
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: NinjaText.display.copyWith(color: colors.ink)),
          if (summary != null) ...[
            const SizedBox(height: 6),
            Text(
              summary,
              style: NinjaText.subtext.copyWith(
                fontSize: 13,
                color: colors.muted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

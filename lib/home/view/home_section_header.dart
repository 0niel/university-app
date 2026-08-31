import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class HomeSectionHeader extends StatelessWidget {
  const HomeSectionHeader({
    required this.title,
    super.key,
    this.action,
    this.onAction,
    this.topPadding = 28,
  });

  final String title;

  final String? action;

  final VoidCallback? onAction;

  final double topPadding;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final action = this.action;

    return Padding(
      padding: .fromLTRB(
        NinjaMetrics.screenPadding,
        topPadding,
        NinjaMetrics.screenPadding,
        4,
      ),
      child: Row(
        crossAxisAlignment: .baseline,
        textBaseline: .alphabetic,
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: .ellipsis,
              style: NinjaText.title.copyWith(color: colors.ink),
            ),
          ),
          if (action != null) ...[
            const SizedBox(width: 10),
            AppPressable(
              onTap: onAction,
              semanticsLabel: action,
              semanticsButton: true,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 44),
                child: Padding(
                  padding: const .symmetric(horizontal: 8, vertical: 7),
                  child: Center(
                    child: Text(
                      action,
                      style: NinjaText.buttonSmall.copyWith(
                        color: colors.brandInk,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

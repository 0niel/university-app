import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class CommunityPageHeader extends StatelessWidget {
  const CommunityPageHeader({
    required this.title,
    super.key,
    this.subtitle,
    this.actions = const [],
  });

  final String title;
  final String? subtitle;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final subtitle = this.subtitle;
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        NinjaMetrics.screenPadding,
        8,
        NinjaMetrics.screenPadding,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              NinjaIconButton(
                icon: const AppLineIconWidget(AppLineIcon.chevronL, size: 20),
                tooltip: context.l10n.back,
                onPressed: () => Navigator.of(context).maybePop(),
              ),
              const Spacer(),
              for (final action in actions) ...[
                const SizedBox(width: 8),
                action,
              ],
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: (textScale >= 1.6 ? NinjaText.title : NinjaText.display)
                .copyWith(color: colors.ink),
          ),
          if (subtitle != null && subtitle.isNotEmpty) ...[
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: NinjaText.subtext.copyWith(color: colors.mutedDark),
            ),
          ],
        ],
      ),
    );
  }
}

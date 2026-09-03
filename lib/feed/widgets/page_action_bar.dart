import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';

class PageActionBar extends StatelessWidget {
  const PageActionBar({
    super.key,
    this.title,
    this.onBack,
    this.actions = const <Widget>[],
  });

  final String? title;
  final VoidCallback? onBack;
  final List<Widget> actions;

  static double topInset(BuildContext context) =>
      math.max(AppSpacing.screenTop, MediaQuery.paddingOf(context).top + 12);

  @override
  Widget build(BuildContext context) {
    final title = this.title;
    return Padding(
      padding: EdgeInsets.only(top: topInset(context)),
      child: Row(
        children: [
          AppBackButton(onPressed: onBack),
          if (title != null) ...[
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.displaySmall.copyWith(
                  color: context.colors.ink,
                ),
              ),
            ),
          ] else
            const Spacer(),
          for (var i = 0; i < actions.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.sm),
            actions[i],
          ],
        ],
      ),
    );
  }
}

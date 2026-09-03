import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class CoworkHeader extends StatelessWidget {
  const CoworkHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final top = math.max(
      AppSpacing.screenTop,
      MediaQuery.paddingOf(context).top + 12,
    );
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screen,
        top,
        AppSpacing.screen,
        0,
      ),
      child: Row(
        children: [
          AppBackButton(onPressed: () => Navigator.of(context).maybePop()),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.coworkTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.displaySmall.copyWith(color: colors.ink),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.coworkVenue,
                  style: AppText.caption.copyWith(color: colors.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

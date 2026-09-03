import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/search/view/search_sheet.dart';

void openGlobalSearch(BuildContext context, {String? query}) {
  unawaited(showSearchSheet(context, query: query));
}

class GlobalSearchButton extends StatelessWidget {
  const GlobalSearchButton({super.key, this.query});

  final String? query;

  @override
  Widget build(BuildContext context) {
    return AppIconButton(
      icon: const AppLineIconWidget(AppLineIcon.search),
      tone: AppIconButtonTone.surface,
      shape: AppIconButtonShape.circle,
      size: AppIconButtonSize.compact,
      tooltip: context.l10n.search,
      onPressed: () => openGlobalSearch(context, query: query),
    );
  }
}

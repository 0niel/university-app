import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/navigation/routes/routes.dart';

void openGlobalSearch(BuildContext context, {String? query}) {
  unawaited(GlobalSearchRoute(query: query).push(context));
}

class GlobalSearchButton extends StatelessWidget {
  const GlobalSearchButton({super.key, this.query});

  final String? query;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'searchHero',
      child: NinjaIconButton(
        icon: const AppLineIconWidget(AppLineIcon.search),
        tooltip: context.l10n.search,
        onPressed: () => openGlobalSearch(context, query: query),
      ),
    );
  }
}

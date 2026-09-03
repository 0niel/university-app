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
  Widget build(BuildContext context) => AppInnerHeader(
    title: title,
    subtitle: subtitle,
    onBack: () => Navigator.of(context).maybePop(),
    backSemanticsLabel: context.l10n.back,
    actions: [for (final action in actions) AppHeaderAction(child: action)],
  );
}

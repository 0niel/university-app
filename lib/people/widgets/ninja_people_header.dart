import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class NinjaPeopleHeader extends StatelessWidget {
  const NinjaPeopleHeader({
    required this.title,
    required this.search,
    required this.addLabel,
    required this.onAdd,
    super.key,
  });

  final String title;
  final Widget search;
  final String addLabel;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) => AppInnerHeader(
    title: title,
    onBack: Navigator.of(context).canPop()
        ? () => Navigator.of(context).pop()
        : null,
    backSemanticsLabel: MaterialLocalizations.of(context).backButtonTooltip,
    actions: [
      AppHeaderAction(child: search),
      AppHeaderAction(
        icon: AppLineIcon.plus,
        semanticsLabel: addLabel,
        onTap: onAdd,
      ),
    ],
  );
}

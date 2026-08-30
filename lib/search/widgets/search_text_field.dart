import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    required this.controller,
    super.key,
    this.autofocus = false,
  });

  final TextEditingController controller;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'searchHero',
      child: NinjaInput(
        controller: controller,
        autofocus: autofocus,
        leadingIcon: const AppLineIconWidget(AppLineIcon.search),
        placeholder: context.l10n.searchGlobalHint,
      ),
    );
  }
}

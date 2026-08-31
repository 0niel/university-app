import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class SearchHeadlineText extends StatelessWidget {
  const SearchHeadlineText({required this.headerText, super.key});

  final String headerText;

  @override
  Widget build(BuildContext context) {
    return Text(
      headerText,
      style: NinjaText.title.copyWith(color: context.ninja.ink),
    );
  }
}

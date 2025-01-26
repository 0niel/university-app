import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';

class SearchHeadlineText extends StatelessWidget {
  const SearchHeadlineText({required this.headerText, super.key});

  final String headerText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 12),
      child: Text(
        headerText.toUpperCase(),
        style: AppTextStyle.chip.copyWith(
          color: Theme.of(context).extension<AppColors>()!.deactive,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';

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
          color: AppTheme.colorsOf(context).deactive,
        ),
      ),
    );
  }
}

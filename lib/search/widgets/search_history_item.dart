import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';

class SearchHistoryItem extends StatelessWidget {
  const SearchHistoryItem({
    Key? key,
    required this.query,
    required this.onPressed,
    required this.onClear,
  }) : super(key: key);

  final String query;
  final void Function(String) onPressed;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onPressed(query);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            query,
            style: AppTextStyle.titleS.copyWith(
              color: AppTheme.colorsOf(context).active,
            ),
          ),
        ),
      ),
    );
  }
}

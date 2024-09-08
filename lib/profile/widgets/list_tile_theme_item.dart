import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';

class ListTileThemeItem extends StatelessWidget {
  const ListTileThemeItem({
    Key? key,
    required this.title,
    required this.onTap,
    this.trailing,
  }) : super(key: key);

  final String title;
  final Widget? trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: AppTextStyle.body.copyWith(
          color: AppTheme.colorsOf(context).active,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      dense: true,
      onTap: () {
        onTap();
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      trailing: trailing,
    );
  }
}

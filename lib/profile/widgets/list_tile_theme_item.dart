import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';

class ListTileThemeItem extends StatelessWidget {
  const ListTileThemeItem({
    super.key,
    required this.title,
    required this.onTap,
    this.trailing,
  });

  final String title;
  final Widget? trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: AppTextStyle.body.copyWith(
          color: Theme.of(context).extension<AppColors>()!.active,
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

import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingsSection({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: AppTextStyle.bodyL.copyWith(
              color: Theme.of(context).extension<AppColors>()!.deactive,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
          color: Theme.of(context).extension<AppColors>()!.background02,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
          ),
        ),
      ],
    );
  }
}

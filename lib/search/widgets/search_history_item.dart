import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:app_ui/app_ui.dart';

class SearchHistoryItem extends StatelessWidget {
  const SearchHistoryItem({
    super.key,
    required this.query,
    required this.onPressed,
    required this.onClear,
  });

  final String query;
  final void Function(String) onPressed;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return PlatformTextButton(
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
              color: Theme.of(context).extension<AppColors>()!.active,
            ),
          ),
        ),
      ),
    );
  }
}

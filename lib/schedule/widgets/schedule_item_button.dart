import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';

class SelectedScheduleItemButton extends StatelessWidget {
  const SelectedScheduleItemButton({
    super.key,
    required this.isSelected,
    required this.text,
    this.onRefreshPressed,
    this.onSelectedPressed,
    this.onDeletePressed,
  });

  final bool isSelected;
  final String text;

  final VoidCallback? onRefreshPressed;
  final VoidCallback? onSelectedPressed;
  final VoidCallback? onDeletePressed;

  @override
  Widget build(BuildContext context) {
    if (isSelected) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          padding: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(width: 1.5, color: isSelected ? AppColors.dark.colorful05 : AppColors.dark.colorful06),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(text, style: AppTextStyle.buttonL, maxLines: 1, overflow: TextOverflow.ellipsis)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RawMaterialButton(
                    onPressed: () {
                      if (onRefreshPressed != null) {
                        onRefreshPressed!();
                      }
                    },
                    shape: const CircleBorder(),
                    constraints: const BoxConstraints(minWidth: 36.0, minHeight: 36.0),
                    child: Icon(
                      Icons.refresh_rounded,
                      color: isSelected ? AppColors.dark.colorful05 : AppColors.dark.colorful06,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.dark.deactive),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(text, style: AppTextStyle.buttonL, overflow: TextOverflow.ellipsis, maxLines: 1)),
            Row(
              children: [
                RawMaterialButton(
                  onPressed: () {
                    if (onSelectedPressed != null) {
                      onSelectedPressed!();
                    }
                  },
                  shape: const CircleBorder(),
                  constraints: const BoxConstraints(minWidth: 36.0, minHeight: 36.0),
                  child: const Icon(Icons.check_rounded),
                ),
                RawMaterialButton(
                  onPressed: () {
                    if (onDeletePressed != null) {
                      onDeletePressed!();
                    }
                  },
                  shape: const CircleBorder(),
                  constraints: const BoxConstraints(minWidth: 36.0, minHeight: 36.0),
                  child: const Icon(Icons.delete_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

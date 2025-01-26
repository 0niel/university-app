import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';

class TagBadge extends StatelessWidget {
  final String tag;
  final Function()? onPressed;
  final Color? color;
  final bool isSelected;

  const TagBadge({
    super.key,
    required this.tag,
    this.isSelected = false,
    this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      backgroundColor: isSelected
          ? color ?? Theme.of(context).extension<AppColors>()!.colorful05
          : Theme.of(context).extension<AppColors>()!.background02,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: color ?? Theme.of(context).extension<AppColors>()!.colorful05,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      disabledColor: Theme.of(context).extension<AppColors>()!.background01,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      label: Text(
        tag,
        style: AppTextStyle.body.copyWith(
          color: isSelected ? Colors.white : color ?? Theme.of(context).extension<AppColors>()!.colorful05,
        ),
      ),
      iconTheme: IconThemeData(
        color: isSelected ? Colors.white : color ?? Theme.of(context).extension<AppColors>()!.colorful05,
      ),
      onSelected: onPressed != null ? (_) => onPressed!() : null,
      selected: isSelected,
    );
  }
}

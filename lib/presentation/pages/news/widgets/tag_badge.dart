import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';

class TagBadge extends StatelessWidget {
  final String tag;
  final Function()? onPressed;
  final Color? color;
  final bool isSelected;

  const TagBadge({
    Key? key,
    required this.tag,
    this.isSelected = false,
    this.onPressed,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      backgroundColor:
          isSelected ? color ?? AppTheme.colorsOf(context).colorful05 : AppTheme.colorsOf(context).background02,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: color ?? AppTheme.colorsOf(context).colorful05,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      disabledColor: AppTheme.colorsOf(context).background01,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      label: Text(
        tag,
        style: AppTextStyle.body.copyWith(
          color: isSelected ? Colors.white : color ?? AppTheme.colorsOf(context).colorful05,
        ),
      ),
      iconTheme: IconThemeData(
        color: isSelected ? Colors.white : color ?? AppTheme.colorsOf(context).colorful05,
      ),
      onSelected: onPressed != null ? (_) => onPressed!() : null,
      selected: isSelected,
    );
  }
}

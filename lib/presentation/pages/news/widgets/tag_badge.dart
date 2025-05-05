import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';

class TagBadge extends StatelessWidget {
  final String tag;
  final Function()? onPressed;
  final Color? color;
  final bool isSelected;
  final bool isCompact; // Add new isCompact property

  const TagBadge({
    super.key,
    required this.tag,
    this.isSelected = false,
    this.onPressed,
    this.color,
    this.isCompact = false, // Default to false
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final tagColor = color ?? colors.colorful01;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(50),
          splashColor: tagColor.withOpacity(0.1),
          highlightColor: tagColor.withOpacity(0.1),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isCompact ? 10 : 14, // Smaller padding for compact mode
              vertical: isCompact ? 4 : 7, // Smaller padding for compact mode
            ),
            decoration: BoxDecoration(
              color: isSelected ? tagColor : Colors.transparent,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: isSelected ? Colors.transparent : tagColor,
                width: isCompact ? 1.0 : 1.5, // Thinner border for compact mode
              ),
              boxShadow:
                  isSelected
                      ? [BoxShadow(color: tagColor.withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 2))]
                      : null,
            ),
            child: Text(
              tag,
              style: (isCompact ? AppTextStyle.captionS : AppTextStyle.chip).copyWith(
                color: isSelected ? colors.white : tagColor,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
                fontSize: isCompact ? 10 : 12, // Smaller font for compact mode
              ),
            ),
          ),
        ),
      ),
    );
  }
}

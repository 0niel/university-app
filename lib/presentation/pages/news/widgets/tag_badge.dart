import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';

class TagBadge extends StatelessWidget {
  final String tag;
  final Function()? onPressed;
  final Color? color;

  const TagBadge({
    Key? key,
    required this.tag,
    this.onPressed,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: color ?? AppTheme.colors.colorful05, width: 2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Text(
              tag,
              style: AppTextStyle.body
                  .copyWith(color: color ?? AppTheme.colors.colorful05),
            ),
          ),
        ),
      ),
    );
  }
}

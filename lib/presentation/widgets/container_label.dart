import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';

class ContainerLabel extends StatelessWidget {
  final String label;
  const ContainerLabel({
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: AppTextStyle.body.copyWith(
          color: AppTheme.colorsOf(context).deactive,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

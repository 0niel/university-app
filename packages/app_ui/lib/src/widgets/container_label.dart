import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class ContainerLabel extends StatelessWidget {
  const ContainerLabel({
    required this.label,
    super.key,
  });
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: AppTextStyle.body.copyWith(
          color: Theme.of(context).extension<AppColors>()!.deactive,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

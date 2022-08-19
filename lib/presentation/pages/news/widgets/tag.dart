import 'package:flutter/material.dart';
import 'package:rtu_app_core/rtu_app_core.dart';

class Tag extends StatelessWidget {
  const Tag(this.text, {Key? key}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: NinjaConstant.grey200,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      child: NinjaText.bodySmall(
        text,
        color: NinjaConstant.grey600,
      ),
    );
  }
}

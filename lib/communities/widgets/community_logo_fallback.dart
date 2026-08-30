import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class CommunityLogoFallback extends StatelessWidget {
  const CommunityLogoFallback({required this.size, super.key});

  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    color: context.ninja.brandTint,
    alignment: Alignment.center,
    child: AppLineIconWidget(
      AppLineIcon.people,
      size: 20,
      color: context.ninja.brandInk,
    ),
  );
}

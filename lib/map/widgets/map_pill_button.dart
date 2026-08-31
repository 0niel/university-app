import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class MapPillButton extends StatelessWidget {
  const MapPillButton({required this.label, required this.onTap, super.key});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return AppPressable(
      onTap: onTap,
      semanticsLabel: label,
      semanticsButton: true,
      child: Container(
        constraints: const BoxConstraints(minHeight: 52),
        alignment: .center,
        padding: const .symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          color: colors.brand,
          borderRadius: .circular(NinjaRadius.pill),
        ),
        child: Text(
          label,
          maxLines: 2,
          textAlign: .center,
          overflow: .ellipsis,
          style: NinjaText.buttonLarge.copyWith(color: colors.onBrand),
        ),
      ),
    );
  }
}

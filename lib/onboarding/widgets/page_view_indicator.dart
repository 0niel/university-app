import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

class PageViewIndicator extends StatelessWidget {
  const PageViewIndicator({super.key, required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 3.75),
      height: isActive ? 15.0 : 11.0,
      width: isActive ? 15.0 : 11.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : AppTheme.colorsOf(context).active,
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        boxShadow: <BoxShadow>[
          isActive
              ? BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  offset: const Offset(0.0, 2.0),
                  blurRadius: 4.0,
                )
              : const BoxShadow(color: Colors.transparent),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ServiceIcon extends StatelessWidget {
  const ServiceIcon({
    super.key,
    required this.color,
    required this.iconColor,
    required this.icon,
  });

  final Color color;
  final Color iconColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: 24,
      ),
    );
  }
}

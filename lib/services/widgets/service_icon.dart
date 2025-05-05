import 'package:flutter/material.dart';

class ServiceIcon extends StatelessWidget {
  const ServiceIcon({super.key, required this.color, required this.iconColor, required this.icon});

  final Color color;
  final Color iconColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Icon(icon, color: iconColor, size: 24),
    );
  }
}

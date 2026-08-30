import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/services/services.dart';

class ServicesDragFeedback extends StatelessWidget {
  const ServicesDragFeedback({required this.service, super.key});

  final ServiceModel service;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Transform.scale(
        scale: 1.12,
        child: SizedBox(
          width: 72,
          child: ServiceTile(
            title: service.title,
            icon: service.icon,
            color: service.color,
          ),
        ),
      ),
    );
  }
}

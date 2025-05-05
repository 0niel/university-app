import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/schedule/widgets/mobile_map_view.dart'
    if (dart.library.html) 'package:rtu_mirea_app/schedule/widgets/web_map_view.dart';

/// Кроссплатформенный виджет для отображения карты
class CampusMapView extends StatelessWidget {
  /// Широта точки для отображения
  final double latitude;

  /// Долгота точки для отображения
  final double longitude;

  const CampusMapView({super.key, required this.latitude, required this.longitude});

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS) {
      return createMapView(latitude: latitude, longitude: longitude);
    } else {
      // На неподдерживаемых платформах показываем заглушку
      return Container(
        color: Colors.grey[200],
        child: const Center(child: Text('Карты доступны только на мобильных устройствах', textAlign: TextAlign.center)),
      );
    }
  }
}

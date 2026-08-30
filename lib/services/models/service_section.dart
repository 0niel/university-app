import 'package:rtu_mirea_app/services/models/service_model.dart';

class ServiceSection {
  const ServiceSection({
    required this.key,
    required this.title,
    required this.services,
  });

  final String key;
  final String title;
  final List<ServiceModel> services;
}

import 'package:flutter/material.dart';

/// Base service model
abstract class ServiceModel {
  final String title;
  final String? description;
  final IconData iconData;
  final Color color;
  final String? url;
  final bool isExternal;
  final String? routePath;

  const ServiceModel({
    required this.title,
    this.description,
    required this.iconData,
    required this.color,
    this.url,
    this.isExternal = true,
    this.routePath,
  });
}

/// Important service model (for ServiceCard)
class ImportantServiceModel extends ServiceModel {
  const ImportantServiceModel({
    required super.title,
    super.description,
    required super.iconData,
    required super.color,
    super.url,
    super.isExternal,
    super.routePath,
  });
}

/// Service tile model (for ServiceTile)
class ServiceTileModel extends ServiceModel {
  const ServiceTileModel({
    required super.title,
    super.description,
    required super.iconData,
    required super.color,
    super.url,
    super.isExternal,
    super.routePath,
  });
}

/// Horizontal service model (for HorizontalServiceCard)
class HorizontalServiceModel extends ServiceModel {
  const HorizontalServiceModel({
    required super.title,
    super.description,
    required super.iconData,
    required super.color,
    super.url,
    super.isExternal,
    super.routePath,
  });
}

/// Wide service model (for WideServiceCard)
class WideServiceModel extends ServiceModel {
  const WideServiceModel({
    required super.title,
    super.description,
    required super.iconData,
    required super.color,
    super.url,
    super.isExternal,
    super.routePath,
  });
}

/// Banner model (for VerticalBanner)
class BannerModel extends ServiceModel {
  final String action;

  const BannerModel({
    required super.title,
    super.description,
    required super.iconData,
    required super.color,
    super.url,
    super.isExternal,
    super.routePath,
    required this.action,
  });
}

/// Community model (for CommunityCard)
class CommunityModel {
  final String title;
  final String description;
  final String url;
  final String logoUrl;
  final bool isExternal;

  const CommunityModel({
    required this.title,
    required this.description,
    required this.url,
    required this.logoUrl,
    this.isExternal = true,
  });
}

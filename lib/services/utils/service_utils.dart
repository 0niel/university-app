import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:rtu_mirea_app/services/models/service_model.dart';

/// Utilities for working with services
class ServiceUtils {
  /// Navigate to a service based on its model
  static void navigateToService(BuildContext context, ServiceModel service) {
    if (service.isExternal) {
      if (service.url != null) {
        launchUrlString(service.url!, mode: LaunchMode.externalApplication);
      }
    } else {
      if (service.routePath != null) {
        context.go(service.routePath!);
      }
    }
  }

  /// Navigate to a community
  static void navigateToCommunity(CommunityModel community) {
    launchUrlString(community.url, mode: LaunchMode.externalApplication);
  }
}

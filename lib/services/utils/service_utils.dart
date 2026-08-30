import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/services/models/service_model.dart';
import 'package:url_launcher/url_launcher_string.dart';

abstract final class ServiceUtils {
  static void navigateToService(BuildContext context, ServiceModel service) {
    if (service.isExternal) {
      final url = service.url;
      if (url != null) {
        unawaited(launchUrlString(url, mode: .externalApplication));
      }
    } else {
      final routePath = service.routePath;
      if (routePath != null) {
        context.go(routePath);
      }
    }
  }
}

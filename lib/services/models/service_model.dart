import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_model.freezed.dart';

@freezed
abstract class ServiceModel with _$ServiceModel {
  const factory ServiceModel({
    required String title,
    required AppLineIcon icon,
    required Color color,
    String? url,
    @Default(true) bool isExternal,
    String? routePath,
  }) = _ServiceModel;
}

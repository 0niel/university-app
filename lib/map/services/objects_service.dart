import 'dart:convert';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/services.dart';

typedef ObjectsAssetLoader = Future<String> Function(String assetPath);

Future<String> _loadObjectsAsset(String assetPath) =>
    rootBundle.loadString(assetPath);

class ObjectsService {
  ObjectsService({this.onLoadObjects = _loadObjectsAsset});

  final ObjectsAssetLoader onLoadObjects;
  final Map<String, String> _idToNameMap = {};

  Future<void> loadObjects() async {
    final Object? decoded = jsonDecode(
      await onLoadObjects(Assets.maps.objects),
    );
    if (decoded is! Map<Object?, Object?>) {
      throw const FormatException('Objects manifest must be a JSON object');
    }

    final objects = decoded['objects'];
    if (objects is! List<Object?>) {
      throw const FormatException('Objects manifest must contain a list');
    }

    final names = <String, String>{};
    for (final object in objects.whereType<Map<Object?, Object?>>()) {
      final id = object['id'];
      final name = object['name'];
      if (object['type'] == 'room' && id is String && name is String) {
        names[id] = name;
      }
    }
    _idToNameMap
      ..clear()
      ..addAll(names);
  }

  String? getNameById(String id) => _idToNameMap[id];
}

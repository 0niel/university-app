import 'dart:convert';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/services.dart';

class ObjectsService {
  final Map<String, String> _idToNameMap = {};

  Future<void> loadObjects() async {
    final String jsonString = await rootBundle.loadString(Assets.maps.objects);
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    for (var obj in jsonData['objects']) {
      if (obj['type'] == 'room') {
        _idToNameMap[obj['id']] = obj['name'];
      }
    }
  }

  String? getNameById(String id) {
    return _idToNameMap[id];
  }
}

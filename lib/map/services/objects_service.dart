import 'dart:convert';
import 'package:flutter/services.dart';

class ObjectsService {
  final Map<String, String> _idToNameMap = {};

  Future<void> loadObjects() async {
    final String jsonString = await rootBundle.loadString('assets/maps/objects.json');
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

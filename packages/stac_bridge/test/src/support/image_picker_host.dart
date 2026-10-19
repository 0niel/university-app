import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:stac_bridge/stac_bridge.dart';

class ImagePickerHost extends MiniAppHost {
  ImagePickerHost(this.onPick);

  final Future<String?> Function() onPick;
  final List<bool> sources = [];
  int reloads = 0;

  @override
  Future<String?> pickImage({required bool fromCamera}) {
    sources.add(fromCamera);
    return onPick();
  }

  @override
  void closeMiniApp() => ();

  @override
  void openLocation(String location) => ();

  @override
  void openExternalUrl(Uri url) => ();

  @override
  void openPage({required String path, String? title}) => ();

  @override
  void openMiniApp({required String slug, String? path}) => ();

  @override
  void reload() => reloads++;

  @override
  void setStorage(String key, Object? value) => ();
}

import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:meta/meta.dart';
import 'package:neon_framework/src/platform/android.dart';
import 'package:neon_framework/src/platform/platform.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:universal_io/io.dart';

/// Linux specific platform information.
///
/// See:
///   * [NeonPlatform] to initialize and acquire an instance
///   * [AndroidNeonPlatform] for the Android implementation
@immutable
@internal
class LinuxNeonPlatform implements NeonPlatform {
  /// Creates a new Linux Neon platform.
  const LinuxNeonPlatform();

  @override
  bool get canUseWebView => false;

  @override
  bool get canUseQuickActions => false;

  @override
  bool get canUseWindowManager => true;

  @override
  bool get canUseCamera => false;

  @override
  bool get canUsePushNotifications => false;

  @override
  bool get canUseSharing => false;

  @override
  void init() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  @override
  Future<String?> saveFileWithPickDialog(String fileName, Uint8List data) async {
    final result = await FilePicker.platform.saveFile(
      fileName: fileName,
    );
    if (result != null) {
      await File(result).writeAsBytes(data);
    }

    return result;
  }
}

import 'dart:typed_data';

import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:meta/meta.dart';
import 'package:neon_framework/src/platform/linux.dart';
import 'package:neon_framework/src/platform/platform.dart';

/// Android specific platform information.
///
/// See:
///   * [NeonPlatform] to initialize and acquire an instance
///   * [LinuxNeonPlatform] for the Linux implementation
@immutable
@internal
class AndroidNeonPlatform implements NeonPlatform {
  /// Creates a new Android Neon platform.
  const AndroidNeonPlatform();

  @override
  bool get canUseCamera => true;

  @override
  bool get canUsePushNotifications => true;

  @override
  bool get canUseQuickActions => true;

  @override
  bool get canUseWebView => true;

  @override
  bool get canUseWindowManager => false;

  @override
  bool get canUseSharing => true;

  @override
  void init() {}

  @override
  Future<String?> saveFileWithPickDialog(String fileName, Uint8List data) => FlutterFileDialog.saveFile(
        params: SaveFileDialogParams(
          data: data,
          fileName: fileName,
        ),
      );
}

import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/mini_apps/widgets/mini_app_scan_error.dart';
import 'package:rtu_mirea_app/mini_apps/widgets/mini_app_scan_reticle.dart';
import 'package:rtu_mirea_app/mini_apps/widgets/mini_app_scan_top_bar.dart';

class MiniAppScanPage extends StatefulWidget {
  const MiniAppScanPage({super.key});

  static Route<String> route() {
    return MaterialPageRoute<String>(builder: (_) => const MiniAppScanPage());
  }

  @override
  State<MiniAppScanPage> createState() => _MiniAppScanPageState();
}

class _MiniAppScanPageState extends State<MiniAppScanPage> {
  final _controller = MobileScannerController(
    detectionSpeed: .noDuplicates,
  );
  bool _handled = false;

  @override
  void dispose() {
    unawaited(_controller.dispose());
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;
    final raw = capture.barcodes.firstOrNull?.rawValue;
    if (raw == null || raw.isEmpty) return;
    _handled = true;
    Navigator.of(context).pop(raw);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: .expand,
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
            errorBuilder: (context, error) =>
                MiniAppScanError(message: l10n.miniAppsScanCameraError),
          ),
          const MiniAppScanReticle(),
          SafeArea(
            child: Column(
              children: [
                MiniAppScanTopBar(controller: _controller),
                const Spacer(),
                Padding(
                  padding: const .fromLTRB(32, 0, 32, 48),
                  child: Text(
                    l10n.miniAppsScanInstruction,
                    textAlign: .center,
                    style: NinjaText.body.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

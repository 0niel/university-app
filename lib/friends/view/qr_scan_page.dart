import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:rtu_mirea_app/friends/view/ninja_qr_scan_error.dart';
import 'package:rtu_mirea_app/friends/view/ninja_qr_scan_reticle.dart';
import 'package:rtu_mirea_app/friends/view/ninja_qr_scan_top_bar.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/navigation/deep_links.dart';

class QrScanPage extends StatefulWidget {
  const QrScanPage({super.key});

  static Route<String> route() {
    return MaterialPageRoute<String>(builder: (_) => const QrScanPage());
  }

  @override
  State<QrScanPage> createState() => _QrScanPageState();
}

class _QrScanPageState extends State<QrScanPage> {
  final _controller = MobileScannerController(
    formats: const [.qrCode],
    detectionSpeed: .noDuplicates,
  );
  bool _handled = false;
  bool _invalid = false;

  @override
  void dispose() {
    unawaited(_controller.dispose());
    super.dispose();
  }

  String? _userIdFrom(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    final uri = Uri.tryParse(raw.trim());
    if (uri == null) return null;
    final location = DeepLinks.normalize(uri);
    if (location == null) return null;
    final id = Uri.parse(location).queryParameters['add'];
    return (id == null || id.isEmpty) ? null : id;
  }

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;
    final barcodes = capture.barcodes;
    final raw = barcodes.elementAtOrNull(0)?.rawValue;
    final userId = _userIdFrom(raw);
    if (userId == null) {
      if (!_invalid) setState(() => _invalid = true);
      return;
    }
    _handled = true;
    Navigator.of(context).pop(userId);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: .expand,
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
            errorBuilder: (context, error) => NinjaQrScanError(
              title: l10n.error,
              message: l10n.friendsScanCameraError,
            ),
          ),
          const NinjaQrScanReticle(),
          SafeArea(
            child: Column(
              children: [
                NinjaQrScanTopBar(controller: _controller),
                const Spacer(),
                Padding(
                  padding: const .fromLTRB(
                    AppSpacing.screen,
                    0,
                    AppSpacing.screen,
                    48,
                  ),
                  child: Container(
                    constraints: const BoxConstraints(
                      minHeight: AppControlSize.iconButton,
                    ),
                    padding: const .symmetric(
                      horizontal: AppSpacing.fieldGap,
                      vertical: AppSpacing.md,
                    ),
                    alignment: .center,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      borderRadius: .circular(AppRadius.full),
                    ),
                    child: Text(
                      _invalid
                          ? l10n.friendsScanInvalid
                          : l10n.friendsScanInstruction,
                      textAlign: .center,
                      style: AppText.body.copyWith(
                        color: _invalid ? colors.danger : Colors.white,
                      ),
                    ),
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

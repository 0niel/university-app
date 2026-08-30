import 'package:flutter/material.dart';

part 'scan_reticle_corner.dart';

class MiniAppScanReticle extends StatelessWidget {
  const MiniAppScanReticle({super.key});

  static const _size = 240.0;
  static const _arm = 34.0;
  static const _thickness = 3.0;

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox.square(
        dimension: _size,
        child: Stack(
          children: [
            _ScanReticleCorner(top: 0, left: 0),
            _ScanReticleCorner(top: 0, right: 0),
            _ScanReticleCorner(bottom: 0, left: 0),
            _ScanReticleCorner(bottom: 0, right: 0),
          ],
        ),
      ),
    );
  }
}

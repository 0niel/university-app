import 'package:flutter/material.dart';

part 'corner.dart';

class NinjaQrScanReticle extends StatelessWidget {
  const NinjaQrScanReticle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox.square(
        dimension: 240,
        child: Stack(
          children: [
            Positioned(top: 0, left: 0, child: _Corner(Alignment.topLeft)),
            Positioned(top: 0, right: 0, child: _Corner(Alignment.topRight)),
            Positioned(
              bottom: 0,
              left: 0,
              child: _Corner(Alignment.bottomLeft),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: _Corner(Alignment.bottomRight),
            ),
          ],
        ),
      ),
    );
  }
}

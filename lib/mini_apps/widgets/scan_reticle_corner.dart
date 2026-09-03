part of 'mini_app_scan_reticle.dart';

class _ScanReticleCorner extends StatelessWidget {
  const _ScanReticleCorner({this.top, this.bottom, this.left, this.right});

  final double? top;
  final double? bottom;
  final double? left;
  final double? right;

  @override
  Widget build(BuildContext context) {
    final bar = ColoredBox(color: context.colors.white);
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: SizedBox.square(
        dimension: MiniAppScanReticle._arm,
        child: Stack(
          children: [
            Positioned(
              top: top,
              bottom: bottom,
              left: 0,
              right: 0,
              height: MiniAppScanReticle._thickness,
              child: bar,
            ),
            Positioned(
              left: left,
              right: right,
              top: 0,
              bottom: 0,
              width: MiniAppScanReticle._thickness,
              child: bar,
            ),
          ],
        ),
      ),
    );
  }
}

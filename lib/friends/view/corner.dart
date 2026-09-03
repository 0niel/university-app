part of 'ninja_qr_scan_reticle.dart';

class _Corner extends StatelessWidget {
  const _Corner(this.alignment);

  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final isTop = alignment.y < 0;
    final isLeft = alignment.x < 0;
    const length = 34.0;
    const thickness = 3.0;
    const radius = BorderRadius.all(Radius.circular(thickness));
    final color = context.colors.white;
    return SizedBox.square(
      dimension: length,
      child: Stack(
        children: [
          Positioned(
            top: isTop ? 0 : null,
            bottom: isTop ? null : 0,
            left: isLeft ? 0 : null,
            right: isLeft ? null : 0,
            child: Container(
              width: length,
              height: thickness,
              decoration: BoxDecoration(color: color, borderRadius: radius),
            ),
          ),
          Positioned(
            top: isTop ? 0 : null,
            bottom: isTop ? null : 0,
            left: isLeft ? 0 : null,
            right: isLeft ? null : 0,
            child: Container(
              width: thickness,
              height: length,
              decoration: BoxDecoration(color: color, borderRadius: radius),
            ),
          ),
        ],
      ),
    );
  }
}

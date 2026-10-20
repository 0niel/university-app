part of 'nfc_pass_card.dart';

class _NfcCardDecoration extends CustomPainter {
  const _NfcCardDecoration({required this.accent});

  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * .98, size.height * .48);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = accent.withValues(alpha: .14);
    for (var index = 0; index < 5; index++) {
      final radius = size.width * (.15 + index * .075);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        math.pi * .54,
        math.pi * .92,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_NfcCardDecoration oldDelegate) =>
      accent != oldDelegate.accent;
}

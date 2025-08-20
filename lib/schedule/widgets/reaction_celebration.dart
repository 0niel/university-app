import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'dart:math' as math;

class ReactionCelebration extends StatefulWidget {
  const ReactionCelebration({super.key, required this.reactionType, required this.position, required this.onComplete});

  final ReactionType reactionType;
  final Offset position;
  final VoidCallback onComplete;

  @override
  State<ReactionCelebration> createState() => _ReactionCelebrationState();
}

class _ReactionCelebrationState extends State<ReactionCelebration> with TickerProviderStateMixin {
  late AnimationController _celebrationController;
  late List<_ParticleData> _particles;
  final _random = math.Random();

  @override
  void initState() {
    super.initState();
    _celebrationController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);

    // Generate random particles
    _particles = List.generate(15, (index) {
      final angle = _random.nextDouble() * 2 * math.pi;
      final velocity = 80 + _random.nextDouble() * 80;
      final life = 0.6 + _random.nextDouble() * 0.8;

      return _ParticleData(
        angle: angle,
        velocity: velocity,
        life: life,
        size: 15 + _random.nextDouble() * 15,
        rotation: _random.nextDouble() * 2 * math.pi,
        rotationSpeed: (_random.nextDouble() - 0.5) * 5,
      );
    });

    _celebrationController.forward().then((_) {
      widget.onComplete();
    });
  }

  @override
  void dispose() {
    _celebrationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.position.dx,
      top: widget.position.dy,
      child: AnimatedBuilder(
        animation: _celebrationController,
        builder: (context, child) {
          return Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // Floating particles
              ..._particles.map((particle) => _buildParticle(particle)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildParticle(_ParticleData particle) {
    final progress = _celebrationController.value;
    final particleProgress = (progress / particle.life).clamp(0.0, 1.0);

    if (particleProgress >= 1.0) {
      return const SizedBox.shrink();
    }

    final distance = particle.velocity * particleProgress;
    final x = math.cos(particle.angle) * distance;
    final y = math.sin(particle.angle) * distance - (particleProgress * particleProgress * 80); // Gravity effect

    final opacity = (1.0 - math.pow(particleProgress, 0.5)).clamp(0.0, 1.0);
    final scale = (1.0 - particleProgress).clamp(0.0, 1.0);
    final rotation = particle.rotation + (particle.rotationSpeed * particleProgress);

    return Transform.translate(
      offset: Offset(x, y),
      child: Transform.scale(
        scale: scale,
        child: Transform.rotate(
          angle: rotation,
          child: Opacity(
            opacity: opacity,
            child: Text(
              widget.reactionType.emoji,
              style: TextStyle(
                fontSize: particle.size,
                shadows: [Shadow(color: Colors.black.withOpacity(0.3), blurRadius: 5, offset: const Offset(2, 2))],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ParticleData {
  final double angle;
  final double velocity;
  final double life;
  final double size;
  final double rotation;
  final double rotationSpeed;

  _ParticleData({
    required this.angle,
    required this.velocity,
    required this.life,
    required this.size,
    required this.rotation,
    required this.rotationSpeed,
  });
}

class ReactionCelebrationOverlay extends StatefulWidget {
  const ReactionCelebrationOverlay({super.key, required this.reactionType, required this.position});

  final ReactionType reactionType;
  final Offset position;

  static void show(BuildContext context, {required ReactionType reactionType, required Offset position}) {
    final overlay = OverlayEntry(
      builder: (context) => ReactionCelebrationOverlay(reactionType: reactionType, position: position),
    );

    Overlay.of(context).insert(overlay);

    // Auto-remove after animation
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (overlay.mounted) {
        overlay.remove();
      }
    });
  }

  @override
  State<ReactionCelebrationOverlay> createState() => _ReactionCelebrationOverlayState();
}

class _ReactionCelebrationOverlayState extends State<ReactionCelebrationOverlay> {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ReactionCelebration(
        reactionType: widget.reactionType,
        position: widget.position,
        onComplete: () {
          // The overlay will be removed by the timer
        },
      ),
    );
  }
}

class ReactionToast extends StatelessWidget {
  const ReactionToast({super.key, required this.message, required this.reactionType});

  final String message;
  final ReactionType reactionType;

  static void show(BuildContext context, {required String message, required ReactionType reactionType}) {
    final overlay = OverlayEntry(builder: (context) => ReactionToast(message: message, reactionType: reactionType));

    Overlay.of(context).insert(overlay);

    // Auto-remove after delay
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (overlay.mounted) {
        overlay.remove();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
          bottom: 100,
          left: 20,
          right: 20,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5)),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(reactionType.emoji, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text(message, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
        )
        .animate()
        .slideY(begin: 1, end: 0, duration: const Duration(milliseconds: 300))
        .fade(duration: const Duration(milliseconds: 300))
        .then(delay: const Duration(milliseconds: 1400))
        .slideY(begin: 0, end: 1, duration: const Duration(milliseconds: 300))
        .fade(begin: 1, end: 0, duration: const Duration(milliseconds: 300));
  }
}

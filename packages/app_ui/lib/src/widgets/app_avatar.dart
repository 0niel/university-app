import 'package:app_ui/app_ui.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

/// Design: "Avatar" · Аватары — app-shell.jsx.
///
/// Initials avatar with deterministically seeded background color.
///
/// Pass [color] to override the auto-assigned palette color.
class AppAvatar extends StatelessWidget {
  const AppAvatar({required this.name, super.key, this.size = 36, this.color});

  final String name;
  final double size;
  final Color? color;

  static const _palette = [
    Color(0xFF7C5CFF),
    Color(0xFFFF6FB1),
    Color(0xFF34D399),
    Color(0xFF4DA8FF),
    Color(0xFFFFB020),
    Color(0xFFFF5577),
  ];

  /// Deterministic palette color for [name] — same seeding the avatar uses
  /// internally. Lets callers (e.g. map markers) tint surrounding chrome to
  /// match the avatar without re-implementing the hash.
  static Color colorFor(String name) {
    final hash = name.codeUnits.fold(0, (a, c) => a + c);
    return _palette.elementAtOrNull(hash % _palette.length) ??
        (_palette.firstOrNull ?? const Color(0xFF7C5CFF));
  }

  @override
  Widget build(BuildContext context) {
    final bg = color ?? colorFor(name);
    final initials = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((s) => s.isNotEmpty)
        .take(2)
        .map((s) => s.characters.firstOrNull?.toUpperCase() ?? '')
        .join();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        initials.isEmpty ? '?' : initials,
        style: AppText.tabular(
          TextStyle(
            fontSize: size * 0.38,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            height: 1,
          ),
        ),
      ),
    );
  }
}

/// Design: avatar stack · Аватары — screens-uikit.jsx.
///
/// A stacked row of [AppAvatar] widgets with overlap. Each avatar wears a
/// background-colored ring to separate it from the one beneath.
class AppAvatarStack extends StatelessWidget {
  const AppAvatarStack({
    required this.names,
    super.key,
    this.size = 36,
    this.overlap = 10,
  });

  /// Ring width drawn around each avatar; counts toward the laid-out diameter.
  static const _ring = 2.0;

  final List<String> names;
  final double size;
  final double overlap;

  @override
  Widget build(BuildContext context) {
    if (names.isEmpty) return const SizedBox.shrink();
    final bg = Theme.of(context).colors.background01;
    // The ring adds [_ring] px on every side (Border is laid out as padding),
    // so the real avatar diameter is size + 2·ring — size the box to it, else
    // the ring is clipped top/bottom/right.
    final diameter = size + _ring * 2;
    final step = size - overlap;
    return SizedBox(
      height: diameter,
      width: diameter + (names.length - 1) * step,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (var i = 0; i < names.length; i++)
            Positioned(
              left: i * step,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: bg, width: _ring),
                ),
                child: AppAvatar(name: names[i], size: size),
              ),
            ),
        ],
      ),
    );
  }
}

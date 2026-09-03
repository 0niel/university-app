import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_stripe_placeholder.dart';
import 'package:flutter/widgets.dart';

class AppAvatar extends StatelessWidget {
  const AppAvatar({
    required this.name,
    super.key,
    this.size = 36,
    this.color,
    this.backgroundColor,
    this.textStyle,
    this.imageUrl,
    this.levelBadge,
    this.online,
  });

  final String name;
  final double size;
  final Color? color;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final String? imageUrl;
  final int? levelBadge;
  final bool? online;

  static List<Color> _palette(AppColors colors) => [
        colors.accent,
        colors.lecture,
        colors.lab,
        colors.exam,
        colors.warn,
        colors.practice,
      ];

  static Color _pick(List<Color> palette, String name) {
    final hash = name.codeUnits.fold(0, (sum, unit) => sum + unit);
    return palette[hash % palette.length];
  }

  static Color colorFor(String name) => _pick(_palette(AppColors.light), name);

  static TextStyle initialsStyle(double size) {
    if (size <= 26) return AppText.sans(9, FontWeight.w800, height: 1);
    if (size <= 30) return AppText.sans(10, FontWeight.w800, height: 1);
    if (size <= 36) return AppText.sans(11, FontWeight.w800, height: 1);
    if (size <= 48) return AppText.sans(13, FontWeight.w700, height: 1);
    if (size <= 64) return AppText.sans(18, FontWeight.w700, height: 1);
    if (size <= 80) return AppText.sans(22, FontWeight.w700, height: 1);
    return AppText.sans(28, FontWeight.w700, height: 1);
  }

  static String initialsOf(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part.characters.first.toUpperCase());
    final initials = parts.join();
    return initials.isEmpty ? '?' : initials;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tone = color ?? _pick(_palette(colors), name);
    final url = imageUrl;
    final level = levelBadge;
    final dot = online;

    Widget avatar = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.tintOf(tone),
        shape: BoxShape.circle,
      ),
      child: Text(
        initialsOf(name),
        style: (textStyle ?? initialsStyle(size)).copyWith(color: tone),
      ),
    );

    if (url != null && url.isNotEmpty) {
      final placeholder = AppStripePlaceholder(
        shape: BoxShape.circle,
        base: colors.surface2,
        stripe: colors.surface,
        stripeWidth: 6,
      );
      avatar = ClipOval(
        child: SizedBox(
          width: size,
          height: size,
          child: Image.network(
            url,
            width: size,
            height: size,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) =>
                progress == null ? child : placeholder,
            errorBuilder: (context, error, stackTrace) => placeholder,
          ),
        ),
      );
    }

    if (level == null && dot == null) return avatar;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(child: avatar),
          if (level != null)
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.accent,
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.surface, width: 2),
                ),
                child: Text(
                  '$level',
                  style: AppText.countBadge.copyWith(color: colors.onAccent),
                ),
              ),
            ),
          if (dot != null)
            Positioned(
              right: 0,
              top: level == null ? null : 0,
              bottom: level == null ? 0 : null,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: dot ? colors.lecture : colors.muted2,
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.surface, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class AppAvatarStack extends StatelessWidget {
  const AppAvatarStack({
    required this.names,
    super.key,
    this.size = 36,
    this.overlap,
    this.maxVisible,
    this.extra = 0,
  });

  static const double _ring = 2;

  final List<String> names;
  final double size;
  final double? overlap;
  final int? maxVisible;
  final int extra;

  @override
  Widget build(BuildContext context) {
    if (names.isEmpty) return const SizedBox.shrink();

    final colors = context.colors;
    final limit = maxVisible == null
        ? names.length
        : (maxVisible! < names.length ? maxVisible! : names.length);
    final visible = names.take(limit).toList();
    final hidden = extra + (names.length - visible.length);
    final step = size - (overlap ?? (size <= 30 ? 8 : 10));
    final diameter = size + _ring * 2;
    final count = visible.length + (hidden > 0 ? 1 : 0);

    Widget ringed(Widget child) => Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: colors.surface, width: _ring),
          ),
          child: child,
        );

    return SizedBox(
      height: diameter,
      width: diameter + (count - 1) * step,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (var i = 0; i < visible.length; i++)
            Positioned(
              left: i * step,
              child: ringed(AppAvatar(name: visible[i], size: size)),
            ),
          if (hidden > 0)
            Positioned(
              left: visible.length * step,
              child: ringed(
                Container(
                  width: size,
                  height: size,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colors.surface2,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '+$hidden',
                    style: AppAvatar.initialsStyle(
                      size,
                    ).copyWith(color: colors.muted),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

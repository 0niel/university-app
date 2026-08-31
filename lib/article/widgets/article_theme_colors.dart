import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ArticleThemeColors extends ThemeExtension<ArticleThemeColors>
    with EquatableMixin {
  const ArticleThemeColors({
    required this.captionNormal,
    required this.captionLight,
  });

  final Color captionNormal;
  final Color captionLight;

  @override
  ArticleThemeColors copyWith({Color? captionNormal, Color? captionLight}) {
    return ArticleThemeColors(
      captionNormal: captionNormal ?? this.captionNormal,
      captionLight: captionLight ?? this.captionLight,
    );
  }

  @override
  ArticleThemeColors lerp(ThemeExtension<ArticleThemeColors>? other, double t) {
    if (other is! ArticleThemeColors) return this;
    return ArticleThemeColors(
      captionNormal:
          Color.lerp(captionNormal, other.captionNormal, t) ?? captionNormal,
      captionLight:
          Color.lerp(captionLight, other.captionLight, t) ?? captionLight,
    );
  }

  @override
  List<Object> get props => [captionNormal, captionLight];
}

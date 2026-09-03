import 'package:app_ui/src/colors/colors.dart';
import 'package:flutter/widgets.dart';

enum BadgeRarity { common, rare, epic, legendary }

extension BadgeRarityX on BadgeRarity {
  String get label => switch (this) {
        BadgeRarity.common => 'обычная',
        BadgeRarity.rare => 'редкая',
        BadgeRarity.epic => 'эпик',
        BadgeRarity.legendary => 'легендарная',
      };

  Color color(AppColors colors) => switch (this) {
        BadgeRarity.common => colors.muted,
        BadgeRarity.rare => colors.accent,
        BadgeRarity.epic => colors.lab,
        BadgeRarity.legendary => colors.warn,
      };

  static BadgeRarity fromString(String value) => switch (value) {
        'rare' => BadgeRarity.rare,
        'epic' => BadgeRarity.epic,
        'legendary' => BadgeRarity.legendary,
        _ => BadgeRarity.common,
      };
}

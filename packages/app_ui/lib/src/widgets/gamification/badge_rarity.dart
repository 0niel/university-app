import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

enum BadgeRarity { common, rare, epic, legendary }

extension BadgeRarityX on BadgeRarity {
  String get label => switch (this) {
        BadgeRarity.common => 'обычная',
        BadgeRarity.rare => 'редкая',
        BadgeRarity.epic => 'эпик',
        BadgeRarity.legendary => 'легендарная',
      };

  Color color(NinjaColors colors) => switch (this) {
        BadgeRarity.common => colors.muted,
        BadgeRarity.rare => colors.indigo,
        BadgeRarity.epic => colors.orange,
        BadgeRarity.legendary => colors.amber,
      };

  static BadgeRarity fromString(String value) => switch (value) {
        'rare' => BadgeRarity.rare,
        'epic' => BadgeRarity.epic,
        'legendary' => BadgeRarity.legendary,
        _ => BadgeRarity.common,
      };
}

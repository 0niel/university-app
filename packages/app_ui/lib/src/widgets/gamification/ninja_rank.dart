import 'package:app_ui/app_ui.dart';

enum NinjaRank {
  genin(emoji: '🥚', name: 'Genin', xpThreshold: 0),
  chunin(emoji: '🥷', name: 'Chunin', xpThreshold: 9 * kXpPerLevel),
  jonin(emoji: '⚔️', name: 'Jonin', xpThreshold: 19 * kXpPerLevel),
  kage(emoji: '🐉', name: 'Kage', xpThreshold: 29 * kXpPerLevel),
  ;

  const NinjaRank({
    required this.emoji,
    required this.name,
    required this.xpThreshold,
  });

  final String emoji;
  final String name;
  final int xpThreshold;

  static NinjaRank fromXp(int xp) {
    for (final rank in NinjaRank.values.reversed) {
      if (xp >= rank.xpThreshold) return rank;
    }
    return NinjaRank.genin;
  }

  NinjaRank? get next => switch (this) {
        NinjaRank.genin => NinjaRank.chunin,
        NinjaRank.chunin => NinjaRank.jonin,
        NinjaRank.jonin => NinjaRank.kage,
        NinjaRank.kage => null,
      };
}

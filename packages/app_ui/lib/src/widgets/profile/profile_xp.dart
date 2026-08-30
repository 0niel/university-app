const kXpPerLevel = 1000;

int levelFromXp(int xp) => (xp ~/ kXpPerLevel) + 1;

int xpIntoLevel(int xp) => xp % kXpPerLevel;

int xpToNextLevel(int xp) => kXpPerLevel - xpIntoLevel(xp);

String formatThousands(int value) {
  if (value < 1000) return '$value';
  final text = value.toString();
  final split = text.length - 3;
  return '${text.substring(0, split)} ${text.substring(split)}';
}

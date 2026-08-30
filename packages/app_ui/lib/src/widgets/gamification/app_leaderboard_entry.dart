class AppLeaderboardEntry {
  const AppLeaderboardEntry({
    required this.userId,
    required this.displayName,
    required this.xp,
    required this.position,
    this.level = 1,
    this.isCurrentUser = false,
  });

  final String userId;
  final String displayName;
  final int xp;
  final int position;
  final int level;
  final bool isCurrentUser;

  String get initials {
    final initialsText = displayName
        .trim()
        .split(RegExp(r'\s+'))
        .where((namePart) => namePart.isNotEmpty)
        .take(2)
        .map((namePart) => namePart.substring(0, 1))
        .join();
    return initialsText.isEmpty ? '?' : initialsText.toUpperCase();
  }
}

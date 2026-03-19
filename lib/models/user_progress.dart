class UserProgress {
  final int xp;
  final int streak;
  final DateTime? lastActivityDate;
  final int level;

  const UserProgress({
    this.xp = 0,
    this.streak = 0,
    this.lastActivityDate,
    this.level = 1,
  });

  int get xpForNextLevel => level * 100;
  int get xpIntoCurrentLevel => xp - _xpForLevel(level);
  double get levelProgress =>
      (xpIntoCurrentLevel / xpForNextLevel).clamp(0.0, 1.0);

  static int _xpForLevel(int lvl) {
    int total = 0;
    for (int i = 1; i < lvl; i++) {
      total += i * 100;
    }
    return total;
  }

  static int levelFromXp(int xp) {
    int lvl = 1;
    int threshold = 0;
    while (true) {
      threshold += lvl * 100;
      if (xp < threshold) break;
      lvl++;
    }
    return lvl;
  }

  String get levelTitle {
    if (level < 3) return 'Beginner';
    if (level < 6) return 'Apprentice';
    if (level < 10) return 'Developer';
    if (level < 15) return 'Engineer';
    return 'Master';
  }

  UserProgress copyWith({
    int? xp,
    int? streak,
    DateTime? lastActivityDate,
  }) {
    final newXp = xp ?? this.xp;
    return UserProgress(
      xp: newXp,
      streak: streak ?? this.streak,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
      level: levelFromXp(newXp),
    );
  }
}
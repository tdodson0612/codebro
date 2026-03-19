import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_progress.dart';

class XpManager extends ChangeNotifier {
  UserProgress _progress = const UserProgress();

  UserProgress get progress => _progress;

  static const int xpPerCorrectAnswer = 10;
  static const int xpPerLessonComplete = 25;
  static const int xpPerfectQuiz = 50;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final xp = prefs.getInt('user_xp') ?? 0;
    final streak = prefs.getInt('user_streak') ?? 0;
    final lastStr = prefs.getString('last_activity_date');
    final last = lastStr != null ? DateTime.tryParse(lastStr) : null;

    int currentStreak = streak;
    if (last != null) {
      final daysSince = DateTime.now().difference(last).inDays;
      if (daysSince > 1) currentStreak = 0;
    }

    _progress = UserProgress(
      xp: xp,
      streak: currentStreak,
      lastActivityDate: last,
      level: UserProgress.levelFromXp(xp),
    );
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_xp', _progress.xp);
    await prefs.setInt('user_streak', _progress.streak);
    if (_progress.lastActivityDate != null) {
      await prefs.setString(
          'last_activity_date', _progress.lastActivityDate!.toIso8601String());
    }
  }

  Future<int> awardCorrectAnswer() async {
    return _addXp(xpPerCorrectAnswer);
  }

  Future<int> awardLessonComplete() async {
    return _addXp(xpPerLessonComplete);
  }

  Future<int> awardPerfectQuiz() async {
    return _addXp(xpPerfectQuiz);
  }

  Future<int> _addXp(int amount) async {
    final oldLevel = _progress.level;
    final now = DateTime.now();
    final last = _progress.lastActivityDate;

    int newStreak = _progress.streak;
    if (last == null) {
      newStreak = 1;
    } else {
      final daysSince = now.difference(last).inDays;
      if (daysSince == 1) {
        newStreak = _progress.streak + 1;
      } else if (daysSince == 0) {
        newStreak = _progress.streak;
      } else {
        newStreak = 1;
      }
    }

    _progress = _progress.copyWith(
      xp: _progress.xp + amount,
      streak: newStreak,
      lastActivityDate: now,
    );

    await _save();
    notifyListeners();

    return _progress.level - oldLevel;
  }

  Future<void> resetAll() async {
    _progress = const UserProgress();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_xp');
    await prefs.remove('user_streak');
    await prefs.remove('last_activity_date');
    notifyListeners();
  }
}
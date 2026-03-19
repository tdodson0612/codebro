import 'package:shared_preferences/shared_preferences.dart';
import '../data/lessons.dart';

class ProgressTracker {
  static Future<void> markLessonCompleted(String language, String lessonTitle) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('$language-$lessonTitle', true);
  }

  static Future<bool> isLessonCompleted(String language, String lessonTitle) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('$language-$lessonTitle') ?? false;
  }

  static Future<void> resetProgress(String language) async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((k) => k.startsWith(language)).toList();
    for (var key in keys) {
      prefs.remove(key);
    }
  }
}

class ProgressUtils {
  static Future<double> getLanguageProgress(String language) async {
    final lessons = LessonData.getLessonsByLanguage(language);
    if (lessons.isEmpty) return 0;
    int completedCount = 0;
    for (var lesson in lessons) {
      bool completed = await ProgressTracker.isLessonCompleted(language, lesson.title);
      if (completed) completedCount++;
    }
    return completedCount / lessons.length;
  }
}

class GlobalProgress {
  static Future<double> getOverallProgress() async {
    final allLessons = LessonData.allLessons;
    int totalLessons = 0;
    int completedLessons = 0;

    for (var language in allLessons.keys) {
      final lessons = allLessons[language]!;
      totalLessons += lessons.length;
      for (var lesson in lessons) {
        bool completed = await ProgressTracker.isLessonCompleted(language, lesson.title);
        if (completed) completedLessons++;
      }
    }

    return totalLessons == 0 ? 0 : completedLessons / totalLessons;
  }
}

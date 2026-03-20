// Central lesson registry.
// Each language has its own folder under lib/lessons/
// with one file per lesson and an index file.

import '../lessons/c/c_lessons_index.dart';
import '../lessons/cpp/cpp_lessons_index.dart';
import '../lessons/csharp/csharp_lessons_index.dart';
import '../lessons/python/python_lessons_index.dart';
import '../lessons/java/java_lessons_index.dart';
import '../lessons/kotlin/kotlin_lessons_index.dart';
import '../lessons/javascript/js_lessons_index.dart';
import '../lessons/html/html_lessons_index.dart';
import '../lessons/css/css_lessons_index.dart';

import '../models/lesson.dart';

export '../lessons/c/c_lessons_index.dart';
export '../lessons/cpp/cpp_lessons_index.dart';
export '../lessons/csharp/csharp_lessons_index.dart';
export '../lessons/python/python_lessons_index.dart';
export '../lessons/java/java_lessons_index.dart';
export '../lessons/kotlin/kotlin_lessons_index.dart';
export '../lessons/javascript/js_lessons_index.dart';
export '../lessons/html/html_lessons_index.dart';
export '../lessons/css/css_lessons_index.dart';

class LessonData {
  static final Map<String, List<Lesson>> _lessons = {
    'C':          cLessons,
    'C++':        cppLessons,
    'C#':         csharpLessons,
    'Python':     pythonLessons,
    'Java':       javaLessons,
    'Kotlin':     kotlinLessons,
    'JavaScript': jsLessons,
    'HTML':       htmlLessons,
    'CSS':        cssLessons,
  };

  static List<Lesson> getLessonsByLanguage(String language) {
    return _lessons[language] ?? [];
  }

  static Map<String, List<Lesson>> get allLessons => _lessons;
}
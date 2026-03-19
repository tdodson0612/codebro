import 'quiz.dart';

class Lesson {
  final String title;
  final String content;
  final List<Quiz> quiz;
  final String language;

  Lesson({
    required this.title,
    required this.content,
    required this.quiz,
    required this.language,
  });
}

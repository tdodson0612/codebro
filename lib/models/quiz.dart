class QuizOption {
  final String text;
  final bool correct;

  QuizOption({required this.text, required this.correct});
}

class Quiz {
  final String question;
  final List<QuizOption> options;

  Quiz({required this.question, required this.options});
}

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cLesson09 = Lesson(
  language: 'C',
  title: 'Type Conversion and Casting',
  content: '''
🎯 METAPHOR:
Type conversion is like converting currencies.
You can convert $10 to Euros — but you lose precision.
Converting double 15.99 to int gives 15 — the .99 is
gone forever. The cast is you authorizing that conversion.

📖 EXPLANATION:
C converts types two ways:
1. Implicit — happens automatically (safe widening)
2. Explicit cast — you instruct the compiler

Promotion order (automatic):
char → short → int → long → float → double

💻 CODE:
#include <stdio.h>

int main() {
    // IMPLICIT CONVERSION
    int    i = 10;
    double d = i;        // int promoted to double
    printf("%.1f\\n", d); // 10.0
    
    int truncated = 15.9; // double truncated to int
    printf("%d\\n", truncated); // 15 (.9 is LOST!)
    
    // EXPLICIT CAST
    double pi    = 3.14159;
    int    whole = (int)pi;   // cast to int
    printf("Whole: %d\\n", whole); // 3
    
    // Integer vs float division
    int a = 7, b = 2;
    int   int_result = a / b;              // 3
    double dbl_result = (double)a / b;     // 3.5
    printf("Int:   %d\\n",   int_result);
    printf("Float: %.1f\\n", dbl_result);
    
    // Char ↔ int
    char ch  = 'A';
    int  num = (int)ch;      // 65
    char back = (char)66;    // 'B'
    printf("ASCII: %d  Char: %c\\n", num, back);
    
    return 0;
}

📝 RULES:
- Cast BEFORE division to get float result
- Narrowing (double→int) loses data
- Widening (int→double) is safe
- Signed→unsigned can produce surprising results
''',
  quiz: [
    Quiz(question: 'What happens when you cast 15.9 to int?', options: [
      QuizOption(text: 'It becomes 15 (truncated toward zero)', correct: true),
      QuizOption(text: 'It becomes 16 (rounded up)', correct: false),
      QuizOption(text: 'It causes a runtime error', correct: false),
      QuizOption(text: 'It stays 15.9', correct: false),
    ]),
    Quiz(question: 'What is the result of 7 / 2 when both are ints?', options: [
      QuizOption(text: '3', correct: true),
      QuizOption(text: '3.5', correct: false),
      QuizOption(text: '4', correct: false),
      QuizOption(text: '3.0', correct: false),
    ]),
    Quiz(question: 'How do you force float division with two ints a and b?', options: [
      QuizOption(text: '(double)a / b', correct: true),
      QuizOption(text: 'a / b', correct: false),
      QuizOption(text: 'double(a / b)', correct: false),
      QuizOption(text: 'a / (int)b', correct: false),
    ]),
  ],
);

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cLesson08 = Lesson(
  language: 'C',
  title: 'Constants and #define',
  content: """
🎯 METAPHOR:
Constants are like the speed of light — a fixed value
that never changes. Using named constants instead of
magic numbers makes code readable and easy to change.
If PI appears 50 times, change it in ONE place, not 50.

📖 EXPLANATION:
Two ways to define constants in C:

1. const keyword — typed, scoped constant
2. #define — preprocessor text replacement

💻 CODE:
#include <stdio.h>

// #define — no type, no semicolon, just text replacement
#define PI       3.14159265358979
#define MAX_SIZE 100
#define GREETING "Hello, World!"

int main() {
    // const — typed constant
    const double GRAVITY     = 9.81;
    const int    DAYS_IN_WEEK = 7;
    
    printf("%s\\n", GREETING);
    
    double area = PI * 5 * 5;
    printf("Area: %.2f\\n", area);
    
    printf("Gravity: %.2f\\n",  GRAVITY);
    printf("Days:    %d\\n",    DAYS_IN_WEEK);
    
    // GRAVITY = 10.0;  // ERROR: cannot assign to const
    
    // Function-like macro (always parenthesize args!)
    #define SQUARE(x) ((x) * (x))
    printf("Square of 5: %d\\n",   SQUARE(5));
    printf("Square of 3+1: %d\\n", SQUARE(3+1)); // = 16
    
    return 0;
}

📝 const vs #define:
const:
  ✅ Has a type (safer, debugger-friendly)
  ✅ Has scope
  ❌ C89: cannot use as array size

#define:
  ✅ Works anywhere including array sizes
  ❌ No type checking
  ❌ Can cause subtle bugs without parentheses

CONVENTION: ALL_CAPS_WITH_UNDERSCORES for constants
""",
  quiz: [
    Quiz(question: 'What is the naming convention for constants?', options: [
      QuizOption(text: 'ALL_CAPS_WITH_UNDERSCORES', correct: true),
      QuizOption(text: 'camelCase', correct: false),
      QuizOption(text: 'PascalCase', correct: false),
      QuizOption(text: 'lowercase_with_underscores', correct: false),
    ]),
    Quiz(question: 'What does #define do?', options: [
      QuizOption(text: 'Replaces text before compilation (preprocessor macro)', correct: true),
      QuizOption(text: 'Creates a typed constant variable', correct: false),
      QuizOption(text: 'Declares a function', correct: false),
      QuizOption(text: 'Imports a library', correct: false),
    ]),
    Quiz(question: 'Can you change the value of a const variable?', options: [
      QuizOption(text: 'No, it causes a compile error', correct: true),
      QuizOption(text: 'Yes, with a special keyword', correct: false),
      QuizOption(text: 'Yes, but only inside functions', correct: false),
      QuizOption(text: 'Only if it is a global const', correct: false),
    ]),
  ],
);

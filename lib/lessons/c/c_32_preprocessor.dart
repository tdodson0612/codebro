import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cLesson32 = Lesson(
  language: 'C',
  title: 'Preprocessor Directives',
  content: """
🎯 METAPHOR:
The preprocessor is like an editor working on your
manuscript BEFORE it goes to the printer (compiler).
It pastes in other files (#include), replaces words
(#define), and can remove whole chapters (#ifdef).
By the time the compiler sees your code, preprocessing
is already done.

📖 EXPLANATION:
The preprocessor runs BEFORE the compiler.
All directives start with #.

#include  → paste another file contents
#define   → text replacement macro
#ifdef    → if macro is defined
#ifndef   → if macro is NOT defined
#if / #elif / #else / #endif → conditional blocks
#pragma   → compiler-specific instructions
#error    → force a compile error

💻 CODE:
#include <stdio.h>

#define PI       3.14159265358979
#define SQUARE(x) ((x) * (x))
#define MAX(a,b)  ((a) > (b) ? (a) : (b))

#define SWAP(a,b,type) do { \
    type _t = (a);           \
    (a) = (b);               \
    (b) = _t;                \
} while(0)

#define DEBUG 1
#ifdef DEBUG
  #define LOG(m) printf("[DBG] %s\n", (m))
#else
  #define LOG(m)
#endif

int main() {
    printf("PI = %.5f\n",   PI);
    printf("SQUARE(5) = %d\n", SQUARE(5));
    printf("MAX(3,7) = %d\n",  MAX(3,7));

    int a = 10, b = 20;
    SWAP(a, b, int);
    printf("Swapped: a=%d b=%d\n", a, b);

    LOG("Program started");

    printf("File: %s  Line: %d\n", __FILE__, __LINE__);
    printf("Date: %s  Time: %s\n", __DATE__, __TIME__);

    return 0;
}
""",
  quiz: [
    Quiz(question: 'When does the preprocessor run?', options: [
      QuizOption(text: 'Before the compiler processes the code', correct: true),
      QuizOption(text: 'After compilation', correct: false),
      QuizOption(text: 'During program execution', correct: false),
      QuizOption(text: 'After linking', correct: false),
    ]),
    Quiz(question: 'What is an include guard used for?', options: [
      QuizOption(text: 'Preventing a header from being included multiple times', correct: true),
      QuizOption(text: 'Protecting code from being read', correct: false),
      QuizOption(text: 'Making includes faster', correct: false),
      QuizOption(text: 'Checking if a library is installed', correct: false),
    ]),
    Quiz(question: 'Why is #define SQUARE(x) x*x dangerous?', options: [
      QuizOption(text: 'SQUARE(1+2) expands to 1+2*1+2=5 not 9', correct: true),
      QuizOption(text: 'It causes a compile error', correct: false),
      QuizOption(text: 'It only works for single-digit numbers', correct: false),
      QuizOption(text: 'There is no danger', correct: false),
    ]),
  ],
);

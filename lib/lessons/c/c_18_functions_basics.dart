import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cLesson18 = Lesson(
  language: 'C',
  title: 'Functions — Basics',
  content: '''
🎯 METAPHOR:
A function is like a recipe card. Instead of writing out
all the steps to bake a cake every time, you write the
recipe once and just say "make cake" whenever you need it.
Functions let you write code once and use it many times.

📖 EXPLANATION:
A function is a named block of code that performs a task.
Functions help you:
- Avoid repeating code (DRY: Don't Repeat Yourself)
- Break a big problem into smaller pieces
- Make code easier to test and debug

Structure:
  return_type name(parameters) {
      body;
      return value;
  }

💻 CODE:
#include <stdio.h>

// Function PROTOTYPE — declare before use
int    add(int a, int b);
void   greet(char *name);
double circleArea(double radius);

// DEFINITIONS
int add(int a, int b) {
    return a + b;
}

void greet(char *name) {
    printf("Hello, %s!\\n", name);
}

double circleArea(double radius) {
    const double PI = 3.14159265358979;
    return PI * radius * radius;
}

int absolute(int n) {
    if (n < 0) return -n;
    return n;
}

int max(int a, int b) { return a > b ? a : b; }

int max3(int a, int b, int c) {
    return max(max(a, b), c); // functions can call each other
}

int main() {
    printf("3+7 = %d\\n", add(3, 7));
    greet("World");
    printf("Area r=5: %.2f\\n", circleArea(5.0));
    printf("abs(-42) = %d\\n", absolute(-42));
    printf("max(3,7,2) = %d\\n", max3(3, 7, 2));
    return 0;
}
''',
  quiz: [
    Quiz(question: 'What is a function prototype?', options: [
      QuizOption(text: 'Declaration telling compiler the function exists before its definition', correct: true),
      QuizOption(text: 'The first version of a function', correct: false),
      QuizOption(text: 'A function that cannot be changed', correct: false),
      QuizOption(text: 'A built-in C function', correct: false),
    ]),
    Quiz(question: 'What does void mean as a return type?', options: [
      QuizOption(text: 'The function returns nothing', correct: true),
      QuizOption(text: 'The function returns zero', correct: false),
      QuizOption(text: 'The function can return any type', correct: false),
      QuizOption(text: 'The function is empty', correct: false),
    ]),
    Quiz(question: 'What is the DRY principle?', options: [
      QuizOption(text: 'Don\'t Repeat Yourself — write code once, reuse it', correct: true),
      QuizOption(text: 'Delete Redundant Yields', correct: false),
      QuizOption(text: 'Do Repeat Yourself for clarity', correct: false),
      QuizOption(text: 'Dynamic Return Yield', correct: false),
    ]),
  ],
);

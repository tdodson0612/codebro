import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cLesson20 = Lesson(
  language: 'C',
  title: 'Recursion',
  content: '''
🎯 METAPHOR:
Recursion is like Russian nesting dolls. Each doll
contains a smaller doll, until you reach the tiniest
one that contains nothing. That smallest doll is your
BASE CASE — the condition that stops the nesting.
Without it, you open dolls forever (stack overflow).

📖 EXPLANATION:
A recursive function calls itself.
Every recursive function needs:
1. BASE CASE — stops the recursion
2. RECURSIVE CASE — calls itself with smaller problem

Without a base case → infinite recursion → stack overflow!

💻 CODE:
#include <stdio.h>

// Factorial: 5! = 5*4*3*2*1 = 120
long long factorial(int n) {
    if (n <= 1) return 1;           // base case
    return n * factorial(n - 1);   // recursive case
}

// Fibonacci: 0,1,1,2,3,5,8,13...
int fibonacci(int n) {
    if (n <= 0) return 0;
    if (n == 1) return 1;
    return fibonacci(n-1) + fibonacci(n-2);
}

// Sum of digits: 123 → 1+2+3 = 6
int sumDigits(int n) {
    if (n < 10) return n;
    return (n % 10) + sumDigits(n / 10);
}

void countdown(int n) {
    if (n <= 0) { printf("Go!\\n"); return; }
    printf("%d...\\n", n);
    countdown(n - 1);
}

int main() {
    printf("5! = %lld\\n",  factorial(5));  // 120
    printf("10! = %lld\\n", factorial(10)); // 3628800
    
    printf("Fibonacci: ");
    for (int i = 0; i < 10; i++)
        printf("%d ", fibonacci(i));
    printf("\\n");
    
    printf("sumDigits(12345) = %d\\n", sumDigits(12345)); // 15
    countdown(5);
    
    return 0;
}
''',
  quiz: [
    Quiz(question: 'What is the base case in recursion?', options: [
      QuizOption(text: 'The condition that stops the recursion', correct: true),
      QuizOption(text: 'The first call to the function', correct: false),
      QuizOption(text: 'The part that calls itself', correct: false),
      QuizOption(text: 'The return value', correct: false),
    ]),
    Quiz(question: 'What happens if a recursive function has no base case?', options: [
      QuizOption(text: 'Stack overflow from infinite recursion', correct: true),
      QuizOption(text: 'It returns 0', correct: false),
      QuizOption(text: 'The compiler catches it', correct: false),
      QuizOption(text: 'It runs once and stops', correct: false),
    ]),
    Quiz(question: 'What is factorial(0) and factorial(1)?', options: [
      QuizOption(text: 'Both are 1', correct: true),
      QuizOption(text: 'Both are 0', correct: false),
      QuizOption(text: '0 and 1 respectively', correct: false),
      QuizOption(text: '1 and 0 respectively', correct: false),
    ]),
  ],
);

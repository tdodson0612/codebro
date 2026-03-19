import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cLesson10 = Lesson(
  language: 'C',
  title: 'Arithmetic Operators',
  content: '''
🎯 METAPHOR:
Arithmetic operators are exactly like math class — plus,
minus, multiply, divide. The only tricky one is % (modulo),
which gives you the REMAINDER after dividing.
10 pizza slices ÷ 3 people = 3 each, with 1 leftover.
10 % 3 = 1.

📖 EXPLANATION:
Operator  Name           Example   Result
+         Addition        5 + 3     8
-         Subtraction     5 - 3     2
*         Multiplication  5 * 3     15
/         Division        7 / 2     3 (integer!)
%         Modulo          7 % 2     1

💻 CODE:
#include <stdio.h>

int main() {
    int a = 17, b = 5;
    
    printf("a + b = %d\\n",  a + b); // 22
    printf("a - b = %d\\n",  a - b); // 12
    printf("a * b = %d\\n",  a * b); // 85
    printf("a / b = %d\\n",  a / b); // 3 (integer division!)
    printf("a %% b = %d\\n", a % b); // 2

    // Useful modulo patterns
    printf("Even? %s\\n", (a % 2 == 0) ? "yes" : "no");
    printf("12-hour: %d\\n", 14 % 12); // 2pm
    
    // Increment / Decrement
    int x = 5;
    x++;
    printf("After x++: %d\\n", x);  // 6
    x--;
    printf("After x--: %d\\n", x);  // 5
    
    // Pre vs Post — important difference!
    int a2 = 5;
    int b2 = a2++;  // b2=5, THEN a2=6
    printf("Post: b2=%d a2=%d\\n", b2, a2);
    
    int a3 = 5;
    int b3 = ++a3;  // a3=6, THEN b3=6
    printf("Pre:  b3=%d a3=%d\\n", b3, a3);
    
    // Compound assignment
    int n = 10;
    n += 5;  // 15
    n -= 3;  // 12
    n *= 2;  // 24
    n /= 4;  // 6
    n %= 4;  // 2
    printf("Final n: %d\\n", n);
    
    return 0;
}
''',
  quiz: [
    Quiz(question: 'What does 17 % 5 equal?', options: [
      QuizOption(text: '2', correct: true),
      QuizOption(text: '3', correct: false),
      QuizOption(text: '1', correct: false),
      QuizOption(text: '12', correct: false),
    ]),
    Quiz(question: 'What is the difference between x++ and ++x?', options: [
      QuizOption(text: 'x++ returns current value then increments; ++x increments first', correct: true),
      QuizOption(text: 'They are identical', correct: false),
      QuizOption(text: '++x increments by 2', correct: false),
      QuizOption(text: 'x++ only works inside loops', correct: false),
    ]),
    Quiz(question: 'What does n += 5 mean?', options: [
      QuizOption(text: 'n = n + 5', correct: true),
      QuizOption(text: 'n + 5 without modifying n', correct: false),
      QuizOption(text: 'Add n to 5 and store in a new variable', correct: false),
      QuizOption(text: 'n = 5', correct: false),
    ]),
  ],
);

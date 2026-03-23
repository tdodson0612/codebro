import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cLesson16 = Lesson(
  language: 'C',
  title: 'while and do-while Loops',
  content: """
🎯 METAPHOR:
while is like a security guard checking a condition
before letting anyone in. If false already, nobody enters.

do-while is like a vending machine — you insert money
FIRST, then it checks if you want more. The action
happens AT LEAST ONCE regardless of the condition.

📖 EXPLANATION:
while:    checks condition BEFORE each iteration
do-while: checks condition AFTER each iteration

Use while when you might skip entirely.
Use do-while when you need at least one run.

💻 CODE:
#include <stdio.h>

int main() {
    // while
    int n = 1;
    while (n <= 5) {
        printf("%d ", n++);
    }
    printf("\\n"); // 1 2 3 4 5
    
    // Double until >= 100
    int number = 1;
    while (number < 100) number *= 2;
    printf("First power of 2 >= 100: %d\\n", number); // 128
    
    // do-while runs at least once
    int x = 10;
    do {
        printf("x = %d\\n", x++); // runs even though x > 5!
    } while (x < 5);
    
    // do-while for menu / input validation
    int choice = 0;
    do {
        choice++;
        printf("Trying choice: %d\\n", choice);
    } while (choice < 1 || choice > 3);
    printf("Valid choice: %d\\n", choice);
    
    return 0;
}

📝 CHOOSING THE RIGHT LOOP:
for      → know the count ahead of time
while    → loop until a condition changes
do-while → need to run at least once (menus, validation)
""",
  quiz: [
    Quiz(question: 'Key difference between while and do-while?', options: [
      QuizOption(text: 'do-while always executes the body at least once', correct: true),
      QuizOption(text: 'while is faster', correct: false),
      QuizOption(text: 'do-while can only count up', correct: false),
      QuizOption(text: 'There is no difference', correct: false),
    ]),
    Quiz(question: 'When should you use while instead of for?', options: [
      QuizOption(text: 'When you do not know in advance how many iterations', correct: true),
      QuizOption(text: 'When the loop must run exactly 10 times', correct: false),
      QuizOption(text: 'When working with arrays', correct: false),
      QuizOption(text: 'while loops are always preferred', correct: false),
    ]),
    Quiz(question: 'A do-while with a false condition runs how many times?', options: [
      QuizOption(text: '1 time (body runs before condition is checked)', correct: true),
      QuizOption(text: '0 times', correct: false),
      QuizOption(text: 'Infinite times', correct: false),
      QuizOption(text: 'Causes a compile error', correct: false),
    ]),
  ],
);

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cLesson15 = Lesson(
  language: 'C',
  title: 'for Loop',
  content: '''
🎯 METAPHOR:
A for loop is like a factory assembly line counter.
"Build 10 cars. Start at car #1. After each car, move
to the next. Stop at car #11." You know the count upfront.

📖 EXPLANATION:
The for loop combines three things in one line:
1. Initialization  — runs once at start
2. Condition       — checked before EACH iteration
3. Update          — runs after EACH iteration

Syntax: for (init; condition; update) { body }

💻 CODE:
#include <stdio.h>

int main() {
    // Basic
    for (int i = 0; i < 5; i++) {
        printf("i = %d\\n", i); // 0,1,2,3,4
    }
    
    // Count down
    for (int i = 10; i > 0; i--)
        printf("%d ", i);
    printf("\\n");
    
    // Step by 2
    for (int i = 0; i <= 10; i += 2)
        printf("%d ", i); // 0 2 4 6 8 10
    printf("\\n");
    
    // Sum 1 to 100
    int sum = 0;
    for (int i = 1; i <= 100; i++) sum += i;
    printf("Sum 1-100: %d\\n", sum); // 5050
    
    // Nested loops
    for (int i = 1; i <= 3; i++) {
        for (int j = 1; j <= 3; j++)
            printf("%d*%d=%d  ", i, j, i*j);
        printf("\\n");
    }
    
    // break exits loop early
    for (int i = 0; i < 100; i++) {
        if (i == 5) break;
        printf("%d ", i); // 0 1 2 3 4
    }
    printf("\\n");
    
    // continue skips current iteration
    for (int i = 0; i < 10; i++) {
        if (i % 2 == 0) continue;
        printf("%d ", i); // 1 3 5 7 9
    }
    printf("\\n");
    
    // Infinite loop
    int count = 0;
    for (;;) {
        if (++count >= 3) break;
    }
    printf("Count: %d\\n", count);
    
    return 0;
}
''',
  quiz: [
    Quiz(question: 'In for (int i=0; i<5; i++), how many times does the body run?', options: [
      QuizOption(text: '5 times (i = 0,1,2,3,4)', correct: true),
      QuizOption(text: '6 times', correct: false),
      QuizOption(text: '4 times', correct: false),
      QuizOption(text: 'Infinite times', correct: false),
    ]),
    Quiz(question: 'What does continue do in a loop?', options: [
      QuizOption(text: 'Skips the rest of the current iteration', correct: true),
      QuizOption(text: 'Exits the loop entirely', correct: false),
      QuizOption(text: 'Pauses the loop', correct: false),
      QuizOption(text: 'Restarts the loop from i=0', correct: false),
    ]),
    Quiz(question: 'What is for(;;)?', options: [
      QuizOption(text: 'An infinite loop', correct: true),
      QuizOption(text: 'A syntax error', correct: false),
      QuizOption(text: 'A loop that runs 3 times', correct: false),
      QuizOption(text: 'An empty loop that does nothing', correct: false),
    ]),
  ],
);

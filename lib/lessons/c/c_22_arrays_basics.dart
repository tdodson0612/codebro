import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cLesson22 = Lesson(
  language: 'C',
  title: 'Arrays — Basics',
  content: '''
🎯 METAPHOR:
An array is like a row of lockers at school. Each locker
is numbered starting from 0, and every locker holds the
same type of item. To get locker #3, you go directly
there — no searching. That is O(1) access.

📖 EXPLANATION:
An array stores multiple values of the SAME type in
CONTIGUOUS (back-to-back) memory. Fixed size, 0-indexed.
C does NOT check bounds — out-of-bounds is undefined behavior!

💻 CODE:
#include <stdio.h>

int main() {
    int grades[5] = {95, 87, 72, 88, 91};
    int zeros[5]  = {0};               // all zeros
    int primes[]  = {2, 3, 5, 7, 11};  // size inferred = 5

    printf("grades[0]: %d\\n", grades[0]); // 95
    printf("grades[4]: %d\\n", grades[4]); // 91

    grades[2] = 75;  // modify element

    int total = 0;
    for (int i = 0; i < 5; i++) total += grades[i];
    printf("Average: %.1f\\n", (double)total / 5);

    // Get count at runtime
    int n = sizeof(primes) / sizeof(primes[0]);
    printf("Primes count: %d\\n", n); // 5

    // 2D array
    int matrix[2][3] = {{1,2,3},{4,5,6}};
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 3; j++)
            printf("%d ", matrix[i][j]);
        printf("\\n");
    }

    return 0;
}
''',
  quiz: [
    Quiz(question: 'For int arr[5], what is the valid index range?', options: [
      QuizOption(text: '0 to 4', correct: true),
      QuizOption(text: '1 to 5', correct: false),
      QuizOption(text: '0 to 5', correct: false),
      QuizOption(text: '1 to 4', correct: false),
    ]),
    Quiz(question: 'How do you get the number of elements in array arr?', options: [
      QuizOption(text: 'sizeof(arr) / sizeof(arr[0])', correct: true),
      QuizOption(text: 'arr.length', correct: false),
      QuizOption(text: 'length(arr)', correct: false),
      QuizOption(text: 'sizeof(arr)', correct: false),
    ]),
    Quiz(question: 'What happens when you access arr[10] on a size-5 array?', options: [
      QuizOption(text: 'Undefined behavior — could crash or corrupt data', correct: true),
      QuizOption(text: 'Returns 0', correct: false),
      QuizOption(text: 'Compiler catches it and errors', correct: false),
      QuizOption(text: 'Returns the last valid element', correct: false),
    ]),
  ],
);

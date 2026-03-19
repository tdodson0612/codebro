import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cLesson26 = Lesson(
  language: 'C',
  title: 'Function Pointers',
  content: """
🎯 METAPHOR:
A function pointer is like a remote control. The remote
does not do anything itself — it holds a reference to
functions (channels). Press button 1: calls the news
function. Press button 2: calls the movie function.
You can pass the remote around or swap what it points to.
This is how callbacks and plugins work.

📖 EXPLANATION:
Functions in C have addresses in memory.
A function pointer stores that address, letting you
call functions indirectly or pass them as arguments.

Syntax: return_type (*ptr_name)(param_types)

💻 CODE:
#include <stdio.h>
#include <stdlib.h>

int add(int a, int b) { return a + b; }
int sub(int a, int b) { return a - b; }
int mul(int a, int b) { return a * b; }

// Callback pattern
void apply(int a, int b, int (*op)(int, int)) {
    printf("Result: %d\n", op(a, b));
}

// Comparator for qsort
int compareAsc(const void *a, const void *b) {
    return (*(int*)a - *(int*)b);
}

int main() {
    int (*fp)(int, int);

    fp = add;
    printf("add(3,4) = %d\n", fp(3,4));   // 7

    fp = sub;
    printf("sub(10,3) = %d\n", fp(10,3)); // 7

    // Array of function pointers
    int (*ops[3])(int,int) = {add, sub, mul};
    char *names[] = {"add", "sub", "mul"};
    for (int i = 0; i < 3; i++)
        printf("%s(6,2) = %d\n", names[i], ops[i](6,2));

    // Pass as callback
    apply(10, 5, add);
    apply(10, 5, sub);

    // qsort with comparator function pointer
    int arr[] = {5, 2, 8, 1, 9, 3};
    int n = sizeof(arr)/sizeof(arr[0]);
    qsort(arr, n, sizeof(int), compareAsc);
    for (int i = 0; i < n; i++) printf("%d ", arr[i]);
    printf("\n"); // 1 2 3 5 8 9

    return 0;
}
""",
  quiz: [
    Quiz(question: 'What is a function pointer?', options: [
      QuizOption(text: 'A variable that stores the address of a function', correct: true),
      QuizOption(text: 'A pointer inside a function', correct: false),
      QuizOption(text: 'A function that returns a pointer', correct: false),
      QuizOption(text: 'A special kind of array', correct: false),
    ]),
    Quiz(question: 'What is a callback function?', options: [
      QuizOption(text: 'A function passed as an argument to another function', correct: true),
      QuizOption(text: 'A function that calls itself', correct: false),
      QuizOption(text: 'A function called after a delay', correct: false),
      QuizOption(text: 'The main function', correct: false),
    ]),
    Quiz(question: 'What standard library function uses function pointers for sorting?', options: [
      QuizOption(text: 'qsort()', correct: true),
      QuizOption(text: 'sort()', correct: false),
      QuizOption(text: 'order()', correct: false),
      QuizOption(text: 'arrange()', correct: false),
    ]),
  ],
);

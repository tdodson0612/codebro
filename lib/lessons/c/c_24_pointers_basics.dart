import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cLesson24 = Lesson(
  language: 'C',
  title: 'Pointers — Basics',
  content: """
🎯 METAPHOR:
A pointer is like a street address written on paper.
The paper is not the house — it tells you WHERE the house
is. A variable holds a VALUE. A pointer holds an ADDRESS.
If a function needs to modify your variable, it needs
the address — the pointer.

📖 EXPLANATION:
A pointer is a variable that stores a MEMORY ADDRESS.

Operators:
& (address-of)  → gets the address of a variable
* (dereference) → follows the address to get the value

int x = 5;
int *p = &x;   // p holds the ADDRESS of x
*p = 10;       // changes x to 10 through the pointer

💻 CODE:
#include <stdio.h>

int main() {
    int x  = 42;
    int *p = &x;

    printf("Value of x:   %d\n", x);   // 42
    printf("Address of x: %p\n", &x);
    printf("Value of p:   %p\n", p);   // same address
    printf("Value at *p:  %d\n", *p);  // 42

    *p = 100;
    printf("x is now: %d\n", x);       // 100!

    // Pointer arithmetic with arrays
    int arr[] = {10, 20, 30, 40, 50};
    int *ptr  = arr;

    printf("arr[0]: %d\n", *ptr);       // 10
    printf("arr[2]: %d\n", *(ptr+2));   // 30
    ptr++;
    printf("After ptr++: %d\n", *ptr);  // 20

    // NULL pointer — points to nothing
    int *null_ptr = NULL;
    if (null_ptr == NULL)
        printf("Safe: pointer is null\n");

    // Pointer to pointer
    int  y    = 5;
    int *py   = &y;
    int **ppy = &py;
    printf("y via **: %d\n", **ppy);    // 5

    return 0;
}
""",
  quiz: [
    Quiz(question: 'What does the & operator do?', options: [
      QuizOption(text: 'Returns the memory address of a variable', correct: true),
      QuizOption(text: 'Dereferences a pointer', correct: false),
      QuizOption(text: 'Performs bitwise AND', correct: false),
      QuizOption(text: 'Declares a reference', correct: false),
    ]),
    Quiz(question: 'If int *p = &x, what does *p = 5 do?', options: [
      QuizOption(text: 'Sets x to 5 through the pointer', correct: true),
      QuizOption(text: 'Sets p to 5', correct: false),
      QuizOption(text: 'Creates a new variable with value 5', correct: false),
      QuizOption(text: 'Nothing — it is invalid syntax', correct: false),
    ]),
    Quiz(question: 'What is a NULL pointer?', options: [
      QuizOption(text: 'A pointer that points to nothing (address 0)', correct: true),
      QuizOption(text: 'A pointer to a null-terminated string', correct: false),
      QuizOption(text: 'An uninitialized pointer', correct: false),
      QuizOption(text: 'A pointer with no type', correct: false),
    ]),
  ],
);

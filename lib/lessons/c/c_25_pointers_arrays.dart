import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cLesson25 = Lesson(
  language: 'C',
  title: 'Pointers and Arrays',
  content: """
🎯 METAPHOR:
In C, an array name IS essentially a pointer to the first
element — like a building directory pointing to unit #1.
From there, you count forward to find any other unit.
Adding 1 to a pointer moves to the NEXT element.
That is pointer arithmetic.

📖 EXPLANATION:
Array names decay to pointers to their first element.
arr[i] is EXACTLY equivalent to *(arr + i).
They compile to identical machine code.

💻 CODE:
#include <stdio.h>

void modifyArray(int *arr, int size) {
    for (int i = 0; i < size; i++)
        arr[i] *= 2;  // modifies original!
}

int main() {
    int nums[] = {10, 20, 30, 40, 50};
    int *p = nums;

    // All four are identical:
    printf("nums[2]   = %d\n", nums[2]);
    printf("*(nums+2) = %d\n", *(nums+2));
    printf("p[2]      = %d\n", p[2]);
    printf("*(p+2)    = %d\n", *(p+2));

    // Traverse with pointer
    for (int *curr = nums; curr < nums+5; curr++)
        printf("%d ", *curr);
    printf("\n");

    // Pointer difference = element count between them
    printf("Diff: %ld\n", &nums[4] - &nums[1]); // 3

    // Arrays modify original via pointer
    modifyArray(nums, 5);
    for (int i = 0; i < 5; i++) printf("%d ", nums[i]);
    printf("\n"); // 20 40 60 80 100

    // String traversal with pointer
    char str[] = "Hello";
    for (char *s = str; *s != '\0'; s++)
        printf("%c", *s);
    printf("\n");

    return 0;
}
""",
  quiz: [
    Quiz(question: 'What is arr[i] equivalent to in pointer notation?', options: [
      QuizOption(text: '*(arr + i)', correct: true),
      QuizOption(text: '*arr + i', correct: false),
      QuizOption(text: '&arr[i]', correct: false),
      QuizOption(text: 'arr + i', correct: false),
    ]),
    Quiz(question: 'When you pass an array to a function, what does it receive?', options: [
      QuizOption(text: 'A pointer to the first element', correct: true),
      QuizOption(text: 'A complete copy of the array', correct: false),
      QuizOption(text: 'The size of the array', correct: false),
      QuizOption(text: 'An immutable reference', correct: false),
    ]),
    Quiz(question: 'If ptr points to arr[2], what does ptr + 3 point to?', options: [
      QuizOption(text: 'arr[5]', correct: true),
      QuizOption(text: 'arr[3]', correct: false),
      QuizOption(text: 'arr[2] + 3 (the value)', correct: false),
      QuizOption(text: 'arr[23]', correct: false),
    ]),
  ],
);

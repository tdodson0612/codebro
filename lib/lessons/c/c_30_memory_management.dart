import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cLesson30 = Lesson(
  language: 'C',
  title: 'Memory Management',
  content: """
🎯 METAPHOR:
The STACK is like a cafeteria tray stack. Each function call
pushes a tray; when the function returns the tray is removed
automatically. Fast, automatic, but limited in size.

The HEAP is like renting a storage unit. Rent any size
(malloc), keep it as long as needed, but YOU must return it
(free). Forget to return it = memory leak.

📖 EXPLANATION:
malloc  → allocate uninitialized heap memory
calloc  → allocate zero-initialized heap memory
realloc → resize an existing heap allocation
free    → release heap memory (always do this!)

💻 CODE:
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {
    // malloc — uninitialized
    int *a = (int*)malloc(5 * sizeof(int));
    if (!a) { fprintf(stderr, "malloc failed\n"); return 1; }
    a[0] = 99;
    printf("a[0] = %d\n", a[0]);
    free(a);
    a = NULL;  // set to NULL after free!

    // calloc — zero-initialized
    int *b = (int*)calloc(5, sizeof(int));
    printf("b[0] = %d\n", b[0]); // always 0
    free(b);

    // realloc — resize
    int *c = (int*)malloc(3 * sizeof(int));
    c[0]=1; c[1]=2; c[2]=3;
    c = (int*)realloc(c, 6 * sizeof(int)); // grow
    c[3]=4; c[4]=5; c[5]=6;
    for (int i = 0; i < 6; i++) printf("%d ", c[i]);
    printf("\n");
    free(c);

    // Dynamic string
    char *str = (char*)malloc(50);
    strcpy(str, "Hello, dynamic world!");
    printf("%s\n", str);
    free(str);

    return 0;
}

📝 COMMON MEMORY ERRORS:
Memory leak:     malloc without matching free
Double free:     free() called twice on same pointer
Use after free:  accessing memory after free()
Buffer overflow: writing past allocated size
Dangling ptr:    pointer to freed memory
""",
  quiz: [
    Quiz(question: 'Key difference between stack and heap?', options: [
      QuizOption(text: 'Stack is automatic and limited; heap is manual and larger', correct: true),
      QuizOption(text: 'Stack is for large data; heap for small', correct: false),
      QuizOption(text: 'Stack requires malloc; heap is automatic', correct: false),
      QuizOption(text: 'They are the same', correct: false),
    ]),
    Quiz(question: 'What does calloc do differently from malloc?', options: [
      QuizOption(text: 'calloc initializes all allocated memory to zero', correct: true),
      QuizOption(text: 'calloc is faster', correct: false),
      QuizOption(text: 'calloc can only allocate for arrays', correct: false),
      QuizOption(text: 'calloc does not need to be freed', correct: false),
    ]),
    Quiz(question: 'What is a memory leak?', options: [
      QuizOption(text: 'Allocated heap memory that is never freed', correct: true),
      QuizOption(text: 'Reading uninitialized memory', correct: false),
      QuizOption(text: 'A stack overflow', correct: false),
      QuizOption(text: 'Writing past the end of an array', correct: false),
    ]),
  ],
);

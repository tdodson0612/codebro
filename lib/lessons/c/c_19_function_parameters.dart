import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cLesson19 = Lesson(
  language: 'C',
  title: 'Function Parameters',
  content: '''
🎯 METAPHOR:
Parameters are like the ingredients list on a recipe card.
Arguments are what you actually use when cooking.
C passes arguments BY VALUE — you get a COPY of each
ingredient, so changes in the function do not affect
the originals. To modify originals, pass a pointer.

📖 EXPLANATION:
C passes arguments by VALUE (default) — function receives a copy.
To modify the original variable, pass a pointer (&variable).
Arrays are always passed as pointers automatically.

💻 CODE:
#include <stdio.h>

// Pass by VALUE — copy only, original unchanged
void tryToDouble(int n) {
    n = n * 2;
    printf("Inside: %d\\n", n);
}

// Pass by POINTER — modifies original
void actuallyDouble(int *n) {
    *n = *n * 2;
}

// Swap using pointers
void swap(int *a, int *b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}

// Array: always passed as pointer
void printArray(int arr[], int size) {
    for (int i = 0; i < size; i++)
        printf("%d ", arr[i]);
    printf("\\n");
}

// const prevents modification
double sumArray(const double arr[], int size) {
    double total = 0;
    for (int i = 0; i < size; i++) total += arr[i];
    return total;
}

int main() {
    int x = 5;
    tryToDouble(x);
    printf("After tryToDouble: %d\\n", x); // still 5!
    
    actuallyDouble(&x);
    printf("After actuallyDouble: %d\\n", x); // 10
    
    int a = 3, b = 7;
    swap(&a, &b);
    printf("Swapped: a=%d b=%d\\n", a, b); // a=7 b=3
    
    int nums[] = {1,2,3,4,5};
    printArray(nums, 5);
    
    double prices[] = {9.99, 14.50, 3.25};
    printf("Total: %.2f\\n", sumArray(prices, 3));
    
    return 0;
}
''',
  quiz: [
    Quiz(question: 'C passes arguments by value. What does this mean?', options: [
      QuizOption(text: 'Function receives a copy — changes do not affect original', correct: true),
      QuizOption(text: 'Function receives the original variable', correct: false),
      QuizOption(text: 'Function receives a reference', correct: false),
      QuizOption(text: 'Changes are saved automatically', correct: false),
    ]),
    Quiz(question: 'How do you allow a function to modify the original variable?', options: [
      QuizOption(text: 'Pass a pointer using &', correct: true),
      QuizOption(text: 'Use the ref keyword', correct: false),
      QuizOption(text: 'Declare the parameter as mutable', correct: false),
      QuizOption(text: 'It is not possible in C', correct: false),
    ]),
    Quiz(question: 'How are arrays passed to functions in C?', options: [
      QuizOption(text: 'As a pointer to the first element', correct: true),
      QuizOption(text: 'As a complete copy of the array', correct: false),
      QuizOption(text: 'By value, same as int', correct: false),
      QuizOption(text: 'They cannot be passed to functions', correct: false),
    ]),
  ],
);

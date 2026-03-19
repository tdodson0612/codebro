import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cLesson28 = Lesson(
  language: 'C',
  title: 'Unions',
  content: """
🎯 METAPHOR:
A union is like a shape-shifting container. It can hold
different types, but only ONE at a time. The container
size is determined by the LARGEST possible type —
like a parking space sized for a car, but a motorcycle
can park there too. Just one vehicle at a time.

📖 EXPLANATION:
Unlike structs (all fields coexist in memory), a union
allocates memory for only the LARGEST field, and ALL
fields share that same memory location.
Writing to one field OVERWRITES the others.

Use cases: memory efficiency, type punning, tagged variants.

💻 CODE:
#include <stdio.h>
#include <stdint.h>

union Data { int i; float f; double d; };

typedef enum { INT_T, FLOAT_T } Kind;
typedef struct {
    Kind kind;
    union { int ival; float fval; } val;
} Variant;

union FloatBytes { float f; uint8_t bytes[4]; };

int main() {
    printf("sizeof(union Data): %zu\n", sizeof(union Data)); // 8

    union Data d;
    d.i = 42;
    printf("int: %d\n", d.i);
    d.f = 3.14f;
    printf("float: %f\n", d.f);
    printf("int after float: %d\n", d.i); // GARBAGE!

    // Tagged union — safe usage
    Variant v;
    v.kind = INT_T;
    v.val.ival = 100;
    if (v.kind == INT_T) printf("Int: %d\n", v.val.ival);

    v.kind = FLOAT_T;
    v.val.fval = 2.71f;
    if (v.kind == FLOAT_T) printf("Float: %.2f\n", v.val.fval);

    // Raw bytes of float 1.0
    union FloatBytes fb;
    fb.f = 1.0f;
    printf("1.0f bytes: ");
    for (int i = 0; i < 4; i++) printf("%02X ", fb.bytes[i]);
    printf("\n"); // 00 00 80 3F

    return 0;
}
""",
  quiz: [
    Quiz(question: 'How much memory does a union use?', options: [
      QuizOption(text: 'The size of its largest member', correct: true),
      QuizOption(text: 'The sum of all member sizes', correct: false),
      QuizOption(text: 'The size of its smallest member', correct: false),
      QuizOption(text: 'A fixed 8 bytes always', correct: false),
    ]),
    Quiz(question: 'If you write to one union field and read another, what happens?', options: [
      QuizOption(text: 'Undefined behavior — memory is reinterpreted', correct: true),
      QuizOption(text: 'You get the previous value of that field', correct: false),
      QuizOption(text: 'You get 0', correct: false),
      QuizOption(text: 'It is a compile error', correct: false),
    ]),
    Quiz(question: 'What is a tagged union?', options: [
      QuizOption(text: 'A struct containing both a union and a type indicator field', correct: true),
      QuizOption(text: 'A union with labels on each field', correct: false),
      QuizOption(text: 'A union used with enum only', correct: false),
      QuizOption(text: 'A union with a name', correct: false),
    ]),
  ],
);

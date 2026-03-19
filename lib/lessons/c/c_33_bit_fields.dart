import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cLesson33 = Lesson(
  language: 'C',
  title: 'Bit Fields in Structs',
  content: """
🎯 METAPHOR:
Bit fields are like a compact form where each answer only
gets a few checkbox squares. "Married? Y/N" needs 1 bit.
"Day of week? 0-6" needs 3 bits. Instead of wasting a whole
int (32 bits) for each small value, bit fields pack multiple
values into one integer — like fitting everything on one
well-designed page.

📖 EXPLANATION:
Bit fields let you specify exactly how many bits each
struct member uses. Great for hardware registers, network
protocol headers, and memory-constrained embedded systems.

Syntax: type member_name : bit_width;

💻 CODE:
#include <stdio.h>

struct DateNormal {
    int year, month, day;  // 12 bytes total
};

struct DatePacked {
    unsigned int year  : 12;  // 0-4095
    unsigned int month : 4;   // 0-15 (use 1-12)
    unsigned int day   : 5;   // 0-31
};   // fits in 4 bytes!

struct Permissions {
    unsigned int read    : 1;
    unsigned int write   : 1;
    unsigned int execute : 1;
    unsigned int hidden  : 1;
    unsigned int         : 4;  // padding
};

int main() {
    printf("Normal: %zu bytes\n", sizeof(struct DateNormal));  // 12
    printf("Packed: %zu bytes\n", sizeof(struct DatePacked));  // 4

    struct DatePacked today = {2024, 3, 15};
    printf("Date: %d/%d/%d\n", today.month, today.day, today.year);

    // Overflow truncates!
    today.month = 20;  // 4-bit max is 15 — truncated
    printf("Overflowed month: %d\n", today.month);

    struct Permissions p = {.read=1, .write=1, .execute=0};
    printf("Size: %zu byte\n", sizeof(p));  // 1
    if (p.read)  printf("Can read\n");
    if (p.write) printf("Can write\n");

    return 0;
}
""",
  quiz: [
    Quiz(question: 'Main advantage of bit fields?', options: [
      QuizOption(text: 'Pack multiple small values into less memory', correct: true),
      QuizOption(text: 'Make code run faster', correct: false),
      QuizOption(text: 'Allow floating point values in structs', correct: false),
      QuizOption(text: 'Enable dynamic sizing', correct: false),
    ]),
    Quiz(question: 'What happens if you store a value too large for a bit field?', options: [
      QuizOption(text: 'The value is truncated to fit the available bits', correct: true),
      QuizOption(text: 'The program crashes', correct: false),
      QuizOption(text: 'A compile error occurs', correct: false),
      QuizOption(text: 'The bit field expands automatically', correct: false),
    ]),
    Quiz(question: 'A bit field with width 0 does what?', options: [
      QuizOption(text: 'Forces the next field to start at the next int boundary', correct: true),
      QuizOption(text: 'Creates a field that is always 0', correct: false),
      QuizOption(text: 'Causes a compile error', correct: false),
      QuizOption(text: 'Creates unnamed padding of 0 bits', correct: false),
    ]),
  ],
);

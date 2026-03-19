import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cLesson29 = Lesson(
  language: 'C',
  title: 'Enumerations (enum)',
  content: """
🎯 METAPHOR:
An enum is like days of the week on a calendar. Instead of
remembering Monday=1, Tuesday=2, you write MONDAY, TUESDAY,
and the compiler assigns numbers. Your code says "if today
is FRIDAY" instead of "if today is 5" — far more readable
and less error-prone. Enums eliminate magic numbers.

📖 EXPLANATION:
An enum defines a set of named integer constants.
Default: values start at 0 and increment by 1.
You can assign custom values.

💻 CODE:
#include <stdio.h>

enum Day {
    MONDAY, TUESDAY, WEDNESDAY,   // 0, 1, 2
    THURSDAY, FRIDAY,             // 3, 4
    SATURDAY, SUNDAY              // 5, 6
};

typedef enum { NORTH, SOUTH, EAST, WEST } Direction;

enum Permission {
    NONE    = 0,
    READ    = 1,    // 0001
    WRITE   = 2,    // 0010
    EXECUTE = 4,    // 0100
    ALL     = 7     // 0111
};

int main() {
    enum Day today = WEDNESDAY;
    const char *names[] = {
        "Monday","Tuesday","Wednesday",
        "Thursday","Friday","Saturday","Sunday"
    };
    printf("Today: %s\n", names[today]);

    switch (today) {
        case SATURDAY:
        case SUNDAY: printf("Weekend!\n"); break;
        default:     printf("Weekday\n");
    }

    // Bit flag permissions
    int perms = READ | WRITE;
    if (perms & READ)    printf("Can read\n");
    if (perms & WRITE)   printf("Can write\n");
    if (perms & EXECUTE) printf("Can execute\n"); // no

    return 0;
}
""",
  quiz: [
    Quiz(question: 'What value does the first enum member get by default?', options: [
      QuizOption(text: '0', correct: true),
      QuizOption(text: '1', correct: false),
      QuizOption(text: '-1', correct: false),
      QuizOption(text: 'Undefined', correct: false),
    ]),
    Quiz(question: 'Why use enum instead of plain integers?', options: [
      QuizOption(text: 'Enum names are self-documenting and reduce magic numbers', correct: true),
      QuizOption(text: 'Enums use less memory', correct: false),
      QuizOption(text: 'Enums allow floating point values', correct: false),
      QuizOption(text: 'Enums are required for switch statements', correct: false),
    ]),
    Quiz(question: 'How do you combine enum bit flags?', options: [
      QuizOption(text: 'Using the | (bitwise OR) operator', correct: true),
      QuizOption(text: 'Using + (addition)', correct: false),
      QuizOption(text: 'Using && (logical AND)', correct: false),
      QuizOption(text: 'You cannot combine enum values', correct: false),
    ]),
  ],
);

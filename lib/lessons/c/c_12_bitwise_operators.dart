import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cLesson12 = Lesson(
  language: 'C',
  title: 'Bitwise Operators',
  content: """
🎯 METAPHOR:
Bitwise operators work at the level of individual bits —
the 0s and 1s making up every number. Think of a byte as
8 light switches. Bitwise operators let you flip individual
switches, check if one is on, or combine switch patterns.
This is how games store flags, how encryption works, and
how hardware registers are controlled.

📖 EXPLANATION:
Operator  Name        Example (4-bit)
&         AND         1010 & 1100 = 1000
|         OR          1010 | 1100 = 1110
^         XOR         1010 ^ 1100 = 0110
~         NOT (flip)  ~1010 = 0101
<<        Left shift  1010 << 1  = 10100
>>        Right shift 1010 >> 1  = 0101

💻 CODE:
#include <stdio.h>

int main() {
    int flags = 0b00000000;
    int READ    = 0b00000001; // bit 0
    int WRITE   = 0b00000010; // bit 1
    int EXECUTE = 0b00000100; // bit 2
    
    // Set a bit (turn ON)
    flags |= READ;
    flags |= WRITE;
    printf("Flags after set: %d\\n", flags); // 3
    
    // Check a bit
    if (flags & READ)    printf("Can read\\n");
    if (flags & WRITE)   printf("Can write\\n");
    if (flags & EXECUTE) printf("Can execute\\n"); // no
    
    // Clear a bit (turn OFF)
    flags &= ~WRITE;
    printf("After clear write: %d\\n", flags); // 1
    
    // Toggle a bit (flip)
    flags ^= READ;
    printf("After toggle read: %d\\n", flags); // 0
    
    // Shift = fast multiply/divide by powers of 2
    int x = 5;
    printf("5 << 3 = %d\\n", x << 3); // 5 * 8 = 40
    printf("40 >> 3 = %d\\n", 40 >> 3); // 40 / 8 = 5
    
    return 0;
}
""",
  quiz: [
    Quiz(question: 'What does bitwise & (AND) return for each bit position?', options: [
      QuizOption(text: '1 only if BOTH inputs have 1', correct: true),
      QuizOption(text: '1 if EITHER input has 1', correct: false),
      QuizOption(text: 'Flips all bits', correct: false),
      QuizOption(text: 'Shifts bits left', correct: false),
    ]),
    Quiz(question: 'How do you check if bit 3 (value 8) is set in variable x?', options: [
      QuizOption(text: 'x & 8', correct: true),
      QuizOption(text: 'x | 8', correct: false),
      QuizOption(text: 'x ^ 8', correct: false),
      QuizOption(text: 'x >> 8', correct: false),
    ]),
    Quiz(question: 'What does x << 2 do?', options: [
      QuizOption(text: 'Multiplies x by 4 (2^2)', correct: true),
      QuizOption(text: 'Divides x by 4', correct: false),
      QuizOption(text: 'Adds 2 to x', correct: false),
      QuizOption(text: 'Shifts x right by 2', correct: false),
    ]),
  ],
);

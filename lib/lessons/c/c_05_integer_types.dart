import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cLesson05 = Lesson(
  language: 'C',
  title: 'Integer Types',
  content: '''
🎯 METAPHOR:
Integer types are like different sized containers at a store.
A tiny cup holds less than a bucket, but takes up less space.
Choosing the right container size saves memory and prevents
overflow — when a number gets too big for its container
and wraps around to the opposite extreme.

📖 EXPLANATION:
C has several integer types. On most 64-bit systems:

Type          Size    Signed Range
char          1 byte  -128 to 127
short         2 bytes -32,768 to 32,767
int           4 bytes -2,147,483,648 to 2,147,483,647
long          8 bytes -(2^63) to (2^63)-1
long long     8 bytes same as long on most systems

Add "unsigned" to store only positives (doubles the max):
unsigned int  4 bytes  0 to 4,294,967,295

💻 CODE:
#include <stdio.h>
#include <limits.h>  // INT_MAX, INT_MIN, etc.

int main() {
    char  c  = 127;
    short s  = 32767;
    int   i  = 2147483647;
    long  l  = 9223372036854775807L;   // L suffix for long
    
    unsigned int ui = 4294967295U;     // U suffix for unsigned
    
    printf("char max:     %d\\n",  CHAR_MAX);
    printf("short max:    %d\\n",  SHRT_MAX);
    printf("int max:      %d\\n",  INT_MAX);
    printf("long max:     %ld\\n", LONG_MAX);
    printf("unsigned int: %u\\n",  ui);
    
    // sizeof tells you the byte size
    printf("int size:  %zu bytes\\n", sizeof(int));
    printf("long size: %zu bytes\\n", sizeof(long));
    
    // Integer overflow — wraps around!
    int overflow = INT_MAX + 1;
    printf("Overflow: %d\\n", overflow);  // -2147483648 !
    
    return 0;
}

📝 KEY POINTS:
- Use int for most whole numbers
- Use long / long long for very large numbers
- Use unsigned when value is never negative
- L suffix = long literal, LL = long long, U = unsigned
''',
  quiz: [
    Quiz(question: 'How many bytes does int typically use?', options: [
      QuizOption(text: '4 bytes', correct: true),
      QuizOption(text: '1 byte', correct: false),
      QuizOption(text: '8 bytes', correct: false),
      QuizOption(text: '2 bytes', correct: false),
    ]),
    Quiz(question: 'What happens when an integer overflows?', options: [
      QuizOption(text: 'It wraps around to the opposite extreme', correct: true),
      QuizOption(text: 'The program crashes', correct: false),
      QuizOption(text: 'It stays at the maximum value', correct: false),
      QuizOption(text: 'The compiler gives an error', correct: false),
    ]),
    Quiz(question: 'What does unsigned mean for an integer type?', options: [
      QuizOption(text: 'It can only store non-negative values', correct: true),
      QuizOption(text: 'It has no sign character in printf', correct: false),
      QuizOption(text: 'It is smaller in memory', correct: false),
      QuizOption(text: 'It cannot be used in arithmetic', correct: false),
    ]),
  ],
);

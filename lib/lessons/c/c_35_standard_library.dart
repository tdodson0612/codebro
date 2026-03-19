import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cLesson35 = Lesson(
  language: 'C',
  title: 'Standard Library Overview',
  content: """
🎯 METAPHOR:
The C standard library is like a fully-equipped toolbox
included with the language. Each header file is a different
drawer. stdio.h is the I/O drawer. math.h is the calculator
drawer. string.h is the text tools drawer. Learn which
drawer to open for what you need — and never build a
hammer from scratch when one is already in the toolbox.

📖 EXPLANATION:
Major C standard library headers:

<stdio.h>    printf, scanf, fopen, fclose, fread, fwrite
<stdlib.h>   malloc, free, atoi, rand, qsort, exit, abs
<string.h>   strlen, strcpy, strcat, strcmp, strstr, memcpy
<math.h>     sin, cos, sqrt, pow, ceil, floor  (link: -lm)
<time.h>     time, localtime, strftime, clock
<ctype.h>    isalpha, isdigit, toupper, tolower
<limits.h>   INT_MAX, CHAR_MAX, LONG_MAX, etc.
<float.h>    DBL_MAX, FLT_EPSILON, DBL_MIN
<errno.h>    errno, EINVAL, ENOENT, ENOMEM
<assert.h>   assert(condition)
<setjmp.h>   setjmp, longjmp
<signal.h>   signal, raise
<stdint.h>   int8_t, uint32_t, int64_t, etc.    (C99)
<stdbool.h>  bool, true, false                   (C99)
<stdarg.h>   va_list, va_start, va_arg, va_end
<stddef.h>   NULL, size_t, ptrdiff_t, offsetof
<complex.h>  complex numbers                     (C99)

💻 CODE:
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <stdint.h>
#include <stdbool.h>

int main() {
    // Fixed-width integers (stdint.h)
    int32_t  exactly32 = 2147483647;
    uint8_t  byte      = 255;
    printf("int32: %d  uint8: %u\n", exactly32, byte);

    // Boolean type (stdbool.h)
    bool flag = true;
    printf("flag: %s\n", flag ? "true" : "false");

    // Random numbers (stdlib.h)
    srand((unsigned)time(NULL));
    for (int i = 0; i < 5; i++)
        printf("%d ", rand() % 100);
    printf("\n");

    // Date and time (time.h)
    time_t now = time(NULL);
    struct tm *local = localtime(&now);
    printf("Year: %d, Month: %d, Day: %d\n",
        local->tm_year + 1900,
        local->tm_mon  + 1,
        local->tm_mday);

    // qsort (stdlib.h)
    int arr[] = {5, 3, 8, 1, 9};
    int cmp(const void *a, const void *b) { return *(int*)a - *(int*)b; }
    // Note: nested functions are GCC extension — usually define outside
    // qsort(arr, 5, sizeof(int), cmp);

    return 0;
}
""",
  quiz: [
    Quiz(question: 'Which header provides fixed-width integer types like int32_t?', options: [
      QuizOption(text: '<stdint.h>', correct: true),
      QuizOption(text: '<limits.h>', correct: false),
      QuizOption(text: '<stdlib.h>', correct: false),
      QuizOption(text: '<types.h>', correct: false),
    ]),
    Quiz(question: 'Which linker flag do you need when using <math.h>?', options: [
      QuizOption(text: '-lm', correct: true),
      QuizOption(text: '-lmath', correct: false),
      QuizOption(text: '-math', correct: false),
      QuizOption(text: 'No flag needed', correct: false),
    ]),
    Quiz(question: 'Which header provides the bool type in C?', options: [
      QuizOption(text: '<stdbool.h>', correct: true),
      QuizOption(text: '<bool.h>', correct: false),
      QuizOption(text: '<types.h>', correct: false),
      QuizOption(text: 'C has no bool type', correct: false),
    ]),
  ],
);

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cLesson34 = Lesson(
  language: 'C',
  title: 'Error Handling with errno',
  content: """
🎯 METAPHOR:
errno is like a sticky note the operating system leaves
on your desk when something goes wrong. After calling a
function, check the note (errno) to see WHAT went wrong.
The note is only valid right after the failure — the next
system call might replace it, so read it immediately.

📖 EXPLANATION:
C does not have exceptions. Error handling uses:
1. Return values (NULL, -1) to signal failure
2. errno — global integer set by library functions
3. perror() — prints errno as a human-readable message
4. strerror() — converts errno number to string

Common errno codes:
ENOENT=2   No such file or directory
EACCES=13  Permission denied
ENOMEM=12  Out of memory
EINVAL=22  Invalid argument

💻 CODE:
#include <stdio.h>
#include <errno.h>
#include <string.h>

int safeDivide(int a, int b, int *result) {
    if (b == 0) { errno = EINVAL; return -1; }
    *result = a / b;
    return 0;
}

int main() {
    // File error
    FILE *f = fopen("nonexistent.txt", "r");
    if (f == NULL) {
        printf("errno = %d\n",       errno);
        printf("Error: %s\n", strerror(errno));
        perror("fopen");
    }

    // Custom error handling
    int result;
    if (safeDivide(10, 0, &result) == -1)
        printf("Division error: %s\n", strerror(errno));

    if (safeDivide(10, 2, &result) == 0)
        printf("10/2 = %d\n", result);

    // strtol with error checking
    char *end;
    errno = 0;
    long val = strtol("  123abc", &end, 10);
    printf("Parsed: %ld, Remaining: '%s'\n", val, end);

    return 0;
}
""",
  quiz: [
    Quiz(question: 'What is errno?', options: [
      QuizOption(text: 'A global integer set by library functions to indicate errors', correct: true),
      QuizOption(text: 'A function that returns error messages', correct: false),
      QuizOption(text: 'A C keyword for error handling', correct: false),
      QuizOption(text: 'The return value of main()', correct: false),
    ]),
    Quiz(question: 'What does perror() do?', options: [
      QuizOption(text: 'Prints a human-readable error message based on errno', correct: true),
      QuizOption(text: 'Returns the current errno value', correct: false),
      QuizOption(text: 'Clears errno', correct: false),
      QuizOption(text: 'Terminates the program with an error', correct: false),
    ]),
    Quiz(question: 'Why set errno = 0 before calling some functions?', options: [
      QuizOption(text: 'To distinguish a real error from a leftover errno value', correct: true),
      QuizOption(text: 'errno = 0 is required by the C standard', correct: false),
      QuizOption(text: 'It makes the function run faster', correct: false),
      QuizOption(text: 'errno is automatically cleared anyway', correct: false),
    ]),
  ],
);

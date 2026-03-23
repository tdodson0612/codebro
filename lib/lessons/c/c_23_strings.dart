import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cLesson23 = Lesson(
  language: 'C',
  title: 'Strings in C',
  content: """
🎯 METAPHOR:
A C string is like a line of train cars where each car
carries one character. The last car is always a special
"end of train" car containing \\0 (null terminator).
Without it, the train never knows where it ends and keeps
reading whatever is in memory next — until it crashes.

📖 EXPLANATION:
C has no built-in string type. Strings are char arrays
terminated by \\0 (null character, value 0).

"Hello" is stored as: H e l l o \\0
                       0 1 2 3 4  5
Array needs 6 slots for 5 characters + null terminator.

💻 CODE:
#include <stdio.h>
#include <string.h>

int main() {
    char str1[10] = "Hello";
    char str2[]   = "World";  // size = 6

    printf("%s\\n", str1);
    printf("strlen: %zu\\n", strlen(str1)); // 5
    printf("sizeof: %zu\\n", sizeof(str1)); // 10

    // String functions from string.h
    char dest[20];
    strcpy(dest, str1);           // copy
    strcat(dest, " ");            // concatenate
    strcat(dest, str2);
    printf("Joined: %s\\n", dest); // Hello World

    if (strcmp(str1, "Hello") == 0)
        printf("Strings are equal\\n");

    // Safe copy with size limit
    char safe[10];
    strncpy(safe, "Very long string", 9);
    safe[9] = '\\0';  // always manually terminate!
    printf("Safe: %s\\n", safe);

    // Searching
    char sentence[] = "The quick brown fox";
    char *found = strstr(sentence, "brown");
    if (found) printf("Found: %s\\n", found); // brown fox

    // String to number
    int    n = atoi("42");
    double d = atof("3.14");
    printf("atoi: %d  atof: %.2f\\n", n, d);

    return 0;
}
""",
  quiz: [
    Quiz(question: 'What marks the end of a C string?', options: [
      QuizOption(text: 'The null character \\0', correct: true),
      QuizOption(text: 'A space character', correct: false),
      QuizOption(text: 'The length stored in the array', correct: false),
      QuizOption(text: 'A special end marker', correct: false),
    ]),
    Quiz(question: 'For the string "Hello", what array size do you need?', options: [
      QuizOption(text: '6 (5 characters + null terminator)', correct: true),
      QuizOption(text: '5 (one per character)', correct: false),
      QuizOption(text: '7 (5 + null + safety)', correct: false),
      QuizOption(text: '4 (just the unique letters)', correct: false),
    ]),
    Quiz(question: 'What does strcmp return when two strings are equal?', options: [
      QuizOption(text: '0', correct: true),
      QuizOption(text: '1', correct: false),
      QuizOption(text: 'true', correct: false),
      QuizOption(text: '-1', correct: false),
    ]),
  ],
);

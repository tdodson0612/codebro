import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cLesson17 = Lesson(
  language: 'C',
  title: 'goto and Labels',
  content: '''
🎯 METAPHOR:
goto is like a teleporter in a building that can take
you to any room instantly. Sounds useful, but imagine
a building where people teleport randomly — no one can
follow the flow. That is spaghetti code. The one
acceptable use: escaping deeply nested loops cleanly.

📖 EXPLANATION:
goto jumps unconditionally to a labeled statement.
Considered bad practice in most situations because it
makes control flow impossible to follow.

Acceptable uses:
- Breaking out of multiple nested loops
- Error handling / cleanup in low-level C code

💻 CODE:
#include <stdio.h>

int main() {
    // Acceptable: clean exit from nested loops
    for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 5; j++) {
            if (i == 2 && j == 3) {
                printf("Found at (%d,%d)\\n", i, j);
                goto done;
            }
        }
    }
    done:
    printf("Search complete\\n");
    
    // Error handling pattern
    int *ptr = NULL;
    int result = 1;
    
    if (result == 0) goto cleanup;
    result = 1; // more work
    if (result == 0) goto cleanup;
    
    printf("All succeeded\\n");
    goto end;
    
    cleanup:
    printf("Cleaning up\\n");
    
    end:
    printf("Done\\n");
    return 0;
}

📝 RULES:
- goto can only jump within the same function
- Cannot jump over variable declarations
- Label names end with a colon (:)
- Prefer break, continue, return over goto
''',
  quiz: [
    Quiz(question: 'Why is goto generally avoided?', options: [
      QuizOption(text: 'It creates spaghetti code that is hard to follow', correct: true),
      QuizOption(text: 'It is very slow', correct: false),
      QuizOption(text: 'It is not part of the C standard', correct: false),
      QuizOption(text: 'It only works on older compilers', correct: false),
    ]),
    Quiz(question: 'One acceptable common use of goto?', options: [
      QuizOption(text: 'Breaking out of deeply nested loops or error cleanup', correct: true),
      QuizOption(text: 'Creating infinite loops', correct: false),
      QuizOption(text: 'Replacing if statements', correct: false),
      QuizOption(text: 'Calling functions', correct: false),
    ]),
    Quiz(question: 'Can goto jump between functions?', options: [
      QuizOption(text: 'No — only within the same function', correct: true),
      QuizOption(text: 'Yes, to any label in the program', correct: false),
      QuizOption(text: 'Only to labels in the same file', correct: false),
      QuizOption(text: 'Yes, but only to main()', correct: false),
    ]),
  ],
);

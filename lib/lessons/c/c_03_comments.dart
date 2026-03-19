import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cLesson03 = Lesson(
  language: 'C',
  title: 'Comments',
  content: '''
🎯 METAPHOR:
Comments are like sticky notes on your code.
The compiler completely ignores them — they are only
there for humans reading the code. Future-you will thank
present-you for writing good comments.

📖 EXPLANATION:
C has two types of comments:
1. Single-line: // text
2. Multi-line:  /* text */

Comments are removed by the preprocessor before compilation.
They have zero effect on program behavior or performance.

💻 CODE:
#include <stdio.h>

// This is a single-line comment

/*
   This is a multi-line comment.
   Useful for longer explanations.
*/

int main() {
    // Print a greeting
    printf("Hello!\\n");  // comment at end of line
    
    /*
     * Block-style multi-line comment
     * used inside functions
     */
    
    return 0; // success
}

📝 BEST PRACTICES:
✅ Comment WHY, not WHAT
   Good: // reverse string because API expects reversed input
   Bad:  // reverse the string  (code already shows this)

✅ Keep comments up to date

✅ Mark work items:
   // TODO: handle negative numbers
   // FIXME: crashes when input is empty
''',
  quiz: [
    Quiz(question: 'Which is a single-line comment in C?', options: [
      QuizOption(text: '// comment', correct: true),
      QuizOption(text: '/* comment */', correct: false),
      QuizOption(text: '# comment', correct: false),
      QuizOption(text: '-- comment', correct: false),
    ]),
    Quiz(question: 'Do comments affect program performance?', options: [
      QuizOption(text: 'No, they are removed before compilation', correct: true),
      QuizOption(text: 'Yes, they slow down the program', correct: false),
      QuizOption(text: 'Only multi-line comments do', correct: false),
      QuizOption(text: 'Only if they are very long', correct: false),
    ]),
    Quiz(question: 'What should comments explain?', options: [
      QuizOption(text: 'WHY the code does something', correct: true),
      QuizOption(text: 'WHAT every line does literally', correct: false),
      QuizOption(text: 'Only the function names', correct: false),
      QuizOption(text: 'Nothing, comments are bad practice', correct: false),
    ]),
  ],
);

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cLesson07 = Lesson(
  language: 'C',
  title: 'char Type and ASCII',
  content: '''
🎯 METAPHOR:
A char is like a single key on a keyboard.
Each key has a number behind it — its ASCII code.
When you press A, the computer stores the number 65.
char lets you work with those individual characters.

📖 EXPLANATION:
char stores a single character — but under the hood
it is just a small integer (1 byte). C uses ASCII
encoding to map characters to numbers.

Key ASCII values:
'A'=65  'Z'=90  'a'=97  'z'=122
'0'=48  '9'=57  ' '=32
'\\n'=10  '\\t'=9  '\\0'=0 (null)

💻 CODE:
#include <stdio.h>
#include <ctype.h>  // character classification functions

int main() {
    char letter = 'A';
    
    printf("Letter: %c\\n", letter);
    printf("As number: %d\\n", letter);  // 65
    
    // Char arithmetic (chars are integers!)
    char next  = letter + 1;   // 'B'
    char lower = letter + 32;  // 'a'  (A=65, a=97, diff=32)
    printf("Next: %c\\n",  next);
    printf("Lower: %c\\n", lower);
    
    // Better: use ctype.h
    printf("tolower: %c\\n", tolower('A')); // a
    printf("toupper: %c\\n", toupper('z')); // Z
    
    printf("isalpha('A'): %d\\n", isalpha('A'));  // non-zero=true
    printf("isdigit('5'): %d\\n", isdigit('5'));
    printf("isspace(' '): %d\\n", isspace(' '));
    
    return 0;
}

📝 ESCAPE SEQUENCES:
\\n  → newline     \\t → tab
\\r  → carriage return
\\\\  → backslash   \\'  → single quote
\\"  → double quote  \\0  → null character
\\a  → bell/alert   \\b  → backspace
''',
  quiz: [
    Quiz(question: 'What is the ASCII value of capital A?', options: [
      QuizOption(text: '65', correct: true),
      QuizOption(text: '97', correct: false),
      QuizOption(text: '41', correct: false),
      QuizOption(text: '48', correct: false),
    ]),
    Quiz(question: 'What does \\0 represent?', options: [
      QuizOption(text: 'The null character (value 0)', correct: true),
      QuizOption(text: 'The digit zero', correct: false),
      QuizOption(text: 'A newline', correct: false),
      QuizOption(text: 'An empty string', correct: false),
    ]),
    Quiz(question: 'Which header provides tolower() and isdigit()?', options: [
      QuizOption(text: 'ctype.h', correct: true),
      QuizOption(text: 'stdio.h', correct: false),
      QuizOption(text: 'string.h', correct: false),
      QuizOption(text: 'char.h', correct: false),
    ]),
  ],
);

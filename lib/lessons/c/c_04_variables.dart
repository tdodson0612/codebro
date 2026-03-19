import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cLesson04 = Lesson(
  language: 'C',
  title: 'Variables',
  content: '''
🎯 METAPHOR:
A variable is like a labeled box. You give the box a name
(like "age"), and you can put a value in it, take it out,
or replace it. In C, you also have to tell the box what
SIZE it is before you use it — that is the data type.

📖 EXPLANATION:
A variable is a named location in memory that stores a value.
In C you must declare variables before using them.

Declaration syntax:
  type name;
  type name = value;   (declaration + initialization)

Rules for variable names:
- Can contain letters, digits, underscores
- Must start with a letter or underscore
- Case-sensitive (age ≠ Age ≠ AGE)
- Cannot be a keyword (int, return, etc.)

💻 CODE:
#include <stdio.h>

int main() {
    // Declaration only (value is garbage!)
    int age;
    
    // Declaration with initialization
    int score     = 100;
    float temp    = 98.6;
    char grade    = 'A';
    
    // Assignment after declaration
    age = 25;
    
    printf("Age: %d\\n",   age);
    printf("Score: %d\\n", score);
    printf("Temp: %.1f\\n",temp);
    printf("Grade: %c\\n", grade);
    
    // Multiple declarations
    int x = 1, y = 2, z = 3;
    
    return 0;
}

📝 FORMAT SPECIFIERS:
%d   → int
%f   → float / double
%c   → char
%s   → string (char array)
%ld  → long
%p   → pointer address
%x   → hexadecimal
%%   → literal % sign
''',
  quiz: [
    Quiz(question: 'What is a variable?', options: [
      QuizOption(text: 'A named location in memory that stores a value', correct: true),
      QuizOption(text: 'A fixed value that never changes', correct: false),
      QuizOption(text: 'A function that returns a value', correct: false),
      QuizOption(text: 'A type of loop', correct: false),
    ]),
    Quiz(question: 'Which variable name is valid in C?', options: [
      QuizOption(text: '_myVar', correct: true),
      QuizOption(text: '2ndValue', correct: false),
      QuizOption(text: 'my-var', correct: false),
      QuizOption(text: 'int', correct: false),
    ]),
    Quiz(question: 'What format specifier prints an int?', options: [
      QuizOption(text: '%d', correct: true),
      QuizOption(text: '%f', correct: false),
      QuizOption(text: '%c', correct: false),
      QuizOption(text: '%s', correct: false),
    ]),
  ],
);

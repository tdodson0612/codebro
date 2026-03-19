import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cLesson02 = Lesson(
  language: 'C',
  title: 'Compiling and Running C',
  content: '''
🎯 METAPHOR:
Writing C code is like writing a recipe in French.
Your computer only speaks machine language (binary).
The compiler is the translator — it converts your
French recipe into something the computer understands.

📖 EXPLANATION:
C is a compiled language. You write source code (.c files),
then a compiler converts it to machine code (an executable).
The most common compiler is GCC (GNU Compiler Collection).

Steps:
1. Write code in a .c file
2. Compile it with GCC
3. Run the resulting executable

💻 CODE:
// Step 1: Save this as hello.c
#include <stdio.h>

int main() {
    printf("Hello!\\n");
    return 0;
}

// Step 2: In your terminal, compile:
//   gcc hello.c -o hello

// Step 3: Run it:
//   ./hello

📝 USEFUL COMPILER FLAGS:
gcc hello.c -o hello        → compile to executable "hello"
gcc -Wall hello.c -o hello  → show all warnings
gcc -g hello.c -o hello     → include debug info
gcc -O2 hello.c -o hello    → optimize for speed

THE 4 STAGES OF COMPILATION:
1. Preprocessing  → handles #include and #define
2. Compilation    → converts C to assembly
3. Assembly       → converts assembly to machine code
4. Linking        → combines object files into executable
''',
  quiz: [
    Quiz(question: 'What does a compiler do?', options: [
      QuizOption(text: 'Converts source code to machine code', correct: true),
      QuizOption(text: 'Runs your program', correct: false),
      QuizOption(text: 'Checks for logic errors', correct: false),
      QuizOption(text: 'Manages memory', correct: false),
    ]),
    Quiz(question: 'Which flag shows all compiler warnings in GCC?', options: [
      QuizOption(text: '-Wall', correct: true),
      QuizOption(text: '-warn', correct: false),
      QuizOption(text: '-W', correct: false),
      QuizOption(text: '-all', correct: false),
    ]),
    Quiz(question: 'What file extension is used for C source files?', options: [
      QuizOption(text: '.c', correct: true),
      QuizOption(text: '.cpp', correct: false),
      QuizOption(text: '.cs', correct: false),
      QuizOption(text: '.cx', correct: false),
    ]),
  ],
);

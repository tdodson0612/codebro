import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cLesson01 = Lesson(
  language: 'C',
  title: 'What is C?',
  content: """
🎯 METAPHOR:
C is like the engine of a car. Most people drive cars
without ever seeing the engine. But if you want to build
a race car — or understand why your car is slow — you need
to understand the engine. C lets you see and control the
engine of a computer.

📖 EXPLANATION:
C was created by Dennis Ritchie at Bell Labs in 1972.
It was designed to write operating systems — including Unix.
Almost every modern language (C++, Java, Python, Go) was
influenced by C. It is fast, portable, and close to hardware.

Why learn C:
- Understand how memory and hardware really work
- Write extremely fast, efficient software
- Foundation for understanding ALL other languages
- Used in embedded systems, kernels, and game engines

💻 CODE:
#include <stdio.h>

int main() {
    printf("Hello, World!\\n");
    return 0;
}

📝 HOW IT WORKS:
#include <stdio.h>  → imports the standard I/O library
int main()          → every C program starts here
printf()            → prints text to the screen
\\n                  → newline character (like pressing Enter)
return 0            → tells the OS the program succeeded
""",
  quiz: [
    Quiz(question: 'Who created C?', options: [
      QuizOption(text: 'Dennis Ritchie', correct: true),
      QuizOption(text: 'Linus Torvalds', correct: false),
      QuizOption(text: 'Brian Kernighan', correct: false),
      QuizOption(text: 'Bjarne Stroustrup', correct: false),
    ]),
    Quiz(question: 'What does return 0 mean in main()?', options: [
      QuizOption(text: 'The program ran successfully', correct: true),
      QuizOption(text: 'The program returned zero values', correct: false),
      QuizOption(text: 'The program crashed', correct: false),
      QuizOption(text: 'Nothing — it is optional', correct: false),
    ]),
    Quiz(question: 'What does #include <stdio.h> do?', options: [
      QuizOption(text: 'Imports standard input/output functions', correct: true),
      QuizOption(text: 'Starts the program', correct: false),
      QuizOption(text: 'Declares the main function', correct: false),
      QuizOption(text: 'Allocates memory', correct: false),
    ]),
  ],
);

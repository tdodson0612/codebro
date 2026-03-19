import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cLesson21 = Lesson(
  language: 'C',
  title: 'Variable Scope and Lifetime',
  content: '''
🎯 METAPHOR:
Scope is like the walls of a room. Variables only exist
inside the room they are born in. A local variable is a
sticky note on the kitchen fridge — it only exists in
that kitchen. Once you leave, the note is gone.
Global variables are hallway signs visible from everywhere.

📖 EXPLANATION:
Scope    = where a variable is VISIBLE
Lifetime = when a variable EXISTS in memory

Storage classes:
auto     → default local vars (stack, freed on return)
static   → persists between calls, initialized once
extern   → refers to a variable defined in another file
register → hint to use CPU register (rarely used today)

💻 CODE:
#include <stdio.h>

int globalCount = 0;         // global — visible everywhere
static int fileOnly = 0;     // this file only

void demoScope() {
    int localVar = 10;        // local to this function
    {
        int blockVar = 20;    // local to this block
        printf("blockVar: %d\\n", blockVar);
    }
    // blockVar no longer exists here
    globalCount++;
}

void staticExample() {
    static int callCount = 0; // initialized ONCE, persists!
    callCount++;
    printf("Called %d time(s)\\n", callCount);
}

void shadowing() {
    int x = 1;
    printf("Outer x: %d\\n", x);  // 1
    {
        int x = 2;  // SHADOWS outer x
        printf("Inner x: %d\\n", x); // 2
    }
    printf("Outer x: %d\\n", x);  // still 1
}

int main() {
    demoScope();
    printf("globalCount: %d\\n", globalCount); // 1

    staticExample(); // Called 1 time(s)
    staticExample(); // Called 2 time(s)
    staticExample(); // Called 3 time(s)

    shadowing();
    return 0;
}
''',
  quiz: [
    Quiz(question: 'What is the scope of a variable declared inside a function?', options: [
      QuizOption(text: 'Local — only visible within that function', correct: true),
      QuizOption(text: 'Global — visible everywhere', correct: false),
      QuizOption(text: 'File scope — visible in the whole file', correct: false),
      QuizOption(text: 'Program scope — visible in all files', correct: false),
    ]),
    Quiz(question: 'What is unique about a static local variable?', options: [
      QuizOption(text: 'It retains its value between function calls', correct: true),
      QuizOption(text: 'It cannot be modified', correct: false),
      QuizOption(text: 'It is visible globally', correct: false),
      QuizOption(text: 'It is allocated on the heap', correct: false),
    ]),
    Quiz(question: 'What is variable shadowing?', options: [
      QuizOption(text: 'An inner-scope variable with the same name hides the outer one', correct: true),
      QuizOption(text: 'A variable that is set to NULL', correct: false),
      QuizOption(text: 'A global variable that copies a local one', correct: false),
      QuizOption(text: 'A variable that changes value unexpectedly', correct: false),
    ]),
  ],
);

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cLesson14 = Lesson(
  language: 'C',
  title: 'switch Statement',
  content: """
🎯 METAPHOR:
switch is like a vending machine. You press a button
(the value), and the machine goes directly to that item
(the case). Without break, the machine keeps dispensing
everything below your selection — that is fallthrough.

📖 EXPLANATION:
switch compares one value against multiple cases.
Cleaner than a long if-else chain for one variable.
Only works with integer types and char — NOT strings.

💻 CODE:
#include <stdio.h>

int main() {
    int day = 3;
    switch (day) {
        case 1: printf("Monday\\n");    break;
        case 2: printf("Tuesday\\n");   break;
        case 3: printf("Wednesday\\n"); break; // prints this
        case 4: printf("Thursday\\n");  break;
        case 5: printf("Friday\\n");    break;
        case 6:
        case 7: printf("Weekend!\\n");  break;  // 6 and 7 share
        default: printf("Invalid\\n");
    }
    
    // Intentional fallthrough
    int level = 2;
    printf("Unlocked: ");
    switch (level) {
        case 3: printf("Admin ");   // fallthrough
        case 2: printf("Editor ");  // fallthrough
        case 1: printf("Viewer ");  break;
        default: printf("None");
    }
    printf("\\n"); // Level 2 → Editor Viewer
    
    // switch with char
    char grade = 'B';
    switch (grade) {
        case 'A': printf("Excellent!\\n"); break;
        case 'B': printf("Good!\\n");      break;
        case 'C': printf("Average\\n");    break;
        default:  printf("Below avg\\n");
    }
    
    return 0;
}
""",
  quiz: [
    Quiz(question: 'What happens if you forget break in a switch case?', options: [
      QuizOption(text: 'Execution falls through to the next case', correct: true),
      QuizOption(text: 'The program crashes', correct: false),
      QuizOption(text: 'The compiler gives an error', correct: false),
      QuizOption(text: 'The switch exits immediately', correct: false),
    ]),
    Quiz(question: 'Which types work in a switch statement?', options: [
      QuizOption(text: 'Integer types and char only', correct: true),
      QuizOption(text: 'Any type including float and string', correct: false),
      QuizOption(text: 'Only int', correct: false),
      QuizOption(text: 'Only enum values', correct: false),
    ]),
    Quiz(question: 'What is the purpose of the default case?', options: [
      QuizOption(text: 'Handles any value that does not match any case', correct: true),
      QuizOption(text: 'It is the first case to execute', correct: false),
      QuizOption(text: 'Required for switch to compile', correct: false),
      QuizOption(text: 'It resets the switch variable', correct: false),
    ]),
  ],
);

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cLesson13 = Lesson(
  language: 'C',
  title: 'if, else if, else',
  content: """
🎯 METAPHOR:
if/else is like a bouncer checking IDs at a club.
IF you are over 21, you get in.
ELSE IF you have a VIP pass, you also get in.
ELSE you go home. Only ONE path is taken.

📖 EXPLANATION:
if statements let your program make decisions based on
whether conditions are true or false.

💻 CODE:
#include <stdio.h>

int main() {
    int age = 20;
    
    if (age >= 18) {
        printf("You can vote!\\n");
    }
    
    if (age >= 21) {
        printf("Can drink in the US\\n");
    } else {
        printf("Too young in the US\\n");
    }
    
    // Grade calculator
    int score = 85;
    char grade;
    if      (score >= 90) grade = 'A';
    else if (score >= 80) grade = 'B';
    else if (score >= 70) grade = 'C';
    else if (score >= 60) grade = 'D';
    else                  grade = 'F';
    printf("Grade: %c\\n", grade); // B
    
    // Nested if
    int x = 15;
    if (x > 0) {
        if (x % 2 == 0) printf("Positive even\\n");
        else             printf("Positive odd\\n");
    }
    
    // Ternary operator
    int max = (x > 10) ? x : 10;
    printf("Max: %d\\n", max);
    
    return 0;
}
""",
  quiz: [
    Quiz(question: 'In an if-else if-else chain, how many blocks execute?', options: [
      QuizOption(text: 'Exactly one — the first true condition', correct: true),
      QuizOption(text: 'All blocks that are true', correct: false),
      QuizOption(text: 'Always the else block', correct: false),
      QuizOption(text: 'All blocks always execute', correct: false),
    ]),
    Quiz(question: 'What does (a ? b : c) do?', options: [
      QuizOption(text: 'If a is true returns b, otherwise returns c', correct: true),
      QuizOption(text: 'Adds a, b, and c', correct: false),
      QuizOption(text: 'Only works with integers', correct: false),
      QuizOption(text: 'It is a type of loop', correct: false),
    ]),
    Quiz(question: 'Why should you always use braces with if statements?', options: [
      QuizOption(text: 'To avoid the dangling else problem and scope issues', correct: true),
      QuizOption(text: 'The compiler requires it', correct: false),
      QuizOption(text: 'It makes the code run faster', correct: false),
      QuizOption(text: 'It is purely cosmetic', correct: false),
    ]),
  ],
);

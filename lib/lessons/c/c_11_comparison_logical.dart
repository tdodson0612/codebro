import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cLesson11 = Lesson(
  language: 'C',
  title: 'Comparison and Logical Operators',
  content: """
🎯 METAPHOR:
Comparison operators ask yes/no questions about values.
"Is 5 greater than 3?" Yes (1). "Is 5 equal to 4?" No (0).
Logical operators combine those answers:
AND (&&) = both must be true
OR  (||) = at least one must be true
NOT (!)  = flips true to false

📖 EXPLANATION:
In C, true = any non-zero value, false = 0.
Comparison and logical operators return 0 or 1.

Comparison: ==  !=  >  <  >=  <=
Logical:    &&  ||  !

💻 CODE:
#include <stdio.h>

int main() {
    int a = 5, b = 10;
    
    printf("a == b: %d\\n", a == b); // 0
    printf("a != b: %d\\n", a != b); // 1
    printf("a <  b: %d\\n", a < b);  // 1
    printf("a >  b: %d\\n", a > b);  // 0
    
    // Logical operators
    int x = 7;
    printf("x>5 && x<10: %d\\n", x > 5 && x < 10); // 1
    printf("x<5 || x>6:  %d\\n", x < 5 || x > 6);  // 1
    printf("!(x==7):     %d\\n", !(x == 7));         // 0
    
    // Short-circuit evaluation
    int n = 0;
    if (n != 0 && 10/n > 1) {
        // && stops at first false — 10/0 never runs!
        printf("This is safe\\n");
    }
    
    // Common mistake: = instead of ==
    int val = 5;
    if (val = 10) {  // ASSIGNS 10 to val, not comparison!
        printf("Always runs! val=%d\\n", val); // val is 10
    }
    
    return 0;
}

📝 PRECEDENCE (high to low):
!    *  /  %    +  -
<  <=  >  >=    == !=
&&               ||
=  +=  -= ...  (lowest)
When in doubt, use parentheses!
""",
  quiz: [
    Quiz(question: 'What does && mean?', options: [
      QuizOption(text: 'Logical AND — true only if both sides are true', correct: true),
      QuizOption(text: 'Bitwise AND', correct: false),
      QuizOption(text: 'Address-of operator used twice', correct: false),
      QuizOption(text: 'Logical OR', correct: false),
    ]),
    Quiz(question: 'What is short-circuit evaluation?', options: [
      QuizOption(text: '&& stops at first false; || stops at first true', correct: true),
      QuizOption(text: 'The program takes a shortcut through code', correct: false),
      QuizOption(text: 'Comparisons skip equal values', correct: false),
      QuizOption(text: 'The compiler optimizes away unused comparisons', correct: false),
    ]),
    Quiz(question: 'What does if (x = 5) do vs if (x == 5)?', options: [
      QuizOption(text: 'x=5 assigns 5 and always runs; x==5 checks equality', correct: true),
      QuizOption(text: 'They are the same', correct: false),
      QuizOption(text: 'x=5 is a syntax error', correct: false),
      QuizOption(text: 'x==5 assigns 5 to x', correct: false),
    ]),
  ],
);

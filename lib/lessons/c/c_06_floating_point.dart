import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cLesson06 = Lesson(
  language: 'C',
  title: 'Floating Point Types',
  content: '''
🎯 METAPHOR:
Floating point numbers are like measuring with a ruler
that has millimeter marks. You can measure 3.5 cm, but you
cannot measure exactly pi (3.14159...) — there is always
tiny rounding. That rounding is floating point imprecision,
and it trips up even experienced programmers.

📖 EXPLANATION:
C has three floating point types:

Type          Size     Precision
float         4 bytes  ~6-7 decimal digits
double        8 bytes  ~15-16 decimal digits
long double   10-16 b  ~18-19 decimal digits

Use double for most calculations. float saves memory
but is less precise. long double is for science.

💻 CODE:
#include <stdio.h>

int main() {
    float  f  = 3.14f;              // f suffix for float
    double d  = 3.14159265358979;
    
    printf("float:  %.7f\\n",  f);
    printf("double: %.15f\\n", d);
    
    // Floating point imprecision!
    double a = 0.1 + 0.2;
    printf("0.1 + 0.2 = %.20f\\n", a);
    // Prints 0.30000000000000004441... NOT 0.3!
    
    // NEVER compare floats with ==
    if (a == 0.3) {
        printf("Equal\\n");        // will NOT print!
    }
    
    // Instead compare within a tolerance
    double epsilon = 1e-9;
    if (a - 0.3 < epsilon && 0.3 - a < epsilon) {
        printf("Close enough!\\n"); // WILL print
    }
    
    return 0;
}

📝 KEY POINTS:
- Never use == to compare floating point numbers
- Use double by default (more precise than float)
- f suffix = float literal (3.14f)
- L suffix = long double literal (3.14L)
- Scientific notation: 1.5e10 = 1.5 × 10^10
''',
  quiz: [
    Quiz(question: 'Which floating point type has the most precision?', options: [
      QuizOption(text: 'long double', correct: true),
      QuizOption(text: 'double', correct: false),
      QuizOption(text: 'float', correct: false),
      QuizOption(text: 'They are all the same', correct: false),
    ]),
    Quiz(question: 'Why should you NOT use == to compare floats?', options: [
      QuizOption(text: 'Floating point numbers have tiny rounding errors', correct: true),
      QuizOption(text: 'The == operator does not work on floats', correct: false),
      QuizOption(text: 'It causes a compile error', correct: false),
      QuizOption(text: 'It is slower', correct: false),
    ]),
    Quiz(question: 'What suffix makes a float literal in C?', options: [
      QuizOption(text: 'f (e.g. 3.14f)', correct: true),
      QuizOption(text: 'd (e.g. 3.14d)', correct: false),
      QuizOption(text: 'fl (e.g. 3.14fl)', correct: false),
      QuizOption(text: 'No suffix needed', correct: false),
    ]),
  ],
);

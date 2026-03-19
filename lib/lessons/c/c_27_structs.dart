import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cLesson27 = Lesson(
  language: 'C',
  title: 'Structs',
  content: """
🎯 METAPHOR:
A struct is like a person profile card. Instead of
separate variables for name, age, and height floating
around your program, you bundle them into one "Person"
card with labeled slots (fields). You can carry the whole
card, copy it, or pass it to someone.

📖 EXPLANATION:
A struct groups related variables of DIFFERENT types
into a single named type. Unlike arrays (same type),
structs can mix int, float, char arrays, nested structs.

Dot operator (.) accesses struct members.
Arrow operator (->) accesses members through a pointer.

💻 CODE:
#include <stdio.h>
#include <string.h>

struct Point { int x, y; };

struct Person {
    char   name[50];
    int    age;
    double height;
};

typedef struct {
    double real, imag;
} Complex;

void birthday(struct Person *p) {
    p->age++;   // -> operator for pointer to struct
}

int main() {
    struct Point p1 = {3, 7};
    printf("Point: (%d,%d)\n", p1.x, p1.y);

    struct Person alice;
    strcpy(alice.name, "Alice");
    alice.age    = 25;
    alice.height = 5.6;
    printf("%s, age %d\n", alice.name, alice.age);

    // Pointer to struct
    struct Person *ptr = &alice;
    printf("Via ->: %s\n", ptr->name);
    // ptr->age is same as (*ptr).age

    birthday(&alice);
    printf("Next year: %d\n", alice.age); // 26

    // Typedef
    Complex c = {3.0, 4.0};
    printf("%.1f + %.1fi\n", c.real, c.imag);

    // Array of structs
    struct Person team[2] = {
        {"Bob", 30, 6.0},
        {"Carol", 28, 5.4}
    };
    for (int i = 0; i < 2; i++)
        printf("%s is %d\n", team[i].name, team[i].age);

    return 0;
}
""",
  quiz: [
    Quiz(question: 'How do you access a struct member through a pointer?', options: [
      QuizOption(text: 'Using the -> operator (ptr->member)', correct: true),
      QuizOption(text: 'Using the dot operator (ptr.member)', correct: false),
      QuizOption(text: 'Using the * operator', correct: false),
      QuizOption(text: 'Using brackets (ptr[member])', correct: false),
    ]),
    Quiz(question: 'What does typedef do when used with structs?', options: [
      QuizOption(text: 'Creates an alias so you can skip the struct keyword', correct: true),
      QuizOption(text: 'Defines a new type from scratch', correct: false),
      QuizOption(text: 'Makes the struct immutable', correct: false),
      QuizOption(text: 'Converts the struct to a class', correct: false),
    ]),
    Quiz(question: 'When a struct is passed by value to a function, what happens?', options: [
      QuizOption(text: 'A complete copy is made — changes do not affect original', correct: true),
      QuizOption(text: 'The original struct is passed directly', correct: false),
      QuizOption(text: 'Only the first field is copied', correct: false),
      QuizOption(text: 'It causes a compile error', correct: false),
    ]),
  ],
);

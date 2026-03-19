import '../models/lesson.dart';
import '../models/quiz.dart';

// ─── C ───────────────────────────────────────────────────────────────────────

final cLessons = [
  Lesson(
    language: 'C',
    title: 'Hello World & Setup',
    content: '''
#include <stdio.h>

int main() {
    printf("Hello, World!\\n");
    return 0;
}

/*
Explanation:
- #include <stdio.h> : includes standard input/output functions
- int main() : main function where execution starts
- printf() : prints text to the console
- return 0 : indicates program finished successfully
*/
''',
    quiz: [
      Quiz(question: 'What is the purpose of #include <stdio.h>?', options: [
        QuizOption(text: 'Start the program', correct: false),
        QuizOption(text: 'Include standard input/output functions', correct: true),
        QuizOption(text: 'Declare main function', correct: false),
        QuizOption(text: 'Print Hello World', correct: false),
      ]),
      Quiz(question: 'What does return 0 signify?', options: [
        QuizOption(text: 'Program ran successfully', correct: true),
        QuizOption(text: 'Program failed', correct: false),
        QuizOption(text: 'Prints zero', correct: false),
        QuizOption(text: 'Exits main function with error', correct: false),
      ]),
      Quiz(question: 'Which function prints text to the console?', options: [
        QuizOption(text: 'print()', correct: false),
        QuizOption(text: 'echo()', correct: false),
        QuizOption(text: 'printf()', correct: true),
        QuizOption(text: 'write()', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'C',
    title: 'Variables & Data Types',
    content: '''
#include <stdio.h>

int main() {
    int age = 25;
    float price = 12.5;
    char letter = 'C';

    printf("Age: %d\\n", age);
    printf("Price: %.2f\\n", price);
    printf("Letter: %c\\n", letter);

    return 0;
}

/*
Explanation:
- int : stores integers
- float : stores floating-point numbers
- char : stores a single character
- Variables must be declared before use
- const int max = 100; prevents modification
*/
''',
    quiz: [
      Quiz(question: 'Which data type is used to store decimal numbers?', options: [
        QuizOption(text: 'int', correct: false),
        QuizOption(text: 'float', correct: true),
        QuizOption(text: 'char', correct: false),
        QuizOption(text: 'void', correct: false),
      ]),
      Quiz(question: "What is the correct way to declare a char variable?", options: [
        QuizOption(text: "char letter = 'A';", correct: true),
        QuizOption(text: "char letter = A;", correct: false),
        QuizOption(text: 'char letter = "A";', correct: false),
        QuizOption(text: 'char letter();', correct: false),
      ]),
      Quiz(question: 'Variables must be ______ before use in C.', options: [
        QuizOption(text: 'Declared', correct: true),
        QuizOption(text: 'Initialized', correct: false),
        QuizOption(text: 'Printed', correct: false),
        QuizOption(text: 'Commented', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'C',
    title: 'Operators',
    content: '''
#include <stdio.h>

int main() {
    int a = 10, b = 3;
    printf("a + b = %d\\n", a + b);
    printf("a - b = %d\\n", a - b);
    printf("a * b = %d\\n", a * b);
    printf("a / b = %d\\n", a / b);
    printf("a %% b = %d\\n", a % b);

    return 0;
}

/*
Explanation:
- +, -, *, /, % : basic arithmetic operators
- ==, !=, >, <, >=, <= : comparison operators
- &&, ||, ! : logical operators
- ++, -- : increment and decrement
- Operators follow precedence rules
- Bitwise: & | ^ ~ << >>
*/
''',
    quiz: [
      Quiz(question: 'What is the remainder of 10 % 3?', options: [
        QuizOption(text: '1', correct: true),
        QuizOption(text: '3', correct: false),
        QuizOption(text: '0', correct: false),
        QuizOption(text: '10', correct: false),
      ]),
      Quiz(question: 'Which operator is used for logical AND?', options: [
        QuizOption(text: '&', correct: false),
        QuizOption(text: '&&', correct: true),
        QuizOption(text: '|', correct: false),
        QuizOption(text: '||', correct: false),
      ]),
      Quiz(question: 'What does ++a do?', options: [
        QuizOption(text: 'Increments a by 1 before use', correct: true),
        QuizOption(text: 'Decrements a by 1', correct: false),
        QuizOption(text: 'Adds a to itself', correct: false),
        QuizOption(text: 'Does nothing', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'C',
    title: 'Control Flow',
    content: '''
#include <stdio.h>

int main() {
    int number = 5;

    if (number > 0) {
        printf("Positive\\n");
    } else {
        printf("Non-positive\\n");
    }

    for (int i = 0; i < 3; i++) {
        printf("i = %d\\n", i);
    }

    int j = 0;
    while (j < 3) {
        printf("j = %d\\n", j);
        j++;
    }

    switch(number) {
        case 1: printf("One\\n"); break;
        case 5: printf("Five\\n"); break;
        default: printf("Other\\n");
    }

    return 0;
}

/*
Explanation:
- if, else: conditional statements
- for, while: loops
- do-while: executes at least once
- switch: multi-way branching
- break: exit loops or switch
- continue: skip current loop iteration
*/
''',
    quiz: [
      Quiz(question: 'Which loop will execute at least once even if condition is false?', options: [
        QuizOption(text: 'for', correct: false),
        QuizOption(text: 'while', correct: false),
        QuizOption(text: 'do-while', correct: true),
        QuizOption(text: 'if', correct: false),
      ]),
      Quiz(question: 'What is the output if number = 5 in the switch example?', options: [
        QuizOption(text: 'One', correct: false),
        QuizOption(text: 'Five', correct: true),
        QuizOption(text: 'Other', correct: false),
        QuizOption(text: 'Error', correct: false),
      ]),
      Quiz(question: 'What does continue do in a loop?', options: [
        QuizOption(text: 'Exits the loop', correct: false),
        QuizOption(text: 'Skips current iteration', correct: true),
        QuizOption(text: 'Pauses loop', correct: false),
        QuizOption(text: 'Repeats entire loop', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'C',
    title: 'Functions',
    content: '''
#include <stdio.h>

// Function declaration
int add(int a, int b);

int main() {
    int sum = add(5, 7);
    printf("Sum: %d\\n", sum);
    return 0;
}

// Function definition
int add(int a, int b) {
    return a + b;
}

/*
Explanation:
- Functions allow code reuse
- Declaration: specifies function name, parameters, and return type
- Definition: contains the function code
- Scope: variables inside functions are local
- Recursion: functions can call themselves
*/
''',
    quiz: [
      Quiz(question: 'What is the return type of add() function?', options: [
        QuizOption(text: 'int', correct: true),
        QuizOption(text: 'void', correct: false),
        QuizOption(text: 'float', correct: false),
        QuizOption(text: 'char', correct: false),
      ]),
      Quiz(question: 'Where is a variable declared inside a function accessible?', options: [
        QuizOption(text: 'Globally', correct: false),
        QuizOption(text: 'Locally in that function', correct: true),
        QuizOption(text: 'In all functions', correct: false),
        QuizOption(text: 'Nowhere', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'C',
    title: 'Arrays & Strings',
    content: '''
#include <stdio.h>
#include <string.h>

int main() {
    int numbers[5] = {1, 2, 3, 4, 5};
    printf("First number: %d\\n", numbers[0]);

    char name[] = "Alice";
    printf("Name: %s\\n", name);
    printf("Length: %lu\\n", strlen(name));

    return 0;
}

/*
Explanation:
- Arrays store multiple values of the same type
- Indexing starts at 0
- Strings are arrays of characters ending with '\\0'
- Use strlen() to get string length
- strcpy, strcmp for string operations
*/
''',
    quiz: [
      Quiz(question: 'What is the index of the first element in an array?', options: [
        QuizOption(text: '0', correct: true),
        QuizOption(text: '1', correct: false),
        QuizOption(text: '-1', correct: false),
        QuizOption(text: 'Depends on compiler', correct: false),
      ]),
      Quiz(question: 'Which function gets the length of a string?', options: [
        QuizOption(text: 'strlen()', correct: true),
        QuizOption(text: 'length()', correct: false),
        QuizOption(text: 'size()', correct: false),
        QuizOption(text: 'count()', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'C',
    title: 'Pointers',
    content: '''
#include <stdio.h>

int main() {
    int a = 10;
    int *p = &a;

    printf("Value of a: %d\\n", a);
    printf("Address of a: %p\\n", &a);
    printf("Value via pointer: %d\\n", *p);

    return 0;
}

/*
Explanation:
- Pointer stores the address of a variable
- & gives the address
- * dereferences the pointer to get the value
- Pointer arithmetic: p+1 moves to next memory location of type
- Pointers enable dynamic memory management
*/
''',
    quiz: [
      Quiz(question: 'What does *p do?', options: [
        QuizOption(text: 'Declares a pointer', correct: false),
        QuizOption(text: 'Dereferences pointer to get value', correct: true),
        QuizOption(text: 'Gets the address', correct: false),
        QuizOption(text: 'Deletes pointer', correct: false),
      ]),
      Quiz(question: 'What operator gets the address of a variable?', options: [
        QuizOption(text: '&', correct: true),
        QuizOption(text: '*', correct: false),
        QuizOption(text: '#', correct: false),
        QuizOption(text: '%', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'C',
    title: 'Structs & Enums',
    content: '''
#include <stdio.h>

struct Point {
    int x;
    int y;
};

enum Color { RED, GREEN, BLUE };

int main() {
    struct Point p1 = {10, 20};
    enum Color c = GREEN;

    printf("Point: (%d, %d)\\n", p1.x, p1.y);
    printf("Color enum value: %d\\n", c);

    return 0;
}

/*
Explanation:
- struct groups different data types together
- enum creates a set of named integer constants
- Access struct members with .
- Enums start at 0 by default
*/
''',
    quiz: [
      Quiz(question: 'Which operator accesses struct members?', options: [
        QuizOption(text: '.', correct: true),
        QuizOption(text: '->', correct: false),
        QuizOption(text: '&', correct: false),
        QuizOption(text: '*', correct: false),
      ]),
      Quiz(question: 'What is the first value of an enum by default?', options: [
        QuizOption(text: '0', correct: true),
        QuizOption(text: '1', correct: false),
        QuizOption(text: 'Depends on compiler', correct: false),
        QuizOption(text: '-1', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'C',
    title: 'Memory Management',
    content: '''
#include <stdio.h>
#include <stdlib.h>

int main() {
    int *arr = (int*)malloc(5 * sizeof(int));
    for(int i=0; i<5; i++) {
        arr[i] = i+1;
        printf("%d ", arr[i]);
    }
    printf("\\n");

    free(arr); // release memory
    return 0;
}

/*
Explanation:
- malloc/calloc/realloc allocate memory dynamically
- free() releases memory
- Always check if malloc returns NULL
- Avoid memory leaks by freeing all allocated memory
*/
''',
    quiz: [
      Quiz(question: 'Which function allocates memory dynamically?', options: [
        QuizOption(text: 'malloc()', correct: true),
        QuizOption(text: 'free()', correct: false),
        QuizOption(text: 'printf()', correct: false),
        QuizOption(text: 'sizeof()', correct: false),
      ]),
      Quiz(question: 'Which function releases allocated memory?', options: [
        QuizOption(text: 'malloc()', correct: false),
        QuizOption(text: 'free()', correct: true),
        QuizOption(text: 'realloc()', correct: false),
        QuizOption(text: 'calloc()', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'C',
    title: 'File I/O',
    content: '''
#include <stdio.h>

int main() {
    FILE *f = fopen("example.txt", "w");
    if(f == NULL) {
        printf("Error opening file\\n");
        return 1;
    }

    fprintf(f, "Hello File!\\n");
    fclose(f);

    FILE *fr = fopen("example.txt", "r");
    char line[100];
    fgets(line, sizeof(line), fr);
    printf("%s", line);
    fclose(fr);

    return 0;
}

/*
Explanation:
- fopen(): open file in read/write mode
- fprintf(): write formatted text to file
- fgets(): read text from file
- fclose(): close file
- "w"=write, "r"=read, "a"=append
*/
''',
    quiz: [
      Quiz(question: 'Which function writes text to a file?', options: [
        QuizOption(text: 'fprintf()', correct: true),
        QuizOption(text: 'fgets()', correct: false),
        QuizOption(text: 'fopen()', correct: false),
        QuizOption(text: 'fclose()', correct: false),
      ]),
      Quiz(question: 'What should you always do after finishing with a file?', options: [
        QuizOption(text: 'Close it with fclose()', correct: true),
        QuizOption(text: 'Delete it', correct: false),
        QuizOption(text: 'Rename it', correct: false),
        QuizOption(text: 'Nothing', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'C',
    title: 'Debugging & Putting It Together',
    content: '''
#include <stdio.h>

int main() {
    int numbers[5] = {1, 2, 3, 4, 5};
    int sum = 0;

    for(int i = 0; i < 5; i++) {
        sum += numbers[i];
    }

    printf("Total sum: %d\\n", sum);

    return 0;
}

/*
Debugging Tips:
- Use printf() to debug values
- Check for array bounds
- Use gdb for advanced debugging
- Combine multiple modules in projects:
    - Variables, loops, functions, arrays, pointers
    - Memory management and file I/O
- Header files (.h) and source files (.c) for project structure
*/
''',
    quiz: [
      Quiz(question: 'Which tool can be used for advanced debugging in C?', options: [
        QuizOption(text: 'gdb', correct: true),
        QuizOption(text: 'gcc', correct: false),
        QuizOption(text: 'make', correct: false),
        QuizOption(text: 'vim', correct: false),
      ]),
      Quiz(question: 'What is a common runtime error when using arrays?', options: [
        QuizOption(text: 'Accessing out-of-bounds index', correct: true),
        QuizOption(text: 'Using printf()', correct: false),
        QuizOption(text: 'Declaring int variables', correct: false),
        QuizOption(text: 'Including stdio.h', correct: false),
      ]),
    ],
  ),
];

// ─── C++ ─────────────────────────────────────────────────────────────────────

final cppLessons = [
  Lesson(
    language: 'C++',
    title: 'Introduction & Setup',
    content: '''
#include <iostream>
using namespace std;

int main() {
    cout << "Hello, World!" << endl;
    return 0;
}

/*
Explanation:
- #include <iostream> imports input/output library
- using namespace std; avoids writing std:: before cout/cin
- cout prints to console
- endl adds a newline and flushes output
- main() is entry point of program
- return 0 indicates successful execution
*/
''',
    quiz: [
      Quiz(question: 'Which library is required for std::cout?', options: [
        QuizOption(text: '#include <iostream>', correct: true),
        QuizOption(text: '#include <stdio.h>', correct: false),
        QuizOption(text: '#include <string>', correct: false),
        QuizOption(text: '#include <math.h>', correct: false),
      ]),
      Quiz(question: 'What does std::endl do?', options: [
        QuizOption(text: 'Ends the line and flushes output', correct: true),
        QuizOption(text: 'Starts a new program', correct: false),
        QuizOption(text: 'Declares a variable', correct: false),
        QuizOption(text: 'Exits the program', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'C++',
    title: 'Variables & Data Types',
    content: '''
#include <iostream>
using namespace std;

int main() {
    int age = 25;
    float price = 12.5;
    double pi = 3.14159;
    char grade = 'A';
    bool isAdult = true;
    string name = "Alice";

    cout << "Age: " << age << endl;
    cout << "Price: " << price << endl;
    cout << "Pi: " << pi << endl;
    cout << "Grade: " << grade << endl;
    cout << "Adult: " << isAdult << endl;
    cout << "Name: " << name << endl;

    return 0;
}

/*
Explanation:
- int: integer numbers
- float: single-precision decimal
- double: double-precision decimal
- char: single character
- bool: true/false
- string: requires <string> or using namespace std
- Variables must be declared before use
*/
''',
    quiz: [
      Quiz(question: 'Which type is used for true/false values?', options: [
        QuizOption(text: 'bool', correct: true),
        QuizOption(text: 'int', correct: false),
        QuizOption(text: 'float', correct: false),
        QuizOption(text: 'char', correct: false),
      ]),
      Quiz(question: 'Which type stores decimal numbers with higher precision?', options: [
        QuizOption(text: 'double', correct: true),
        QuizOption(text: 'float', correct: false),
        QuizOption(text: 'int', correct: false),
        QuizOption(text: 'bool', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'C++',
    title: 'Operators',
    content: '''
#include <iostream>
using namespace std;

int main() {
    int a = 10, b = 3;
    cout << "a + b = " << a + b << endl;
    cout << "a - b = " << a - b << endl;
    cout << "a * b = " << a * b << endl;
    cout << "a / b = " << a / b << endl;
    cout << "a % b = " << a % b << endl;
    return 0;
}

/*
Explanation:
- Arithmetic: + - * / %
- Assignment: = += -= *= /=
- Increment/Decrement: ++ --
- Comparison: == != > < >= <=
- Logical: && || !
- Bitwise: & | ^ ~ << >>
- Operators follow precedence rules
*/
''',
    quiz: [
      Quiz(question: 'What is the result of 10 % 3?', options: [
        QuizOption(text: '1', correct: true),
        QuizOption(text: '0', correct: false),
        QuizOption(text: '3', correct: false),
        QuizOption(text: '10', correct: false),
      ]),
      Quiz(question: 'Which operator increments a variable by 1?', options: [
        QuizOption(text: '++', correct: true),
        QuizOption(text: '--', correct: false),
        QuizOption(text: '+', correct: false),
        QuizOption(text: '=', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'C++',
    title: 'Control Flow',
    content: '''
#include <iostream>
using namespace std;

int main() {
    int number = 5;

    if (number > 0) {
        cout << "Positive" << endl;
    } else {
        cout << "Non-positive" << endl;
    }

    for(int i = 0; i < 3; i++) {
        cout << "i = " << i << endl;
    }

    int j = 0;
    while(j < 3) {
        cout << "j = " << j << endl;
        j++;
    }

    switch(number) {
        case 1: cout << "One" << endl; break;
        case 5: cout << "Five" << endl; break;
        default: cout << "Other" << endl;
    }

    return 0;
}

/*
Explanation:
- if, else if, else: conditional branching
- for, while: loops
- do-while: executes at least once
- switch: multi-way branching
- break: exit loop or switch
- continue: skip current loop iteration
*/
''',
    quiz: [
      Quiz(question: 'Which loop executes at least once even if condition is false?', options: [
        QuizOption(text: 'do-while', correct: true),
        QuizOption(text: 'for', correct: false),
        QuizOption(text: 'while', correct: false),
        QuizOption(text: 'if', correct: false),
      ]),
      Quiz(question: 'What does continue do?', options: [
        QuizOption(text: 'Skips current iteration', correct: true),
        QuizOption(text: 'Exits the loop', correct: false),
        QuizOption(text: 'Stops the program', correct: false),
        QuizOption(text: 'Repeats the loop from start', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'C++',
    title: 'Functions',
    content: '''
#include <iostream>
using namespace std;

int add(int a, int b) {
    return a + b;
}

void greet(string name) {
    cout << "Hello, " << name << endl;
}

int main() {
    int sum = add(5, 7);
    cout << "Sum: " << sum << endl;
    greet("Alice");
    return 0;
}

/*
Explanation:
- Functions allow code reuse
- Return type specifies the value returned
- void: no return value
- Parameters pass data into functions
- Function overloading: same name, different parameters
*/
''',
    quiz: [
      Quiz(question: 'Which keyword indicates a function returns no value?', options: [
        QuizOption(text: 'void', correct: true),
        QuizOption(text: 'int', correct: false),
        QuizOption(text: 'null', correct: false),
        QuizOption(text: 'none', correct: false),
      ]),
      Quiz(question: 'What is function overloading?', options: [
        QuizOption(text: 'Same name, different parameters', correct: true),
        QuizOption(text: 'Same name, same parameters', correct: false),
        QuizOption(text: 'Different name, same parameters', correct: false),
        QuizOption(text: 'Calling a function twice', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'C++',
    title: 'Arrays & Strings',
    content: '''
#include <iostream>
#include <string>
using namespace std;

int main() {
    int numbers[5] = {1, 2, 3, 4, 5};
    cout << "First number: " << numbers[0] << endl;

    string name = "Alice";
    cout << "Name: " << name << endl;
    cout << "Length: " << name.length() << endl;
    cout << "Substr: " << name.substr(1, 3) << endl;

    return 0;
}

/*
Explanation:
- Arrays: fixed-size, same type elements
- Strings: class in C++, supports methods
- .length() / .size(): get string length
- .substr(): extract substring
- .find(): search for substring
*/
''',
    quiz: [
      Quiz(question: 'Which method returns the length of a string?', options: [
        QuizOption(text: 'length()', correct: true),
        QuizOption(text: 'size()', correct: false),
        QuizOption(text: 'count()', correct: false),
        QuizOption(text: 'len()', correct: false),
      ]),
      Quiz(question: 'How do you access the first element of an array?', options: [
        QuizOption(text: '[0]', correct: true),
        QuizOption(text: '[1]', correct: false),
        QuizOption(text: '[first]', correct: false),
        QuizOption(text: '[start]', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'C++',
    title: 'Classes & Objects',
    content: '''
#include <iostream>
using namespace std;

class Rectangle {
public:
    int width;
    int height;

    Rectangle(int w, int h) {
        width = w;
        height = h;
    }

    int area() {
        return width * height;
    }
};

int main() {
    Rectangle rect(5, 10);
    cout << "Area: " << rect.area() << endl;
    return 0;
}

/*
Explanation:
- class: blueprint for objects
- Constructor initializes object
- public keyword allows access from outside
- private: only accessible inside class
- Methods define object behavior
*/
''',
    quiz: [
      Quiz(question: 'What is a constructor in C++?', options: [
        QuizOption(text: 'Special function to initialize objects', correct: true),
        QuizOption(text: 'Function to delete objects', correct: false),
        QuizOption(text: 'Global function', correct: false),
        QuizOption(text: 'Destructor', correct: false),
      ]),
      Quiz(question: 'Which keyword allows access to members outside the class?', options: [
        QuizOption(text: 'public', correct: true),
        QuizOption(text: 'private', correct: false),
        QuizOption(text: 'protected', correct: false),
        QuizOption(text: 'extern', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'C++',
    title: 'Memory Management',
    content: '''
#include <iostream>
using namespace std;

int main() {
    int* ptr = new int;
    *ptr = 42;
    cout << "Value: " << *ptr << endl;
    delete ptr;

    int* arr = new int[5];
    for(int i = 0; i < 5; i++) arr[i] = i;
    delete[] arr;

    return 0;
}

/*
Explanation:
- new allocates memory dynamically
- delete frees memory for single variable
- delete[] frees memory for arrays
- Avoid memory leaks by freeing all dynamic memory
- Smart pointers (unique_ptr, shared_ptr) in modern C++
*/
''',
    quiz: [
      Quiz(question: 'Which keyword allocates memory dynamically?', options: [
        QuizOption(text: 'new', correct: true),
        QuizOption(text: 'malloc', correct: false),
        QuizOption(text: 'delete', correct: false),
        QuizOption(text: 'free', correct: false),
      ]),
      Quiz(question: 'Which keyword frees an array allocated with new?', options: [
        QuizOption(text: 'delete[]', correct: true),
        QuizOption(text: 'delete', correct: false),
        QuizOption(text: 'free', correct: false),
        QuizOption(text: 'remove', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'C++',
    title: 'File I/O',
    content: '''
#include <iostream>
#include <fstream>
using namespace std;

int main() {
    ofstream outFile("example.txt");
    if(outFile.is_open()) {
        outFile << "Hello File!" << endl;
        outFile.close();
    }

    ifstream inFile("example.txt");
    string line;
    if(inFile.is_open()) {
        while(getline(inFile, line)) {
            cout << line << endl;
        }
        inFile.close();
    }
    return 0;
}

/*
Explanation:
- ofstream: output file stream (write)
- ifstream: input file stream (read)
- getline(): read line from file
- close(): close file after use
- Always check is_open() before reading/writing
*/
''',
    quiz: [
      Quiz(question: 'Which class writes text to a file in C++?', options: [
        QuizOption(text: 'ofstream', correct: true),
        QuizOption(text: 'ifstream', correct: false),
        QuizOption(text: 'fstream', correct: false),
        QuizOption(text: 'filewriter', correct: false),
      ]),
      Quiz(question: 'Which function reads a line from a file?', options: [
        QuizOption(text: 'getline()', correct: true),
        QuizOption(text: 'readline()', correct: false),
        QuizOption(text: 'read()', correct: false),
        QuizOption(text: 'scan()', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'C++',
    title: 'Debugging & Putting It Together',
    content: '''
#include <iostream>
using namespace std;

int main() {
    int numbers[] = {1, 2, 3, 4, 5};
    int total = 0;
    for(int n : numbers) {
        total += n;
    }
    cout << "Total sum: " << total << endl;
    return 0;
}

/*
Debugging Tips:
- Use cout statements to trace variable values
- Check for segmentation faults (invalid pointer access)
- Use debugger in IDE (Visual Studio, Code::Blocks, CLion)
- Break code into functions and classes for clarity
- Range-based for loop: for(int n : array) iterates over all elements
*/
''',
    quiz: [
      Quiz(question: 'What happens if you dereference an invalid pointer?', options: [
        QuizOption(text: 'Segmentation fault', correct: true),
        QuizOption(text: 'IndexError', correct: false),
        QuizOption(text: 'NullPointerException', correct: false),
        QuizOption(text: 'Syntax error', correct: false),
      ]),
      Quiz(question: 'Which is a range-based for loop syntax?', options: [
        QuizOption(text: 'for(int n : numbers)', correct: true),
        QuizOption(text: 'for(int i=0;i<n;i++)', correct: false),
        QuizOption(text: 'foreach(int n in numbers)', correct: false),
        QuizOption(text: 'for n in numbers', correct: false),
      ]),
    ],
  ),
];

// ─── C# ──────────────────────────────────────────────────────────────────────

final csharpLessons = [
  Lesson(
    language: 'C#',
    title: 'Introduction & Setup',
    content: '''
using System;

class Program {
    static void Main(string[] args) {
        Console.WriteLine("Hello, World!");
    }
}

/*
Explanation:
- using System; imports essential libraries
- Console.WriteLine prints to the console
- Main is the entry point
- Static means it belongs to the class, not an object
- C# is case-sensitive
*/
''',
    quiz: [
      Quiz(question: 'Which function prints text to the console in C#?', options: [
        QuizOption(text: 'Console.WriteLine()', correct: true),
        QuizOption(text: 'print()', correct: false),
        QuizOption(text: 'printf()', correct: false),
        QuizOption(text: 'cout', correct: false),
      ]),
      Quiz(question: 'What is the entry point of a C# program?', options: [
        QuizOption(text: 'Main()', correct: true),
        QuizOption(text: 'Start()', correct: false),
        QuizOption(text: 'Init()', correct: false),
        QuizOption(text: 'Run()', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'C#',
    title: 'Variables & Data Types',
    content: '''
using System;

class Program {
    static void Main(string[] args) {
        int age = 25;
        double price = 12.5;
        char grade = 'A';
        bool isAdult = true;
        string name = "Alice";

        Console.WriteLine(\$"Age: {age}");
        Console.WriteLine(\$"Price: {price}");
        Console.WriteLine(\$"Grade: {grade}");
        Console.WriteLine(\$"Adult: {isAdult}");
        Console.WriteLine(\$"Name: {name}");
    }
}

/*
Explanation:
- int: integers
- double: floating point numbers
- char: single character
- bool: true/false
- string: sequence of characters
- \$ prefix enables string interpolation
*/
''',
    quiz: [
      Quiz(question: 'Which type is used for decimal numbers?', options: [
        QuizOption(text: 'double', correct: true),
        QuizOption(text: 'int', correct: false),
        QuizOption(text: 'bool', correct: false),
        QuizOption(text: 'char', correct: false),
      ]),
      Quiz(question: 'Which type stores true/false values?', options: [
        QuizOption(text: 'bool', correct: true),
        QuizOption(text: 'int', correct: false),
        QuizOption(text: 'double', correct: false),
        QuizOption(text: 'char', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'C#',
    title: 'Operators',
    content: '''
using System;

class Program {
    static void Main(string[] args) {
        int a = 10, b = 3;
        Console.WriteLine(\$"a + b = {a + b}");
        Console.WriteLine(\$"a - b = {a - b}");
        Console.WriteLine(\$"a * b = {a * b}");
        Console.WriteLine(\$"a / b = {a / b}");
        Console.WriteLine(\$"a % b = {a % b}");
    }
}

/*
Explanation:
- Arithmetic: + - * / %
- Comparison: == != > < >= <=
- Logical: && || !
- Assignment: = += -= *= /=
- Increment/Decrement: ++ --
*/
''',
    quiz: [
      Quiz(question: 'What is the remainder of 10 % 3?', options: [
        QuizOption(text: '1', correct: true),
        QuizOption(text: '0', correct: false),
        QuizOption(text: '3', correct: false),
        QuizOption(text: '10', correct: false),
      ]),
      Quiz(question: 'Which operator is logical AND?', options: [
        QuizOption(text: '&&', correct: true),
        QuizOption(text: '||', correct: false),
        QuizOption(text: '&', correct: false),
        QuizOption(text: '!', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'C#',
    title: 'Control Flow',
    content: '''
using System;

class Program {
    static void Main(string[] args) {
        int number = 5;

        if (number > 0) {
            Console.WriteLine("Positive");
        } else {
            Console.WriteLine("Non-positive");
        }

        for (int i = 0; i < 3; i++) {
            Console.WriteLine(\$"i = {i}");
        }

        int j = 0;
        while (j < 3) {
            Console.WriteLine(\$"j = {j}");
            j++;
        }

        switch (number) {
            case 1: Console.WriteLine("One"); break;
            case 5: Console.WriteLine("Five"); break;
            default: Console.WriteLine("Other"); break;
        }
    }
}

/*
Explanation:
- if, else if, else: conditional statements
- for, while, do-while: loops
- switch: multi-way branching
- break: exit loops or switch
- continue: skip current iteration
*/
''',
    quiz: [
      Quiz(question: 'Which loop executes at least once even if condition is false?', options: [
        QuizOption(text: 'do-while', correct: true),
        QuizOption(text: 'for', correct: false),
        QuizOption(text: 'while', correct: false),
        QuizOption(text: 'if', correct: false),
      ]),
      Quiz(question: 'What does break do?', options: [
        QuizOption(text: 'Exits loop or switch', correct: true),
        QuizOption(text: 'Skips current iteration', correct: false),
        QuizOption(text: 'Stops program', correct: false),
        QuizOption(text: 'Repeats loop', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'C#',
    title: 'Functions / Methods',
    content: '''
using System;

class Program {
    static int Add(int a, int b) {
        return a + b;
    }

    static void Greet(string name) {
        Console.WriteLine("Hello, " + name);
    }

    static void Main(string[] args) {
        int sum = Add(5, 7);
        Console.WriteLine(\$"Sum: {sum}");
        Greet("Alice");
    }
}

/*
Explanation:
- Functions/methods allow code reuse
- Return type specifies value returned
- void: no return value
- Parameters pass data into method
- static: belongs to class, not instance
*/
''',
    quiz: [
      Quiz(question: 'Which return type indicates no value is returned?', options: [
        QuizOption(text: 'void', correct: true),
        QuizOption(text: 'int', correct: false),
        QuizOption(text: 'null', correct: false),
        QuizOption(text: 'none', correct: false),
      ]),
      Quiz(question: 'How do you pass data into a method?', options: [
        QuizOption(text: 'Parameters', correct: true),
        QuizOption(text: 'Return type', correct: false),
        QuizOption(text: 'Global variable', correct: false),
        QuizOption(text: 'Const only', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'C#',
    title: 'Arrays & Strings',
    content: '''
using System;

class Program {
    static void Main(string[] args) {
        int[] numbers = {1, 2, 3, 4, 5};
        Console.WriteLine(numbers[0]);
        numbers[2] = 10;
        Console.WriteLine(numbers[2]);

        string name = "Alice";
        Console.WriteLine(name.Length);
        Console.WriteLine(name.Substring(1, 3));
        Console.WriteLine(name + " Smith");
    }
}

/*
Explanation:
- Arrays: ordered collection of same type elements
- Strings: immutable sequences of characters
- .Length: returns length
- .Substring(): extracts portion of string
- .ToUpper(), .ToLower(), .Replace(), .Contains()
*/
''',
    quiz: [
      Quiz(question: 'Which property returns string length?', options: [
        QuizOption(text: 'Length', correct: true),
        QuizOption(text: 'Count', correct: false),
        QuizOption(text: 'Size', correct: false),
        QuizOption(text: 'length()', correct: false),
      ]),
      Quiz(question: 'How do you access the first element of an array?', options: [
        QuizOption(text: '[0]', correct: true),
        QuizOption(text: '[1]', correct: false),
        QuizOption(text: '[first]', correct: false),
        QuizOption(text: '[start]', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'C#',
    title: 'Classes & Objects',
    content: '''
using System;

class Rectangle {
    public int Width;
    public int Height;

    public Rectangle(int w, int h) {
        Width = w;
        Height = h;
    }

    public int Area() {
        return Width * Height;
    }
}

class Program {
    static void Main(string[] args) {
        Rectangle rect = new Rectangle(5, 10);
        Console.WriteLine(\$"Area: {rect.Area()}");
    }
}

/*
Explanation:
- class: blueprint for objects
- Constructor initializes object
- public: accessible outside class
- private: only accessible inside class
- Methods define object behavior
*/
''',
    quiz: [
      Quiz(question: 'What initializes a new object in C#?', options: [
        QuizOption(text: 'Constructor', correct: true),
        QuizOption(text: 'Main', correct: false),
        QuizOption(text: 'Init', correct: false),
        QuizOption(text: 'Create', correct: false),
      ]),
      Quiz(question: 'Which keyword allows members to be accessed outside the class?', options: [
        QuizOption(text: 'public', correct: true),
        QuizOption(text: 'private', correct: false),
        QuizOption(text: 'protected', correct: false),
        QuizOption(text: 'internal', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'C#',
    title: 'Memory Management',
    content: '''
using System;

class Program {
    static void Main(string[] args) {
        int[] numbers = new int[5];
        for(int i = 0; i < 5; i++) {
            numbers[i] = i + 1;
        }

        foreach(int n in numbers) {
            Console.WriteLine(n);
        }
    }
}

/*
Explanation:
- C# uses garbage collection to free memory automatically
- new allocates memory for objects and arrays
- No need to manually delete objects
- IDisposable and using statement for unmanaged resources
- Avoid unnecessary large objects to reduce memory pressure
*/
''',
    quiz: [
      Quiz(question: 'How is memory freed in C#?', options: [
        QuizOption(text: 'Garbage collection', correct: true),
        QuizOption(text: 'delete keyword', correct: false),
        QuizOption(text: 'manual free()', correct: false),
        QuizOption(text: 'Memory is never freed', correct: false),
      ]),
      Quiz(question: 'Which keyword allocates memory for objects?', options: [
        QuizOption(text: 'new', correct: true),
        QuizOption(text: 'malloc', correct: false),
        QuizOption(text: 'alloc', correct: false),
        QuizOption(text: 'create', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'C#',
    title: 'File I/O',
    content: '''
using System;
using System.IO;

class Program {
    static void Main(string[] args) {
        File.WriteAllText("example.txt", "Hello File!");

        string content = File.ReadAllText("example.txt");
        Console.WriteLine(content);
    }
}

/*
Explanation:
- File.WriteAllText writes text to file
- File.ReadAllText reads text from file
- Always handle exceptions in real applications
- StreamReader/StreamWriter for larger files
- File.AppendAllText to add to existing file
*/
''',
    quiz: [
      Quiz(question: 'Which method writes text to a file in C#?', options: [
        QuizOption(text: 'File.WriteAllText', correct: true),
        QuizOption(text: 'File.ReadAllText', correct: false),
        QuizOption(text: 'Console.Write', correct: false),
        QuizOption(text: 'StreamWriter.Write', correct: false),
      ]),
      Quiz(question: 'Which method reads text from a file?', options: [
        QuizOption(text: 'File.ReadAllText', correct: true),
        QuizOption(text: 'File.WriteAllText', correct: false),
        QuizOption(text: 'Read()', correct: false),
        QuizOption(text: 'ReadLine()', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'C#',
    title: 'Exception Handling',
    content: '''
using System;

class Program {
    static void Main(string[] args) {
        try {
            int result = 10 / 0;
        } catch(DivideByZeroException e) {
            Console.WriteLine("Cannot divide by zero!");
        } finally {
            Console.WriteLine("Execution finished.");
        }
    }
}

/*
Explanation:
- try: code that may throw exception
- catch: handles specific exception
- finally: executes regardless of exception
- Common exceptions: DivideByZeroException, NullReferenceException,
  IndexOutOfRangeException, InvalidOperationException
*/
''',
    quiz: [
      Quiz(question: 'Which block handles exceptions?', options: [
        QuizOption(text: 'catch', correct: true),
        QuizOption(text: 'try', correct: false),
        QuizOption(text: 'finally', correct: false),
        QuizOption(text: 'throw', correct: false),
      ]),
      Quiz(question: 'Which exception occurs when dividing by zero?', options: [
        QuizOption(text: 'DivideByZeroException', correct: true),
        QuizOption(text: 'NullReferenceException', correct: false),
        QuizOption(text: 'IndexOutOfRangeException', correct: false),
        QuizOption(text: 'ArithmeticException', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'C#',
    title: 'Debugging & Putting It Together',
    content: '''
using System;

class Program {
    static void Main(string[] args) {
        int[] numbers = {1, 2, 3, 4, 5};
        int total = 0;

        foreach(int n in numbers) {
            total += n;
        }

        Console.WriteLine(\$"Total sum: {total}");
    }
}

/*
Debugging Tips:
- Use Console.WriteLine to trace values
- Watch for NullReferenceException, IndexOutOfRangeException
- Use IDE debugger (Visual Studio, VS Code)
- Modularize code with methods and classes
- foreach loop: simplified iteration over collections
*/
''',
    quiz: [
      Quiz(question: 'Which method is used for quick debugging output?', options: [
        QuizOption(text: 'Console.WriteLine', correct: true),
        QuizOption(text: 'print', correct: false),
        QuizOption(text: 'echo', correct: false),
        QuizOption(text: 'printf', correct: false),
      ]),
      Quiz(question: 'Which exception occurs for invalid array index?', options: [
        QuizOption(text: 'IndexOutOfRangeException', correct: true),
        QuizOption(text: 'DivideByZeroException', correct: false),
        QuizOption(text: 'NullReferenceException', correct: false),
        QuizOption(text: 'ArithmeticException', correct: false),
      ]),
    ],
  ),
];

// ─── Python ──────────────────────────────────────────────────────────────────

final pythonLessons = [
  Lesson(
    language: 'Python',
    title: 'Introduction & Setup',
    content: '''
# Hello World in Python
print("Hello, World!")

"""
Explanation:
- print() outputs text to the console
- No need for semicolons or main function
- Python uses indentation for blocks
- Python is dynamically typed
- Comments start with # or use triple quotes
"""
''',
    quiz: [
      Quiz(question: 'Which function prints output to the console?', options: [
        QuizOption(text: 'print()', correct: true),
        QuizOption(text: 'Console.WriteLine()', correct: false),
        QuizOption(text: 'printf()', correct: false),
        QuizOption(text: 'echo()', correct: false),
      ]),
      Quiz(question: 'How does Python define code blocks?', options: [
        QuizOption(text: 'Indentation', correct: true),
        QuizOption(text: 'Curly braces {}', correct: false),
        QuizOption(text: 'Semicolons', correct: false),
        QuizOption(text: 'Parentheses', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'Python',
    title: 'Variables & Data Types',
    content: '''
age = 25          # integer
price = 12.5      # float
name = "Alice"    # string
is_adult = True   # boolean

print(f"Age: {age}")
print(f"Price: {price}")
print(f"Name: {name}")
print(f"Adult: {is_adult}")

# Check type
print(type(age))   # <class 'int'>

"""
Explanation:
- Python is dynamically typed; type is inferred
- int, float, str, bool are basic types
- f-strings allow inline variable printing
- type() returns the type of a variable
"""
''',
    quiz: [
      Quiz(question: 'Which type is used for decimal numbers in Python?', options: [
        QuizOption(text: 'float', correct: true),
        QuizOption(text: 'int', correct: false),
        QuizOption(text: 'bool', correct: false),
        QuizOption(text: 'str', correct: false),
      ]),
      Quiz(question: 'Which type stores True/False values?', options: [
        QuizOption(text: 'bool', correct: true),
        QuizOption(text: 'int', correct: false),
        QuizOption(text: 'str', correct: false),
        QuizOption(text: 'float', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'Python',
    title: 'Operators',
    content: '''
a = 10
b = 3

print("a + b =", a + b)
print("a - b =", a - b)
print("a * b =", a * b)
print("a / b =", a / b)     # float division
print("a // b =", a // b)   # integer division
print("a % b =", a % b)     # remainder
print("a ** b =", a ** b)   # exponentiation

"""
Explanation:
- Arithmetic: + - * / // % **
- Comparison: == != > < >= <=
- Logical: and, or, not
- Assignment: =, +=, -=, *=, /=
- ** is exponentiation (2**3 = 8)
- // is floor division (10//3 = 3)
"""
''',
    quiz: [
      Quiz(question: 'What does // do in Python?', options: [
        QuizOption(text: 'Integer division', correct: true),
        QuizOption(text: 'Float division', correct: false),
        QuizOption(text: 'Modulo', correct: false),
        QuizOption(text: 'Exponent', correct: false),
      ]),
      Quiz(question: 'Which operator is exponentiation?', options: [
        QuizOption(text: '**', correct: true),
        QuizOption(text: '^', correct: false),
        QuizOption(text: '*', correct: false),
        QuizOption(text: '%', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'Python',
    title: 'Control Flow',
    content: '''
number = 5

if number > 0:
    print("Positive")
elif number == 0:
    print("Zero")
else:
    print("Negative")

for i in range(3):
    print(f"i = {i}")

j = 0
while j < 3:
    print(f"j = {j}")
    j += 1

"""
Explanation:
- if, elif, else: conditionals (no switch in Python)
- for: iterate over sequences or ranges
- while: repeat until condition is False
- range(n): 0 to n-1
- range(start, stop, step)
- break: exit loop
- continue: skip current iteration
"""
''',
    quiz: [
      Quiz(question: 'Which Python keyword is for multiple condition checks?', options: [
        QuizOption(text: 'elif', correct: true),
        QuizOption(text: 'else if', correct: false),
        QuizOption(text: 'switch', correct: false),
        QuizOption(text: 'case', correct: false),
      ]),
      Quiz(question: 'Which function generates a sequence of numbers?', options: [
        QuizOption(text: 'range()', correct: true),
        QuizOption(text: 'seq()', correct: false),
        QuizOption(text: 'list()', correct: false),
        QuizOption(text: 'enumerate()', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'Python',
    title: 'Functions',
    content: '''
def add(a, b):
    return a + b

def greet(name="World"):
    print(f"Hello, {name}!")

greet()
greet("Alice")

# Keyword arguments
def info(name, age):
    print(f"Name: {name}, Age: {age}")

info(age=25, name="Alice")

# Variable-length arguments
def sum_all(*args):
    return sum(args)

print(sum_all(1, 2, 3, 4))

"""
Explanation:
- def keyword defines function
- Parameters can have default values
- Keyword arguments allow any order
- *args collects variable number of arguments
- **kwargs collects keyword arguments as dict
- return sends value back to caller
"""
''',
    quiz: [
      Quiz(question: 'Which keyword defines a function in Python?', options: [
        QuizOption(text: 'def', correct: true),
        QuizOption(text: 'function', correct: false),
        QuizOption(text: 'func', correct: false),
        QuizOption(text: 'lambda', correct: false),
      ]),
      Quiz(question: 'How do you define a function that accepts variable number of arguments?', options: [
        QuizOption(text: '*args', correct: true),
        QuizOption(text: '**kwargs', correct: false),
        QuizOption(text: 'varargs', correct: false),
        QuizOption(text: 'array', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'Python',
    title: 'Lists & Strings',
    content: '''
numbers = [1, 2, 3, 4, 5]
print(numbers[0])
numbers.append(6)
numbers.pop()
numbers.insert(2, 10)
print(numbers[1:4])

name = "Alice"
print(name.upper())
print(name.lower())
print(name.replace("A", "E"))
print(name.split("i"))
print(len(name))

"""
Explanation:
- Lists: ordered, mutable sequences
- append(), insert(), pop(), remove(), slicing
- Strings: immutable sequences
- upper(), lower(), replace(), split(), strip(), find()
- len() returns number of elements
"""
''',
    quiz: [
      Quiz(question: 'Which method adds an element to a list?', options: [
        QuizOption(text: 'append()', correct: true),
        QuizOption(text: 'insert()', correct: false),
        QuizOption(text: 'pop()', correct: false),
        QuizOption(text: 'remove()', correct: false),
      ]),
      Quiz(question: 'Which method converts string to uppercase?', options: [
        QuizOption(text: 'upper()', correct: true),
        QuizOption(text: 'lower()', correct: false),
        QuizOption(text: 'capitalize()', correct: false),
        QuizOption(text: 'title()', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'Python',
    title: 'Classes & Objects',
    content: '''
class Rectangle:
    def __init__(self, width, height):
        self.width = width
        self.height = height

    def area(self):
        return self.width * self.height

    def __str__(self):
        return f"Rectangle({self.width}x{self.height})"

rect = Rectangle(5, 10)
print(f"Area: {rect.area()}")
print(rect)

"""
Explanation:
- __init__ is constructor
- self refers to instance
- Methods defined inside class
- __str__ defines string representation
- Classes encapsulate data and behavior
- Inheritance: class Child(Parent):
"""
''',
    quiz: [
      Quiz(question: 'What is self in Python classes?', options: [
        QuizOption(text: 'Reference to the instance', correct: true),
        QuizOption(text: 'Class name', correct: false),
        QuizOption(text: 'Function name', correct: false),
        QuizOption(text: 'Static variable', correct: false),
      ]),
      Quiz(question: 'Which method is called when an object is created?', options: [
        QuizOption(text: '__init__', correct: true),
        QuizOption(text: '__start__', correct: false),
        QuizOption(text: 'new()', correct: false),
        QuizOption(text: '__create__', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'Python',
    title: 'File I/O',
    content: '''
with open("example.txt", "w") as f:
    f.write("Hello File!\\n")

with open("example.txt", "r") as f:
    content = f.read()
    print(content)

# Read line by line
with open("example.txt", "r") as f:
    for line in f:
        print(line.strip())

"""
Explanation:
- open(filename, mode) opens file
- Modes: 'r'=read, 'w'=write, 'a'=append, 'rb'=binary read
- with ensures file is closed automatically
- read(), readline(), readlines()
- write() writes string to file
"""
''',
    quiz: [
      Quiz(question: 'Which mode opens a file for writing?', options: [
        QuizOption(text: 'w', correct: true),
        QuizOption(text: 'r', correct: false),
        QuizOption(text: 'a', correct: false),
        QuizOption(text: 'rb', correct: false),
      ]),
      Quiz(question: 'Which statement ensures a file is closed automatically?', options: [
        QuizOption(text: 'with open() as', correct: true),
        QuizOption(text: 'try-except', correct: false),
        QuizOption(text: 'close()', correct: false),
        QuizOption(text: 'finally', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'Python',
    title: 'Modules',
    content: '''
import math
print(math.sqrt(16))
print(math.pi)

from random import randint
print(randint(1, 10))

import os
print(os.getcwd())

"""
Explanation:
- import module or from module import function
- Standard library includes:
  math, random, os, sys, datetime, json, re,
  collections, itertools, functools, pathlib
- pip install package_name for third-party packages
"""
''',
    quiz: [
      Quiz(question: 'Which function computes square root using math module?', options: [
        QuizOption(text: 'math.sqrt()', correct: true),
        QuizOption(text: 'sqrt()', correct: false),
        QuizOption(text: 'math.square()', correct: false),
        QuizOption(text: 'math.root()', correct: false),
      ]),
      Quiz(question: 'Which keyword imports a module in Python?', options: [
        QuizOption(text: 'import', correct: true),
        QuizOption(text: 'using', correct: false),
        QuizOption(text: 'include', correct: false),
        QuizOption(text: 'require', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'Python',
    title: 'Debugging & Putting It Together',
    content: '''
numbers = [1, 2, 3, 4, 5]
total = 0

for n in numbers:
    total += n

print(f"Total sum: {total}")

"""
Debugging Tips:
- Use print() to trace values at different steps
- Python debugger: import pdb; pdb.set_trace()
- Common errors:
  - IndexError: invalid list index
  - TypeError: wrong type used
  - NameError: variable not defined
  - ValueError: wrong value type
  - KeyError: dictionary key not found
- Test functions individually
- Modularize code for clarity
"""
''',
    quiz: [
      Quiz(question: 'Which module provides an interactive debugger?', options: [
        QuizOption(text: 'pdb', correct: true),
        QuizOption(text: 'math', correct: false),
        QuizOption(text: 'random', correct: false),
        QuizOption(text: 'sys', correct: false),
      ]),
      Quiz(question: 'Which error occurs when accessing invalid list index?', options: [
        QuizOption(text: 'IndexError', correct: true),
        QuizOption(text: 'TypeError', correct: false),
        QuizOption(text: 'NameError', correct: false),
        QuizOption(text: 'ValueError', correct: false),
      ]),
    ],
  ),
];

// ─── Java ────────────────────────────────────────────────────────────────────

final javaLessons = [
  Lesson(
    language: 'Java',
    title: 'Introduction & Setup',
    content: '''
public class Main {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
    }
}

/*
Explanation:
- main method is the entry point
- System.out.println prints text to console
- Java is case-sensitive
- Each statement ends with a semicolon ;
- Java is compiled to bytecode and runs on JVM
*/
''',
    quiz: [
      Quiz(question: 'What is the entry point of a Java program?', options: [
        QuizOption(text: 'main()', correct: true),
        QuizOption(text: 'start()', correct: false),
        QuizOption(text: 'run()', correct: false),
        QuizOption(text: 'init()', correct: false),
      ]),
      Quiz(question: 'Which method prints text to the console?', options: [
        QuizOption(text: 'System.out.println()', correct: true),
        QuizOption(text: 'print()', correct: false),
        QuizOption(text: 'echo()', correct: false),
        QuizOption(text: 'printf()', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'Java',
    title: 'Variables & Data Types',
    content: '''
public class Main {
    public static void main(String[] args) {
        int age = 25;
        double price = 12.5;
        char grade = 'A';
        boolean isAdult = true;
        String name = "Alice";

        System.out.println("Age: " + age);
        System.out.println("Price: " + price);
        System.out.println("Grade: " + grade);
        System.out.println("Adult: " + isAdult);
        System.out.println("Name: " + name);
    }
}

/*
Explanation:
- int, double, char, boolean, String are common types
- String is an object (capitalized)
- Primitive types: int, double, char, boolean, long, float, short, byte
- Variables must be declared with type
*/
''',
    quiz: [
      Quiz(question: 'Which type stores true/false values?', options: [
        QuizOption(text: 'boolean', correct: true),
        QuizOption(text: 'int', correct: false),
        QuizOption(text: 'double', correct: false),
        QuizOption(text: 'char', correct: false),
      ]),
      Quiz(question: 'Which type is used for decimal numbers?', options: [
        QuizOption(text: 'double', correct: true),
        QuizOption(text: 'int', correct: false),
        QuizOption(text: 'float', correct: false),
        QuizOption(text: 'long', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'Java',
    title: 'Operators',
    content: '''
public class Main {
    public static void main(String[] args) {
        int a = 10, b = 3;
        System.out.println("a + b = " + (a + b));
        System.out.println("a - b = " + (a - b));
        System.out.println("a * b = " + (a * b));
        System.out.println("a / b = " + (a / b));
        System.out.println("a % b = " + (a % b));
    }
}

/*
Explanation:
- Arithmetic: + - * / %
- Comparison: == != > < >= <=
- Logical: && || !
- Assignment: = += -= *= /=
- Increment/Decrement: ++ --
*/
''',
    quiz: [
      Quiz(question: 'Which operator gives remainder of division?', options: [
        QuizOption(text: '%', correct: true),
        QuizOption(text: '/', correct: false),
        QuizOption(text: 'mod', correct: false),
        QuizOption(text: '!', correct: false),
      ]),
      Quiz(question: 'Which is logical AND operator?', options: [
        QuizOption(text: '&&', correct: true),
        QuizOption(text: '||', correct: false),
        QuizOption(text: '&', correct: false),
        QuizOption(text: '!', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'Java',
    title: 'Control Flow',
    content: '''
public class Main {
    public static void main(String[] args) {
        int number = 5;

        if(number > 0) {
            System.out.println("Positive");
        } else {
            System.out.println("Non-positive");
        }

        for(int i = 0; i < 3; i++) {
            System.out.println("i = " + i);
        }

        int j = 0;
        while(j < 3) {
            System.out.println("j = " + j);
            j++;
        }

        switch(number) {
            case 1: System.out.println("One"); break;
            case 5: System.out.println("Five"); break;
            default: System.out.println("Other"); break;
        }
    }
}
''',
    quiz: [
      Quiz(question: 'Which keyword exits a loop or switch?', options: [
        QuizOption(text: 'break', correct: true),
        QuizOption(text: 'continue', correct: false),
        QuizOption(text: 'exit', correct: false),
        QuizOption(text: 'stop', correct: false),
      ]),
      Quiz(question: 'Which statement is used for multi-way branching?', options: [
        QuizOption(text: 'switch', correct: true),
        QuizOption(text: 'if', correct: false),
        QuizOption(text: 'for', correct: false),
        QuizOption(text: 'loop', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'Java',
    title: 'Functions / Methods',
    content: '''
public class Main {

    static int add(int a, int b) {
        return a + b;
    }

    static void greet(String name) {
        System.out.println("Hello, " + name);
    }

    public static void main(String[] args) {
        int sum = add(5, 7);
        System.out.println("Sum: " + sum);
        greet("Alice");
    }
}

/*
Explanation:
- Methods allow code reuse
- static: belongs to class, not object
- return type specifies value returned
- void: no return
- Parameters pass data into method
- Method overloading: same name, different params
*/
''',
    quiz: [
      Quiz(question: 'Which keyword defines a method that belongs to the class, not object?', options: [
        QuizOption(text: 'static', correct: true),
        QuizOption(text: 'class', correct: false),
        QuizOption(text: 'void', correct: false),
        QuizOption(text: 'public', correct: false),
      ]),
      Quiz(question: 'Which return type means no value is returned?', options: [
        QuizOption(text: 'void', correct: true),
        QuizOption(text: 'int', correct: false),
        QuizOption(text: 'null', correct: false),
        QuizOption(text: 'none', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'Java',
    title: 'Arrays & Strings',
    content: '''
public class Main {
    public static void main(String[] args) {
        int[] numbers = {1, 2, 3, 4, 5};
        System.out.println(numbers[0]);
        numbers[2] = 10;
        System.out.println(numbers[2]);

        String name = "Alice";
        System.out.println(name.length());
        System.out.println(name.toUpperCase());
        System.out.println(name.substring(1, 4));
        System.out.println(name.contains("lic"));
    }
}
''',
    quiz: [
      Quiz(question: 'Which method returns the length of a string?', options: [
        QuizOption(text: 'length()', correct: true),
        QuizOption(text: 'size()', correct: false),
        QuizOption(text: 'count()', correct: false),
        QuizOption(text: 'len()', correct: false),
      ]),
      Quiz(question: 'How do you access the first element of an array?', options: [
        QuizOption(text: '[0]', correct: true),
        QuizOption(text: '[1]', correct: false),
        QuizOption(text: '[start]', correct: false),
        QuizOption(text: '[first]', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'Java',
    title: 'Classes & Objects',
    content: '''
public class Rectangle {
    int width;
    int height;

    Rectangle(int w, int h) {
        width = w;
        height = h;
    }

    int area() {
        return width * height;
    }

    public static void main(String[] args) {
        Rectangle rect = new Rectangle(5, 10);
        System.out.println("Area: " + rect.area());
    }
}

/*
Explanation:
- class: blueprint for objects
- constructor initializes object
- instance variables: properties of object
- methods: behavior of object
- new: creates object instance
*/
''',
    quiz: [
      Quiz(question: 'Which method initializes a new object?', options: [
        QuizOption(text: 'Constructor', correct: true),
        QuizOption(text: 'Main', correct: false),
        QuizOption(text: 'init()', correct: false),
        QuizOption(text: 'Create()', correct: false),
      ]),
      Quiz(question: 'What is an object?', options: [
        QuizOption(text: 'Instance of a class', correct: true),
        QuizOption(text: 'Class', correct: false),
        QuizOption(text: 'Method', correct: false),
        QuizOption(text: 'Array', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'Java',
    title: 'File I/O',
    content: '''
import java.io.*;

public class Main {
    public static void main(String[] args) {
        try {
            FileWriter writer = new FileWriter("example.txt");
            writer.write("Hello File!");
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }

        try {
            BufferedReader br = new BufferedReader(new FileReader("example.txt"));
            String line;
            while((line = br.readLine()) != null) {
                System.out.println(line);
            }
            br.close();
        } catch(IOException e) {
            e.printStackTrace();
        }
    }
}
''',
    quiz: [
      Quiz(question: 'Which class reads text from a file efficiently?', options: [
        QuizOption(text: 'BufferedReader', correct: true),
        QuizOption(text: 'FileWriter', correct: false),
        QuizOption(text: 'Scanner', correct: false),
        QuizOption(text: 'PrintWriter', correct: false),
      ]),
      Quiz(question: 'Which keyword handles exceptions?', options: [
        QuizOption(text: 'try-catch', correct: true),
        QuizOption(text: 'throws', correct: false),
        QuizOption(text: 'finally', correct: false),
        QuizOption(text: 'error', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'Java',
    title: 'Exception Handling',
    content: '''
public class Main {
    public static void main(String[] args) {
        try {
            int result = 10 / 0;
            System.out.println(result);
        } catch (ArithmeticException e) {
            System.out.println("Cannot divide by zero!");
        } finally {
            System.out.println("Execution finished.");
        }
    }
}

/*
Explanation:
- try: code that may throw exception
- catch: handles specific exception
- finally: executes regardless of exception
- Common exceptions:
  ArithmeticException, NullPointerException,
  ArrayIndexOutOfBoundsException, IOException,
  NumberFormatException, ClassNotFoundException
*/
''',
    quiz: [
      Quiz(question: 'Which block handles the exception?', options: [
        QuizOption(text: 'catch', correct: true),
        QuizOption(text: 'try', correct: false),
        QuizOption(text: 'finally', correct: false),
        QuizOption(text: 'throw', correct: false),
      ]),
      Quiz(question: 'Which exception occurs when dividing by zero?', options: [
        QuizOption(text: 'ArithmeticException', correct: true),
        QuizOption(text: 'NullPointerException', correct: false),
        QuizOption(text: 'ArrayIndexOutOfBoundsException', correct: false),
        QuizOption(text: 'IOException', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'Java',
    title: 'Debugging & Putting It Together',
    content: '''
public class Main {
    public static void main(String[] args) {
        int[] numbers = {1, 2, 3, 4, 5};
        int total = 0;

        for(int n : numbers) {
            total += n;
        }

        System.out.println("Total sum: " + total);
    }
}

/*
Debugging Tips:
- Use System.out.println() to trace values
- Watch for NullPointerException, ArrayIndexOutOfBoundsException
- Step through code with IDE debugger (Eclipse, IntelliJ, VS Code)
- Modularize code into methods and classes
- Enhanced for loop: for(int n : array) iterates all elements
*/
''',
    quiz: [
      Quiz(question: 'Which method is commonly used for quick debugging output?', options: [
        QuizOption(text: 'System.out.println()', correct: true),
        QuizOption(text: 'print()', correct: false),
        QuizOption(text: 'console.log()', correct: false),
        QuizOption(text: 'echo()', correct: false),
      ]),
      Quiz(question: 'Which exception occurs for invalid array index?', options: [
        QuizOption(text: 'ArrayIndexOutOfBoundsException', correct: true),
        QuizOption(text: 'NullPointerException', correct: false),
        QuizOption(text: 'ArithmeticException', correct: false),
        QuizOption(text: 'IOException', correct: false),
      ]),
    ],
  ),
];

// ─── Kotlin ──────────────────────────────────────────────────────────────────

final kotlinLessons = [
  Lesson(
    language: 'Kotlin',
    title: 'Introduction & Setup',
    content: '''
fun main() {
    println("Hello, World!")
}

/*
Explanation:
- main() is the entry point
- println prints text to console with a newline
- print() prints without newline
- Kotlin is case-sensitive
- Kotlin is fully interoperable with Java
*/
''',
    quiz: [
      Quiz(question: 'Which function prints text to console in Kotlin?', options: [
        QuizOption(text: 'println()', correct: true),
        QuizOption(text: 'print()', correct: false),
        QuizOption(text: 'Console.WriteLine()', correct: false),
        QuizOption(text: 'echo()', correct: false),
      ]),
      Quiz(question: 'What is the entry point of a Kotlin program?', options: [
        QuizOption(text: 'main()', correct: true),
        QuizOption(text: 'start()', correct: false),
        QuizOption(text: 'init()', correct: false),
        QuizOption(text: 'program()', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'Kotlin',
    title: 'Variables & Data Types',
    content: '''
fun main() {
    val name: String = "Alice"  // immutable
    var age: Int = 25           // mutable
    val price: Double = 12.5
    val grade: Char = 'A'
    val isAdult: Boolean = true

    println("Name: \$name")
    println("Age: \$age")
    println("Price: \$price")
    println("Grade: \$grade")
    println("Adult: \$isAdult")
}

/*
Explanation:
- val: read-only (immutable) variable
- var: mutable variable
- Types: Int, Double, Float, Char, Boolean, String, Long
- \$ allows string interpolation
- Type inference: val name = "Alice" (type auto-detected)
*/
''',
    quiz: [
      Quiz(question: 'Which keyword defines an immutable variable?', options: [
        QuizOption(text: 'val', correct: true),
        QuizOption(text: 'var', correct: false),
        QuizOption(text: 'let', correct: false),
        QuizOption(text: 'const', correct: false),
      ]),
      Quiz(question: 'Which type stores decimal numbers?', options: [
        QuizOption(text: 'Double', correct: true),
        QuizOption(text: 'Int', correct: false),
        QuizOption(text: 'Boolean', correct: false),
        QuizOption(text: 'Char', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'Kotlin',
    title: 'Operators',
    content: '''
fun main() {
    val a = 10
    val b = 3

    println("a + b = \${a + b}")
    println("a - b = \${a - b}")
    println("a * b = \${a * b}")
    println("a / b = \${a / b}")
    println("a % b = \${a % b}")

    println("a > b: \${a > b}")
    println("a == b: \${a == b}")
    println("Logical AND: \${a > 0 && b > 0}")
}

/*
Explanation:
- Arithmetic: + - * / %
- Comparison: > < == != >= <=
- Logical: && || !
- Kotlin uses === for referential equality
*/
''',
    quiz: [
      Quiz(question: 'Which operator gives the remainder?', options: [
        QuizOption(text: '%', correct: true),
        QuizOption(text: '/', correct: false),
        QuizOption(text: '*', correct: false),
        QuizOption(text: '-', correct: false),
      ]),
      Quiz(question: 'Which is logical AND operator in Kotlin?', options: [
        QuizOption(text: '&&', correct: true),
        QuizOption(text: '||', correct: false),
        QuizOption(text: 'and', correct: false),
        QuizOption(text: '!', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'Kotlin',
    title: 'Control Flow',
    content: '''
fun main() {
    val number = 5

    if(number > 0) {
        println("Positive")
    } else {
        println("Non-positive")
    }

    for(i in 0..2) {
        println("i = \$i")
    }

    var j = 0
    while(j < 3) {
        println("j = \$j")
        j++
    }

    when(number) {
        1 -> println("One")
        5 -> println("Five")
        else -> println("Other")
    }
}

/*
Explanation:
- if, else if, else: conditionals
- for: iterate over ranges or collections
- while: repeat until condition is false
- when: multi-way branching (replaces switch)
- ..: inclusive range operator
- until: exclusive range (0 until 5 = 0,1,2,3,4)
*/
''',
    quiz: [
      Quiz(question: 'Which statement is used for multi-way branching?', options: [
        QuizOption(text: 'when', correct: true),
        QuizOption(text: 'switch', correct: false),
        QuizOption(text: 'if', correct: false),
        QuizOption(text: 'for', correct: false),
      ]),
      Quiz(question: 'Which operator defines an inclusive range?', options: [
        QuizOption(text: '..', correct: true),
        QuizOption(text: 'until', correct: false),
        QuizOption(text: '->', correct: false),
        QuizOption(text: '-', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'Kotlin',
    title: 'Functions',
    content: '''
fun add(a: Int, b: Int): Int {
    return a + b
}

fun greet(name: String) {
    println("Hello, \$name")
}

fun main() {
    val sum = add(5, 7)
    println("Sum: \$sum")
    greet("Alice")
}

/*
Explanation:
- fun keyword defines function
- Return type specified after colon (:)
- Parameters defined with name: Type
- Void equivalent: Unit (can be omitted)
- Single-expression functions: fun add(a: Int, b: Int) = a + b
- Default parameter values supported
*/
''',
    quiz: [
      Quiz(question: 'Which keyword is used to define a function?', options: [
        QuizOption(text: 'fun', correct: true),
        QuizOption(text: 'def', correct: false),
        QuizOption(text: 'function', correct: false),
        QuizOption(text: 'func', correct: false),
      ]),
      Quiz(question: 'How do you specify the return type in Kotlin?', options: [
        QuizOption(text: 'After colon (:) after parameters', correct: true),
        QuizOption(text: 'Before function name', correct: false),
        QuizOption(text: 'Inside curly braces', correct: false),
        QuizOption(text: 'Using ->', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'Kotlin',
    title: 'Arrays & Strings',
    content: '''
fun main() {
    val numbers = arrayOf(1, 2, 3, 4, 5)
    println(numbers[0])
    numbers[2] = 10
    println(numbers[2])

    val name = "Alice"
    println(name.length)
    println(name.substring(1, 4))
    println(name + " Smith")
    println(name.uppercase())
}

/*
Explanation:
- arrayOf(): creates fixed-size array
- Strings support: length, substring, uppercase, lowercase, contains, replace
- String templates: "Hello \$name" or "Result: \${a + b}"
*/
''',
    quiz: [
      Quiz(question: 'How do you access the first element of an array?', options: [
        QuizOption(text: '[0]', correct: true),
        QuizOption(text: '[1]', correct: false),
        QuizOption(text: '[first]', correct: false),
        QuizOption(text: '[start]', correct: false),
      ]),
      Quiz(question: 'Which property gives string length?', options: [
        QuizOption(text: 'length', correct: true),
        QuizOption(text: 'size', correct: false),
        QuizOption(text: 'count', correct: false),
        QuizOption(text: 'len()', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'Kotlin',
    title: 'Classes & Objects',
    content: '''
class Rectangle(val width: Int, val height: Int) {
    fun area(): Int {
        return width * height
    }

    override fun toString(): String {
        return "Rectangle(\${width}x\${height})"
    }
}

fun main() {
    val rect = Rectangle(5, 10)
    println("Area: \${rect.area()}")
    println(rect)
}

/*
Explanation:
- class: blueprint for objects
- Primary constructor defined in class header
- val: read-only property, var: mutable property
- override toString() for string representation
- Data classes: data class Point(val x: Int, val y: Int)
*/
''',
    quiz: [
      Quiz(question: 'How do you define a class with a primary constructor?', options: [
        QuizOption(text: 'class Rectangle(val width: Int, val height: Int)', correct: true),
        QuizOption(text: 'class Rectangle() { }', correct: false),
        QuizOption(text: 'Rectangle(width: Int, height: Int)', correct: false),
        QuizOption(text: 'class Rectangle { constructor() }', correct: false),
      ]),
      Quiz(question: 'How do you define a read-only property in Kotlin class?', options: [
        QuizOption(text: 'val', correct: true),
        QuizOption(text: 'var', correct: false),
        QuizOption(text: 'const', correct: false),
        QuizOption(text: 'readonly', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'Kotlin',
    title: 'File I/O',
    content: '''
import java.io.File

fun main() {
    File("example.txt").writeText("Hello File!")

    val content = File("example.txt").readText()
    println(content)

    File("example.txt").readLines().forEach { println(it) }
}

/*
Explanation:
- File("filename"): access file
- writeText(): writes text (overwrites)
- appendText(): adds to existing file
- readText(): reads full file
- readLines(): reads as list of lines
- Always handle exceptions in real apps
*/
''',
    quiz: [
      Quiz(question: 'Which method writes text to a file?', options: [
        QuizOption(text: 'writeText()', correct: true),
        QuizOption(text: 'readText()', correct: false),
        QuizOption(text: 'println()', correct: false),
        QuizOption(text: 'write()', correct: false),
      ]),
      Quiz(question: 'Which method reads text from a file?', options: [
        QuizOption(text: 'readText()', correct: true),
        QuizOption(text: 'writeText()', correct: false),
        QuizOption(text: 'read()', correct: false),
        QuizOption(text: 'readLine()', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'Kotlin',
    title: 'Exception Handling',
    content: '''
fun main() {
    try {
        val result = 10 / 0
    } catch(e: ArithmeticException) {
        println("Cannot divide by zero!")
    } finally {
        println("Execution finished.")
    }
}

/*
Explanation:
- try: code that may fail
- catch: handles specific exception
- finally: always executes
- Common exceptions:
  ArithmeticException, NullPointerException,
  IndexOutOfBoundsException, IllegalArgumentException
- Kotlin also has the Elvis operator ?: for null safety
*/
''',
    quiz: [
      Quiz(question: 'Which block handles exceptions?', options: [
        QuizOption(text: 'catch', correct: true),
        QuizOption(text: 'try', correct: false),
        QuizOption(text: 'finally', correct: false),
        QuizOption(text: 'throw', correct: false),
      ]),
      Quiz(question: 'Which exception occurs when dividing by zero?', options: [
        QuizOption(text: 'ArithmeticException', correct: true),
        QuizOption(text: 'NullPointerException', correct: false),
        QuizOption(text: 'IndexOutOfBoundsException', correct: false),
        QuizOption(text: 'Exception', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'Kotlin',
    title: 'Debugging & Putting It Together',
    content: '''
fun main() {
    val numbers = arrayOf(1, 2, 3, 4, 5)
    var total = 0

    for(n in numbers) {
        total += n
    }

    println("Total sum: \$total")
}

/*
Debugging Tips:
- Use println to trace values
- Watch for exceptions like IndexOutOfBounds, NullPointer
- IDE debugger: Android Studio or IntelliJ
- Break code into functions and classes for clarity
- Kotlin null safety: use ? for nullable types
  val name: String? = null
*/
''',
    quiz: [
      Quiz(question: 'Which method is commonly used for quick debugging output?', options: [
        QuizOption(text: 'println()', correct: true),
        QuizOption(text: 'print()', correct: false),
        QuizOption(text: 'echo()', correct: false),
        QuizOption(text: 'write()', correct: false),
      ]),
      Quiz(question: 'Which exception occurs for invalid array index?', options: [
        QuizOption(text: 'IndexOutOfBoundsException', correct: true),
        QuizOption(text: 'ArithmeticException', correct: false),
        QuizOption(text: 'NullPointerException', correct: false),
        QuizOption(text: 'RuntimeException', correct: false),
      ]),
    ],
  ),
];

// ─── JavaScript ──────────────────────────────────────────────────────────────

final jsLessons = [
  Lesson(
    language: 'JavaScript',
    title: 'Introduction & Setup',
    content: '''
// This is a single-line comment
console.log("Hello, World!");

/*
Explanation:
- console.log prints text to console
- JavaScript is case-sensitive
- Runs in browser or Node.js
- Semicolons optional but recommended
*/
''',
    quiz: [
      Quiz(question: 'Which method prints text to console in JavaScript?', options: [
        QuizOption(text: 'console.log()', correct: true),
        QuizOption(text: 'print()', correct: false),
        QuizOption(text: 'System.out.println()', correct: false),
        QuizOption(text: 'echo()', correct: false),
      ]),
      Quiz(question: 'Where can JavaScript code run?', options: [
        QuizOption(text: 'Browser or Node.js', correct: true),
        QuizOption(text: 'Only browser', correct: false),
        QuizOption(text: 'Only server', correct: false),
        QuizOption(text: 'Java Virtual Machine', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'JavaScript',
    title: 'Variables & Data Types',
    content: '''
let name = "Alice";  // mutable
const pi = 3.14;     // immutable
var age = 25;        // old-style, avoid

let isAdult = true;
let price = 12.5;
let nothing = null;
let undef = undefined;

console.log("Name:", name);
console.log("Age:", age);
console.log("Pi:", pi);
console.log(typeof name);   // "string"
console.log(typeof age);    // "number"

/*
Explanation:
- let: mutable variable (block-scoped)
- const: immutable variable (block-scoped)
- var: old-style variable (function-scoped), avoid
- Types: string, number, boolean, null, undefined, object
- typeof: returns type as string
*/
''',
    quiz: [
      Quiz(question: 'Which keyword defines an immutable variable?', options: [
        QuizOption(text: 'const', correct: true),
        QuizOption(text: 'let', correct: false),
        QuizOption(text: 'var', correct: false),
        QuizOption(text: 'immutable', correct: false),
      ]),
      Quiz(question: 'Which type stores true/false values?', options: [
        QuizOption(text: 'boolean', correct: true),
        QuizOption(text: 'number', correct: false),
        QuizOption(text: 'string', correct: false),
        QuizOption(text: 'char', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'JavaScript',
    title: 'Operators',
    content: '''
let a = 10;
let b = 3;

console.log("a + b =", a + b);
console.log("a - b =", a - b);
console.log("a * b =", a * b);
console.log("a / b =", a / b);
console.log("a % b =", a % b);
console.log("a ** b =", a ** b);  // exponentiation

console.log("a > b:", a > b);
console.log("a === b:", a === b);  // strict equality
console.log("Logical AND:", a > 0 && b > 0);

/*
Explanation:
- Arithmetic: + - * / % **
- Comparison: == != === !== > < >= <=
- === checks value AND type (use this over ==)
- Logical: && || !
- Assignment: = += -= *= /=
*/
''',
    quiz: [
      Quiz(question: 'Which operator gives the remainder?', options: [
        QuizOption(text: '%', correct: true),
        QuizOption(text: '/', correct: false),
        QuizOption(text: '*', correct: false),
        QuizOption(text: '-', correct: false),
      ]),
      Quiz(question: 'Which operator checks value AND type?', options: [
        QuizOption(text: '===', correct: true),
        QuizOption(text: '==', correct: false),
        QuizOption(text: '!=', correct: false),
        QuizOption(text: '!==', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'JavaScript',
    title: 'Control Flow',
    content: '''
let number = 5;

if(number > 0) {
    console.log("Positive");
} else {
    console.log("Non-positive");
}

for(let i = 0; i < 3; i++) {
    console.log("i =", i);
}

let j = 0;
while(j < 3) {
    console.log("j =", j);
    j++;
}

switch(number) {
    case 1: console.log("One"); break;
    case 5: console.log("Five"); break;
    default: console.log("Other");
}

/*
Explanation:
- if, else if, else: conditionals
- for, while, do-while: loops
- switch: multi-way branching
- break: exit loop/switch
- continue: skip current iteration
- for...of: iterate over arrays
- for...in: iterate over object keys
*/
''',
    quiz: [
      Quiz(question: 'Which statement is used for multi-way branching?', options: [
        QuizOption(text: 'switch', correct: true),
        QuizOption(text: 'if', correct: false),
        QuizOption(text: 'for', correct: false),
        QuizOption(text: 'while', correct: false),
      ]),
      Quiz(question: 'Which keyword exits a loop or switch?', options: [
        QuizOption(text: 'break', correct: true),
        QuizOption(text: 'continue', correct: false),
        QuizOption(text: 'exit', correct: false),
        QuizOption(text: 'return', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'JavaScript',
    title: 'Functions',
    content: '''
function add(a, b) {
    return a + b;
}

function greet(name) {
    console.log("Hello, " + name);
}

let sum = add(5, 7);
console.log("Sum:", sum);
greet("Alice");

// Arrow function (modern syntax)
const multiply = (a, b) => a * b;
console.log(multiply(3, 4));

/*
Explanation:
- function keyword defines function
- return keyword specifies return value
- Arrow functions: shorter syntax
- Functions are first-class objects in JS
- Default parameters: function greet(name = "World")
- Rest parameters: function sum(...args)
*/
''',
    quiz: [
      Quiz(question: 'Which keyword specifies a return value?', options: [
        QuizOption(text: 'return', correct: true),
        QuizOption(text: 'yield', correct: false),
        QuizOption(text: 'output', correct: false),
        QuizOption(text: 'result', correct: false),
      ]),
      Quiz(question: 'Which is the correct arrow function syntax?', options: [
        QuizOption(text: 'const f = (a, b) => a + b', correct: true),
        QuizOption(text: 'const f = a, b -> a + b', correct: false),
        QuizOption(text: 'const f = function a, b { return a + b }', correct: false),
        QuizOption(text: 'arrow f(a, b) = a + b', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'JavaScript',
    title: 'Arrays & Strings',
    content: '''
let numbers = [1, 2, 3, 4, 5];
console.log(numbers[0]);
numbers.push(6);        // add to end
numbers.pop();          // remove from end
console.log(numbers.length);

let name = "Alice";
console.log(name.length);
console.log(name.substring(1, 4));
console.log(name + " Smith");
console.log(name.toUpperCase());
console.log(name.includes("lic"));

/*
Explanation:
- Arrays: ordered collection of elements
- push(), pop(), shift(), unshift(), splice(), slice()
- Strings: length, substring, toUpperCase, toLowerCase,
  includes, indexOf, replace, split, trim
*/
''',
    quiz: [
      Quiz(question: 'Which method adds element to end of array?', options: [
        QuizOption(text: 'push()', correct: true),
        QuizOption(text: 'pop()', correct: false),
        QuizOption(text: 'shift()', correct: false),
        QuizOption(text: 'unshift()', correct: false),
      ]),
      Quiz(question: 'Which property returns string length?', options: [
        QuizOption(text: 'length', correct: true),
        QuizOption(text: 'size', correct: false),
        QuizOption(text: 'count', correct: false),
        QuizOption(text: 'len()', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'JavaScript',
    title: 'Objects',
    content: '''
let person = {
    name: "Alice",
    age: 25,
    greet: function() {
        console.log("Hello, " + this.name);
    }
};

console.log(person.name);
console.log(person["age"]);
person.greet();

// Add new property
person.email = "alice@example.com";

/*
Explanation:
- Objects store key-value pairs
- Access with dot notation or bracket notation
- Methods: functions inside objects
- this keyword refers to current object
- Object.keys(), Object.values(), Object.entries()
*/
''',
    quiz: [
      Quiz(question: 'How do you call a method inside an object?', options: [
        QuizOption(text: 'object.method()', correct: true),
        QuizOption(text: 'object->method()', correct: false),
        QuizOption(text: 'object.method', correct: false),
        QuizOption(text: 'method(object)', correct: false),
      ]),
      Quiz(question: 'Which keyword refers to the current object?', options: [
        QuizOption(text: 'this', correct: true),
        QuizOption(text: 'self', correct: false),
        QuizOption(text: 'me', correct: false),
        QuizOption(text: 'current', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'JavaScript',
    title: 'DOM Basics',
    content: '''
// Access elements
let heading = document.getElementById("myHeading");
heading.innerText = "Hello DOM!";

// Query selector
let btn = document.querySelector(".myButton");

// Create element
let para = document.createElement("p");
para.innerText = "This is a paragraph.";
document.body.appendChild(para);

// Event listener
btn.addEventListener("click", function() {
    console.log("Button clicked!");
});

/*
Explanation:
- document.getElementById(): get element by id
- document.querySelector(): CSS selector
- createElement(): create new HTML element
- appendChild(): add element to DOM
- addEventListener(): handle events
- innerText / innerHTML: get or set content
*/
''',
    quiz: [
      Quiz(question: 'Which method gets element by id?', options: [
        QuizOption(text: 'document.getElementById()', correct: true),
        QuizOption(text: 'document.querySelector()', correct: false),
        QuizOption(text: 'getElementByClass()', correct: false),
        QuizOption(text: 'document.getElement()', correct: false),
      ]),
      Quiz(question: 'Which method adds element to the DOM?', options: [
        QuizOption(text: 'appendChild()', correct: true),
        QuizOption(text: 'addElement()', correct: false),
        QuizOption(text: 'insert()', correct: false),
        QuizOption(text: 'attachChild()', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'JavaScript',
    title: 'Exception Handling',
    content: '''
try {
    let result = JSON.parse("invalid json");
} catch(e) {
    console.log("Error occurred:", e.message);
} finally {
    console.log("Execution finished.");
}

// Custom error
try {
    throw new Error("Something went wrong");
} catch(e) {
    console.log(e.message);
}

/*
Explanation:
- try: code that may throw an error
- catch(e): handles the error, e is the error object
- finally: executes regardless of error
- throw: manually throw an error
- Common errors: ReferenceError, TypeError, RangeError, SyntaxError
*/
''',
    quiz: [
      Quiz(question: 'Which block handles exceptions?', options: [
        QuizOption(text: 'catch', correct: true),
        QuizOption(text: 'try', correct: false),
        QuizOption(text: 'finally', correct: false),
        QuizOption(text: 'throw', correct: false),
      ]),
      Quiz(question: 'Which error occurs when accessing undefined variable?', options: [
        QuizOption(text: 'ReferenceError', correct: true),
        QuizOption(text: 'TypeError', correct: false),
        QuizOption(text: 'SyntaxError', correct: false),
        QuizOption(text: 'RangeError', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'JavaScript',
    title: 'Debugging & Putting It Together',
    content: '''
let numbers = [1, 2, 3, 4, 5];
let total = 0;

for(let n of numbers) {
    total += n;
}

console.log("Total sum:", total);

/*
Debugging Tips:
- console.log(): print values
- console.error(): print errors
- console.table(): print arrays/objects as table
- Use browser DevTools (F12) debugger
- Watch for common errors:
  - ReferenceError: variable not defined
  - TypeError: wrong type operation
- for...of: iterate array values
- for...in: iterate object keys
*/
''',
    quiz: [
      Quiz(question: 'Which method is used for quick debugging output?', options: [
        QuizOption(text: 'console.log()', correct: true),
        QuizOption(text: 'print()', correct: false),
        QuizOption(text: 'echo()', correct: false),
        QuizOption(text: 'write()', correct: false),
      ]),
      Quiz(question: 'Which loop iterates over array values?', options: [
        QuizOption(text: 'for...of', correct: true),
        QuizOption(text: 'for...in', correct: false),
        QuizOption(text: 'forEach', correct: false),
        QuizOption(text: 'for...each', correct: false),
      ]),
    ],
  ),
];

// ─── HTML ────────────────────────────────────────────────────────────────────

final htmlLessons = [
  Lesson(
    language: 'HTML',
    title: 'HTML Structure',
    content: '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Page</title>
</head>
<body>
    <h1>Hello World</h1>
    <p>This is my first HTML page.</p>
</body>
</html>

<!--
Explanation:
- <!DOCTYPE html>: declares HTML5
- <html>: root element
- <head>: metadata, title, links to CSS/JS
- <body>: visible content
- <h1> to <h6>: headings (h1 is largest)
- <p>: paragraph
- meta charset: character encoding
- meta viewport: responsive design
-->
''',
    quiz: [
      Quiz(question: 'Which tag contains visible content of the page?', options: [
        QuizOption(text: '<body>', correct: true),
        QuizOption(text: '<head>', correct: false),
        QuizOption(text: '<html>', correct: false),
        QuizOption(text: '<title>', correct: false),
      ]),
      Quiz(question: 'Which tag declares HTML5 document?', options: [
        QuizOption(text: '<!DOCTYPE html>', correct: true),
        QuizOption(text: '<html>', correct: false),
        QuizOption(text: '<head>', correct: false),
        QuizOption(text: '<body>', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'HTML',
    title: 'Text & Links',
    content: '''
<p>This is a paragraph.</p>
<a href="https://example.com" target="_blank">Visit Example</a>
<strong>Bold Text</strong>
<em>Italic Text</em>
<br>
<hr>
<span>Inline element</span>

<!--
Explanation:
- <p>: paragraph
- <a href="URL">: hyperlink
- target="_blank": open in new tab
- <strong>: bold (semantic)
- <em>: italic (semantic)
- <br>: line break (self-closing)
- <hr>: horizontal rule
- <span>: inline container
-->
''',
    quiz: [
      Quiz(question: 'Which tag creates a hyperlink?', options: [
        QuizOption(text: '<a>', correct: true),
        QuizOption(text: '<link>', correct: false),
        QuizOption(text: '<href>', correct: false),
        QuizOption(text: '<url>', correct: false),
      ]),
      Quiz(question: 'Which tag makes text italic (semantic)?', options: [
        QuizOption(text: '<em>', correct: true),
        QuizOption(text: '<i>', correct: false),
        QuizOption(text: '<italic>', correct: false),
        QuizOption(text: '<it>', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'HTML',
    title: 'Images',
    content: '''
<img src="image.jpg" alt="Description of image" width="200" height="100">

<!-- Responsive image -->
<img src="photo.jpg" alt="Photo" style="max-width:100%">

<!-- Figure with caption -->
<figure>
    <img src="chart.png" alt="Chart">
    <figcaption>Figure 1: Chart</figcaption>
</figure>

<!--
Explanation:
- <img>: inserts image (self-closing)
- src: image source (URL or file path)
- alt: alternative text for accessibility/SEO
- width/height: size in pixels
- <figure>: semantic container for media
- <figcaption>: caption for figure
-->
''',
    quiz: [
      Quiz(question: 'Which attribute defines image source?', options: [
        QuizOption(text: 'src', correct: true),
        QuizOption(text: 'href', correct: false),
        QuizOption(text: 'link', correct: false),
        QuizOption(text: 'source', correct: false),
      ]),
      Quiz(question: 'Which attribute provides text if image fails to load?', options: [
        QuizOption(text: 'alt', correct: true),
        QuizOption(text: 'title', correct: false),
        QuizOption(text: 'desc', correct: false),
        QuizOption(text: 'text', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'HTML',
    title: 'Lists & Tables',
    content: '''
<!-- Ordered list -->
<ol>
    <li>First item</li>
    <li>Second item</li>
</ol>

<!-- Unordered list -->
<ul>
    <li>Item A</li>
    <li>Item B</li>
</ul>

<!-- Table -->
<table border="1">
    <thead>
        <tr><th>Name</th><th>Age</th></tr>
    </thead>
    <tbody>
        <tr><td>Alice</td><td>25</td></tr>
        <tr><td>Bob</td><td>30</td></tr>
    </tbody>
</table>

<!--
Explanation:
- <ol>: ordered (numbered) list
- <ul>: unordered (bullet) list
- <li>: list item
- <table>: table container
- <thead>: table header section
- <tbody>: table body section
- <tr>: table row
- <th>: table header cell (bold, centered)
- <td>: table data cell
-->
''',
    quiz: [
      Quiz(question: 'Which tag creates a list item?', options: [
        QuizOption(text: '<li>', correct: true),
        QuizOption(text: '<ul>', correct: false),
        QuizOption(text: '<ol>', correct: false),
        QuizOption(text: '<item>', correct: false),
      ]),
      Quiz(question: 'Which tag defines table header cell?', options: [
        QuizOption(text: '<th>', correct: true),
        QuizOption(text: '<td>', correct: false),
        QuizOption(text: '<tr>', correct: false),
        QuizOption(text: '<table>', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'HTML',
    title: 'Forms',
    content: '''
<form action="/submit" method="POST">
    <label for="name">Name:</label>
    <input type="text" id="name" name="name" required><br>

    <label for="email">Email:</label>
    <input type="email" id="email" name="email"><br>

    <label for="age">Age:</label>
    <input type="number" id="age" name="age" min="0" max="120"><br>

    <label>
        <input type="checkbox" name="agree"> I agree
    </label><br>

    <input type="submit" value="Submit">
    <input type="reset" value="Clear">
</form>

<!--
Explanation:
- <form>: container for inputs
- action: URL to send data to
- method: GET or POST
- <input> types: text, email, password, number,
  checkbox, radio, submit, reset, file, date
- <label>: accessible label for input
- required: field cannot be empty
- <textarea>: multi-line text input
- <select>: dropdown
-->
''',
    quiz: [
      Quiz(question: 'Which tag contains input fields?', options: [
        QuizOption(text: '<form>', correct: true),
        QuizOption(text: '<input>', correct: false),
        QuizOption(text: '<label>', correct: false),
        QuizOption(text: '<fieldset>', correct: false),
      ]),
      Quiz(question: 'Which input type sends form on click?', options: [
        QuizOption(text: 'submit', correct: true),
        QuizOption(text: 'button', correct: false),
        QuizOption(text: 'text', correct: false),
        QuizOption(text: 'reset', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'HTML',
    title: 'Semantic Elements',
    content: '''
<header>
    <nav>
        <a href="/">Home</a>
        <a href="/about">About</a>
    </nav>
</header>

<main>
    <article>
        <h2>Article Title</h2>
        <p>Article content...</p>
    </article>

    <aside>
        <p>Sidebar content</p>
    </aside>
</main>

<footer>
    <p>&copy; 2024 My Site</p>
</footer>

<!--
Semantic HTML5 elements:
- <header>: page or section header
- <nav>: navigation links
- <main>: main content area
- <article>: self-contained content
- <section>: thematic grouping
- <aside>: sidebar / supplementary content
- <footer>: page or section footer
- Benefits: better SEO, accessibility, readability
-->
''',
    quiz: [
      Quiz(question: 'Which tag defines navigation links?', options: [
        QuizOption(text: '<nav>', correct: true),
        QuizOption(text: '<menu>', correct: false),
        QuizOption(text: '<links>', correct: false),
        QuizOption(text: '<header>', correct: false),
      ]),
      Quiz(question: 'Which tag represents self-contained content?', options: [
        QuizOption(text: '<article>', correct: true),
        QuizOption(text: '<section>', correct: false),
        QuizOption(text: '<main>', correct: false),
        QuizOption(text: '<div>', correct: false),
      ]),
    ],
  ),
];

// ─── CSS ─────────────────────────────────────────────────────────────────────

final cssLessons = [
  Lesson(
    language: 'CSS',
    title: 'CSS Selectors & Colors',
    content: '''
/* Element selector */
p {
    color: blue;
    font-size: 16px;
}

/* ID selector */
#myId {
    background-color: yellow;
}

/* Class selector */
.highlight {
    font-weight: bold;
    color: red;
}

/* Multiple selectors */
h1, h2, h3 {
    font-family: Arial, sans-serif;
}

/* Descendant selector */
div p {
    margin: 10px;
}

/*
Explanation:
- element selector: targets all elements of that type
- #id selector: targets specific element by id
- .class selector: targets elements with that class
- Multiple: comma-separated
- Descendant: space-separated
- Child: div > p (direct children only)
*/
''',
    quiz: [
      Quiz(question: 'Which selector targets an element by id?', options: [
        QuizOption(text: '#id', correct: true),
        QuizOption(text: '.class', correct: false),
        QuizOption(text: 'element', correct: false),
        QuizOption(text: '*', correct: false),
      ]),
      Quiz(question: 'Which property changes text color?', options: [
        QuizOption(text: 'color', correct: true),
        QuizOption(text: 'background-color', correct: false),
        QuizOption(text: 'font-color', correct: false),
        QuizOption(text: 'text-color', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'CSS',
    title: 'Box Model',
    content: '''
div {
    width: 200px;
    height: 100px;
    padding: 10px;             /* inside border */
    border: 5px solid black;   /* border itself */
    margin: 20px;              /* outside border */
    box-sizing: border-box;    /* include padding in width */
}

/*
Explanation:
- Content: width & height
- Padding: space inside border
- Border: thickness around padding
- Margin: space outside border
- box-sizing: border-box (recommended) makes
  width include padding and border
- Total default size = content + padding + border + margin
*/
''',
    quiz: [
      Quiz(question: 'Which property adds space inside the border?', options: [
        QuizOption(text: 'padding', correct: true),
        QuizOption(text: 'margin', correct: false),
        QuizOption(text: 'border', correct: false),
        QuizOption(text: 'spacing', correct: false),
      ]),
      Quiz(question: 'Which property is outermost in the box model?', options: [
        QuizOption(text: 'margin', correct: true),
        QuizOption(text: 'padding', correct: false),
        QuizOption(text: 'border', correct: false),
        QuizOption(text: 'content', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'CSS',
    title: 'Typography & Fonts',
    content: '''
body {
    font-family: 'Georgia', serif;
    font-size: 16px;
    line-height: 1.6;
    color: #333;
}

h1 {
    font-size: 2rem;
    font-weight: bold;
    text-align: center;
    letter-spacing: 2px;
    text-transform: uppercase;
}

p {
    text-decoration: underline;
    word-spacing: 3px;
}

/*
Explanation:
- font-family: typeface (use fallbacks)
- font-size: px, em, rem, %
- font-weight: normal, bold, 100-900
- line-height: spacing between lines
- text-align: left, right, center, justify
- text-transform: uppercase, lowercase, capitalize
- letter-spacing: space between characters
*/
''',
    quiz: [
      Quiz(question: 'Which property sets the typeface?', options: [
        QuizOption(text: 'font-family', correct: true),
        QuizOption(text: 'font-size', correct: false),
        QuizOption(text: 'font-style', correct: false),
        QuizOption(text: 'font-weight', correct: false),
      ]),
      Quiz(question: 'Which property centers text horizontally?', options: [
        QuizOption(text: 'text-align: center', correct: true),
        QuizOption(text: 'align: center', correct: false),
        QuizOption(text: 'justify-content: center', correct: false),
        QuizOption(text: 'margin: auto', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'CSS',
    title: 'Layout - Flexbox',
    content: '''
.container {
    display: flex;
    justify-content: center;   /* horizontal alignment */
    align-items: center;       /* vertical alignment */
    flex-wrap: wrap;           /* wrap to next line */
    gap: 10px;                 /* spacing between items */
}

.item {
    flex: 1;                   /* grow to fill space */
    min-width: 200px;
}

/*
Explanation:
- display: flex makes container a flex container
- justify-content: flex-start, center, flex-end, space-between, space-around
- align-items: flex-start, center, flex-end, stretch
- flex-direction: row (default) or column
- flex-wrap: wrap items to new lines
- flex: shorthand for flex-grow, flex-shrink, flex-basis
- gap: spacing between flex items
*/
''',
    quiz: [
      Quiz(question: 'Which display value makes a container a flex container?', options: [
        QuizOption(text: 'flex', correct: true),
        QuizOption(text: 'grid', correct: false),
        QuizOption(text: 'block', correct: false),
        QuizOption(text: 'inline', correct: false),
      ]),
      Quiz(question: 'Which property aligns items along the main axis?', options: [
        QuizOption(text: 'justify-content', correct: true),
        QuizOption(text: 'align-items', correct: false),
        QuizOption(text: 'flex-wrap', correct: false),
        QuizOption(text: 'flex-direction', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'CSS',
    title: 'Layout - CSS Grid',
    content: '''
.grid-container {
    display: grid;
    grid-template-columns: 1fr 2fr 1fr;
    grid-template-rows: auto;
    gap: 20px;
    padding: 10px;
}

.header {
    grid-column: 1 / -1;   /* spans all columns */
}

.sidebar {
    grid-column: 1;
}

.main {
    grid-column: 2 / 4;
}

/*
Explanation:
- display: grid makes container a grid
- grid-template-columns: defines column sizes
- fr: fractional unit
- repeat(3, 1fr): three equal columns
- gap: spacing between grid items
- grid-column: / to span columns
- grid-row: / to span rows
*/
''',
    quiz: [
      Quiz(question: 'Which display value creates a grid layout?', options: [
        QuizOption(text: 'grid', correct: true),
        QuizOption(text: 'flex', correct: false),
        QuizOption(text: 'block', correct: false),
        QuizOption(text: 'table', correct: false),
      ]),
      Quiz(question: 'Which property sets spacing between grid items?', options: [
        QuizOption(text: 'gap', correct: true),
        QuizOption(text: 'margin', correct: false),
        QuizOption(text: 'padding', correct: false),
        QuizOption(text: 'spacing', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'CSS',
    title: 'Transitions & Animations',
    content: '''
/* Transition */
button {
    background-color: blue;
    color: white;
    transition: background-color 0.3s ease, transform 0.2s;
}

button:hover {
    background-color: darkblue;
    transform: scale(1.05);
}

/* Keyframe animation */
@keyframes fadeIn {
    from { opacity: 0; transform: translateY(-10px); }
    to   { opacity: 1; transform: translateY(0); }
}

.animated {
    animation: fadeIn 0.5s ease forwards;
}

/*
Explanation:
- transition: smooth property changes on state change
- :hover: triggered when mouse hovers
- @keyframes: define animation steps
- animation: name duration easing fill-mode
- transform: scale, rotate, translate, skew
*/
''',
    quiz: [
      Quiz(question: 'Which property defines smooth CSS property changes?', options: [
        QuizOption(text: 'transition', correct: true),
        QuizOption(text: 'animation', correct: false),
        QuizOption(text: 'transform', correct: false),
        QuizOption(text: 'hover', correct: false),
      ]),
      Quiz(question: 'Which rule defines animation keyframes?', options: [
        QuizOption(text: '@keyframes', correct: true),
        QuizOption(text: 'animation', correct: false),
        QuizOption(text: 'transition', correct: false),
        QuizOption(text: '@animation', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'CSS',
    title: 'Responsive Design',
    content: '''
/* Mobile first approach */
.container {
    width: 100%;
    padding: 10px;
}

/* Tablet */
@media (min-width: 600px) {
    .container {
        max-width: 600px;
        margin: 0 auto;
    }
}

/* Desktop */
@media (min-width: 1024px) {
    .container {
        max-width: 1200px;
        display: grid;
        grid-template-columns: 1fr 3fr;
    }
}

/*
Explanation:
- @media: apply styles based on device/screen size
- min-width: apply from this width up (mobile-first)
- max-width: apply up to this width
- Common breakpoints: 600px (tablet), 1024px (desktop)
- Mobile-first: start with mobile styles, then enhance
*/
''',
    quiz: [
      Quiz(question: 'Which CSS feature applies styles based on screen size?', options: [
        QuizOption(text: '@media', correct: true),
        QuizOption(text: '@screen', correct: false),
        QuizOption(text: '@responsive', correct: false),
        QuizOption(text: '@viewport', correct: false),
      ]),
      Quiz(question: 'Which approach starts with mobile styles?', options: [
        QuizOption(text: 'Mobile-first', correct: true),
        QuizOption(text: 'Desktop-first', correct: false),
        QuizOption(text: 'Responsive-first', correct: false),
        QuizOption(text: 'Grid-first', correct: false),
      ]),
    ],
  ),
  Lesson(
    language: 'CSS',
    title: 'Putting It Together',
    content: '''
<!DOCTYPE html>
<html>
<head>
<style>
:root {
    --primary: #2563eb;
    --bg: #f8fafc;
}

* {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
}

body {
    font-family: Georgia, serif;
    background: var(--bg);
}

.container {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
}

.box {
    width: 120px;
    height: 120px;
    background-color: var(--primary);
    border-radius: 12px;
    transition: transform 0.4s ease, box-shadow 0.4s ease;
    cursor: pointer;
}

.box:hover {
    transform: rotate(45deg) scale(1.15);
    box-shadow: 0 20px 40px rgba(37,99,235,0.3);
}
</style>
</head>
<body>
<div class="container">
    <div class="box"></div>
</div>
</body>
</html>

/*
Combines:
- CSS variables (:root)
- Box model, flexbox layout
- Hover transitions
- box-shadow effect
- border-radius for rounded corners
*/
''',
    quiz: [
      Quiz(question: 'Where are CSS custom variables (CSS variables) defined?', options: [
        QuizOption(text: ':root', correct: true),
        QuizOption(text: 'body', correct: false),
        QuizOption(text: ':variables', correct: false),
        QuizOption(text: '@vars', correct: false),
      ]),
      Quiz(question: 'Which property adds rounded corners?', options: [
        QuizOption(text: 'border-radius', correct: true),
        QuizOption(text: 'border-curve', correct: false),
        QuizOption(text: 'corner-radius', correct: false),
        QuizOption(text: 'round', correct: false),
      ]),
    ],
  ),
];

// ─── Central LessonData ───────────────────────────────────────────────────────

class LessonData {
  static final Map<String, List<Lesson>> _lessons = {
    'C': cLessons,
    'C++': cppLessons,
    'C#': csharpLessons,
    'Python': pythonLessons,
    'Java': javaLessons,
    'Kotlin': kotlinLessons,
    'JavaScript': jsLessons,
    'HTML': htmlLessons,
    'CSS': cssLessons,
  };

  static List<Lesson> getLessonsByLanguage(String language) {
    return _lessons[language] ?? [];
  }

  static Map<String, List<Lesson>> get allLessons => _lessons;
}

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cLesson31 = Lesson(
  language: 'C',
  title: 'File I/O',
  content: """
🎯 METAPHOR:
Working with files is like working with a physical notebook.
Open it (fopen), read or write page by page, then close it
(fclose) when done. The FILE pointer is like your pen —
it remembers exactly where you are in the notebook.

📖 EXPLANATION:
File modes:
"r"  → read only (file must exist)
"w"  → write only (creates or overwrites)
"a"  → append (creates if not exists)
"r+" → read and write
"rb" → read binary    "wb" → write binary

💻 CODE:
#include <stdio.h>

int main() {
    // Write a file
    FILE *f = fopen("test.txt", "w");
    if (!f) { perror("fopen"); return 1; }
    fprintf(f, "Line 1: Hello!\n");
    fprintf(f, "Line 2: %d\n", 42);
    fclose(f);

    // Read line by line
    f = fopen("test.txt", "r");
    char buf[256];
    while (fgets(buf, sizeof(buf), f) != NULL)
        printf("%s", buf);
    fclose(f);

    // File position and size
    f = fopen("test.txt", "r");
    fseek(f, 0, SEEK_END);
    long size = ftell(f);
    printf("File size: %ld bytes\n", size);
    rewind(f);
    fclose(f);

    // Binary file
    int data[] = {1, 2, 3, 4, 5};
    f = fopen("data.bin", "wb");
    fwrite(data, sizeof(int), 5, f);
    fclose(f);

    int read_data[5];
    f = fopen("data.bin", "rb");
    fread(read_data, sizeof(int), 5, f);
    fclose(f);

    for (int i = 0; i < 5; i++) printf("%d ", read_data[i]);
    printf("\n");

    remove("test.txt");
    remove("data.bin");
    return 0;
}
""",
  quiz: [
    Quiz(question: 'What mode opens a file for writing, creating it if needed?', options: [
      QuizOption(text: '"w"', correct: true),
      QuizOption(text: '"r"', correct: false),
      QuizOption(text: '"a"', correct: false),
      QuizOption(text: '"x"', correct: false),
    ]),
    Quiz(question: 'What does fseek(file, 0, SEEK_END) do?', options: [
      QuizOption(text: 'Moves the file position to the end', correct: true),
      QuizOption(text: 'Deletes the file', correct: false),
      QuizOption(text: 'Closes the file', correct: false),
      QuizOption(text: 'Reads 0 bytes from the end', correct: false),
    ]),
    Quiz(question: 'Difference between text and binary mode?', options: [
      QuizOption(text: 'Binary reads raw bytes; text may translate newlines', correct: true),
      QuizOption(text: 'Binary is for numbers only', correct: false),
      QuizOption(text: 'Text mode is always faster', correct: false),
      QuizOption(text: 'No difference on all platforms', correct: false),
    ]),
  ],
);

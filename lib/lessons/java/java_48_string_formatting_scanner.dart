import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson48 = Lesson(
  language: 'Java',
  title: 'String Formatting and User Input',
  content: """
🎯 METAPHOR:
String formatting is like a professional mail-merge
system. You design a template: "Dear {name}, your invoice
for {amount} is due on {date}." Then you pour in the data
and the system fills in every placeholder precisely —
right-aligned numbers, two decimal places on money,
month names spelled out, column widths padded to align
a report. Without formatting, printing a table of numbers
is chaos. With it, you control every pixel of output.
Scanner is the reverse — it reads whatever the user
types (or whatever's in a file) and parses it into the
types your program needs, one token at a time.

📖 EXPLANATION:
String.format() / printf() use printf-style specifiers.
Scanner reads tokenized input from System.in, files, or Strings.

─────────────────────────────────────
FORMAT SPECIFIERS — QUICK REFERENCE:
─────────────────────────────────────
  %s     → String
  %d     → integer (decimal)
  %f     → floating point (6 decimal places by default)
  %e     → scientific notation (1.234500e+02)
  %g     → shorter of %f or %e
  %b     → boolean
  %c     → character
  %x     → hex (lowercase)
  %X     → hex (uppercase)
  %o     → octal
  %n     → platform newline
  %%     → literal percent

WIDTH AND PRECISION:
  %10s   → right-align in 10 chars
  %-10s  → left-align in 10 chars
  %10.2f → width 10, 2 decimal places
  %05d   → zero-pad to 5 wide
  %,d    → thousands separator (1,000,000)
  %+.2f  → always show sign (+3.14)
  %(f    → parentheses for negative: (1.23)

─────────────────────────────────────
String.format() vs printf():
─────────────────────────────────────
  // Returns a formatted String:
  String s = String.format("Hello, %s! Score: %.1f%%", name, score);

  // Java 15+ shorthand (equivalent):
  String s = "Hello, %s! Score: %.1f%%".formatted(name, score);

  // Prints AND formats (no return):
  System.out.printf("Hello, %s! Score: %.1f%%%n", name, score);
  System.out.printf("%-15s %5d %8.2f%n", name, rank, score);

─────────────────────────────────────
Formatter — explicit control:
─────────────────────────────────────
  StringBuilder sb = new StringBuilder();
  Formatter fmt = new Formatter(sb);
  fmt.format("%-10s %5d%n", "Alice", 95);
  fmt.format("%-10s %5d%n", "Bob",   82);
  System.out.print(sb);
  fmt.close();

─────────────────────────────────────
Scanner — reading input:
─────────────────────────────────────
  Scanner sc = new Scanner(System.in);   // from keyboard
  Scanner sc = new Scanner(file);         // from file
  Scanner sc = new Scanner("1 2 3");     // from String

  sc.next()         → next token (whitespace-delimited)
  sc.nextLine()     → entire line (including spaces)
  sc.nextInt()      → parse next token as int
  sc.nextDouble()   → parse next token as double
  sc.nextBoolean()  → parse next token as boolean
  sc.hasNext()      → true if more tokens
  sc.hasNextLine()  → true if more lines
  sc.hasNextInt()   → true if next is a valid int
  sc.close()        → close when done

  DELIMITER:
  sc.useDelimiter(",")  → split on comma instead of whitespace

─────────────────────────────────────
READING FILES WITH Scanner:
─────────────────────────────────────
  try (Scanner sc = new Scanner(new File("data.txt"))) {
      while (sc.hasNextLine()) {
          String line = sc.nextLine();
          // process line
      }
  }

  // Parse CSV:
  try (Scanner sc = new Scanner(new File("data.csv"))) {
      sc.useDelimiter("[,\\\\n]");
      while (sc.hasNext()) {
          String field = sc.next();
      }
  }

─────────────────────────────────────
printf-style TABLE FORMATTING:
─────────────────────────────────────
  System.out.printf("%-20s %10s %8s%n", "Name", "Score", "Grade");
  System.out.println("-".repeat(40));
  System.out.printf("%-20s %10.2f %8s%n", "Alice", 95.5, "A");
  System.out.printf("%-20s %10.2f %8s%n", "Bob",   82.0, "B");

  Output:
  Name                      Score    Grade
  ----------------------------------------
  Alice                     95.50        A
  Bob                       82.00        B

💻 CODE:
import java.util.*;
import java.util.stream.*;
import java.io.*;

public class StringFormattingScanner {
    public static void main(String[] args) throws Exception {

        // ─── BASIC FORMAT SPECIFIERS ──────────────────────
        System.out.println("=== Format Specifiers ===");
        String  name  = "Terry";
        int     score = 95;
        double  gpa   = 3.847;
        boolean honor = true;

        System.out.printf("  Name:    %s%n", name);
        System.out.printf("  Score:   %d%n", score);
        System.out.printf("  GPA:     %.2f%n", gpa);
        System.out.printf("  Honor:   %b%n", honor);
        System.out.printf("  Hex 255: %X%n", 255);
        System.out.printf("  Oct 255: %o%n", 255);
        System.out.printf("  Sci:     %e%n", 12345.6789);
        System.out.printf("  Pct:     %.1f%%%n", 78.5);

        // ─── WIDTH AND ALIGNMENT ──────────────────────────
        System.out.println("\n=== Width and Alignment ===");
        System.out.printf("  '%10s'  right-aligned%n", "hello");
        System.out.printf("  '%-10s'  left-aligned%n",  "hello");
        System.out.printf("  '%10d'  right-aligned%n", 42);
        System.out.printf("  '%05d'  zero-padded%n",   42);
        System.out.printf("  '%10.3f' width+precision%n", 3.14159);
        System.out.printf("  '%+.2f'  always sign%n",  3.14);
        System.out.printf("  '%+.2f'  always sign%n", -3.14);
        System.out.printf("  '%,d'    thousands sep%n", 1_234_567);
        System.out.printf("  '%,.2f'  number format%n", 1_234.567);

        // ─── TABLE FORMATTING ─────────────────────────────
        System.out.println("\n=== Employee Table ===");
        record Employee(String name, String dept, double salary, int years) {}
        List<Employee> employees = List.of(
            new Employee("Alice Chen",    "Engineering", 95_000, 6),
            new Employee("Bob Smith",     "Marketing",   72_000, 3),
            new Employee("Charlie Davis", "Engineering", 110_000, 8),
            new Employee("Diana Wilson",  "HR",          65_000, 2),
            new Employee("Eve Johnson",   "Engineering",  88_000, 4)
        );

        String header = "%-18s %-14s %12s %6s";
        System.out.printf("  " + header + "%n", "Name", "Department", "Salary", "Years");
        System.out.println("  " + "─".repeat(55));

        for (var e : employees) {
            System.out.printf("  %-18s %-14s %12s %6d%n",
                e.name(), e.dept(),
                String.format("$%,.0f", e.salary()),
                e.years());
        }

        System.out.println("  " + "─".repeat(55));
        double total = employees.stream().mapToDouble(Employee::salary).sum();
        System.out.printf("  %-32s %12s%n", "TOTAL PAYROLL:", String.format("$%,.0f", total));

        // ─── String.format() vs .formatted() ─────────────
        System.out.println("\n=== String.format() vs .formatted() ===");
        String msg1 = String.format("Name: %-10s Score: %3d Grade: %s",
            "Alice", 95, "A");
        String msg2 = "Name: %-10s Score: %3d Grade: %s"
            .formatted("Alice", 95, "A");   // Java 15+
        System.out.println("  format():    " + msg1);
        System.out.println("  .formatted():" + msg2);
        System.out.println("  Equal: " + msg1.equals(msg2));

        // ─── REPORTS WITH Formatter ───────────────────────
        System.out.println("\n=== Report with Formatter ===");
        StringWriter sw = new StringWriter();
        try (Formatter fmt = new Formatter(sw)) {
            fmt.format("%-30s%n", "QUARTERLY SALES REPORT");
            fmt.format("%-30s%n", "=".repeat(30));
            fmt.format("%-15s %10s %10s%n", "Product", "Units", "Revenue");
            fmt.format("%-15s %10s %10s%n", "─".repeat(15), "─".repeat(10), "─".repeat(10));

            String[][] data = {
                {"Widget A", "1,250",  "$31,250"},
                {"Widget B",   "890",  "$44,500"},
                {"Widget C", "2,100",  "$21,000"},
                {"Widget D",   "450",  "$22,500"}
            };
            for (String[] row : data) {
                fmt.format("%-15s %10s %10s%n", row[0], row[1], row[2]);
            }
            fmt.format("%-15s %10s %10s%n", "─".repeat(15), "─".repeat(10), "─".repeat(10));
            fmt.format("%-15s %10s %10s%n", "TOTAL", "4,690", "$119,250");
        }
        System.out.println(sw);

        // ─── SCANNER FROM STRING ──────────────────────────
        System.out.println("=== Scanner — Parse String ===");
        String data = "Alice 95 3.8\nBob 82 3.2\nCharlie 91 3.7";
        Scanner sc1 = new Scanner(data);
        System.out.printf("  %-10s %5s %5s%n", "Name", "Score", "GPA");
        while (sc1.hasNextLine()) {
            String line = sc1.nextLine();
            Scanner lineScanner = new Scanner(line);
            String studentName = lineScanner.next();
            int    studentScore = lineScanner.nextInt();
            double studentGpa   = lineScanner.nextDouble();
            System.out.printf("  %-10s %5d %5.1f%n",
                studentName, studentScore, studentGpa);
            lineScanner.close();
        }
        sc1.close();

        // ─── SCANNER WITH DELIMITER ───────────────────────
        System.out.println("\n=== Scanner with CSV Delimiter ===");
        String csv = "Alice,95,Engineering,2018-03-15\n" +
                     "Bob,82,Marketing,2020-07-01\n" +
                     "Charlie,91,Engineering,2019-11-20";

        Scanner csvScanner = new Scanner(csv);
        csvScanner.useDelimiter("[,\n]");

        System.out.printf("  %-10s %5s %-15s %s%n",
            "Name", "Score", "Dept", "Date");
        while (csvScanner.hasNext()) {
            String n  = csvScanner.next().trim();
            int    s  = csvScanner.nextInt();
            String d  = csvScanner.next().trim();
            String dt = csvScanner.next().trim();
            System.out.printf("  %-10s %5d %-15s %s%n", n, s, d, dt);
        }
        csvScanner.close();

        // ─── NUMERIC FORMAT PATTERNS ──────────────────────
        System.out.println("\n=== Numeric Formatting Patterns ===");
        double[] numbers = {0.001, 1.5, 1000, 1_234_567.89, -42.5, Math.PI};

        System.out.printf("  %-15s %-12s %-12s %-12s %-12s%n",
            "Value", "%f", "%.2f", "%,d", "%e");
        for (double n : numbers) {
            System.out.printf("  %-15.5f %-12.6f %-12.2f %-12s %-12.3e%n",
                n, n, n,
                n % 1 == 0 ? String.format("%,d", (long)n) : "N/A",
                n);
        }

        // ─── KEYBOARD INPUT DEMO (simulated) ─────────────
        System.out.println("\n=== Scanner Keyboard Input (simulated) ===");
        System.out.println("  In real programs, use Scanner to read keyboard input:");
        System.out.println("""
              Scanner sc = new Scanner(System.in);
              System.out.print("Enter your name: ");
              String name = sc.nextLine();
              System.out.print("Enter your age: ");
              int age = sc.nextInt();
              System.out.printf("Hello %s, you are %d years old!%n", name, age);
              sc.close();
            """);

        // Simulated version with a fake input
        Scanner fakeInput = new Scanner("Terry\n30");
        System.out.print("  [Simulated] Enter your name: ");
        String inputName = fakeInput.nextLine();
        System.out.println(inputName);
        System.out.print("  [Simulated] Enter your age: ");
        int inputAge = fakeInput.nextInt();
        System.out.println(inputAge);
        System.out.printf("  Hello %s, you are %d years old!%n", inputName, inputAge);
        fakeInput.close();
    }
}

📝 KEY POINTS:
✅ String.format() returns a String; printf() prints and returns void
✅ .formatted() (Java 15+) is the idiomatic String method alternative to String.format()
✅ %-10s left-aligns; %10s right-aligns; %05d zero-pads
✅ %,.2f formats as 1,234.57 — comma separator with 2 decimal places
✅ Use Formatter with a StringWriter/StringBuilder for building reports
✅ Scanner.nextLine() reads the whole line; next() reads one whitespace-delimited token
✅ useDelimiter() sets a custom split pattern (comma for CSV)
✅ Always close Scanner to release underlying resources
✅ hasNextInt(), hasNextDouble() safely check before parsing
❌ Don't mix nextLine() with nextInt() without consuming the newline in between
❌ nextInt() leaves the newline in the buffer — call nextLine() after to consume it
❌ Don't use Scanner for large file parsing — prefer Files.lines() or BufferedReader
❌ %n is the platform-neutral newline; \\n is always Unix newline
""",
  quiz: [
    Quiz(question: 'What is the difference between %-10s and %10s in format specifiers?', options: [
      QuizOption(text: '%-10s left-aligns the text in 10 characters; %10s right-aligns it', correct: true),
      QuizOption(text: '%-10s uses negative padding (dashes); %10s uses spaces', correct: false),
      QuizOption(text: '%-10s is for Strings; %10s is for numbers only', correct: false),
      QuizOption(text: '%-10s limits the string to 10 chars; %10s expands it to 10 chars', correct: false),
    ]),
    Quiz(question: 'What is the common bug when mixing nextInt() and nextLine() in Scanner?', options: [
      QuizOption(text: 'nextInt() leaves the newline in the buffer — the following nextLine() reads an empty string', correct: true),
      QuizOption(text: 'nextInt() clears the buffer — nextLine() then reads from the beginning again', correct: false),
      QuizOption(text: 'nextLine() resets the delimiter set by useDelimiter() after nextInt()', correct: false),
      QuizOption(text: 'They cannot be mixed — nextInt() and nextLine() use different internal buffers', correct: false),
    ]),
    Quiz(question: 'What does %,d produce for the value 1234567?', options: [
      QuizOption(text: '1,234,567 — adds thousands separators', correct: true),
      QuizOption(text: '1234567, — appends a comma to the number', correct: false),
      QuizOption(text: '1.234.567 — uses period as thousands separator in some locales', correct: false),
      QuizOption(text: 'A compile error — the comma flag is not a valid format specifier', correct: false),
    ]),
  ],
);

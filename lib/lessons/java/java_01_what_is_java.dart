import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson01 = Lesson(
  language: 'Java',
  title: 'What is Java?',
  content: """
🎯 METAPHOR:
Java is like a universal power adapter for software.
Your laptop charger only works in one country's outlets.
But a universal adapter works everywhere — Europe, Asia,
Australia, the Americas. Java's secret is the same idea:
you write your code ONCE, and the Java Virtual Machine
(JVM) acts as the universal adapter, translating it to
run on ANY operating system. Windows, macOS, Linux,
Android — the same Java code, everywhere.
"Write Once, Run Anywhere" is not just a slogan.
It's the design principle that made Java the most
widely used programming language on Earth.

📖 EXPLANATION:
Java is a high-level, object-oriented, statically typed
programming language developed by James Gosling at Sun
Microsystems and released in 1995. Oracle acquired Sun
in 2010 and continues to develop Java today.

─────────────────────────────────────
WHY JAVA BECAME SO DOMINANT:
─────────────────────────────────────
  ✅ Platform independent  → Write Once, Run Anywhere
  ✅ Object-oriented       → Clean, reusable design
  ✅ Strongly typed        → Errors caught at compile time
  ✅ Automatic memory mgmt → Garbage collector handles memory
  ✅ Massive ecosystem     → Libraries for everything
  ✅ Enterprise proven     → Powers banks, hospitals, Google

─────────────────────────────────────
HOW JAVA WORKS — THE JVM:
─────────────────────────────────────
  Your code (.java file)
        ↓  javac (compiler)
  Bytecode (.class file)
        ↓  JVM (on any platform)
  Machine code → runs on THIS computer

  Other languages compile directly to machine code for
  one specific OS/CPU. Java compiles to bytecode —
  a universal middle-ground language — and the JVM
  (installed on the target machine) handles the rest.

─────────────────────────────────────
JAVA EDITIONS:
─────────────────────────────────────
  Java SE  → Standard Edition (what we learn here)
             Core language + standard library
  Java EE  → Enterprise Edition (now Jakarta EE)
             Web servers, databases, enterprise apps
  Java ME  → Micro Edition
             Embedded devices, IoT (less common today)

─────────────────────────────────────
JAVA VERSIONS — A QUICK HISTORY:
─────────────────────────────────────
  Java 1.0  (1996) → The beginning
  Java 5    (2004) → Generics, enums, autoboxing
  Java 8    (2014) → Lambdas, Streams, DateTime API  ⭐ milestone
  Java 11   (2018) → LTS — Long Term Support release ⭐ common
  Java 17   (2021) → LTS — Records, sealed classes   ⭐ popular
  Java 21   (2023) → LTS — Virtual threads, pattern  ⭐ current LTS

  LTS = Long Term Support — supported for many years.
  Most companies use Java 11, 17, or 21.

─────────────────────────────────────
JAVA vs KOTLIN vs PYTHON vs C++:
─────────────────────────────────────
  Language  Type system  Speed    Use case
  ─────────────────────────────────────────
  Java      Static       Fast     Enterprise, Android (legacy)
  Kotlin    Static       Fast     Android (modern), JVM apps
  Python    Dynamic      Slower   Data science, scripts, AI
  C++       Static       Fastest  Systems, games, performance

Java is still the most popular language for enterprise
backend development, and one of the top languages for
Android (before Kotlin took over), big data (Hadoop, Spark),
and teaching computer science worldwide.

─────────────────────────────────────
YOUR FIRST JAVA PROGRAM:
─────────────────────────────────────
  public class HelloWorld {
      public static void main(String[] args) {
          System.out.println("Hello, World!");
      }
  }

Every Java program needs:
  1. A CLASS that matches the filename
  2. A main() method — the entry point
  3. System.out.println() to print

💻 CODE:
// File: HelloJava.java
// Every Java program is a class. The filename MUST match
// the public class name exactly — including capitalization.

public class HelloJava {

    // main() is the entry point — Java starts here.
    // public  → accessible from anywhere
    // static  → belongs to the class, not an instance
    // void    → returns nothing
    // String[] args → command-line arguments (can be empty)
    public static void main(String[] args) {

        // Print with newline
        System.out.println("Hello, World!");

        // Print without newline
        System.out.print("Hello ");
        System.out.print("Java!");
        System.out.println(); // just a newline

        // String formatting (printf-style)
        System.out.printf("Java %d was released in %d%n", 21, 2023);

        // Variables — must declare type explicitly
        String language = "Java";
        int year = 1995;
        boolean isAwesome = true;

        System.out.println(language + " was created in " + year);
        System.out.println("Is Java awesome? " + isAwesome);

        // Show the JVM version you're running
        System.out.println("Java version: " +
            System.getProperty("java.version"));
    }
}

/*
  OUTPUT:
  Hello, World!
  Hello Java!
  Java 21 was released in 2023
  Java was created in 1995
  Is Java awesome? true
  Java version: 21.0.1
*/

📝 KEY POINTS:
✅ Java runs on the JVM — Write Once, Run Anywhere
✅ Java is statically typed — all variable types declared at compile time
✅ Every Java program lives inside a class
✅ The main() method is the entry point — execution starts here
✅ The filename MUST match the public class name exactly
✅ Java 8, 11, 17, and 21 are the most important versions to know
✅ System.out.println() prints with newline; print() without
✅ Garbage collection handles memory — no manual malloc/free
❌ Java is verbose compared to Kotlin or Python — that's intentional
❌ Don't confuse Java with JavaScript — they are completely different
❌ The filename and class name MUST match — HelloWorld.java ≠ Helloworld.java
❌ Java is NOT the same as Jakarta EE (Java EE) — we're learning Java SE
""",
  quiz: [
    Quiz(question: 'What does the JVM (Java Virtual Machine) do?', options: [
      QuizOption(text: 'Translates Java bytecode into machine code for the current platform', correct: true),
      QuizOption(text: 'Compiles Java source code into bytecode', correct: false),
      QuizOption(text: 'Manages network connections for Java applications', correct: false),
      QuizOption(text: 'Provides a graphical interface for Java programs', correct: false),
    ]),
    Quiz(question: 'What must be true about the filename of a Java source file?', options: [
      QuizOption(text: 'It must exactly match the name of the public class inside it', correct: true),
      QuizOption(text: 'It can be any name as long as it ends in .java', correct: false),
      QuizOption(text: 'It must be all lowercase to compile correctly', correct: false),
      QuizOption(text: 'It must match the package name of the class', correct: false),
    ]),
    Quiz(question: 'Which Java version introduced lambdas and the Streams API?', options: [
      QuizOption(text: 'Java 8', correct: true),
      QuizOption(text: 'Java 5', correct: false),
      QuizOption(text: 'Java 11', correct: false),
      QuizOption(text: 'Java 17', correct: false),
    ]),
  ],
);

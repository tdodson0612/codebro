import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson02 = Lesson(
  language: 'Java',
  title: 'Setting Up Java',
  content: """
🎯 METAPHOR:
Setting up Java is like setting up a recording studio.
You need three things: the instruments (the JDK — tools
that let you CREATE Java programs), the recording software
(your IDE — where you write and run the code), and the
playback system (the JRE — what actually runs Java programs,
already included in the JDK). Skip the JDK and you have
nowhere to write music. Skip the IDE and you're writing
on a napkin. Everything is free — you just need to install
it in the right order.

📖 EXPLANATION:
There are two key things to understand before setting up:

─────────────────────────────────────
JDK vs JRE vs JVM:
─────────────────────────────────────
  JVM  → Java Virtual Machine
         The engine that RUNS compiled bytecode
         Included inside JRE

  JRE  → Java Runtime Environment
         JVM + core libraries
         Enough to RUN Java programs
         NOT enough to DEVELOP them

  JDK  → Java Development Kit
         JRE + compiler (javac) + tools (jar, javadoc...)
         Everything you need to WRITE and RUN Java

  ✅ Install the JDK — it includes everything.

─────────────────────────────────────
STEP 1: INSTALL THE JDK
─────────────────────────────────────
Choose a JDK distribution (all free):

  ⭐ Temurin (Eclipse Adoptium) — most popular free JDK
     https://adoptium.net/
     Recommended: Java 21 LTS

  Oracle JDK — official, free for development
     https://www.oracle.com/java/technologies/downloads/

  Amazon Corretto — AWS's free LTS build
     https://aws.amazon.com/corretto/

  Install Java 21 LTS for new projects.
  Check it's working:
    java -version   → should show 21.x.x
    javac -version  → should show javac 21.x.x

─────────────────────────────────────
STEP 2: CHOOSE YOUR IDE
─────────────────────────────────────
  ⭐ IntelliJ IDEA Community (FREE — best Java IDE)
     → https://www.jetbrains.com/idea/
     → Everything works out of the box
     → Smart completion, refactoring, debugging

  Eclipse IDE (Free, classic)
     → https://www.eclipse.org/
     → Popular in enterprise / academia

  VS Code + Extension Pack for Java (Free)
     → Lighter weight option
     → Good for smaller projects

  → IntelliJ IDEA Community is strongly recommended.
    It's what most professional Java developers use.

─────────────────────────────────────
STEP 3: CREATE A PROJECT IN INTELLIJ
─────────────────────────────────────
  1. Open IntelliJ IDEA
  2. New Project → Java → JDK 21
  3. Name your project (e.g. "MyFirstJavaProject")
  4. src/ folder → right click → New → Java Class
  5. Name it "Main" → write your code → Run ▶

─────────────────────────────────────
COMMAND LINE WORKFLOW (optional):
─────────────────────────────────────
  # Compile
  javac HelloWorld.java

  # This creates HelloWorld.class (bytecode)

  # Run
  java HelloWorld

  # Or in one command (Java 11+):
  java HelloWorld.java

─────────────────────────────────────
PROJECT STRUCTURE (typical):
─────────────────────────────────────
  MyProject/
  ├── src/
  │   └── main/
  │       └── java/
  │           └── com/
  │               └── example/
  │                   └── Main.java
  ├── out/           ← compiled .class files
  └── MyProject.iml  ← IntelliJ project file

  With build tools (real projects use these):
  ├── pom.xml        ← Maven build config
  └── build.gradle   ← Gradle build config

─────────────────────────────────────
BUILD TOOLS:
─────────────────────────────────────
  Real Java projects use a build tool to manage
  dependencies and compilation:

  Maven  → uses pom.xml (XML config)
           most common in enterprise
  Gradle → uses build.gradle (Kotlin/Groovy DSL)
           modern, flexible, used in Android

  For learning: IntelliJ without a build tool is fine.
  For real projects: learn Maven or Gradle next.

─────────────────────────────────────
CHECKING YOUR SETUP:
─────────────────────────────────────
  Open a terminal/command prompt and type:

  java -version
  ──────────────────────────────────
  openjdk version "21.0.1" 2023-10-17
  OpenJDK Runtime Environment Temurin-21.0.1+12
  OpenJDK 64-Bit Server VM Temurin-21.0.1+12

  javac -version
  ──────────────────────────────────
  javac 21.0.1

  If you see version numbers → you're ready!

💻 CODE:
// File: Main.java
// This is your setup verification program.
// Create this file, compile it, and run it.

public class Main {
    public static void main(String[] args) {

        // Print Java environment information
        System.out.println("=".repeat(40));
        System.out.println("  Java Environment Check");
        System.out.println("=".repeat(40));

        // System properties — built into every JVM
        String version = System.getProperty("java.version");
        String vendor  = System.getProperty("java.vendor");
        String home    = System.getProperty("java.home");
        String os      = System.getProperty("os.name");
        String arch    = System.getProperty("os.arch");

        System.out.println("Java Version : " + version);
        System.out.println("Java Vendor  : " + vendor);
        System.out.println("Java Home    : " + home);
        System.out.println("OS Name      : " + os);
        System.out.println("Architecture : " + arch);
        System.out.println("=".repeat(40));

        // Basic math to confirm things run
        int a = 10, b = 3;
        System.out.printf("Math check: %d + %d = %d%n", a, b, a + b);
        System.out.printf("Math check: %d * %d = %d%n", a, b, a * b);
        System.out.printf("Math check: %d / %d = %d%n", a, b, a / b);

        System.out.println("=".repeat(40));
        System.out.println("  Setup complete! Let's write Java.");
        System.out.println("=".repeat(40));
    }
}

/*
  EXPECTED OUTPUT:
  ════════════════════════════════════════
    Java Environment Check
  ════════════════════════════════════════
  Java Version : 21.0.1
  Java Vendor  : Eclipse Adoptium
  Java Home    : /usr/lib/jvm/java-21
  OS Name      : Mac OS X
  Architecture : aarch64
  ════════════════════════════════════════
  Math check: 10 + 3 = 13
  Math check: 10 * 3 = 30
  Math check: 10 / 3 = 3
  ════════════════════════════════════════
    Setup complete! Let's write Java.
  ════════════════════════════════════════
*/

📝 KEY POINTS:
✅ Install the JDK — it includes the JRE and JVM
✅ Java 21 LTS is the recommended version for new projects
✅ Temurin (Adoptium) is the most popular free JDK distribution
✅ IntelliJ IDEA Community Edition is the best free Java IDE
✅ javac compiles .java → .class; java runs the .class file
✅ Java 11+ supports running .java files directly without compiling first
✅ Real projects use Maven or Gradle to manage dependencies
✅ System.getProperty() reads JVM environment information
❌ Don't install JRE alone if you want to write Java — you need the JDK
❌ Don't confuse javac (compiler) with java (runtime)
❌ Don't mix JDK versions in the same project — stick to one
❌ VS Code needs additional setup for Java — IntelliJ works out of the box
""",
  quiz: [
    Quiz(question: 'What is the difference between the JDK and JRE?', options: [
      QuizOption(text: 'The JDK includes the compiler and tools for development; the JRE only runs Java programs', correct: true),
      QuizOption(text: 'The JRE is newer than the JDK; they are otherwise the same', correct: false),
      QuizOption(text: 'The JDK runs Java programs; the JRE compiles them', correct: false),
      QuizOption(text: 'The JDK is for Windows; the JRE is for Mac and Linux', correct: false),
    ]),
    Quiz(question: 'Which command compiles a Java source file?', options: [
      QuizOption(text: 'javac FileName.java', correct: true),
      QuizOption(text: 'java FileName.java', correct: false),
      QuizOption(text: 'compile FileName.java', correct: false),
      QuizOption(text: 'jvm FileName.java', correct: false),
    ]),
    Quiz(question: 'Which Java version is the current Long Term Support (LTS) release recommended for new projects?', options: [
      QuizOption(text: 'Java 21', correct: true),
      QuizOption(text: 'Java 8', correct: false),
      QuizOption(text: 'Java 14', correct: false),
      QuizOption(text: 'Java 19', correct: false),
    ]),
  ],
);

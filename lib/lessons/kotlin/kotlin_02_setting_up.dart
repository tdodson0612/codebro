import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson02 = Lesson(
  language: 'Kotlin',
  title: 'Setting Up Kotlin',
  content: """
🎯 METAPHOR:
Setting up Kotlin is like preparing a kitchen before you cook.
You need the right appliances (the JDK), a good workspace
(your IDE or terminal), and the right ingredients ready to go
(your project structure). A master chef can cook on a campfire,
but a proper kitchen makes everything faster, cleaner, and
more enjoyable. IntelliJ IDEA is the five-star kitchen —
built by the same people who made Kotlin.

📖 EXPLANATION:
There are several ways to run Kotlin code. Pick the one
that fits your situation.

─────────────────────────────────────
OPTION 1: IntelliJ IDEA (Recommended)
─────────────────────────────────────
The best Kotlin IDE, made by JetBrains — same company
that made Kotlin itself.

  1. Download IntelliJ IDEA Community (free):
     https://www.jetbrains.com/idea/
  2. Create New Project → Kotlin → JVM
  3. Write code in src/main/kotlin/
  4. Click Run ▶ or press Shift+F10

─────────────────────────────────────
OPTION 2: Android Studio
─────────────────────────────────────
If you're doing Android development:

  1. Download Android Studio (free):
     https://developer.android.com/studio
  2. New Project → Empty Activity
  3. Language: Kotlin
  4. Run on emulator or real device

─────────────────────────────────────
OPTION 3: Command Line
─────────────────────────────────────
Step 1: Install JDK 17+ (Java Development Kit)
  → https://adoptium.net/

Step 2: Install Kotlin compiler
  → https://kotlinlang.org/docs/command-line.html
  → Or use SDKMAN: sdk install kotlin

Step 3: Compile and run:
  kotlinc hello.kt -include-runtime -d hello.jar
  java -jar hello.jar

─────────────────────────────────────
OPTION 4: Kotlin Playground (no install)
─────────────────────────────────────
Run Kotlin instantly in the browser:
  https://play.kotlinlang.org/

Perfect for experimenting without setting anything up.

─────────────────────────────────────
PROJECT STRUCTURE (JVM project):
─────────────────────────────────────
  my-project/
  ├── src/
  │   └── main/
  │       └── kotlin/
  │           └── Main.kt       ← your code goes here
  ├── build.gradle.kts          ← build config (Gradle)
  └── settings.gradle.kts

─────────────────────────────────────
FILE NAMING CONVENTIONS:
─────────────────────────────────────
  Files end in .kt
  File names use PascalCase: MyClass.kt
  One top-level class per file (convention, not required)
  Package name matches directory structure

💻 CODE:
// File: Main.kt
// This is all you need for a basic Kotlin program

fun main() {
    println("Kotlin is running!")

    // Check your Kotlin version at runtime
    val version = KotlinVersion.CURRENT
    println("Kotlin version: \$version")
}

// You can have multiple top-level functions in one file
fun greet(name: String) {
    println("Hello, \$name!")
}

// No class required for simple programs
// (Unlike Java where everything must be in a class)

📝 KEY POINTS:
✅ Kotlin files use the .kt extension
✅ IntelliJ IDEA is the best environment — made by same team
✅ The Kotlin Playground is perfect for quick experiments
✅ JDK 17+ is recommended for modern Kotlin development
✅ No class wrapper needed for top-level functions and main()
✅ Gradle is the standard build tool for Kotlin projects
❌ Don't confuse JDK (Java Development Kit) with JRE
   (Java Runtime Environment) — you need the JDK to compile
❌ The command-line compiler is rarely used day-to-day —
   use an IDE for real projects
❌ Kotlin files are NOT .java files — never mix extensions
""",
  quiz: [
    Quiz(question: 'What file extension do Kotlin source files use?', options: [
      QuizOption(text: '.kt', correct: true),
      QuizOption(text: '.kotlin', correct: false),
      QuizOption(text: '.java', correct: false),
      QuizOption(text: '.kts', correct: false),
    ]),
    Quiz(question: 'Which IDE is made by the same company that created Kotlin?', options: [
      QuizOption(text: 'IntelliJ IDEA', correct: true),
      QuizOption(text: 'Eclipse', correct: false),
      QuizOption(text: 'VS Code', correct: false),
      QuizOption(text: 'Android Studio', correct: false),
    ]),
    Quiz(question: 'What is required to compile and run Kotlin on the command line?', options: [
      QuizOption(text: 'The JDK (Java Development Kit)', correct: true),
      QuizOption(text: 'Only the JRE (Java Runtime Environment)', correct: false),
      QuizOption(text: 'Node.js', correct: false),
      QuizOption(text: 'The Android SDK', correct: false),
    ]),
  ],
);

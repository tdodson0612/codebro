import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson30 = Lesson(
  language: 'Kotlin',
  title: 'File I/O and Standard Input',
  content: """
🎯 METAPHOR:
File I/O is like a filing cabinet. Reading a file is like
opening a drawer, pulling out a folder, and reading what's
inside. Writing a file is like typing up a document and
putting it in the folder. The cabinet stays after you leave
(data persists). The folder name is the file path.
You must open the drawer (open the file) to access it,
and you should close it when done (close the stream) —
otherwise other people can't access the cabinet properly.
Kotlin's extension functions on File make this as natural
as talking to the cabinet in plain English.

📖 EXPLANATION:
Kotlin runs on the JVM and uses Java's java.io.File class,
but wraps it with extension functions that are much cleaner
to use. Reading a file is a one-liner in Kotlin.

─────────────────────────────────────
FILE — the core class:
─────────────────────────────────────
  import java.io.File

  val file = File("path/to/file.txt")

  // Check existence and type
  file.exists()        // true if file exists
  file.isFile()        // true if it's a file (not directory)
  file.isDirectory()   // true if it's a folder

─────────────────────────────────────
READING FILES — Kotlin extension methods:
─────────────────────────────────────
  file.readText()          → entire file as a String
  file.readLines()         → List<String> of lines
  file.forEachLine { }     → stream through lines (memory efficient)
  file.bufferedReader()    → Java-style BufferedReader
  file.readBytes()         → ByteArray

  // One-liner read:
  val content = File("data.txt").readText()

  // Read with charset:
  val content = File("data.txt").readText(Charsets.UTF_8)

─────────────────────────────────────
WRITING FILES — Kotlin extension methods:
─────────────────────────────────────
  file.writeText("content")       → write (overwrites!)
  file.appendText("more")         → append to existing
  file.writeBytes(byteArray)      → write raw bytes
  file.printWriter().use { }      → line-by-line writing

  // Overwrite:
  File("out.txt").writeText("Hello, World!")

  // Append:
  File("out.txt").appendText("\\nNew line")

─────────────────────────────────────
use {} — automatic resource management:
─────────────────────────────────────
  Like Java's try-with-resources. Closes the resource
  automatically when the block finishes, even if an
  exception is thrown.

  File("out.txt").bufferedWriter().use { writer ->
      writer.write("Line 1")
      writer.newLine()
      writer.write("Line 2")
  }  // automatically closed here

─────────────────────────────────────
PATHS AND DIRECTORIES:
─────────────────────────────────────
  file.name          → "file.txt"
  file.nameWithoutExtension → "file"
  file.extension     → "txt"
  file.parent        → parent directory path
  file.absolutePath  → full absolute path
  file.length()      → file size in bytes

  // Create directory
  File("mydir").mkdir()
  File("mydir/sub/deep").mkdirs()  // creates all parents too

  // List directory contents
  File("mydir").listFiles()?.forEach { println(it.name) }

  // Walk directory tree
  File("mydir").walk().forEach { println(it.path) }

─────────────────────────────────────
STANDARD INPUT: readLine():
─────────────────────────────────────
  val input = readLine()         // reads one line from stdin
  val number = readLine()?.toIntOrNull() ?: 0

  // Multiple inputs
  val (a, b) = readLine()!!.split(" ").map { it.toInt() }

─────────────────────────────────────
EXCEPTION HANDLING WITH FILES:
─────────────────────────────────────
  try {
      val content = File("missing.txt").readText()
  } catch (e: FileNotFoundException) {
      println("File not found: \${e.message}")
  } catch (e: IOException) {
      println("IO error: \${e.message}")
  }

  // Or idiomatic Kotlin:
  val content = runCatching { File("data.txt").readText() }
      .getOrElse { "Default content" }

💻 CODE:
import java.io.File
import java.io.IOException

fun demonstrateFileOps() {
    val fileName = "demo.txt"
    val file = File(fileName)

    // ─── WRITING ───────────────────────────────
    println("=== Writing ===")

    // Write a file (creates or overwrites)
    file.writeText("""
        Line 1: Hello from Kotlin!
        Line 2: File I/O is easy.
        Line 3: Kotlin extensions make it clean.
        Line 4: 42
        Line 5: Last line.
    """.trimIndent())
    println("Written to: \${file.absolutePath}")
    println("File size: \${file.length()} bytes")

    // Append
    file.appendText("\\nLine 6: Appended after the fact.")

    // ─── READING ───────────────────────────────
    println("\\n=== Reading ===")

    // Read entire file as string
    val fullContent = file.readText()
    println("--- Full content ---")
    println(fullContent)

    // Read as list of lines
    val lines = file.readLines()
    println("--- Line count: \${lines.size} ---")
    lines.forEachIndexed { i, line -> println("\${i + 1}: \$line") }

    // Memory-efficient streaming
    println("\\n--- Line streaming ---")
    var lineCount = 0
    file.forEachLine { line ->
        lineCount++
        if (line.contains("Kotlin")) println("Found Kotlin mention: \$line")
    }
    println("Total lines processed: \$lineCount")

    // ─── FILE PROPERTIES ───────────────────────
    println("\\n=== File properties ===")
    println("Name:      \${file.name}")
    println("Extension: \${file.extension}")
    println("No ext:    \${file.nameWithoutExtension}")
    println("Exists:    \${file.exists()}")
    println("Is file:   \${file.isFile}")
    println("Is dir:    \${file.isDirectory}")
    println("Size:      \${file.length()} bytes")

    // ─── BUFFERED READ/WRITE ────────────────────
    println("\\n=== Buffered Writer ===")
    val csvFile = File("data.csv")
    csvFile.bufferedWriter().use { writer ->
        writer.write("name,age,score")
        writer.newLine()
        writer.write("Terry,30,95")
        writer.newLine()
        writer.write("Sam,25,87")
        writer.newLine()
        writer.write("Bob,35,91")
    }
    println("CSV written")

    // Read CSV and parse
    val users = csvFile.readLines()
        .drop(1)   // skip header
        .map { line ->
            val (name, age, score) = line.split(",")
            Triple(name, age.toInt(), score.toInt())
        }
    println("Parsed users:")
    users.forEach { (name, age, score) ->
        println("  \$name (age \$age) — score: \$score")
    }

    // ─── DIRECTORIES ───────────────────────────
    println("\\n=== Directories ===")
    val dir = File("output_dir")
    dir.mkdirs()
    println("Directory created: \${dir.absolutePath}")

    // Write multiple files into directory
    listOf("alpha", "beta", "gamma").forEachIndexed { i, name ->
        File(dir, "\$name.txt").writeText("Content of \$name file (index \$i)")
    }

    // List directory
    dir.listFiles()?.sortedBy { it.name }?.forEach {
        println("  \${it.name} (\${it.length()} bytes)")
    }

    // ─── ERROR HANDLING ─────────────────────────
    println("\\n=== Error handling ===")
    val missingContent = runCatching {
        File("nonexistent_file.txt").readText()
    }.getOrElse { e ->
        "Default: file not found (\${e.javaClass.simpleName})"
    }
    println(missingContent)

    // Cleanup
    file.delete()
    csvFile.delete()
    dir.walkBottomUp().forEach { it.delete() }
    println("\\nCleanup done.")
}

fun main() {
    demonstrateFileOps()

    // Standard input example (commented — requires interactive terminal)
    // print("Enter your name: ")
    // val name = readLine() ?: "Guest"
    // println("Hello, \$name!")

    // print("Enter two numbers: ")
    // val (a, b) = readLine()!!.split(" ").map { it.toInt() }
    // println("Sum: \${a + b}")
}

📝 KEY POINTS:
✅ File("path").readText() reads entire file as String — one liner
✅ readLines() returns a List<String> of all lines
✅ forEachLine {} streams lines one at a time — memory efficient for large files
✅ use {} automatically closes streams — even if an exception is thrown
✅ appendText() adds to the end; writeText() overwrites
✅ mkdirs() creates the directory AND all missing parent directories
✅ runCatching wraps file operations cleanly for error handling
✅ readLine() reads one line from standard input
❌ readText() loads the whole file in memory — don't use for large files
❌ Always use use {} for streams — never manually forget to close()
❌ writeText() silently overwrites — check exists() if needed
❌ File paths are OS-dependent — use File.separator or Path for portability
""",
  quiz: [
    Quiz(question: 'What is the purpose of the use {} block when working with file streams in Kotlin?', options: [
      QuizOption(text: 'It automatically closes the stream when the block finishes, even if an exception occurs', correct: true),
      QuizOption(text: 'It locks the file so other processes cannot access it during the block', correct: false),
      QuizOption(text: 'It buffers all write operations and flushes them at once when the block ends', correct: false),
      QuizOption(text: 'It provides a coroutine scope for async file operations', correct: false),
    ]),
    Quiz(question: 'When would you use forEachLine {} instead of readLines()?', options: [
      QuizOption(text: 'For large files — forEachLine streams one line at a time without loading the whole file into memory', correct: true),
      QuizOption(text: 'When you need random access to any line by index', correct: false),
      QuizOption(text: 'forEachLine is faster than readLines() regardless of file size', correct: false),
      QuizOption(text: 'When the file contains binary data instead of text', correct: false),
    ]),
    Quiz(question: 'What is the difference between writeText() and appendText()?', options: [
      QuizOption(text: 'writeText() overwrites the file; appendText() adds to the end without removing existing content', correct: true),
      QuizOption(text: 'writeText() is asynchronous; appendText() is synchronous', correct: false),
      QuizOption(text: 'appendText() creates the file if it does not exist; writeText() throws if the file is missing', correct: false),
      QuizOption(text: 'They are identical — both append to the existing file content', correct: false),
    ]),
  ],
);

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson30 = Lesson(
  language: 'Java',
  title: 'NIO and the Modern Files API (java.nio)',
  content: """
🎯 METAPHOR:
java.nio is like the upgrade from a hand-drawn map to GPS.
The old java.io is a hand-drawn map — it works, you can
navigate with it, but finding your destination requires
work. java.nio.file is GPS: you tell it "take me from A
to B" and it handles routing, checking if paths exist,
creating directories along the way, and giving you
turn-by-turn directions. Files.readAllLines() is
"read the whole file" — one call. Files.write() is
"write this list to a file" — one call. The Path API
is type-safe directions instead of fragile string paths.
Modern Java code should use java.nio, not java.io.

📖 EXPLANATION:
java.nio (New I/O) was introduced in Java 1.4 and
dramatically improved in Java 7 with the NIO.2 / Files API.
For most file operations, java.nio is now the preferred choice.

─────────────────────────────────────
KEY CLASSES IN java.nio.file:
─────────────────────────────────────
  Path            → represents a file path (like a type-safe String)
  Paths           → factory for Path objects (use Path.of() in Java 11+)
  Files           → static utility methods for file operations
  FileSystem      → access to file systems
  WatchService    → watch directories for changes

─────────────────────────────────────
Path — type-safe file paths:
─────────────────────────────────────
  Path p = Path.of("data", "users", "config.json");
  // → "data/users/config.json"  (platform-appropriate separator)

  Path absolute = Path.of("/home/user/docs/file.txt");
  Path relative = Path.of("reports/2024/q4.csv");

  p.getFileName()     → "config.json" (last component)
  p.getParent()       → "data/users"
  p.getRoot()         → "/" (on Unix) or "C:\\" (Windows)
  p.isAbsolute()      → false for relative paths
  p.toAbsolutePath()  → prepends current working directory
  p.normalize()       → resolve . and .. components
  p.resolve("sub")    → appends: "data/users/sub"
  p.relativize(other) → compute relative path between two paths
  p.startsWith("data") → true

─────────────────────────────────────
Files — static utility methods:
─────────────────────────────────────
  READING:
  Files.readAllLines(path)          → List<String>
  Files.readAllLines(path, charset) → with specific encoding
  Files.readString(path)            → entire file as String (Java 11)
  Files.lines(path)                 → Stream<String> (lazy!)
  Files.readAllBytes(path)          → byte[]
  Files.newBufferedReader(path)     → BufferedReader

  WRITING:
  Files.write(path, lines)                    → write List<String>
  Files.write(path, bytes)                    → write bytes
  Files.writeString(path, content)            → write String (Java 11)
  Files.write(path, lines, APPEND)            → append
  Files.newBufferedWriter(path)               → BufferedWriter
  Files.newOutputStream(path, options)        → OutputStream

  COPY/MOVE/DELETE:
  Files.copy(src, dst)              → copy file
  Files.copy(src, dst, REPLACE_EXISTING) → overwrite if exists
  Files.move(src, dst)              → move/rename
  Files.delete(path)                → delete (throws if missing)
  Files.deleteIfExists(path)        → delete if exists

  DIRECTORY OPERATIONS:
  Files.createDirectory(path)       → create one directory
  Files.createDirectories(path)     → create path + parents
  Files.list(dir)                   → Stream<Path> of contents
  Files.walk(dir)                   → Stream<Path> recursive
  Files.find(dir, depth, matcher)   → search with BiPredicate

  CHECKING:
  Files.exists(path)                → path exists?
  Files.notExists(path)             → doesn't exist?
  Files.isDirectory(path)           → is it a folder?
  Files.isRegularFile(path)         → is it a file?
  Files.isReadable(path)            → can we read it?
  Files.size(path)                  → file size in bytes
  Files.getLastModifiedTime(path)   → last modified
  Files.getAttribute(path, name)    → specific attribute

─────────────────────────────────────
StandardOpenOption:
─────────────────────────────────────
  CREATE                → create if doesn't exist
  CREATE_NEW            → create, fail if exists
  APPEND                → write to end
  TRUNCATE_EXISTING     → clear file before writing
  WRITE, READ           → access modes

─────────────────────────────────────
WALK AND SEARCH:
─────────────────────────────────────
  Files.walk(dir)                   // all files recursively
      .filter(Files::isRegularFile)
      .filter(p -> p.toString().endsWith(".java"))
      .forEach(System.out::println);

  Files.find(dir, Integer.MAX_VALUE,
      (path, attrs) -> attrs.isRegularFile() && attrs.size() > 1024)
      .forEach(System.out::println);

💻 CODE:
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.nio.file.attribute.*;
import java.util.*;
import java.util.stream.*;

public class NIOFiles {
    static final Path BASE = Path.of("nio_demo");

    public static void main(String[] args) throws IOException {
        try {
            setup();
            demoPaths();
            demoReadWrite();
            demoDirectories();
            demoWalkAndSearch();
            demoCopyMove();
        } finally {
            cleanup();
        }
    }

    static void setup() throws IOException {
        Files.createDirectories(BASE.resolve("subdir"));
        Files.createDirectories(BASE.resolve("src/main/java"));
        Files.createDirectories(BASE.resolve("src/test/java"));
    }

    // ─── PATH API ─────────────────────────────────────
    static void demoPaths() {
        System.out.println("=== Path API ===");

        Path p = Path.of("projects", "myapp", "src", "Main.java");
        System.out.println("  Path:       " + p);
        System.out.println("  FileName:   " + p.getFileName());
        System.out.println("  Parent:     " + p.getParent());
        System.out.println("  IsAbsolute: " + p.isAbsolute());
        System.out.println("  Absolute:   " + p.toAbsolutePath());

        Path base  = Path.of("/home/user");
        Path file  = Path.of("/home/user/docs/report.pdf");
        Path relative = base.relativize(file);
        System.out.println("  Relative:   " + relative);

        Path combined = base.resolve("config").resolve("settings.json");
        System.out.println("  Resolved:   " + combined);

        Path withDots = Path.of("/home/user/../user/./docs");
        System.out.println("  Normalized: " + withDots.normalize());
    }

    // ─── READ AND WRITE ───────────────────────────────
    static void demoReadWrite() throws IOException {
        System.out.println("\n=== File Read & Write ===");

        Path textFile = BASE.resolve("sample.txt");

        // Write a String (Java 11+)
        Files.writeString(textFile,
            "Line 1: Hello from NIO!\nLine 2: Much cleaner than java.io\n" +
            "Line 3: Files API is great\nLine 4: Path is type-safe\n" +
            "Line 5: Streams integration\n");
        System.out.println("  Written: " + textFile.getFileName());

        // Read all lines as List
        List<String> lines = Files.readAllLines(textFile);
        System.out.println("  Lines count: " + lines.size());
        lines.forEach(l -> System.out.println("    " + l));

        // Read as Stream (lazy — good for large files)
        System.out.println("\n  Stream-based read (filtered):");
        try (Stream<String> stream = Files.lines(textFile)) {
            stream.filter(l -> l.contains("great") || l.contains("clean"))
                  .map(l -> "  → " + l)
                  .forEach(System.out::println);
        }

        // Append with StandardOpenOption
        Files.writeString(textFile,
            "Line 6: Appended with APPEND option\n",
            StandardOpenOption.APPEND);
        System.out.println("  After append: " +
            Files.readAllLines(textFile).size() + " lines");

        // Write a list of strings
        Path csvFile = BASE.resolve("data.csv");
        List<String> rows = Arrays.asList(
            "name,score,grade",
            "Alice,95,A",
            "Bob,82,B",
            "Charlie,71,C"
        );
        Files.write(csvFile, rows, StandardCharsets.UTF_8,
            StandardOpenOption.CREATE);
        System.out.println("\n  CSV written:");
        Files.readAllLines(csvFile).forEach(r -> System.out.println("    " + r));

        // File info
        System.out.println("\n  File info:");
        System.out.println("    size:     " + Files.size(textFile) + " bytes");
        System.out.println("    exists:   " + Files.exists(textFile));
        System.out.println("    readable: " + Files.isReadable(textFile));
        System.out.println("    modified: " + Files.getLastModifiedTime(textFile));
    }

    // ─── DIRECTORY OPERATIONS ─────────────────────────
    static void demoDirectories() throws IOException {
        System.out.println("\n=== Directory Operations ===");

        // Create nested dirs in one call
        Path deepDir = BASE.resolve("level1/level2/level3");
        Files.createDirectories(deepDir);
        System.out.println("  Created: " + deepDir);

        // Create some files
        for (int i = 1; i <= 3; i++) {
            Files.writeString(BASE.resolve("subdir/file" + i + ".txt"),
                "Content of file " + i);
            Files.writeString(BASE.resolve("src/main/java/Class" + i + ".java"),
                "public class Class" + i + " {}");
        }

        // List directory contents (non-recursive)
        System.out.println("\n  Contents of " + BASE + ":");
        try (Stream<Path> entries = Files.list(BASE)) {
            entries.sorted()
                   .forEach(p -> {
                       String type = Files.isDirectory(p) ? "DIR " : "FILE";
                       System.out.printf("    [%s] %s%n", type, p.getFileName());
                   });
        }
    }

    // ─── WALK AND SEARCH ──────────────────────────────
    static void demoWalkAndSearch() throws IOException {
        System.out.println("\n=== Walk & Search ===");

        // Walk all files recursively
        System.out.println("  All files in " + BASE + ":");
        try (Stream<Path> walk = Files.walk(BASE)) {
            walk.filter(Files::isRegularFile)
                .sorted()
                .forEach(p -> System.out.println("    " + BASE.relativize(p)));
        }

        // Find .java files
        System.out.println("\n  Java files:");
        try (Stream<Path> walk = Files.walk(BASE)) {
            walk.filter(Files::isRegularFile)
                .filter(p -> p.toString().endsWith(".java"))
                .forEach(p -> System.out.println("    " + p.getFileName()));
        }

        // Find using Files.find with attributes
        System.out.println("\n  Files.find (regular files >0 bytes):");
        try (Stream<Path> found = Files.find(BASE, Integer.MAX_VALUE,
                (p, attrs) -> attrs.isRegularFile() && attrs.size() > 0)) {
            found.sorted()
                 .forEach(p -> System.out.printf("    %-30s %d bytes%n",
                     BASE.relativize(p), p.toFile().length()));
        }
    }

    // ─── COPY AND MOVE ────────────────────────────────
    static void demoCopyMove() throws IOException {
        System.out.println("\n=== Copy & Move ===");

        Path src = BASE.resolve("sample.txt");
        Path dst = BASE.resolve("sample_backup.txt");

        // Copy
        Files.copy(src, dst, StandardCopyOption.REPLACE_EXISTING);
        System.out.println("  Copied: " + src.getFileName() + " → " + dst.getFileName());
        System.out.println("  Backup size: " + Files.size(dst) + " bytes");

        // Move/rename
        Path moved = BASE.resolve("sample_moved.txt");
        Files.move(dst, moved, StandardCopyOption.REPLACE_EXISTING);
        System.out.println("  Moved:  " + dst.getFileName() + " → " + moved.getFileName());
        System.out.println("  Original exists: " + Files.exists(dst));
        System.out.println("  Moved exists:    " + Files.exists(moved));

        // Delete
        Files.deleteIfExists(moved);
        System.out.println("  Deleted: " + moved.getFileName());
    }

    static void cleanup() throws IOException {
        if (Files.exists(BASE)) {
            try (Stream<Path> walk = Files.walk(BASE)) {
                walk.sorted(Comparator.reverseOrder())
                    .forEach(p -> { try { Files.delete(p); } catch (IOException e) {} });
            }
            System.out.println("\n  (cleanup: demo directory removed)");
        }
    }
}

📝 KEY POINTS:
✅ Path is type-safe and platform-independent — prefer over String for paths
✅ Path.of() (Java 11+) or Paths.get() creates Path objects
✅ Files.readString() and Files.writeString() are one-liners for text I/O (Java 11)
✅ Files.lines() returns a lazy Stream<String> — great for large files
✅ Files.createDirectories() creates the full path including all parents
✅ Files.walk() recursively traverses a directory tree
✅ StandardOpenOption.APPEND appends; TRUNCATE_EXISTING overwrites
✅ Files.deleteIfExists() is safer than delete() — no exception if missing
✅ Path.relativize() and Path.resolve() compute relative and absolute paths
❌ Always close Files.lines() stream — it holds a file handle; use try-with-resources
❌ Files.readAllLines() loads everything into memory — don't use for huge files
❌ Files.list() is NOT recursive — use Files.walk() for directory tree traversal
❌ Don't concatenate paths with + — use path.resolve("sub") instead
""",
  quiz: [
    Quiz(question: 'What is the advantage of Files.lines(path) over Files.readAllLines(path)?', options: [
      QuizOption(text: 'lines() returns a lazy Stream — it reads on demand without loading the whole file into memory', correct: true),
      QuizOption(text: 'lines() is faster because it uses parallel processing automatically', correct: false),
      QuizOption(text: 'readAllLines() requires an explicit charset; lines() detects encoding automatically', correct: false),
      QuizOption(text: 'They are identical — lines() is just a stream wrapper around readAllLines()', correct: false),
    ]),
    Quiz(question: 'What does Path.resolve("subdir") do?', options: [
      QuizOption(text: 'Appends "subdir" to the current path to create a new child path', correct: true),
      QuizOption(text: 'Converts the path to an absolute path by looking up "subdir" in the filesystem', correct: false),
      QuizOption(text: 'Normalizes the path by resolving any ".." or "." components named "subdir"', correct: false),
      QuizOption(text: 'Checks if "subdir" exists and returns the path only if it does', correct: false),
    ]),
    Quiz(question: 'Which method creates all missing parent directories along with the target directory?', options: [
      QuizOption(text: 'Files.createDirectories(path) — creates the full path including all parents', correct: true),
      QuizOption(text: 'Files.createDirectory(path) — creates the entire path recursively', correct: false),
      QuizOption(text: 'Files.mkdirs(path) — Java NIO equivalent of File.mkdirs()', correct: false),
      QuizOption(text: 'Path.resolve(path).create() — creates the resolved path and its parents', correct: false),
    ]),
  ],
);

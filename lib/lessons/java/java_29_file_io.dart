import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson29 = Lesson(
  language: 'Java',
  title: 'File I/O with java.io',
  content: """
🎯 METAPHOR:
Java I/O streams are like water pipes in a building.
The SOURCE is where the water comes from (a file, network,
keyboard). The SINK is where it goes (a file, screen,
network). FILTERS are devices that wrap the pipe and
transform the water as it passes through — a water softener
(BufferedReader softens the raw bytes into convenient lines),
a purifier (InputStreamReader converts bytes to characters).
You chain filters: RawWaterSource → Softener → Purifier → Tap.
Each filter adds a capability. This is Java's DECORATOR
pattern applied to I/O — the same pattern that makes
java.io so flexible and composable.

📖 EXPLANATION:
Java has two I/O stream hierarchies:
→ Byte streams: InputStream/OutputStream (raw bytes)
→ Character streams: Reader/Writer (text, encoded chars)

─────────────────────────────────────
BYTE STREAM HIERARCHY:
─────────────────────────────────────
  InputStream
  ├── FileInputStream         → read bytes from file
  ├── ByteArrayInputStream    → read from byte array
  ├── FilterInputStream
  │   └── BufferedInputStream → buffered byte reading
  └── ObjectInputStream       → deserialize objects

  OutputStream
  ├── FileOutputStream        → write bytes to file
  ├── ByteArrayOutputStream   → write to byte array
  ├── FilterOutputStream
  │   └── BufferedOutputStream → buffered byte writing
  └── ObjectOutputStream      → serialize objects

─────────────────────────────────────
CHARACTER STREAM HIERARCHY:
─────────────────────────────────────
  Reader
  ├── FileReader              → read chars from file
  ├── StringReader            → read from String
  ├── InputStreamReader       → bytes → chars (bridge)
  └── BufferedReader          → line-based reading (wraps Reader)

  Writer
  ├── FileWriter              → write chars to file
  ├── StringWriter            → write to String buffer
  ├── OutputStreamWriter      → chars → bytes (bridge)
  ├── BufferedWriter          → buffered char writing
  └── PrintWriter             → formatted output (printf)

─────────────────────────────────────
THE BUFFERING PATTERN:
─────────────────────────────────────
  Without buffering: every read/write = OS call (slow!)
  With buffering: reads/writes in chunks (fast!)

  // Unbuffered — 1 OS call per character:
  FileReader fr = new FileReader("file.txt");
  int c;
  while ((c = fr.read()) != -1) { ... }

  // Buffered — reads chunk at a time, serves from buffer:
  BufferedReader br = new BufferedReader(new FileReader("file.txt"));
  String line;
  while ((line = br.readLine()) != null) { ... }

  Always wrap with Buffered* for real I/O.

─────────────────────────────────────
ALWAYS CLOSE RESOURCES:
─────────────────────────────────────
  // ❌ Old way — risk of resource leak:
  FileReader fr = new FileReader("file.txt");
  // ... if exception here, fr never closes!
  fr.close();

  // ✅ try-with-resources — auto-closes:
  try (BufferedReader br = new BufferedReader(new FileReader("file.txt"))) {
      String line;
      while ((line = br.readLine()) != null) {
          System.out.println(line);
      }
  }  // br.close() called automatically

─────────────────────────────────────
OBJECT SERIALIZATION:
─────────────────────────────────────
  class User implements Serializable {
      private String name;
      private int age;
      // transient fields are NOT serialized:
      private transient String password;
  }

  // Serialize (save to file):
  try (ObjectOutputStream oos = new ObjectOutputStream(
          new FileOutputStream("users.dat"))) {
      oos.writeObject(user);
  }

  // Deserialize (load from file):
  try (ObjectInputStream ois = new ObjectInputStream(
          new FileInputStream("users.dat"))) {
      User user = (User) ois.readObject();
  }

─────────────────────────────────────
WHEN TO USE java.io vs java.nio:
─────────────────────────────────────
  java.io    → Simple sequential file reads/writes
               Compatibility with older code
               Serialization

  java.nio   → Better performance for large files
               Non-blocking I/O
               Modern utility methods (Files, Paths)

  For most NEW code → prefer java.nio (next lesson).
  java.io is still useful and widely seen in existing code.

💻 CODE:
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.*;

// Serializable class
class Config implements Serializable {
    private static final long serialVersionUID = 1L;

    private String host;
    private int port;
    private boolean debug;
    private transient String secretKey;  // NOT serialized

    public Config(String host, int port, boolean debug, String secretKey) {
        this.host      = host;
        this.port      = port;
        this.debug     = debug;
        this.secretKey = secretKey;
    }

    @Override
    public String toString() {
        return String.format("Config{host='%s', port=%d, debug=%b, secret=%s}",
            host, port, debug, secretKey == null ? "(not loaded)" : "****");
    }
}

public class FileIO {
    static final String TEST_FILE = "test_java_io.txt";
    static final String CSV_FILE  = "test_data.csv";
    static final String OBJ_FILE  = "test_config.dat";

    public static void main(String[] args) {
        try {
            demoTextWriteRead();
            demoCSVProcessing();
            demoSerialization();
            demoStringIO();
        } finally {
            // Cleanup
            new File(TEST_FILE).delete();
            new File(CSV_FILE).delete();
            new File(OBJ_FILE).delete();
        }
    }

    // ─── TEXT FILE READ/WRITE ─────────────────────────
    static void demoTextWriteRead() throws IOException {
        System.out.println("=== Text File I/O ===");

        // WRITE with PrintWriter (easiest for text)
        try (PrintWriter pw = new PrintWriter(
                new BufferedWriter(new FileWriter(TEST_FILE)))) {

            pw.println("Line 1: Hello from Java!");
            pw.println("Line 2: File I/O with java.io");
            pw.printf("Line 3: Pi = %.5f%n", Math.PI);
            pw.println("Line 4: Writing text files");
            pw.println("Line 5: BufferedWriter is fast");
        }
        System.out.println("  Written: " + TEST_FILE);

        // READ with BufferedReader (line by line)
        System.out.println("  Reading line by line:");
        try (BufferedReader br = new BufferedReader(new FileReader(TEST_FILE))) {
            String line;
            int lineNum = 1;
            while ((line = br.readLine()) != null) {
                System.out.println("    " + lineNum++ + ": " + line);
            }
        }

        // APPEND to existing file
        try (PrintWriter pw = new PrintWriter(
                new BufferedWriter(new FileWriter(TEST_FILE, true)))) {  // true = append
            pw.println("Line 6: Appended later");
        }

        // Count lines after append
        try (BufferedReader br = new BufferedReader(new FileReader(TEST_FILE))) {
            long lines = br.lines().count();
            System.out.println("  Total lines after append: " + lines);
        }
    }

    // ─── CSV PROCESSING ───────────────────────────────
    static void demoCSVProcessing() throws IOException {
        System.out.println("\n=== CSV Processing ===");

        // Write CSV
        try (PrintWriter pw = new PrintWriter(new FileWriter(CSV_FILE))) {
            pw.println("name,age,score,city");
            pw.println("Alice,28,92.5,London");
            pw.println("Bob,34,87.0,Paris");
            pw.println("Charlie,22,95.5,London");
            pw.println("Diana,31,78.5,Berlin");
        }

        // Read and parse CSV
        List<Map<String, String>> records = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(CSV_FILE))) {
            String header = br.readLine();
            String[] cols = header.split(",");

            String line;
            while ((line = br.readLine()) != null) {
                String[] vals = line.split(",");
                Map<String, String> record = new LinkedHashMap<>();
                for (int i = 0; i < cols.length; i++) {
                    record.put(cols[i], vals[i]);
                }
                records.add(record);
            }
        }

        System.out.println("  Parsed " + records.size() + " records:");
        records.forEach(r -> {
            System.out.printf("    %-10s age=%-3s score=%-6s city=%s%n",
                r.get("name"), r.get("age"), r.get("score"), r.get("city"));
        });

        // Stats
        double avgScore = records.stream()
            .mapToDouble(r -> Double.parseDouble(r.get("score")))
            .average().orElse(0);
        System.out.printf("  Average score: %.2f%n", avgScore);
    }

    // ─── OBJECT SERIALIZATION ─────────────────────────
    static void demoSerialization() throws IOException, ClassNotFoundException {
        System.out.println("\n=== Object Serialization ===");

        Config original = new Config("api.example.com", 8080, true, "super_secret_key");
        System.out.println("  Original: " + original);

        // Serialize
        try (ObjectOutputStream oos = new ObjectOutputStream(
                new BufferedOutputStream(new FileOutputStream(OBJ_FILE)))) {
            oos.writeObject(original);
            System.out.println("  Serialized to: " + OBJ_FILE);
        }

        // Deserialize
        try (ObjectInputStream ois = new ObjectInputStream(
                new BufferedInputStream(new FileInputStream(OBJ_FILE)))) {
            Config loaded = (Config) ois.readObject();
            System.out.println("  Deserialized: " + loaded);
            System.out.println("  (Note: 'secret' field is null — transient!)");
        }
    }

    // ─── STRING I/O (in-memory streams) ───────────────
    static void demoStringIO() throws IOException {
        System.out.println("\n=== StringWriter / StringReader ===");

        // Write to a String instead of a file
        StringWriter sw = new StringWriter();
        try (PrintWriter pw = new PrintWriter(sw)) {
            pw.println("Report Title");
            pw.println("=".repeat(30));
            for (int i = 1; i <= 5; i++) {
                pw.printf("Item %d: value = %d%n", i, i * i);
            }
        }
        String report = sw.toString();
        System.out.println("  Generated report:");
        System.out.println(report);

        // Read from a String using StringReader
        System.out.println("  Line count: ");
        try (BufferedReader br = new BufferedReader(new StringReader(report))) {
            long count = br.lines().count();
            System.out.println("  " + count + " lines in the report");
        }

        // ByteArrayOutputStream — capture output as bytes
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        try (PrintStream ps = new PrintStream(baos, true, StandardCharsets.UTF_8)) {
            ps.printf("Captured output: %s%n", new Date());
        }
        String captured = baos.toString(StandardCharsets.UTF_8);
        System.out.println("  Captured: " + captured.trim());
    }
}

📝 KEY POINTS:
✅ Always use try-with-resources — ensures streams are closed even on exception
✅ Wrap FileReader/FileWriter in BufferedReader/BufferedWriter for performance
✅ PrintWriter makes it easy to write formatted text with println() and printf()
✅ BufferedReader.readLine() returns null at end of file — use as loop condition
✅ Append to a file with new FileWriter(path, true) — second arg true = append
✅ transient fields are skipped during serialization
✅ serialVersionUID prevents InvalidClassException on class version changes
✅ StringWriter/StringReader enable in-memory I/O for testing
❌ Never forget to close streams — use try-with-resources always
❌ Don't read large files entirely into memory — stream line by line
❌ Serialization is fragile — prefer JSON/XML for data exchange
❌ Don't use FileReader/FileWriter without specifying charset — use InputStreamReader(fis, StandardCharsets.UTF_8)
""",
  quiz: [
    Quiz(question: 'Why should you wrap FileReader in a BufferedReader?', options: [
      QuizOption(text: 'BufferedReader reads data in chunks, reducing OS calls and providing the readLine() method', correct: true),
      QuizOption(text: 'FileReader cannot read text files alone — it only reads bytes', correct: false),
      QuizOption(text: 'BufferedReader adds error handling that FileReader lacks', correct: false),
      QuizOption(text: 'The JVM requires BufferedReader to properly close FileReader resources', correct: false),
    ]),
    Quiz(question: 'What does the transient keyword do on a class field?', options: [
      QuizOption(text: 'Marks the field to be excluded from serialization — it is not saved', correct: true),
      QuizOption(text: 'Makes the field thread-local — each thread has its own copy', correct: false),
      QuizOption(text: 'Makes the field temporary — it is garbage collected after the method returns', correct: false),
      QuizOption(text: 'Prevents the field from being accessed outside the class', correct: false),
    ]),
    Quiz(question: 'How do you append to an existing file with FileWriter?', options: [
      QuizOption(text: 'Pass true as the second argument: new FileWriter(path, true)', correct: true),
      QuizOption(text: 'Use FileWriter.appendMode() before writing', correct: false),
      QuizOption(text: 'Use AppendWriter instead of FileWriter', correct: false),
      QuizOption(text: 'Seek to the end of the file with writer.seek(Long.MAX_VALUE)', correct: false),
    ]),
  ],
);

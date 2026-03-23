import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson58 = Lesson(
  language: 'Java',
  title: 'Properties Files and System Properties',
  content: """
🎯 METAPHOR:
Properties files are like sticky notes on the outside of
a machine. The machine (your app) works the same regardless
of the notes, but the notes configure how it behaves:
"connect to THIS database," "use THAT API key," "run in
DEBUG mode." Changing a note changes the behavior without
opening the machine. System properties are the notes the
JVM puts on itself when it starts — the operating system,
the Java version, the home directory. You can read them,
and you can add your own when launching: -Dmyapp.env=prod.

📖 EXPLANATION:
java.util.Properties is a key=value text format widely
used for application configuration in Java.

─────────────────────────────────────
Properties FILE FORMAT:
─────────────────────────────────────
  # This is a comment
  ! This is also a comment

  db.host = localhost
  db.port = 5432
  db.name = myapp
  db.user = admin
  db.password = secret123

  app.name = CodeBro
  app.version = 2.0.0
  debug = false

  # Multi-line value (backslash continuation):
  message = Hello, \\
             this is a \\
             multi-line value

  # Unicode:
  greeting = \\u3053\\u3093\\u306B\\u3061\\u306F   (= こんにちは)

─────────────────────────────────────
LOADING PROPERTIES:
─────────────────────────────────────
  Properties props = new Properties();

  // From file:
  try (InputStream is = new FileInputStream("config.properties")) {
      props.load(is);
  }

  // From classpath:
  try (InputStream is = MyClass.class.getResourceAsStream("/config.properties")) {
      props.load(is);
  }

  // From XML:
  props.loadFromXML(inputStream);

  // Inline defaults:
  Properties defaults = new Properties();
  defaults.setProperty("timeout", "30");
  Properties props = new Properties(defaults);

─────────────────────────────────────
READING PROPERTIES:
─────────────────────────────────────
  props.getProperty("db.host")            → "localhost"
  props.getProperty("missing")            → null
  props.getProperty("missing", "default") → "default"
  props.stringPropertyNames()             → Set<String>
  props.size()                            → count
  props.isEmpty()                         → empty?
  props.containsKey("db.host")           → true/false

─────────────────────────────────────
WRITING PROPERTIES:
─────────────────────────────────────
  props.setProperty("new.key", "value");
  props.remove("old.key");

  // Save to file:
  try (OutputStream os = new FileOutputStream("output.properties")) {
      props.store(os, "App configuration");
  }

  // Save as XML:
  props.storeToXML(os, "comment");

─────────────────────────────────────
SYSTEM PROPERTIES:
─────────────────────────────────────
  System.getProperty("java.version")      → "21.0.1"
  System.getProperty("java.vendor")       → "Eclipse Adoptium"
  System.getProperty("os.name")           → "Mac OS X"
  System.getProperty("os.arch")           → "aarch64"
  System.getProperty("user.home")         → "/home/terry"
  System.getProperty("user.name")         → "terry"
  System.getProperty("java.home")         → JVM home path
  System.getProperty("file.separator")    → "/" or "\\"
  System.getProperty("path.separator")    → ":" or ";"
  System.getProperty("line.separator")    → "\\n" or "\\r\\n"
  System.getProperty("java.class.path")   → classpath

  // Set a system property:
  System.setProperty("myapp.env", "prod");

  // Via JVM flags at launch:
  java -Dmyapp.env=prod -Ddebug=true MyApp

  // Get all system properties:
  System.getProperties().list(System.out);

─────────────────────────────────────
ENVIRONMENT VARIABLES vs PROPERTIES:
─────────────────────────────────────
  System.getenv("HOME")         → /home/terry (env var)
  System.getenv("PATH")         → shell PATH
  System.getenv()               → Map<String, String> of all

  Env vars:    set by the OS/shell, read-only in Java
  Sys props:   set via -D or System.setProperty(), mutable
  .properties: text files, loaded by your code

  Precedence (typical):
  env vars → sys props → properties files → defaults

─────────────────────────────────────
BEST PRACTICES:
─────────────────────────────────────
  ✅ Store config in .properties files, not code
  ✅ Never commit passwords to version control
  ✅ Use env vars or secrets managers for sensitive values
  ✅ Provide default values for all optional properties
  ✅ Validate required properties at startup

💻 CODE:
import java.io.*;
import java.nio.file.*;
import java.util.*;

public class PropertiesDemo {
    public static void main(String[] args) throws IOException {

        // ─── CREATE AND WRITE PROPERTIES ─────────────────
        System.out.println("=== Creating Properties ===");
        Properties config = new Properties();
        config.setProperty("db.host",     "localhost");
        config.setProperty("db.port",     "5432");
        config.setProperty("db.name",     "codebro");
        config.setProperty("app.name",    "CodeBro");
        config.setProperty("app.version", "2.0.0");
        config.setProperty("debug",       "false");
        config.setProperty("max.threads", "10");

        // Save to file
        Path propFile = Files.createTempFile("app", ".properties");
        try (OutputStream os = new FileOutputStream(propFile.toFile())) {
            config.store(os, "CodeBro Application Configuration");
        }
        System.out.println("  Saved: " + propFile);
        System.out.println("  Content:");
        Files.readAllLines(propFile).forEach(l -> System.out.println("    " + l));

        // ─── LOAD AND READ ────────────────────────────────
        System.out.println("\n=== Loading Properties ===");
        Properties loaded = new Properties();
        try (InputStream is = new FileInputStream(propFile.toFile())) {
            loaded.load(is);
        }

        System.out.println("  All keys: " + new TreeSet<>(loaded.stringPropertyNames()));
        System.out.println("  db.host:  " + loaded.getProperty("db.host"));
        System.out.println("  db.port:  " + loaded.getProperty("db.port"));
        System.out.println("  missing:  " + loaded.getProperty("nonexistent", "default-value"));

        // ─── PROPERTIES WITH DEFAULTS ─────────────────────
        System.out.println("\n=== Properties with Defaults ===");
        Properties defaults = new Properties();
        defaults.setProperty("timeout",    "30");
        defaults.setProperty("max.retries","3");
        defaults.setProperty("log.level",  "INFO");

        Properties app = new Properties(defaults);
        app.load(new FileInputStream(propFile.toFile()));
        app.setProperty("log.level", "DEBUG");   // override default

        System.out.println("  timeout (default):  " + app.getProperty("timeout"));
        System.out.println("  log.level (override):" + app.getProperty("log.level"));
        System.out.println("  max.retries (default):" + app.getProperty("max.retries"));

        // ─── TYPED PROPERTY ACCESS ────────────────────────
        System.out.println("\n=== Typed Access ===");
        int port    = Integer.parseInt(loaded.getProperty("db.port", "5432"));
        boolean dbg = Boolean.parseBoolean(loaded.getProperty("debug", "false"));
        int threads = Integer.parseInt(loaded.getProperty("max.threads", "4"));
        System.out.printf("  port=%d  debug=%b  threads=%d%n", port, dbg, threads);

        // ─── SYSTEM PROPERTIES ────────────────────────────
        System.out.println("\n=== System Properties ===");
        String[] sysprops = {
            "java.version", "java.vendor", "os.name",
            "os.arch", "user.name", "user.home",
            "file.separator", "path.separator", "line.separator"
        };
        for (String key : sysprops) {
            String val = System.getProperty(key);
            if (val != null) {
                // Escape line.separator for display
                val = val.replace("\n", "\\n").replace("\r", "\\r");
                System.out.printf("  %-20s = %s%n", key, val);
            }
        }

        // Setting a system property
        System.setProperty("myapp.env", "development");
        System.out.println("\n  Custom sys prop: " +
            System.getProperty("myapp.env"));

        // ─── ENVIRONMENT VARIABLES ────────────────────────
        System.out.println("\n=== Environment Variables ===");
        Map<String, String> env = System.getenv();
        String[] interestingEnv = {"HOME", "USER", "PATH", "JAVA_HOME"};
        for (String key : interestingEnv) {
            String val = env.get(key);
            if (val != null) {
                System.out.printf("  %-12s = %s%n", key,
                    val.length() > 50 ? val.substring(0, 50) + "..." : val);
            }
        }
        System.out.println("  Total env vars: " + env.size());

        // ─── CONFIG SERVICE PATTERN ───────────────────────
        System.out.println("\n=== Config Service Pattern ===");
        Properties finalConfig = loaded;

        // Helper class (inner for demo)
        class Config {
            private final Properties p;
            Config(Properties p) { this.p = p; }

            String require(String key) {
                String val = p.getProperty(key);
                if (val == null) throw new IllegalStateException("Required: " + key);
                return val;
            }
            String get(String key, String def) { return p.getProperty(key, def); }
            int    getInt(String key, int def) {
                try { return Integer.parseInt(p.getProperty(key, String.valueOf(def))); }
                catch (NumberFormatException e) { return def; }
            }
            boolean getBool(String key, boolean def) {
                return Boolean.parseBoolean(p.getProperty(key, String.valueOf(def)));
            }
        }

        Config cfg = new Config(finalConfig);
        System.out.println("  DB: " + cfg.require("db.host") + ":" + cfg.getInt("db.port", 5432));
        System.out.println("  App: " + cfg.require("app.name") + " v" + cfg.require("app.version"));
        System.out.println("  Debug: " + cfg.getBool("debug", false));

        // ─── XML PROPERTIES ───────────────────────────────
        System.out.println("\n=== XML Properties ===");
        Path xmlFile = Files.createTempFile("config", ".xml");
        try (OutputStream os = new FileOutputStream(xmlFile.toFile())) {
            config.storeToXML(os, "App Config in XML");
        }
        System.out.println("  XML format (first 3 lines):");
        Files.readAllLines(xmlFile).stream().limit(3)
            .forEach(l -> System.out.println("    " + l));

        // Cleanup
        Files.deleteIfExists(propFile);
        Files.deleteIfExists(xmlFile);
    }
}

📝 KEY POINTS:
✅ Properties files use key=value format; # and ! start comments
✅ Properties.load() reads .properties files; loadFromXML() reads XML format
✅ getProperty(key, defaultValue) safely returns a default if key is missing
✅ System.getProperty() reads JVM properties; System.getenv() reads OS env vars
✅ Use -Dkey=value JVM flag to pass system properties at launch
✅ Provide defaults via new Properties(defaults) so fallbacks work automatically
✅ Always parse typed values explicitly: Integer.parseInt(props.getProperty("port"))
✅ Store sensitive config in env vars or secrets managers — not in .properties files
❌ Never commit passwords or API keys in properties files to version control
❌ Don't call props.get() (returns Object) — use getProperty() (returns String)
❌ Properties extends Hashtable but treat it as a key-value config — don't use put()
❌ System.setProperty() affects the entire JVM — use sparingly in tests
""",
  quiz: [
    Quiz(question: 'What does props.getProperty("key", "default") return when the key is not present?', options: [
      QuizOption(text: '"default" — the second argument is the fallback value when the key is missing', correct: true),
      QuizOption(text: 'null — the default parameter is only used when the file cannot be loaded', correct: false),
      QuizOption(text: 'An empty string — Properties always returns "" for missing keys', correct: false),
      QuizOption(text: 'It throws MissingPropertyException when the key is absent', correct: false),
    ]),
    Quiz(question: 'How do you pass a system property to a Java application at launch?', options: [
      QuizOption(text: 'Use the -D flag: java -Dmyapp.env=prod MyApp', correct: true),
      QuizOption(text: 'Use the -P flag: java -Pmyapp.env=prod MyApp', correct: false),
      QuizOption(text: 'Set it in the JAVA_OPTS environment variable before running', correct: false),
      QuizOption(text: 'Write it to a system.properties file in the working directory', correct: false),
    ]),
    Quiz(question: 'What is the difference between System.getProperty() and System.getenv()?', options: [
      QuizOption(text: 'getProperty() reads JVM system properties set with -D; getenv() reads OS environment variables', correct: true),
      QuizOption(text: 'getenv() reads from .properties files; getProperty() reads OS variables', correct: false),
      QuizOption(text: 'They are identical — both read key-value pairs from the environment', correct: false),
      QuizOption(text: 'getProperty() is thread-safe; getenv() is not', correct: false),
    ]),
  ],
);

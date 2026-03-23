import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson56 = Lesson(
  language: 'Java',
  title: 'JAR Files, Classpath, and Deployment',
  content: """
🎯 METAPHOR:
A JAR (Java ARchive) file is like a shipping container
for your code. You don't send each crate separately across
the ocean — you load everything into a standardized
container (JAR), put a manifest on the side (MANIFEST.MF)
that says what's inside and who's in charge (the Main-Class),
and ship the whole container in one go. Anyone with a port
(JVM) can unload and run it. An executable JAR is even
better: it's a self-contained unit where the recipient
just says "run this" without needing to know what's inside.

📖 EXPLANATION:
JAR files bundle compiled .class files, resources, and
metadata into a single ZIP-format archive for distribution.

─────────────────────────────────────
JAR BASICS:
─────────────────────────────────────
  A JAR file is a ZIP archive with a .jar extension.
  It contains:
  → .class files (compiled Java bytecode)
  → resource files (.properties, .xml, images, etc.)
  → META-INF/MANIFEST.MF (metadata file)

─────────────────────────────────────
THE MANIFEST FILE (META-INF/MANIFEST.MF):
─────────────────────────────────────
  Manifest-Version: 1.0
  Main-Class: com.example.Main
  Class-Path: lib/gson.jar lib/slf4j.jar
  Created-By: 21 (Oracle Corporation)

  Main-Class → which class has the main() method
  Class-Path → additional JARs needed at runtime

─────────────────────────────────────
jar COMMAND (JDK tool):
─────────────────────────────────────
  # Create JAR:
  jar cf myapp.jar *.class         # create from class files
  jar cfm myapp.jar manifest.mf -C out .  # with manifest, from out/ dir

  # View contents:
  jar tf myapp.jar                 # list files
  jar tf myapp.jar | grep .class   # just class files

  # Extract:
  jar xf myapp.jar                 # extract all
  jar xf myapp.jar META-INF/       # extract just manifest

  # Run executable JAR:
  java -jar myapp.jar
  java -jar myapp.jar arg1 arg2    # with arguments

─────────────────────────────────────
CLASSPATH — where Java finds classes:
─────────────────────────────────────
  The classpath tells the JVM WHERE to look for classes.

  # Set on command line:
  java -cp myapp.jar:lib/* com.example.Main     # Unix (colon)
  java -cp myapp.jar;lib\\* com.example.Main     # Windows (semicolon)

  # Or environment variable (avoid — use -cp instead):
  export CLASSPATH=myapp.jar:lib/*

  # Modern: --class-path or --module-path

  Common classpath entries:
  .           → current directory
  myapp.jar   → a specific JAR
  lib/*       → all JARs in lib/ directory
  out/        → a directory of .class files

─────────────────────────────────────
EXECUTABLE JAR — run without flags:
─────────────────────────────────────
  # Build with Maven (creates executable JAR):
  mvn package
  # → target/myapp-1.0.jar (contains all classes)

  # Spring Boot creates a fat JAR (all dependencies inside):
  mvn spring-boot:repackage
  # → target/myapp-1.0.jar (~50MB with all deps embedded)

  # Run:
  java -jar target/myapp-1.0.jar

─────────────────────────────────────
MAVEN BUILD LIFECYCLE:
─────────────────────────────────────
  validate  → check project structure
  compile   → compile source
  test      → run unit tests
  package   → create JAR/WAR
  verify    → integration tests
  install   → install to local Maven repo (~/.m2)
  deploy    → push to remote repo (Nexus, Artifactory)

  mvn package        # runs: validate → compile → test → package
  mvn package -DskipTests  # skip tests
  mvn clean package  # clean first, then package

─────────────────────────────────────
FAT JAR vs THIN JAR:
─────────────────────────────────────
  Thin JAR  → only your code; dependencies separate
             → smaller, but harder to distribute
             → java -cp "myapp.jar:lib/*" com.Main

  Fat JAR   → your code + all dependencies bundled
             → larger (~10-100MB), but self-contained
             → java -jar myapp-fat.jar
             → Spring Boot, Quarkus use this

─────────────────────────────────────
READING RESOURCES FROM JAR:
─────────────────────────────────────
  // Read a file packaged inside the JAR:
  InputStream is = MyClass.class.getResourceAsStream("/config.properties");
  // Or relative to the class:
  InputStream is2 = MyClass.class.getResourceAsStream("data.csv");

  // Get URL of a resource:
  URL url = MyClass.class.getResource("/templates/email.html");

─────────────────────────────────────
MULTI-RELEASE JAR (Java 9+):
─────────────────────────────────────
  A single JAR can contain class files optimized for
  multiple Java versions:
  META-INF/versions/11/com/example/Feature.class
  META-INF/versions/17/com/example/Feature.class
  com/example/Feature.class  (baseline for Java 8)

  The JVM uses the highest-version class it supports.

─────────────────────────────────────
jlink — create minimal JVM runtime:
─────────────────────────────────────
  Bundle a custom JVM with only needed modules:
  jlink --add-modules java.base,java.net.http \\
        --output myapp-runtime
  # Result: a folder with just enough JVM to run your app

💻 CODE:
import java.io.*;
import java.net.*;
import java.nio.file.*;
import java.util.*;
import java.util.jar.*;

public class JARDemo {
    public static void main(String[] args) throws Exception {

        // ─── MANIFEST INSPECTION ─────────────────────────
        System.out.println("=== JAR Manifest Info ===");
        // Read this app's own manifest (works when run from a JAR)
        InputStream manifestStream = JARDemo.class
            .getResourceAsStream("/META-INF/MANIFEST.MF");

        if (manifestStream != null) {
            Manifest manifest = new Manifest(manifestStream);
            Attributes attrs = manifest.getMainAttributes();
            System.out.println("  Main-Class:  " + attrs.getValue("Main-Class"));
            System.out.println("  Class-Path:  " + attrs.getValue("Class-Path"));
            System.out.println("  Created-By:  " + attrs.getValue("Created-By"));
        } else {
            System.out.println("  (Not running from a JAR — no manifest)");
        }

        // ─── READING RESOURCES FROM CLASSPATH ─────────────
        System.out.println("\n=== Reading Resources from Classpath ===");

        // Create a temporary properties file to simulate classpath resource
        Path tempDir  = Files.createTempDirectory("jar-demo");
        Path propFile = tempDir.resolve("app.properties");
        Files.writeString(propFile, """
                app.name=Java Course App
                app.version=1.0.0
                app.author=Terry
                debug=false
                """);

        // Load as Properties
        Properties props = new Properties();
        try (InputStream is = new FileInputStream(propFile.toFile())) {
            props.load(is);
        }

        System.out.println("  Properties loaded:");
        props.forEach((k, v) ->
            System.out.printf("    %-15s = %s%n", k, v));

        // ─── CREATING A JAR PROGRAMMATICALLY ──────────────
        System.out.println("\n=== Creating a JAR Programmatically ===");
        Path jarPath = tempDir.resolve("demo.jar");

        // Create a simple manifest
        Manifest mf = new Manifest();
        mf.getMainAttributes().put(Attributes.Name.MANIFEST_VERSION, "1.0");
        mf.getMainAttributes().put(Attributes.Name.MAIN_CLASS, "com.example.Main");
        mf.getMainAttributes().put(new Attributes.Name("Created-By"), "Java 21");

        // Create JAR
        try (JarOutputStream jos = new JarOutputStream(
                new FileOutputStream(jarPath.toFile()), mf)) {

            // Add a config file
            jos.putNextEntry(new JarEntry("config/settings.properties"));
            jos.write("theme=dark\nfont.size=14\n".getBytes());
            jos.closeEntry();

            // Add a resource
            jos.putNextEntry(new JarEntry("resources/greeting.txt"));
            jos.write("Hello from inside the JAR!\n".getBytes());
            jos.closeEntry();

            // Add a fake class file
            jos.putNextEntry(new JarEntry("com/example/Main.class"));
            jos.write(new byte[]{(byte)0xCA, (byte)0xFE, (byte)0xBA, (byte)0xBE}); // Java magic bytes
            jos.closeEntry();
        }

        System.out.println("  Created: " + jarPath);
        System.out.println("  Size:    " + Files.size(jarPath) + " bytes");

        // ─── READING THE JAR ──────────────────────────────
        System.out.println("\n=== Reading JAR Contents ===");
        try (JarFile jar = new JarFile(jarPath.toFile())) {
            Manifest manifest = jar.getManifest();
            System.out.println("  Main-Class: " +
                manifest.getMainAttributes().getValue("Main-Class"));

            System.out.println("  Entries:");
            jar.entries().asIterator().forEachRemaining(entry -> {
                System.out.printf("    %-40s %5d bytes%n",
                    entry.getName(),
                    entry.getSize() < 0 ? 0 : entry.getSize());
            });

            // Read a specific entry
            JarEntry greeting = jar.getJarEntry("resources/greeting.txt");
            if (greeting != null) {
                String content = new String(jar.getInputStream(greeting).readAllBytes());
                System.out.println("  greeting.txt: " + content.trim());
            }
        }

        // ─── CLASSPATH INFORMATION ────────────────────────
        System.out.println("\n=== Classpath Information ===");
        String cp = System.getProperty("java.class.path");
        String[] entries = cp.split(File.pathSeparator);
        System.out.println("  Classpath entries (" + entries.length + "):");
        for (String entry : entries) {
            System.out.println("    " + entry);
        }

        // ─── JAR COMMANDS REFERENCE ───────────────────────
        System.out.println("\n=== JAR Command Reference ===");
        String[] commands = {
            "jar cf  app.jar -C out .          # create from out/ directory",
            "jar cfm app.jar MANIFEST.MF -C out .  # with custom manifest",
            "jar tf  app.jar                    # list contents",
            "jar xf  app.jar                    # extract all",
            "jar uf  app.jar new-file.class    # update/add file",
            "java -jar app.jar                  # run executable JAR",
            "java -cp app.jar:lib/* com.Main   # explicit classpath (Unix)",
            "java -cp app.jar;lib\\\\* com.Main   # explicit classpath (Windows)"
        };
        for (String cmd : commands) System.out.println("  " + cmd);

        // ─── DEPLOYMENT PATTERNS ──────────────────────────
        System.out.println("\n=== Deployment Patterns ===");
        String[] patterns = {
            "Thin JAR   → your code only; 'java -cp lib/* -jar app.jar'",
            "Fat JAR    → all deps bundled; 'java -jar app-fat.jar' (Spring Boot)",
            "Native     → GraalVM native-image → no JVM needed, instant startup",
            "Docker     → containerize JAR; FROM eclipse-temurin:21-jre",
            "jlink      → custom JVM; smaller than full JDK, self-contained",
        };
        for (String p : patterns) System.out.println("  " + p);

        // Cleanup
        Files.deleteIfExists(propFile);
        Files.deleteIfExists(jarPath);
        Files.deleteIfExists(tempDir);
        System.out.println("\n  (temp files cleaned up)");
    }
}

📝 KEY POINTS:
✅ JAR files are ZIP archives containing .class files, resources, and a manifest
✅ MANIFEST.MF specifies Main-Class (entry point) and Class-Path (dependencies)
✅ java -jar app.jar runs an executable JAR using the Main-Class from the manifest
✅ Fat JARs bundle all dependencies — self-contained, easy to distribute
✅ Thin JARs are smaller but require separate dependency management
✅ Use getClass().getResourceAsStream() to read files packaged inside a JAR
✅ Maven package creates a JAR; spring-boot:repackage creates a fat/executable JAR
✅ jlink creates a custom JVM image with only the modules you need
✅ JarFile API lets you read and inspect JAR contents programmatically
❌ Don't set CLASSPATH environment variable — use -cp/-classpath on the command line
❌ Executable JARs need Main-Class in the manifest — otherwise java -jar fails
❌ Resources inside JARs cannot be accessed as File objects — use getResourceAsStream()
❌ Don't manually manage dependencies in lib/ folders — use Maven/Gradle
""",
  quiz: [
    Quiz(question: 'What is the purpose of the MANIFEST.MF file in a JAR?', options: [
      QuizOption(text: 'It specifies the Main-Class (entry point) and Class-Path (additional dependencies) for the JAR', correct: true),
      QuizOption(text: 'It lists all the Java source files included in the JAR', correct: false),
      QuizOption(text: 'It contains the JAR\'s digital signature for security verification', correct: false),
      QuizOption(text: 'It specifies which Java version the JAR requires to run', correct: false),
    ]),
    Quiz(question: 'How do you read a file that is bundled inside a JAR at runtime?', options: [
      QuizOption(text: 'Use MyClass.class.getResourceAsStream("/path/to/file") — File paths do not work inside JARs', correct: true),
      QuizOption(text: 'Use new File("path/to/file") — it resolves relative to the JAR location', correct: false),
      QuizOption(text: 'Extract the JAR first, then read the extracted file with FileInputStream', correct: false),
      QuizOption(text: 'Use Files.readAllBytes(Path.of("classpath:file")) — Spring-style classpath resolution', correct: false),
    ]),
    Quiz(question: 'What is the difference between a thin JAR and a fat JAR?', options: [
      QuizOption(text: 'A thin JAR contains only your code; a fat JAR bundles all dependencies too — making it self-contained', correct: true),
      QuizOption(text: 'A thin JAR is for production; a fat JAR is for development with debug information', correct: false),
      QuizOption(text: 'A fat JAR compresses classes more aggressively; a thin JAR uses no compression', correct: false),
      QuizOption(text: 'They are identical — fat and thin just describe the file size on disk', correct: false),
    ]),
  ],
);

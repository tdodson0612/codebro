import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson45 = Lesson(
  language: 'Java',
  title: 'Java Module System (JPMS)',
  content: """
🎯 METAPHOR:
The Java Module System is like turning a big open-plan
office (the classpath) into a building with locked doors
(the module system). In the old open-plan office, anyone
could walk anywhere — any class could access any other class.
Now each department (module) has locked doors. You must
declare "I want access to Engineering's conference room"
(requires) and Engineering must declare "these rooms are
available to visitors" (exports). Trying to sneak in
through the back door (deep reflection, internal APIs) is
also blocked unless explicitly permitted. This is the module
system's gift: controlled, documented, enforced dependencies.

📖 EXPLANATION:
The Java Platform Module System (JPMS), introduced in
Java 9 (Project Jigsaw), adds a layer above packages.
A module is a named, self-describing collection of packages.

─────────────────────────────────────
WHY MODULES?
─────────────────────────────────────
  Problems with the old classpath:
  → "JAR hell" — conflicting versions, unclear dependencies
  → Internal JDK classes accessible (sun.*, com.sun.*)
  → No way to hide packages from other JARs
  → Application startup loads everything (slow)

  Module system solves:
  → Reliable configuration: declare what you need
  → Strong encapsulation: hide packages you don't export
  → Scalable platform: JDK itself modularized into ~70 modules
  → Smaller runtime: link only the modules you need

─────────────────────────────────────
module-info.java — the module descriptor:
─────────────────────────────────────
  // Located at: src/module-info.java
  module com.myapp.core {

      // Packages this module exports (others can use):
      exports com.myapp.core.api;
      exports com.myapp.core.model;

      // Packages exported only to specific modules:
      exports com.myapp.core.internal to com.myapp.ui;

      // Modules this module depends on:
      requires java.sql;
      requires java.logging;
      requires com.google.gson;

      // Transitive: anyone requiring com.myapp.core
      // automatically gets java.sql too:
      requires transitive java.sql;

      // Allow reflection into package (for frameworks):
      opens com.myapp.core.model to com.google.gson;
      opens com.myapp.core.config;  // open to everyone

      // Service providers (ServiceLoader):
      uses com.myapp.core.spi.Plugin;
      provides com.myapp.core.spi.Plugin
          with com.myapp.core.DefaultPlugin;
  }

─────────────────────────────────────
KEYWORDS IN module-info.java:
─────────────────────────────────────
  module    → declares the module name
  requires  → depends on another module
  requires transitive → transitive dependency
  requires static → compile-time only dependency
  exports   → makes a package accessible
  opens     → allows deep reflection (for frameworks)
  uses      → declares a service this module uses
  provides  → declares a service implementation

─────────────────────────────────────
JDK MODULES — important ones:
─────────────────────────────────────
  java.base          → always available (String, Collections...)
  java.sql           → JDBC
  java.xml           → XML parsing
  java.net.http      → HttpClient (Java 11)
  java.logging       → java.util.logging
  java.desktop       → AWT/Swing
  java.compiler      → JavaCompiler API
  jdk.jshell         → JShell API
  jdk.httpserver     → Simple HTTP server

  java.base is implicitly required — you don't need to declare it.

─────────────────────────────────────
PROJECT STRUCTURE WITH MODULES:
─────────────────────────────────────
  myapp/
  ├── com.myapp.core/
  │   └── src/
  │       ├── module-info.java
  │       └── com/myapp/core/
  │           ├── api/...
  │           └── model/...
  ├── com.myapp.ui/
  │   └── src/
  │       ├── module-info.java
  │       └── com/myapp/ui/...
  └── com.myapp.main/
      └── src/
          ├── module-info.java
          └── com/myapp/main/...

─────────────────────────────────────
PRACTICAL REALITY:
─────────────────────────────────────
  → Most NEW Java apps don't use modules (yet)
  → Maven/Gradle projects still use classpath by default
  → Modules matter more for: JDK itself, library authors,
    jlink for creating slim JVM distributions
  → Spring Boot, Android don't use JPMS
  → Understanding modules helps you read JDK docs and
    troubleshoot InaccessibleObjectException

─────────────────────────────────────
jlink — creating a custom runtime:
─────────────────────────────────────
  jlink --module-path mods:\$JAVA_HOME/jmods \\
        --add-modules com.myapp.main \\
        --output myapp-runtime

  Creates a custom JVM with ONLY the needed modules.
  Dramatically reduces distribution size (400MB → 30MB).

💻 CODE:
// ─── This lesson demonstrates module concepts via code ──
// In a real project, module-info.java would be at src/ root
// Here we simulate the patterns and concepts

// Simulating what module-info.java would look like:

/*
  FILE: src/module-info.java
  ─────────────────────────────
  module com.codebro.lessons {
      // We use these JDK modules:
      requires java.net.http;    // HttpClient
      requires java.sql;         // JDBC
      requires java.logging;     // logging

      // We export our API package:
      exports com.codebro.lessons.api;

      // Our model package is exported only to specific modules:
      exports com.codebro.lessons.model to com.codebro.ui;

      // Internal packages are NOT exported — hidden:
      // com.codebro.lessons.internal is private!

      // Allow Jackson to reflect on our model classes:
      opens com.codebro.lessons.model to com.fasterxml.jackson.databind;

      // Service loader pattern:
      uses com.codebro.lessons.spi.LessonProvider;
  }
*/

import java.lang.module.*;
import java.util.*;
import java.util.stream.*;

public class ModuleSystem {
    public static void main(String[] args) {

        // ─── INSPECT JDK MODULES ──────────────────────────
        System.out.println("=== JDK Module Inspection ===");

        ModuleLayer bootLayer = ModuleLayer.boot();
        Set<Module> modules = bootLayer.modules();

        long count = modules.stream().count();
        System.out.println("  Total JDK modules loaded: " + count);

        // Show java.* modules
        System.out.println("\n  java.* modules:");
        modules.stream()
            .map(Module::getName)
            .filter(name -> name.startsWith("java."))
            .sorted()
            .forEach(name -> System.out.println("    " + name));

        // ─── INSPECT SPECIFIC MODULE ──────────────────────
        System.out.println("\n=== java.sql module details ===");
        Optional<Module> sqlModule = bootLayer.findModule("java.sql");
        sqlModule.ifPresentOrElse(mod -> {
            ModuleDescriptor desc = mod.getDescriptor();
            System.out.println("  Name: " + desc.name());
            System.out.println("  Version: " + desc.rawVersion().orElse("N/A"));

            System.out.println("  Exports (first 5):");
            desc.exports().stream()
                .limit(5)
                .forEach(e -> {
                    String target = e.isQualified() ?
                        " (to " + e.targets() + ")" : " (to all)";
                    System.out.println("    " + e.source() + target);
                });

            System.out.println("  Requires (first 5):");
            desc.requires().stream()
                .limit(5)
                .forEach(r -> System.out.println("    " + r.name() +
                    (r.modifiers().isEmpty() ? "" : " " + r.modifiers())));

        }, () -> System.out.println("  java.sql not found (may be excluded)"));

        // ─── INSPECT CURRENT MODULE ───────────────────────
        System.out.println("\n=== This application's module ===");
        Module currentModule = ModuleSystem.class.getModule();
        System.out.println("  Module name: " + currentModule.getName());
        System.out.println("  Is named: " + currentModule.isNamed());
        System.out.println("  (Unnamed module = running on classpath, not module path)");

        // ─── SIMULATED module-info.java PATTERNS ─────────
        System.out.println("\n=== Module descriptor patterns (simulated) ===");

        String[] modulePatterns = {
            "module com.myapp {",
            "    requires java.sql;              // JDBC support",
            "    requires java.net.http;          // HTTP client",
            "    requires transitive java.logging;// pass to dependents",
            "    requires static java.compiler;   // compile-time only",
            "",
            "    exports com.myapp.api;           // public API",
            "    exports com.myapp.model;         // data models",
            "    // com.myapp.internal NOT exported — hidden!",
            "",
            "    opens com.myapp.model to         // allow reflection",
            "        com.fasterxml.jackson.databind;",
            "",
            "    uses com.myapp.spi.Plugin;        // consume service",
            "    provides com.myapp.spi.Plugin     // provide service",
            "        with com.myapp.DefaultPlugin;",
            "}"
        };

        for (String line : modulePatterns) {
            System.out.println("  " + line);
        }

        // ─── COMMON MODULE ISSUES AND SOLUTIONS ───────────
        System.out.println("\n=== Common Module Issues & Solutions ===");

        String[][] issues = {
            { "InaccessibleObjectException",
              "Add 'opens com.example.model' to module-info.java for frameworks needing reflection" },
            { "module not found",
              "Add 'requires module.name' to module-info.java and ensure JAR is on module path" },
            { "package not found in module",
              "The package is in an unnamed module — mix of module/classpath" },
            { "AccessDeniedException to sun.* APIs",
              "Use --add-opens or migrate to public API — sun.* is now properly hidden" },
            { "Cannot access class from unnamed module",
              "Either add module-info.java or run with --add-exports on command line" }
        };

        for (String[] issue : issues) {
            System.out.println("  Problem: " + issue[0]);
            System.out.println("  Solution: " + issue[1]);
            System.out.println();
        }

        // ─── jlink EXAMPLE (documentation only) ──────────
        System.out.println("=== jlink — Custom Runtime Example ===");
        System.out.println("""
          Create a minimal JVM containing only needed modules:

         \$ jlink \\
              --module-path\$JAVA_HOME/jmods:mods \\
              --add-modules com.myapp.main \\
              --output myapp-runtime \\
              --strip-debug \\
              --compress=2 \\
              --no-header-files \\
              --no-man-pages

          Result: myapp-runtime/bin/java (tiny custom JVM)
          Typical size reduction: 400MB JDK → 30-50MB custom runtime
          """);

        // ─── PRACTICAL ADVICE ─────────────────────────────
        System.out.println("=== Practical Advice ===");
        System.out.println("""
          When to add module-info.java:
          → Building a reusable library
          → Creating a jlink custom runtime
          → Enforcing package encapsulation in a large codebase
          → New Java 9+ application from scratch

          When to skip modules (for now):
          → Spring Boot / Quarkus application
          → Android development
          → Quick prototype or learning project
          → When all dependencies support modules (many don't yet)

          Most enterprise Java apps run on the classpath (unnamed module).
          You'll encounter module errors when framework internals change
          (Spring, Hibernate, Jackson need reflection access).
          Fix: add --add-opens JVM flags or update dependencies.
          """);
    }
}

📝 KEY POINTS:
✅ module-info.java lives at the root of the source directory
✅ requires declares dependencies; exports declares what others can use
✅ Packages NOT exported are hidden — strong encapsulation
✅ opens allows deep reflection into a package (for frameworks like Spring, Jackson)
✅ requires transitive passes a dependency to modules requiring this one
✅ java.base is always available — no need to declare it
✅ jlink creates a minimal custom JVM with only needed modules
✅ InaccessibleObjectException means you need to opens the package
❌ Most Spring Boot / Maven apps don't use JPMS — they use the unnamed module (classpath)
❌ Not all third-party libraries support JPMS yet — mixing can be tricky
❌ Automatic modules (JARs without module-info) are a bridge — not a final solution
❌ Don't confuse Java modules with Maven/Gradle modules — completely different concepts
""",
  quiz: [
    Quiz(question: 'What does the exports keyword do in module-info.java?', options: [
      QuizOption(text: 'Makes a package accessible to code in other modules — unexported packages are hidden', correct: true),
      QuizOption(text: 'Exports the entire module as a JAR to a repository', correct: false),
      QuizOption(text: 'Makes all classes in the module public regardless of their modifiers', correct: false),
      QuizOption(text: 'Declares which external modules this module depends on', correct: false),
    ]),
    Quiz(question: 'What is the purpose of the opens keyword in module-info.java?', options: [
      QuizOption(text: 'Allows deep reflection into the package — needed for frameworks like Spring and Jackson', correct: true),
      QuizOption(text: 'Opens the package for public access, making it equivalent to exports', correct: false),
      QuizOption(text: 'Opens a network socket on the port matching the package hash', correct: false),
      QuizOption(text: 'Makes all fields in the package public for testing purposes', correct: false),
    ]),
    Quiz(question: 'What does InaccessibleObjectException typically indicate?', options: [
      QuizOption(text: 'A framework is trying to reflect into a module\'s package that hasn\'t been opened with opens', correct: true),
      QuizOption(text: 'The class does not exist on the classpath', correct: false),
      QuizOption(text: 'The field or method being accessed is declared private', correct: false),
      QuizOption(text: 'A module has been compiled with a different Java version', correct: false),
    ]),
  ],
);

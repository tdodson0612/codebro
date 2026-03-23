import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson20 = Lesson(
  language: 'Java',
  title: 'Packages and Imports',
  content: """
🎯 METAPHOR:
Packages in Java are like the filing system of a large law
firm. Contracts go in the "contracts" drawer. Employee
records go in "HR." Court filings go in "litigation."
Without this organization, finding anything in a firm with
thousands of documents would be impossible. Java packages
do the same for code: com.myapp.data for data models,
com.myapp.service for business logic, com.myapp.web for
HTTP handling. Imports are like the inter-departmental
memo that says "I need document XYZ from the contracts
drawer" — without the memo, you have to spell out the full
filing path every single time you need it.

📖 EXPLANATION:

─────────────────────────────────────
PACKAGES:
─────────────────────────────────────
  A package is a NAMESPACE — a named grouping of classes.
  It prevents naming conflicts: two classes can have the
  same name if they're in different packages.

  // First line of every Java file:
  package com.mycompany.myapp.features.auth;

  Convention: reverse domain name → subdirectories
    com.google.maps
    org.springframework.boot
    io.netty.channel

  Physical structure must match package structure:
    com/mycompany/myapp/features/auth/AuthService.java

─────────────────────────────────────
IMPORTS:
─────────────────────────────────────
  import java.util.List;           // import one class
  import java.util.*;              // import all from package (star)
  import static java.lang.Math.*;  // static import

  Without import — fully qualified name:
  java.util.List<String> list = new java.util.ArrayList<>();

  With import:
  List<String> list = new ArrayList<>();   // much cleaner

─────────────────────────────────────
JAVA STANDARD PACKAGES:
─────────────────────────────────────
  java.lang     → auto-imported: String, Math, Integer,
                  System, Thread, Object, Exception...
  java.util     → collections, Date, Scanner, Arrays...
  java.io       → File, InputStream, OutputStream...
  java.nio      → modern file I/O, Paths, Files...
  java.net      → URL, HttpURLConnection, Socket...
  java.time     → LocalDate, LocalTime, Duration...
  java.math     → BigInteger, BigDecimal...
  java.util.function → Function, Consumer, Predicate...
  java.util.stream   → Stream, Collectors...
  java.util.concurrent → ExecutorService, locks...

─────────────────────────────────────
NAMING CONFLICTS:
─────────────────────────────────────
  Both java.util.Date and java.sql.Date exist!
  
  // Solution 1: import one, use fully qualified for the other
  import java.util.Date;

  Date d1 = new Date();                      // java.util.Date
  java.sql.Date d2 = new java.sql.Date(0);   // fully qualified

  // Solution 2: both fully qualified
  java.util.Date d3 = new java.util.Date();
  java.sql.Date  d4 = new java.sql.Date(0);

─────────────────────────────────────
PACKAGE ACCESS:
─────────────────────────────────────
  Classes in the SAME package can access each other's
  package-private (no modifier) members.
  This enables closely related classes to work together
  while hiding details from the rest of the world.

─────────────────────────────────────
MODULE SYSTEM (Java 9+):
─────────────────────────────────────
  Java 9 introduced the module system (Project Jigsaw).
  A module groups packages and declares what it exports
  and what it requires.

  // module-info.java
  module com.myapp {
      requires java.net.http;
      requires java.sql;
      exports com.myapp.api;      // only this package visible outside
  }

  For most learning purposes, you can ignore modules.
  They matter for large applications and library design.

💻 CODE:
// This demo simulates what real package structure looks like.
// In a real project, these would be in separate files in
// matching directory structures.

import java.util.*;
import java.util.stream.*;
import static java.lang.Math.*;    // static import — sqrt, PI, etc.
import static java.util.Collections.*;  // unmodifiableList, etc.

// Simulating package: com.codebro.model
class User {
    private final String id;
    private final String username;
    private final String email;

    public User(String id, String username, String email) {
        this.id       = id;
        this.username = username;
        this.email    = email;
    }

    public String getId()       { return id; }
    public String getUsername() { return username; }
    public String getEmail()    { return email; }

    @Override
    public String toString() {
        return String.format("User{id='%s', username='%s'}", id, username);
    }
}

// Simulating package: com.codebro.util
class StringUtils {
    private StringUtils() { }   // utility class — no instances

    public static String capitalize(String s) {
        if (s == null || s.isEmpty()) return s;
        return Character.toUpperCase(s.charAt(0)) + s.substring(1).toLowerCase();
    }

    public static String truncate(String s, int maxLen) {
        if (s == null || s.length() <= maxLen) return s;
        return s.substring(0, maxLen - 3) + "...";
    }

    public static boolean isValidEmail(String email) {
        return email != null && email.contains("@") && email.contains(".");
    }
}

// Simulating package: com.codebro.service
class UserService {
    private final List<User> users = new ArrayList<>();
    private int nextId = 1;

    public User createUser(String username, String email) {
        if (!StringUtils.isValidEmail(email))
            throw new IllegalArgumentException("Invalid email: " + email);
        User user = new User("U-" + nextId++, username, email);
        users.add(user);
        return user;
    }

    public Optional<User> findById(String id) {
        return users.stream()
            .filter(u -> u.getId().equals(id))
            .findFirst();
    }

    public List<User> findByUsernameContaining(String query) {
        return users.stream()
            .filter(u -> u.getUsername().toLowerCase().contains(query.toLowerCase()))
            .collect(Collectors.toList());
    }

    public List<User> getAllUsers() {
        return unmodifiableList(users);   // static import from Collections
    }

    public int getUserCount() { return users.size(); }
}

public class PackagesAndImports {
    public static void main(String[] args) {

        // ─── DEMONSTRATE PACKAGE STRUCTURE ───────────────
        System.out.println("=== Package Architecture Demo ===");
        System.out.println("(In a real project, these classes would be in:");
        System.out.println(" com/codebro/model/User.java");
        System.out.println(" com/codebro/util/StringUtils.java");
        System.out.println(" com/codebro/service/UserService.java)\n");

        // ─── StringUtils (utility class) ─────────────────
        System.out.println("=== StringUtils ===");
        String[] names = {"alice", "BOB", "charlie DOE", "  DIANA  "};
        for (String name : names) {
            System.out.printf("  capitalize('%-15s') → '%s'%n",
                name + "'", StringUtils.capitalize(name.trim()));
        }

        String longText = "This is a very long text that needs to be truncated";
        System.out.println("  truncate(40): '" + StringUtils.truncate(longText, 40) + "'");

        // ─── UserService ──────────────────────────────────
        System.out.println("\n=== UserService ===");
        UserService service = new UserService();

        service.createUser("terry99", "terry@example.com");
        service.createUser("sam_dev", "sam@example.com");
        service.createUser("alice_j", "alice@example.com");
        service.createUser("bob_smith", "bob@example.com");

        System.out.println("All users:");
        service.getAllUsers().forEach(u ->
            System.out.println("  " + u));

        System.out.println("\nSearch for 'a':");
        service.findByUsernameContaining("a")
            .forEach(u -> System.out.println("  Found: " + u));

        System.out.println("\nFind by ID:");
        Optional<User> found = service.findById("U-2");
        found.ifPresentOrElse(
            u -> System.out.println("  " + u),
            () -> System.out.println("  Not found")
        );

        // ─── STATIC IMPORTS IN ACTION ─────────────────────
        System.out.println("\n=== Static imports (Math.*) ===");
        System.out.printf("  sqrt(144)   = %.0f%n", sqrt(144));  // from Math
        System.out.printf("  PI          = %.5f%n", PI);          // from Math
        System.out.printf("  abs(-42)    = %d%n",  abs(-42));     // from Math
        System.out.printf("  pow(2, 10)  = %.0f%n", pow(2, 10)); // from Math
        System.out.printf("  floor(3.7)  = %.0f%n", floor(3.7)); // from Math

        // ─── NAME CONFLICT RESOLUTION ─────────────────────
        System.out.println("\n=== Name conflict: java.util.Date vs java.sql.Date ===");
        java.util.Date utilDate = new java.util.Date();
        System.out.println("  java.util.Date  : " + utilDate.getClass().getName());

        // Would also work but requires fully qualified:
        // java.sql.Date sqlDate = new java.sql.Date(System.currentTimeMillis());

        // ─── STANDARD LIBRARY PACKAGES ───────────────────
        System.out.println("\n=== Standard library packages ===");
        Map<String, String> packages = new LinkedHashMap<>();
        packages.put("java.lang",     "String, Math, Integer, System — auto-imported");
        packages.put("java.util",     "Collections, List, Map, Set, Optional, Scanner");
        packages.put("java.io",       "File, InputStream, OutputStream, Reader, Writer");
        packages.put("java.nio",      "Files, Paths, Path, ByteBuffer");
        packages.put("java.time",     "LocalDate, LocalTime, Duration, ZonedDateTime");
        packages.put("java.math",     "BigInteger, BigDecimal");
        packages.put("java.net",      "URL, HttpURLConnection, InetAddress, Socket");
        packages.put("java.util.function", "Function, Consumer, Supplier, Predicate");
        packages.put("java.util.stream",   "Stream, Collectors, IntStream");

        packages.forEach((pkg, desc) ->
            System.out.printf("  %-30s → %s%n", pkg, desc));
    }
}

📝 KEY POINTS:
✅ Package declaration is the FIRST line of a Java source file
✅ Convention: reverse domain name, all lowercase: com.company.project.module
✅ Directory structure MUST match the package structure
✅ java.lang is imported automatically — no import needed for String, Math, etc.
✅ Star imports (java.util.*) import all public types but NOT sub-packages
✅ Static imports let you use static members without the class name prefix
✅ For name conflicts, use the fully qualified class name for one of them
✅ Package-private members (no modifier) are visible within the same package
❌ Don't overuse star imports — explicit imports document dependencies clearly
❌ Package names are all lowercase — NEVER use CamelCase in package names
❌ A class can only be in ONE package — declared at the top of the file
❌ The module system (Java 9+) adds another layer on top — learn packages first
""",
  quiz: [
    Quiz(question: 'What is the convention for Java package naming?', options: [
      QuizOption(text: 'Reverse domain name in all lowercase: com.company.project', correct: true),
      QuizOption(text: 'PascalCase matching the class names inside: Com.Company.Project', correct: false),
      QuizOption(text: 'Underscore-separated lowercase: com_company_project', correct: false),
      QuizOption(text: 'Any descriptive name without dots: myapppackage', correct: false),
    ]),
    Quiz(question: 'Which package is automatically imported in every Java file?', options: [
      QuizOption(text: 'java.lang — providing String, Math, Integer, Object, System, etc.', correct: true),
      QuizOption(text: 'java.util — providing List, Map, and collections', correct: false),
      QuizOption(text: 'java.io — providing File and I/O streams', correct: false),
      QuizOption(text: 'No package is auto-imported — all must be explicitly imported', correct: false),
    ]),
    Quiz(question: 'How do you handle a naming conflict when two packages have a class with the same name?', options: [
      QuizOption(text: 'Import one and use the fully qualified name for the other', correct: true),
      QuizOption(text: 'You cannot use both in the same file', correct: false),
      QuizOption(text: 'Use an alias import: import java.sql.Date as SqlDate', correct: false),
      QuizOption(text: 'The most recently imported class wins automatically', correct: false),
    ]),
  ],
);

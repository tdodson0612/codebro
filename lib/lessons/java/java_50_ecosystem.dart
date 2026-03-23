import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson50 = Lesson(
  language: 'Java',
  title: 'Java Ecosystem: Maven, Gradle, and Spring',
  content: """
🎯 METAPHOR:
Writing Java without a build tool is like baking
professionally without a kitchen — you COULD do everything
by hand (mix in a bowl, use a camp stove), but professional
kitchens (Maven, Gradle) have everything organized,
automatic, and repeatable. Maven is the classic restaurant
kitchen — rigid, opinionated, extremely well-documented.
Gradle is the modern open-concept kitchen — flexible,
faster, programmable. Spring is the entire restaurant
management system: it handles ingredients (dependency
injection), schedules orders (request routing), manages
staff (lifecycle management), and handles payment (security).
Real Java applications combine all three: build tool +
framework + ecosystem libraries.

📖 EXPLANATION:
The Java ecosystem extends far beyond the standard library.
Understanding the most important tools is essential for
any Java developer.

─────────────────────────────────────
MAVEN — Build and Dependency Management:
─────────────────────────────────────
  Maven manages:
  → Dependencies (download JARs automatically)
  → Build lifecycle (compile, test, package, deploy)
  → Project structure (convention over configuration)
  → Plugins (jar, war, spring-boot, surefire...)

  Key file: pom.xml (Project Object Model)

  <!-- pom.xml structure: -->
  <project>
      <groupId>com.example</groupId>
      <artifactId>myapp</artifactId>
      <version>1.0.0</version>
      <packaging>jar</packaging>

      <properties>
          <java.version>21</java.version>
      </properties>

      <dependencies>
          <dependency>
              <groupId>org.springframework.boot</groupId>
              <artifactId>spring-boot-starter-web</artifactId>
              <version>3.2.0</version>
          </dependency>
          <dependency>
              <groupId>org.junit.jupiter</groupId>
              <artifactId>junit-jupiter</artifactId>
              <version>5.10.0</version>
              <scope>test</scope>    // only in test classpath
          </dependency>
      </dependencies>
  </project>

  COMMON COMMANDS:
  mvn compile             → compile source
  mvn test                → run tests
  mvn package             → create JAR
  mvn install             → install to local repo
  mvn spring-boot:run     → run Spring Boot app
  mvn dependency:tree     → show dependency tree

─────────────────────────────────────
GRADLE — Modern Build System:
─────────────────────────────────────
  Gradle uses Kotlin or Groovy DSL instead of XML.
  Faster than Maven (incremental builds, caching).
  Used by Android (required) and many modern Java projects.

  // build.gradle.kts (Kotlin DSL):
  plugins {
      application
      kotlin("jvm") version "1.9.0"
  }

  repositories { mavenCentral() }

  dependencies {
      implementation("org.springframework.boot:spring-boot-starter-web:3.2.0")
      testImplementation("org.junit.jupiter:junit-jupiter:5.10.0")
  }

  COMMON COMMANDS:
  ./gradlew build         → compile + test + package
  ./gradlew test          → run tests
  ./gradlew run           → run application
  ./gradlew dependencies  → show dependency tree
  ./gradlew bootRun       → run Spring Boot app

─────────────────────────────────────
MAVEN CENTRAL REPOSITORY:
─────────────────────────────────────
  Central repository for all Java libraries.
  Search at: search.maven.org

  Find any library and copy its dependency XML/Kotlin DSL.
  Common libraries:

  Spring Boot:   spring-boot-starter-web, *-data-jpa, *-security
  Database:      h2, postgresql, mysql-connector-j
  HTTP client:   okhttp, retrofit
  JSON:          jackson-databind, gson, fastjson
  Logging:       logback-classic, log4j-core, slf4j-api
  Testing:       junit-jupiter, mockito-core, assertj-core
  Utils:         guava, commons-lang3, lombok

─────────────────────────────────────
SPRING FRAMEWORK — The Industry Standard:
─────────────────────────────────────
  Spring Boot = Spring Framework + auto-configuration.
  The most widely used Java framework worldwide.

  CORE CONCEPTS:
  → IoC (Inversion of Control): Spring creates objects for you
  → DI (Dependency Injection): Spring wires dependencies
  → Beans: Spring-managed objects

  KEY ANNOTATIONS:
  @SpringBootApplication   → main class marker
  @RestController          → HTTP controller (REST API)
  @Service                 → business logic
  @Repository              → data access layer
  @Component               → generic bean
  @Autowired               → inject dependency
  @GetMapping("/users")    → GET /users endpoint
  @PostMapping("/users")   → POST /users endpoint
  @RequestBody             → bind request body to object
  @PathVariable            → URL parameter
  @RequestParam            → query parameter

  KEY MODULES:
  spring-boot-starter-web      → REST APIs (Tomcat embedded)
  spring-boot-starter-data-jpa → Database access via JPA/Hibernate
  spring-boot-starter-security → Authentication & authorization
  spring-boot-starter-test     → Testing (JUnit + Mockito)
  spring-boot-starter-cache    → Caching abstraction

─────────────────────────────────────
POPULAR JAVA LIBRARIES:
─────────────────────────────────────
  LOGGING:
  SLF4J + Logback — standard logging facade + implementation
  java.util.logging — built-in (avoid in new code)

  HTTP:
  OkHttp — fast HTTP/2 client
  Retrofit — REST client with annotations
  Feign — declarative HTTP client for microservices

  JSON:
  Jackson — most popular Java JSON library
  Gson — Google's JSON library (simpler)

  TESTING:
  Mockito — mock objects in tests
  AssertJ — fluent assertions
  WireMock — mock HTTP servers in tests
  Testcontainers — Docker containers in tests

  ORM / DATABASE:
  Hibernate — JPA implementation
  jOOQ — type-safe SQL in Java
  Spring Data JPA — repositories over Hibernate

  UTILITIES:
  Lombok — reduces boilerplate (@Data, @Builder, @Slf4j)
  Guava — Google's utility library
  Apache Commons — utilities for strings, collections, I/O

─────────────────────────────────────
YOUR LEARNING ROADMAP:
─────────────────────────────────────
  STEP 1 → Maven/Gradle basics
    Create a project, add dependencies, run tests

  STEP 2 → Spring Boot basics
    Build a simple REST API
    Tutorial: spring.io/quickstart

  STEP 3 → Spring Data JPA
    Connect to a database
    CRUD operations with repositories

  STEP 4 → Spring Security
    Add authentication to your API

  STEP 5 → Testing
    Unit tests with JUnit + Mockito
    Integration tests with @SpringBootTest

  STEP 6 → Production concerns
    Logging with SLF4J/Logback
    Configuration with application.properties
    Docker containerization
    Cloud deployment (AWS, GCP, Azure)

  BEST RESOURCES:
  → spring.io/guides — official Spring tutorials
  → baeldung.com — top Java/Spring blog
  → youtube: Amigoscode, Marco Codes
  → "Spring in Action" book (Craig Walls)

💻 CODE:
// ─── DEMONSTRATION: Spring Boot patterns in pure Java ──
// Real Spring Boot needs the Spring dependency.
// This shows the patterns you'd use in production.

import java.util.*;
import java.util.stream.*;
import java.util.function.*;

// ─── DOMAIN MODEL ─────────────────────────────────────
record UserDto(int id, String name, String email, String role) {
    public static UserDto of(int id, String name, String email) {
        return new UserDto(id, name, email, "USER");
    }
}

// ─── REPOSITORY LAYER (data access) ───────────────────
// In Spring: annotated with @Repository, uses JPA/JDBC
class UserRepository {
    private final Map<Integer, UserDto> store = new HashMap<>();
    private int nextId = 1;

    public UserDto save(UserDto user) {
        var saved = new UserDto(nextId++, user.name(), user.email(), user.role());
        store.put(saved.id(), saved);
        return saved;
    }

    public Optional<UserDto> findById(int id) {
        return Optional.ofNullable(store.get(id));
    }

    public List<UserDto> findAll() {
        return new ArrayList<>(store.values());
    }

    public List<UserDto> findByRole(String role) {
        return store.values().stream()
            .filter(u -> u.role().equals(role))
            .collect(Collectors.toList());
    }

    public boolean deleteById(int id) {
        return store.remove(id) != null;
    }
}

// ─── SERVICE LAYER (business logic) ───────────────────
// In Spring: annotated with @Service, @Transactional
class UserService {
    private final UserRepository repository;   // @Autowired in Spring

    public UserService(UserRepository repository) {
        this.repository = repository;
    }

    public UserDto createUser(String name, String email) {
        if (name.isBlank()) throw new IllegalArgumentException("Name cannot be blank");
        if (!email.contains("@")) throw new IllegalArgumentException("Invalid email");
        return repository.save(UserDto.of(0, name.strip(), email.toLowerCase()));
    }

    public UserDto getUser(int id) {
        return repository.findById(id)
            .orElseThrow(() -> new NoSuchElementException("User not found: " + id));
    }

    public List<UserDto> getAllUsers() {
        return repository.findAll();
    }

    public boolean deleteUser(int id) {
        getUser(id);  // throws if not found
        return repository.deleteById(id);
    }

    // Business logic: promote to admin
    public UserDto promoteToAdmin(int id) {
        UserDto user = getUser(id);
        var promoted = new UserDto(user.id(), user.name(), user.email(), "ADMIN");
        return repository.save(promoted);
    }
}

// ─── CONTROLLER LAYER (HTTP) ──────────────────────────
// In Spring: @RestController, @GetMapping, @PostMapping
// Here we simulate HTTP request/response with records
record HttpRequest(String method, String path, Map<String, String> body) {}
record HttpResponse(int status, String body) {}

class UserController {
    private final UserService service;   // @Autowired in Spring

    public UserController(UserService service) {
        this.service = service;
    }

    // @GetMapping("/users")
    public HttpResponse getAllUsers() {
        var users = service.getAllUsers();
        return new HttpResponse(200, "Users: " + users);
    }

    // @GetMapping("/users/{id}")
    public HttpResponse getUser(int id) {
        try {
            return new HttpResponse(200, service.getUser(id).toString());
        } catch (NoSuchElementException e) {
            return new HttpResponse(404, e.getMessage());
        }
    }

    // @PostMapping("/users")
    public HttpResponse createUser(String name, String email) {
        try {
            UserDto created = service.createUser(name, email);
            return new HttpResponse(201, "Created: " + created);
        } catch (IllegalArgumentException e) {
            return new HttpResponse(400, e.getMessage());
        }
    }

    // @DeleteMapping("/users/{id}")
    public HttpResponse deleteUser(int id) {
        try {
            service.deleteUser(id);
            return new HttpResponse(204, "Deleted");
        } catch (NoSuchElementException e) {
            return new HttpResponse(404, e.getMessage());
        }
    }
}

// ─── SIMPLE DI CONTAINER (simulates Spring IoC) ───────
class ApplicationContext {
    private UserRepository repository;
    private UserService service;
    private UserController controller;

    public ApplicationContext() {
        // Spring does this automatically via @Autowired
        this.repository = new UserRepository();
        this.service    = new UserService(repository);
        this.controller = new UserController(service);
    }

    public UserController getController() { return controller; }
}

public class JavaEcosystem {
    public static void main(String[] args) {
        System.out.println("=== Java Ecosystem Demo ===");
        System.out.println("(Simulating Spring Boot MVC layers)\n");

        // Wire everything up (Spring does this automatically)
        var ctx = new ApplicationContext();
        var ctrl = ctx.getController();

        // Simulate HTTP requests
        System.out.println("POST /users  → Create users");
        System.out.println(ctrl.createUser("Alice Chen", "alice@example.com"));
        System.out.println(ctrl.createUser("Bob Smith",  "bob@example.com"));
        System.out.println(ctrl.createUser("Carol Davis","carol@example.com"));

        System.out.println("\nGET /users  → List all");
        System.out.println(ctrl.getAllUsers());

        System.out.println("\nGET /users/2  → Get one");
        System.out.println(ctrl.getUser(2));

        System.out.println("\nGET /users/99  → Not found");
        System.out.println(ctrl.getUser(99));

        System.out.println("\nDELETE /users/1");
        System.out.println(ctrl.deleteUser(1));

        System.out.println("\nGET /users  → After delete");
        System.out.println(ctrl.getAllUsers());

        System.out.println("\nPOST /users  → Invalid email");
        System.out.println(ctrl.createUser("Dave", "notanemail"));

        System.out.println("\n=== Maven/Gradle Quick Reference ===");
        System.out.println("""
          Maven commands:
            mvn compile          → compile
            mvn test             → test
            mvn package          → create JAR
            mvn spring-boot:run  → run app
            mvn dependency:tree  → show deps

          Gradle commands:
            ./gradlew build      → compile + test + package
            ./gradlew test       → run tests
            ./gradlew bootRun    → run Spring Boot

          Add a dependency (Maven):
            search.maven.org → find artifact → copy XML → paste in pom.xml

          Spring Boot quickstart:
            start.spring.io → select deps → generate → unzip → code!
          """);
    }
}

📝 KEY POINTS:
✅ Maven uses pom.xml; Gradle uses build.gradle or build.gradle.kts
✅ Add dependencies by groupId + artifactId + version — they're auto-downloaded
✅ Maven Central (search.maven.org) is the main public repository
✅ Spring Boot auto-configures Spring based on dependencies present
✅ @RestController + @GetMapping/@PostMapping = REST endpoint in Spring
✅ Repository → Service → Controller is the standard Spring layered architecture
✅ Spring's IoC container creates and wires beans automatically (@Autowired)
✅ start.spring.io generates a Spring Boot project with selected dependencies
✅ Lombok reduces boilerplate: @Data, @Builder, @Slf4j on any class
❌ Don't manage JAR files manually — always use Maven/Gradle for dependencies
❌ Don't put business logic in controllers — keep it in the service layer
❌ Don't use Spring's ApplicationContext directly in production code
❌ Don't skip tests — Spring Boot's @SpringBootTest makes integration testing easy
""",
  quiz: [
    Quiz(question: 'What is the main purpose of Maven and Gradle in Java projects?', options: [
      QuizOption(text: 'To manage dependencies, automate builds (compile/test/package), and standardize project structure', correct: true),
      QuizOption(text: 'To provide a runtime environment for executing Java applications', correct: false),
      QuizOption(text: 'To replace the JVM with a faster execution engine', correct: false),
      QuizOption(text: 'To generate documentation from Javadoc comments', correct: false),
    ]),
    Quiz(question: 'In Spring Boot\'s layered architecture, what is the role of the Service layer?', options: [
      QuizOption(text: 'Contains business logic — sits between the controller (HTTP) and repository (data access)', correct: true),
      QuizOption(text: 'Handles HTTP requests and maps them to controller methods', correct: false),
      QuizOption(text: 'Manages database connections and SQL queries directly', correct: false),
      QuizOption(text: 'Provides authentication and authorization for all requests', correct: false),
    ]),
    Quiz(question: 'What does @Autowired do in Spring?', options: [
      QuizOption(text: 'Tells Spring to inject a dependency automatically — Spring finds and creates the matching bean', correct: true),
      QuizOption(text: 'Marks a method to be called automatically when the application starts', correct: false),
      QuizOption(text: 'Registers a class as an HTTP endpoint accessible from outside', correct: false),
      QuizOption(text: 'Enables automatic database transaction management for the annotated method', correct: false),
    ]),
  ],
);

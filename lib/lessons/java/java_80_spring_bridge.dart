import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson80 = Lesson(
  language: 'Java',
  title: 'Java → Spring Boot: Building Server Applications',
  content: """
🎯 METAPHOR:
Knowing Java and moving to Spring Boot is like knowing
how to cook and getting your first professional kitchen.
You can already chop vegetables, boil pasta, and make
sauces — Java gives you all these skills. Spring Boot
is the professional kitchen that equips you with
industrial ovens (embedded Tomcat server), a prep line
(dependency injection), a ticket system (request routing),
a walk-in fridge (database abstraction), and a health
inspector pass (security). You don't have to build any
of this infrastructure — Spring Boot provides it all,
pre-configured, ready to cook in. Your Java skills
let you focus on the recipe, not the kitchen setup.

📖 EXPLANATION:
Spring Boot is the most popular Java framework for
building web APIs, microservices, and enterprise apps.
Everything from this Java course applies directly.

─────────────────────────────────────
WHAT TRANSFERS DIRECTLY:
─────────────────────────────────────
  ✅ All Java syntax and features
  ✅ OOP, interfaces, abstract classes
  ✅ Generics, Collections, Streams
  ✅ Exception handling
  ✅ Lambdas and functional interfaces
  ✅ Design patterns (Spring IS patterns)
  ✅ JDBC (Spring Data JPA wraps it)
  ✅ Annotations (Spring uses them heavily)
  ✅ Reflection (Spring uses it internally)
  ✅ Concurrency (Spring async support)

─────────────────────────────────────
SPRING BOOT CORE CONCEPTS:
─────────────────────────────────────
  IoC Container:
  Spring creates and manages objects ("beans").
  You declare what you need — Spring wires it.

  @Service, @Repository, @Controller, @Component:
  → Marks classes as Spring-managed beans

  @Autowired (or constructor injection):
  → Spring injects dependencies automatically

  @SpringBootApplication:
  → Entry point: combines @Configuration,
    @EnableAutoConfiguration, @ComponentScan

─────────────────────────────────────
BUILDING A REST API:
─────────────────────────────────────
  @RestController
  @RequestMapping("/api/users")
  public class UserController {

      private final UserService service;

      // Constructor injection (preferred over @Autowired)
      UserController(UserService service) {
          this.service = service;
      }

      @GetMapping("/{id}")
      public ResponseEntity<UserDto> getUser(@PathVariable Long id) {
          return service.findById(id)
              .map(ResponseEntity::ok)
              .orElse(ResponseEntity.notFound().build());
      }

      @PostMapping
      public ResponseEntity<UserDto> createUser(
              @RequestBody @Valid CreateUserRequest req) {
          UserDto created = service.create(req);
          return ResponseEntity.status(201).body(created);
      }

      @DeleteMapping("/{id}")
      public ResponseEntity<Void> deleteUser(@PathVariable Long id) {
          service.delete(id);
          return ResponseEntity.noContent().build();
      }
  }

─────────────────────────────────────
SPRING DATA JPA — database access:
─────────────────────────────────────
  @Entity
  @Table(name = "users")
  public class User {
      @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
      private Long id;

      @Column(nullable = false)
      private String name;

      @Column(unique = true)
      private String email;
  }

  public interface UserRepository extends JpaRepository<User, Long> {
      Optional<User> findByEmail(String email);
      List<User> findByNameContaining(String name);
      @Query("SELECT u FROM User u WHERE u.createdAt > :date")
      List<User> findRecentUsers(@Param("date") LocalDate date);
  }

  Spring auto-implements the interface — no SQL needed
  for common queries (derived from method name).

─────────────────────────────────────
APPLICATION PROPERTIES:
─────────────────────────────────────
  # src/main/resources/application.properties
  spring.datasource.url=jdbc:postgresql://localhost:5432/mydb
  spring.datasource.username=postgres
  spring.datasource.password=secret
  spring.jpa.hibernate.ddl-auto=update
  server.port=8080
  logging.level.org.springframework=INFO

─────────────────────────────────────
SPRING BOOT KEY STARTERS:
─────────────────────────────────────
  spring-boot-starter-web         → REST APIs (Tomcat embedded)
  spring-boot-starter-data-jpa    → JPA + Hibernate + DB
  spring-boot-starter-security    → Authentication + Authorization
  spring-boot-starter-validation  → @Valid, @NotNull, @Size etc.
  spring-boot-starter-test        → JUnit 5 + Mockito + MockMvc
  spring-boot-starter-actuator    → health/metrics endpoints
  spring-boot-starter-cache       → @Cacheable abstraction

─────────────────────────────────────
YOUR SPRING BOOT LEARNING PATH:
─────────────────────────────────────
  WEEK 1-2: First REST API
  → spring.io/quickstart — 15-minute first app
  → Create CRUD API (GET/POST/PUT/DELETE)
  → Test with Postman or curl

  WEEK 3-4: Database integration
  → Spring Data JPA + H2 (dev) / PostgreSQL (prod)
  → Entity relationships (@OneToMany, @ManyToOne)
  → Repository queries

  WEEK 5-6: Validation and error handling
  → @Valid + Jakarta Validation (@NotNull, @Size)
  → @ControllerAdvice for global exception handling
  → Custom error responses

  WEEK 7-8: Security
  → Spring Security basics
  → JWT authentication
  → Role-based authorization

  WEEK 9-10: Production concerns
  → Logging with SLF4J/Logback
  → Actuator for health/metrics
  → Docker containerization
  → Deployment (Railway, Render, AWS, GCP)

─────────────────────────────────────
BEST RESOURCES:
─────────────────────────────────────
  📚 Official:
  spring.io/guides              → official tutorials
  spring.io/quickstart          → 5-minute start
  spring.academy                → free Spring courses

  📺 Video:
  Amigoscode (YouTube)          → most popular Spring channel
  Marco Codes (YouTube)          → practical Spring tutorials
  Teddy Smith (YouTube)         → Spring Security

  📖 Books:
  "Spring in Action" (Craig Walls)
  "Spring Boot Up and Running" (Mark Heckler)

  🛠️ Projects to build:
  1. Todo REST API (CRUD + JPA + H2)
  2. User authentication service (JWT + Spring Security)
  3. Product catalog API (Postgres + validation + pagination)
  4. Microservice + API Gateway (Spring Cloud)

💻 CODE:
import java.util.*;
import java.time.*;

// ─── DOMAIN MODEL ─────────────────────────────────────
record UserDto(Long id, String name, String email, LocalDate joinedDate) {}
record CreateUserRequest(String name, String email) {}
record UpdateUserRequest(String name) {}

// ─── SIMPLE SIMULATION OF SPRING BOOT LAYERS ──────────
class User {
    private final Long id;
    private String name;
    private final String email;
    private final LocalDate joinedDate;

    User(Long id, String name, String email) {
        this.id = id; this.name = name;
        this.email = email; this.joinedDate = LocalDate.now();
    }

    UserDto toDto() { return new UserDto(id, name, email, joinedDate); }
    Long getId() { return id; }
    String getName() { return name; }
    String getEmail() { return email; }
    void setName(String name) { this.name = name; }
}

// Repository layer (normally: extends JpaRepository<User, Long>)
class UserRepository {
    private final Map<Long, User> db = new LinkedHashMap<>();
    private long nextId = 1;

    User save(User user) { db.put(user.getId(), user); return user; }
    Optional<User> findById(Long id) { return Optional.ofNullable(db.get(id)); }
    Optional<User> findByEmail(String email) {
        return db.values().stream()
            .filter(u -> u.getEmail().equals(email)).findFirst();
    }
    List<User> findAll() { return new ArrayList<>(db.values()); }
    void deleteById(Long id) { db.remove(id); }
    long count() { return db.size(); }
    long nextId() { return nextId++; }
}

// Service layer — business logic
class UserService {
    private final UserRepository repo;

    UserService(UserRepository repo) { this.repo = repo; }

    List<UserDto> getAllUsers() {
        return repo.findAll().stream().map(User::toDto).toList();
    }

    Optional<UserDto> findById(Long id) {
        return repo.findById(id).map(User::toDto);
    }

    UserDto createUser(CreateUserRequest req) {
        if (req.name().isBlank()) throw new IllegalArgumentException("Name required");
        if (!req.email().contains("@")) throw new IllegalArgumentException("Invalid email");
        if (repo.findByEmail(req.email()).isPresent())
            throw new IllegalStateException("Email already exists: " + req.email());
        User user = new User(repo.nextId(), req.name().strip(), req.email().toLowerCase());
        return repo.save(user).toDto();
    }

    UserDto updateUser(Long id, UpdateUserRequest req) {
        User user = repo.findById(id)
            .orElseThrow(() -> new NoSuchElementException("User not found: " + id));
        user.setName(req.name().strip());
        return repo.save(user).toDto();
    }

    void deleteUser(Long id) {
        if (repo.findById(id).isEmpty())
            throw new NoSuchElementException("User not found: " + id);
        repo.deleteById(id);
    }
}

// Controller layer — HTTP handling
record HttpRequest(String method, String path, Object body) {}
record HttpResponse(int status, Object body) {}

class UserController {
    private final UserService service;
    UserController(UserService service) { this.service = service; }

    HttpResponse handle(HttpRequest req) {
        try {
            return switch (req.method()) {
                case "GET_ALL"  -> new HttpResponse(200, service.getAllUsers());
                case "GET"      -> service.findById((Long) req.body())
                    .map(dto -> new HttpResponse(200, dto))
                    .orElse(new HttpResponse(404, "User not found"));
                case "POST"     -> new HttpResponse(201, service.createUser((CreateUserRequest) req.body()));
                case "PUT"      -> new HttpResponse(200, service.updateUser(
                    Long.parseLong(req.path().split("/")[2]),
                    (UpdateUserRequest) req.body()));
                case "DELETE"   -> {
                    service.deleteUser((Long) req.body());
                    yield new HttpResponse(204, null);
                }
                default         -> new HttpResponse(405, "Method not allowed");
            };
        } catch (IllegalArgumentException e) {
            return new HttpResponse(400, e.getMessage());
        } catch (IllegalStateException e) {
            return new HttpResponse(409, e.getMessage());
        } catch (NoSuchElementException e) {
            return new HttpResponse(404, e.getMessage());
        }
    }
}

public class SpringBootBridge {
    public static void main(String[] args) {
        System.out.println("=== Spring Boot Architecture Demo ===\n");

        // Wire the layers (Spring does this automatically with @Autowired)
        UserRepository repo = new UserRepository();
        UserService service = new UserService(repo);
        UserController ctrl = new UserController(service);

        // Simulate HTTP requests
        System.out.println("--- POST /api/users ---");
        printResponse(ctrl.handle(new HttpRequest("POST", "/api/users",
            new CreateUserRequest("Alice Chen", "alice@example.com"))));
        printResponse(ctrl.handle(new HttpRequest("POST", "/api/users",
            new CreateUserRequest("Bob Smith", "bob@example.com"))));
        printResponse(ctrl.handle(new HttpRequest("POST", "/api/users",
            new CreateUserRequest("Carol Davis", "carol@example.com"))));

        System.out.println("\n--- GET /api/users ---");
        printResponse(ctrl.handle(new HttpRequest("GET_ALL", "/api/users", null)));

        System.out.println("\n--- GET /api/users/1 ---");
        printResponse(ctrl.handle(new HttpRequest("GET", "/api/users/1", 1L)));

        System.out.println("\n--- GET /api/users/99 (not found) ---");
        printResponse(ctrl.handle(new HttpRequest("GET", "/api/users/99", 99L)));

        System.out.println("\n--- POST /api/users (duplicate email) ---");
        printResponse(ctrl.handle(new HttpRequest("POST", "/api/users",
            new CreateUserRequest("Alice2", "alice@example.com"))));

        System.out.println("\n--- POST /api/users (invalid) ---");
        printResponse(ctrl.handle(new HttpRequest("POST", "/api/users",
            new CreateUserRequest("", "not-an-email"))));

        System.out.println("\n--- DELETE /api/users/2 ---");
        printResponse(ctrl.handle(new HttpRequest("DELETE", "/api/users/2", 2L)));

        System.out.println("\n--- GET /api/users (after delete) ---");
        printResponse(ctrl.handle(new HttpRequest("GET_ALL", "/api/users", null)));

        System.out.println("\n=== Spring Boot Quick Reference ===\n");
        System.out.println("  Get started in 5 minutes: spring.io/quickstart");
        System.out.println("  Generate a project:       start.spring.io");
        System.out.println();
        System.out.println("  Key annotations learned:  @RestController, @Service,");
        System.out.println("  @Repository, @Entity, @GetMapping, @PostMapping,");
        System.out.println("  @RequestBody, @PathVariable, @Valid, @Autowired");
    }

    static void printResponse(HttpResponse r) {
        String statusIcon = r.status() < 300 ? "✅" : r.status() < 500 ? "⚠️ " : "❌";
        System.out.printf("  %s HTTP %d: %s%n", statusIcon, r.status(),
            r.body() instanceof List<?> list
                ? "[" + list.size() + " items] " + list
                : r.body());
    }
}

📝 KEY POINTS:
✅ Spring Boot auto-configures based on JAR dependencies — no XML needed
✅ @RestController = @Controller + @ResponseBody — returns JSON automatically
✅ Constructor injection is preferred over @Autowired field injection
✅ Spring Data JPA auto-implements repositories — no SQL for standard queries
✅ @Valid + Jakarta Validation annotations validate request bodies automatically
✅ @ControllerAdvice handles exceptions globally — clean, DRY error handling
✅ application.properties configures everything: DB URL, port, log levels
✅ spring.io/quickstart gets you a running app in under 5 minutes
✅ start.spring.io generates a project skeleton with chosen dependencies
❌ Don't use field injection (@Autowired on fields) — prefer constructor injection
❌ Don't write SQL manually for common queries — use Spring Data JPA derived queries
❌ Don't ignore security — add spring-boot-starter-security before going live
❌ Don't deploy without health checks — add spring-boot-starter-actuator
""",
  quiz: [
    Quiz(question: 'What does @RestController do differently than @Controller in Spring?', options: [
      QuizOption(text: '@RestController combines @Controller + @ResponseBody — methods return data serialized as JSON, not view names', correct: true),
      QuizOption(text: '@RestController is required for handling GET requests; @Controller handles POST only', correct: false),
      QuizOption(text: '@RestController creates a singleton bean; @Controller creates a new instance per request', correct: false),
      QuizOption(text: 'They are identical — @RestController is just a shorter alias for @Controller', correct: false),
    ]),
    Quiz(question: 'What does Spring Data JPA\'s method findByEmail(String email) do without any implementation code?', options: [
      QuizOption(text: 'Spring auto-implements it by parsing the method name and generating the appropriate SELECT WHERE query', correct: true),
      QuizOption(text: 'It throws an AbstractMethodError at runtime if no implementation is provided', correct: false),
      QuizOption(text: 'Spring searches all @Entity classes for a field named "email" and returns matches', correct: false),
      QuizOption(text: 'The method requires @Query annotation — Spring cannot derive queries without explicit SQL', correct: false),
    ]),
    Quiz(question: 'Why is constructor injection preferred over @Autowired field injection in Spring?', options: [
      QuizOption(text: 'Constructor injection makes dependencies explicit, supports immutability (final fields), and works without Spring for testing', correct: true),
      QuizOption(text: 'Field injection with @Autowired causes circular dependency exceptions more often', correct: false),
      QuizOption(text: 'Constructor injection is the only injection type supported in Spring Boot 3+', correct: false),
      QuizOption(text: 'Field injection requires additional configuration; constructor injection works with default settings', correct: false),
    ]),
  ],
);

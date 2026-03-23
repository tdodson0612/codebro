import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson33 = Lesson(
  language: 'Java',
  title: 'Annotations',
  content: """
🎯 METAPHOR:
Annotations are like sticky labels on items in a warehouse.
The items (your code) work perfectly without labels.
But labels give METADATA to the people and systems that
process them: "@FRAGILE" tells movers to be careful,
"@PERISHABLE" tells logistics to expedite, "@PRIORITY"
tells the dispatch team to move it first. The warehouse
workers (compiler, frameworks, tools) read these labels
and change how they handle the items — without the items
themselves knowing or changing. @Override tells the
compiler "double-check this." @Deprecated tells the IDE
"warn users." @Autowired tells Spring "inject a dependency
here." The item (code) is unchanged; the annotation
adds instructions for the processors.

📖 EXPLANATION:
Annotations are metadata attached to Java code elements.
They have no direct effect on program execution —
their effects come from tools, frameworks, and the compiler
that READ and PROCESS them.

─────────────────────────────────────
BUILT-IN JAVA ANNOTATIONS:
─────────────────────────────────────
  @Override           → verify this overrides a parent method
  @Deprecated         → mark as outdated (with @since, @see)
  @SuppressWarnings   → suppress specific compiler warnings
  @FunctionalInterface→ enforce single abstract method
  @SafeVarargs        → suppress unsafe varargs warnings
  @Native             → mark constant used in native code

  Meta-annotations (on annotation definitions):
  @Target             → where annotation can be applied
  @Retention          → how long annotation lives
  @Documented         → include in Javadoc
  @Inherited          → subclasses inherit the annotation
  @Repeatable         → can be applied multiple times

─────────────────────────────────────
@Target — where can it be applied:
─────────────────────────────────────
  ElementType.TYPE             → class, interface, enum
  ElementType.METHOD           → methods
  ElementType.FIELD            → fields
  ElementType.PARAMETER        → method parameters
  ElementType.CONSTRUCTOR      → constructors
  ElementType.LOCAL_VARIABLE   → local variables
  ElementType.ANNOTATION_TYPE  → other annotations
  ElementType.PACKAGE          → package declarations
  ElementType.TYPE_PARAMETER   → generic type params
  ElementType.TYPE_USE         → any type use

─────────────────────────────────────
@Retention — how long it survives:
─────────────────────────────────────
  RetentionPolicy.SOURCE   → in source only, discarded at compile
  RetentionPolicy.CLASS    → in .class file, NOT in runtime
  RetentionPolicy.RUNTIME  → available at runtime via reflection

─────────────────────────────────────
CREATING CUSTOM ANNOTATIONS:
─────────────────────────────────────
  @Target(ElementType.METHOD)
  @Retention(RetentionPolicy.RUNTIME)
  public @interface LogCall {
      String level() default "INFO";
      boolean includeArgs() default false;
  }

  Usage:
  @LogCall(level = "DEBUG", includeArgs = true)
  public void processOrder(Order order) { ... }

─────────────────────────────────────
READING ANNOTATIONS VIA REFLECTION:
─────────────────────────────────────
  Method method = MyClass.class.getMethod("processOrder", Order.class);
  if (method.isAnnotationPresent(LogCall.class)) {
      LogCall annotation = method.getAnnotation(LogCall.class);
      System.out.println("Level: " + annotation.level());
  }

─────────────────────────────────────
COMMON FRAMEWORK ANNOTATIONS:
─────────────────────────────────────
  Spring:
  @Component, @Service, @Repository, @Controller
  @Autowired, @Qualifier, @Value
  @RequestMapping, @GetMapping, @PostMapping
  @Transactional, @Scheduled, @Async

  JPA/Hibernate:
  @Entity, @Table, @Id, @Column, @GeneratedValue
  @OneToMany, @ManyToOne, @JoinColumn

  JUnit 5:
  @Test, @BeforeEach, @AfterEach, @DisplayName
  @ParameterizedTest, @ValueSource, @Disabled

  Jakarta Validation:
  @NotNull, @NotBlank, @Size, @Min, @Max, @Email
  @Pattern, @Valid

💻 CODE:
import java.lang.annotation.*;
import java.lang.reflect.*;
import java.util.*;

// ─── CUSTOM ANNOTATIONS ───────────────────────────────

@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
@interface LogCall {
    String level() default "INFO";
    boolean includeArgs() default true;
    String description() default "";
}

@Target(ElementType.FIELD)
@Retention(RetentionPolicy.RUNTIME)
@interface Validate {
    int minLength() default 0;
    int maxLength() default Integer.MAX_VALUE;
    boolean required() default true;
    String pattern() default ".*";
}

@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@interface Entity {
    String tableName();
    boolean cached() default false;
}

@Target(ElementType.FIELD)
@Retention(RetentionPolicy.RUNTIME)
@interface Column {
    String name() default "";
    boolean primaryKey() default false;
    boolean nullable() default true;
}

// ─── ANNOTATED CLASSES ────────────────────────────────

@Entity(tableName = "users", cached = true)
class User {
    @Column(name = "user_id", primaryKey = true, nullable = false)
    @Validate(required = true)
    private int id;

    @Column(name = "username", nullable = false)
    @Validate(minLength = 3, maxLength = 20, pattern = "[a-zA-Z0-9_]+")
    private String username;

    @Column(name = "email")
    @Validate(pattern = ".+@.+\\..+")
    private String email;

    @Column(name = "age")
    private int age;

    public User(int id, String username, String email, int age) {
        this.id = id; this.username = username;
        this.email = email; this.age = age;
    }

    @LogCall(level = "DEBUG", description = "Retrieve user greeting")
    public String greet() { return "Hello, " + username + "!"; }

    @LogCall(level = "INFO")
    @Deprecated(since = "2.0")
    public String getDisplayName() { return username; }

    public int getId()        { return id;       }
    public String getUsername(){ return username; }
    public String getEmail()  { return email;     }
    public int getAge()       { return age;       }
}

// ─── ANNOTATION PROCESSORS ────────────────────────────

class EntityInspector {
    public static void inspectEntity(Class<?> clazz) {
        System.out.println("=== Entity Inspection: " + clazz.getSimpleName() + " ===");

        Entity entity = clazz.getAnnotation(Entity.class);
        if (entity != null) {
            System.out.println("  Table: " + entity.tableName() + " | Cached: " + entity.cached());
        }

        System.out.println("  Columns:");
        for (Field field : clazz.getDeclaredFields()) {
            Column col = field.getAnnotation(Column.class);
            Validate val = field.getAnnotation(Validate.class);

            if (col != null) {
                String colName = col.name().isEmpty() ? field.getName() : col.name();
                String pk = col.primaryKey() ? " [PK]" : "";
                String nn = !col.nullable() ? " NOT NULL" : "";
                String req = (val != null && val.required()) ? " REQUIRED" : "";
                System.out.printf("    %-15s → %-20s%s%s%s%n",
                    field.getName(), colName, pk, nn, req);

                if (val != null && (val.minLength() > 0 || val.maxLength() < Integer.MAX_VALUE
                        || !val.pattern().equals(".*"))) {
                    System.out.printf("      validation: len[%d-%d] pattern='%s'%n",
                        val.minLength(), val.maxLength(), val.pattern());
                }
            }
        }
    }
}

class MethodLogger {
    public static void logAnnotatedMethods(Class<?> clazz) {
        System.out.println("\n=== Annotated Methods: " + clazz.getSimpleName() + " ===");

        for (Method method : clazz.getDeclaredMethods()) {
            LogCall logCall = method.getAnnotation(LogCall.class);
            if (logCall != null) {
                System.out.printf("  @LogCall on %s():%n", method.getName());
                System.out.printf("    level=%s includeArgs=%s%n",
                    logCall.level(), logCall.includeArgs());
                if (!logCall.description().isEmpty()) {
                    System.out.println("    description=" + logCall.description());
                }

                // Check for other annotations on same method
                if (method.isAnnotationPresent(Deprecated.class)) {
                    Deprecated dep = method.getAnnotation(Deprecated.class);
                    System.out.printf("    ⚠️  @Deprecated since %s%n", dep.since());
                }
            }
        }
    }
}

// ─── SIMPLE VALIDATOR USING ANNOTATIONS ───────────────

class AnnotationValidator {
    public static List<String> validate(Object obj) {
        List<String> errors = new ArrayList<>();
        Class<?> clazz = obj.getClass();

        for (Field field : clazz.getDeclaredFields()) {
            Validate v = field.getAnnotation(Validate.class);
            if (v == null) continue;

            field.setAccessible(true);
            try {
                Object value = field.get(obj);
                String fieldName = field.getName();

                if (v.required() && (value == null || value.toString().isEmpty())) {
                    errors.add(fieldName + ": required but missing");
                    continue;
                }

                if (value instanceof String s) {
                    if (s.length() < v.minLength())
                        errors.add(fieldName + ": too short (min " + v.minLength() + ")");
                    if (s.length() > v.maxLength())
                        errors.add(fieldName + ": too long (max " + v.maxLength() + ")");
                    if (!v.pattern().equals(".*") && !s.matches(v.pattern()))
                        errors.add(fieldName + ": doesn't match pattern " + v.pattern());
                }
            } catch (IllegalAccessException e) {
                errors.add(field.getName() + ": could not access");
            }
        }
        return errors;
    }
}

public class Annotations {
    public static void main(String[] args) throws Exception {

        // ─── ENTITY INSPECTION ────────────────────────────
        EntityInspector.inspectEntity(User.class);

        // ─── METHOD LOGGING METADATA ──────────────────────
        MethodLogger.logAnnotatedMethods(User.class);

        // ─── RUNTIME VALIDATION ───────────────────────────
        System.out.println("\n=== Validation ===");
        User valid   = new User(1, "terry99", "terry@test.com", 30);
        User invalid = new User(2, "ab", "notanemail", 25);

        List<String> validErrors   = AnnotationValidator.validate(valid);
        List<String> invalidErrors = AnnotationValidator.validate(invalid);

        System.out.println("  Valid user errors:   " +
            (validErrors.isEmpty() ? "✅ None" : validErrors));
        System.out.println("  Invalid user errors: " + invalidErrors);

        // ─── BUILT-IN ANNOTATIONS ─────────────────────────
        System.out.println("\n=== Built-in Annotations ===");
        User user = new User(1, "terry", "t@test.com", 30);

        // @Override verified at compile time
        System.out.println("  greet(): " + user.greet());

        // @Deprecated — still callable, just warned
        @SuppressWarnings("deprecation")
        String name = user.getDisplayName();
        System.out.println("  getDisplayName() (deprecated): " + name);

        // @SuppressWarnings
        @SuppressWarnings({"unchecked", "rawtypes"})
        List rawList = new ArrayList();
        rawList.add("suppressed warning");
        System.out.println("  Suppressed warning list: " + rawList);

        // Check if annotations present at runtime
        System.out.println("\n=== Runtime annotation checks ===");
        Method greetMethod = User.class.getMethod("greet");
        System.out.println("  greet() has @LogCall: " +
            greetMethod.isAnnotationPresent(LogCall.class));

        Class<?> userClass = User.class;
        System.out.println("  User has @Entity: " +
            userClass.isAnnotationPresent(Entity.class));
        System.out.println("  User has @Validate: " +
            userClass.isAnnotationPresent(Validate.class));  // false — @Validate is for fields
    }
}

📝 KEY POINTS:
✅ Annotations are metadata — they don't change behavior directly
✅ @Override, @Deprecated, @SuppressWarnings are the most-used built-ins
✅ @Retention(RUNTIME) is required for annotation to be readable via reflection
✅ @Target restricts where an annotation can be applied
✅ Custom annotations use @interface syntax and can have default values
✅ Frameworks (Spring, JPA, JUnit) use annotations as configuration
✅ Annotation processing happens at compile time (APT) or runtime (reflection)
✅ @Documented includes the annotation in generated Javadoc
❌ Annotations with SOURCE retention cannot be read at runtime
❌ Annotation elements can only be primitives, Strings, enums, Class, other annotations, or arrays of these
❌ Don't use annotations as a replacement for clear code — over-annotation obscures intent
❌ @SuppressWarnings should be used sparingly — warnings usually indicate real issues
""",
  quiz: [
    Quiz(question: 'What does @Retention(RetentionPolicy.RUNTIME) mean for an annotation?', options: [
      QuizOption(text: 'The annotation is available at runtime and can be read via reflection', correct: true),
      QuizOption(text: 'The annotation causes its logic to run repeatedly at runtime', correct: false),
      QuizOption(text: 'The annotation is stripped from bytecode but kept in source', correct: false),
      QuizOption(text: 'The annotation is compiled into the class but discarded at runtime', correct: false),
    ]),
    Quiz(question: 'What is the syntax for defining a custom annotation in Java?', options: [
      QuizOption(text: 'public @interface MyAnnotation { }', correct: true),
      QuizOption(text: 'public annotation MyAnnotation { }', correct: false),
      QuizOption(text: 'public class MyAnnotation extends Annotation { }', correct: false),
      QuizOption(text: '@Annotation public interface MyAnnotation { }', correct: false),
    ]),
    Quiz(question: 'What does @Target(ElementType.METHOD) specify?', options: [
      QuizOption(text: 'The annotation can only be applied to methods — not classes, fields, or parameters', correct: true),
      QuizOption(text: 'The annotation targets the method\'s return type specifically', correct: false),
      QuizOption(text: 'The annotation applies to the method and all types it references', correct: false),
      QuizOption(text: 'The annotation is inherited by overriding methods in subclasses', correct: false),
    ]),
  ],
);

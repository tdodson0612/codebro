import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson34 = Lesson(
  language: 'Java',
  title: 'Reflection',
  content: """
🎯 METAPHOR:
Reflection is like a building's building-information model
(BIM) — a detailed digital blueprint of the building while
it's already built and occupied. Normal code uses the
building: opens doors, turns on lights. Reflection reads
the blueprint AT RUNTIME: "How many rooms are there?
What are the doors made of? Is this wall load-bearing?"
It can even modify the building: "Tear out this wall
(access a private field), change the door color (modify
a field's value), or add a room (create a new instance
via constructor)." Reflection gives your code the ability
to inspect and manipulate other code — even code it knew
nothing about at compile time. Powerful. Slow. Use with care.

📖 EXPLANATION:
Reflection (java.lang.reflect) lets code examine and
manipulate classes, methods, fields, and constructors
AT RUNTIME — even private ones (with setAccessible).

─────────────────────────────────────
GETTING A Class<?> OBJECT:
─────────────────────────────────────
  // Three ways:
  Class<?> c1 = String.class;           // compile-time literal
  Class<?> c2 = "hello".getClass();     // from instance
  Class<?> c3 = Class.forName("java.lang.String"); // by name (throws)

─────────────────────────────────────
CLASS INFORMATION:
─────────────────────────────────────
  clazz.getName()              → "com.example.MyClass"
  clazz.getSimpleName()        → "MyClass"
  clazz.getPackageName()       → "com.example"
  clazz.getSuperclass()        → parent Class
  clazz.getInterfaces()        → implemented interfaces
  clazz.getModifiers()         → access flags (use Modifier.isX())
  clazz.isInterface()          → true if interface
  clazz.isEnum()               → true if enum
  clazz.isAnnotation()         → true if annotation
  clazz.isAnonymousClass()     → true if anonymous
  clazz.getDeclaredFields()    → all fields (incl. private)
  clazz.getFields()            → only public fields (incl. inherited)
  clazz.getDeclaredMethods()   → all methods (incl. private)
  clazz.getMethods()           → public methods (incl. inherited)
  clazz.getDeclaredConstructors() → all constructors
  clazz.getAnnotations()       → annotations on this class

─────────────────────────────────────
WORKING WITH FIELDS:
─────────────────────────────────────
  Field field = clazz.getDeclaredField("name");
  field.setAccessible(true);  // bypass private access

  // Read:
  Object value = field.get(instance);

  // Write:
  field.set(instance, "new value");

  // Field info:
  field.getName()         → "name"
  field.getType()         → String.class
  field.getModifiers()    → Modifier.PRIVATE etc.
  field.getAnnotations()  → annotations on this field

─────────────────────────────────────
WORKING WITH METHODS:
─────────────────────────────────────
  Method method = clazz.getDeclaredMethod("greet", String.class);
  method.setAccessible(true);
  Object result = method.invoke(instance, "Terry");

  method.getName()
  method.getReturnType()
  method.getParameterTypes()
  method.getModifiers()
  method.getAnnotations()

─────────────────────────────────────
WORKING WITH CONSTRUCTORS:
─────────────────────────────────────
  Constructor<?> ctor = clazz.getDeclaredConstructor(String.class, int.class);
  ctor.setAccessible(true);
  Object newInstance = ctor.newInstance("Terry", 30);

─────────────────────────────────────
WHEN TO USE REFLECTION:
─────────────────────────────────────
  ✅ Frameworks (Spring, JPA, JUnit) — dependency injection,
     ORM mapping, test discovery
  ✅ Serialization libraries (Jackson, Gson)
  ✅ Plugin systems — load and call code at runtime
  ✅ Debugging and inspection tools
  ❌ Regular application code — too slow, bypasses safety
  ❌ Never use setAccessible(true) on production code
     you control — redesign instead

💻 CODE:
import java.lang.reflect.*;
import java.util.*;

// ─── CLASSES TO INSPECT ───────────────────────────────
class Vehicle {
    private String make;
    protected int year;
    public String color;

    private static int instanceCount = 0;

    public Vehicle(String make, int year, String color) {
        this.make = make; this.year = year; this.color = color;
        instanceCount++;
    }

    protected Vehicle(String make) {
        this(make, 2024, "White");
    }

    public String getMake() { return make; }
    public int getYear()    { return year; }

    private String secretMethod() { return "Secret from " + make; }

    @Override
    public String toString() { return make + " (" + year + ")"; }
}

class ElectricVehicle extends Vehicle implements Comparable<ElectricVehicle> {
    private int rangeKm;

    public ElectricVehicle(String make, int year, int rangeKm) {
        super(make, year, "White");
        this.rangeKm = rangeKm;
    }

    @Override
    public int compareTo(ElectricVehicle other) {
        return Integer.compare(this.rangeKm, other.rangeKm);
    }

    public int getRange() { return rangeKm; }
}

// ─── SIMPLE DI CONTAINER ──────────────────────────────
@interface Inject { }

class DatabaseService {
    public String query(String sql) { return "Result of: " + sql; }
}

class UserService {
    @Inject
    private DatabaseService db;

    public String getUser(int id) {
        return db.query("SELECT * FROM users WHERE id = " + id);
    }
}

class SimpleContainer {
    private final Map<Class<?>, Object> beans = new HashMap<>();

    public void register(Object bean) { beans.put(bean.getClass(), bean); }

    @SuppressWarnings("unchecked")
    public <T> T get(Class<T> type) { return (T) beans.get(type); }

    public void inject(Object target) throws Exception {
        for (Field f : target.getClass().getDeclaredFields()) {
            if (f.isAnnotationPresent(Inject.class)) {
                Object dep = beans.get(f.getType());
                if (dep != null) {
                    f.setAccessible(true);
                    f.set(target, dep);
                    System.out.printf("  Injected %s into %s.%s%n",
                        f.getType().getSimpleName(),
                        target.getClass().getSimpleName(),
                        f.getName());
                }
            }
        }
    }
}

public class ReflectionDemo {
    public static void main(String[] args) throws Exception {

        // ─── CLASS INSPECTION ─────────────────────────────
        System.out.println("=== Class Inspection ===");
        Class<?> evClass = ElectricVehicle.class;

        System.out.println("  Name:         " + evClass.getName());
        System.out.println("  Simple name:  " + evClass.getSimpleName());
        System.out.println("  Package:      " + evClass.getPackageName());
        System.out.println("  Superclass:   " + evClass.getSuperclass().getSimpleName());
        System.out.println("  Interfaces:   " +
            Arrays.toString(Arrays.stream(evClass.getInterfaces())
                .map(Class::getSimpleName).toArray()));
        System.out.println("  Is enum:      " + evClass.isEnum());
        System.out.println("  Is interface: " + evClass.isInterface());

        // ─── FIELD INSPECTION ─────────────────────────────
        System.out.println("\n=== Field Inspection ===");
        System.out.println("  All declared fields (Vehicle):");
        for (Field f : Vehicle.class.getDeclaredFields()) {
            String mods = Modifier.toString(f.getModifiers());
            System.out.printf("    %-10s %-8s %s%n",
                mods.isEmpty() ? "(package)" : mods,
                f.getType().getSimpleName(), f.getName());
        }

        // ─── METHOD INSPECTION ────────────────────────────
        System.out.println("\n=== Method Inspection ===");
        System.out.println("  Public methods (inherited too):");
        for (Method m : ElectricVehicle.class.getMethods()) {
            if (!m.getDeclaringClass().equals(Object.class)) {
                System.out.printf("    %s %s(%s)%n",
                    m.getReturnType().getSimpleName(),
                    m.getName(),
                    String.join(", ", Arrays.stream(m.getParameterTypes())
                        .map(Class::getSimpleName).toArray(String[]::new)));
            }
        }

        // ─── ACCESSING PRIVATE MEMBERS ────────────────────
        System.out.println("\n=== Accessing Private Members ===");
        Vehicle car = new Vehicle("Tesla", 2024, "Red");

        // Read private field
        Field makeField = Vehicle.class.getDeclaredField("make");
        makeField.setAccessible(true);
        String makeValue = (String) makeField.get(car);
        System.out.println("  Private 'make' field: " + makeValue);

        // Modify private field
        makeField.set(car, "NIO");
        System.out.println("  After modification: " + makeField.get(car));

        // Call private method
        Method secret = Vehicle.class.getDeclaredMethod("secretMethod");
        secret.setAccessible(true);
        String secretResult = (String) secret.invoke(car);
        System.out.println("  Private method result: " + secretResult);

        // ─── CREATE INSTANCE VIA REFLECTION ───────────────
        System.out.println("\n=== Create Instances via Reflection ===");

        // Use public constructor
        Constructor<Vehicle> publicCtor = Vehicle.class.getDeclaredConstructor(
            String.class, int.class, String.class);
        Vehicle v1 = publicCtor.newInstance("BMW", 2023, "Blue");
        System.out.println("  Via 3-arg ctor: " + v1);

        // Use protected constructor
        Constructor<Vehicle> protectedCtor = Vehicle.class.getDeclaredConstructor(String.class);
        protectedCtor.setAccessible(true);
        Vehicle v2 = protectedCtor.newInstance("Audi");
        System.out.println("  Via protected ctor: " + v2);

        // ─── SIMPLE DI CONTAINER ──────────────────────────
        System.out.println("\n=== Simple Dependency Injection ===");
        SimpleContainer container = new SimpleContainer();
        container.register(new DatabaseService());

        UserService userService = new UserService();
        container.inject(userService);      // injects DatabaseService via reflection

        String result = userService.getUser(42);
        System.out.println("  Result: " + result);

        // ─── GENERIC TYPE INSPECTION ──────────────────────
        System.out.println("\n=== Generic Type Information ===");
        class GenericHolder {
            public List<String> stringList;
            public Map<String, Integer> scoreMap;
        }

        for (Field field : GenericHolder.class.getDeclaredFields()) {
            Type genericType = field.getGenericType();
            System.out.printf("  %s → %s%n", field.getName(), genericType.getTypeName());
        }

        // ─── ANNOTATIONS VIA REFLECTION ───────────────────
        System.out.println("\n=== Annotations on Fields ===");
        for (Field f : UserService.class.getDeclaredFields()) {
            System.out.printf("  %s: annotations = %s%n",
                f.getName(), Arrays.toString(f.getAnnotations()));
        }
    }
}

📝 KEY POINTS:
✅ getDeclaredX() gets ALL members (incl. private) of THIS class only
✅ getX() gets only public members including inherited ones
✅ setAccessible(true) bypasses access checks — use sparingly
✅ method.invoke(instance, args) calls a method reflectively
✅ constructor.newInstance(args) creates an instance reflectively
✅ field.get(instance) reads; field.set(instance, value) writes
✅ Reflection enables frameworks: Spring DI, JPA, JUnit, Jackson
✅ getGenericType() preserves generic type info for fields/methods
❌ Reflection is 10-50x slower than direct method calls — avoid in hot paths
❌ setAccessible(true) breaks encapsulation — only for frameworks
❌ Class.forName() throws ClassNotFoundException — always handle it
❌ The Java module system (Java 9+) restricts reflective access to modules
""",
  quiz: [
    Quiz(question: 'What is the difference between getDeclaredFields() and getFields()?', options: [
      QuizOption(text: 'getDeclaredFields() gets ALL fields of this class including private; getFields() gets only public fields including inherited ones', correct: true),
      QuizOption(text: 'getDeclaredFields() is faster; getFields() includes annotations', correct: false),
      QuizOption(text: 'getFields() gets all fields; getDeclaredFields() gets only non-inherited fields', correct: false),
      QuizOption(text: 'They are identical — the naming difference is historical', correct: false),
    ]),
    Quiz(question: 'What does field.setAccessible(true) do?', options: [
      QuizOption(text: 'Bypasses Java\'s access control checks, allowing reading/writing of private fields via reflection', correct: true),
      QuizOption(text: 'Makes the field public permanently in the class definition', correct: false),
      QuizOption(text: 'Enables concurrent access to the field from multiple threads', correct: false),
      QuizOption(text: 'Unlocks the field for modification even if it\'s declared final', correct: false),
    ]),
    Quiz(question: 'What is the primary reason to AVOID reflection in performance-critical code?', options: [
      QuizOption(text: 'Reflection is 10-50x slower than direct method calls due to dynamic lookups and security checks', correct: true),
      QuizOption(text: 'Reflection is not thread-safe and causes race conditions', correct: false),
      QuizOption(text: 'Reflection prevents the JVM from garbage-collecting reflected classes', correct: false),
      QuizOption(text: 'Reflection requires additional memory that is never released', correct: false),
    ]),
  ],
);

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson19 = Lesson(
  language: 'Java',
  title: 'Enums',
  content: """
🎯 METAPHOR:
An enum is like the seasons of the year. There are exactly
FOUR: Spring, Summer, Autumn, Winter. You can't invent a
fifth season. You can't use a made-up season name. The set
is fixed and known. But each season isn't just a name —
Summer has longer days, Winter has shorter ones. They have
properties. They have behavior: "Is it cold?" returns true
for Winter and false for Summer. Java enums are the same:
a fixed, named set of constants, each of which can carry
its own data and behavior. Way more powerful than just
naming numbers 1, 2, 3, 4.

📖 EXPLANATION:
Enums (enumerations) are a special class type in Java
representing a fixed set of named constants. Unlike simple
constant ints, Java enums are full objects with fields,
methods, and constructors.

─────────────────────────────────────
BASIC ENUM:
─────────────────────────────────────
  enum Day {
      MONDAY, TUESDAY, WEDNESDAY, THURSDAY,
      FRIDAY, SATURDAY, SUNDAY
  }

  Day today = Day.FRIDAY;
  System.out.println(today);         // FRIDAY
  System.out.println(today.name());  // "FRIDAY"
  System.out.println(today.ordinal()); // 4 (0-indexed position)

─────────────────────────────────────
ENUM BUILT-IN METHODS:
─────────────────────────────────────
  Day.values()            → Day[] of all constants
  Day.valueOf("FRIDAY")   → Day.FRIDAY (by name)
  day.name()              → "FRIDAY" (String)
  day.ordinal()           → 4 (int position, 0-based)

─────────────────────────────────────
ENUM WITH FIELDS AND METHODS:
─────────────────────────────────────
  enum Planet {
      MERCURY(3.303e+23, 2.4397e6),
      EARTH  (5.976e+24, 6.37814e6);

      private final double mass;
      private final double radius;

      Planet(double mass, double radius) {  // constructor
          this.mass   = mass;
          this.radius = radius;
      }

      static final double G = 6.67300E-11;

      double surfaceGravity() {
          return G * mass / (radius * radius);
      }

      double weightOn(double otherWeight) {
          return otherWeight * surfaceGravity() / 9.80665;
      }
  }

─────────────────────────────────────
ENUM WITH ABSTRACT METHOD:
─────────────────────────────────────
  enum Operation {
      ADD    { @Override public int apply(int a, int b) { return a + b; } },
      SUB    { @Override public int apply(int a, int b) { return a - b; } },
      MUL    { @Override public int apply(int a, int b) { return a * b; } },
      DIV    { @Override public int apply(int a, int b) { return a / b; } };

      public abstract int apply(int a, int b);
  }

  Operation.ADD.apply(5, 3);   // 8

─────────────────────────────────────
ENUM IMPLEMENTING INTERFACE:
─────────────────────────────────────
  interface Describable { String describe(); }

  enum Season implements Describable {
      SPRING { @Override public String describe() { return "Flowers bloom"; } },
      SUMMER { @Override public String describe() { return "Beach time!"; } };
  }

─────────────────────────────────────
ENUM IN switch:
─────────────────────────────────────
  Day day = Day.SATURDAY;
  String type = switch (day) {
      case MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY -> "Weekday";
      case SATURDAY, SUNDAY -> "Weekend!";
  };
  // Note: no default needed — compiler verifies all cases covered

─────────────────────────────────────
ENUM AS SINGLETON:
─────────────────────────────────────
  enum AppDatabase {
      INSTANCE;

      public void query(String sql) {
          System.out.println("Running: " + sql);
      }
  }

  AppDatabase.INSTANCE.query("SELECT * FROM users");
  // Thread-safe, serialization-safe singleton!

💻 CODE:
import java.util.EnumMap;
import java.util.EnumSet;
import java.util.Map;

// ─── BASIC ENUM ───────────────────────────────────────
enum Status {
    PENDING, PROCESSING, SHIPPED, DELIVERED, CANCELLED;

    public boolean isTerminal() {
        return this == DELIVERED || this == CANCELLED;
    }

    public boolean canTransitionTo(Status next) {
        return switch (this) {
            case PENDING    -> next == PROCESSING || next == CANCELLED;
            case PROCESSING -> next == SHIPPED    || next == CANCELLED;
            case SHIPPED    -> next == DELIVERED;
            default         -> false;    // terminal states can't transition
        };
    }
}

// ─── ENUM WITH DATA ───────────────────────────────────
enum HttpStatus {
    OK(200, "OK"),
    CREATED(201, "Created"),
    NO_CONTENT(204, "No Content"),
    BAD_REQUEST(400, "Bad Request"),
    UNAUTHORIZED(401, "Unauthorized"),
    NOT_FOUND(404, "Not Found"),
    SERVER_ERROR(500, "Internal Server Error");

    private final int code;
    private final String message;

    HttpStatus(int code, String message) {
        this.code    = code;
        this.message = message;
    }

    public int    getCode()    { return code;    }
    public String getMessage() { return message; }
    public boolean isSuccess() { return code >= 200 && code < 300; }
    public boolean isError()   { return code >= 400; }

    public static HttpStatus fromCode(int code) {
        for (HttpStatus s : values()) {
            if (s.code == code) return s;
        }
        throw new IllegalArgumentException("Unknown HTTP status: " + code);
    }

    @Override
    public String toString() {
        return code + " " + message;
    }
}

// ─── ENUM WITH ABSTRACT METHOD ────────────────────────
enum MathOp {
    ADD("+") {
        @Override public double apply(double a, double b) { return a + b; }
    },
    SUBTRACT("-") {
        @Override public double apply(double a, double b) { return a - b; }
    },
    MULTIPLY("×") {
        @Override public double apply(double a, double b) { return a * b; }
    },
    DIVIDE("÷") {
        @Override public double apply(double a, double b) {
            if (b == 0) throw new ArithmeticException("Division by zero");
            return a / b;
        }
    },
    POWER("^") {
        @Override public double apply(double a, double b) { return Math.pow(a, b); }
    };

    private final String symbol;
    MathOp(String symbol) { this.symbol = symbol; }

    public abstract double apply(double a, double b);

    @Override public String toString() { return symbol; }

    public String describe(double a, double b) {
        return String.format("%.2f %s %.2f = %.4f", a, symbol, b, apply(a, b));
    }
}

public class Enums {
    public static void main(String[] args) {

        // ─── BASIC ENUM USAGE ─────────────────────────────
        System.out.println("=== Basic Enum Operations ===");
        for (Status s : Status.values()) {
            System.out.printf("  %-12s ordinal=%-2d terminal=%s%n",
                s.name(), s.ordinal(), s.isTerminal());
        }

        // ─── STATE MACHINE WITH ENUM ──────────────────────
        System.out.println("\n=== Order State Machine ===");
        Status order = Status.PENDING;
        Status[] transitions = {Status.PROCESSING, Status.SHIPPED, Status.DELIVERED};

        System.out.println("  Order starts: " + order);
        for (Status next : transitions) {
            if (order.canTransitionTo(next)) {
                System.out.println("  → Transitioning to: " + next);
                order = next;
            } else {
                System.out.println("  ❌ Cannot transition from " + order + " to " + next);
            }
        }

        // Try invalid transition
        try {
            Status delivered = Status.DELIVERED;
            System.out.println("\n  Try: DELIVERED → PROCESSING");
            System.out.println("  Allowed: " + delivered.canTransitionTo(Status.PROCESSING));
        } catch (Exception e) {
            System.out.println("  Error: " + e.getMessage());
        }

        // ─── ENUM WITH DATA ───────────────────────────────
        System.out.println("\n=== HTTP Status Codes ===");
        int[] codes = {200, 201, 404, 500};
        for (int code : codes) {
            HttpStatus status = HttpStatus.fromCode(code);
            System.out.printf("  %s | success=%-5s | error=%s%n",
                status, status.isSuccess(), status.isError());
        }

        // ─── switch WITH ENUM (exhaustive) ────────────────
        System.out.println("\n=== switch with Enum ===");
        for (HttpStatus s : new HttpStatus[]{HttpStatus.OK, HttpStatus.NOT_FOUND, HttpStatus.SERVER_ERROR}) {
            String category = switch (s) {
                case OK, CREATED, NO_CONTENT -> "✅ Success";
                case BAD_REQUEST, UNAUTHORIZED, NOT_FOUND -> "⚠️  Client error";
                case SERVER_ERROR -> "🔥 Server error";
            };
            System.out.println("  " + s + " → " + category);
        }

        // ─── ENUM WITH ABSTRACT METHOD ────────────────────
        System.out.println("\n=== Math Operations ===");
        double a = 10.0, b = 3.0;
        for (MathOp op : MathOp.values()) {
            try {
                System.out.println("  " + op.describe(a, b));
            } catch (ArithmeticException e) {
                System.out.println("  " + a + " " + op + " " + b + " = Error: " + e.getMessage());
            }
        }

        // ─── EnumSet AND EnumMap ──────────────────────────
        System.out.println("\n=== EnumSet and EnumMap ===");
        EnumSet<Status> activeStatuses = EnumSet.of(
            Status.PENDING, Status.PROCESSING, Status.SHIPPED
        );
        System.out.println("  Active statuses: " + activeStatuses);
        System.out.println("  PENDING is active: " + activeStatuses.contains(Status.PENDING));
        System.out.println("  DELIVERED is active: " + activeStatuses.contains(Status.DELIVERED));

        EnumMap<HttpStatus, String> statusMessages = new EnumMap<>(HttpStatus.class);
        statusMessages.put(HttpStatus.OK, "Request successful");
        statusMessages.put(HttpStatus.NOT_FOUND, "Resource does not exist");
        statusMessages.put(HttpStatus.SERVER_ERROR, "Something went wrong");

        statusMessages.forEach((status, msg) ->
            System.out.println("  " + status + " → " + msg));
    }
}

📝 KEY POINTS:
✅ Enums are type-safe named constants — can't pass invalid values
✅ Enum constants can have fields, methods, and constructors
✅ values() returns all constants as an array; valueOf() looks up by name
✅ ordinal() gives the 0-based position — don't rely on it for logic
✅ switch on enum is exhaustive — no default needed if all cases covered
✅ EnumSet and EnumMap are highly efficient collection types for enums
✅ Abstract methods in enum force each constant to provide its own implementation
✅ Enum constructor is always private — Java enforces this
❌ Don't use ordinal() to store or compare enum values in databases
❌ enum constructors cannot be public — they are always private
❌ You cannot create new enum instances at runtime — they're fixed
❌ Don't use enums when the set of values might change — use something else
""",
  quiz: [
    Quiz(question: 'What does the values() method return for a Java enum?', options: [
      QuizOption(text: 'An array of all enum constants in declaration order', correct: true),
      QuizOption(text: 'A List of the enum constant names as Strings', correct: false),
      QuizOption(text: 'The number of constants in the enum', correct: false),
      QuizOption(text: 'A Set of all constants for fast membership testing', correct: false),
    ]),
    Quiz(question: 'What is the access modifier of an enum constructor?', options: [
      QuizOption(text: 'Always private — you cannot declare a public or protected enum constructor', correct: true),
      QuizOption(text: 'Always public — enum constructors must be accessible to create constants', correct: false),
      QuizOption(text: 'Package-private by default — same as any other class', correct: false),
      QuizOption(text: 'Any access modifier is allowed', correct: false),
    ]),
    Quiz(question: 'Why should you avoid storing enum ordinal() values in a database?', options: [
      QuizOption(text: 'Reordering enum constants changes their ordinals, breaking stored data', correct: true),
      QuizOption(text: 'ordinal() values are not serializable to SQL types', correct: false),
      QuizOption(text: 'ordinal() throws an exception if stored in a numeric column', correct: false),
      QuizOption(text: 'ordinal() values are randomized each time the JVM starts', correct: false),
    ]),
  ],
);

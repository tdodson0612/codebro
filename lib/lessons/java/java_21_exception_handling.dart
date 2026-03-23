import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson21 = Lesson(
  language: 'Java',
  title: 'Exception Handling',
  content: """
🎯 METAPHOR:
Exception handling is like a parachute system on an airplane.
The plane (your program) flies normally — no parachutes
needed. But when something unexpected goes wrong (engine
failure = exception), the system CATCHES the problem before
disaster (crash) occurs, handles it gracefully (deploy
parachutes = catch block), and ensures certain things
always happen (landing checklist = finally block).
Without exception handling, ANY unexpected event sends
the plane straight into the ground. WITH it, you have
layers of protection, clear response procedures, and
a way to communicate what went wrong.

📖 EXPLANATION:
Exceptions are events that disrupt normal program flow.
Java's exception system is one of the richest in any language.

─────────────────────────────────────
EXCEPTION HIERARCHY:
─────────────────────────────────────
  Throwable
  ├── Error                → JVM errors — don't catch!
  │   ├── OutOfMemoryError
  │   └── StackOverflowError
  └── Exception            → Things your code can handle
      ├── RuntimeException → Unchecked — don't need to declare
      │   ├── NullPointerException
      │   ├── ArrayIndexOutOfBoundsException
      │   ├── ClassCastException
      │   ├── IllegalArgumentException
      │   ├── IllegalStateException
      │   └── ArithmeticException
      └── (checked exceptions) → MUST handle or declare
          ├── IOException
          ├── SQLException
          └── FileNotFoundException

─────────────────────────────────────
CHECKED vs UNCHECKED:
─────────────────────────────────────
  CHECKED (compile-time enforced):
  → Must be caught (try/catch) OR declared (throws)
  → Represent "expected" exceptional conditions
  → IOException, SQLException, ClassNotFoundException

  UNCHECKED (RuntimeException):
  → No requirement to catch or declare
  → Usually represent programming errors
  → NullPointerException, IllegalArgumentException

─────────────────────────────────────
try / catch / finally:
─────────────────────────────────────
  try {
      // code that might throw
  } catch (SpecificException e) {
      // handle specific case
  } catch (AnotherException | YetAnother e) {  // multi-catch
      // handle multiple types
  } catch (Exception e) {
      // catch-all (use sparingly)
  } finally {
      // ALWAYS runs — cleanup goes here
  }

─────────────────────────────────────
try-with-resources (Java 7+):
─────────────────────────────────────
  try (BufferedReader reader = new BufferedReader(...)) {
      String line = reader.readLine();
  }  // reader.close() called automatically — even on exception!

  The resource must implement AutoCloseable.
  Preferred over manual finally { resource.close(); }

─────────────────────────────────────
CUSTOM EXCEPTIONS:
─────────────────────────────────────
  // Checked:
  public class PaymentException extends Exception {
      private final String errorCode;

      public PaymentException(String message, String errorCode) {
          super(message);
          this.errorCode = errorCode;
      }

      public String getErrorCode() { return errorCode; }
  }

  // Unchecked:
  public class ValidationException extends RuntimeException {
      public ValidationException(String message) { super(message); }
      public ValidationException(String msg, Throwable cause) {
          super(msg, cause);
      }
  }

─────────────────────────────────────
EXCEPTION CHAINING:
─────────────────────────────────────
  Wrap a lower-level exception in a higher-level one
  to preserve the original cause:

  try {
      int[] arr = new int[5];
      arr[10] = 1;
  } catch (ArrayIndexOutOfBoundsException e) {
      throw new DataProcessingException("Array access failed", e);
  }

  e.getCause() → returns the wrapped original exception

─────────────────────────────────────
BEST PRACTICES:
─────────────────────────────────────
  ✅ Catch the most specific exception first
  ✅ Use finally (or try-with-resources) for cleanup
  ✅ Include meaningful error messages
  ✅ Wrap low-level exceptions in domain exceptions
  ✅ Log exceptions with context
  ❌ Never swallow exceptions silently: catch(e) { }
  ❌ Don't catch Exception broadly — miss real bugs
  ❌ Don't use exceptions for normal control flow

💻 CODE:
import java.io.*;
import java.util.*;

// ─── CUSTOM EXCEPTIONS ────────────────────────────────
class InsufficientFundsException extends Exception {
    private final double required;
    private final double available;

    public InsufficientFundsException(double required, double available) {
        super(String.format(
            "Insufficient funds: need \$%.2f, have \$%.2f", required, available));
        this.required  = required;
        this.available = available;
    }

    public double getRequired()  { return required;  }
    public double getAvailable() { return available; }
    public double getShortfall() { return required - available; }
}

class ValidationException extends RuntimeException {
    private final String field;

    public ValidationException(String field, String message) {
        super("Validation failed for '" + field + "': " + message);
        this.field = field;
    }

    public String getField() { return field; }
}

// ─── BANK ACCOUNT (uses checked exception) ────────────
class Account {
    private String id;
    private double balance;
    private List<String> log = new ArrayList<>();

    public Account(String id, double balance) {
        if (balance < 0) throw new ValidationException("balance", "cannot be negative");
        this.id      = id;
        this.balance = balance;
        log.add("OPEN: " + balance);
    }

    public void deposit(double amount) {
        if (amount <= 0) throw new ValidationException("amount", "must be positive");
        balance += amount;
        log.add(String.format("DEP +%.2f → %.2f", amount, balance));
    }

    public void withdraw(double amount) throws InsufficientFundsException {
        if (amount <= 0) throw new ValidationException("amount", "must be positive");
        if (amount > balance) throw new InsufficientFundsException(amount, balance);
        balance -= amount;
        log.add(String.format("WD  -%.2f → %.2f", amount, balance));
    }

    public void transfer(Account target, double amount) throws InsufficientFundsException {
        withdraw(amount);       // may throw InsufficientFundsException
        target.deposit(amount);
        log.add(String.format("TFR -%.2f → %s", amount, target.id));
        target.log.add(String.format("TFR +%.2f ← %s", amount, this.id));
    }

    public String getId()      { return id; }
    public double getBalance() { return balance; }
    public List<String> getLog() { return Collections.unmodifiableList(log); }

    @Override public String toString() {
        return String.format("Account[%s, $%.2f]", id, balance);
    }
}

// ─── DATA PARSER (exception chaining) ─────────────────
class DataParser {
    public int parseAge(String input) {
        try {
            int age = Integer.parseInt(input.trim());
            if (age < 0 || age > 150)
                throw new IllegalArgumentException("Age out of range: " + age);
            return age;
        } catch (NumberFormatException e) {
            // Wrap low-level exception in domain exception
            throw new ValidationException("age",
                "'" + input + "' is not a valid integer");
        }
    }

    public List<Integer> parseAllAges(String[] inputs) {
        List<Integer> ages = new ArrayList<>();
        List<String> errors = new ArrayList<>();

        for (String input : inputs) {
            try {
                ages.add(parseAge(input));
            } catch (ValidationException e) {
                errors.add(e.getMessage());
            }
        }

        if (!errors.isEmpty()) {
            System.out.println("  ⚠️  Parsing errors:");
            errors.forEach(err -> System.out.println("    • " + err));
        }
        return ages;
    }
}

public class ExceptionHandling {
    public static void main(String[] args) {

        // ─── BASIC try/catch/finally ──────────────────────
        System.out.println("=== Basic Exception Handling ===");
        int[] numbers = {10, 5, 0, 2};
        for (int divisor : numbers) {
            try {
                int result = 100 / divisor;
                System.out.printf("  100 / %d = %d%n", divisor, result);
            } catch (ArithmeticException e) {
                System.out.printf("  100 / %d → ❌ %s%n", divisor, e.getMessage());
            } finally {
                System.out.println("  (finally always runs)");
            }
        }

        // ─── CUSTOM EXCEPTIONS ────────────────────────────
        System.out.println("\n=== Bank Account with Custom Exceptions ===");
        Account checking = new Account("CHK-001", 1000.0);
        Account savings  = new Account("SAV-001", 500.0);

        // Normal operations
        try {
            checking.deposit(250.0);
            checking.withdraw(100.0);
            System.out.println("  " + checking);

            // Transfer
            checking.transfer(savings, 300.0);
            System.out.println("  After transfer: " + checking + " | " + savings);

            // This will fail — insufficient funds
            checking.withdraw(2000.0);

        } catch (InsufficientFundsException e) {
            System.out.println("  ❌ " + e.getMessage());
            System.out.printf("  Shortfall: $%.2f%n", e.getShortfall());
        }

        // Validation exception (unchecked)
        try {
            new Account("X", -100);
        } catch (ValidationException e) {
            System.out.println("  ❌ " + e.getMessage());
        }

        // Log output
        System.out.println("\n  Checking log:");
        checking.getLog().forEach(entry -> System.out.println("    " + entry));

        // ─── MULTI-CATCH ──────────────────────────────────
        System.out.println("\n=== Multi-catch ===");
        Object[] items = {"hello", null, new int[]{1}, "42", true};
        for (Object item : items) {
            try {
                String s = (String) item;           // may throw ClassCastException
                int len = s.length();               // may throw NullPointerException
                int num = Integer.parseInt(s);      // may throw NumberFormatException
                System.out.printf("  Parsed '%s' as int: %d%n", s, num);
            } catch (ClassCastException | NullPointerException e) {
                System.out.printf("  ⚠️  Type issue [%s]: %s%n",
                    e.getClass().getSimpleName(), e.getMessage());
            } catch (NumberFormatException e) {
                System.out.printf("  ⚠️  Not a number: '%s'%n", item);
            }
        }

        // ─── try-with-resources ───────────────────────────
        System.out.println("\n=== try-with-resources ===");
        String tempFile = "test_exception_demo.txt";
        try {
            // Write file
            try (PrintWriter pw = new PrintWriter(new FileWriter(tempFile))) {
                pw.println("Line 1: Hello");
                pw.println("Line 2: World");
                pw.println("Line 3: Java");
            }  // pw.close() called automatically

            // Read file
            try (BufferedReader br = new BufferedReader(new FileReader(tempFile))) {
                String line;
                int lineNum = 1;
                while ((line = br.readLine()) != null) {
                    System.out.println("  " + lineNum++ + ": " + line);
                }
            }  // br.close() called automatically

        } catch (IOException e) {
            System.out.println("  ❌ IO Error: " + e.getMessage());
        } finally {
            new File(tempFile).delete();  // cleanup
            System.out.println("  (temp file cleaned up in finally)");
        }

        // ─── EXCEPTION CHAINING ───────────────────────────
        System.out.println("\n=== Data Parsing with Exception Chaining ===");
        DataParser parser = new DataParser();
        String[] ageInputs = {"25", "abc", "30", "-5", "200", "42"};
        List<Integer> validAges = parser.parseAllAges(ageInputs);
        System.out.println("  Valid ages: " + validAges);
        System.out.printf("  Average: %.1f%n",
            validAges.stream().mapToInt(i -> i).average().orElse(0));
    }
}

📝 KEY POINTS:
✅ Checked exceptions MUST be caught or declared with throws
✅ RuntimeExceptions (unchecked) don't require handling
✅ finally always runs — even if an exception is thrown or caught
✅ try-with-resources auto-closes resources — preferred over manual close
✅ Catch most specific exceptions first — general exceptions last
✅ Multi-catch: catch (TypeA | TypeB e) handles both in one block
✅ Custom exceptions carry domain-specific context (field name, error code)
✅ Exception chaining: throw new DomainEx("msg", originalCause)
❌ Never swallow exceptions: catch(Exception e) { } — this hides bugs
❌ Don't catch Error — JVM errors are fatal and unrecoverable
❌ Don't use exceptions for normal control flow — use if/else
❌ Don't catch Exception broadly in business logic — you'll miss real bugs
""",
  quiz: [
    Quiz(question: 'What is the difference between checked and unchecked exceptions in Java?', options: [
      QuizOption(text: 'Checked exceptions must be caught or declared with throws; unchecked exceptions (RuntimeException) do not', correct: true),
      QuizOption(text: 'Checked exceptions are faster; unchecked exceptions carry more information', correct: false),
      QuizOption(text: 'Unchecked exceptions cannot be caught; checked exceptions can', correct: false),
      QuizOption(text: 'Checked exceptions extend Error; unchecked exceptions extend Exception', correct: false),
    ]),
    Quiz(question: 'What does try-with-resources guarantee?', options: [
      QuizOption(text: 'The resource\'s close() method is called automatically when the try block exits, even on exception', correct: true),
      QuizOption(text: 'Exceptions thrown inside the try block are suppressed and logged automatically', correct: false),
      QuizOption(text: 'The resource is created fresh on every iteration of a loop', correct: false),
      QuizOption(text: 'Resources opened inside the try block are shared between threads safely', correct: false),
    ]),
    Quiz(question: 'When does the finally block run?', options: [
      QuizOption(text: 'Always — whether the try block succeeds, throws an exception, or even returns', correct: true),
      QuizOption(text: 'Only when an exception is caught in a catch block', correct: false),
      QuizOption(text: 'Only when no exception is thrown', correct: false),
      QuizOption(text: 'Only when the method returns normally without exceptions', correct: false),
    ]),
  ],
);

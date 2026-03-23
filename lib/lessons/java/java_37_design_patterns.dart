import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson37 = Lesson(
  language: 'Java',
  title: 'Design Patterns in Java',
  content: """
🎯 METAPHOR:
Design patterns are like standardized construction blueprints.
Every architect knows what "a load-bearing wall" means.
Every civil engineer knows what "a cantilever" is.
These aren't inventions unique to each project —
they're PROVEN SOLUTIONS with names that let professionals
communicate efficiently: "We'll use a Façade pattern here"
tells the whole team the structure without a 20-minute
explanation. Design patterns in software are the same:
proven solutions to recurring problems, with shared
vocabulary, so your team communicates clearly and your
code communicates its INTENT.

📖 EXPLANATION:
The Gang of Four (GoF) patterns fall into three categories:
Creational (how objects are made), Structural (how they fit
together), and Behavioral (how they communicate).

─────────────────────────────────────
CREATIONAL PATTERNS:
─────────────────────────────────────
  Singleton    → one instance, global access point
  Factory      → create objects without specifying exact class
  Builder      → construct complex objects step by step
  Prototype    → clone existing objects
  Abstract Factory → families of related objects

─────────────────────────────────────
STRUCTURAL PATTERNS:
─────────────────────────────────────
  Adapter      → make incompatible interfaces work together
  Decorator    → add behavior without modifying class
  Facade       → simplified interface to complex subsystem
  Composite    → tree structure of objects
  Proxy        → surrogate or placeholder for another object
  Bridge       → decouple abstraction from implementation

─────────────────────────────────────
BEHAVIORAL PATTERNS:
─────────────────────────────────────
  Observer     → event subscription (listener pattern)
  Strategy     → interchangeable algorithms
  Command      → encapsulate requests as objects
  Template     → skeleton algorithm, subclasses fill steps
  Iterator     → sequential access to collection
  Chain of Resp → pass request along handler chain
  State        → behavior changes with internal state

─────────────────────────────────────
KEY JAVA PATTERN IMPLEMENTATIONS:
─────────────────────────────────────
  Singleton → enum or double-checked locking
  Builder   → static inner class with fluent API
  Observer  → java.util.Observer (deprecated) or custom
  Strategy  → functional interface (lambda)
  Factory   → static factory methods or abstract factory
  Decorator → wrapping with same interface

─────────────────────────────────────
PATTERNS IN THE JAVA STANDARD LIBRARY:
─────────────────────────────────────
  Singleton:   Runtime.getRuntime()
  Factory:     Calendar.getInstance(), NumberFormat.getInstance()
  Decorator:   BufferedReader wrapping FileReader
  Iterator:    java.util.Iterator
  Observer:    java.util.EventListener, PropertyChangeListener
  Strategy:    Comparator<T>
  Composite:   javax.swing components
  Template:    AbstractList, AbstractMap
  Command:     Runnable, Callable
  Proxy:       java.lang.reflect.Proxy

💻 CODE:
import java.util.*;
import java.util.function.*;

// ─── SINGLETON (enum variant — best Java singleton) ───
enum AppConfig {
    INSTANCE;

    private final Map<String, String> settings = new HashMap<>();

    public void set(String key, String value) { settings.put(key, value); }
    public String get(String key)             { return settings.get(key); }
    public String get(String key, String def) { return settings.getOrDefault(key, def); }

    @Override public String toString()        { return "AppConfig" + settings; }
}

// ─── BUILDER PATTERN ──────────────────────────────────
class HttpRequest {
    private final String method;
    private final String url;
    private final Map<String, String> headers;
    private final String body;
    private final int timeout;

    private HttpRequest(Builder builder) {
        this.method  = builder.method;
        this.url     = builder.url;
        this.headers = Collections.unmodifiableMap(new LinkedHashMap<>(builder.headers));
        this.body    = builder.body;
        this.timeout = builder.timeout;
    }

    public static Builder builder(String method, String url) {
        return new Builder(method, url);
    }

    @Override
    public String toString() {
        return method + " " + url +
            (headers.isEmpty() ? "" : " headers=" + headers) +
            (body != null ? " body=[" + body.substring(0, Math.min(20, body.length())) + "...]" : "") +
            " timeout=" + timeout + "s";
    }

    static class Builder {
        private final String method;
        private final String url;
        private final Map<String, String> headers = new LinkedHashMap<>();
        private String body;
        private int timeout = 30;

        private Builder(String method, String url) {
            this.method = method;
            this.url = url;
        }

        public Builder header(String name, String value) {
            headers.put(name, value); return this;
        }
        public Builder body(String body)     { this.body = body; return this; }
        public Builder timeout(int seconds)  { this.timeout = seconds; return this; }
        public HttpRequest build()           { return new HttpRequest(this); }
    }
}

// ─── OBSERVER PATTERN ─────────────────────────────────
interface EventListener<T> {
    void onEvent(T event);
}

class EventBus<T> {
    private final List<EventListener<T>> listeners = new ArrayList<>();

    public void subscribe(EventListener<T> listener)   { listeners.add(listener); }
    public void unsubscribe(EventListener<T> listener) { listeners.remove(listener); }

    public void publish(T event) {
        listeners.forEach(l -> l.onEvent(event));
    }
}

record OrderEvent(String type, String orderId, double amount) { }

// ─── STRATEGY PATTERN (with lambdas) ──────────────────
class Sorter<T> {
    private Comparator<T> strategy;

    public Sorter<T> using(Comparator<T> strategy) {
        this.strategy = strategy; return this;
    }

    public List<T> sort(List<T> items) {
        var copy = new ArrayList<>(items);
        copy.sort(strategy);
        return copy;
    }
}

record Product(String name, double price, int rating) { }

// ─── DECORATOR PATTERN ────────────────────────────────
interface TextProcessor {
    String process(String text);
}

class UpperCaseProcessor implements TextProcessor {
    @Override public String process(String text) { return text.toUpperCase(); }
}

class TrimProcessor implements TextProcessor {
    private final TextProcessor inner;
    TrimProcessor(TextProcessor inner) { this.inner = inner; }
    @Override public String process(String text) { return inner.process(text.strip()); }
}

class PrefixProcessor implements TextProcessor {
    private final TextProcessor inner;
    private final String prefix;
    PrefixProcessor(TextProcessor inner, String prefix) {
        this.inner = inner; this.prefix = prefix;
    }
    @Override public String process(String text) { return prefix + inner.process(text); }
}

// ─── CHAIN OF RESPONSIBILITY ──────────────────────────
abstract class Handler {
    protected Handler next;

    public Handler setNext(Handler next) { this.next = next; return next; }

    protected abstract boolean handle(String request);

    public boolean process(String request) {
        if (handle(request)) return true;
        return next != null && next.process(request);
    }
}

class AuthHandler extends Handler {
    @Override protected boolean handle(String req) {
        if (!req.contains("token:")) {
            System.out.println("  ❌ AuthHandler: No token — rejected");
            return false;
        }
        System.out.println("  ✅ AuthHandler: Token found — passed");
        return false;   // continue chain
    }
}

class RateLimitHandler extends Handler {
    private int requests = 0;
    @Override protected boolean handle(String req) {
        if (++requests > 3) {
            System.out.println("  ❌ RateLimit: Too many requests — rejected");
            return true;   // stop chain
        }
        System.out.println("  ✅ RateLimit: Request #" + requests + " — passed");
        return false;
    }
}

class LoggingHandler extends Handler {
    @Override protected boolean handle(String req) {
        System.out.println("  📝 Logger: Processing '" + req.substring(0, Math.min(30, req.length())) + "'");
        return false;   // always continue
    }
}

public class DesignPatterns {
    public static void main(String[] args) {

        // ─── SINGLETON (enum) ─────────────────────────────
        System.out.println("=== Singleton (enum) ===");
        AppConfig.INSTANCE.set("host", "api.example.com");
        AppConfig.INSTANCE.set("port", "443");

        AppConfig c1 = AppConfig.INSTANCE;
        AppConfig c2 = AppConfig.INSTANCE;
        System.out.println("  c1 == c2: " + (c1 == c2));
        System.out.println("  host: " + c1.get("host"));
        System.out.println("  timeout: " + c2.get("timeout", "30s"));

        // ─── BUILDER ──────────────────────────────────────
        System.out.println("\n=== Builder ===");
        HttpRequest getReq = HttpRequest.builder("GET", "https://api.example.com/users")
            .header("Authorization", "Bearer abc123")
            .header("Accept", "application/json")
            .timeout(10)
            .build();

        HttpRequest postReq = HttpRequest.builder("POST", "https://api.example.com/users")
            .header("Content-Type", "application/json")
            .body("{\"name\":\"Terry\",\"email\":\"t@t.com\"}")
            .timeout(30)
            .build();

        System.out.println("  GET:  " + getReq);
        System.out.println("  POST: " + postReq);

        // ─── OBSERVER ─────────────────────────────────────
        System.out.println("\n=== Observer (EventBus) ===");
        EventBus<OrderEvent> orderBus = new EventBus<>();

        // Subscribe with lambdas
        orderBus.subscribe(e ->
            System.out.printf("  📧 Email: Order %s %s ($%.2f)%n",
                e.orderId(), e.type(), e.amount()));
        orderBus.subscribe(e ->
            System.out.printf("  📊 Analytics: %s event recorded%n", e.type()));
        EventListener<OrderEvent> warehouse = e -> {
            if (e.type().equals("PLACED"))
                System.out.println("  📦 Warehouse: Prepare order " + e.orderId());
        };
        orderBus.subscribe(warehouse);

        orderBus.publish(new OrderEvent("PLACED",    "ORD-001", 99.99));
        orderBus.publish(new OrderEvent("SHIPPED",   "ORD-001", 99.99));
        orderBus.publish(new OrderEvent("DELIVERED", "ORD-001", 99.99));

        // ─── STRATEGY (lambdas as strategies) ─────────────
        System.out.println("\n=== Strategy ===");
        var products = Arrays.asList(
            new Product("Laptop", 999.99, 4),
            new Product("Phone",  699.99, 5),
            new Product("Tablet", 499.99, 3),
            new Product("Watch",  299.99, 4)
        );

        var sorter = new Sorter<Product>();

        System.out.println("  By price (asc):");
        sorter.using(Comparator.comparingDouble(Product::price))
              .sort(products)
              .forEach(p -> System.out.printf("    %-8s $%.2f%n", p.name(), p.price()));

        System.out.println("  By rating (desc), then name:");
        sorter.using(Comparator.comparingInt(Product::rating).reversed()
                               .thenComparing(Product::name))
              .sort(products)
              .forEach(p -> System.out.printf("    %-8s ★%d%n", p.name(), p.rating()));

        // ─── DECORATOR ────────────────────────────────────
        System.out.println("\n=== Decorator ===");
        TextProcessor basic    = new UpperCaseProcessor();
        TextProcessor trimmed  = new TrimProcessor(basic);
        TextProcessor prefixed = new PrefixProcessor(trimmed, ">>> ");

        String[] inputs = {"  hello world  ", "  kotlin  ", "  java  "};
        for (String input : inputs) {
            System.out.printf("  '%-15s' → '%s'%n", input, prefixed.process(input));
        }

        // ─── CHAIN OF RESPONSIBILITY ──────────────────────
        System.out.println("\n=== Chain of Responsibility ===");
        var auth      = new AuthHandler();
        var rateLimit = new RateLimitHandler();
        var logger    = new LoggingHandler();

        // Build chain: auth → rateLimit → logger
        auth.setNext(rateLimit).setNext(logger);

        String[] requests = {
            "no-token request data",
            "token: abc; data=1",
            "token: abc; data=2",
            "token: abc; data=3",
            "token: abc; data=4"  // rate-limited
        };

        for (String req : requests) {
            System.out.println("  Processing: " + req.substring(0, Math.min(20, req.length())));
            auth.process(req);
            System.out.println();
        }
    }
}

📝 KEY POINTS:
✅ Singleton via enum is thread-safe and serialization-safe — preferred Java approach
✅ Builder pattern: use static inner Builder class with fluent method chaining
✅ Observer pattern: decouple publishers from subscribers using interfaces/lambdas
✅ Strategy pattern: pass different Comparator/Function implementations
✅ Decorator: wrap an interface implementation to add behavior without modification
✅ Chain of Responsibility: link handlers, each decides to handle or pass along
✅ Lambdas replace Strategy and Command classes in modern Java
✅ Patterns are tools — use when they reduce complexity, not to show off
❌ Don't implement Singleton with double-checked locking — use enum instead
❌ Don't apply patterns blindly — YAGNI (You Aren't Gonna Need It)
❌ Over-architecting simple code with patterns adds unnecessary complexity
❌ Builder pattern needs careful thought — too many optional fields can indicate a design smell
""",
  quiz: [
    Quiz(question: 'Why is the enum approach the preferred way to implement Singleton in Java?', options: [
      QuizOption(text: 'Enums are inherently thread-safe, serialization-safe, and prevent reflection-based instantiation', correct: true),
      QuizOption(text: 'Enums are faster than class-based singletons at runtime', correct: false),
      QuizOption(text: 'The enum approach allows multiple instances if needed later', correct: false),
      QuizOption(text: 'Enum singletons can be subclassed easily to add behavior', correct: false),
    ]),
    Quiz(question: 'What problem does the Builder pattern solve?', options: [
      QuizOption(text: 'Telescoping constructors — objects with many optional parameters become unreadable with multiple constructors', correct: true),
      QuizOption(text: 'Thread safety — Builder ensures only one instance is created', correct: false),
      QuizOption(text: 'Inheritance hierarchies — Builder eliminates the need for subclasses', correct: false),
      QuizOption(text: 'Memory allocation — Builder reuses object instances instead of creating new ones', correct: false),
    ]),
    Quiz(question: 'In modern Java, what typically replaces a Strategy pattern with multiple strategy classes?', options: [
      QuizOption(text: 'A functional interface with lambda expressions passed as strategy implementations', correct: true),
      QuizOption(text: 'Abstract factory methods that produce the correct strategy', correct: false),
      QuizOption(text: 'Annotation-based strategy selection processed at compile time', correct: false),
      QuizOption(text: 'Static nested classes that implement the strategy interface', correct: false),
    ]),
  ],
);

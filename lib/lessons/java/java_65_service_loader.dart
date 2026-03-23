import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson65 = Lesson(
  language: 'Java',
  title: 'ServiceLoader and the SPI Pattern',
  content: """
🎯 METAPHOR:
ServiceLoader is like a plugin marketplace. Your app
defines what a plugin must do (the service interface),
and plugins register themselves in a marketplace directory
(META-INF/services). When your app starts, it checks
the directory for all registered plugins and loads them
automatically — without ever importing them directly.
New plugins can be added by dropping a JAR into the lib
folder. The app never changes. This is the plugin
architecture that powers Java's own JDBC drivers,
charset encoders, XML parsers, and more.

📖 EXPLANATION:
The Service Provider Interface (SPI) pattern allows
decoupled plugin/extension architectures.

─────────────────────────────────────
THREE PARTS:
─────────────────────────────────────
  1. SERVICE INTERFACE — the contract:
     public interface PaymentProcessor {
         String getName();
         boolean process(double amount);
     }

  2. PROVIDER — the implementation:
     public class StripeProcessor implements PaymentProcessor {
         @Override public String getName() { return "Stripe"; }
         @Override public boolean process(double amount) { ... }
     }

     File: META-INF/services/com.example.PaymentProcessor
     Content: com.stripe.StripeProcessor

  3. CONSUMER — loads providers:
     ServiceLoader<PaymentProcessor> loader =
         ServiceLoader.load(PaymentProcessor.class);
     for (PaymentProcessor proc : loader) {
         System.out.println(proc.getName());
     }

─────────────────────────────────────
IN A MODULE SYSTEM (Java 9+):
─────────────────────────────────────
  // Provider module's module-info.java:
  module com.stripe {
      provides com.example.PaymentProcessor
          with com.stripe.StripeProcessor;
  }

  // Consumer module's module-info.java:
  module com.myapp {
      uses com.example.PaymentProcessor;
  }

─────────────────────────────────────
BUILT-IN SPI EXAMPLES IN THE JDK:
─────────────────────────────────────
  java.sql.Driver               → JDBC drivers
  java.nio.charset.spi.CharsetProvider → character sets
  javax.imageio.spi.ImageWriterSpi  → image formats
  java.util.logging.LogManager  → logging providers
  java.security.Provider        → crypto providers

─────────────────────────────────────
ServiceLoader API:
─────────────────────────────────────
  ServiceLoader.load(Service.class)           → all implementations
  ServiceLoader.load(Service.class, classLoader) → with custom loader
  loader.findFirst()                          → Optional<Service>
  loader.stream()                             → Stream<Provider<S>>
  loader.reload()                             → refresh after JAR changes

─────────────────────────────────────
PRACTICAL USES:
─────────────────────────────────────
  ✅ Plugin systems (IDEs, build tools)
  ✅ Driver registration (JDBC, image decoders)
  ✅ Codec/format support (JSON libs, XML parsers)
  ✅ Strategy implementations across JARs
  ✅ Feature flags via alternate implementations

💻 CODE:
import java.util.*;

// ─── SERVICE INTERFACE ────────────────────────────────
interface Serializer {
    String getName();
    String serialize(Map<String, Object> data);
    Map<String, Object> deserialize(String text);
}

// ─── BUILT-IN IMPLEMENTATIONS (normally in separate JARs) ──
class JsonSerializer implements Serializer {
    @Override public String getName() { return "JSON"; }

    @Override
    public String serialize(Map<String, Object> data) {
        StringBuilder sb = new StringBuilder("{");
        data.forEach((k, v) -> {
            if (sb.length() > 1) sb.append(",");
            sb.append("\"").append(k).append("\":");
            if (v instanceof String) sb.append("\"").append(v).append("\"");
            else sb.append(v);
        });
        return sb.append("}").toString();
    }

    @Override
    public Map<String, Object> deserialize(String text) {
        // Simplified parser for demo
        Map<String, Object> result = new LinkedHashMap<>();
        String inner = text.replaceAll("[{}\"\\s]", "");
        for (String pair : inner.split(",")) {
            String[] kv = pair.split(":");
            if (kv.length == 2) result.put(kv[0], kv[1]);
        }
        return result;
    }
}

class CsvSerializer implements Serializer {
    @Override public String getName() { return "CSV"; }

    @Override
    public String serialize(Map<String, Object> data) {
        return String.join(",", data.keySet()) + "\n" +
               String.join(",", data.values().stream()
                   .map(Object::toString).toList());
    }

    @Override
    public Map<String, Object> deserialize(String text) {
        String[] lines = text.split("\n");
        String[] keys  = lines[0].split(",");
        String[] vals  = lines.length > 1 ? lines[1].split(",") : new String[0];
        Map<String, Object> result = new LinkedHashMap<>();
        for (int i = 0; i < Math.min(keys.length, vals.length); i++) {
            result.put(keys[i].trim(), vals[i].trim());
        }
        return result;
    }
}

// ─── ServiceLoader SIMULATION ─────────────────────────
// In real code: ServiceLoader.load(Serializer.class)
// loads from META-INF/services/com.example.Serializer
// Here we simulate with a registry
class PluginRegistry {
    private static final List<Serializer> plugins = new ArrayList<>();

    static {
        // In real SPI: these come from JAR files via ServiceLoader
        plugins.add(new JsonSerializer());
        plugins.add(new CsvSerializer());
    }

    public static List<Serializer> loadAll() { return Collections.unmodifiableList(plugins); }

    public static Optional<Serializer> findByName(String name) {
        return plugins.stream().filter(s -> s.getName().equals(name)).findFirst();
    }

    // Simulate ServiceLoader.load() usage:
    // ServiceLoader<Serializer> loader = ServiceLoader.load(Serializer.class);
    // loader.forEach(s -> System.out.println(s.getName()));
}

public class ServiceLoaderDemo {
    public static void main(String[] args) {

        // ─── USING THE SPI ────────────────────────────────
        System.out.println("=== Service Provider Interface (SPI) ===");
        Map<String, Object> data = new LinkedHashMap<>();
        data.put("name",   "Alice");
        data.put("age",    "28");
        data.put("city",   "London");
        data.put("active", "true");

        // Discover and use all plugins
        List<Serializer> serializers = PluginRegistry.loadAll();
        System.out.println("  Found " + serializers.size() + " serializer(s):");

        for (Serializer s : serializers) {
            String serialized = s.serialize(data);
            System.out.println("\n  [" + s.getName() + "] Serialized:");
            System.out.println("  " + serialized);
            System.out.println("  [" + s.getName() + "] Deserialized: " +
                s.deserialize(serialized));
        }

        // Find specific plugin by name
        System.out.println("\n  Finding 'JSON' serializer:");
        PluginRegistry.findByName("JSON")
            .ifPresentOrElse(
                s -> System.out.println("  Found: " + s.getName() + " → " + s.serialize(data)),
                () -> System.out.println("  Not found!")
            );

        // ─── REAL SERVICELOADER USAGE ─────────────────────
        System.out.println("\n=== Real ServiceLoader (JDBC Driver example) ===");
        System.out.println("  // In META-INF/services/java.sql.Driver:");
        System.out.println("  // org.postgresql.Driver");
        System.out.println("  // com.mysql.cj.jdbc.Driver");
        System.out.println();
        System.out.println("  // JDBC auto-loads drivers via ServiceLoader:");
        System.out.println("  // Class.forName('org.postgresql.Driver') not needed since Java 6!");
        System.out.println("  // DriverManager.getConnection(url) → ServiceLoader finds the driver");

        // ─── SPI STRUCTURE REFERENCE ─────────────────────
        System.out.println("\n=== SPI File Structure ===");
        System.out.println("""
          src/
          ├── META-INF/
          │   └── services/
          │       └── com.example.Serializer   ← service interface FQN
          │           # Content:
          │           com.example.JsonSerializer
          │           com.example.CsvSerializer
          └── com/example/
              ├── Serializer.java              ← interface
              ├── JsonSerializer.java          ← impl 1
              └── CsvSerializer.java           ← impl 2

          // Loading:
          ServiceLoader<Serializer> loader = ServiceLoader.load(Serializer.class);
          loader.forEach(s -> System.out.println(s.getName()));
          loader.findFirst().ifPresent(s -> s.serialize(data));
          """);

        // ─── MODULE SYSTEM SPI ────────────────────────────
        System.out.println("=== Module System SPI (Java 9+) ===");
        System.out.println("""
          // module-info.java of the API module:
          module com.example.api {
              exports com.example;
          }

          // module-info.java of the JSON provider:
          module com.example.json {
              requires com.example.api;
              provides com.example.Serializer
                  with com.example.JsonSerializer;
          }

          // module-info.java of the consumer:
          module com.myapp {
              requires com.example.api;
              uses com.example.Serializer;
          }
          """);
    }
}

📝 KEY POINTS:
✅ SPI = Service Provider Interface — the pattern; ServiceLoader = the mechanism
✅ Create META-INF/services/fully.qualified.Interface with one impl per line
✅ ServiceLoader.load() discovers all registered implementations at runtime
✅ JDBC drivers, charset providers, and XML parsers all use SPI — it's everywhere
✅ In modules (Java 9+), use 'provides X with Y' and 'uses X' in module-info.java
✅ ServiceLoader.findFirst() returns Optional — handles no implementations gracefully
✅ loader.reload() refreshes after new JARs are added to the classpath
✅ SPI enables plugin architectures where plugins are unknown at compile time
❌ The META-INF/services filename MUST be the fully qualified interface name
❌ Each implementation MUST have a no-arg constructor (for ServiceLoader to instantiate)
❌ ServiceLoader is not thread-safe — synchronize if loading from multiple threads
❌ Module system SPI requires explicit 'uses' declaration — unlike classpath SPI
""",
  quiz: [
    Quiz(question: 'What file do you create to register a service provider in the classpath-based SPI?', options: [
      QuizOption(text: 'META-INF/services/fully.qualified.InterfaceName containing the implementation class name', correct: true),
      QuizOption(text: 'META-INF/providers.xml listing all implementation classes', correct: false),
      QuizOption(text: 'A ServiceRegistry.properties file in the root of the JAR', correct: false),
      QuizOption(text: 'An @ServiceProvider annotation on the implementation class', correct: false),
    ]),
    Quiz(question: 'What is a real-world example of the SPI pattern in the Java JDK?', options: [
      QuizOption(text: 'JDBC drivers — DriverManager uses ServiceLoader to auto-discover registered drivers', correct: true),
      QuizOption(text: 'Java generics — type parameters are discovered at runtime via SPI', correct: false),
      QuizOption(text: 'The JVM garbage collector — selected via SPI at startup', correct: false),
      QuizOption(text: 'Thread scheduling — the scheduler registers via SPI in java.util.concurrent', correct: false),
    ]),
    Quiz(question: 'What constraint must all ServiceLoader implementations satisfy?', options: [
      QuizOption(text: 'They must have a public no-argument constructor — ServiceLoader uses it to instantiate them', correct: true),
      QuizOption(text: 'They must be declared final — ServiceLoader cannot work with abstract implementations', correct: false),
      QuizOption(text: 'They must implement Serializable so they can be cached between JVM restarts', correct: false),
      QuizOption(text: 'They must be in the same package as the service interface', correct: false),
    ]),
  ],
);

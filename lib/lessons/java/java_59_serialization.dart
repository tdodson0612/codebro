import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson59 = Lesson(
  language: 'Java',
  title: 'Serialization Deep Dive',
  content: """
🎯 METAPHOR:
Serialization is like freeze-drying food for space travel.
You take a living, complex object (a meal) and convert it
to a shelf-stable form (byte stream) that can survive the
journey — through a file, a network connection, or a cache.
At the other end, you rehydrate it back into a usable object.
The original meal and the rehydrated version are structurally
identical, even though the food went through a complete
transformation in between. Java's built-in serialization
is the old freeze-drying machine — it works but has quirks.
Modern alternatives (JSON, Protocol Buffers) are the
industrial-grade systems that have replaced it in most
production apps.

📖 EXPLANATION:
Java serialization converts objects to byte streams and back.
It's built into the JDK but has significant gotchas.

─────────────────────────────────────
IMPLEMENTING Serializable:
─────────────────────────────────────
  public class User implements Serializable {
      private static final long serialVersionUID = 1L;
      private String name;
      private int age;
      private transient String password;  // NOT serialized
  }

  serialVersionUID: a version fingerprint for the class.
  If not declared, Java generates one based on the class
  structure. If the class changes (fields added/removed),
  the generated UID changes → InvalidClassException on
  deserialization. ALWAYS declare it explicitly.

─────────────────────────────────────
SERIALIZING (writing):
─────────────────────────────────────
  try (ObjectOutputStream oos = new ObjectOutputStream(
          new BufferedOutputStream(new FileOutputStream("data.ser")))) {
      oos.writeObject(user);          // write one object
      oos.writeObject(list);          // write a List
      oos.writeInt(42);               // write a primitive
      oos.writeUTF("hello");          // write a String
  }

─────────────────────────────────────
DESERIALIZING (reading):
─────────────────────────────────────
  try (ObjectInputStream ois = new ObjectInputStream(
          new BufferedInputStream(new FileInputStream("data.ser")))) {
      User user = (User) ois.readObject();      // unchecked cast
      List<String> list = (List<String>) ois.readObject();
  }

─────────────────────────────────────
TRANSIENT — skip a field:
─────────────────────────────────────
  private transient String cachedValue;  // won't be serialized
  private transient Logger logger;        // loggers must be transient

  After deserialization, transient fields have their
  DEFAULT value: null for objects, 0 for numbers, false for boolean.

─────────────────────────────────────
CUSTOM SERIALIZATION:
─────────────────────────────────────
  Override these magic methods in your class:
  private void writeObject(ObjectOutputStream oos) throws IOException {
      oos.defaultWriteObject();          // write normal fields
      oos.writeInt(computedValue);       // write extra data
  }

  private void readObject(ObjectInputStream ois)
          throws IOException, ClassNotFoundException {
      ois.defaultReadObject();           // read normal fields
      this.computedValue = ois.readInt();// read extra data
      // Post-deserialization init:
      this.cache = new HashMap<>();
  }

─────────────────────────────────────
Externalizable — full manual control:
─────────────────────────────────────
  public class Config implements Externalizable {
      @Override
      public void writeExternal(ObjectOutput out) throws IOException {
          out.writeUTF(host);
          out.writeInt(port);
      }

      @Override
      public void readExternal(ObjectInput in)
              throws IOException {
          this.host = in.readUTF();
          this.port = in.readInt();
      }
  }

  Faster than Serializable, more explicit, requires
  no-arg constructor (unlike Serializable).

─────────────────────────────────────
SERIALIZATION PITFALLS:
─────────────────────────────────────
  ❌ Security: malicious byte streams can exploit readObject()
  ❌ Versioning: class evolution breaks deserialization
  ❌ Performance: slow and verbose
  ❌ All referenced objects must also be Serializable
  ❌ Static fields are NOT serialized
  ❌ transient fields lose their values

  For new code, prefer:
  ✅ JSON via Jackson or Gson
  ✅ XML via JAXB
  ✅ Protocol Buffers (protobuf)
  ✅ Records (auto-serializable with JSON libs)

─────────────────────────────────────
WHEN JAVA SERIALIZATION IS STILL USED:
─────────────────────────────────────
  → RMI (Remote Method Invocation)
  → HTTP session replication in Java EE
  → Java caching (Ehcache, Hazelcast default)
  → Deep object cloning (rare)
  → JVM internals

💻 CODE:
import java.io.*;
import java.nio.file.*;
import java.util.*;

// ─── SERIALIZABLE CLASSES ─────────────────────────────
class Address implements Serializable {
    private static final long serialVersionUID = 1L;

    private String street;
    private String city;
    private String country;

    public Address(String street, String city, String country) {
        this.street  = street;
        this.city    = city;
        this.country = country;
    }

    @Override public String toString() {
        return street + ", " + city + ", " + country;
    }
}

class Person implements Serializable {
    private static final long serialVersionUID = 2L;

    private String name;
    private int    age;
    private Address address;                    // nested Serializable
    private transient String sessionToken;      // NOT serialized
    private transient List<String> cache;        // NOT serialized

    public Person(String name, int age, Address address) {
        this.name         = name;
        this.age          = age;
        this.address      = address;
        this.sessionToken = "tok_" + System.currentTimeMillis();
        this.cache        = new ArrayList<>();
    }

    // Custom readObject to initialize transient fields after deserialization
    private void readObject(ObjectInputStream ois)
            throws IOException, ClassNotFoundException {
        ois.defaultReadObject();
        this.cache = new ArrayList<>();        // re-initialize transient
        // sessionToken stays null — that's correct (session expired)
    }

    @Override public String toString() {
        return String.format("Person{name='%s', age=%d, addr='%s', token=%s}",
            name, age, address, sessionToken);
    }
}

// ─── EXTERNALIZABLE ───────────────────────────────────
class Config implements Externalizable {
    private String host;
    private int    port;
    private boolean ssl;

    // Required no-arg constructor for Externalizable
    public Config() { }

    public Config(String host, int port, boolean ssl) {
        this.host = host;
        this.port = port;
        this.ssl  = ssl;
    }

    @Override
    public void writeExternal(ObjectOutput out) throws IOException {
        out.writeUTF(host);
        out.writeInt(port);
        out.writeBoolean(ssl);
    }

    @Override
    public void readExternal(ObjectInput in) throws IOException {
        this.host = in.readUTF();
        this.port = in.readInt();
        this.ssl  = in.readBoolean();
    }

    @Override public String toString() {
        return String.format("Config{host='%s', port=%d, ssl=%b}", host, port, ssl);
    }
}

public class SerializationDeep {
    public static void main(String[] args) throws Exception {
        Path file = Files.createTempFile("serial", ".ser");

        // ─── BASIC SERIALIZATION ──────────────────────────
        System.out.println("=== Serialization ===");
        Address addr = new Address("123 Main St", "London", "UK");
        Person alice = new Person("Alice", 28, addr);

        System.out.println("  Original: " + alice);
        System.out.println("  Token:    " + alice.sessionToken);

        // Serialize
        try (ObjectOutputStream oos = new ObjectOutputStream(
                new BufferedOutputStream(new FileOutputStream(file.toFile())))) {
            oos.writeObject(alice);
        }
        System.out.println("  Serialized to: " + file + " (" + Files.size(file) + " bytes)");

        // Deserialize
        Person loaded;
        try (ObjectInputStream ois = new ObjectInputStream(
                new BufferedInputStream(new FileInputStream(file.toFile())))) {
            loaded = (Person) ois.readObject();
        }
        System.out.println("\n  Deserialized: " + loaded);
        System.out.println("  Token after deser: " + loaded.sessionToken + " (null — transient!)");
        System.out.println("  Cache after deser: " + loaded.cache + " (re-initialized!)");

        // ─── MULTIPLE OBJECTS ─────────────────────────────
        System.out.println("\n=== Multiple Objects ===");
        List<Person> team = List.of(
            new Person("Bob",   32, new Address("456 Oak Ave", "Paris",  "FR")),
            new Person("Carol", 25, new Address("789 Pine Rd", "Berlin", "DE"))
        );

        Path teamFile = Files.createTempFile("team", ".ser");
        try (ObjectOutputStream oos = new ObjectOutputStream(
                new FileOutputStream(teamFile.toFile()))) {
            oos.writeObject(team);
            oos.writeInt(team.size());           // also write a primitive
            oos.writeUTF("Team Alpha");          // and a string
        }

        try (ObjectInputStream ois = new ObjectInputStream(
                new FileInputStream(teamFile.toFile()))) {
            @SuppressWarnings("unchecked")
            List<Person> restoredTeam = (List<Person>) ois.readObject();
            int  count    = ois.readInt();
            String teamName = ois.readUTF();
            System.out.println("  Team: " + teamName + " (" + count + " members)");
            restoredTeam.forEach(p -> System.out.println("    " + p));
        }

        // ─── EXTERNALIZABLE ───────────────────────────────
        System.out.println("\n=== Externalizable ===");
        Config cfg = new Config("db.example.com", 5432, true);
        Path cfgFile = Files.createTempFile("cfg", ".ext");

        try (ObjectOutputStream oos = new ObjectOutputStream(
                new FileOutputStream(cfgFile.toFile()))) {
            oos.writeObject(cfg);
        }

        Config loadedCfg;
        try (ObjectInputStream ois = new ObjectInputStream(
                new FileInputStream(cfgFile.toFile()))) {
            loadedCfg = (Config) ois.readObject();
        }
        System.out.println("  Original:     " + cfg);
        System.out.println("  Deserialized: " + loadedCfg);

        // ─── DEEP CLONE VIA SERIALIZATION ─────────────────
        System.out.println("\n=== Deep Clone via Serialization ===");
        // A trick: serialize to byte array, deserialize as new object
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        try (ObjectOutputStream oos = new ObjectOutputStream(baos)) {
            oos.writeObject(alice);
        }
        Person clone;
        try (ObjectInputStream ois = new ObjectInputStream(
                new ByteArrayInputStream(baos.toByteArray()))) {
            clone = (Person) ois.readObject();
        }
        System.out.println("  Original == clone: " + (alice == clone));        // false
        System.out.println("  Clone name: " + clone.name);
        System.out.println("  Same addr ref: " + (alice.address == clone.address)); // false (deep!)

        // ─── serialVersionUID IMPORTANCE ─────────────────
        System.out.println("\n=== serialVersionUID ===");
        System.out.println("  Always declare: private static final long serialVersionUID = 1L;");
        System.out.println("  Without it: Java generates UID from class structure");
        System.out.println("  If class changes: generated UID changes → InvalidClassException");
        System.out.println("  With explicit UID: you control versioning");

        // ─── MODERN ALTERNATIVES ──────────────────────────
        System.out.println("\n=== Modern Alternatives to Java Serialization ===");
        String[][] alternatives = {
            { "Jackson",    "JSON serialization — most popular, huge ecosystem" },
            { "Gson",       "JSON — simpler API, Google library" },
            { "Protobuf",   "Protocol Buffers — compact binary, language-agnostic" },
            { "Kryo",       "Fast binary serialization for JVM — used in Spark" },
            { "JAXB",       "XML — built into JDK for XML serialization" },
            { "Records+JSON","Java records + Jackson/Gson — ideal for DTOs" },
        };
        for (String[] alt : alternatives) {
            System.out.printf("  %-12s → %s%n", alt[0], alt[1]);
        }

        // Cleanup
        Files.deleteIfExists(file);
        Files.deleteIfExists(teamFile);
        Files.deleteIfExists(cfgFile);
    }
}

📝 KEY POINTS:
✅ Implement Serializable to make a class serializable (marker interface)
✅ ALWAYS declare serialVersionUID = 1L explicitly to control versioning
✅ transient fields are not serialized — reset to default values after deserialization
✅ Static fields are NOT serialized — they belong to the class, not the instance
✅ Custom writeObject/readObject methods allow full control of serialization
✅ Externalizable gives complete manual control — faster, needs no-arg constructor
✅ All referenced objects must also be Serializable or marked transient
✅ Serialization to ByteArrayOutputStream creates an in-memory deep clone
✅ For new code, prefer JSON (Jackson/Gson), protobuf, or records
❌ Never deserialize data from untrusted sources — it's a security vulnerability
❌ Don't skip serialVersionUID — it causes cryptic InvalidClassException on class changes
❌ Changing field names or types in a Serializable class breaks deserialization
❌ Java serialization is slow and produces large output — avoid in performance-critical paths
""",
  quiz: [
    Quiz(question: 'What happens to a field marked transient during serialization?', options: [
      QuizOption(text: 'It is excluded from serialization and reset to its default value (null/0/false) on deserialization', correct: true),
      QuizOption(text: 'It is serialized but encrypted for security', correct: false),
      QuizOption(text: 'It causes a NotSerializableException if the field type is not Serializable', correct: false),
      QuizOption(text: 'It is serialized only if the field has been explicitly set since construction', correct: false),
    ]),
    Quiz(question: 'Why should you always declare serialVersionUID explicitly?', options: [
      QuizOption(text: 'Without it Java generates one based on class structure — any class change breaks deserialization of old data', correct: true),
      QuizOption(text: 'serialVersionUID is required by the Serializable interface — omitting it causes a compile error', correct: false),
      QuizOption(text: 'Explicit UID improves serialization performance by caching the class descriptor', correct: false),
      QuizOption(text: 'It prevents other classes from deserializing your objects without permission', correct: false),
    ]),
    Quiz(question: 'What is the main security concern with Java serialization from untrusted sources?', options: [
      QuizOption(text: 'Malicious byte streams can exploit readObject() to execute arbitrary code — a well-known attack vector', correct: true),
      QuizOption(text: 'Serialization exposes all private fields in plain text over the network', correct: false),
      QuizOption(text: 'Deserialization ignores access modifiers making all fields public', correct: false),
      QuizOption(text: 'The serialized stream contains the class\'s source code which can be decompiled', correct: false),
    ]),
  ],
);

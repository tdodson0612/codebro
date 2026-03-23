import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson74 = Lesson(
  language: 'Java',
  title: 'JVM Internals: Class Loading and Bytecode',
  content: """
🎯 METAPHOR:
The JVM is like a universal translation booth at the
United Nations. Java source code is the speech in your
native language. The Java compiler (javac) translates
it to bytecode — a single universal language all JVMs
understand. When your program runs, the interpreter
in the JVM translates bytecode to your specific CPU's
native instructions — just like the UN booth translates
the universal language to each delegate's native tongue.
The JIT compiler is the experienced interpreter who
notices that certain phrases come up constantly and
memorizes their direct translation — making future
occurrences instant instead of requiring fresh translation.

📖 EXPLANATION:
Understanding JVM internals helps you optimize
performance, diagnose problems, and understand why
Java behaves the way it does.

─────────────────────────────────────
JVM EXECUTION FLOW:
─────────────────────────────────────
  Source code (.java)
      ↓ javac (compiler)
  Bytecode (.class) — platform-independent
      ↓ Class Loader
  Method Area (loaded class metadata)
      ↓ Interpreter / JIT Compiler
  Machine code (CPU-specific, runs natively)

─────────────────────────────────────
CLASS LOADER HIERARCHY:
─────────────────────────────────────
  Bootstrap ClassLoader  → loads rt.jar / java.* classes
        ↓
  Extension/Platform CL  → loads lib/ext, java.se.*
        ↓
  Application ClassLoader → loads your classpath classes
        ↓
  Custom ClassLoaders    → plugins, containers, OSGi

  DELEGATION MODEL: child asks parent first.
  If parent can load the class, child doesn't try.
  Prevents duplicate/conflicting class versions.

─────────────────────────────────────
CLASS LOADING PHASES:
─────────────────────────────────────
  1. LOADING:    Read .class file bytes
  2. LINKING:
     a. Verification: check bytecode is valid
     b. Preparation: allocate static fields, set defaults
     c. Resolution:  resolve symbolic references → direct refs
  3. INITIALIZATION: run static initializers, <clinit>

  Class is initialized at first use:
  → First instance creation
  → First static method/field access
  → Class.forName() call

─────────────────────────────────────
BYTECODE — what javac produces:
─────────────────────────────────────
  Every .class file starts with: CA FE BA BE (magic number)
  Followed by: version, constant pool, access flags, fields,
               methods with bytecode instructions.

  Common bytecode instructions:
  iload, istore       → int load/store from local vars
  iadd, isub, imul    → int arithmetic
  invokevirtual       → call instance method (polymorphic)
  invokestatic        → call static method
  invokeinterface     → call interface method
  new, dup            → create object on heap
  getfield, putfield  → object field access

  // View bytecode:
  javap -c MyClass.class

─────────────────────────────────────
JIT COMPILATION:
─────────────────────────────────────
  JVM starts by interpreting bytecode.
  "Hot" methods (called frequently) are JIT-compiled
  to native machine code for speed.

  Tiers:
  0: Interpretation
  1: C1 compiler (fast, less optimized)
  2: C1 + profiling
  3: C2 compiler (slow compile, highly optimized)

  HotSpot optimizations:
  → Inlining: copy method body to call site
  → Loop unrolling: expand loop iterations
  → Escape analysis: allocate short-lived objects on stack
  → Dead code elimination: remove unreachable code

─────────────────────────────────────
JVM RUNTIME DATA AREAS:
─────────────────────────────────────
  Method Area (Metaspace)  → class metadata, static vars
  Heap                     → objects (GC managed)
  Stack (per thread)       → frames, local vars, operand stack
  PC Register (per thread) → current instruction pointer
  Native Method Stack      → JNI native method frames

─────────────────────────────────────
DYNAMIC CLASS LOADING:
─────────────────────────────────────
  // Load a class by name at runtime:
  Class<?> clazz = Class.forName("com.example.Plugin");

  // Load from custom location:
  URL[] urls = { new URL("file:/path/to/plugin.jar") };
  URLClassLoader loader = new URLClassLoader(urls);
  Class<?> plugin = loader.loadClass("com.example.Plugin");

  // Same class name, different loaders = DIFFERENT classes!
  // This is why ClassCastException can occur across class loaders.

─────────────────────────────────────
jdk.internal TOOLS:
─────────────────────────────────────
  javap -c         → disassemble bytecode
  javap -v         → verbose bytecode + constant pool
  jps              → list Java processes
  jstack <pid>     → thread dump (find deadlocks)
  jmap -heap <pid> → heap usage
  jconsole         → GUI JVM monitoring
  jvisualvm        → advanced profiling

💻 CODE:
import java.lang.reflect.*;

public class JVMInternals {
    static int staticCounter = 0;  // in Method Area
    int instanceId;                  // in Heap (per object)

    static {
        System.out.println("  [Static init] JVMInternals class loaded");
        staticCounter = 100;
    }

    JVMInternals(int id) {
        this.instanceId = id;
        System.out.println("  [Constructor] Created instance #" + id);
    }

    public static void main(String[] args) throws Exception {

        // ─── CLASS LOADER HIERARCHY ───────────────────────
        System.out.println("=== Class Loader Hierarchy ===");
        ClassLoader appCL  = JVMInternals.class.getClassLoader();
        ClassLoader sysCL  = ClassLoader.getSystemClassLoader();
        ClassLoader platCL = sysCL.getParent();

        System.out.println("  App CL:      " + appCL);
        System.out.println("  System CL:   " + sysCL);
        System.out.println("  Platform CL: " + platCL);
        System.out.println("  Bootstrap CL: " + String.class.getClassLoader() + " (null = bootstrap)");

        // ─── CLASS LOADING TIMING ─────────────────────────
        System.out.println("\n=== Class Loading ===");
        System.out.println("  Static block ran when class was first referenced above");
        System.out.println("  staticCounter = " + staticCounter);

        System.out.println("\n  Creating instances:");
        JVMInternals obj1 = new JVMInternals(1);
        JVMInternals obj2 = new JVMInternals(2);

        // ─── CLASS METADATA ───────────────────────────────
        System.out.println("\n=== Class Metadata ===");
        Class<?> clazz = JVMInternals.class;
        System.out.println("  Name:         " + clazz.getName());
        System.out.println("  SimpleName:   " + clazz.getSimpleName());
        System.out.println("  Superclass:   " + clazz.getSuperclass().getName());
        System.out.println("  ClassLoader:  " + clazz.getClassLoader().getClass().getSimpleName());
        System.out.println("  isArray:      " + clazz.isArray());
        System.out.println("  Interfaces:   " + java.util.Arrays.toString(clazz.getInterfaces()));

        // Fields
        System.out.println("  Fields:");
        for (Field f : clazz.getDeclaredFields()) {
            System.out.printf("    %-15s %s %s%n",
                f.getName(), Modifier.toString(f.getModifiers()),
                f.getType().getSimpleName());
        }

        // Methods
        System.out.println("  Declared methods:");
        for (Method m : clazz.getDeclaredMethods()) {
            System.out.printf("    %s %s(%s)%n",
                m.getReturnType().getSimpleName(), m.getName(),
                java.util.Arrays.stream(m.getParameterTypes())
                    .map(Class::getSimpleName)
                    .collect(java.util.stream.Collectors.joining(", ")));
        }

        // ─── DYNAMIC CLASS LOADING ────────────────────────
        System.out.println("\n=== Dynamic Class Loading ===");
        String className = "java.util.HashMap";
        Class<?> dynamicClass = Class.forName(className);
        System.out.println("  Loaded: " + dynamicClass.getName());

        // Create instance via reflection
        Object map = dynamicClass.getDeclaredConstructor().newInstance();
        Method putMethod = dynamicClass.getMethod("put", Object.class, Object.class);
        Method getMethod = dynamicClass.getMethod("get", Object.class);

        putMethod.invoke(map, "key", "value");
        Object retrieved = getMethod.invoke(map, "key");
        System.out.println("  Dynamic map.get('key') = " + retrieved);

        // ─── JVM VERSION AND INFO ─────────────────────────
        System.out.println("\n=== JVM Information ===");
        System.out.println("  JVM name:     " + System.getProperty("java.vm.name"));
        System.out.println("  JVM version:  " + System.getProperty("java.vm.version"));
        System.out.println("  Java version: " + System.getProperty("java.version"));
        System.out.println("  Spec version: " + System.getProperty("java.specification.version"));

        // ─── BYTECODE VIEWING REFERENCE ───────────────────
        System.out.println("\n=== Bytecode Tools ===");
        System.out.println("  View bytecode: javap -c YourClass.class");
        System.out.println("  Verbose:       javap -v YourClass.class");
        System.out.println("  Example output for a simple method:");
        System.out.println("""
            public static int add(int, int);
              Code:
                 0: iload_0          // load first param
                 1: iload_1          // load second param
                 2: iadd             // add them
                 3: ireturn          // return result
          """);

        // ─── JVM TUNING REFERENCE ─────────────────────────
        System.out.println("=== JVM Flags Reference ===");
        String[][] flags = {
            { "-Xms512m",                "Initial heap size" },
            { "-Xmx4g",                  "Max heap size" },
            { "-Xss256k",                "Thread stack size" },
            { "-XX:+UseG1GC",            "Use G1 garbage collector" },
            { "-XX:+UseZGC",             "Use ZGC (low latency)" },
            { "-XX:+PrintGCDetails",     "Verbose GC logging" },
            { "-XX:+HeapDumpOnOutOfMemoryError", "Dump on OOME" },
            { "-verbose:class",          "Log class loading" },
            { "-XX:+TieredCompilation",  "Enable JIT tiers (default on)" },
            { "-XX:CompileThreshold=100","JIT after 100 calls (default 10k)" },
        };
        for (String[] flag : flags) {
            System.out.printf("  %-40s → %s%n", flag[0], flag[1]);
        }
    }
}

📝 KEY POINTS:
✅ Every .class file starts with CAFEBABE — the Java magic number
✅ Class loading: Loading → Verification → Preparation → Resolution → Initialization
✅ Static initializers run once when the class is first initialized
✅ Class.forName() loads a class by name — triggers initialization
✅ Parent-first delegation: Bootstrap → Platform → Application ClassLoader
✅ JIT compiles "hot" methods to native code after ~10,000 invocations
✅ javap -c shows bytecode; -v shows verbose info including constant pool
✅ jstack shows thread dumps; jconsole/jvisualvm provide live JVM monitoring
✅ Escape analysis allows stack allocation of short-lived objects (faster, no GC)
❌ Classes loaded by different ClassLoaders are different — ClassCastException can occur
❌ Class.forName() throws ClassNotFoundException — always handle it
❌ Don't rely on static initializer order between classes — can cause subtle bugs
❌ Heap size (-Xmx) too small → OutOfMemoryError; too large → long GC pauses
""",
  quiz: [
    Quiz(question: 'What is the delegation model in Java class loading?', options: [
      QuizOption(text: 'A child ClassLoader always asks its parent first — only loads the class itself if the parent cannot find it', correct: true),
      QuizOption(text: 'The child ClassLoader loads all classes first, then delegates failures to the parent', correct: false),
      QuizOption(text: 'All ClassLoaders load classes simultaneously and the first to finish wins', correct: false),
      QuizOption(text: 'Delegation means the parent ClassLoader creates instances that child loaders use', correct: false),
    ]),
    Quiz(question: 'When does a Java class\'s static initializer block run?', options: [
      QuizOption(text: 'The first time the class is initialized — when an instance is created, or its static members are accessed', correct: true),
      QuizOption(text: 'Every time a new instance of the class is created', correct: false),
      QuizOption(text: 'When the JVM starts, before main() is called', correct: false),
      QuizOption(text: 'Static initializers run at compile time, not at runtime', correct: false),
    ]),
    Quiz(question: 'What does the JIT (Just-In-Time) compiler do?', options: [
      QuizOption(text: 'It compiles frequently-called ("hot") bytecode methods to native machine code for faster execution', correct: true),
      QuizOption(text: 'It compiles Java source code to bytecode at runtime instead of using javac', correct: false),
      QuizOption(text: 'It validates bytecode for safety before the interpreter runs it', correct: false),
      QuizOption(text: 'It optimizes garbage collection timing to avoid pauses during method calls', correct: false),
    ]),
  ],
);

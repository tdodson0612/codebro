import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson42 = Lesson(
  language: 'Dart',
  title: 'dart:ffi — Foreign Function Interface',
  content: '''
🎯 METAPHOR:
dart:ffi is like a diplomatic bridge between Dart and
the C world. Dart and C are neighboring countries with
completely different customs and languages. dart:ffi
provides the embassy and visa system: it defines how
Dart types map to C types (your passport conversion),
how to call C functions from Dart (diplomatic meetings),
and how to handle C pointers (navigating foreign laws).
Without this bridge, Dart couldn't use the billions of
lines of existing C/C++ code — native SDKs, system
libraries, performance-critical algorithms.

📖 EXPLANATION:
dart:ffi allows Dart code to call native C functions
and work with C data structures directly. This enables
integration with C libraries, OS APIs, and high-performance
native code. Available on all native platforms.

─────────────────────────────────────
📦 KEY CONCEPTS
─────────────────────────────────────
NativeType hierarchy:
  Void, Bool
  Int8, Int16, Int32, Int64
  Uint8, Uint16, Uint32, Uint64
  Float, Double (ABI-specific: 32/64 bit)
  Pointer<T>  → C pointer
  Struct      → C struct
  Union       → C union
  Array<T>    → fixed-size C array

DynamicLibrary → loaded .so/.dll/.dylib
NativeFunction<T> → C function type
Pointer<T>    → typed C pointer

─────────────────────────────────────
📐 TYPE MAPPING
─────────────────────────────────────
C Type      → Dart FFI Type  → Dart Type
int32_t     → Int32          → int
uint8_t     → Uint8          → int
double      → Double         → double
float       → Float          → double
bool        → Bool           → bool
void*       → Pointer<Void>  → Pointer<Void>
char*       → Pointer<Char>  → String (via .toDartString())
void (*fn)() → NativeFunction<Void Function()>

─────────────────────────────────────
🔑 LOADING A LIBRARY
─────────────────────────────────────
// Load shared library
final lib = DynamicLibrary.open('libsqlite3.so');

// Look up a function
final sqlite3_open = lib.lookupFunction<
  Int32 Function(Pointer<Char>, Pointer<Pointer<Void>>),
  int Function(Pointer<Char>, Pointer<Pointer<Void>>)
>('sqlite3_open');

// System libraries (already loaded)
final libm = DynamicLibrary.process();

─────────────────────────────────────
🏗️  STRUCTS
─────────────────────────────────────
final class Point extends Struct {
  @Int32()
  external int x;
  @Int32()
  external int y;
}

final pointPtr = calloc.allocate<Point>();
pointPtr.ref.x = 10;
pointPtr.ref.y = 20;
calloc.free(pointPtr);

─────────────────────────────────────
⚠️  MEMORY MANAGEMENT
─────────────────────────────────────
C memory is NOT garbage collected!
allocate() / calloc() for C memory — MUST free()!
malloc package: calloc.allocate<T>(), calloc.free(ptr)
Or use arena allocator for automatic cleanup.

💻 CODE:
import 'dart:ffi';
import 'dart:io';
// import 'package:ffi/ffi.dart';  // for String helpers

void main() {
  // ── CALLING SIMPLE C FUNCTIONS ─
  // On Unix systems, libm (math library) is available
  // We'll show the pattern with conceptual examples

  print('=== dart:ffi Examples ===');

  // ── BASIC FFI PATTERN ──────────
  // 1. Load the library
  // (On macOS/Linux, use DynamicLibrary.open for .so/.dylib)
  // (On all platforms, DynamicLibrary.process() for already-loaded libs)

  final libmExample = """
  // Load math library
  final libm = DynamicLibrary.open(
    Platform.isLinux ? 'libm.so.6' : 'libm.dylib'
  );

  // Look up sqrt function
  // C signature: double sqrt(double x);
  final sqrt = libm.lookupFunction<
    Double Function(Double),   // C function type (NativeFunction<...>)
    double Function(double)    // Dart function type
  >('sqrt');

  print(sqrt(144.0));   // 12.0
  print(sqrt(2.0));     // 1.4142135623730951
  """;
  print('libm example:\n\$libmExample');

  // ── STRUCT EXAMPLE ─────────────
  final structExample = """
  // import "package:ffi/ffi.dart" for calloc
  import "dart:ffi";
  import "package:ffi/ffi.dart";

  // Define C struct
  final class Vector2 extends Struct {
    @Float()
    external double x;

    @Float()
    external double y;
  }

  // Allocate on native heap
  final ptr = calloc.allocate<Vector2>();
  ptr.ref.x = 3.0;
  ptr.ref.y = 4.0;

  // Use it
  final mag = sqrt(ptr.ref.x * ptr.ref.x + ptr.ref.y * ptr.ref.y);
  print("Magnitude: \$mag");  // 5.0

  // MUST free — not garbage collected!
  calloc.free(ptr);
  """;
  print('Struct example:\n\$structExample');

  // ── STRINGS IN FFI ─────────────
  final stringExample = """
  import "package:ffi/ffi.dart";

  // Dart String → C String (char*)
  final nativeName = "Alice".toNativeUtf8();   // Pointer<Char>

  // Use in C function call...

  // C String → Dart String
  final dartString = nativeName.toDartString();
  print(dartString);  // Alice

  // Free!
  calloc.free(nativeName);
  """;
  print('String example:\n\$stringExample');

  // ── CALLBACKS ─────────────────
  final callbackExample = """
  // C function that takes a callback
  // void processItems(int count, void (*callback)(int item));

  typedef CallbackType = Void Function(Int32);
  typedef CallbackDart = void Function(int);

  final callback = NativeCallable<CallbackType>.listener(
    (int item) => print("Processing item: \$item"),
  );

  // Pass to C function
  cProcessItems(5, callback.nativeFunction);

  callback.close();  // Clean up native callable
  """;
  print('Callback example:\n\$callbackExample');

  // ── SQLITE INTEGRATION ─────────
  final sqliteExample = """
  // Real-world: Dart FFI bindings for SQLite
  // (package:sqlite3 does this for you!)

  final sqlite3 = DynamicLibrary.open("libsqlite3.so");

  // Open database
  final openFn = sqlite3.lookupFunction<
    Int32 Function(Pointer<Char>, Pointer<Pointer<Void>>),
    int Function(Pointer<Char>, Pointer<Pointer<Void>>)
  >("sqlite3_open");

  using((arena) {
    final path = "/tmp/test.db".toNativeUtf8(allocator: arena);
    final dbPtr = arena.allocate<Pointer<Void>>();

    final rc = openFn(path.cast(), dbPtr);
    if (rc != 0) throw Exception("Failed to open database");

    // ... use database ...

    // Close database
    // arena frees all arena allocations on exit
  });
  """;
  print('SQLite FFI example:\n\$sqliteExample');

  // ── ARENA ALLOCATOR PATTERN ────
  final arenaExample = """
  // import "package:ffi/ffi.dart";

  // Arena automatically frees all allocations at end of using()
  using((arena) {
    // All allocations in this arena are freed when using() exits
    final p1 = arena.allocate<Int32>(count: 10);
    final p2 = "Hello".toNativeUtf8(allocator: arena);

    // use p1 and p2...
    // No need to manually free!
  });  // ← p1 and p2 freed here automatically
  """;
  print('Arena example:\n\$arenaExample');

  // ── WHEN TO USE dart:ffi ────────
  print("""
When to use dart:ffi:
  ✅ Integrating existing C/C++ libraries
  ✅ Accessing OS APIs not wrapped by Dart
  ✅ Performance-critical numeric computation
  ✅ Interfacing with hardware (sensors, serial ports)
  ✅ Using SQLite, OpenSSL, or other C libraries directly

Alternatives to consider:
  📦 package:sqlite3     → FFI bindings for SQLite
  📦 package:ffi         → Helpers for FFI (calloc, using, etc.)
  📦 package:path_provider → File paths (no FFI needed)
  📦 platform channels  → Flutter's way to call native platform code
  📦 ffigen              → Auto-generate FFI bindings from C headers

When NOT to use dart:ffi:
  ❌ For simple platform calls in Flutter → use platform channels
  ❌ When a Dart package already wraps the library
  ❌ When you need to run on web (FFI is native-only)
  ❌ For memory-unsafe operations without careful review
""");
}

📝 KEY POINTS:
✅ dart:ffi bridges Dart and C/C++ native libraries at near-zero overhead
✅ NativeType hierarchy maps C types to Dart: Int32, Double, Pointer<T>, etc.
✅ DynamicLibrary.open() loads a .so/.dll/.dylib; lookupFunction() finds functions
✅ Struct extends lets you map C structs to Dart classes
✅ C memory is NOT garbage collected — always pair allocate with free
✅ Arena allocator (from package:ffi) frees all allocations automatically
✅ package:ffi provides helpers: calloc, using(), String conversion
✅ NativeCallable lets C code call back into Dart functions
❌ Never forget to free native memory — Dart GC doesn't manage it
❌ FFI is native-only — not available on Flutter Web
❌ Prefer existing packages (sqlite3, ffi) over writing raw FFI bindings
''',
  quiz: [
    Quiz(question: 'What is the primary purpose of dart:ffi?', options: [
      QuizOption(text: 'To provide fast file I/O operations', correct: false),
      QuizOption(text: 'To call native C functions and work with C data structures from Dart', correct: true),
      QuizOption(text: 'To create platform channels in Flutter', correct: false),
      QuizOption(text: 'To access web browser APIs', correct: false),
    ]),
    Quiz(question: 'Why must native memory allocated via calloc be manually freed?', options: [
      QuizOption(text: 'Dart\'s garbage collector does manage native memory', correct: false),
      QuizOption(text: 'Native C memory is outside the Dart heap — Dart\'s GC has no knowledge of it', correct: true),
      QuizOption(text: 'calloc allocation is temporary by design', correct: false),
      QuizOption(text: 'It frees automatically after the function exits', correct: false),
    ]),
    Quiz(question: 'What does the arena allocator (from package:ffi) provide?', options: [
      QuizOption(text: 'Garbage collection for native memory', correct: false),
      QuizOption(text: 'Automatic freeing of all arena-allocated memory when using() exits', correct: true),
      QuizOption(text: 'A pool of pre-allocated native memory for performance', correct: false),
      QuizOption(text: 'Thread-safe native memory access', correct: false),
    ]),
  ],
);
import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson79 = Lesson(
  language: 'Java',
  title: 'Java → Android Development: Your Next Step',
  content: """
🎯 METAPHOR:
Learning Java and then moving to Android is like getting
a driver's license and then renting a specific car model
for the first time. The fundamentals — steering, braking,
reading the road — are the same. But this specific car
has different controls for the radio, a unique parking
assist system, and its own quirks. Android IS Java (and
Kotlin), but the "car" — the Android framework — has its
own controls: Activities, Fragments, Jetpack Compose,
Room, Retrofit. Your Java skills are the license.
Android development is learning this specific car.

📖 EXPLANATION:
Everything you've learned in this Java course applies
directly to Android. This lesson bridges you from
Java fundamentals to Android app development.

─────────────────────────────────────
WHAT TRANSFERS DIRECTLY:
─────────────────────────────────────
  ✅ All Java syntax — Android is Java (+ Kotlin)
  ✅ OOP — Activity IS-A Context, Adapter IS-A pattern
  ✅ Collections — ArrayList, HashMap everywhere
  ✅ Lambdas/Streams — Android supports Java 8+
  ✅ Exception handling — try/catch in every callback
  ✅ Interfaces — RecyclerView.Adapter, OnClickListener
  ✅ Generics — LiveData<T>, MutableStateFlow<T>
  ✅ Design patterns — Observer, Singleton, Factory
  ✅ Multithreading — essential for smooth 60fps UI
  ✅ JSON/HTTP — Retrofit + Gson/Moshi

─────────────────────────────────────
ANDROID-SPECIFIC CONCEPTS TO LEARN:
─────────────────────────────────────
  ARCHITECTURE:
  Activity / Fragment     → screen + UI lifecycle
  ViewModel              → survives screen rotation
  LiveData / StateFlow   → observable data
  Repository             → data layer abstraction
  MVVM / MVI             → architectural patterns

  UI:
  Jetpack Compose        → modern declarative UI (Kotlin)
  XML layouts            → traditional imperative UI
  RecyclerView           → efficient scrolling lists
  Constraint/LinearLayout→ view positioning

  DATA:
  Room                   → SQLite ORM (like JPA/Hibernate)
  SharedPreferences      → key-value config storage
  DataStore              → modern async preferences

  NETWORKING:
  Retrofit               → type-safe HTTP (uses OkHttp)
  Gson / Moshi           → JSON serialization
  Coroutines             → Kotlin async (replaces threads)

  ASYNC (Android main thread = UI thread):
  Coroutines + Dispatchers → Kotlin's way
  AsyncTask (deprecated)   → old Java way
  ExecutorService          → works but verbose
  Virtual threads          → coming in Android

  TOOLS:
  Android Studio         → IDE (based on IntelliJ)
  Gradle                 → build system
  ADB                    → Android Debug Bridge (CLI)
  Logcat                 → runtime logging
  Emulator / Device      → testing environment

─────────────────────────────────────
ANDROID ACTIVITY LIFECYCLE (learn this!):
─────────────────────────────────────
  onCreate()   → called when Activity is first created
  onStart()    → Activity becomes visible
  onResume()   → Activity in foreground, user interacting
  onPause()    → Activity partially obscured
  onStop()     → Activity no longer visible
  onDestroy()  → Activity being destroyed

  Common mistakes:
  → Starting heavy work in onCreate() on main thread
  → Leaking resources by not releasing in onStop/onDestroy
  → Ignoring configuration changes (rotation = new Activity)

─────────────────────────────────────
ANDROID PERMISSIONS MODEL:
─────────────────────────────────────
  AndroidManifest.xml:
  <uses-permission android:name="android.permission.INTERNET"/>
  <uses-permission android:name="android.permission.CAMERA"/>

  Runtime permissions (dangerous):
  ActivityCompat.requestPermissions(this, perms, CODE);

─────────────────────────────────────
KOTLIN PREFERENCE IN ANDROID:
─────────────────────────────────────
  Google officially recommends Kotlin for Android.
  You CAN write Android in Java, but:
  → Kotlin is the first-class language in documentation
  → Jetpack Compose is Kotlin-only
  → Coroutines are idiomatic Kotlin
  → New libraries target Kotlin first

  Good news: after this Java course, Kotlin is a SMALL step.
  The Kotlin lessons in this app cover everything you need
  to transition from Java to Kotlin-first Android development.

─────────────────────────────────────
YOUR ANDROID LEARNING PATH:
─────────────────────────────────────
  WEEK 1-2: Setup and basics
  → Install Android Studio
  → Create "Hello World" app
  → Understand Activity, XML layouts, Button onClick

  WEEK 3-4: UI and navigation
  → RecyclerView for lists
  → Multiple screens with Navigation Component
  → Basic Jetpack Compose introduction

  WEEK 5-6: Data and architecture
  → Room database (SQLite)
  → ViewModel + LiveData/StateFlow
  → MVVM architecture pattern

  WEEK 7-8: Networking
  → Retrofit + Gson/Moshi
  → REST API integration
  → Coroutines for async networking

  WEEK 9+: Real app
  → Build a complete feature
  → Handle errors, loading states
  → Testing (JUnit + Espresso)

─────────────────────────────────────
BEST RESOURCES:
─────────────────────────────────────
  📚 Official:
  developer.android.com/courses  → free structured courses
  developer.android.com/jetpack  → Jetpack component docs
  developer.android.com/codelabs → hands-on labs

  📺 Video:
  "Android Basics with Compose" (Google's official course)
  Philipp Lackner (YouTube) → most popular Android channel
  Stevdza-San (YouTube)     → architecture focused

  📖 Books:
  "Android Programming: Big Nerd Ranch Guide"
  "Head First Android Development"

  🛠️ Projects to build:
  1. Todo app (CRUD, Room, ViewModel)
  2. Weather app (Retrofit, API integration)
  3. News reader (RecyclerView, Retrofit, Compose)
  4. Chat app (Firebase, real-time updates)

💻 CODE:
// ─── ANDROID CODE PREVIEW ─────────────────────────────
// This shows what Android code looks like using your Java skills

public class AndroidPreview {
    public static void main(String[] args) {
        System.out.println("=== Android Development Preview ===\n");

        System.out.println("Your Java knowledge maps to Android like this:\n");

        String[][] mapping = {
            { "Java Concept",          "Android Equivalent" },
            { "─────────────────────────────────────────────────────────", "" },
            { "ArrayList<T>",          "RecyclerView.Adapter data source" },
            { "interface OnClick",     "View.OnClickListener" },
            { "Observer pattern",      "LiveData/StateFlow observers" },
            { "Runnable/Thread",       "Coroutine/Dispatcher (Kotlin)" },
            { "HttpClient",            "Retrofit HTTP client" },
            { "Gson/Jackson",          "Gson/Moshi JSON parsing" },
            { "Room ≈ JPA/Hibernate",  "@Entity, @Dao, @Database" },
            { "Log.d() ≈ SLF4J",       "Logcat output" },
            { "Singleton pattern",     "Application class / Hilt DI" },
            { "Repository pattern",    "Android Repository (MVVM)" },
            { "ViewModel (Java)",      "androidx.lifecycle.ViewModel" },
            { "Properties files",      "SharedPreferences/DataStore" },
        };

        for (String[] row : mapping) {
            if (row[1].isEmpty()) System.out.println("  " + row[0]);
            else System.out.printf("  %-30s → %s%n", row[0], row[1]);
        }

        System.out.println("\n=== Sample Android Activity (Java) ===\n");
        System.out.println("""
          // Activity = a screen in your app
          public class MainActivity extends AppCompatActivity {

              private Button button;
              private TextView textView;

              @Override
              protected void onCreate(Bundle savedInstanceState) {
                  super.onCreate(savedInstanceState);
                  setContentView(R.layout.activity_main);  // set XML layout

                  // Find views (your Java skills apply here)
                  button   = findViewById(R.id.button);
                  textView = findViewById(R.id.textView);

                  // Set click listener (familiar interface/lambda pattern)
                  button.setOnClickListener(view -> {
                      textView.setText("Hello, Android!");
                  });
              }

              @Override
              protected void onPause() {
                  super.onPause();
                  // Save state when app loses focus
              }
          }
          """);

        System.out.println("=== Jetpack Compose (Kotlin) ===\n");
        System.out.println("""
          // Compose: declarative UI (like Flutter!)
          @Composable
          fun Greeting(name: String) {
              Column(modifier = Modifier.padding(16.dp)) {
                  Text(text = "Hello, $name!")
                  Button(onClick = { /* handle click */ }) {
                      Text("Press me")
                  }
              }
          }
          // Familiar: functions, parameters, events — just different syntax
          """);

        System.out.println("=== Your Next Steps ===\n");
        System.out.println("  1. Complete the Kotlin lessons in this app");
        System.out.println("     (Kotlin is a small step from Java)");
        System.out.println();
        System.out.println("  2. Install Android Studio:");
        System.out.println("     developer.android.com/studio");
        System.out.println();
        System.out.println("  3. Follow Google's official course:");
        System.out.println("     developer.android.com/courses/android-basics-compose");
        System.out.println();
        System.out.println("  4. Build the Todo app first — you know enough Java!");
        System.out.println();
        System.out.println("  5. Join the community:");
        System.out.println("     reddit.com/r/androiddev");
        System.out.println("     discord.gg/androiddev");
    }
}

📝 KEY POINTS:
✅ All Java fundamentals transfer directly to Android — OOP, collections, patterns, threading
✅ Android lifecycle (onCreate → onStart → onResume → onPause → onStop → onDestroy) is critical
✅ Never do heavy work on the Android main (UI) thread — always use background threading
✅ Google officially recommends Kotlin + Jetpack Compose for new Android development
✅ Your Java foundation makes Kotlin transition very fast — they share JVM and many patterns
✅ MVVM (ViewModel + LiveData) is the recommended Android architecture pattern
✅ Retrofit is the industry-standard HTTP client for Android (built on OkHttp)
✅ Room is JPA/Hibernate for Android — same patterns, Android-optimized
✅ Start with: developer.android.com/courses — official, free, structured
❌ Don't write Android in Java if starting fresh — Kotlin is now the standard
❌ Don't do network calls on the main thread — Android throws NetworkOnMainThreadException
❌ Don't ignore the Activity lifecycle — it's the source of most Android bugs
❌ Don't skip architecture patterns — apps without ViewModel/LiveData become unmaintainable
""",
  quiz: [
    Quiz(question: 'Why does Google recommend Kotlin over Java for new Android development?', options: [
      QuizOption(text: 'Kotlin is the first-class language with Jetpack Compose (Kotlin-only), coroutines, and new libraries targeting Kotlin first', correct: true),
      QuizOption(text: 'Java is no longer supported on Android — only Kotlin compiles to Android bytecode', correct: false),
      QuizOption(text: 'Kotlin apps are faster than Java apps because Kotlin avoids JVM overhead', correct: false),
      QuizOption(text: 'Kotlin apps use less memory because they don\'t require the full Java runtime', correct: false),
    ]),
    Quiz(question: 'What is the Android Activity lifecycle method called when the Activity first becomes visible to the user?', options: [
      QuizOption(text: 'onStart() — the Activity becomes visible but may not yet be in the foreground', correct: true),
      QuizOption(text: 'onCreate() — the Activity is created and made visible simultaneously', correct: false),
      QuizOption(text: 'onResume() — the Activity gains focus and becomes visible at the same time', correct: false),
      QuizOption(text: 'onShow() — Android\'s method for making an Activity visible', correct: false),
    ]),
    Quiz(question: 'What Java pattern does Android\'s LiveData/StateFlow implement?', options: [
      QuizOption(text: 'The Observer pattern — UI components subscribe and are notified when data changes', correct: true),
      QuizOption(text: 'The Singleton pattern — one LiveData instance serves all observers', correct: false),
      QuizOption(text: 'The Factory pattern — LiveData creates different data types based on configuration', correct: false),
      QuizOption(text: 'The Strategy pattern — different data-fetching strategies are swappable', correct: false),
    ]),
  ],
);

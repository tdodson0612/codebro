import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson36 = Lesson(
  language: 'Kotlin',
  title: 'Kotlin Multiplatform (KMP)',
  content: """
🎯 METAPHOR:
Kotlin Multiplatform is like a restaurant chain's central
kitchen that preps the core dishes — sauces, stocks, dough
— that every branch location uses. Each branch (iOS, Android,
Web, Desktop) still has its own local chefs who handle
what's unique to them: presentation style, local specials,
kitchen layout. But the fundamental recipes (business logic,
data models, API calls) come from the central kitchen.
You write the core once. Each platform adds what it
needs natively. No compromise on native quality, and no
duplication of the shared core.

📖 EXPLANATION:
Kotlin Multiplatform (KMP) lets you share Kotlin code
across platforms: Android, iOS, JVM (desktop/server),
JavaScript (web), and native binaries.

─────────────────────────────────────
KMP vs CROSS-PLATFORM FRAMEWORKS:
─────────────────────────────────────
  Framework    Approach             UI
  ──────────────────────────────────────────────
  KMP          Share business logic  Native UI per platform
  Flutter      Full cross-platform   Custom rendered UI
  React Native Share JS logic        Native UI components
  Xamarin      Share C# logic        Platform UI or Xamarin.Forms

KMP's philosophy: share LOGIC, not UI.
Each platform gets native UI performance and look.

─────────────────────────────────────
PROJECT STRUCTURE:
─────────────────────────────────────
  shared/
  ├── commonMain/    ← shared Kotlin code (ALL platforms)
  │   └── kotlin/
  │       └── com/example/
  │           ├── data/
  │           ├── domain/
  │           └── utils/
  ├── androidMain/   ← Android-specific code
  ├── iosMain/       ← iOS-specific code
  ├── jvmMain/       ← JVM-specific code
  └── jsMain/        ← JavaScript-specific code

  androidApp/    ← Android app (uses shared + androidMain)
  iosApp/        ← iOS app (uses shared + iosMain)

─────────────────────────────────────
expect / actual — the KMP mechanism:
─────────────────────────────────────
When you need platform-specific behavior, use expect/actual.

  // In commonMain — the DECLARATION
  expect fun getPlatformName(): String
  expect class DatabaseDriver(path: String)

  // In androidMain — the Android IMPLEMENTATION
  actual fun getPlatformName() = "Android"
  actual class DatabaseDriver(path: String) {
      // Uses Android SQLite
  }

  // In iosMain — the iOS IMPLEMENTATION
  actual fun getPlatformName() = "iOS"
  actual class DatabaseDriver(path: String) {
      // Uses iOS SQLite
  }

─────────────────────────────────────
WHAT TO SHARE (commonMain):
─────────────────────────────────────
  ✅ Data models (User, Product, Order)
  ✅ Business logic (calculations, validation)
  ✅ API client code (network requests)
  ✅ Repository patterns
  ✅ Use cases / interactors
  ✅ Serialization (kotlinx.serialization)
  ✅ Coroutines and Flow

─────────────────────────────────────
WHAT STAYS PLATFORM-SPECIFIC:
─────────────────────────────────────
  ❌ UI (stays native: Jetpack Compose / SwiftUI)
  ❌ Platform permissions (camera, location, etc.)
  ❌ Platform-specific SDKs (Google Maps, etc.)
  ❌ Push notifications (APNS vs FCM)

─────────────────────────────────────
KEY KMP LIBRARIES:
─────────────────────────────────────
  kotlinx.serialization → JSON serialization
  kotlinx.coroutines    → async/suspend (shared)
  kotlinx.datetime      → date/time (cross-platform)
  Ktor                  → HTTP client (multiplatform)
  SQLDelight            → database (multiplatform)
  Koin                  → dependency injection (multiplatform)

─────────────────────────────────────
BUILD CONFIGURATION (build.gradle.kts):
─────────────────────────────────────
  kotlin {
      androidTarget()
      iosX64()
      iosArm64()
      iosSimulatorArm64()

      sourceSets {
          val commonMain by getting {
              dependencies {
                  implementation("io.ktor:ktor-client-core:2.x")
                  implementation("org.jetbrains.kotlinx:kotlinx-serialization-json:1.x")
              }
          }
          val androidMain by getting { ... }
          val iosMain by getting { ... }
      }
  }

─────────────────────────────────────
KOTLIN/JS — for web:
─────────────────────────────────────
  kotlin {
      js(IR) {
          browser()
          nodejs()
      }
  }

  // Kotlin can call JavaScript directly:
  external fun alert(message: String)
  external val window: dynamic

  // Export Kotlin to JS:
  @JsExport
  fun greet(name: String) = "Hello, \$name!"

💻 CODE:
// ─── commonMain code (shared across all platforms) ───

// Data models — shared
data class User(
    val id: String,
    val name: String,
    val email: String,
    val createdAt: Long  // epoch millis — platform-independent
)

data class ApiResponse<T>(
    val data: T?,
    val error: String?,
    val success: Boolean
)

// Business logic — shared
object UserValidator {
    fun validateEmail(email: String): Boolean =
        email.contains("@") && email.contains(".") && email.length >= 5

    fun validateName(name: String): Boolean =
        name.trim().length in 2..100

    fun validate(user: User): List<String> {
        val errors = mutableListOf<String>()
        if (!validateName(user.name)) errors.add("Name must be 2-100 characters")
        if (!validateEmail(user.email)) errors.add("Email is invalid")
        return errors
    }
}

// Repository pattern — shared interface
interface UserRepository {
    suspend fun getUser(id: String): User?
    suspend fun getUsers(): List<User>
    suspend fun saveUser(user: User): Boolean
    suspend fun deleteUser(id: String): Boolean
}

// In-memory implementation — shared (usable in tests)
class InMemoryUserRepository : UserRepository {
    private val users = mutableMapOf<String, User>()

    override suspend fun getUser(id: String): User? = users[id]
    override suspend fun getUsers(): List<User> = users.values.toList()
    override suspend fun saveUser(user: User): Boolean {
        users[user.id] = user
        return true
    }
    override suspend fun deleteUser(id: String): Boolean = users.remove(id) != null
}

// Use case — shared
class GetUserUseCase(private val repository: UserRepository) {
    suspend operator fun invoke(id: String): ApiResponse<User> {
        return try {
            val user = repository.getUser(id)
            if (user != null) ApiResponse(user, null, true)
            else ApiResponse(null, "User not found", false)
        } catch (e: Exception) {
            ApiResponse(null, e.message ?: "Unknown error", false)
        }
    }
}

// expect/actual demonstration (platform-specific time)
// In real KMP this would use expect/actual:
// expect fun currentTimeMillis(): Long
// androidMain: actual fun currentTimeMillis() = System.currentTimeMillis()
// iosMain: actual fun currentTimeMillis() = ... (platform call)

// For this demo, using JVM directly:
fun currentTimeMillis(): Long = System.currentTimeMillis()

fun main() {
    println("=== Shared Business Logic Demo ===")
    println("(This code would run identically on Android, iOS, JVM, JS)")
    println()

    // Data models work everywhere
    val user = User(
        id = "u001",
        name = "Terry Smith",
        email = "terry@example.com",
        createdAt = currentTimeMillis()
    )
    println("User: \$user")

    // Validation — shared logic
    println("\\n=== Validation ===")
    val validErrors = UserValidator.validate(user)
    println("Valid user errors: \$validErrors")   // []

    val invalidUser = User("u002", "X", "notanemail", currentTimeMillis())
    val invalidErrors = UserValidator.validate(invalidUser)
    println("Invalid user errors: \$invalidErrors")

    // Repository — shared pattern
    println("\\n=== Repository ===")
    val repo = InMemoryUserRepository()

    kotlinx.coroutines.runBlocking {
        repo.saveUser(user)
        repo.saveUser(User("u002", "Sam Jones", "sam@example.com", currentTimeMillis()))

        println("All users: ${
repo.getUsers().map { it.name }}")

        val getUser = GetUserUseCase(repo)
        val response1 = getUser("u001")
        println("Get u001: success=${
response1.success}, name=${
response1.data?.name}")

        val response2 = getUser("u999")
        println("Get u999: success=${
response2.success}, error=${
response2.error}")

        repo.deleteUser("u002")
        println("After delete: ${
repo.getUsers().map { it.name }}")
    }

    // Platform name — would use expect/actual in real KMP
    println("\\n=== Platform ===")
    println("Platform: JVM (in real KMP, would show Android or iOS)")
    println("KMP shared code runs IDENTICALLY on every platform")
}

📝 KEY POINTS:
✅ KMP shares business logic — each platform keeps native UI
✅ commonMain code runs on ALL targets unchanged
✅ expect/actual declares platform APIs in common, implements per platform
✅ Ktor, SQLDelight, kotlinx.serialization, and Koin support KMP
✅ Repository pattern + use cases are ideal for sharing
✅ Kotlin/JS lets Kotlin compile to JavaScript for web
✅ Shared code gets the full benefit of Kotlin: null safety, coroutines, etc.
❌ KMP is not Flutter — UI stays native and platform-specific
❌ Not all Kotlin libraries support KMP — check targets before using
❌ expect/actual can become complex — only use where needed
❌ iOS integration via CocoaPods or Swift Package Manager adds build complexity
""",
  quiz: [
    Quiz(question: 'What is the primary philosophy of Kotlin Multiplatform compared to Flutter?', options: [
      QuizOption(text: 'KMP shares business logic while keeping native UI per platform; Flutter shares everything including UI', correct: true),
      QuizOption(text: 'KMP shares the UI and logic; Flutter only shares the logic layer', correct: false),
      QuizOption(text: 'KMP compiles to native machine code; Flutter runs on a virtual machine', correct: false),
      QuizOption(text: 'They have the same philosophy — both are full cross-platform solutions', correct: false),
    ]),
    Quiz(question: 'What do the expect and actual keywords do in Kotlin Multiplatform?', options: [
      QuizOption(text: 'expect declares a platform API in common code; actual provides the implementation per platform', correct: true),
      QuizOption(text: 'expect checks a condition at compile time; actual handles the false case', correct: false),
      QuizOption(text: 'expect defines the shared interface; actual creates a type-safe mock for testing', correct: false),
      QuizOption(text: 'They are synonyms for abstract and override in multiplatform contexts', correct: false),
    ]),
    Quiz(question: 'Which of these belongs in commonMain (shared across all platforms)?', options: [
      QuizOption(text: 'Business logic, data models, API client code, and repository implementations', correct: true),
      QuizOption(text: 'UI components, platform permissions, and native SDK integrations', correct: false),
      QuizOption(text: 'Only data models — all logic must remain platform-specific', correct: false),
      QuizOption(text: 'Push notification handling and camera access code', correct: false),
    ]),
  ],
);

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson51 = Lesson(
  language: 'Kotlin',
  title: 'Introduction to Android Development',
  content: """
🎯 METAPHOR:
Building an Android app is like building a restaurant.
You've spent this whole course learning to cook (Kotlin).
Now it's time to open the restaurant. The kitchen is Kotlin
— your business logic, data models, and coroutines. The
dining room is the UI — screens, buttons, and layouts.
The menu is your app's navigation — which screen the user
sees and when. The waitstaff are ViewModels — they take
orders from the dining room and pass them to the kitchen,
then bring results back. The health inspector is Android's
lifecycle — strict rules about when you can do what, and
what happens when the customer walks out mid-meal.
Learning to cook was essential. Now you need to understand
the whole restaurant.

📖 EXPLANATION:
Android development with Kotlin builds on everything you've
learned. Here's the landscape: what the key pieces are,
how they connect, and where to go deeper.

─────────────────────────────────────
THE ANDROID TECH STACK (modern):
─────────────────────────────────────
  Layer           Technology
  ──────────────────────────────────────────────────
  UI              Jetpack Compose (modern) or XML Views
  State/Logic     ViewModel + StateFlow
  Navigation      Navigation Compose
  Local data      Room (SQLite) or DataStore
  Network         Retrofit + OkHttp OR Ktor Client
  Serialization   kotlinx.serialization or Gson/Moshi
  DI              Hilt (recommended) or Koin
  Async           Coroutines + Flow
  Images          Coil (Kotlin-native image loader)
  Testing         JUnit5 + MockK + Espresso/Compose Test

─────────────────────────────────────
KEY ANDROID CONCEPTS TO LEARN:
─────────────────────────────────────

1. ACTIVITY and FRAGMENT lifecycle
   An Activity is a single screen. It goes through states:
   onCreate → onStart → onResume → onPause → onStop → onDestroy
   
   Each state matters: if you start a coroutine in onCreate
   but don't cancel it in onDestroy, you have a memory leak.
   In modern Android you mostly use fragments OR Compose
   destinations rather than multiple activities.

2. JETPACK COMPOSE — the modern UI toolkit
   Compose replaces XML layouts. UI is written in Kotlin
   using composable functions:

   @Composable
   fun Greeting(name: String) {
       Text(text = "Hello, \$name!")
   }

   Compose is DECLARATIVE — you describe WHAT the UI should
   look like given state. Kotlin handles the HOW.
   This is the direction all new Android projects should take.
   Research: "Jetpack Compose tutorial Android"

3. VIEWMODEL — surviving configuration changes
   When the user rotates the screen, Activities are destroyed
   and recreated. ViewModel survives rotation — it holds
   your UI state and data safely.

   class UserViewModel : ViewModel() {
       private val _users = MutableStateFlow<List<User>>(emptyList())
       val users: StateFlow<List<User>> = _users.asStateFlow()

       fun loadUsers() {
           viewModelScope.launch {
               _users.value = repository.getUsers()
           }
       }
   }

   viewModelScope is a CoroutineScope tied to the ViewModel's
   lifetime — automatically cancelled when ViewModel is cleared.

4. ROOM — local database
   Room is a SQLite wrapper that uses annotations and Kotlin.

   @Entity
   data class User(
       @PrimaryKey val id: Int,
       val name: String,
       val email: String
   )

   @Dao
   interface UserDao {
       @Query("SELECT * FROM user")
       fun getAll(): Flow<List<User>>

       @Insert
       suspend fun insert(user: User)
   }

   Notice: getAll() returns Flow<List<User>> — the UI
   automatically updates when the database changes!

5. HILT — dependency injection
   Hilt (built on Dagger) wires your app together so you
   don't have to manually create and pass dependencies.

   @HiltViewModel
   class UserViewModel @Inject constructor(
       private val repository: UserRepository
   ) : ViewModel()

   @AndroidEntryPoint
   class MainActivity : ComponentActivity()

6. RETROFIT — network requests
   Retrofit turns an interface into a REST API client:

   interface ApiService {
       @GET("users")
       suspend fun getUsers(): List<User>

       @POST("users")
       suspend fun createUser(@Body user: User): User
   }

7. NAVIGATION COMPOSE
   Navigate between screens with type-safety:

   NavHost(navController, startDestination = "home") {
       composable("home") { HomeScreen(navController) }
       composable("profile/{userId}") { backStack ->
           val id = backStack.arguments?.getString("userId")
           ProfileScreen(id)
       }
   }

─────────────────────────────────────
THE ARCHITECTURE — MVVM:
─────────────────────────────────────
Modern Android apps use MVVM (Model-View-ViewModel):

  UI (Compose)
      ↕ observes StateFlow / sends events
  ViewModel
      ↕ calls use cases
  Repository
      ↕ decides: network or local cache?
  Data Sources
      ├── Remote (Retrofit/Ktor)
      └── Local (Room/DataStore)

Everything you learned about sealed classes, StateFlow,
coroutines, data classes, and null safety is used here
constantly. This is where your Kotlin knowledge pays off.

─────────────────────────────────────
WHAT A MODERN ANDROID PROJECT LOOKS LIKE:
─────────────────────────────────────
  app/
  ├── di/               ← Hilt dependency injection modules
  ├── data/
  │   ├── local/        ← Room database, DAOs, entities
  │   ├── remote/       ← Retrofit service interfaces, DTOs
  │   └── repository/   ← Repository implementations
  ├── domain/
  │   ├── model/        ← Clean data models (not tied to DB/API)
  │   └── usecase/      ← Business logic use cases
  └── ui/
      ├── screens/      ← Composable screens
      ├── components/   ← Reusable composable components
      └── viewmodel/    ← ViewModels per screen

─────────────────────────────────────
YOUR LEARNING ROADMAP:
─────────────────────────────────────
Follow this path to go from Kotlin knowledge to Android dev:

  STEP 1 — Jetpack Compose basics
  → developer.android.com/compose
  → "Compose pathway" on Android developer site
  → Build: a simple counter, todo list, calculator

  STEP 2 — ViewModel + StateFlow
  → "Android ViewModel guide" official docs
  → Build: a screen that survives rotation

  STEP 3 — Navigation Compose
  → "Navigation with Compose" official docs
  → Build: a multi-screen app

  STEP 4 — Room database
  → "Room persistence library" official docs
  → Build: a notes app that saves to local storage

  STEP 5 — Retrofit + Coroutines
  → "Retrofit Android tutorial"
  → Build: an app that fetches data from a real API

  STEP 6 — Hilt dependency injection
  → "Hilt Android guide" official docs
  → Refactor your app to use proper DI

  STEP 7 — Full project
  → Build a complete app with all layers connected
  → "Now in Android" open source app on GitHub is
     the gold standard reference — study it!

─────────────────────────────────────
ESSENTIAL RESOURCES:
─────────────────────────────────────
  📖 Official Android Docs:
     developer.android.com/docs

  📖 Compose Documentation:
     developer.android.com/compose

  📖 "Now in Android" sample (Google's reference app):
     github.com/android/nowinandroid

  📖 Android Developers YouTube channel:
     youtube.com/@AndroidDevelopers

  📖 Philipp Lackner (YouTube — best Kotlin/Android tutorials):
     youtube.com/@PhilippLackner

  📖 Android weekly newsletter:
     androidweekly.net

💻 CODE:
// This gives a taste of what Android Kotlin code looks like.
// This won't compile standalone — it needs the Android SDK.
// It's here to show you the patterns and make them familiar.

/*

// ─── A complete minimal feature in modern Android ─────

// 1. DATA LAYER — model and repository

data class Post(val id: Int, val title: String, val body: String)

interface PostRepository {
    fun getPosts(): Flow<List<Post>>
    suspend fun refreshPosts()
}

class PostRepositoryImpl(
    private val api: PostApiService,
    private val dao: PostDao
) : PostRepository {

    // Emit from local DB, refresh from network in background
    override fun getPosts(): Flow<List<Post>> = dao.getAll()

    override suspend fun refreshPosts() {
        val posts = api.getPosts()
        dao.insertAll(posts.map { it.toEntity() })
    }
}

// 2. VIEWMODEL — bridges data and UI

@HiltViewModel
class PostViewModel @Inject constructor(
    private val repository: PostRepository
) : ViewModel() {

    sealed class UiState {
        data object Loading : UiState()
        data class Success(val posts: List<Post>) : UiState()
        data class Error(val message: String) : UiState()
    }

    private val _uiState = MutableStateFlow<UiState>(UiState.Loading)
    val uiState: StateFlow<UiState> = _uiState.asStateFlow()

    init {
        loadPosts()
    }

    private fun loadPosts() {
        viewModelScope.launch {
            try {
                repository.getPosts().collect { posts ->
                    _uiState.value = UiState.Success(posts)
                }
            } catch (e: Exception) {
                _uiState.value = UiState.Error(e.message ?: "Unknown error")
            }
        }
    }
}

// 3. UI — Jetpack Compose screen

@Composable
fun PostListScreen(
    viewModel: PostViewModel = hiltViewModel()
) {
    val uiState by viewModel.uiState.collectAsStateWithLifecycle()

    when (val state = uiState) {
        is PostViewModel.UiState.Loading -> {
            Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                CircularProgressIndicator()
            }
        }
        is PostViewModel.UiState.Success -> {
            LazyColumn {
                items(state.posts) { post ->
                    PostItem(post = post)
                }
            }
        }
        is PostViewModel.UiState.Error -> {
            Text(
                text = "Error: \${state.message}",
                color = MaterialTheme.colorScheme.error
            )
        }
    }
}

@Composable
fun PostItem(post: Post) {
    Card(modifier = Modifier.fillMaxWidth().padding(8.dp)) {
        Column(modifier = Modifier.padding(16.dp)) {
            Text(text = post.title, style = MaterialTheme.typography.titleMedium)
            Spacer(modifier = Modifier.height(4.dp))
            Text(text = post.body, style = MaterialTheme.typography.bodyMedium,
                maxLines = 2, overflow = TextOverflow.Ellipsis)
        }
    }
}

*/

// ─── Standalone Kotlin version of the same patterns ───
// (runs without Android SDK — pure Kotlin)

import kotlinx.coroutines.*
import kotlinx.coroutines.flow.*

data class Post(val id: Int, val title: String, val body: String)

// Repository pattern
class InMemoryPostRepository {
    private val _posts = MutableStateFlow<List<Post>>(emptyList())
    val posts: StateFlow<List<Post>> = _posts.asStateFlow()

    suspend fun refresh() {
        delay(500)  // simulate network
        _posts.value = listOf(
            Post(1, "Kotlin is Great", "Kotlin makes Android development a joy."),
            Post(2, "Compose is the Future", "Jetpack Compose revolutionizes UI."),
            Post(3, "Coroutines Rock", "Async code that reads like sync code.")
        )
    }
}

// ViewModel-like class
class PostViewModel(private val repo: InMemoryPostRepository) {
    sealed class UiState {
        data object Loading : UiState()
        data class Success(val posts: List<Post>) : UiState()
        data class Error(val message: String) : UiState()
    }

    private val _uiState = MutableStateFlow<UiState>(UiState.Loading)
    val uiState: StateFlow<UiState> = _uiState.asStateFlow()

    fun load(scope: CoroutineScope) {
        scope.launch {
            try {
                repo.refresh()
                repo.posts.collect { posts ->
                    _uiState.value = UiState.Success(posts)
                }
            } catch (e: Exception) {
                _uiState.value = UiState.Error(e.message ?: "Unknown")
            }
        }
    }
}

fun main() = runBlocking {
    println("=== Android MVVM pattern (pure Kotlin demo) ===\\n")

    val repo = InMemoryPostRepository()
    val viewModel = PostViewModel(repo)

    // Simulate UI observing the state
    val uiJob = launch {
        viewModel.uiState.collect { state ->
            when (state) {
                is PostViewModel.UiState.Loading ->
                    println("UI: Showing loading spinner...")
                is PostViewModel.UiState.Success -> {
                    println("UI: Showing \${state.posts.size} posts:")
                    state.posts.forEach { post ->
                        println("  • \${post.title}")
                    }
                }
                is PostViewModel.UiState.Error ->
                    println("UI: Error — \${state.message}")
            }
        }
    }

    viewModel.load(this)
    delay(1000)
    uiJob.cancel()

    println("\\n=== Your Android journey starts here! ===")
    println("The patterns above (StateFlow, ViewModel, Repository)")
    println("are exactly what you'll use in real Android apps.")
    println("\\nNext steps:")
    println("  1. developer.android.com/compose")
    println("  2. Search: 'Philipp Lackner Android tutorial'")
    println("  3. Study: github.com/android/nowinandroid")
}

📝 KEY POINTS:
✅ Android development uses all your Kotlin knowledge immediately
✅ Jetpack Compose is the modern way to build Android UI — learn this first
✅ ViewModel survives screen rotation — holds UI state safely
✅ StateFlow + collect = reactive UI that updates automatically
✅ Room + Flow = database changes automatically push to the UI
✅ MVVM separates UI, business logic, and data cleanly
✅ Hilt handles dependency injection so you don't wire things manually
✅ viewModelScope auto-cancels coroutines when ViewModel is cleared
✅ "Now in Android" on GitHub is the gold standard reference project
❌ Don't learn old XML View system — go straight to Compose
❌ Don't do network calls on the main thread — always use coroutines
❌ Don't skip architecture — spaghetti code in Activities is a dead end
❌ Don't ignore lifecycle — it causes crashes and memory leaks if ignored
""",
  quiz: [
    Quiz(question: 'What is the purpose of a ViewModel in Android development?', options: [
      QuizOption(text: 'It holds UI state and business logic, surviving configuration changes like screen rotation', correct: true),
      QuizOption(text: 'It renders the UI by converting Kotlin code into XML layouts', correct: false),
      QuizOption(text: 'It manages database connections and SQL queries directly', correct: false),
      QuizOption(text: 'It is the entry point of an Android app — equivalent to main()', correct: false),
    ]),
    Quiz(question: 'Why does Room\'s getAll() return Flow<List<T>> instead of just List<T>?', options: [
      QuizOption(text: 'So the UI automatically receives updated data whenever the database changes', correct: true),
      QuizOption(text: 'Because Room requires all queries to be asynchronous by default', correct: false),
      QuizOption(text: 'Flow is required for pagination support in large databases', correct: false),
      QuizOption(text: 'List<T> is not supported in Room — Flow is the only option', correct: false),
    ]),
    Quiz(question: 'What is the recommended first step when learning Android development after mastering Kotlin?', options: [
      QuizOption(text: 'Jetpack Compose — the modern declarative UI toolkit at developer.android.com/compose', correct: true),
      QuizOption(text: 'XML layouts and View binding — the foundation everything else is built on', correct: false),
      QuizOption(text: 'Hilt dependency injection — you need DI before you can build anything', correct: false),
      QuizOption(text: 'Room database — data persistence is the core of every app', correct: false),
    ]),
  ],
);

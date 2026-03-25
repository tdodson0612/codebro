import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson57 = Lesson(
  language: 'Dart',
  title: 'Advanced Generics: Bounds, Variance & Type System',
  content: '''
🎯 METAPHOR:
Generic bounds are like job requirements on a hiring form.
"We accept any candidate (T)" is no bounds. "We accept
any candidate who is a Software Engineer (T extends Engineer)"
is an upper bound. The bound GUARANTEES that T has the skills
(methods) of an Engineer — so you can call engineer.code()
on any T in your generic function. Without the bound, the
compiler doesn't know what T can do, so it forbids calling
anything but Object methods. Variance is about what you can
SUBSTITUTE — if Dog is an Animal, can you use a List<Dog>
where a List<Animal> is expected? Dart says no by default
(invariant) to prevent type safety violations.

📖 EXPLANATION:
Advanced generics covers bounded type parameters (T extends X),
type constraints for multiple bounds (not supported natively
but workarounds exist), covariant/contravariant annotations,
generic methods, and how Dart's type system handles subtyping
of generic types.

─────────────────────────────────────
📐 BOUNDED TYPE PARAMETERS
─────────────────────────────────────
class SortedList<T extends Comparable<T>> { }

// T must be Comparable<T>
// Inside SortedList, you can call t.compareTo(other) ✅

// Multiple bounds (workaround — use intersection type):
abstract class Serializable { String serialize(); }
abstract class Cloneable<T> { T clone(); }

// Single bound via mixin/interface combining both:
abstract class SerializableAndCloneable
    implements Serializable, Cloneable<SerializableAndCloneable> {}

class Cache<T extends SerializableAndCloneable> { }

─────────────────────────────────────
🔄 VARIANCE IN DART
─────────────────────────────────────
Invariant (default): List<Dog> is NOT a List<Animal>
  Even though Dog is an Animal.
  This prevents:
    List<Animal> animals = List<Dog>();   // ❌ if allowed:
    animals.add(Cat());  // would corrupt the Dog list!

Covariant output: return types can be narrower
  class Animal { Animal clone() => Animal(); }
  class Dog extends Animal {
    @override
    Dog clone() => Dog();  // return type narrowed ✅
  }

Covariant parameter (explicit annotation):
  void feed(covariant Dog food) { }  // only accepts Dog

Function type variance:
  Function(Animal) → Function(Dog)   // contravariant input
  Function(Dog)    → Function(Animal) // covariant return type

─────────────────────────────────────
🔑 COVARIANT ANNOTATION
─────────────────────────────────────
Use covariant when you know a parameter type
will be narrowed in subclasses:

abstract class Repository<T> {
  void save(covariant T item);
}

class DogRepository extends Repository<Dog> {
  @override
  void save(Dog item) { } // narrowed — not covariant error!
}

─────────────────────────────────────
🧮 REIFIED GENERICS
─────────────────────────────────────
Dart keeps generic type information at runtime:
  var list = <String>[];
  list is List<String>  → true
  list is List<int>     → false
  list.runtimeType      → List<String>

This enables runtime type checks on generic types,
unlike Java's type erasure.

─────────────────────────────────────
🔧 TYPE ALIASES FOR GENERICS
─────────────────────────────────────
typedef Json = Map<String, dynamic>;
typedef Predicate<T> = bool Function(T value);
typedef Transformer<A, B> = B Function(A input);
typedef EventHandler<T extends Event> = void Function(T);

💻 CODE:
void main() {
  print('=== Advanced Generics ===\n');

  boundedGenericsDemo();
  varianceDemo();
  genericMethodsDemo();
  typeAliasesDemo();
  runtimeTypeDemo();
}

// ── BOUNDED GENERICS ──────────────

void boundedGenericsDemo() {
  print('--- Bounded Generics ---');

  // SortedList — T must be Comparable
  final words = SortedList<String>();
  words.add('banana');
  words.add('apple');
  words.add('cherry');
  print(words.toList());   // [apple, banana, cherry]

  final nums = SortedList<int>();
  nums.add(3); nums.add(1); nums.add(4); nums.add(1); nums.add(5);
  print(nums.toList());    // [1, 1, 3, 4, 5]
  print('Min: ${
nums.min}, Max: ${
nums.max}');

  // Generic function with bound
  print(findMax([3, 1, 4, 1, 5, 9, 2, 6]));  // 9
  print(findMax(['banana', 'apple', 'cherry'])); // cherry

  // MinHeap with Comparable bound
  final heap = MinHeap<int>();
  [5, 3, 8, 1, 4, 2].forEach(heap.insert);
  while (!heap.isEmpty) {
    print('  ${
heap.extractMin()}');  // 1, 2, 3, 4, 5, 8
  }
}

class SortedList<T extends Comparable<T>> {
  final List<T> _data = [];

  void add(T item) {
    _data.add(item);
    _data.sort();
  }

  List<T> toList() => List.unmodifiable(_data);

  T get min {
    if (_data.isEmpty) throw StateError('Empty');
    return _data.first;
  }

  T get max {
    if (_data.isEmpty) throw StateError('Empty');
    return _data.last;
  }

  bool contains(T item) => _data.contains(item);
}

T findMax<T extends Comparable<T>>(List<T> items) {
  if (items.isEmpty) throw ArgumentError('Empty list');
  return items.reduce((a, b) => a.compareTo(b) > 0 ? a : b);
}

class MinHeap<T extends Comparable<T>> {
  final List<T> _heap = [];

  bool get isEmpty => _heap.isEmpty;

  void insert(T value) {
    _heap.add(value);
    _bubbleUp(_heap.length - 1);
  }

  T extractMin() {
    if (isEmpty) throw StateError('Heap is empty');
    final min = _heap.first;
    final last = _heap.removeLast();
    if (_heap.isNotEmpty) {
      _heap[0] = last;
      _siftDown(0);
    }
    return min;
  }

  void _bubbleUp(int i) {
    while (i > 0) {
      final parent = (i - 1) ~/ 2;
      if (_heap[i].compareTo(_heap[parent]) >= 0) break;
      final tmp = _heap[i]; _heap[i] = _heap[parent]; _heap[parent] = tmp;
      i = parent;
    }
  }

  void _siftDown(int i) {
    while (true) {
      int smallest = i;
      final l = 2 * i + 1, r = 2 * i + 2;
      if (l < _heap.length && _heap[l].compareTo(_heap[smallest]) < 0) smallest = l;
      if (r < _heap.length && _heap[r].compareTo(_heap[smallest]) < 0) smallest = r;
      if (smallest == i) break;
      final tmp = _heap[i]; _heap[i] = _heap[smallest]; _heap[smallest] = tmp;
      i = smallest;
    }
  }
}

// ── VARIANCE DEMO ─────────────────

void varianceDemo() {
  print('\n--- Variance ---');

  // Invariance: List<Dog> is NOT List<Animal>
  final dogs = <Dog>[Dog('Rex'), Dog('Buddy')];
  // List<Animal> animals = dogs;  // ❌ compile error — invariant!

  // But you can read as List<Animal> with explicit cast (unsafe):
  // final animals = dogs as List<Animal>;  // runtime may fail

  // Covariant return types ✅
  final animal = Cat('Whiskers').clone();
  print(animal.runtimeType);  // Cat (not Animal)

  // Covariant parameters via annotation
  final repo = DogRepository();
  repo.save(Dog('Max'));  // ✅ accepts Dog

  // Type-safe reading from covariant collection
  final List<dynamic> mixed = [Dog('A'), Cat('B'), Dog('C')];
  for (final item in mixed) {
    if (item is Dog) {
      print('Dog: ${
item.name}');
    } else if (item is Cat) {
      print('Cat: ${
item.name}');
    }
  }

  // Function variance
  // Function that takes Animal can be used as Function that takes Dog
  void feedAnimal(Animal a) => print('Feeding ${
a.name}');
  void Function(Dog) dogFeeder = feedAnimal;  // ✅ contravariant input
  dogFeeder(Dog('Fido'));
}

class Animal {
  final String name;
  Animal(this.name);
  Animal clone() => Animal(name);
}

class Dog extends Animal {
  Dog(super.name);
  @override
  Dog clone() => Dog(name);  // ✅ covariant return type
}

class Cat extends Animal {
  Cat(super.name);
  @override
  Cat clone() => Cat(name);  // ✅ covariant return type
}

abstract class Repository<T> {
  void save(covariant T item);  // covariant annotation!
  T? find(String id);
}

class DogRepository extends Repository<Dog> {
  final Map<String, Dog> _store = {};

  @override
  void save(Dog item) => _store[item.name] = item;  // Dog, not Animal

  @override
  Dog? find(String id) => _store[id];
}

// ── GENERIC METHODS ───────────────

void genericMethodsDemo() {
  print('\n--- Generic Methods ---');

  // Generic method — type inferred from args
  print(zip([1, 2, 3], ['a', 'b', 'c']));
  // [(1, a), (2, b), (3, c)]

  // Generic with bound
  print(clamp(5.7, min: 0.0, max: 5.0));   // 5.0
  print(clamp(-2, min: 0, max: 10));         // 0

  // Generic cache
  final cache = TypedCache();
  cache.set<String>('name', 'Alice');
  cache.set<int>('age', 30);

  print(cache.get<String>('name'));  // Alice
  print(cache.get<int>('age'));      // 30
  print(cache.get<String>('age'));   // null (wrong type)
}

List<(A, B)> zip<A, B>(List<A> a, List<B> b) {
  final len = a.length < b.length ? a.length : b.length;
  return [for (int i = 0; i < len; i++) (a[i], b[i])];
}

T clamp<T extends num>(T value, {required T min, required T max}) {
  if (value < min) return min;
  if (value > max) return max;
  return value;
}

class TypedCache {
  final Map<String, (Type, dynamic)> _store = {};

  void set<T>(String key, T value) => _store[key] = (T, value);

  T? get<T>(String key) {
    final entry = _store[key];
    if (entry == null || entry.\$1 != T) return null;
    return entry.\$2 as T;
  }
}

// ── TYPE ALIASES ──────────────────

void typeAliasesDemo() {
  print('\n--- Type Aliases ---');

  typedef Json = Map<String, dynamic>;
  typedef Predicate<T> = bool Function(T);
  typedef Transformer<A, B> = B Function(A);

  Json user = {'name': 'Alice', 'age': 30};
  print(user['name']);

  Predicate<int> isEven = (n) => n % 2 == 0;
  Transformer<String, int> strLen = (s) => s.length;

  print([1,2,3,4,5].where(isEven).toList());    // [2, 4]
  print(['hi', 'hello', 'hey'].map(strLen).toList());  // [2, 5, 3]
}

// ── RUNTIME TYPE CHECKS ───────────

void runtimeTypeDemo() {
  print('\n--- Reified Generics ---');

  // Dart keeps type info at runtime!
  var intList = <int>[1, 2, 3];
  var strList = <String>['a', 'b'];

  print(intList is List<int>);      // true
  print(intList is List<String>);   // false  ← wouldn't work in Java!
  print(intList.runtimeType);       // List<int>

  // Use this for type-safe generic operations
  Object unknown = [1, 2, 3];
  if (unknown is List<int>) {
    print('Sum: ${
unknown.reduce((a, b) => a + b)}');  // type-safe!
  }

  // Generic class runtimeType
  var box = Box<String>('hello');
  print(box.runtimeType);   // Box<String>
  print(box is Box<String>); // true
  print(box is Box<int>);    // false
}

class Box<T> {
  final T value;
  Box(this.value);
}

📝 KEY POINTS:
✅ T extends Comparable<T> bounds T to types that can be compared
✅ Bounded generics let you call the bound's methods inside the generic class/function
✅ List<Dog> is NOT a subtype of List<Animal> — generic types are invariant by default
✅ Covariant return types are fine: overriding Dog clone() → Dog in Animal subclass
✅ covariant annotation on parameters allows narrowing in subclasses
✅ Dart's generics are reified — type info is available at runtime
✅ Type aliases with typedef clean up complex generic signatures
✅ Generic methods can infer type parameters from arguments
❌ Don't cast List<Dog> to List<Animal> — use proper variance or redesign
❌ Invariance prevents type-unsafe mutations — don't fight it with casts
❌ Multiple bounds aren't directly supported — use an interface combining them
''',
  quiz: [
    Quiz(question: 'Why is List<Dog> not a subtype of List<Animal> in Dart?', options: [
      QuizOption(text: 'Dog is not a subtype of Animal', correct: false),
      QuizOption(text: 'If allowed, you could add a Cat to a List<Dog> via the List<Animal> reference — corrupting type safety', correct: true),
      QuizOption(text: 'Dart does not support generic subtyping at all', correct: false),
      QuizOption(text: 'It is a limitation that will be fixed in future Dart versions', correct: false),
    ]),
    Quiz(question: 'What does T extends Comparable<T> guarantee inside a generic function?', options: [
      QuizOption(text: 'T is a number type', correct: false),
      QuizOption(text: 'You can call t.compareTo(other) — T implements comparison', correct: true),
      QuizOption(text: 'T can be sorted by the system automatically', correct: false),
      QuizOption(text: 'T is an immutable type', correct: false),
    ]),
    Quiz(question: 'What makes Dart generics "reified" unlike Java?', options: [
      QuizOption(text: 'Dart generics compile faster', correct: false),
      QuizOption(text: 'Type information is preserved at runtime — list is List<String> returns true at runtime', correct: true),
      QuizOption(text: 'Dart generics support more type bounds', correct: false),
      QuizOption(text: 'Dart uses different syntax for generics', correct: false),
    ]),
  ],
);

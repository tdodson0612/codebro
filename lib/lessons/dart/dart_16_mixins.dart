import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson16 = Lesson(
  language: 'Dart',
  title: 'Mixins',
  content: '''
🎯 METAPHOR:
Mixins are like power-ups in a video game.
Your character (class) has a base set of skills. But
you can pick up power-ups (mixins) that grant additional
abilities: flying, invisibility, super strength. You can
combine power-ups! A character that has FlyMixin and
InvisibilityMixin can both fly AND turn invisible.
The character doesn't become a different species
(no new parent class) — they just have extra abilities
bolted on. Dart's Mixins are exactly this: a way to
compose behaviors without deep inheritance hierarchies.

📖 EXPLANATION:
Mixins let you reuse code across multiple class hierarchies
without multiple inheritance. A mixin defines methods
and fields that can be "mixed in" to any class using
the with keyword. Unlike implements, mixins PROVIDE
implementations — you get the code for free.

─────────────────────────────────────
📐 DEFINING A MIXIN
─────────────────────────────────────
mixin FlyMixin {
  void fly() => print('\$this is flying!');
}

mixin SwimMixin {
  void swim() => print('\$this is swimming!');
}

─────────────────────────────────────
🔗 USING MIXINS
─────────────────────────────────────
class Duck extends Animal with FlyMixin, SwimMixin {
  // Duck can now fly() and swim()!
}

// Order matters: with A, B, C
// Methods resolved right-to-left (C overrides B overrides A)

─────────────────────────────────────
🎯 MIXIN ON (CONSTRAINING)
─────────────────────────────────────
// Only classes that extend Animal can use this mixin:
mixin AnimalMixin on Animal {
  void makeAnimalSound() {
    speak();  // can call Animal's method!
  }
}

─────────────────────────────────────
🔑 MIXIN vs ABSTRACT CLASS
─────────────────────────────────────
Abstract class:
  • Has an identity (a type name)
  • Can be extended, implemented
  • Constructor-aware

Mixin:
  • No identity of its own as a type
  • Applied with "with"
  • No user-defined constructors
  • Focused on composing behaviors

─────────────────────────────────────
🔄 CLASS AS MIXIN (mixin class)
─────────────────────────────────────
Dart 3: mixin class can be both extended AND mixed in:
  mixin class Serializable {
    Map<String, dynamic> toJson() => {'type': runtimeType.toString()};
  }
  // Can use as: class X extends Serializable {}
  // Or as:      class X with Serializable {}

─────────────────────────────────────
📊 MIXIN LINEARIZATION
─────────────────────────────────────
Multiple mixins are applied left-to-right, stacking on top:
  class C extends A with M1, M2 {}
  Equivalent to: C extends (M2 extends (M1 extends A))
  Method resolution: C → M2 → M1 → A

💻 CODE:
void main() {
  // ── USING MIXINS ──────────────
  var duck = Duck('Donald');
  duck.eat();     // Donald eats  (from Animal)
  duck.fly();     // Donald is flying!  (from FlyMixin)
  duck.swim();    // Donald is swimming!  (from SwimMixin)
  duck.quack();   // Donald: Quack!  (Duck's own method)

  var penguin = Penguin('Skipper');
  penguin.eat();  // Skipper eats  (from Animal)
  penguin.swim(); // Skipper is swimming!  (from SwimMixin)
  // penguin.fly(); // ❌ Penguin doesn't have FlyMixin

  // ── MIXIN ON (CONSTRAINED) ────
  var cat = Cat('Luna');
  cat.describe();   // I am an Animal named Luna

  // ── TYPE CHECKING WITH MIXINS ─
  print(duck is FlyMixin);   // true
  print(duck is SwimMixin);  // true
  print(duck is Animal);     // true
  print(penguin is FlyMixin); // false

  // ── SERIALIZABLE MIXIN ────────
  var user = User(name: 'Alice', age: 30);
  print(user.toJson());   // {name: Alice, age: 30, id: ...}
  print(user.validate()); // true (name and age are valid)

  // ── MIXIN LINEARIZATION ───────
  var logger = LoggedPrinter();
  logger.printMessage('Hello');

  // ── MIXIN CLASS ────────────────
  var d = Dog2();
  d.speak();
  d.log('barked');

  var logger2 = AnimalLogger();  // used as regular class
  logger2.log('started up');

  // ── PRACTICAL: COMPARABLE MIXIN ──
  var items = [
    Product(name: 'Banana', price: 0.99),
    Product(name: 'Apple', price: 1.49),
    Product(name: 'Cherry', price: 2.99),
  ];
  items.sort();   // uses Comparable mixin!
  for (var p in items) {
    print('\${p.name}: \$\${p.price}');
  }
}

// ── BASE CLASS ─────────────────
class Animal {
  final String name;
  Animal(this.name);
  void eat() => print('\$name eats');
  void speak() => print('\$name makes a sound');
  @override
  String toString() => name;
}

// ── MIXINS ────────────────────
mixin FlyMixin {
  void fly() => print('\$this is flying!');

  double altitude = 0;

  void ascend(double meters) {
    altitude += meters;
    print('\$this ascends to \${altitude}m');
  }
}

mixin SwimMixin {
  void swim() => print('\$this is swimming!');

  int depth = 0;

  void dive(int meters) {
    depth += meters;
    print('\$this dives to \${depth}m');
  }
}

// ── MIXIN ON (must extend Animal) ──
mixin DescribableMixin on Animal {
  void describe() {
    speak();  // can call Animal's speak()!
    print('I am an Animal named \$name');
  }
}

// ── CLASSES USING MIXINS ───────
class Duck extends Animal with FlyMixin, SwimMixin {
  Duck(super.name);
  void quack() => print('\$name: Quack!');
}

class Penguin extends Animal with SwimMixin {
  Penguin(super.name);
}

class Cat extends Animal with DescribableMixin {
  Cat(super.name);
}

// ── SERIALIZABLE MIXIN ─────────
mixin Serializable {
  Map<String, dynamic> toJson();   // abstract — subclass provides

  String serialize() => toJson().entries
      .map((e) => '\${e.key}: \${e.value}')
      .join(', ');
}

mixin Validatable {
  bool validate();  // abstract

  void assertValid() {
    if (!validate()) throw StateError('Invalid state!');
  }
}

class User with Serializable, Validatable {
  final String name;
  final int age;
  final String id = DateTime.now().millisecondsSinceEpoch.toString();

  User({required this.name, required this.age});

  @override
  Map<String, dynamic> toJson() => {
    'name': name,
    'age': age,
    'id': id,
  };

  @override
  bool validate() => name.isNotEmpty && age > 0 && age < 150;
}

// ── MIXIN LINEARIZATION ────────
mixin M1 {
  String get greeting => 'Hello from M1';
  void printMessage(String msg) => print('M1: \$msg');
}

mixin M2 {
  String get greeting => 'Hello from M2';
  void printMessage(String msg) => print('M2: \$msg');
}

class LoggedPrinter with M1, M2 {
  // M2 takes precedence (right-most mixin wins)
}

// ── MIXIN CLASS (Dart 3) ───────
mixin class AnimalLogger {
  void log(String action) {
    print('[LOG] \${runtimeType}: \$action at \${DateTime.now()}');
  }
}

class Dog2 extends Animal with AnimalLogger {
  Dog2() : super('Dog');
  void speak() {
    print('\$name barks!');
    log('barked');
  }
}

class StandaloneLogger extends AnimalLogger {
  void info(String msg) {
    log(msg);
  }
}

// ── COMPARABLE MIXIN ──────────
mixin ComparableMixin<T> on Comparable<T> {}

class Product implements Comparable<Product> {
  final String name;
  final double price;

  Product({required this.name, required this.price});

  @override
  int compareTo(Product other) => price.compareTo(other.price);

  @override
  String toString() => '\$name (\\\$\${price.toStringAsFixed(2)})';
}

📝 KEY POINTS:
✅ Mixins add behaviors to classes without requiring a shared parent
✅ with MixinA, MixinB — order matters: rightmost wins on conflicts
✅ mixin on Type constrains which classes can use the mixin (and enables calling Type's methods)
✅ Mixins cannot have user-defined constructors
✅ Mixins can have fields AND methods — full implementation provided
✅ mixin class (Dart 3) can be both extended and used with with
✅ Multiple mixins don't create true multiple inheritance — they linearize
✅ Type checking: obj is MixinName returns true if the mixin was applied
❌ Mixins cannot have constructor parameters — their state must be initialized differently
❌ Don't use mixin on unnecessarily — it restricts which classes can apply the mixin
❌ The with clause comes AFTER extends: class C extends A with M1, M2
''',
  quiz: [
    Quiz(question: 'What is the key advantage of mixins over abstract class inheritance?', options: [
      QuizOption(text: 'Mixins are faster at runtime', correct: false),
      QuizOption(text: 'Mixins can be applied to any class regardless of its inheritance chain, enabling horizontal code reuse', correct: true),
      QuizOption(text: 'Mixins allow user-defined constructors', correct: false),
      QuizOption(text: 'Mixins support multiple inheritance with diamonds', correct: false),
    ]),
    Quiz(question: 'What does "mixin M on Animal" mean?', options: [
      QuizOption(text: 'M extends Animal', correct: false),
      QuizOption(text: 'M can only be applied to classes that extend Animal, and can call Animal\'s methods', correct: true),
      QuizOption(text: 'M implements Animal', correct: false),
      QuizOption(text: 'Animal must use the M mixin', correct: false),
    ]),
    Quiz(question: 'In "class C extends A with M1, M2", which mixin\'s method takes precedence if both define the same method?', options: [
      QuizOption(text: 'M1 — the first mixin listed', correct: false),
      QuizOption(text: 'M2 — the last mixin listed (rightmost wins)', correct: true),
      QuizOption(text: 'A — the base class always wins', correct: false),
      QuizOption(text: 'C — if C doesn\'t define it, it\'s a compile error', correct: false),
    ]),
  ],
);
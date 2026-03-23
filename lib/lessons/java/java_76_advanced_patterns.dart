import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson76 = Lesson(
  language: 'Java',
  title: 'Advanced Design Patterns: Visitor, Interpreter, and Mediator',
  content: """
🎯 METAPHOR:
The Visitor pattern is like a health inspector visiting
different types of businesses — restaurants, factories,
pharmacies. The inspector (visitor) carries the same
clipboard but applies different rules to each business
type. The businesses (elements) don't need to know
all the health rules — they just "accept" the inspector
and let him do his job. New types of inspections can
be added by creating new inspectors, without changing
the businesses at all.

The Mediator is like an air traffic controller.
Planes (components) don't talk to each other directly —
that would be chaos. They all talk to the controller
(mediator) who coordinates everything. Remove direct
coupling between all N² pairs of planes, replace with
N communications to one central point.

📖 EXPLANATION:
These GoF patterns solve specific architectural problems
encountered in larger codebases.

─────────────────────────────────────
VISITOR PATTERN:
─────────────────────────────────────
  Problem: add operations to a class hierarchy without
           modifying the classes.

  Structure:
  ┌─────────┐       ┌──────────────┐
  │ Visitor │←──────│   Element    │
  │+visitA()│       │+accept(v)    │
  │+visitB()│       └──────────────┘
  └─────────┘           ↑      ↑
                    ElementA  ElementB
                  +accept(v) +accept(v)
                  v.visitA(this) v.visitB(this)

  Double dispatch: when you call elem.accept(visitor),
  Java dispatches to the right accept() based on elem's
  type, which then dispatches to the right visit() based
  on visitor's type.

  // Element interface:
  interface Expr { <T> T accept(ExprVisitor<T> visitor); }

  // Visitor interface:
  interface ExprVisitor<T> {
      T visitNum(Num n);
      T visitAdd(Add a);
      T visitMul(Mul m);
  }

  // Use for: AST evaluation, pretty-printing, serialization

─────────────────────────────────────
INTERPRETER PATTERN:
─────────────────────────────────────
  Problem: interpret/evaluate a grammar or expression tree.

  Define a class for each grammar rule.
  compose them into a tree structure (AST).

  interface Expression {
      int interpret(Map<String, Integer> context);
  }

  class Variable implements Expression {
      String name;
      int interpret(Map<String,Integer> ctx) { return ctx.get(name); }
  }

  class Add implements Expression {
      Expression left, right;
      int interpret(Map<String,Integer> ctx) {
          return left.interpret(ctx) + right.interpret(ctx);
      }
  }

  Use for: rule engines, query languages, template engines,
           config expression evaluators.

─────────────────────────────────────
MEDIATOR PATTERN:
─────────────────────────────────────
  Problem: N components all need to interact — direct
           connections create O(N²) coupling.

  Solution: introduce a mediator that all components
  communicate through. N connections instead of N².

  interface Mediator { void notify(Component sender, String event); }

  abstract class Component {
      protected Mediator mediator;
      void setMediator(Mediator m) { this.mediator = m; }
  }

  class Button extends Component {
      void click() { mediator.notify(this, "click"); }
  }

  Use for: chat rooms, event buses, GUI form coordination,
           workflow orchestration.

─────────────────────────────────────
PROXY PATTERN (bonus):
─────────────────────────────────────
  A surrogate that controls access to another object.

  Types:
  Virtual proxy: lazy initialization (create heavy obj only when needed)
  Remote proxy:  represents obj in different address space (RMI)
  Protection proxy: access control
  Logging proxy: add logging without modifying the original

  interface Service { String execute(String request); }

  class LoggingProxy implements Service {
      private Service realService;
      String execute(String req) {
          log("Before: " + req);
          String result = realService.execute(req);
          log("After: " + result);
          return result;
      }
  }

  // Java dynamic proxy:
  Service proxy = (Service) Proxy.newProxyInstance(
      Service.class.getClassLoader(),
      new Class[]{Service.class},
      (proxyObj, method, args) -> {
          System.out.println("Before " + method.getName());
          Object result = method.invoke(realService, args);
          System.out.println("After " + method.getName());
          return result;
      });

─────────────────────────────────────
WHEN TO USE EACH:
─────────────────────────────────────
  Visitor:     Add operations to stable class hierarchy
               without modification (AST traversal)
  Interpreter: Simple grammar evaluation / rule engines
  Mediator:    Decouple components that interact heavily
  Proxy:       Transparent cross-cutting concerns (logging,
               security, caching, lazy init)

💻 CODE:
import java.util.*;
import java.lang.reflect.*;

// ─── VISITOR — expression tree ─────────────────────────
interface Expr { <T> T accept(ExprVisitor<T> v); }
record Num2(double value) implements Expr {
    public <T> T accept(ExprVisitor<T> v) { return v.visitNum(this); }
}
record Add2(Expr left, Expr right) implements Expr {
    public <T> T accept(ExprVisitor<T> v) { return v.visitAdd(this); }
}
record Mul2(Expr left, Expr right) implements Expr {
    public <T> T accept(ExprVisitor<T> v) { return v.visitMul(this); }
}
record Neg(Expr expr) implements Expr {
    public <T> T accept(ExprVisitor<T> v) { return v.visitNeg(this); }
}

interface ExprVisitor<T> {
    T visitNum(Num2 n);
    T visitAdd(Add2 a);
    T visitMul(Mul2 m);
    T visitNeg(Neg n);
}

class Evaluator implements ExprVisitor<Double> {
    public Double visitNum(Num2 n) { return n.value(); }
    public Double visitAdd(Add2 a) { return a.left().accept(this) + a.right().accept(this); }
    public Double visitMul(Mul2 m) { return m.left().accept(this) * m.right().accept(this); }
    public Double visitNeg(Neg n)  { return -n.expr().accept(this); }
}

class PrettyPrinter implements ExprVisitor<String> {
    public String visitNum(Num2 n) { return String.valueOf((int)n.value() == n.value() ? (int)n.value() : n.value()); }
    public String visitAdd(Add2 a) { return "(" + a.left().accept(this) + " + " + a.right().accept(this) + ")"; }
    public String visitMul(Mul2 m) { return "(" + m.left().accept(this) + " * " + m.right().accept(this) + ")"; }
    public String visitNeg(Neg n)  { return "-" + n.expr().accept(this); }
}

// Add new operation without changing any Expr class:
class Counter implements ExprVisitor<Integer> {
    public Integer visitNum(Num2 n) { return 1; }
    public Integer visitAdd(Add2 a) { return a.left().accept(this) + a.right().accept(this); }
    public Integer visitMul(Mul2 m) { return m.left().accept(this) + m.right().accept(this); }
    public Integer visitNeg(Neg n)  { return n.expr().accept(this); }
}

// ─── MEDIATOR — chat room ──────────────────────────────
interface ChatMediator {
    void sendMessage(String from, String to, String message);
    void broadcast(String from, String message);
    void register(String name, ChatUser user);
}

interface ChatUser { void receive(String from, String message); }

class ChatRoom implements ChatMediator {
    private final Map<String, ChatUser> users = new LinkedHashMap<>();

    public void register(String name, ChatUser user) { users.put(name, user); }

    public void sendMessage(String from, String to, String message) {
        ChatUser recipient = users.get(to);
        if (recipient != null) recipient.receive(from, message);
        else System.out.println("  [" + to + "] not found");
    }

    public void broadcast(String from, String message) {
        users.forEach((name, user) -> {
            if (!name.equals(from)) user.receive(from, "[BROADCAST] " + message);
        });
    }
}

class BasicUser implements ChatUser {
    private final String name;
    private final List<String> inbox = new ArrayList<>();
    private final ChatMediator mediator;

    BasicUser(String name, ChatMediator mediator) {
        this.name = name; this.mediator = mediator;
        mediator.register(name, this);
    }

    public void send(String to, String msg) {
        System.out.println("  " + name + " → " + to + ": " + msg);
        mediator.sendMessage(name, to, msg);
    }

    public void shout(String msg) {
        System.out.println("  " + name + " [BROADCAST]: " + msg);
        mediator.broadcast(name, msg);
    }

    public void receive(String from, String msg) {
        inbox.add(from + ": " + msg);
        System.out.println("  📨 " + name + " received from " + from + ": " + msg);
    }

    public List<String> getInbox() { return inbox; }
}

// ─── DYNAMIC PROXY ────────────────────────────────────
interface DataService {
    String getData(String key);
    void setData(String key, String value);
}

class InMemoryDataService implements DataService {
    private final Map<String, String> store = new HashMap<>();
    public String getData(String key) { return store.getOrDefault(key, null); }
    public void setData(String key, String value) { store.put(key, value); }
}

public class AdvancedPatterns {
    public static void main(String[] args) {

        // ─── VISITOR ──────────────────────────────────────
        System.out.println("=== Visitor Pattern ===");
        // Expression: (2 * 3) + -(4)  = 6 + (-4) = 2
        Expr expr = new Add2(
            new Mul2(new Num2(2), new Num2(3)),
            new Neg(new Num2(4))
        );

        Evaluator eval = new Evaluator();
        PrettyPrinter pp = new PrettyPrinter();
        Counter counter = new Counter();

        System.out.println("  Expression:  " + expr.accept(pp));
        System.out.println("  Value:       " + expr.accept(eval));
        System.out.println("  Num count:   " + expr.accept(counter));

        // A different expression: (5 + 3) * -(2)  = -16
        Expr expr2 = new Mul2(
            new Add2(new Num2(5), new Num2(3)),
            new Neg(new Num2(2))
        );
        System.out.println("  Expression2: " + expr2.accept(pp));
        System.out.println("  Value2:      " + expr2.accept(eval));

        // ─── MEDIATOR ─────────────────────────────────────
        System.out.println("\n=== Mediator Pattern (Chat Room) ===");
        ChatRoom room = new ChatRoom();
        BasicUser alice = new BasicUser("Alice", room);
        BasicUser bob   = new BasicUser("Bob",   room);
        BasicUser carol = new BasicUser("Carol", room);

        alice.send("Bob", "Hey Bob!");
        bob.send("Alice", "Hi Alice!");
        carol.shout("Anyone want to pair program?");
        alice.send("Dave", "Are you there?");  // Dave not registered

        System.out.println("\n  Inboxes:");
        System.out.println("  Alice inbox: " + alice.getInbox());
        System.out.println("  Bob inbox:   " + bob.getInbox());
        System.out.println("  Carol inbox: " + carol.getInbox());

        // ─── DYNAMIC PROXY ────────────────────────────────
        System.out.println("\n=== Dynamic Proxy (Logging) ===");
        DataService realService = new InMemoryDataService();

        // Create a logging proxy dynamically
        DataService loggingProxy = (DataService) Proxy.newProxyInstance(
            DataService.class.getClassLoader(),
            new Class[]{DataService.class},
            (proxy, method, proxyArgs) -> {
                String args2 = proxyArgs != null ?
                    Arrays.toString(proxyArgs) : "[]";
                System.out.println("  → Calling " + method.getName() + args2);
                Object result = method.invoke(realService, proxyArgs);
                System.out.println("  ← Result: " + result);
                return result;
            }
        );

        loggingProxy.setData("key1", "Hello");
        loggingProxy.setData("key2", "World");
        loggingProxy.getData("key1");
        loggingProxy.getData("missing");
    }
}

📝 KEY POINTS:
✅ Visitor: add operations to a closed class hierarchy — uses double dispatch
✅ accept(visitor) → visitor.visit(this) — each Element calls the right visit method
✅ New operations require only new Visitor implementations — Elements unchanged
✅ Interpreter: each grammar rule is a class — compose into an AST, call interpret()
✅ Mediator: all components communicate through one mediator — reduces N² coupling to N
✅ Dynamic Proxy: wraps any interface implementation transparently at runtime
✅ Proxy.newProxyInstance() intercepts all method calls — ideal for cross-cutting concerns
✅ Visitor is ideal for ASTs — compilers, rule engines, data transformation pipelines
❌ Visitor breaks Open/Closed if new Element types are needed — must add to every Visitor
❌ Mediator can become a God Object if too much logic moves into it — keep it thin
❌ Dynamic Proxy only works for interfaces — use CGLIB/ByteBuddy for class proxies
❌ Interpreter scales poorly for complex grammars — use ANTLR or parser combinator instead
""",
  quiz: [
    Quiz(question: 'What problem does the Visitor pattern solve?', options: [
      QuizOption(text: 'Adding new operations to a stable class hierarchy without modifying any existing classes', correct: true),
      QuizOption(text: 'Reducing the number of objects created when traversing a data structure', correct: false),
      QuizOption(text: 'Providing a simplified interface to a complex subsystem', correct: false),
      QuizOption(text: 'Allowing lazy initialization of expensive objects until they are first needed', correct: false),
    ]),
    Quiz(question: 'Why does the Mediator pattern reduce coupling?', options: [
      QuizOption(text: 'It replaces O(N²) direct connections between N components with N connections to one mediator', correct: true),
      QuizOption(text: 'It uses interfaces so components don\'t depend on concrete implementations', correct: false),
      QuizOption(text: 'It lazy-loads components only when they are first accessed', correct: false),
      QuizOption(text: 'It caches component interactions to avoid repeated communication overhead', correct: false),
    ]),
    Quiz(question: 'What is "double dispatch" in the Visitor pattern?', options: [
      QuizOption(text: 'Two virtual dispatches: first on the element type (accept), then on the visitor type (visit) — selecting the right combination', correct: true),
      QuizOption(text: 'Calling the same visitor method twice to ensure idempotency', correct: false),
      QuizOption(text: 'Dispatching to two different visitors simultaneously for parallel processing', correct: false),
      QuizOption(text: 'A technique where elements dispatch to visitors which dispatch back to elements', correct: false),
    ]),
  ],
);

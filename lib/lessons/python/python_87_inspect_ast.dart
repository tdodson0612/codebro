import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson87 = Lesson(
  language: 'Python',
  title: 'inspect, ast & Python Introspection',
  content: '''
🎯 METAPHOR:
The inspect module is like having X-ray vision for Python code.
You can look inside any function, class, or module at runtime:
"How many parameters does this function take? What are their names?
What are their default values? Where is this function defined?
What is its source code?" The ast module goes deeper — it parses
Python source into a tree of nodes you can traverse, analyze,
or transform. It's like getting the blueprint AND being able
to modify the blueprint before anything is built.

📖 EXPLANATION:
inspect provides runtime introspection of live Python objects.
ast parses Python source code into an Abstract Syntax Tree.
Together they power linters, IDEs, documentation generators,
testing frameworks, and code transformation tools.

─────────────────────────────────────
📦 INSPECT MODULE
─────────────────────────────────────
inspect.signature(func)        → Parameter info
inspect.getdoc(obj)            → cleaned docstring
inspect.getsource(obj)         → source code as str
inspect.getfile(obj)           → filename where defined
inspect.isfunction(obj)        → True for functions
inspect.isclass(obj)           → True for classes
inspect.ismethod(obj)          → True for bound methods
inspect.ismodule(obj)          → True for modules
inspect.getmembers(obj)        → [(name, value), ...]
inspect.stack()                → current call stack
inspect.currentframe()         → current execution frame
inspect.getcallargs(f, *a, **k) → map args to params

─────────────────────────────────────
🌳 AST MODULE
─────────────────────────────────────
ast.parse(source)       → parse string to AST
ast.dump(tree)          → tree as readable string
ast.NodeVisitor         → walk the tree
ast.NodeTransformer     → transform the tree
ast.literal_eval(s)     → safely evaluate literals only
ast.unparse(tree)       → AST back to source code (3.9+)
ast.walk(tree)          → iterate all nodes
compile(tree, ...)      → compile AST to bytecode

─────────────────────────────────────
🔒 AST LITERAL_EVAL — SAFE EVAL
─────────────────────────────────────
ast.literal_eval() evaluates ONLY literals:
  strings, bytes, numbers, tuples, lists, dicts,
  sets, booleans, None

CANNOT evaluate function calls, variables, operators.
Use instead of eval() for user input validation!

─────────────────────────────────────
⚡ PRACTICAL USES
─────────────────────────────────────
inspect:
  • Auto-generate API documentation
  • Build decorators that adapt to function signatures
  • Dependency injection frameworks
  • Test frameworks (pytest uses inspect heavily)

ast:
  • Linters (flake8, pylint, ruff)
  • Type checkers (mypy, pyright)
  • Code formatters (black)
  • Safe user expression evaluation
  • Code generation

💻 CODE:
import inspect
import ast
import textwrap
from typing import get_type_hints

# ── INSPECT SIGNATURES ─────────────

def complex_function(
    name: str,
    age: int,
    /,           # positional-only boundary
    score: float = 0.0,
    *tags: str,
    verbose: bool = False,
    **kwargs
) -> dict:
    """
    A complex function demonstrating all parameter types.

    Args:
        name: The person's name (positional-only)
        age: Their age (positional-only)
        score: A score value (keyword-or-positional)
        *tags: Variable tags
        verbose: Whether to be verbose (keyword-only)
        **kwargs: Extra keyword arguments
    """
    return {"name": name, "age": age}

# Get signature
sig = inspect.signature(complex_function)
print(f"Signature: {sig}")
print()

for name, param in sig.parameters.items():
    kind_names = {
        inspect.Parameter.POSITIONAL_ONLY:            "positional-only",
        inspect.Parameter.POSITIONAL_OR_KEYWORD:      "positional-or-keyword",
        inspect.Parameter.VAR_POSITIONAL:             "var-positional (*args)",
        inspect.Parameter.KEYWORD_ONLY:               "keyword-only",
        inspect.Parameter.VAR_KEYWORD:                "var-keyword (**kwargs)",
    }
    has_default = param.default is not inspect.Parameter.empty
    has_annotation = param.annotation is not inspect.Parameter.empty
    print(f"  {name:10s}  kind={kind_names[param.kind]}")
    if has_annotation:
        print(f"             annotation={param.annotation}")
    if has_default:
        print(f"             default={param.default!r}")

# Type hints via typing
hints = get_type_hints(complex_function)
print(f"\\nType hints: {hints}")

# Check if something is callable, a function, class, etc.
class MyClass:
    def method(self): pass

obj = MyClass()
print(f"\\ninspect.isfunction(complex_function): {inspect.isfunction(complex_function)}")
print(f"inspect.isclass(MyClass):             {inspect.isclass(MyClass)}")
print(f"inspect.ismethod(obj.method):         {inspect.ismethod(obj.method)}")
print(f"inspect.isbuiltin(len):               {inspect.isbuiltin(len)}")

# Get all members of an object
print("\\nMembers of MyClass:")
for name, value in inspect.getmembers(MyClass):
    if not name.startswith("__"):
        print(f"  {name}: {type(value).__name__}")

# Get source code
source = inspect.getsource(complex_function)
print(f"\\nSource code ({len(source)} chars):")
print(textwrap.indent(source[:200], "  "))

# Get docstring (cleaned)
doc = inspect.getdoc(complex_function)
print(f"\\nDocstring:\\n{textwrap.indent(doc, '  ')}")

# ── CALL STACK INSPECTION ─────────

def level3():
    frame = inspect.currentframe()
    stack = inspect.stack()
    print("\\nCall stack (from innermost):")
    for frame_info in stack[:4]:   # just top 4
        print(f"  {frame_info.function}() in {frame_info.filename.split('/')[-1]}:{frame_info.lineno}")

def level2():
    level3()

def level1():
    level2()

level1()

# ── AST PARSING ───────────────────

source_code = """
def add(x, y):
    return x + y

class Calculator:
    def multiply(self, a, b):
        return a * b

result = add(3, 4)
"""

tree = ast.parse(source_code)
print(f"\\nAST root type: {type(tree).__name__}")
print(f"Top-level nodes:")
for node in ast.walk(tree):
    if isinstance(node, (ast.FunctionDef, ast.ClassDef, ast.Assign)):
        print(f"  {type(node).__name__}: {getattr(node, 'name', '?')}")

# Pretty print the AST
print(f"\\nAST dump (partial):")
print(ast.dump(tree, indent=2)[:500])

# ── AST LITERAL_EVAL — SAFE EVAL ──

# Safely evaluate user-provided data structures
safe_inputs = [
    "[1, 2, 3, 4, 5]",
    "{'name': 'Alice', 'age': 30}",
    "(True, False, None)",
    "{'key': [1, 2, {'nested': 3}]}",
]

for s in safe_inputs:
    result = ast.literal_eval(s)
    print(f"  {s[:30]:30s} → {type(result).__name__}")

# Unsafe input blocked
unsafe = "__import__('os').system('ls')"
try:
    ast.literal_eval(unsafe)
except (ValueError, SyntaxError) as e:
    print(f"  BLOCKED: {e}")

# ── AST VISITOR PATTERN ───────────

class FunctionFinder(ast.NodeVisitor):
    """Find all function definitions in source code."""

    def __init__(self):
        self.functions = []

    def visit_FunctionDef(self, node):
        args = [arg.arg for arg in node.args.args]
        self.functions.append({
            "name": node.name,
            "line": node.lineno,
            "args": args,
            "has_docstring": (
                isinstance(node.body[0], ast.Expr) and
                isinstance(node.body[0].value, ast.Constant)
            ) if node.body else False
        })
        self.generic_visit(node)   # continue visiting children

code = """
def add(x, y):
    "Add two numbers."
    return x + y

def multiply(a, b, c=1):
    return a * b * c

class MyClass:
    def method(self, value):
        pass
"""

finder = FunctionFinder()
finder.visit(ast.parse(code))
print(f"\\nFunctions found:")
for fn in finder.functions:
    doc_marker = "📝" if fn["has_docstring"] else "  "
    print(f"  {doc_marker} {fn['name']}({', '.join(fn['args'])}) at line {fn['line']}")

# ── VARIABLE USAGE ANALYSIS ───────

class VariableUsage(ast.NodeVisitor):
    """Track which variables are assigned vs. used."""

    def __init__(self):
        self.assigned = set()
        self.used = set()

    def visit_Name(self, node):
        if isinstance(node.ctx, ast.Store):
            self.assigned.add(node.id)
        elif isinstance(node.ctx, ast.Load):
            self.used.add(node.id)

code = "x = 1; y = x + z; result = y * 2"
analyzer = VariableUsage()
analyzer.visit(ast.parse(code))

print(f"\\nAssigned: {analyzer.assigned}")
print(f"Used:     {analyzer.used}")
print(f"Unused:   {analyzer.assigned - analyzer.used}")
print(f"Undefined:{analyzer.used - analyzer.assigned - {'z'}}")  # z not assigned

# ── AST TRANSFORMER ──────────────

class PowerToMul(ast.NodeTransformer):
    """Transform x**2 to x*x for small exponents."""

    def visit_BinOp(self, node):
        self.generic_visit(node)   # visit children first
        if (isinstance(node.op, ast.Pow) and
            isinstance(node.right, ast.Constant) and
            node.right.value == 2):
            # Replace x**2 with x*x
            return ast.BinOp(
                left=node.left,
                op=ast.Mult(),
                right=node.left,
            )
        return node

code = "result = x**2 + y**2"
tree = ast.parse(code)
ast.fix_missing_locations(PowerToMul().visit(tree))

# Unparse back to code (Python 3.9+)
transformed = ast.unparse(tree)
print(f"\\nOriginal:   {code}")
print(f"Transformed: {transformed}")   # result = x * x + y * y

# ── PRACTICAL INSPECT USE ─────────

# Decorator that validates types using inspection
def validate_types(func):
    """Decorator that checks argument types at runtime."""
    hints = get_type_hints(func)
    sig = inspect.signature(func)

    def wrapper(*args, **kwargs):
        # Map args to parameter names
        bound = sig.bind(*args, **kwargs)
        bound.apply_defaults()

        for param_name, value in bound.arguments.items():
            if param_name in hints and hints[param_name] is not None:
                expected = hints[param_name]
                if not isinstance(value, expected):
                    raise TypeError(
                        f"Parameter '{param_name}' expected {expected.__name__}, "
                        f"got {type(value).__name__}"
                    )
        return func(*args, **kwargs)
    return wrapper

@validate_types
def greet(name: str, times: int) -> str:
    return (f"Hello, {name}! " * times).strip()

print(f"\\n{greet('Alice', 3)}")
try:
    greet("Alice", "3")   # should be int, not str!
except TypeError as e:
    print(f"Type error caught: {e}")

📝 KEY POINTS:
✅ inspect.signature() is the definitive way to introspect function parameters
✅ ast.literal_eval() safely evaluates data literals — use instead of eval() for user input
✅ ast.NodeVisitor with visit_NodeType() methods to analyze code structure
✅ ast.NodeTransformer with visit_NodeType() to rewrite/transform code
✅ ast.unparse() (Python 3.9+) converts AST back to source code
✅ inspect.getsource() gets the actual source code of any Python object
✅ inspect.stack() is invaluable for debugging and logging context
❌ Never use eval() on user input — use ast.literal_eval() for data literals
❌ ast.NodeTransformer: always call self.generic_visit(node) to process children
❌ inspect.getsource() fails on built-in functions (C implementation, no source)
''',
  quiz: [
    Quiz(question: 'What does ast.literal_eval() safely evaluate?', options: [
      QuizOption(text: 'Any Python expression including function calls', correct: false),
      QuizOption(text: 'Only Python literals: strings, numbers, lists, dicts, booleans, None', correct: true),
      QuizOption(text: 'Any expression that does not use import statements', correct: false),
      QuizOption(text: 'Only numeric expressions', correct: false),
    ]),
    Quiz(question: 'What does inspect.signature(func) return?', options: [
      QuizOption(text: 'The source code of the function', correct: false),
      QuizOption(text: 'A Signature object describing all parameters, their types, and defaults', correct: true),
      QuizOption(text: 'The return value of calling the function', correct: false),
      QuizOption(text: 'A string showing the function\'s name', correct: false),
    ]),
    Quiz(question: 'In an ast.NodeVisitor, what does generic_visit(node) do?', options: [
      QuizOption(text: 'Visits only the node itself, not its children', correct: false),
      QuizOption(text: 'Continues visiting child nodes — must be called to recurse into the tree', correct: true),
      QuizOption(text: 'Returns the node unchanged', correct: false),
      QuizOption(text: 'Transforms the node to its default representation', correct: false),
    ]),
  ],
);

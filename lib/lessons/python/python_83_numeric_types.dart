import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson83 = Lesson(
  language: 'Python',
  title: 'Numeric Types: Decimal, Fraction & Complex',
  content: '''
🎯 METAPHOR:
Python's numeric tower has three floors above plain floats.
The ground floor (float) uses IEEE 754 binary floating point —
fast but imprecise. 0.1 + 0.2 ≠ 0.3 there.
The second floor (Decimal) is like an accountant's ledger —
precise to exactly as many digits as you specify.
Perfect for money. 0.1 + 0.2 = 0.3 exactly.
The third floor (Fraction) is like a mathematician's notepad
— it keeps 1/3 as exactly 1/3, never converting to a decimal.
The penthouse (complex) adds the imaginary dimension for
engineering and signal processing.

📖 EXPLANATION:
Python has 4 numeric types beyond int and float:
  Decimal  → fixed-precision decimal arithmetic
  Fraction → exact rational numbers (numerator/denominator)
  complex  → complex numbers with real + imaginary parts
  int      → arbitrary precision (already covered!)

─────────────────────────────────────
💰 DECIMAL — EXACT DECIMAL MATH
─────────────────────────────────────
from decimal import Decimal, getcontext, ROUND_HALF_UP

getcontext().prec = 28   # set precision (significant digits)

Use for: money, tax calculations, anything needing
         exact decimal results

─────────────────────────────────────
➗ FRACTION — EXACT RATIONAL MATH
─────────────────────────────────────
from fractions import Fraction

Fraction(1, 3)      → 1/3 exactly
Fraction("1/3")     → 1/3 from string
Fraction(0.1)       → shows float's true value!

Auto-reduces: Fraction(4, 8) → Fraction(1, 2)

─────────────────────────────────────
🔢 COMPLEX — IMAGINARY NUMBERS
─────────────────────────────────────
z = 3 + 4j       → complex literal
z = complex(3, 4) → constructor

z.real    → 3.0
z.imag    → 4.0
z.conjugate() → 3-4j
abs(z)    → 5.0 (magnitude)

import cmath  for complex math functions

─────────────────────────────────────
📊 NUMERIC TOWER HIERARCHY
─────────────────────────────────────
int → float → complex   (Python's automatic promotion)
int and Decimal don't mix without explicit conversion
Fraction and float mix but lose exactness

💻 CODE:
from decimal import Decimal, getcontext, ROUND_HALF_UP, ROUND_CEILING
from fractions import Fraction
import cmath
import math

# ── THE FLOAT PROBLEM ─────────────

# IEEE 754 binary floating point is IMPRECISE for decimals
print(0.1 + 0.2)              # 0.30000000000000004
print(0.1 + 0.2 == 0.3)       # False!
print(f"{0.1:.20f}")          # 0.10000000000000000555...

# For comparisons, use tolerance (not ==)
import math
print(math.isclose(0.1 + 0.2, 0.3))  # True

# ── DECIMAL — EXACT DECIMAL MATH ──

# Always create from STRING, not float!
d1 = Decimal("0.1")
d2 = Decimal("0.2")
d3 = d1 + d2
print(d3)              # 0.3  (exact!)
print(d3 == Decimal("0.3"))   # True

# From float — shows float's imprecision
bad = Decimal(0.1)     # DON'T DO THIS
print(bad)             # Decimal('0.1000000000000000055511151231257827021181583404541015625')

# Set precision globally
getcontext().prec = 50   # 50 significant digits
result = Decimal("1") / Decimal("3")
print(result)   # 0.33333333333333333333333333333333333333333333333333

# Reset to default
getcontext().prec = 28

# Money calculation example
price = Decimal("19.99")
tax_rate = Decimal("0.0875")
quantity = 3

subtotal = price * quantity
tax = (subtotal * tax_rate).quantize(Decimal("0.01"), rounding=ROUND_HALF_UP)
total = subtotal + tax

print(f"Subtotal: ${subtotal}")    # $59.97
print(f"Tax:      ${tax}")         # $5.25
print(f"Total:    ${total}")       # $65.22

# Rounding modes
d = Decimal("2.5")
print(d.quantize(Decimal("1"), rounding=ROUND_HALF_UP))    # 3
print(d.quantize(Decimal("1"), rounding=ROUND_CEILING))    # 3

d = Decimal("2.345")
print(d.quantize(Decimal("0.01")))                    # 2.34 (ROUND_HALF_EVEN default)
print(d.quantize(Decimal("0.01"), rounding=ROUND_HALF_UP)) # 2.35

# Arithmetic
print(Decimal("10") / Decimal("3"))    # 3.333...3333 (28 digits)
print(Decimal("10") % Decimal("3"))    # 1
print(Decimal("2") ** 10)              # 1024

# Infinity and NaN
from decimal import Decimal, InvalidOperation
inf = Decimal("Infinity")
nan = Decimal("NaN")
print(inf + Decimal("1"))   # Infinity

# Special values
print(Decimal("0").is_zero())    # True
print(Decimal("Inf").is_infinite()) # True
print(Decimal("NaN").is_nan())   # True

# ── FRACTION — EXACT RATIONALS ────

# Create fractions
f1 = Fraction(1, 3)    # 1/3 exactly
f2 = Fraction(1, 6)    # 1/6 exactly
f3 = f1 + f2
print(f3)              # 1/2  (auto-simplified!)

# From string
f4 = Fraction("3/4")
f5 = Fraction("1.5")   # → 3/2
print(f4, f5)

# Auto-reduction
print(Fraction(4, 8))   # 1/2  (GCD reduction)
print(Fraction(6, 4))   # 3/2

# Exact arithmetic
print(Fraction(1, 3) + Fraction(1, 3) + Fraction(1, 3))  # 1 exactly!
print(Fraction(1, 3) * 3)   # 1 exactly!

# Compare to float
print(Fraction(1, 3) > 0.333)   # True (exact comparison!)

# From float — reveals float's true value!
print(Fraction(0.1))
# Fraction(3602879701896397, 36028797018963968) — that's what 0.1 really is!

# Numerator and denominator
f = Fraction(7, 4)
print(f.numerator)    # 7
print(f.denominator)  # 4

# Practical: exact unit conversion
def exact_convert(value: Fraction, from_unit: str, to_unit: str) -> Fraction:
    conversions = {
        ("inches", "cm"):  Fraction(127, 50),  # exactly 2.54
        ("cm", "inches"):  Fraction(50, 127),
        ("lbs", "kg"):     Fraction(45359237, 100000000),
        ("miles", "km"):   Fraction(1609344, 1000000),
    }
    factor = conversions.get((from_unit, to_unit), Fraction(1))
    return value * factor

inches = Fraction(12)
cm = exact_convert(inches, "inches", "cm")
print(f"12 inches = {cm} cm = {float(cm):.4f} cm")

# Limit denominator (for approximation)
pi_approx = Fraction(math.pi).limit_denominator(100)
print(f"π ≈ {pi_approx} = {float(pi_approx):.6f}")   # 311/99

# ── COMPLEX NUMBERS ───────────────

# Create complex numbers
z1 = 3 + 4j      # literal syntax
z2 = complex(1, -2)
z3 = complex(0, 1)  # imaginary unit j

print(z1)           # (3+4j)
print(z2)           # (1-2j)
print(z3)           # 1j

# Components
print(z1.real)       # 3.0
print(z1.imag)       # 4.0
print(z1.conjugate()) # (3-4j)
print(abs(z1))       # 5.0  (magnitude: sqrt(3²+4²))

# Arithmetic
print(z1 + z2)    # (4+2j)
print(z1 * z2)    # (3+4j)*(1-2j) = 3-6j+4j-8j² = 11-2j
print(z1 / z2)    # complex division

# Powers
print(z3 ** 2)    # (-0+0j) = -1  (j² = -1)

# cmath — math functions for complex numbers
print(cmath.sqrt(-1))          # 1j  (real math would fail!)
print(cmath.sqrt(-4))          # 2j
print(cmath.exp(1j * math.pi)) # Euler's formula: e^(iπ) ≈ -1+0j

# Polar form
r, theta = cmath.polar(z1)
print(f"r={r:.2f}, θ={math.degrees(theta):.1f}°")  # r=5.00, θ=53.1°

# From polar back to rectangular
z_back = cmath.rect(r, theta)
print(z_back)   # (3+4j) approximately

# Phase (angle)
print(cmath.phase(z1))   # 0.9272... radians

# Useful: roots of unity (signal processing)
n = 8  # 8th roots of unity
roots = [cmath.rect(1, 2 * math.pi * k / n) for k in range(n)]
for k, root in enumerate(roots):
    print(f"  ω^{k} = {root.real:.3f} + {root.imag:.3f}j")

# ── TYPE PROMOTION ────────────────

# Python's numeric tower: int → float → complex
print(type(1 + 1.0))     # float (int promoted to float)
print(type(1.0 + 1j))    # complex (float promoted to complex)

# Decimal doesn't mix with float automatically
try:
    print(Decimal("1.5") + 1.5)
except TypeError as e:
    print(f"TypeError: {e}")

# Must convert explicitly
print(Decimal("1.5") + Decimal(str(1.5)))  # or Decimal("1.5")

# Fraction and float mix (but loses exactness)
print(Fraction(1, 3) + 0.5)   # 0.833... as float

# ── WHEN TO USE EACH ──────────────

print("""
USE:
  int     → integers (arbitrary precision), loop counters
  float   → scientific computing, approximate real numbers
  Decimal → money, accounting, tax, banking
  Fraction → exact ratios, unit fractions, number theory
  complex → signal processing, electrical engineering, math
  
AVOID:
  float for money → use Decimal
  float == float  → use math.isclose()
  Decimal(0.1)    → use Decimal("0.1") (string!)
""")

📝 KEY POINTS:
✅ Float arithmetic is imprecise — 0.1 + 0.2 ≠ 0.3 in float
✅ Decimal("0.1") is exact — always create from strings, not floats
✅ Fraction stores exact rationals — 1/3 stays 1/3, never 0.333...
✅ Use math.isclose() for float comparisons, not ==
✅ Decimal is for money; Fraction is for exact math; complex for imaginary
✅ cmath provides sqrt, exp, log, sin etc. for complex numbers
✅ abs(complex_number) gives the magnitude (distance from origin)
❌ Never do Decimal(0.1) — pass as a string: Decimal("0.1")
❌ Never use float for currency calculations — use Decimal
❌ Decimal and float don't mix without explicit conversion (TypeError)
''',
  quiz: [
    Quiz(question: 'Why is Decimal("0.1") preferred over Decimal(0.1)?', options: [
      QuizOption(text: 'Decimal() cannot accept float arguments', correct: false),
      QuizOption(text: 'Decimal(0.1) inherits float\'s imprecision; Decimal("0.1") is exact', correct: true),
      QuizOption(text: 'String creation is faster', correct: false),
      QuizOption(text: 'They produce identical results', correct: false),
    ]),
    Quiz(question: 'What does Fraction(1,3) + Fraction(1,3) + Fraction(1,3) equal?', options: [
      QuizOption(text: 'Fraction(1, 1) — exactly 1', correct: true),
      QuizOption(text: '0.9999999999999999 — floating point error', correct: false),
      QuizOption(text: 'Fraction(3, 9) — not reduced', correct: false),
      QuizOption(text: 'A TypeError', correct: false),
    ]),
    Quiz(question: 'What does abs(3 + 4j) return?', options: [
      QuizOption(text: '7 — sum of real and imaginary parts', correct: false),
      QuizOption(text: '5.0 — the magnitude: sqrt(3² + 4²)', correct: true),
      QuizOption(text: '(3+4j) — complex numbers are already positive', correct: false),
      QuizOption(text: '3 — the real part only', correct: false),
    ]),
  ],
);

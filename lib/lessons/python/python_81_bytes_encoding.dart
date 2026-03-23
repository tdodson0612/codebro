import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson81 = Lesson(
  language: 'Python',
  title: 'Bytes, Encoding & Unicode',
  content: """
🎯 METAPHOR:
The difference between str and bytes is like the difference
between a word and its ink on paper. A word (str) is an
abstract concept — "café" has meaning regardless of font.
Ink on paper (bytes) is the physical representation:
which specific bits are written. The encoding (UTF-8,
Latin-1, ASCII) is the "font rule" that maps between them.
Python 3 keeps these strictly separate — you can't
accidentally mix them. You must explicitly choose the
encoding when crossing the boundary.

📖 EXPLANATION:
Python 3 has two fundamental text-like types:
  str   → Unicode text (abstract characters)
  bytes → raw binary data (0-255 per byte)

They are completely separate types. You convert between
them with encode() and decode(), always specifying encoding.

─────────────────────────────────────
📐 str vs bytes
─────────────────────────────────────
"hello"      → str   — Unicode, each char is a code point
b"hello"     → bytes — sequence of integers 0-255

str methods:  .upper(), .split(), .find() etc
bytes methods: .upper(), .split(), .find() etc (same names!)
              BUT no .format() — bytes aren't text

─────────────────────────────────────
🔄 CONVERTING BETWEEN THEM
─────────────────────────────────────
str  → bytes:  "hello".encode("utf-8")
bytes → str:   b"hello".decode("utf-8")

Common encodings:
  utf-8      → universal, variable 1-4 bytes per char (USE THIS)
  ascii      → 0-127 only, 1 byte per char
  latin-1    → 0-255, 1 byte per char, Western European
  utf-16     → 2-4 bytes, used by Windows/Java
  utf-32     → fixed 4 bytes per char

─────────────────────────────────────
📦 BYTEARRAY
─────────────────────────────────────
bytes      → immutable sequence of integers
bytearray  → mutable sequence of integers

Like bytes but you can change individual bytes.

─────────────────────────────────────
🔬 MEMORYVIEW
─────────────────────────────────────
Provides a zero-copy view of binary data.
Access slices without copying.
Works with bytes, bytearray, array.array.

─────────────────────────────────────
🌍 UNICODE BASICS
─────────────────────────────────────
Unicode is a universal standard assigning numbers (code points)
to every character in every writing system.
  "A" → U+0041
  "é" → U+00E9
  "中" → U+4E2D
  "😀" → U+1F600

Python 3 str stores Unicode code points internally.
UTF-8 is the encoding that represents these as bytes.

💻 CODE:
# ── STR vs BYTES ──────────────────

# str — Unicode text
s = "Hello, café! 中文 😀"
print(type(s))      # <class 'str'>
print(len(s))       # 17 characters (code points)
print(s[7])         # é

# bytes — raw binary
b = b"Hello, world!"
print(type(b))      # <class 'bytes'>
print(len(b))       # 13 bytes
print(b[0])         # 72  (integer, not character!)
print(b[0:5])       # b'Hello' (slice gives bytes)

# They are NOT compatible
try:
    result = "hello" + b" world"
except TypeError as e:
    print(f"TypeError: {e}")

try:
    result = "hello" == b"hello"
    print(f"str == bytes: {result}")   # False (not equal, not error)
except Exception as e:
    print(e)

# ── ENCODING (str → bytes) ────────

text = "Hello, café! 😀"

# UTF-8 (recommended always)
utf8 = text.encode("utf-8")
print(f"UTF-8:   {utf8}")
print(f"UTF-8 length: {len(utf8)} bytes")   # more than len(text)!

# ASCII — fails on non-ASCII chars
try:
    ascii_bytes = text.encode("ascii")
except UnicodeEncodeError as e:
    print(f"ASCII can't encode 'é': {e}")

# Encode with error handling
safe = text.encode("ascii", errors="ignore")    # skip bad chars
print(f"ASCII ignore: {safe}")

replaced = text.encode("ascii", errors="replace")  # ? for bad chars
print(f"ASCII replace: {replaced}")

xmlesc = text.encode("ascii", errors="xmlcharrefreplace")  # &#xxx;
print(f"XML escape: {xmlesc}")

# Different encodings give different bytes
print(f"UTF-8:   {len('café'.encode('utf-8'))} bytes")    # 5
print(f"UTF-16:  {len('café'.encode('utf-16'))} bytes")   # 10 (+ BOM)
print(f"Latin-1: {len('café'.encode('latin-1'))} bytes")  # 4

# ── DECODING (bytes → str) ────────

data = b"Hello, caf\xc3\xa9!"   # UTF-8 bytes for "café"

decoded = data.decode("utf-8")
print(f"Decoded: {decoded}")     # Hello, café!

# Wrong encoding → garbled or error
try:
    wrong = data.decode("ascii")
except UnicodeDecodeError as e:
    print(f"Wrong encoding: {e}")

# Decode with error handling
garbled = data.decode("ascii", errors="replace")   # replacement char
print(f"Wrong (replace): {garbled}")

# ── BYTEARRAY — MUTABLE BYTES ─────

# bytes is immutable
b = b"hello"
try:
    b[0] = 72   # TypeError!
except TypeError as e:
    print(f"bytes immutable: {e}")

# bytearray is mutable
ba = bytearray(b"hello")
ba[0] = 72          # 'H' in ASCII
ba[1] = 105         # 'i'
print(ba)           # bytearray(b'Hillo')
print(ba.decode())  # Hillo

# Build bytes incrementally
buf = bytearray()
buf.extend(b"Hello")
buf.append(44)       # ','
buf.extend(b" World")
print(bytes(buf))    # b'Hello, World'
print(buf.decode())  # Hello, World

# ── MEMORYVIEW — ZERO-COPY ────────

data = bytearray(range(256))   # 256 bytes: 0, 1, 2, ... 255
view = memoryview(data)

# Slice without copying!
chunk = view[10:20]
print(bytes(chunk))   # b'\n\x0b\x0c\r\x0e\x0f\x10\x11\x12\x13'

# Modify through view
view[0] = 255
print(data[0])   # 255 — original modified!

# Cast to different types (reinterpret bytes)
import array
arr = array.array("i", [1, 2, 3, 4])   # 4 signed ints
mv = memoryview(arr)
print(mv.format)   # 'i' — signed int
print(mv[0])       # 1

# ── UNICODE & CODE POINTS ─────────

# ord() — character to code point (int)
print(ord("A"))     # 65
print(ord("é"))     # 233
print(ord("中"))    # 20013
print(ord("😀"))   # 128512

# chr() — code point to character
print(chr(65))      # A
print(chr(233))     # é
print(chr(20013))   # 中
print(chr(128512))  # 😀

# Unicode names
import unicodedata
print(unicodedata.name("A"))       # LATIN CAPITAL LETTER A
print(unicodedata.name("é"))       # LATIN SMALL LETTER E WITH ACUTE
print(unicodedata.name("😀"))     # GRINNING FACE
print(unicodedata.category("A"))   # Lu (Letter, uppercase)
print(unicodedata.category("1"))   # Nd (Number, decimal digit)

# Normalization (same-looking chars can have different code points!)
s1 = "café"           # "é" as single code point U+00E9
s2 = "cafe\u0301"    # "e" + combining accent U+0301
print(s1 == s2)        # False — different code points!
print(len(s1), len(s2))  # 4  vs  5

# Normalize first:
n1 = unicodedata.normalize("NFC", s1)
n2 = unicodedata.normalize("NFC", s2)
print(n1 == n2)   # True — normalized!

# Case folding for comparison
print("café".casefold() == "CAFÉ".casefold())   # True

# ── FILE ENCODING ─────────────────

# Always specify encoding!
with open("test.txt", "w", encoding="utf-8") as f:
    f.write("Hello, café! 中文 😀\\n")

with open("test.txt", "r", encoding="utf-8") as f:
    content = f.read()
print(content)

# Binary mode (no encoding/decoding)
with open("test.txt", "rb") as f:
    raw = f.read()
print(raw[:20])  # raw UTF-8 bytes

# ── STRUCT — BINARY PACKING ───────

import struct

# Pack values into binary format
# ">IHH" = big-endian, unsigned int (4 bytes), 2x unsigned short (2 bytes)
packed = struct.pack(">IHH", 0x08090A0B, 0x0C0D, 0x0E0F)
print(f"Packed: {packed.hex()}")   # 08090a0b0c0d0e0f

# Unpack binary data back to Python values
unpacked = struct.unpack(">IHH", packed)
print(f"Unpacked: {unpacked}")   # (134678027, 3085, 3599)

# Struct format codes:
# b/B — signed/unsigned byte (1)
# h/H — signed/unsigned short (2)
# i/I — signed/unsigned int (4)
# q/Q — signed/unsigned long long (8)
# f   — float (4)
# d   — double (8)
# s   — char[] (bytes)
# x   — pad byte (skip)
# > = big-endian, < = little-endian, = = native

# Read a BMP file header
BMP_HEADER_FMT = "<2sIHHI"   # little-endian
BMP_HEADER_SIZE = struct.calcsize(BMP_HEADER_FMT)
print(f"BMP header size: {BMP_HEADER_SIZE} bytes")

# ── BASE64 ENCODING ───────────────

import base64

# Binary data → ASCII-safe text
data = bytes(range(16))
b64 = base64.b64encode(data)
print(f"Base64: {b64}")   # b'AAECAwQFBgcICQoLDA0ODw=='

# Back to binary
decoded = base64.b64decode(b64)
print(f"Decoded: {decoded}")   # b'\\x00\\x01\\x02...'

# URL-safe variant (no +/ characters)
url_safe = base64.urlsafe_b64encode(data)
print(f"URL-safe: {url_safe}")

# Encode a string via base64 (for embedding in JSON etc)
text = "Hello, café! 😀"
encoded = base64.b64encode(text.encode("utf-8")).decode("ascii")
print(f"B64 text: {encoded}")

# Hex encoding
hex_str = data.hex()
print(f"Hex: {hex_str}")      # 000102030405060708090a0b0c0d0e0f
back = bytes.fromhex(hex_str)
print(f"From hex: {back}")

import os
os.remove("test.txt")

📝 KEY POINTS:
✅ str is Unicode text; bytes is raw binary — they are separate, incompatible types
✅ Always encode/decode with explicit encoding: .encode("utf-8") / .decode("utf-8")
✅ UTF-8 is the encoding you should use for almost everything
✅ len(str) = number of characters; len(bytes) = number of bytes (may differ!)
✅ bytearray is mutable bytes — use when building binary data incrementally
✅ memoryview provides zero-copy access to binary buffers
✅ struct.pack/unpack for reading/writing binary file formats and network protocols
✅ base64 encodes binary data as ASCII text (for JSON, HTML, email)
❌ Never open text files without specifying encoding — default varies by OS!
❌ Never compare str == bytes (always False) or concatenate them (TypeError)
❌ Assuming all text is ASCII — Python 3 strings are Unicode, embrace it
""",
  quiz: [
    Quiz(question: 'What is the result of len("café".encode("utf-8"))?', options: [
      QuizOption(text: '4 — same as len("café")', correct: false),
      QuizOption(text: '5 — "é" takes 2 bytes in UTF-8', correct: true),
      QuizOption(text: '8 — UTF-8 uses 2 bytes per character', correct: false),
      QuizOption(text: 'A UnicodeEncodeError', correct: false),
    ]),
    Quiz(question: 'What is the difference between bytes and bytearray?', options: [
      QuizOption(text: 'bytes stores text; bytearray stores binary', correct: false),
      QuizOption(text: 'bytes is immutable; bytearray is mutable', correct: true),
      QuizOption(text: 'bytearray can only store ASCII; bytes handles Unicode', correct: false),
      QuizOption(text: 'They are identical — just different names', correct: false),
    ]),
    Quiz(question: 'What does struct.pack(">I", 255) produce?', options: [
      QuizOption(text: 'The string "255"', correct: false),
      QuizOption(text: 'The integer 255', correct: false),
      QuizOption(text: 'A 4-byte big-endian binary representation of 255', correct: true),
      QuizOption(text: 'A list of 255 bytes', correct: false),
    ]),
  ],
);

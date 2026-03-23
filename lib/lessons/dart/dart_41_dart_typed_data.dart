import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson41 = Lesson(
  language: 'Dart',
  title: 'dart:typed_data',
  content: '''
🎯 METAPHOR:
dart:typed_data is like specialized warehouses vs a
general storage unit. A regular List<int> is the general
storage unit — flexible, accepts any size integer, but
wastes space and is slow for bulk operations. A Uint8List
is a warehouse built EXACTLY for 8-bit items — every
slot holds exactly one byte, storage is packed tight,
operations are blazing fast. When you process images,
audio samples, network packets, or binary file formats,
you need the specialized warehouse, not the general unit.

📖 EXPLANATION:
dart:typed_data provides typed arrays backed by raw binary
buffers — similar to JavaScript's TypedArray. They're
essential for image processing, audio, network protocols,
file parsing, and any scenario requiring efficient binary
data manipulation.

─────────────────────────────────────
📦 KEY TYPES
─────────────────────────────────────
Uint8List      → unsigned 8-bit integers (bytes, 0–255)
Int8List       → signed 8-bit integers (-128–127)
Uint16List     → unsigned 16-bit integers
Int16List      → signed 16-bit integers
Uint32List     → unsigned 32-bit integers
Int32List      → signed 32-bit integers
Uint64List     → unsigned 64-bit integers
Int64List      → signed 64-bit integers
Float32List    → 32-bit floats
Float64List    → 64-bit doubles (same as Dart double)

ByteData       → random access to a ByteBuffer
ByteBuffer     → raw memory buffer

─────────────────────────────────────
🔑 BYTEDATA — THE SWISS ARMY KNIFE
─────────────────────────────────────
ByteData lets you READ AND WRITE different types
at different offsets in the same buffer:

  final bd = ByteData(8);
  bd.setUint32(0, 0xDEADBEEF);   // bytes 0-3
  bd.setUint32(4, 0xCAFEBABE);   // bytes 4-7
  print(bd.getUint8(0));          // 0xDE = 222

  // Endianness matters!
  bd.setUint32(0, 255, Endian.big);    // big-endian
  bd.setUint32(0, 255, Endian.little); // little-endian

─────────────────────────────────────
🔄 CONVERTING BETWEEN TYPES
─────────────────────────────────────
// List<int> → Uint8List
Uint8List.fromList([72, 101, 108, 108, 111])

// Uint8List → String (via utf8)
utf8.decode(uint8List)

// Share a ByteBuffer between different views:
var buffer = Uint8List(8).buffer;
var bytes = Uint8List.view(buffer);
var shorts = Uint16List.view(buffer);
// Both see the same memory!

─────────────────────────────────────
⚡ PERFORMANCE
─────────────────────────────────────
Uint8List is MUCH faster than List<int> for bulk ops:
• Backed by native array (no boxing)
• SIMD operations possible
• Zero-copy views (no data copied)
• Efficient transfer between isolates
  (use TransferableTypedData)

💻 CODE:
import 'dart:typed_data';
import 'dart:convert';

void main() {
  // ── BASIC TYPED ARRAYS ─────────
  // Create
  final bytes = Uint8List(4);      // [0, 0, 0, 0]
  bytes[0] = 72;   // H
  bytes[1] = 105;  // i
  bytes[2] = 33;   // !
  print(bytes);    // [72, 105, 33, 0]
  print(utf8.decode(bytes.sublist(0, 3)));  // Hi!

  // From list
  final from = Uint8List.fromList([0xFF, 0x00, 0xAB, 0xCD]);
  print(from[0]);   // 255
  print(from[3]);   // 205

  // Different types
  final floats = Float64List(3);
  floats[0] = 3.14159;
  floats[1] = 2.71828;
  floats[2] = 1.61803;
  print(floats);   // [3.14159, 2.71828, 1.61803]

  final ints32 = Int32List.fromList([-1000000, 0, 1000000]);
  print(ints32);

  // ── BYTEDATA ───────────────────
  final bd = ByteData(16);

  // Write different types at different offsets
  bd.setUint8(0, 0xFF);           // byte 0 = 255
  bd.setUint16(1, 0xABCD);        // bytes 1-2
  bd.setUint32(3, 0xDEADBEEF);    // bytes 3-6 (native endian)
  bd.setUint32(7, 255, Endian.big);    // big-endian
  bd.setUint32(11, 255, Endian.little); // little-endian
  bd.setFloat64(12, 3.14);        // last 4 bytes — wait, 12+8=20 > 16!

  // Actually: 16 bytes total
  final bd2 = ByteData(16);
  bd2.setUint32(0, 0xCAFEBABE, Endian.big);
  bd2.setUint32(4, 0xDEADBEEF, Endian.big);
  bd2.setFloat64(8, 3.14159265358979, Endian.little);

  // Read back
  print(bd2.getUint32(0, Endian.big).toRadixString(16));   // cafebabe
  print(bd2.getUint32(4, Endian.big).toRadixString(16));   // deadbeef
  print(bd2.getFloat64(8, Endian.little));  // 3.14159265358979

  // ── VIEWS — ZERO COPY ──────────
  // Different typed views of the SAME buffer
  final buffer = ByteBuffer.fromUint8List(Uint8List.fromList([
    0x01, 0x00, 0x02, 0x00,   // two Uint16 values (little-endian)
    0x03, 0x00, 0x04, 0x00,
  ]));

  final u8view  = Uint8List.view(buffer);
  final u16view = Uint16List.view(buffer);

  print('Uint8:  \${u8view.toList()}');
  // [1, 0, 2, 0, 3, 0, 4, 0]

  print('Uint16: \${u16view.toList()}');
  // [1, 2, 3, 4]  (little-endian)

  // Both see the same memory — modifying one affects the other!
  u8view[0] = 0xFF;
  print('After modify Uint16[0]: \${u16view[0]}');  // 255

  // ── PRACTICAL: BINARY FILE FORMAT ─
  // Write a simple binary format:
  // Magic bytes (4) | version (1) | count (4) | data (n * 4)

  final values = [10, 20, 30, 40, 50];
  final buffer2 = _writeBinaryFormat(values);
  final parsed = _readBinaryFormat(buffer2);
  print('Written and read back: \$parsed');  // [10, 20, 30, 40, 50]

  // ── UINT8LIST ↔ STRING ──────────
  // String → Uint8List (common for file writing)
  final text = 'Hello, Dart! 🎯';
  final encoded = Uint8List.fromList(utf8.encode(text));
  print('Bytes: \${encoded.length}');

  // Uint8List → String
  final decoded = utf8.decode(encoded);
  print('Decoded: \$decoded');

  // ── SUBLIST (SLICE) ─────────────
  final data = Uint8List.fromList(List.generate(20, (i) => i));
  final slice = data.sublist(5, 10);   // bytes 5-9
  print('Slice: \$slice');   // [5, 6, 7, 8, 9]

  // sublist copies — if you want a view:
  final view = Uint8List.view(data.buffer, 5, 5);  // offset=5, length=5
  print('View: \$view');     // [5, 6, 7, 8, 9]

  // Modifying view changes original!
  view[0] = 99;
  print('data[5] after view modify: \${data[5]}');  // 99

  // ── COPY DATA ─────────────────
  final src = Uint8List.fromList([1, 2, 3, 4, 5]);
  final dst = Uint8List(10);
  dst.setAll(2, src);   // copy src into dst starting at offset 2
  print(dst);  // [0, 0, 1, 2, 3, 4, 5, 0, 0, 0]

  dst.setRange(0, 3, src, 2);  // copy src[2..5] into dst[0..3]
  print(dst);  // [3, 4, 5, 2, 3, 4, 5, 0, 0, 0]
}

Uint8List _writeBinaryFormat(List<int> values) {
  final size = 4 + 1 + 4 + values.length * 4;  // magic + version + count + data
  final bd = ByteData(size);
  int offset = 0;

  // Magic bytes 'DART'
  bd.setUint8(offset++, 0x44);  // D
  bd.setUint8(offset++, 0x41);  // A
  bd.setUint8(offset++, 0x52);  // R
  bd.setUint8(offset++, 0x54);  // T

  // Version
  bd.setUint8(offset++, 1);

  // Count
  bd.setUint32(offset, values.length, Endian.big);
  offset += 4;

  // Data
  for (final v in values) {
    bd.setInt32(offset, v, Endian.big);
    offset += 4;
  }

  return bd.buffer.asUint8List();
}

List<int> _readBinaryFormat(Uint8List bytes) {
  final bd = ByteData.view(bytes.buffer);
  int offset = 0;

  // Verify magic
  final magic = String.fromCharCodes([
    bd.getUint8(offset++), bd.getUint8(offset++),
    bd.getUint8(offset++), bd.getUint8(offset++),
  ]);
  if (magic != 'DART') throw FormatException('Invalid magic: \$magic');

  final version = bd.getUint8(offset++);
  final count = bd.getUint32(offset, Endian.big);
  offset += 4;

  return List.generate(count, (i) {
    final v = bd.getInt32(offset, Endian.big);
    offset += 4;
    return v;
  });
}

extension on ByteBuffer {
  static ByteBuffer fromUint8List(Uint8List list) => list.buffer;
}

📝 KEY POINTS:
✅ Uint8List is far faster than List<int> for binary data operations
✅ ByteData provides typed reads/writes at specific offsets in a buffer
✅ Endian.big vs Endian.little matters for cross-platform binary compatibility
✅ Views (Uint16List.view(buffer)) share memory with no copying
✅ sublist() copies; view() shares — use view() for performance-critical code
✅ Uint8List.fromList(utf8.encode(s)) for string-to-bytes conversion
✅ TransferableTypedData enables zero-copy transfer between isolates
✅ ByteData is essential for parsing and creating binary file formats
❌ Don't access typed arrays out of bounds — throws RangeError
❌ Forgetting endianness causes subtle bugs when parsing network data
❌ Uint8List wrapping a ByteBuffer and modifying it affects all views
''',
  quiz: [
    Quiz(question: 'What is the main performance advantage of Uint8List over List<int>?', options: [
      QuizOption(text: 'Uint8List supports more operations than List<int>', correct: false),
      QuizOption(text: 'Uint8List is backed by a compact native array with no boxing — faster and more memory efficient', correct: true),
      QuizOption(text: 'Uint8List is automatically sorted', correct: false),
      QuizOption(text: 'Uint8List allows null values; List<int> does not', correct: false),
    ]),
    Quiz(question: 'What does Uint16List.view(buffer) create?', options: [
      QuizOption(text: 'A copy of the buffer as 16-bit integers', correct: false),
      QuizOption(text: 'A zero-copy view of the same buffer memory interpreted as 16-bit integers', correct: true),
      QuizOption(text: 'A new buffer with double the size', correct: false),
      QuizOption(text: 'A read-only version of the buffer', correct: false),
    ]),
    Quiz(question: 'Why does endianness matter when using ByteData?', options: [
      QuizOption(text: 'It affects performance only', correct: false),
      QuizOption(text: 'Different platforms store multi-byte numbers with bytes in different orders — wrong endianness gives wrong values', correct: true),
      QuizOption(text: 'Endianness only matters for floating-point numbers', correct: false),
      QuizOption(text: 'It determines the buffer\'s memory alignment', correct: false),
    ]),
  ],
);

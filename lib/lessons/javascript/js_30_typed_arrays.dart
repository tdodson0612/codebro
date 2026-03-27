import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson30 = Lesson(
  language: 'JavaScript',
  title: 'Typed Arrays and ArrayBuffer',
  content: """
🎯 METAPHOR:
An ArrayBuffer is like a fixed-size block of raw memory —
a flat slab of bytes with no inherent structure or meaning.
On its own it's useless — just a sequence of bits. Typed
Arrays are the lens you put over that raw memory to give
it structure and meaning. The same 4 bytes of memory might
look like one 32-bit integer through an Int32Array lens, or
four separate bytes through a Uint8Array lens, or two
16-bit integers through a Uint16Array lens. DataView is
the precision instrument that lets you read any number
of bytes at any position with any interpretation —
like a multi-mode microscope you can configure per read.

📖 EXPLANATION:
Typed Arrays allow you to work with binary data directly.
They're essential for WebGL, audio/video processing, file
reading, WebSockets, and any low-level binary manipulation.

─────────────────────────────────────
TYPED ARRAY TYPES:
─────────────────────────────────────
  Type           Bytes  Range
  ──────────────────────────────────────────────────
  Int8Array      1      -128 to 127
  Uint8Array     1      0 to 255
  Uint8ClampedArray 1   0 to 255 (clamped, not modular)
  Int16Array     2      -32,768 to 32,767
  Uint16Array    2      0 to 65,535
  Int32Array     4      -2^31 to 2^31-1
  Uint32Array    4      0 to 2^32-1
  Float32Array   4      ~±3.4e38 (IEEE 754 float)
  Float64Array   8      ~±1.8e308 (IEEE 754 double)
  BigInt64Array  8      BigInt
  BigUint64Array 8      BigInt

─────────────────────────────────────
CREATING TYPED ARRAYS:
─────────────────────────────────────
  // From length (all zeros):
  const arr = new Int32Array(4);     // [0, 0, 0, 0]

  // From regular array:
  const arr = new Float32Array([1.5, 2.5, 3.5]);

  // From ArrayBuffer:
  const buffer = new ArrayBuffer(16);    // 16 bytes
  const int32  = new Int32Array(buffer); // 4 int32s (4×4=16)
  const float64= new Float64Array(buffer); // 2 float64s (2×8=16)

  // Views share the same buffer!
  int32[0] = 1234567890;
  console.log(float64[0]);  // different interpretation of same bytes

─────────────────────────────────────
TYPED ARRAY OPERATIONS:
─────────────────────────────────────
  Typed arrays share most Array methods:
  .length, .set(), .subarray(), .slice()
  .fill(), .copyWithin()
  .map(), .filter(), .reduce(), .forEach()
  .find(), .findIndex(), .every(), .some()
  .sort(), .reverse(), .indexOf()
  .join(), .entries(), .keys(), .values()

  Key differences from regular Array:
  → Fixed type — all elements same type
  → Fixed length — can't push/pop
  → No sparse arrays — always dense
  → Faster math operations (hardware-level types)

─────────────────────────────────────
DataView — mixed/flexible byte reading:
─────────────────────────────────────
  const buffer = new ArrayBuffer(16);
  const view   = new DataView(buffer);

  // Write:
  view.setInt8(0, 127);          // at byte 0
  view.setFloat32(4, 3.14);      // at byte 4
  view.setInt32(8, -12345, true); // little-endian

  // Read:
  view.getInt8(0)                // 127
  view.getFloat32(4)             // 3.14
  view.getInt32(8, true)         // -12345 (little-endian)

  // Endianness matters for multi-byte reads/writes:
  // true  = little-endian (x86, most CPUs)
  // false = big-endian (network byte order)

─────────────────────────────────────
PRACTICAL USE CASES:
─────────────────────────────────────
  WebGL: Float32Array for vertex data, Uint16Array for indices
  Audio: Float32Array for PCM audio samples
  Images: Uint8ClampedArray for RGBA pixel data (Canvas)
  Files:  Reading binary file formats (PNG, WAV, ZIP headers)
  Network: Parsing binary protocols (WebSocket binary frames)
  Crypto: Working with hash values and keys (Uint8Array)
  WASM:   Sharing memory with WebAssembly modules

─────────────────────────────────────
BUFFER SHARING:
─────────────────────────────────────
  // Multiple views over the SAME buffer:
  const buffer  = new ArrayBuffer(8);
  const bytes   = new Uint8Array(buffer);
  const shorts  = new Uint16Array(buffer);
  const doubles = new Float64Array(buffer);

  // Writing to one view affects others:
  doubles[0] = Math.PI;
  console.log(bytes);  // sees the same 8 bytes

  // SharedArrayBuffer for cross-thread sharing (Workers):
  const shared = new SharedArrayBuffer(1024);
  // Can pass to Web Workers without copying!

💻 CODE:
// ─── TYPED ARRAY BASICS ───────────────────────────────
console.log("=== Typed Array Basics ===");

// Create from values:
const ints   = new Int32Array([1, 2, 3, 4, 5]);
const floats = new Float32Array([1.1, 2.2, 3.3]);
const bytes  = new Uint8Array([255, 128, 0, 64]);

console.log("  Int32Array:", ints);
console.log("  Float32Array:", floats);
console.log("  Uint8Array:", bytes);
console.log("  ints.length:", ints.length);
console.log("  ints.BYTES_PER_ELEMENT:", ints.BYTES_PER_ELEMENT);

// Overflow behavior:
const uint8  = new Uint8Array([300, -1, 256]);  // overflow!
const clamped = new Uint8ClampedArray([300, -1, 256]); // clamped

console.log("  Uint8 overflow:  ", uint8);   // wraps: [44, 255, 0]
console.log("  Uint8Clamped:    ", clamped); // clamped: [255, 0, 255]

// ─── ARRAYBUFFER AND VIEWS ────────────────────────────
console.log("\n=== ArrayBuffer and Views ===");

const buffer = new ArrayBuffer(16);  // 16 bytes of raw memory
console.log("  Buffer byteLength:", buffer.byteLength);

const int32View   = new Int32Array(buffer);    // 4 × 4-byte ints
const uint8View   = new Uint8Array(buffer);    // 16 × 1-byte ints
const float32View = new Float32Array(buffer);  // 4 × 4-byte floats

console.log("  Sharing same buffer:");
int32View[0] = 0x41424344;   // ASCII: DCBA (little-endian)
int32View[1] = 42;
float32View[2] = 3.14;

console.log("  int32View:", Array.from(int32View));
console.log("  uint8View (first 8):", Array.from(uint8View.slice(0, 8)));
console.log("  As ASCII:", String.fromCharCode(...uint8View.slice(0, 4)));

// ─── TYPED ARRAY METHODS ──────────────────────────────
console.log("\n=== Typed Array Methods ===");

const data = new Float32Array([3, 1, 4, 1, 5, 9, 2, 6, 5, 3]);
console.log("  Original:", Array.from(data));

// Most Array methods work:
const doubled  = data.map(n => n * 2);
const filtered = data.filter(n => n > 3);
const sum      = data.reduce((a, n) => a + n, 0);

console.log("  Doubled:", Array.from(doubled));
console.log("  > 3:", Array.from(filtered));
console.log("  Sum:", sum);

// Sort (in-place):
const sorted = new Float32Array(data);  // copy first
sorted.sort();
console.log("  Sorted:", Array.from(sorted));

// set() — copy from array/typed array:
const dest = new Int32Array(10);
dest.set([1, 2, 3], 3);   // start at index 3
console.log("  After set([1,2,3] at 3):", Array.from(dest));

// subarray() — shared view (no copy):
const sub = data.subarray(2, 6);
console.log("  subarray(2,6):", Array.from(sub));

// ─── DATAVIEW ─────────────────────────────────────────
console.log("\n=== DataView (flexible binary access) ===");

const buf  = new ArrayBuffer(16);
const view = new DataView(buf);

// Write different types at specific byte offsets:
view.setUint8(0,   0xDE);         // magic byte 1
view.setUint8(1,   0xAD);         // magic byte 2
view.setInt16(2,   300, true);    // little-endian short
view.setFloat32(4, Math.PI, true);// little-endian float
view.setInt32(8,   -12345, false); // big-endian int

// Read back:
const magic = view.getUint8(0).toString(16).padStart(2, '0') +
              view.getUint8(1).toString(16).padStart(2, '0');
console.log("  Magic bytes:", magic.toUpperCase());
console.log("  Int16 (LE): ", view.getInt16(2, true));
console.log("  Float32:    ", view.getFloat32(4, true).toFixed(5));
console.log("  Int32 (BE): ", view.getInt32(8, false));

// ─── PRACTICAL: Image Pixel Data ──────────────────────
console.log("\n=== Practical: Pixel Data Simulation ===");

// Simulate RGBA image data (like Canvas ImageData):
const width  = 4;
const height = 4;
const pixels = new Uint8ClampedArray(width * height * 4);  // RGBA

// Fill with a gradient:
for (let y = 0; y < height; y++) {
    for (let x = 0; x < width; x++) {
        const i = (y * width + x) * 4;
        pixels[i + 0] = Math.round((x / width) * 255);  // R
        pixels[i + 1] = Math.round((y / height) * 255); // G
        pixels[i + 2] = 128;                             // B
        pixels[i + 3] = 255;                             // A (opaque)
    }
}

console.log("  4×4 RGBA pixel grid:");
for (let y = 0; y < height; y++) {
    const row = [];
    for (let x = 0; x < width; x++) {
        const i = (y * width + x) * 4;
        row.push(\`rgba(\${
pixels[i]},\${
pixels[i+1]},\${
pixels[i+2]},\${
pixels[i+3]})\`);
    }
    console.log("   ", row.map(c => c.slice(0, 16).padEnd(17)).join(" "));
}

// Grayscale conversion (in-place):
for (let i = 0; i < pixels.length; i += 4) {
    const gray = Math.round(0.299 * pixels[i] + 0.587 * pixels[i+1] + 0.114 * pixels[i+2]);
    pixels[i] = pixels[i+1] = pixels[i+2] = gray;
}
console.log("  After grayscale: first pixel R:", pixels[0], "G:", pixels[1], "B:", pixels[2]);

// ─── PRACTICAL: Binary Protocol ───────────────────────
console.log("\n=== Practical: Binary Protocol Encoding ===");

// Encode a simple message packet:
// [ version(1) | type(1) | payloadLength(2) | payload(n) ]
function encodePacket(type, payload) {
    const payloadBytes = new TextEncoder().encode(payload);
    const buffer = new ArrayBuffer(4 + payloadBytes.length);
    const view   = new DataView(buffer);
    view.setUint8(0,  1);                    // version
    view.setUint8(1,  type);                 // message type
    view.setUint16(2, payloadBytes.length, true); // payload length (LE)
    new Uint8Array(buffer, 4).set(payloadBytes);  // payload bytes
    return new Uint8Array(buffer);
}

function decodePacket(bytes) {
    const view    = new DataView(bytes.buffer, bytes.byteOffset);
    const version = view.getUint8(0);
    const type    = view.getUint8(1);
    const length  = view.getUint16(2, true);
    const payload = new TextDecoder().decode(bytes.slice(4, 4 + length));
    return { version, type, payload };
}

const packet = encodePacket(0x01, "Hello, binary world!");
console.log("  Encoded packet:", Array.from(packet).slice(0, 8).map(b => b.toString(16).padStart(2,'0')).join(' ') + "...");

const decoded = decodePacket(packet);
console.log("  Decoded:", decoded);

📝 KEY POINTS:
✅ ArrayBuffer is raw memory — you must create a view (TypedArray or DataView) to use it
✅ Multiple typed array views can share the same ArrayBuffer — changes are visible to all
✅ Uint8ClampedArray clamps out-of-range values (0-255) — useful for pixel data
✅ Regular Uint8Array wraps on overflow — 256 becomes 0, 257 becomes 1
✅ DataView provides flexible byte-level access with explicit endianness control
✅ Typed arrays are dense, fixed-type, fixed-length — faster than regular arrays for math
✅ TextEncoder/TextDecoder convert between strings and Uint8Array
✅ SharedArrayBuffer allows sharing memory between Web Workers (with Atomics for sync)
❌ Typed arrays don't support push/pop/shift/unshift — fixed length
❌ array.filter() on a typed array returns a regular Array (not a typed array)
❌ Don't use regular arrays for binary data — typed arrays are far more efficient
❌ Endianness matters when sharing binary data between different systems
""",
  quiz: [
    Quiz(question: 'What is an ArrayBuffer and how is it used?', options: [
      QuizOption(text: 'A fixed block of raw memory with no inherent structure — you access it through typed array views like Uint8Array or Int32Array', correct: true),
      QuizOption(text: 'A special array that automatically resizes as you add elements', correct: false),
      QuizOption(text: 'A buffer that holds JavaScript objects in a compact binary format', correct: false),
      QuizOption(text: 'An array that stores ArrayBuffer objects as its elements', correct: false),
    ]),
    Quiz(question: 'What is the difference between Uint8Array and Uint8ClampedArray?', options: [
      QuizOption(text: 'Uint8Array wraps on overflow (256→0); Uint8ClampedArray clamps to the range 0-255 (256→255, -1→0)', correct: true),
      QuizOption(text: 'Uint8ClampedArray is read-only; Uint8Array allows writes', correct: false),
      QuizOption(text: 'Uint8Array is for raw binary; Uint8ClampedArray is only for canvas pixel data', correct: false),
      QuizOption(text: 'Uint8ClampedArray is twice as large — it stores both the value and its clamped version', correct: false),
    ]),
    Quiz(question: 'What does DataView provide that TypedArrays do not?', options: [
      QuizOption(text: 'Flexible access to read/write different types at any byte offset with explicit endianness control', correct: true),
      QuizOption(text: 'Better performance for large arrays due to hardware-level optimization', correct: false),
      QuizOption(text: 'The ability to resize the underlying ArrayBuffer dynamically', correct: false),
      QuizOption(text: 'Support for JavaScript objects and strings as binary data', correct: false),
    ]),
  ],
);

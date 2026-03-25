import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson33 = Lesson(
  language: 'JavaScript',
  title: 'DOM Manipulation',
  content: """
🎯 METAPHOR:
The DOM (Document Object Model) is like a live family
tree of your HTML page. Every HTML element is a node
in the tree — the <html> root has children (<head>,
<body>), which have their own children (<div>, <p>,
<button>), and so on. JavaScript can reach any node
in this tree, read it, change it, add new branches,
or prune old ones. And unlike a printed family tree,
the DOM is LIVE — every change you make appears in the
browser instantly. document.querySelector() is the
search function that finds any node. innerHTML/textContent
is the text editor. classList is the wardrobe manager.
appendChild/removeChild are the tree surgeons.

📖 EXPLANATION:
The DOM API lets JavaScript interact with HTML documents
in the browser. It's the bridge between JS and the page.

─────────────────────────────────────
SELECTING ELEMENTS:
─────────────────────────────────────
  // Modern (preferred):
  document.querySelector('.class')     → first match
  document.querySelector('#id')        → by id
  document.querySelector('div > p')    → CSS selector
  document.querySelectorAll('.items')  → NodeList of ALL

  // Classic (still used):
  document.getElementById('myId')
  document.getElementsByClassName('btn')  // live HTMLCollection
  document.getElementsByTagName('div')    // live HTMLCollection
  document.getElementsByName('username')  // by name attribute

  // Relative selection (from an element):
  el.querySelector('.child')
  el.closest('.parent')         // walk up the DOM
  el.parentElement              // direct parent
  el.children                   // child elements
  el.childNodes                 // all child nodes (incl. text)
  el.firstElementChild          // first child element
  el.lastElementChild           // last child element
  el.nextElementSibling         // next sibling element
  el.previousElementSibling

─────────────────────────────────────
READING AND WRITING CONTENT:
─────────────────────────────────────
  el.textContent   → text only (safe, no HTML parsing)
  el.innerHTML     → HTML string (parse and render HTML)
  el.innerText     → visible text (layout-aware)
  el.value         → input/textarea/select value
  el.outerHTML     → element itself + contents as string

  // Safe vs unsafe:
  el.textContent = userInput;   // ✅ safe — no XSS
  el.innerHTML   = userInput;   // ❌ XSS risk!

─────────────────────────────────────
ATTRIBUTES:
─────────────────────────────────────
  el.getAttribute('href')        // get any attribute
  el.setAttribute('href', url)   // set any attribute
  el.removeAttribute('disabled') // remove attribute
  el.hasAttribute('disabled')    // check existence
  el.toggleAttribute('disabled') // toggle on/off

  // Common shorthand properties:
  el.id, el.className, el.src, el.href, el.value
  el.disabled, el.checked, el.type, el.name

  // Dataset (data-* attributes):
  <div data-user-id="42" data-role="admin">
  el.dataset.userId  // "42"  (camelCase)
  el.dataset.role    // "admin"

─────────────────────────────────────
CLASSES:
─────────────────────────────────────
  el.classList.add('active')
  el.classList.remove('hidden')
  el.classList.toggle('open')
  el.classList.contains('active')  // boolean
  el.classList.replace('old', 'new')
  el.classList.item(0)             // first class name
  [...el.classList]                // array of class names

─────────────────────────────────────
STYLES:
─────────────────────────────────────
  el.style.color       = 'red';
  el.style.fontSize    = '16px';
  el.style.cssText     = 'color: red; font-size: 16px;';

  // Computed (actual rendered) styles:
  getComputedStyle(el).color
  getComputedStyle(el).getPropertyValue('font-size')

  // CSS Custom Properties:
  el.style.setProperty('--color', 'blue');
  getComputedStyle(el).getPropertyValue('--color');

─────────────────────────────────────
CREATING AND INSERTING ELEMENTS:
─────────────────────────────────────
  const div = document.createElement('div');
  div.className = 'card';
  div.textContent = 'Hello';

  // Inserting:
  parent.appendChild(child)          // append at end
  parent.prepend(child)              // insert at start
  parent.insertBefore(new, before)   // before a sibling
  el.before(node)                    // before this el
  el.after(node)                     // after this el
  el.replaceWith(node)               // replace this el

  // Template literal approach:
  container.insertAdjacentHTML('beforeend', \`
      <div class="card">
          <h3>${
title}</h3>
          <p>${
safe(description)}</p>
      </div>
  \`);
  // Positions: 'beforebegin', 'afterbegin', 'beforeend', 'afterend'

─────────────────────────────────────
REMOVING ELEMENTS:
─────────────────────────────────────
  el.remove()                        // remove from DOM
  parent.removeChild(child)          // remove specific child
  parent.replaceChild(new, old)      // replace a child
  parent.innerHTML = ''              // remove all children
  el.replaceChildren()               // modern: remove all

─────────────────────────────────────
MEASURING ELEMENTS:
─────────────────────────────────────
  el.getBoundingClientRect()  → { top, left, width, height, ... }
  el.offsetWidth, el.offsetHeight    // with padding
  el.clientWidth, el.clientHeight    // inner size
  el.scrollTop, el.scrollLeft        // scroll position
  el.scrollHeight, el.scrollWidth    // full content size

💻 CODE:
// DOM lessons run in a browser. Here we simulate the core
// patterns showing exactly what each API call does.

// ─── DOCUMENT STRUCTURE (simulated) ──────────────────
class FakeElement {
    constructor(tag, attrs = {}, children = []) {
        this.tagName    = tag.toUpperCase();
        this.id         = attrs.id || '';
        this.className  = attrs.className || '';
        this.textContent = attrs.textContent || '';
        this.dataset    = attrs.dataset || {};
        this.children   = [...children];
        this.style      = {};
        this._classList = new Set((this.className || '').split(' ').filter(Boolean));
        this.attributes = { ...attrs };
        this.classList  = {
            add:      (...c) => { c.forEach(cl => this._classList.add(cl)); this.className = [...this._classList].join(' '); },
            remove:   (...c) => { c.forEach(cl => this._classList.delete(cl)); this.className = [...this._classList].join(' '); },
            toggle:   (c)    => { this._classList.has(c) ? this._classList.delete(c) : this._classList.add(c); this.className = [...this._classList].join(' '); },
            contains: (c)    => this._classList.has(c),
            toString: ()     => [...this._classList].join(' '),
        };
    }

    querySelector(selector) {
        const cls = selector.startsWith('.') ? selector.slice(1) : null;
        const id  = selector.startsWith('#') ? selector.slice(1) : null;
        for (const child of this.children) {
            if (cls && child.className.split(' ').includes(cls)) return child;
            if (id  && child.id === id) return child;
            const found = child.querySelector?.(selector);
            if (found) return found;
        }
        return null;
    }

    appendChild(child) { this.children.push(child); return child; }
    removeChild(child) { this.children = this.children.filter(c => c !== child); return child; }
    prepend(child)     { this.children.unshift(child); return child; }
    remove()           { /* in real DOM: removes from parent */ }

    getAttribute(name) { return this.attributes[name]; }
    setAttribute(name, val) { this.attributes[name] = val; if (name === 'id') this.id = val; }
    hasAttribute(name) { return name in this.attributes; }

    toString() {
        const attrs  = this.id ? \` id="${
this.id}"\` : '';
        const cls    = this.className ? \` class="${
this.className}"\` : '';
        const childStr = this.children.map(c => c.toString()).join('');
        const content  = childStr || this.textContent;
        return \`<${
this.tagName.toLowerCase()}${
attrs}${
cls}>${
content}</${
this.tagName.toLowerCase()}>\`;
    }
}

function el(tag, attrs, ...children) {
    return new FakeElement(tag, attrs, children);
}

// ─── ELEMENT CREATION ─────────────────────────────────
console.log("=== Creating Elements ===");

const card = el('div', { className: 'card', dataset: { id: '42', type: 'user' } },
    el('h2', { textContent: 'Alice Chen' }),
    el('p',  { textContent: 'Software Engineer', className: 'subtitle' }),
    el('span', { textContent: '⭐⭐⭐⭐⭐', className: 'rating' })
);

console.log("  Card structure:");
console.log(" ", card.toString());

// ─── CLASS MANIPULATION ───────────────────────────────
console.log("\n=== classList Manipulation ===");

const btn = el('button', { className: 'btn', textContent: 'Click me' });
console.log("  Initial classes:", btn.className);

btn.classList.add('primary', 'large');
console.log("  After add('primary', 'large'):", btn.className);

btn.classList.remove('large');
console.log("  After remove('large'):", btn.className);

btn.classList.toggle('active');
console.log("  After toggle('active'):", btn.className);

btn.classList.toggle('active');
console.log("  After toggle('active') again:", btn.className);

console.log("  contains('primary'):", btn.classList.contains('primary'));
console.log("  contains('danger'):", btn.classList.contains('danger'));

// ─── ATTRIBUTE ACCESS ─────────────────────────────────
console.log("\n=== Attributes ===");

const link = el('a', { href: 'https://example.com', id: 'main-link', textContent: 'Visit' });
console.log("  getAttribute('href'):", link.getAttribute('href'));
console.log("  hasAttribute('target'):", link.hasAttribute('target'));
link.setAttribute('target', '_blank');
link.setAttribute('rel', 'noopener noreferrer');
console.log("  After setAttribute('target'):", link.getAttribute('target'));
console.log("  Link html:", link.toString());

// data-* attributes:
const userCard = el('div', { dataset: { userId: '42', role: 'admin', active: 'true' } });
console.log("  dataset.userId:", userCard.dataset.userId);
console.log("  dataset.role:", userCard.dataset.role);
console.log("  dataset.active:", userCard.dataset.active);

// ─── DOM TRAVERSAL SIMULATION ─────────────────────────
console.log("\n=== DOM Traversal ===");

const list = el('ul', { className: 'user-list' },
    el('li', { className: 'user-item', id: 'user-1', textContent: 'Alice' }),
    el('li', { className: 'user-item active', id: 'user-2', textContent: 'Bob' }),
    el('li', { className: 'user-item', id: 'user-3', textContent: 'Carol' }),
);

console.log("  Children count:", list.children.length);
console.log("  First child:", list.children[0]?.textContent);
console.log("  Last child:", list.children[list.children.length - 1]?.textContent);
console.log("  Query .active:", list.querySelector('.active')?.textContent);
console.log("  Query #user-3:", list.querySelector('#user-3')?.textContent);

// ─── BUILDING A COMPONENT ─────────────────────────────
console.log("\n=== Building Components ===");

function createUserCard(user) {
    const card = el('div', { className: 'user-card', dataset: { userId: String(user.id) } });

    const header = el('div', { className: 'card-header' },
        el('h3', { textContent: user.name }),
        el('span', { className: \`badge ${
user.role}\`, textContent: user.role })
    );

    const body = el('div', { className: 'card-body' },
        el('p', { textContent: user.email }),
        el('p', { textContent: \`${
user.posts} posts\` })
    );

    const footer = el('div', { className: 'card-footer' },
        el('button', { className: 'btn btn-primary', textContent: 'Follow' }),
        el('button', { className: 'btn btn-secondary', textContent: 'Message' })
    );

    card.appendChild(header);
    card.appendChild(body);
    card.appendChild(footer);
    return card;
}

const users = [
    { id: 1, name: 'Alice Chen', email: 'alice@example.com', role: 'admin', posts: 42 },
    { id: 2, name: 'Bob Smith',  email: 'bob@example.com',  role: 'user',  posts: 8  },
];

users.forEach(user => {
    const card = createUserCard(user);
    console.log(\`  Card for ${
user.name}:\`);
    console.log("   ", card.toString().slice(0, 120) + "...");
    console.log("   Children:", card.children.length);
    console.log("   Header text:", card.querySelector('.card-header')?.children[0]?.textContent);
});

// ─── REAL DOM REFERENCE ───────────────────────────────
console.log("\n=== Real DOM Quick Reference ===");

const domRef = [
    ["Select one",    "document.querySelector('.card')"],
    ["Select all",    "document.querySelectorAll('.card')"],
    ["By ID",         "document.getElementById('main')"],
    ["Create el",     "document.createElement('div')"],
    ["Set text",      "el.textContent = 'Hello'"],
    ["Set HTML",      "el.innerHTML = '<b>Bold</b>'"],
    ["Add class",     "el.classList.add('active')"],
    ["Remove class",  "el.classList.remove('hidden')"],
    ["Toggle class",  "el.classList.toggle('open')"],
    ["Get attr",      "el.getAttribute('data-id')"],
    ["Set attr",      "el.setAttribute('disabled', '')"],
    ["Set style",     "el.style.display = 'none'"],
    ["Append child",  "parent.appendChild(child)"],
    ["Remove el",     "el.remove()"],
    ["Insert HTML",   "el.insertAdjacentHTML('beforeend', html)"],
    ["Get size",      "el.getBoundingClientRect()"],
    ["Scroll to",     "el.scrollIntoView({ behavior: 'smooth' })"],
];

domRef.forEach(([desc, code]) => {
    console.log(\`  ${
desc.padEnd(15)}: ${
code}\`);
});

📝 KEY POINTS:
✅ querySelector() and querySelectorAll() accept any CSS selector — most versatile
✅ Use textContent for setting text safely — never innerHTML with user-provided data (XSS!)
✅ classList.add/remove/toggle/contains — the right way to manage CSS classes
✅ dataset provides clean access to data-* attributes (data-user-id → el.dataset.userId)
✅ insertAdjacentHTML() is faster than innerHTML reassignment for adding content
✅ el.remove() removes the element from the DOM directly — no need for parent.removeChild()
✅ getBoundingClientRect() gives exact element position and size in the viewport
✅ querySelectorAll() returns a static NodeList — getElementsBy* returns a live HTMLCollection
✅ el.closest('.parent') walks UP the DOM tree to find the nearest matching ancestor
❌ Never use innerHTML with untrusted user input — it creates XSS vulnerabilities
❌ getElementsByClassName/TagName return live collections — can cause infinite loops if mutating
❌ Don't use document.write() — it overwrites the entire document if called after page load
❌ Heavy DOM manipulation in loops is slow — batch changes or use DocumentFragment
""",
  quiz: [
    Quiz(question: 'Why is el.textContent safer than el.innerHTML for displaying user data?', options: [
      QuizOption(text: 'textContent treats everything as plain text — no HTML parsing, preventing XSS attacks from malicious scripts', correct: true),
      QuizOption(text: 'textContent is automatically sanitized by the browser before rendering', correct: false),
      QuizOption(text: 'innerHTML only works for static strings, not dynamic user data', correct: false),
      QuizOption(text: 'textContent is faster — innerHTML triggers a full page reflow', correct: false),
    ]),
    Quiz(question: 'What does document.querySelectorAll() return?', options: [
      QuizOption(text: 'A static NodeList of all matching elements — it doesn\'t update when the DOM changes', correct: true),
      QuizOption(text: 'A live HTMLCollection that automatically updates when elements are added or removed', correct: false),
      QuizOption(text: 'An array of matching elements that you can use all Array methods on directly', correct: false),
      QuizOption(text: 'A single Element — the first match in document order', correct: false),
    ]),
    Quiz(question: 'What does el.closest(".container") do?', options: [
      QuizOption(text: 'Walks UP the DOM tree from el, returning the nearest ancestor matching ".container"', correct: true),
      QuizOption(text: 'Finds the nearest descendant of el that matches ".container"', correct: false),
      QuizOption(text: 'Returns the sibling element closest to el with class "container"', correct: false),
      QuizOption(text: 'Finds the element geometrically closest to el on the page', correct: false),
    ]),
  ],
);

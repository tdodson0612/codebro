import '../../models/lesson.dart';
import '../../models/quiz.dart';

final jsLesson34 = Lesson(
  language: 'JavaScript',
  title: 'Events and Event Handling',
  content: """
🎯 METAPHOR:
Events are like a building's alarm system. The alarm
doesn't do anything until something TRIGGERS it — a
fire, a door opening, a motion sensor activating.
Buttons, keyboard presses, mouse movements, network
responses — these are all triggers. Event listeners
are the guards stationed at each sensor: "when THIS
alarm goes off, do THIS." Event bubbling is the
spreading alarm: a fire on floor 3 doesn't just ring
floor 3's alarm — it also rings floors 4, 5, 6 all
the way to the roof (parent elements). Event delegation
is having ONE guard at the building entrance who handles
ALL floors' fire alarms — much more efficient than a
guard per floor when you have hundreds of floors.

📖 EXPLANATION:
Events are signals fired when something happens in the
browser — clicks, key presses, form submissions, etc.

─────────────────────────────────────
ADDING EVENT LISTENERS:
─────────────────────────────────────
  // Modern (preferred):
  element.addEventListener('click', handler);
  element.addEventListener('click', handler, { once: true });
  element.addEventListener('click', handler, { capture: true });
  element.addEventListener('click', handler, { passive: true });

  // Remove:
  element.removeEventListener('click', handler);
  // MUST be the same function reference!

  // Old way (avoid):
  element.onclick = handler;           // replaces any existing
  <button onclick="handler()">         // HTML attribute — avoid

─────────────────────────────────────
THE EVENT OBJECT:
─────────────────────────────────────
  Common properties (all events):
  event.type           → 'click', 'keydown', etc.
  event.target         → element that triggered the event
  event.currentTarget  → element the listener is on
  event.bubbles        → true if event bubbles
  event.cancelable     → true if can be prevented
  event.timeStamp      → when event was created

  Mouse events:
  event.clientX/Y      → position relative to viewport
  event.pageX/Y        → position relative to page
  event.offsetX/Y      → position relative to element
  event.button         → 0=left, 1=middle, 2=right
  event.buttons        → bitmask of pressed buttons
  event.ctrlKey        → true if Ctrl held
  event.shiftKey       → true if Shift held
  event.altKey         → true if Alt/Option held
  event.metaKey        → true if Cmd/Win held

  Keyboard events:
  event.key            → 'Enter', 'a', 'ArrowUp', etc.
  event.code           → 'KeyA', 'Enter', physical key
  event.keyCode        → (deprecated) numeric code
  event.repeat         → true if key held down

  Form events:
  event.target.value   → input value on 'input'/'change'

─────────────────────────────────────
STOPPING EVENTS:
─────────────────────────────────────
  event.preventDefault()   → stop default browser action
    // Stops: form submit, link navigation, right-click menu

  event.stopPropagation()  → stop bubbling UP
    // Parent elements won't receive this event

  event.stopImmediatePropagation()  → stop bubbling AND
    // other listeners on THIS element

─────────────────────────────────────
EVENT BUBBLING AND CAPTURING:
─────────────────────────────────────
  Bubbling (default): target → parent → ... → document
  Capturing:          document → ... → parent → target

  // Listen during capture phase:
  el.addEventListener('click', handler, { capture: true });
  // or: el.addEventListener('click', handler, true);

  // Most events bubble. Some don't:
  // focus, blur — don't bubble (use focusin/focusout)
  // mouseenter, mouseleave — don't bubble (vs. mouseover)
  // load, error — don't bubble

─────────────────────────────────────
EVENT DELEGATION:
─────────────────────────────────────
  Instead of adding listeners to N children, add ONE
  to the parent and check event.target:

  // ❌ N listeners:
  items.forEach(item => item.addEventListener('click', handler));

  // ✅ 1 listener (delegation):
  container.addEventListener('click', (e) => {
      const item = e.target.closest('.item');
      if (!item) return;   // click wasn't on an item
      handleItem(item);
  });

  Benefits:
  → Works for dynamically added elements
  → Fewer event listeners = better memory
  → Cleaner code

─────────────────────────────────────
CUSTOM EVENTS:
─────────────────────────────────────
  // Create:
  const event = new CustomEvent('user:login', {
      bubbles: true,
      cancelable: true,
      detail: { userId: 42, username: 'alice' }
  });

  // Dispatch:
  element.dispatchEvent(event);

  // Listen:
  document.addEventListener('user:login', (e) => {
      console.log(e.detail.username);
  });

─────────────────────────────────────
COMMON EVENT TYPES:
─────────────────────────────────────
  Mouse:    click, dblclick, mousedown, mouseup
            mousemove, mouseenter, mouseleave
            mouseover, mouseout, contextmenu, wheel

  Keyboard: keydown, keyup, keypress (deprecated)

  Form:     submit, input, change, focus, blur
            focusin, focusout, reset, invalid

  Window:   load, DOMContentLoaded, resize, scroll
            beforeunload, unload, online, offline

  Media:    play, pause, ended, timeupdate, volumechange

  Drag:     dragstart, drag, dragend, dragenter
            dragover, dragleave, drop

  Touch:    touchstart, touchmove, touchend, touchcancel

  Pointer:  pointerdown, pointerup, pointermove

💻 CODE:
// ─── EVENT SYSTEM SIMULATION ──────────────────────────
// Browser-only APIs simulated for this lesson

class EventEmitter {
    #listeners = new Map();

    addEventListener(type, handler, options = {}) {
        if (!this.#listeners.has(type)) this.#listeners.set(type, []);
        this.#listeners.get(type).push({ handler, options });
        return () => this.removeEventListener(type, handler); // cleanup fn
    }

    removeEventListener(type, handler) {
        if (!this.#listeners.has(type)) return;
        this.#listeners.set(type,
            this.#listeners.get(type).filter(l => l.handler !== handler)
        );
    }

    dispatchEvent(event) {
        event.currentTarget = this;
        const listeners = this.#listeners.get(event.type) || [];
        for (const { handler, options } of [...listeners]) {
            handler.call(this, event);
            if (options.once) this.removeEventListener(event.type, handler);
        }
        return !event.defaultPrevented;
    }
}

class FakeEvent {
    constructor(type, init = {}) {
        this.type             = type;
        this.bubbles          = init.bubbles ?? false;
        this.cancelable       = init.cancelable ?? false;
        this.detail           = init.detail ?? null;
        this.target           = null;
        this.currentTarget    = null;
        this.defaultPrevented = false;
        this.propagationStopped = false;
        this.timeStamp        = Date.now();
    }
    preventDefault()          { if (this.cancelable) this.defaultPrevented = true; }
    stopPropagation()         { this.propagationStopped = true; }
}

// ─── BASIC EVENT LISTENING ────────────────────────────
console.log("=== Basic Event Listening ===");

const button = new EventEmitter();

// Add multiple listeners:
button.addEventListener('click', (e) => {
    console.log(\`  click listener 1: type=\${e.type}\`);
});
button.addEventListener('click', (e) => {
    console.log(\`  click listener 2: target=\${e.currentTarget?.constructor?.name}\`);
});

const clickEvent = new FakeEvent('click', { cancelable: true });
button.dispatchEvent(clickEvent);

// ─── ONCE OPTION ──────────────────────────────────────
console.log("\n=== once: true Option ===");

const modal = new EventEmitter();
let openCount = 0;

modal.addEventListener('open', () => {
    openCount++;
    console.log(\`  Modal opened (count: \${openCount})\`);
}, { once: true });

modal.dispatchEvent(new FakeEvent('open'));  // fires
modal.dispatchEvent(new FakeEvent('open'));  // doesn't fire again
console.log("  Only fired once despite 2 dispatches:", openCount === 1);

// ─── REMOVING LISTENERS ───────────────────────────────
console.log("\n=== Removing Event Listeners ===");

const input = new EventEmitter();
let changeCount = 0;

const onChange = () => { changeCount++; console.log(\`  Change #\${changeCount}\`); };
input.addEventListener('change', onChange);

input.dispatchEvent(new FakeEvent('change'));  // fires
input.dispatchEvent(new FakeEvent('change'));  // fires
input.removeEventListener('change', onChange);
input.dispatchEvent(new FakeEvent('change'));  // doesn't fire

console.log("  Only 2 changes despite 3 dispatches:", changeCount === 2);

// ─── CUSTOM EVENTS ────────────────────────────────────
console.log("\n=== Custom Events ===");

const app = new EventEmitter();

// Auth system using custom events:
function AuthService(eventBus) {
    return {
        login(username, password) {
            if (password === 'correct') {
                eventBus.dispatchEvent(new FakeEvent('auth:login', {
                    bubbles: true,
                    detail: { username, userId: 42, timestamp: Date.now() }
                }));
                return true;
            }
            eventBus.dispatchEvent(new FakeEvent('auth:error', {
                detail: { message: 'Invalid credentials', username }
            }));
            return false;
        },
        logout() {
            eventBus.dispatchEvent(new FakeEvent('auth:logout', {
                detail: { timestamp: Date.now() }
            }));
        }
    };
}

// Listen to events:
app.addEventListener('auth:login', (e) => {
    console.log(\`  ✅ User logged in: \${e.detail.username} (ID: \${e.detail.userId})\`);
});
app.addEventListener('auth:error', (e) => {
    console.log(\`  ❌ Auth error for '\${e.detail.username}': \${e.detail.message}\`);
});
app.addEventListener('auth:logout', (e) => {
    console.log(\`  👋 User logged out at \${new Date(e.detail.timestamp).toISOString()}\`);
});

const auth = AuthService(app);
auth.login('alice', 'wrong');
auth.login('alice', 'correct');
auth.logout();

// ─── EVENT DELEGATION ─────────────────────────────────
console.log("\n=== Event Delegation ===");

class FakeList extends EventEmitter {
    constructor() {
        super();
        this.items = [];
    }

    addItem(id, label) {
        this.items.push({ id, label });
        console.log(\`  Added item: \${label} (id=\${id})\`);
    }

    simulateItemClick(id) {
        const item = this.items.find(i => i.id === id);
        if (!item) return;
        // Simulate a click on a list item bubbling up to the list
        const e = new FakeEvent('click', { bubbles: true });
        e.target = item;   // target is the item
        e.dataset = { itemId: id };
        this.dispatchEvent(e);
    }
}

const todoList = new FakeList();

// ONE listener on the container handles all items:
todoList.addEventListener('click', (e) => {
    if (!e.target?.id) return;
    console.log(\`  Delegated click on item: "\${e.target.label}" (id=\${e.target.id})\`);
});

todoList.addItem('t1', 'Buy groceries');
todoList.addItem('t2', 'Write tests');
todoList.addItem('t3', 'Go for a run');

todoList.simulateItemClick('t1');
todoList.simulateItemClick('t3');

// ─── PREVENT DEFAULT ──────────────────────────────────
console.log("\n=== preventDefault() ===");

const form = new EventEmitter();

form.addEventListener('submit', (e) => {
    const isValid = true;  // validation check
    if (!isValid) {
        e.preventDefault();
        console.log("  Form submission prevented — invalid data");
    } else {
        console.log("  Form submitted (default allowed)");
    }
});

const submitEvent = new FakeEvent('submit', { cancelable: true });
form.dispatchEvent(submitEvent);
console.log("  Default prevented:", submitEvent.defaultPrevented);

// ─── KEYBOARD EVENT SIMULATION ────────────────────────
console.log("\n=== Keyboard Events ===");

function simulateKeyboard() {
    const shortcuts = new Map([
        ['s+ctrl',    () => console.log("  💾 Save triggered (Ctrl+S)")],
        ['z+ctrl',    () => console.log("  ↩️  Undo triggered (Ctrl+Z)")],
        ['f+ctrl',    () => console.log("  🔍 Find triggered (Ctrl+F)")],
        ['Escape',    () => console.log("  ❌ Escape — close dialog")],
        ['Enter',     () => console.log("  ✅ Enter — confirm")],
    ]);

    function handleKey(key, ctrlKey = false) {
        const combo = ctrlKey ? \`\${key}+ctrl\` : key;
        const action = shortcuts.get(combo);
        if (action) action();
        else console.log(\`  Key: '\${key}' \${ctrlKey ? '(+Ctrl)' : ''}\`);
    }

    // Simulate keypresses:
    handleKey('s', true);
    handleKey('z', true);
    handleKey('Escape');
    handleKey('a');
}
simulateKeyboard();

📝 KEY POINTS:
✅ addEventListener() is the modern way — can add multiple listeners, supports options
✅ event.target is where the event originated; event.currentTarget is where the listener is
✅ Event delegation: one listener on a parent handles all child events using event.target
✅ { once: true } removes the listener automatically after first call
✅ { passive: true } on scroll/touch events tells browser you won't call preventDefault()
✅ removeEventListener() requires the SAME function reference — store handlers in variables
✅ Custom events with CustomEvent and detail property decouple components cleanly
✅ event.preventDefault() stops default browser behavior (form submit, link navigation)
✅ event.stopPropagation() prevents the event from bubbling up to parent elements
❌ Never use inline HTML event attributes (onclick="...") — they're hard to maintain and test
❌ Don't use anonymous functions with removeEventListener — you can't reference them to remove
❌ focus and blur don't bubble — use focusin and focusout instead for delegation
❌ Passive event listeners cannot call preventDefault() — throws a warning in Chrome
""",
  quiz: [
    Quiz(question: 'What is event delegation and why is it useful?', options: [
      QuizOption(text: 'Adding one listener to a parent element that handles events from all children — works for dynamic elements and uses less memory', correct: true),
      QuizOption(text: 'Delegating event handling to a Web Worker to avoid blocking the main thread', correct: false),
      QuizOption(text: 'Using custom events to communicate between components instead of direct function calls', correct: false),
      QuizOption(text: 'Allowing browser default behavior to handle events without custom listeners', correct: false),
    ]),
    Quiz(question: 'What is the difference between event.target and event.currentTarget?', options: [
      QuizOption(text: 'target is the element that triggered the event; currentTarget is the element the listener is attached to', correct: true),
      QuizOption(text: 'target is the parent element; currentTarget is the child that was clicked', correct: false),
      QuizOption(text: 'They are the same when bubbling is stopped; different during capturing', correct: false),
      QuizOption(text: 'currentTarget is set by the browser; target is set by dispatchEvent()', correct: false),
    ]),
    Quiz(question: 'Why must you store event handler functions in variables to remove them later?', options: [
      QuizOption(text: 'removeEventListener() requires the exact same function reference — anonymous functions create new references each time', correct: true),
      QuizOption(text: 'Arrow functions cannot be removed — only regular function declarations can be', correct: false),
      QuizOption(text: 'removeEventListener() searches by function name — anonymous functions have no name to match', correct: false),
      QuizOption(text: 'Variables let the garbage collector track handlers; otherwise they are automatically removed', correct: false),
    ]),
  ],
);

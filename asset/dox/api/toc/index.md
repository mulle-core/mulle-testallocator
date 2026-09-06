# mulle-testallocator Library Documentation for AI
<!-- Keywords: allocator, leak, free, trace, test, malloc, memory -->
## 1. Introduction & Purpose

- mulle-testallocator is a drop-in replacement allocator for C programs that detects memory leaks, double frees, false frees and false reallocs during tests (and at runtime). It implements the `struct mulle_allocator` interface defined by `mulle-allocator`.
- Solves: automated leak/double-free detection without code changes. Just link the library (with whole-archive / `all-load` semantics) and run the program with the `MULLE_TESTALLOCATOR` environment variable; a C constructor patches the default allocators and an atexit handler reports leaks on exit.
- Key features: manual initialize/reset/cancel lifecycle, leak detection toggles, configurable trace levels, allocation size capping (out-of-memory simulation), stdlib `realloc` scribbling, and fail-fast bailing on erroneous frees.
- Relationship: a foundational testing component of the `mulle-core` ecosystem. It builds upon `mulle-allocator` and uses `mulle-thread`, `mulle-atinit`, `mulle-atexit` and `mulle-stacktrace`.

## 2. Key Concepts & Design Philosophy

- The core object is a global `struct mulle_allocator` instance named `mulle_testallocator`. All its operations are wrapped: allocations are recorded into an internal open-addressing pointer set, frees into another. Because it conforms to the standard allocator interface, it can be swapped in via `mulle_default_allocator = mulle_testallocator;`.
- Fail-fast on errors: on a double free, false free or false realloc, the library prints a message to `stderr` and calls the configured "bail" vector (by default `abort()`). This stops the program at the exact offending operation, which is much easier to debug than continuing with corrupted memory.
- Leak detection is opt-in and scoped: `mulle_testallocator_reset()` checks for leaks among currently tracked allocations, prints `### leak <address>` lines to `stderr`, then clears the tracking state, acting as a checkpoint between tests.
- Automatic activation: `mulle_testallocator_initialize()` registers a high-priority `mulle_atinit` initializer. That initializer reads environment variables, patches `mulle_allocator_default`, `mulle_allocator_stdlib` and `mulle_allocator_stdlib_nofree`, and registers an atexit handler (`_mulle_atexit`) that runs the leak check at program exit.
- Scribbling: newly allocated memory through the allocator is filled with `0xF3A7F3A7`, and the stdlib `realloc` wrapper fills fresh stdlib allocations with `0xCAF3CAF3`, helping to expose use of uninitialized data. Both behaviors can be disabled via config/env.
- Inlined helper containers (`pointerarray.h`, `pointerset.h`, root `blockset.h`) are plain C, all-inlined utilities used for the test allocator's bookkeeping; they can be reused in tests.

## 3. Core API & Data Structures

All signatures copied verbatim from the header files.

### 3.1. src/mulle-testallocator.h

#### Global instances

```c
MULLE__TESTALLOCATOR_GLOBAL struct _mulle_testallocator_config   mulle_testallocator_config;
MULLE__TESTALLOCATOR_GLOBAL struct mulle_allocator               mulle_testallocator;
```

- `mulle_testallocator`: the global `struct mulle_allocator` instance implementing the tracking allocator. Assign it to `mulle_default_allocator` to route all `mulle_malloc`/`mulle_free` allocations through it.
- `mulle_testallocator_config`: the global configuration struct (see `mulle-testallocator-struct.h`). Modify it (or let env vars do so at init) to change runtime behavior like `dont_free`, `dont_scribble`, `max_size`.

#### Lifecycle Functions

- `void mulle_testallocator_initialize( void);`
  - Registers the internal initializer via `mulle_atinit` at priority 1000000 (name `"**mulle_testallocator**"`). Safe to call more than once. On platforms with constructor support this runs automatically at load time.
- `void mulle_testallocator_reset_detect_leaks( int detect);`
  - If `detect` is non-zero, reports all still-tracked allocations as leaks on `stderr` (and bails unless suppressed), then clears the internal allocation/free sets. If `detect` is zero it just clears the sets. Mutex-protected.
- `static inline void   mulle_testallocator_discard( void)`
  - Shorthand for `mulle_testallocator_reset_detect_leaks( 0)`: start a clean sheet without checking leaks.
- `static inline void   mulle_testallocator_reset( void)`
  - Shorthand for `mulle_testallocator_reset_detect_leaks( 1)`: check leaks, then start a clean sheet.
- `void mulle_testallocator_cancel( void);`
  - Calls `discard()` and sets the trace level to "cancelled" (-2), which disables all further tracking. Call only at end of a test session; reinitialization afterwards is not supported.

#### Configuration & Control

- `void mulle_testallocator_set_tracelevel( unsigned int value);`
  - Sets tracing verbosity. Value `1` traces setup and exit, `2` additionally traces every allocation/deallocation, `4` adds stacktraces. A value of `-1` disables tracing (per header comment).
- `void mulle_testallocator_set_max_size( size_t value);`
  - If `value` is non-zero, any allocation request larger than `value` fails with `ENOMEM` (simulates out-of-memory). `0` turns the limit off.
- `void mulle_testallocator_set_stacktracesymbolizer( void (*f)( void));`
  - Sets a callback that parses/improves the backtrace strings printed when stacktrace tracing is enabled.

#### Unlocked (internal) functions

- `void _mulle_testallocator_reset( void);`
  - Unlocked reset of the internal pointer sets; callers must hold the internal lock. Rarely useful.
- `void _mulle_testallocator_detect_leaks( void);`
  - Unlocked leak check over the allocations set; callers must hold the internal lock.

#### Error Handling

- `void mulle_testallocator_bail( void *p);`
  - Default fatal-error handler: on non-Windows platforms calls `abort()` (on macOS with `MULLE_TESTALLOCATOR_HISTORY` set it first invokes `malloc_history`). It is the default value of `mulle_testallocator_config.bail`. It is also the `abafree` function of the `mulle_testallocator` instance.

#### stdlib Support

- `void *mulle_testallocator_stdlib_realloc( void *q,
                                            size_t size,
                                            struct mulle_allocator *allocator);`
  - A `realloc` wrapper suitable for patching stdlib allocators (e.g. `mulle_stdlib_allocator.realloc`). If the pointer is NULL and scribbling is enabled, the new block is filled with `0xCAF3CAF3`.

#### Testallocator Detection

- `int mulle_allocator_is_testallocator( const struct mulle_allocator *p);`
  - Returns `1` if the given `mulle_allocator` instance is `mulle_testallocator`, `0` otherwise. Returns `0` for NULL input. Compares the `calloc`, `realloc`, `free` and `fail` function pointers against the global instance.

#### Environment Variables

Configured during the automatic initializer run:

| Variable | Effect |
|---|---|
| `MULLE_TESTALLOCATOR` | Activates the test allocator at startup; value is used as trace level (or truthy YES). |
| `MULLE_TESTALLOCATOR_TRACE` | `1`: trace setup/exit. `2`: also trace allocations/deallocations. `3+`: add stacktraces (verbosity grows with value). Non-zero implicitly enables activation. |
| `MULLE_TESTALLOCATOR_DONT_FREE` | If truthy, memory is tracked but never actually freed (can burn memory quickly, makes traces simpler). |
| `MULLE_TESTALLOCATOR_DONT_SCRIBBLE` | If truthy, freed/new memory is not scribbled. |
| `MULLE_TESTALLOCATOR_MAX_SIZE` | If set, allocations larger than this get `ENOMEM`. |
| `MULLE_TESTALLOCATOR_LEAKS` | Leak mode bitmask: `1` = only report the first leak, `2` = do not bail on leaks. |

### 3.2. src/mulle-testallocator-struct.h

```c
struct _mulle_testallocator_config
{
   void     (*bail)( void *q);
   int      _windows;
   int      patch_stdlib_scribble;  // if set, patches stdlib malloc to scribble memory
   int      out_of_memory;
   size_t   max_size;
   int      dont_free;  // use this to avoid reuse of memory areas
   int      dont_scribble;  // use this to avoid reuse of memory areas
};
```

- **Purpose:** configuration and runtime state of the test allocator.
- **Key Fields:**
  - `bail`: the bail vector called on fatal errors (default `mulle_testallocator_bail`); must be first for mulle-objc patching ease.
  - `_windows`: platform flag (set on `_WIN32`).
  - `patch_stdlib_scribble`: if set, patch stdlib malloc to scribble memory.
  - `out_of_memory`: set when an out-of-memory condition (via `max_size`) has been triggered; may then deny further allocations.
  - `max_size`: maximum permitted allocation size (0 = unlimited).
  - `dont_free`: avoid reuse of freed memory areas (doesn't really free).
  - `dont_scribble`: avoid scribbling freed memory areas.

### 3.3. src/pointerarray.h

`struct _pointerarray` — a simple growing array of pointers, all-inlined, used for testing bookkeeping. Can store NULL pointers; the "no element" sentinel is `(void *) -1`.

```c
struct _pointerarray
{
   size_t   count;
   size_t   used;
   size_t   size;
   void     **pointers;
};
```

- Key fields: `count` (number of non-NULL pointers), `used` (number of slots filled), `size` (current capacity), `pointers` (backing array).
- **Lifecycle:**
  - `static inline struct _pointerarray  *_pointerarray_alloc( void *(*calloc)( size_t, size_t))` — allocate the struct via the supplied `calloc`.
  - `static inline void  _pointerarray_done( struct _pointerarray *array, void (*free)( void *))` — free the inner pointer array.
  - `static inline void  _pointerarray_free( struct _pointerarray *array, void (*free)( void *))` — free array then struct.
- **Core Operations:**
  - `static inline int   _pointerarray_add( struct _pointerarray *array, void  *pointer, void *(*realloc)( void *, size_t))` — append a pointer (doubling growth, boosting `count`); returns `-1` and asserts on realloc failure.
  - `static inline void  *_pointerarray_get( struct _pointerarray *array, unsigned int i)` — index lookup, asserts bounds.
  - `static inline unsigned int   _pointerarray_index( struct _pointerarray *array, void *p)` — linear search; returns `(unsigned int) -1` if absent.
  - `static inline void   _pointerarray_set( struct _pointerarray *array, unsigned int i, void *p)` — overwrite slot, maintaining the non-NULL `count`.
  - `static inline size_t  _pointerarray_count_non_null_pointers( struct _pointerarray *array)` — returns `count`.
- **Enumeration:**
  - `static inline struct  _pointerarray_enumerator   _pointerarray_enumerate( struct _pointerarray *array)` — build an enumerator over all used slots.
  - `static inline void   *_pointerarray_enumerator_next( struct _pointerarray_enumerator *rover)` — returns the next pointer, or `(void *) -1` when exhausted.
  - `static inline void  _pointerarray_enumerator_done( struct _pointerarray_enumerator *rover)` — no-op, present for symmetry.
  - `struct _pointerarray_enumerator { void **curr; void **sentinel; };`
- Internal `_pointerarray_grow` doubles capacity.

### 3.4. src/pointerset.h

`struct _pointerset` — an open-addressing, all-inlined hash set for pointers. Cannot store NULL or `(void *) -1`.

```c
struct _pointerset
{
   size_t   count;
   size_t   used;
   size_t   max;
   size_t   mask;
   void     **pointers;
};
```

- Key fields: `count` (active entries), `used` (non-tombstone slots), `max` (load threshold ~ half of capacity), `mask` (capacity - 1), `pointers` (backing array; NULL/`(void *)-1` are empty/tombstone).
- **Lifecycle:**
  - `static inline struct _pointerset  *_pointerset_create( void *(*calloc)( size_t, size_t))`
  - `static inline void  _pointerset_init( struct _pointerset *set)`
  - `static inline void  _pointerset_done( struct _pointerset *set, void (*free)( void *))`
  - `static inline void  _pointerset_free( struct _pointerset *set, void (*free)( void *))`
- **Core Operations:**
  - `static inline void   *_pointerset_sureadd( struct _pointerset *set, void  *pointer)` — insert assuming capacity; returns the pointer, or NULL if already present.
  - `static inline void   *_pointerset_add( struct _pointerset *set, void  *pointer, void *(*calloc)( size_t, size_t), void (*free)( void *))` — insert with possible growth; returns the pointer, NULL if present, `(void *) -1` on growth failure.
  - `static inline void  *_pointerset_get( struct _pointerset *set, void *pointer)` — lookup; returns stored pointer or NULL.
  - `static inline void  _pointerset_remove( struct _pointerset *set, void *pointer)` — tombstones the entry (`(void *) -1`) and decrements `count`.
  - Internal `_pointerset_grow` doubles/re-hashes; usage `avalanche`/`avalanche32`/`avalanche64` (MurmurHash3-style) provide the hash.
- **Enumeration:**
  - `static inline struct  _pointerset_enumerator   _pointerset_enumerate( struct _pointerset *set)` — build an enumerator (handles NULL set/pointers gracefully).
  - `static inline void   *_pointerset_enumerator_next( struct _pointerset_enumerator *rover)` — returns the next live pointer, or NULL when exhausted (skips NULL and tombstone slots).
  - `static inline void  _pointerset_enumerator_done( struct _pointerset_enumerator *rover)` — no-op, present for symmetry.
  - `struct _pointerset_enumerator { void **curr; void **sentinel; };`

### 3.5. blockset.h (repo root, experimental)

`struct _block { void *adr; size_t length; }` and `struct _blockset` implement a growing hash table mapping addresses to lengths (`size_t count, used, max, mask; struct _block *blocks;`), with API mirroring `_pointerset` (`_blockset_create/init/done/free`, `_blockset_add/get/remove/grow`, enumerator, sentinel `noblock`). It is located in the repository root, is **not part of the published `src/` set**, and its header comment marks it "Untested!" and slated for tracking allocation sizes on realloc. Treat it as a work-in-progress.

## 4. Performance Characteristics

- The allocation/free path adds an open-addressing hash lookup (average O(1)) plus a mutex lock/unlock (`mulle_thread_mutex`) around the tracking sets, on top of the underlying `calloc`/`realloc`/`free`. This is a significant constant overhead; it is not suitable for production allocation hot paths, only for tests and debugging.
- `pointerarray`: append amortized O(1) (doubling growth), indexed get O(1), `_pointerarray_index` linear O(n).
- `pointerset`/`blockset`: hash table semantics, average O(1) add/get/remove; degenerate worst case O(n); growth re-hashes in O(n) amortized over inserts.
- Memory: tracking stores one word per live allocation plus allocation doubling slack in the sets; enabling `dont_free`/`dont_scribble` retains or reuses freed memory and can grow memory usage quickly.
- Thread-safety: the tracking operations (`test_calloc`, `test_realloc`, `test_free`) and `mulle_testallocator_reset_detect_leaks` are protected by an internal mutex, so concurrent allocator use on a single initialized instance is safe. Global configuration changes and `initialize` itself are not synchronized; do not reconfigure mid-flight from multiple threads. The inlined helper containers are not thread-safe at all.

## 5. AI Usage Recommendations & Patterns

- **Best Practices:**
  - Always `mulle_testallocator_initialize()` before any allocation goes through the test allocator. If initialization has not run, `may_alloc` asserts.
  - Use the canonical manual pattern: `mulle_testallocator_initialize(); mulle_default_allocator = mulle_testallocator; { ...tests... } mulle_testallocator_reset();`.
  - Bracket test sections with `mulle_testallocator_reset()` to print and clear leaks between tests rather than only at exit.
  - Use `mulle_testallocator_discard()` to zero the tracking sets when a test intentionally leaks.
  - For environment-var driven leak checking, run the binary with `MULLE_TESTALLOCATOR=YES` (no code changes needed); ensure the library is linked ahead of all other code with whole-archive / the `all-load` mark so its constructor isn't dropped.
  - Use `mulle_allocator_is_testallocator()` to verify a given allocator pointer is the test allocator before assuming tracking is active.
  - To detect where a leaked address came from, re-run with `MULLE_TESTALLOCATOR_TRACE=2` (or `3` for stacktraces) and search the trace for the leaked address.
- **Common Pitfalls:**
  - Do not search for `mulle_testallocator_done()`; it does not exist. Teardown is `mulle_testallocator_cancel()`, and only once.
  - Do not rely on the `_`-prefixed functions (`_mulle_testallocator_reset`, `_mulle_testallocator_detect_leaks`): they require the internal lock.
  - `(void *) -1` is a sentinel in both `pointerarray` and `pointerset`; NULL and `(void *) -1` cannot be stored in a `pointerset`.
  - When freeing, use the same allocator the block came from; freeing a pointer never returned by the test allocator triggers a "false free" bail.
  - stdlib `malloc` calls are invisible to the allocator's leak check unless you patch the stdlib realloc (`mulle_stdlib_allocator.realloc = mulle_testallocator_stdlib_realloc;`).
  - `mulle_testallocator_initialize()` relies on `mulle_atinit` + `_mulle_atexit` + a C constructor; without constructor support or the `all-load` link mark, activation silently does not happen.
- **Idiomatic Usage:** Follow the tests in `test/checks/` (`goodfree.c`, `leak.c`, `badfree.c`, `doublefree.c`, `scribble.c`). They all use the manual initialize/swap/reset pattern so they work even when the compiler lacks constructor support.

## 6. Integration Examples

Coding style: 3-space indent, Allman braces, aligned declarations, C89 variable rules, `return( expr);`.

### Example 1: Manual leak and double-free checking with the default allocator

```c
#include <mulle-allocator/mulle-allocator.h>
#include <mulle-testallocator/mulle-testallocator.h>

static void  run_test( void)
{
   void  *p;

   p = mulle_malloc( 1848);
   mulle_free( p);
}

//
// run tests in manual mode, since the compiler might not support constructors
//
int  main( int argc, char *argv[])
{
   mulle_testallocator_initialize();
   mulle_default_allocator = mulle_testallocator;
   {
      run_test();
   }
   mulle_testallocator_reset();
   return( 0);
}
```

A "double free" (freeing `p` twice) or "false free" (freeing a string literal) makes the program print e.g. `###\n### double free: 0x...` and bail (abort). A leaked block prints `### leak 0x...` at `mulle_testallocator_reset()`.

### Example 2: Environment-variable driven leak detection with stdlib scribbling

```c
#include <mulle-allocator/mulle-allocator.h>
#include <mulle-testallocator/mulle-testallocator.h>

int  main( int argc, char *argv[])
{
   void  *p;

   mulle_testallocator_initialize();

   mulle_default_allocator        = mulle_testallocator;
   mulle_stdlib_allocator.realloc = mulle_testallocator_stdlib_realloc;

   p = mulle_allocator_malloc( &mulle_stdlib_allocator, 16);
   mulle_allocator_free( &mulle_stdlib_allocator, p);

   mulle_testallocator_reset();
   return( 0);
}
```

Run with `MULLE_TESTALLOCATOR=YES MULLE_TESTALLOCATOR_TRACE=2 ./executable` to see every alloc/free, and `MULLE_TESTALLOCATOR_TRACE=3` to add stacktraces for leak attribution.

### Example 3: Checking whether an allocator is the test allocator

```c
#include <mulle-allocator/mulle-allocator.h>
#include <mulle-testallocator/mulle-testallocator.h>

int  main( int argc, char *argv[])
{
   int  is_test;

   mulle_testallocator_initialize();
   mulle_default_allocator = mulle_testallocator;

   is_test = mulle_allocator_is_testallocator( &mulle_default_allocator);
   printf( "default allocator is test allocator: %d\n", is_test);

   mulle_testallocator_reset();
   return( 0);
}
```

The function safely returns `0` for NULL input and for any other allocator instance.

## 7. Dependencies

Direct `mulle-sde` dependencies (from `.mulle/etc/sourcetree/config` and `clib.json`):

- `mulle-allocator` (mulle-c) — defines `struct mulle_allocator`, `mulle_allocator_default`, `mulle_stdlib_allocator`
- `mulle-thread` (mulle-concurrent) — mutex and thread-once helpers
- `mulle-atinit` — deterministic initializer registration
- `mulle-atexit` — atexit registration for the leak report
- `mulle-stacktrace` — backtrace capture/formatting for tracing
- `mulle-dlfcn` — dynamic symbol lookup (`mulle_dlsym_exe`) for optional runtime resolution
# mulle-testallocator Library Documentation for AI
<!-- Keywords: allocator, leak, debug, test, malloc, free, tracer -->
## 1. Introduction & Purpose

- mulle-testallocator provides a drop-in test allocator for C programs that detects leaks, double-frees and supports tracing and basic stdlib patching. It exposes a mulle_allocator instance and a configuration struct to control behaviors (bail handler, scribble, max size, dont_free).
- Solves: automated leak/double-free detection during unit tests and controlled allocation behavior for tests.
- Key features: initialize/reset/cancel lifecycle, leak detection toggles, trace levels, max-size capping, stdlib realloc wrapper, and simple inlined helper containers used for bookkeeping.
- Relationship: a testing-support component that integrates with mulle-allocator and the mulle-* ecosystem.

## 2. Key Concepts & Design Philosophy

- Design: a test allocator that can replace the default allocator during tests, track allocations in lightweight inlined structures (pointerarray, pointerset, blockset) and report or bail on bad states.
- Leak detection is opt-in: reset/detect flags control whether allocations are checked.
- Minimal runtime overhead for normal usage; helpers are implemented as inlined headers for easy reuse in tests.
- Not thread-safe by default; designed for single-threaded test harnesses unless external locking is provided.

## 3. Core API & Data Structures

This is the most critical section. It is organized by header files.

### 3.1. src/mulle-testallocator.h

- Globals:
  - MULLE__TESTALLOCATOR_GLOBAL struct _mulle_testallocator_config   mulle_testallocator_config;
  - MULLE__TESTALLOCATOR_GLOBAL struct mulle_allocator               mulle_testallocator;

- Lifecycle:
  - void mulle_testallocator_initialize( void);
    - Initialize internal tables and optionally patch stdlib. Call once before using the allocator in tests.
  - void mulle_testallocator_reset_detect_leaks( int detect);
    - Enable (1) or disable (0) leak detection. Used by reset/discard helpers below.
  - static inline void mulle_testallocator_discard( void)
    - Shorthand to turn leak detection off for the current run.
  - static inline void mulle_testallocator_reset( void)
    - Shorthand to enable leak detection (start clean sheet).
  - void mulle_testallocator_cancel( void);
    - Finalize and free internal state; call at test end if using discard previously.

- Configuration and control:
  - void mulle_testallocator_set_tracelevel( unsigned int value);
    - 0..2 for verbosity; -1 to turn off tracing.
  - void mulle_testallocator_set_max_size( size_t value);
    - Set a maximum allocation size (0 disables).
  - void mulle_testallocator_set_stacktracesymbolizer( void (*f)( void));
    - Provide a function pointer used to enhance backtrace strings.
  - void mulle_testallocator_reset_detect_leaks( int detect);
    - Lower-level control; unlocked functions exist for internal use:
      - void _mulle_testallocator_reset( void);
      - void _mulle_testallocator_detect_leaks( void);

- Error handling:
  - void mulle_testallocator_bail( void *p);
    - Called on fatal allocator errors; default calls configured bail handler.

- Helpers:
  - void *mulle_testallocator_stdlib_realloc( void *q, size_t size, struct mulle_allocator *allocator);
    - Realloc wrapper suitable for intercepting stdlib calls when patching.

Notes:
- The library exposes a global mulle_testallocator which can be assigned to mulle_default_allocator to replace the default allocator for testing (see struct comment in the struct header).

### 3.2. src/mulle-testallocator-struct.h

struct _mulle_testallocator_config
- Purpose: configuration/state for the test allocator.
- Fields:
   - void (*bail)( void *q);     // Bail vector called on fatal error
   - int _windows;              // platform flag
   - int patch_stdlib_scribble; // patch stdlib malloc to scribble
   - int out_of_memory;         // set when OOM detected
   - size_t max_size;           // maximum allocation size
   - int dont_free;             // avoid reuse of freed areas
   - int dont_scribble;         // avoid scribbling freed areas
- Usage: modify mulle_testallocator_config before/after initialize to alter runtime behavior.

### 3.3. src/pointerarray.h

struct _pointerarray
- Purpose: simple growing array of pointers used for bookkeeping in tests.
- Key fields: size_t count (non-null pointers), used, size, void **pointers.
- Lifecycle:
  - _pointerarray_alloc( calloc ) -> allocate structure
  - _pointerarray_done/_pointerarray_free( free ) -> free inner array and struct
- Core ops:
  - _pointerarray_add( array, pointer, realloc ) -> append pointer (allows NULL entries)
  - _pointerarray_get( array, index ) -> fetch pointer
  - _pointerarray_index( array, p ) -> linear search index or -1
  - _pointerarray_set( array, index, p ) -> set with count adjustment
- Inspection:
  - _pointerarray_count_non_null_pointers( array )
- Enumeration:
  - struct _pointerarray_enumerator + _pointerarray_enumerate/_pointerarray_enumerator_next/_done

Complexity: append amortized O(1), get O(1), index O(n).

### 3.4. src/pointerset.h

struct _pointerset
- Purpose: open-addressing hashset for pointers (cannot store NULL or (void *)-1).
- Key fields: count, used, max, mask, void **pointers.
- Lifecycle:
  - _pointerset_create( calloc ) / _pointerset_init / _pointerset_done / _pointerset_free
- Core ops:
  - _pointerset_add/_pointerset_sureadd( set, pointer ) -> insert (returns pointer or NULL if present)
  - _pointerset_get( set, pointer ) -> returns stored pointer or NULL
  - _pointerset_remove( set, pointer ) -> remove entry
  - Internals: _pointerset_grow handles resizing and rehashing
- Enumeration via _pointerset_enumerator

Complexity: average O(1) for add/get/remove; resizing O(n) amortized.

### 3.5. blockset.h

struct _blockset and struct _block
- Purpose: store (address, length) pairs; used to track allocated blocks (helps with realloc/size queries).
- Key fields: struct _block { void *adr; size_t length; } and _blockset has count, used, max, mask, blocks.
- Lifecycle and operations mirror pointerset semantics: create, init, add, get (returns noblock sentinel), remove, grow, enumerate.
- Complexity: same as pointerset (hash table semantics).

## 4. Performance Characteristics

- pointerarray: append amortized O(1), random access O(1), linear search O(n).
- pointerset/blockset: hash-table semantics, average O(1) for add/get/remove; worst-case O(n) if degenerate. Rehashing/growth is O(n) but amortized.
- Memory: tracking structures keep additional metadata and pointer arrays; enabling dont_free/dont_scribble increases memory retention.
- Thread-safety: not thread-safe. External synchronization required for concurrent tests.

## 5. AI Usage Recommendations & Patterns

- Best practices:
  - Always call mulle_testallocator_initialize() before using the allocator in tests.
  - Use mulle_testallocator_reset() at test start to enable leak detection and get a clean state.
  - Call mulle_testallocator_cancel() if you used discard and want to teardown internal resources.
  - Prefer the exposed functions over touching internal structs. The inlined containers are convenience helpers for internal use.
  - To globally replace the allocator for tests, assign mulle_default_allocator = mulle_testallocator (do so consistently and restore afterwards).
- Common pitfalls:
  - Do not assume thread-safety.
  - Do not rely on internal symbols prefixed with `_` across library boundaries.
  - When patching stdlib, take care with allocator semantics; use provided stdlib wrapper where appropriate.

## 6. Integration Examples

### Example 1: Initialize test allocator and enable tracing

```c
#include "mulle-testallocator.h"

int
main( void)
{
   mulle_testallocator_initialize();
   mulle_testallocator_set_tracelevel( 2);
   /* optionally limit allocation sizes (0 disables): */
   mulle_testallocator_set_max_size( 0);

   /* Run tests that allocate via the default allocator. Optionally:
      mulle_default_allocator = mulle_testallocator; */

   /* enable leak detection for the run */
   mulle_testallocator_reset();

   /* ... run test code ... */

   mulle_testallocator_cancel();
   return(0);
}
```

### Example 2: Disable leak checking for a test section (discard)

```c
#include "mulle-testallocator.h"

void
some_test_section( void)
{
   mulle_testallocator_discard(); /* do not detect leaks here */

   /* code that intentionally leaks for the test */

   /* restore detection for subsequent tests */
   mulle_testallocator_reset();
}
```

### Example 3: Using _pointerarray (internal helper) to collect pointers

```c
#include <stdlib.h>
#include "pointerarray.h"

int
main( void)
{
   struct _pointerarray  *arr;
   void                  *p;
   struct _pointerarray_enumerator  en;

   arr = _pointerarray_alloc( calloc);

   p = malloc( 16);
   _pointerarray_add( arr, p, realloc);

   en = _pointerarray_enumerate( arr);
   while( (p = _pointerarray_enumerator_next( &en)) != (void *) -1)
   {
      /* use p */
   }
   _pointerarray_enumerator_done( &en);

   _pointerarray_free( arr, free);
   return( 0);
}
```

## 7. Dependencies

- Direct runtime/build dependencies (from README):
  - mulle-allocator (core allocation abstractions)
  - mulle-atinit (constructor/initializer helpers)
  - mulle-dlfcn (shared library helper, optional for dynamic symbolization)
  - mulle-stacktrace (optional; used to collect/format backtraces)
  - mulle-thread (used by some platform helpers)

- Typical usage: include mulle-testallocator alongside mulle-allocator and link it early so constructor activation works.


---

Notes for an AI:
- Primary API surfaces: mulle_testallocator_initialize(), mulle_testallocator_reset(), configuration via mulle_testallocator_config, and the exported mulle_testallocator allocator object.
- For concrete usage, prefer the test examples in test/checks/; they demonstrate manual initialization and environment-driven modes.
 The core concept is to provide an allocator, `mulle_testallocator`, that conforms to the `struct mulle_allocator` interface. This allows it to be seamlessly swapped with the default allocator.
- **Allocation Tracking:** The test allocator maintains a thread-safe internal set of all currently active memory allocations. When `malloc` is called, a record is added; when `free` is called, the corresponding record is removed.
- **Automatic Activation:** The library can be activated automatically at program startup by setting the `MULLE_TESTALLOCATOR=YES` environment variable. It uses a constructor function to replace the `mulle_default_allocator` and an `atexit` handler to print the leak report upon termination.
- **Fail-Fast on Errors:** For errors like double frees or bad frees, the library's philosophy is to abort immediately. This stops the program at the exact point of the error, making it much easier to debug than continuing with corrupted memory.
- **Tracing and Debugging:** Verbose tracing can be enabled via environment variables (`MULLE_TESTALLOCATOR_TRACE`) to see every allocation and deallocation, optionally including stack traces, which is invaluable for pinpointing the source of leaks.

## 3. Core API & Data Structures

The library's main interaction point is the `mulle_testallocator` instance and a set of control functions.

### 3.1. `mulle-testallocator.h`

#### Global Allocator Instance
- `mulle_testallocator`: A global instance of `struct mulle_allocator` that provides the memory debugging functionality. It can be assigned to `mulle_default_allocator` to enable tracking for all code using the default allocator.

#### Manual Control Functions
- `mulle_testallocator_initialize()`: Initializes the internal data structures of the test allocator. This is called automatically by the constructor when using environment variable activation.
- `mulle_testallocator_reset()`: Checks for leaks among the currently tracked allocations, prints a report to `stderr`, and then clears the internal tracking set. This is useful for checking for leaks within a specific section of code without waiting for the program to exit.
- `mulle_testallocator_done()`: Releases all resources held by the test allocator itself. This is called automatically by the `atexit` handler.

#### Environment Variables (for configuration)
- `MULLE_TESTALLOCATOR=YES`: Activates the test allocator for the entire program run.
- `MULLE_TESTALLOCATOR_TRACE=[1,2,3+]`: Enables tracing of allocations and deallocations.
  - `1`: Traces setup and exit.
  - `2`: Also traces every allocation and free.
  - `3+`: Also includes a stack trace for each operation.
- `MULLE_TESTALLOCATOR_DONT_FREE=YES`: Allocations are tracked, but the underlying memory is never actually freed. This can help simplify traces but will consume memory rapidly.
- `MULLE_TESTALLOCATOR_FIRST_LEAK=YES`: If set, the leak report will stop after the first leak is found.

## 4. Performance Characteristics

- **Overhead:** The test allocator introduces significant performance and memory overhead compared to a standard allocator. Each allocation and deallocation requires locking a mutex, hash map lookups, and storing metadata. It is **not** suitable for use in production code.
- **Memory Usage:** Memory usage is substantially higher than normal, as metadata (including file, line, function name, and optionally a stack trace) is stored for every single allocation.
- **Thread-Safety:** The library is fully thread-safe. All access to the internal tracking data is protected by a mutex.

## 5. AI Usage Recommendations & Patterns

- **Activation:** The easiest way to use the library is to link it and run the program with `MULLE_TESTALLOCATOR=YES`. No code changes are required if the program already uses `mulle_allocator`.
- **Linking:** For automatic activation to work correctly, `mulle-testallocator` should be linked early, and the linker must be instructed to load the entire static archive to prevent the constructor from being optimized away.
  - **mulle-sde:** Use the `all-load` mark.
  - **Linux:** `-Wl,--whole-archive -lmulle-testallocator -Wl,--no-whole-archive`
- **Manual Scoping:** To check for leaks in a specific part of the code, bracket the code with `mulle_default_allocator = mulle_testallocator;` and `mulle_testallocator_reset();`. Remember to restore the original allocator afterward.
- **Debugging Leaks:** When a leak is reported, the address of the leaked block is printed. To find where it was allocated, re-run with `MULLE_TESTALLOCATOR_TRACE=3`. Then, search the trace output for the leaked address to find the stack trace of its allocation site.

## 6. Integration Examples

### Example 1: Automatic Leak Detection

This example shows a program with an intentional memory leak. No special code is needed; the leak is detected by running with the environment variable.
*Source: `test/checks/leak.c`*

```c
#include <mulle-allocator/mulle-allocator.h>

int main(void)
{
    // This allocation is never freed.
    mulle_malloc(16);

    return 0;
}
```

**Execution and Output:**
```sh
$ MULLE_TESTALLOCATOR=YES ./my_program
mulle_testallocator: *** Leaked 1 block(s) (16 bytes) ***
mulle_testallocator: [1] 0x... (16 bytes) leaked
```

### Example 2: Detecting a Double Free

This program attempts to free the same memory block twice. `mulle-testallocator` will detect this and abort immediately.
*Source: `test/checks/doublefree.c`*

```c
#include <mulle-allocator/mulle-allocator.h>

int main(void)
{
    void *p = mulle_malloc(16);
    mulle_free(p);

    // This second free will cause the program to abort.
    mulle_free(p);

    return 0;
}
```
**Execution and Output:**
```sh
$ MULLE_TESTALLOCATOR=YES ./my_program
mulle_testallocator: *** pointer 0x... was already freed ***
Abort trap: 6
```

### Example 3: Manual Leak Checking with `reset`

This example demonstrates how to check for leaks within a specific scope, which is useful for unit tests.
*Source: `README.md`*
```c
#include <mulle-testallocator/mulle-testallocator.h>
#include <mulle-allocator/mulle-allocator.h>
#include <stdio.h>

void function_with_a_leak(void)
{
    mulle_malloc(32);
}

int main(void)
{
    struct mulle_allocator *original_allocator;

    // Setup test allocator for a specific scope
    mulle_testallocator_initialize();
    original_allocator = mulle_default_allocator;
    mulle_default_allocator = &mulle_testallocator;

    printf("--- Checking for leaks in function_with_a_leak ---
");
    function_with_a_leak();
    // reset() will print the leak report here
    mulle_testallocator_reset();
    printf("--- Check finished ---

");

    // Restore original allocator
    mulle_default_allocator = original_allocator;
    mulle_testallocator_done();

    return 0;
}
```

## 7. Dependencies

- `mulle-allocator`
- `mulle-atinit`
- `mulle-atexit`
- `mulle-stacktrace`
- `mulle-thread`

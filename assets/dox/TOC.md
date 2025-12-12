# mulle-testallocator Library Documentation for AI

## 1. Introduction & Purpose

`mulle-testallocator` is a C library for memory debugging. It acts as a drop-in replacement for `mulle-allocator` to detect common memory errors such as memory leaks, double frees, and invalid pointer frees.

Its primary purpose is to be used during testing and debugging phases. By tracking every allocation and deallocation, it can report on memory blocks that were allocated but never freed (leaks) at the end of a program's execution or at specific checkpoints. It also validates pointers passed to `free`, immediately crashing the program if a double free or a free of an invalid pointer is detected.

## 2. Key Concepts & Design Philosophy

- **Allocator Replacement:** The core concept is to provide an allocator, `mulle_testallocator`, that conforms to the `struct mulle_allocator` interface. This allows it to be seamlessly swapped with the default allocator.
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

### 6.2.1


feature: switch test allocator to the reallocarray vector

* **BREAKING**: ``mulle_testallocator_stdlib_realloc()`` is replaced by ``mulle_testallocator_stdlib_reallocarray(` void *q, `size_t` n, `size_t` size, struct `mulle_allocator` *)`
* **BREAKING**: the test allocator now installs its hooks into the `reallocarray` slot of `struct `mulle_allocator`` (`calloc`/`reallocarray`/`free`/`fail`), so existing code patching `.realloc` must switch to `.reallocarray`
* stdlib wrapper now backs malloc, realloc, allocarray and reallocarray through a single reallocarray entry point
* zero-size and multiplication-overflow arguments are detected and routed to the allocation fail vector, matching the default reallocarray semantics

## 6.2.0


feature: add function to detect the test allocator

* new ``mulle_allocator_is_testallocator()`` API to check if a given ``mulle_allocator`` instance is the test allocator
* returns 1 for the test allocator, 0 otherwise, and safely handles NULL input





* source files now consistently reference mulle-testallocator project
* BSD license header added to files that were missing it
* copyright years updated to reflect actual project origins

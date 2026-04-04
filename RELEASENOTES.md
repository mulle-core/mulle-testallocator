## 6.1.0







feature: export stdlib realloc wrapper and harden allocator init/reset

* declare `mulle_testallocator_stdlib_realloc` in the public header so callers/tests can interpose or call the allocator's stdlib realloc wrapper
* make allocator initialization and test helpers more robust: install allocator hooks reliably, add reset/detect-leak and cancel/reset paths for test workflows, and improve diagnostics/debug tracing

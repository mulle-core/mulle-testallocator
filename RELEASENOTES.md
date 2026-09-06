## 6.2.0


feature: add function to detect the test allocator

* new ``mulle_allocator_is_testallocator()`` API to check if a given ``mulle_allocator`` instance is the test allocator
* returns 1 for the test allocator, 0 otherwise, and safely handles NULL input





* source files now consistently reference mulle-testallocator project
* BSD license header added to files that were missing it
* copyright years updated to reflect actual project origins

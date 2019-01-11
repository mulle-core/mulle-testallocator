# `mulle_testallocator`

## How to use it


Link against `mulle_testallocator` to search for leaks and mistaken frees in
your code. Wrap the test allocator around your code like this:

```
#include <mulle-allocator/mulle-allocator.h>
#include <mulle-testallocator/mulle-testallocator.h>


int  main( int argc, char *argv[])
{
   mulle_testallocator_initialize(); // or mulle_testallocator_reset
   mulle_default_allocator = mulle_testallocator;
   {
      // do stuff
   }
   mulle_testallocator_reset();
}
```

> This will check all allocations going through `mulle_allocator_malloc` and
friends. Direct calls to `malloc` can not be tracked.


## Environment Variables

Debug support can be turned on and off with environment variables

Variable                         | Description
-------------------------------- | ------------------------------------
`MULLE_TESTALLOCATOR_ENABLE`     | Turn on automatic tracing during startup. (See below)
`MULLE_TESTALLOCATOR_TRACE`      | Trace setup, allocations and deallocations. 1: trace setup and exit. 2: additionally traces allocations. 3: adds a stacktrace to the output (on participating platforms). A value larger than 3 increases the verbosity of the stacktrace.
`MULLE_TESTALLOCATOR_DONT_FREE`  | Memory is not actually freed, this can be useful, when reuse of memory makes the trace too confusing. Obviously this can burn memory away quickly.
`MULLE_TESTALLOCATOR_FIRST_LEAK` | Only report the first leak if set to 1 or YES.


## Automatic startup is tricky and platform dependent

For this to work, ensure that the mulle-testallocator is actually linked and
incorporated wholesale. Also make sure the constructor function of
mulle-testallocator is run as the very first. You may need to reorder
linking of the library to the earliest or latest possible stage.

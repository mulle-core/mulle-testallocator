# mulle-testallocator

mulle-testallocator is a leak and double free checker for tests
(and at runtime). It builds upon [mulle-allocator](//mulle-c/mulle-allocator).


Fork      |  Build Status | Release Version
----------|---------------|-----------------------------------
[Mulle kybernetiK](//github.com/mulle-c/mulle-testallocator) | [![Build Status](https://travis-ci.org/mulle-c/mulle-testallocator.svg?branch=release)](https://travis-ci.org/mulle-c/mulle-testallocator) | ![Mulle kybernetiK tag](https://img.shields.io/github/tag/mulle-c/mulle-testallocator.svg) [![Build Status](https://travis-ci.org/mulle-c/mulle-testallocator.svg?branch=release)](https://travis-ci.org/mulle-c/mulle-testallocator)

##  Use `mulle_testallocator` for leak detection

Use `mulle_malloc` and friends instead of `malloc` in your code.

So instead of:

```
   malloc( 1848);
   calloc( 18, 48);
   s = strdup( "VfL Bochum 1848");
   realloc( s, 18);
   free( s);
```

write

```
   mulle_malloc( 1848);
   mulle_calloc( 18, 48);
   s = mulle_strdup( "VfL Bochum 1848");
   mulle_realloc( s, 18);
   mulle_free( s);
```

Now you can easily check for leaks using the `mulle_testallocator` library.

Wrap your code inside

```
mulle_testallocator_initialize();
mulle_default_allocator = mulle_testallocator;
{
   mulle_malloc( 1848);
   mulle_calloc( 18, 48);
   s = mulle_strdup( "VfL Bochum 1848");
   mulle_realloc( s, 18);
   mulle_free( s);
}
mulle_testallocator_reset();
```

and `mulle_testallocator_reset` will tell you about your leaks.
All `mulle_testallocator` routines will check for erroneus frees and
wrong pointers.


## Install

Use [mulle-sde](//github.com/mulle-sde) to add mulle-testallocator to your
dependencies `mulle-sde dependency add https://github.com/mulle-c/mulle-testallocator.git`.


## Manual Installation

Install the requirements:


Requirements                                              | Description
----------------------------------------------------------|-----------------------
[mulle-c11](//github.com/mulle-c/mulle-c11)               | Compiler glue, single header
[mulle-allocator](//github.com/mulle-c/mulle-allocator)   | Memory allocation library
[mulle-thread](//github.com/mulle-concurrent/mulle-thread)| Thread and lock glue


Install with

```
mkdir build
cd build
cmake
make
make install
```


## API

* [Test Allocator](dox/API_TESTALLOCATOR.md)


### Platforms and Compilers

All platforms and compilers supported by
[mulle-c11](//www.mulle-kybernetik.com/software/git/mulle-c11/) and
[mulle-thread](//www.mulle-kybernetik.com/software/git/mulle-thread/).


## Author

[Nat!](//www.mulle-kybernetik.com/weblog) for
[Mulle kybernetiK](//www.mulle-kybernetik.com) and
[Codeon GmbH](//www.codeon.de)

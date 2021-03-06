# mulle-testallocator

#### 🔄 C memory leak and double free checking

mulle-testallocator is a leak and double free checker for tests
(and at runtime). It builds upon [mulle-allocator](//mulle-c/mulle-allocator).


| Release Version
|-----------------------------------
[![Build Status](https://travis-ci.org/mulle-core/mulle-testallocator.svg?branch=release)](https://travis-ci.org/mulle-core/mulle-testallocator) | ![Mulle kybernetiK tag](https://img.shields.io/github/tag/mulle-core/mulle-testallocator.svg?branch=release) [![Build Status](https://travis-ci.org/mulle-core/mulle-testallocator.svg?branch=release)](https://travis-ci.org/mulle-core/mulle-testallocator)


###  Use `mulle_testallocator` for leak detection

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
Just run your code with the environment variable MULLE_TESTALLOCATOR
set to YES.
mulle-testallocator will tell you your leaks when the executable exits.

> This feature needs a C-compiler that handles `__attribute__(((constructor))`.
>
> The order of constructor and atexit calls is dependent on the link order.
> To catch all leaks, it is advantageous to link mulle-testallocator ahead of
> all other code. You should also use [whole archive linking](https://stackoverflow.com/questions/25038974/force-load-linker-flag-for-other-platforms) as otherwise the
> library may just be omitted from the link.


#### Manual method

Or you can wrap your code inside the following piece of code:

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

All `mulle_testallocator` routines will check for erroneous frees and
wrong pointers.

> #### Tip
>
> Locate Objective-C leaks easily with
>
> ```
> MULLE_OBJC_EPHEMERAL_SINGLETON=YES \
> MULLE_OBJC_TRACE_INSTANCE=YES \
> MULLE_OBJC_TRACE_METHOD_CALL=YES \
> MULLE_TESTALLOCATOR_TRACE=2 \
>    ./kitchen/Debug/myexe
> ```
> The search for the leak address and you will see the method that
> allocated the leak.
>


## API and Environment

You can configure trace output and other properties of the
[Test Allocator](dox/API_TESTALLOCATOR.md) via the API or environment
variables.


### Platforms and Compilers

All platforms and compilers supported by
[mulle-c11](//github.com/mulle-c/mulle-c11) and
[mulle-thread](//github.com/mulle-concurrent/mulle-thread).



## Add

Use [mulle-sde](//github.com/mulle-sde) to add mulle-testallocator to your project:

```
mulle-sde dependency add --marks all-load,no-singlephase \
                         --github mulle-core \
                         mulle-testallocator
```

## Install

### mulle-sde

Use [mulle-sde](//github.com/mulle-sde) to build and install mulle-testallocator and all dependencies:

```
mulle-sde install --prefix /usr/local \
   https://github.com/mulle-core/mulle-testallocator/archive/latest.tar.gz
```

### Manual Installation


Install the requirements:

Requirements                                                 | Description
-------------------------------------------------------------|-----------------------
[mulle-c11](//github.com/mulle-c/mulle-c11)                  | Compiler glue, single header
[mulle-allocator](//github.com/mulle-c/mulle-allocator)      | Memory allocation library
[mulle-thread](//github.com/mulle-concurrent/mulle-thread)   | Thread and lock glue
[mulle-stacktrace](//github.com/mulle-core/mulle-stracktrace)| Stacktrace support glue
[mulle-atinit](//github.com/mulle-core/mulle-atinit)         | Cross-platform atinit support
[mulle-atexit](//github.com/mulle-core/mulle-atexit)         | Cross-platform atexit support

Install into `/usr/local`:

```
mkdir build 2> /dev/null
(
   cd build ;
   cmake -DCMAKE_INSTALL_PREFIX=/usr/local \
         -DCMAKE_PREFIX_PATH=/usr/local \
         -DCMAKE_BUILD_TYPE=Release .. ;
   make install
)
```


## Author

[Nat!](//www.mulle-kybernetik.com/weblog) for
[Mulle kybernetiK](//www.mulle-kybernetik.com) and
[Codeon GmbH](//www.codeon.de)

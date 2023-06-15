# mulle-testallocator

#### 🔄 C memory leak and double free checking


# mulle-testallocator

#### 🔄 C memory leak and double free checking

mulle-testallocator is a leak and double free checker for tests
(and at runtime). It builds upon [mulle-allocator](//github.com/mulle-c/mulle-allocator).


| Release Version
|-----------------------------------
|[![Build Status](https://github.com/mulle-core/mulle-testallocator/workflows/CI/badge.svg?branch=release)](//github.com/mulle-core/mulle-testallocator)  ![Mulle kybernetiK tag](https://img.shields.io/github/tag/mulle-core/mulle-testallocator/workflows/CI/badge.svg?branch=release)


###  Use `mulle_testallocator` for leak detection

Use `mulle_malloc` and friends instead of `malloc` in your code.

So instead of:

``` c
   malloc( 1848);
   calloc( 18, 48);
   s = strdup( "VfL Bochum 1848");
   realloc( s, 18);
   free( s);
```

write

``` c
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
> all other code. You should also use [whole archive linking](//stackoverflow.com/questions/25038974/force-load-linker-flag-for-other-platforms) as otherwise the
> library may just be omitted from the link.


#### Manual method

Or you can wrap your code inside the following piece of code:

``` c
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
> ``` sh
> MULLE_OBJC_EPHEMERAL_SINGLETON=YES \
> MULLE_OBJC_TRACE_INSTANCE=YES \
> MULLE_OBJC_TRACE_METHOD_CALL=YES \
> MULLE_TESTALLOCATOR_TRACE=2 \
>    ./kitchen/Debug/myexe
> ```
> The search for the leak address and you will see the method that
> allocated the leak.
>



| Release Version                                       | Release Notes
|-------------------------------------------------------|--------------
| ![Mulle kybernetiK tag](https://img.shields.io/github/tag/mulle-core/mulle-testallocator.svg?branch=release) [![Build Status](https://github.com/mulle-core/mulle-testallocator/workflows/CI/badge.svg?branch=release)](//github.com/mulle-core/mulle-testallocator/actions)| [RELEASENOTES](RELEASENOTES.md) |


## API

You can configure trace output and other properties of the
[Test Allocator](dox/API_TESTALLOCATOR.md) via the API or environment
variables.



## Usage

###  Use `mulle_testallocator` for leak detection

Use `mulle_malloc` and friends instead of `malloc` in your code.

So instead of:

``` c
   malloc( 1848);
   calloc( 18, 48);
   s = strdup( "VfL Bochum 1848");
   realloc( s, 18);
   free( s);
```

write

``` c
   mulle_malloc( 1848);
   mulle_calloc( 18, 48);
   s = mulle_strdup( "VfL Bochum 1848");
   mulle_realloc( s, 18);
   mulle_free( s);
```

Now you can easily check for leaks using this `mulle_testallocator` library.
Just run your code with the environment variable MULLE_TESTALLOCATOR
set to YES.
mulle-testallocator will tell you your leaks when the executable exits.

> #### Note
>
> This feature needs a C-compiler that handles `__attribute__(((constructor))`.
>
> The order of constructor and atexit calls is dependent on the link order.
> To catch all leaks, it is advantageous to link mulle-testallocator ahead of
> all other code. You should also use [whole archive linking](//stackoverflow.com/questions/25038974/force-load-linker-flag-for-other-platforms) as otherwise the
> library may just be omitted from the link.


#### Manual method

Or you can wrap your code inside the following piece of code:

``` c
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

and `mulle_testallocator_reset` will tell you about your leaks. You
don't need the 'constructor' support then.

All `mulle_testallocator` routines will check for erroneous frees and
wrong pointers.

> #### Tip
>
> Locate Objective-C leaks easily with
>
> ``` sh
> MULLE_OBJC_EPHEMERAL_SINGLETON=YES \
> MULLE_OBJC_TRACE_INSTANCE=YES \
> MULLE_OBJC_TRACE_METHOD_CALL=YES \
> MULLE_TESTALLOCATOR_TRACE=2 \
>    ./kitchen/Debug/myexe
> ```
> Then search for the leak address and you will see the method that
> allocated the leak.
>






## Add

**This project is a component of the [mulle-core](//github.com/mulle-core/mulle-core) library. As such you usually will *not* add or install it
individually, unless you specifically do not want to link against
`mulle-core`.**


### Add as an individual component

Use [mulle-sde](//github.com/mulle-sde) to add mulle-testallocator to your project:

``` sh
mulle-sde add github:mulle-core/mulle-testallocator
```

To only add the sources of mulle-testallocator with dependency
sources use [clib](https://github.com/clibs/clib):


``` sh
clib install --out src/mulle-core mulle-core/mulle-testallocator
```

Add `-isystem src/mulle-core` to your `CFLAGS` and compile all the sources that were downloaded with your project.


## Install

### Install with mulle-sde

Use [mulle-sde](//github.com/mulle-sde) to build and install mulle-testallocator and all dependencies:

``` sh
mulle-sde install --prefix /usr/local \
   https://github.com/mulle-core/mulle-testallocator/archive/latest.tar.gz
```

### Manual Installation

Install the requirements:

| Requirements                                 | Description
|----------------------------------------------|-----------------------
| [mulle-thread](https://github.com/mulle-concurrent/mulle-thread)             | 🔠 Cross-platform thread/mutex/tss/atomic operations in C
| [mulle-allocator](https://github.com/mulle-c/mulle-allocator)             | 🔄 Flexible C memory allocation scheme
| [mulle-stacktrace](https://github.com/mulle-core/mulle-stacktrace)             | 👣 Stracktrace support for various OS
| [mulle-atinit](https://github.com/mulle-core/mulle-atinit)             | 🤱🏼 Compatibility library for deterministic initializers
| [mulle-atexit](https://github.com/mulle-core/mulle-atexit)             | 👼 Compatibility library to fix atexit
| [mulle-dlfcn](https://github.com/mulle-core/mulle-dlfcn)             | ♿️ Shared library helper

Install **mulle-testallocator** into `/usr/local` with [cmake](https://cmake.org):

``` sh
cmake -B build \
      -DCMAKE_INSTALL_PREFIX=/usr/local \
      -DCMAKE_PREFIX_PATH=/usr/local \
      -DCMAKE_BUILD_TYPE=Release &&
cmake --build build --config Release &&
cmake --install build --config Release
```

## Author

[Nat!](https://mulle-kybernetik.com/weblog) for Mulle kybernetiK



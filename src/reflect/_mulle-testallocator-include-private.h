/*
 *   This file will be regenerated by `mulle-sourcetree-to-c` via
 *   `mulle-sde reflect` and any edits will be lost.
 *   Suppress generation of this file with:
 *
 *      mulle-sde environment set MULLE_SOURCETREE_TO_C_PRIVATEINCLUDE_FILE DISABLE
 *
 *   To not let mulle-sourcetree-to-c generate any header files:
 *
 *      mulle-sde environment set MULLE_SOURCETREE_TO_C_RUN DISABLE
 *
 */

#ifndef _mulle_testallocator_include_private_h__
#define _mulle_testallocator_include_private_h__

// You can tweak the following #include with these commands.
// (Use B417A6CC-391E-466E-9516-27D754C8A317 instead of mulle-stacktrace if there are duplicate entries)
//    remove #include:: `mulle-sde dependency mark mulle-stacktrace no-header`
//    rename:              `mulle-sde dependency|library set mulle-stacktrace include whatever.h`
//    reorder:             `mulle-sde dependency move mulle-stacktrace <up|down>`
//    toggle #include:    `mulle-sde dependency mark mulle-stacktrace [no-]import`
//    toggle public:       `mulle-sde dependency mark mulle-stacktrace [no-]public`
//    toggle optional:     `mulle-sde dependency mark mulle-stacktrace [no-]require`
//    remove for platform: `mulle-sde dependency mark mulle-stacktrace no-platform-<uname>`
//        (use `mulle-sourcetree-to-c --unames` to list known values)
#include <mulle-stacktrace/mulle-stacktrace.h>   // mulle-stacktrace

// You can tweak the following #include with these commands.
// (Use 1E64BF82-7365-41E3-94CA-3CF148B45533 instead of mulle-atinit if there are duplicate entries)
//    remove #include:: `mulle-sde dependency mark mulle-atinit no-header`
//    rename:              `mulle-sde dependency|library set mulle-atinit include whatever.h`
//    reorder:             `mulle-sde dependency move mulle-atinit <up|down>`
//    toggle #include:    `mulle-sde dependency mark mulle-atinit [no-]import`
//    toggle public:       `mulle-sde dependency mark mulle-atinit [no-]public`
//    toggle optional:     `mulle-sde dependency mark mulle-atinit [no-]require`
//    remove for platform: `mulle-sde dependency mark mulle-atinit no-platform-<uname>`
//        (use `mulle-sourcetree-to-c --unames` to list known values)
#include <mulle-atinit/mulle-atinit.h>   // mulle-atinit

// You can tweak the following #include with these commands.
// (Use 8CCFB85A-7AE3-452E-A231-A93918CDD6C8 instead of mulle-atexit if there are duplicate entries)
//    remove #include:: `mulle-sde dependency mark mulle-atexit no-header`
//    rename:              `mulle-sde dependency|library set mulle-atexit include whatever.h`
//    reorder:             `mulle-sde dependency move mulle-atexit <up|down>`
//    toggle #include:    `mulle-sde dependency mark mulle-atexit [no-]import`
//    toggle public:       `mulle-sde dependency mark mulle-atexit [no-]public`
//    toggle optional:     `mulle-sde dependency mark mulle-atexit [no-]require`
//    remove for platform: `mulle-sde dependency mark mulle-atexit no-platform-<uname>`
//        (use `mulle-sourcetree-to-c --unames` to list known values)
#include <mulle-atexit/mulle-atexit.h>   // mulle-atexit

// You can tweak the following #include with these commands.
// (Use 42A968F8-3B06-4645-B569-C459E9238D22 instead of mulle-dlfcn if there are duplicate entries)
//    remove #include:: `mulle-sde dependency mark mulle-dlfcn no-header`
//    rename:              `mulle-sde dependency|library set mulle-dlfcn include whatever.h`
//    reorder:             `mulle-sde dependency move mulle-dlfcn <up|down>`
//    toggle #include:    `mulle-sde dependency mark mulle-dlfcn [no-]import`
//    toggle public:       `mulle-sde dependency mark mulle-dlfcn [no-]public`
//    toggle optional:     `mulle-sde dependency mark mulle-dlfcn [no-]require`
//    remove for platform: `mulle-sde dependency mark mulle-dlfcn no-platform-<uname>`
//        (use `mulle-sourcetree-to-c --unames` to list known values)
#include <mulle-dlfcn/mulle-dlfcn.h>   // mulle-dlfcn

#endif

/*
 *   This file will be regenerated by `mulle-sde reflect` and any edits will be
 *   lost. Suppress generation of this file with:
 *      mulle-sde environment --global \
 *         set MULLE_SOURCETREE_TO_C_PRIVATEINCLUDE_FILE DISABLE
 *
 *   To not generate any header files:
 *      mulle-sde environment --global \
 *         set MULLE_SOURCETREE_TO_C_RUN DISABLE
 */

#ifndef _mulle_testallocator_include_private_h__
#define _mulle_testallocator_include_private_h__

// How to tweak the following mulle-stacktrace #include
//    remove:             `mulle-sourcetree mark mulle-stacktrace no-header`
//    rename:             `mulle-sde dependency|library set mulle-stacktrace include whatever.h`
//    toggle #import:     `mulle-sourcetree mark mulle-stacktrace [no-]import`
//    toggle localheader: `mulle-sourcetree mark mulle-stacktrace [no-]localheader`
//    toggle public:      `mulle-sourcetree mark mulle-stacktrace [no-]public`
//    toggle optional:    `mulle-sourcetree mark mulle-stacktrace [no-]require`
//    remove for os:      `mulle-sourcetree mark mulle-stacktrace no-os-<osname>`
# if defined( __has_include) && __has_include("mulle-stacktrace.h")
#   include "mulle-stacktrace.h"   // mulle-stacktrace
# else
#   include <mulle-stacktrace/mulle-stacktrace.h>   // mulle-stacktrace
# endif

// How to tweak the following mulle-atinit #include
//    remove:             `mulle-sourcetree mark mulle-atinit no-header`
//    rename:             `mulle-sde dependency|library set mulle-atinit include whatever.h`
//    toggle #import:     `mulle-sourcetree mark mulle-atinit [no-]import`
//    toggle localheader: `mulle-sourcetree mark mulle-atinit [no-]localheader`
//    toggle public:      `mulle-sourcetree mark mulle-atinit [no-]public`
//    toggle optional:    `mulle-sourcetree mark mulle-atinit [no-]require`
//    remove for os:      `mulle-sourcetree mark mulle-atinit no-os-<osname>`
# if defined( __has_include) && __has_include("mulle-atinit.h")
#   include "mulle-atinit.h"   // mulle-atinit
# else
#   include <mulle-atinit/mulle-atinit.h>   // mulle-atinit
# endif

// How to tweak the following mulle-atexit #include
//    remove:             `mulle-sourcetree mark mulle-atexit no-header`
//    rename:             `mulle-sde dependency|library set mulle-atexit include whatever.h`
//    toggle #import:     `mulle-sourcetree mark mulle-atexit [no-]import`
//    toggle localheader: `mulle-sourcetree mark mulle-atexit [no-]localheader`
//    toggle public:      `mulle-sourcetree mark mulle-atexit [no-]public`
//    toggle optional:    `mulle-sourcetree mark mulle-atexit [no-]require`
//    remove for os:      `mulle-sourcetree mark mulle-atexit no-os-<osname>`
# if defined( __has_include) && __has_include("mulle-atexit.h")
#   include "mulle-atexit.h"   // mulle-atexit
# else
#   include <mulle-atexit/mulle-atexit.h>   // mulle-atexit
# endif

#endif

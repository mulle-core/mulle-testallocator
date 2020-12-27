/*
 *   This file will be regenerated by `mulle-sde reflect` and any edits will be
 *   lost. Suppress generation of this file with:
 *      mulle-sde environment --global \
 *         set MULLE_SOURCETREE_TO_C_INCLUDE_FILE DISABLE
 *
 *   To not generate any header files:
 *      mulle-sde environment --global \
 *         set MULLE_SOURCETREE_TO_C_RUN DISABLE
 */

#ifndef _mulle_testallocator_include_h__
#define _mulle_testallocator_include_h__

// How to tweak the following mulle-thread #include
//    remove:             `mulle-sourcetree mark mulle-thread no-header`
//    rename:             `mulle-sde dependency|library set mulle-thread include whatever.h`
//    toggle #import:     `mulle-sourcetree mark mulle-thread [no-]import`
//    toggle public:      `mulle-sourcetree mark mulle-thread [no-]public`
//    toggle optional:    `mulle-sourcetree mark mulle-thread [no-]require`
//    remove for os:      `mulle-sourcetree mark mulle-thread no-os-<osname>`
# include <mulle-thread/mulle-thread.h>   // mulle-thread

// How to tweak the following mulle-allocator #include
//    remove:             `mulle-sourcetree mark mulle-allocator no-header`
//    rename:             `mulle-sde dependency|library set mulle-allocator include whatever.h`
//    toggle #import:     `mulle-sourcetree mark mulle-allocator [no-]import`
//    toggle public:      `mulle-sourcetree mark mulle-allocator [no-]public`
//    toggle optional:    `mulle-sourcetree mark mulle-allocator [no-]require`
//    remove for os:      `mulle-sourcetree mark mulle-allocator no-os-<osname>`
# include <mulle-allocator/mulle-allocator.h>   // mulle-allocator

#endif

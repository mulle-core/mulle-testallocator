//
//  mulle_testallocator.c
//  mulle-container
//
//  Created by Nat! on 04.11.15.
//  Copyright (c) 2015 Nat! - Mulle kybernetiK.
//  Copyright (c) 2015 Codeon GmbH.
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  Neither the name of Mulle kybernetiK nor the names of its contributors
//  may be used to endorse or promote products derived from this software
//  without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//
#include "include-private.h"

#include "mulle-testallocator.h"
#include "mulle-testallocator-struct.h"
// #include "mulle_testallocator.h"  // don't include for windows
#include <assert.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>


//#define DEBUG_INITIALIZE


#pragma clang diagnostic ignored "-Wparentheses"

#pragma mark - track allocations

#include "pointerset.h"


// a mixture of values < 0 and bits > 0
enum
{
   mulle_testallocator_trace_cancelled  = -2,
   mulle_testallocator_trace_disabled   = -1,
   mulle_testallocator_trace_none       = 0,
   mulle_testallocator_trace_enabled    = 1,
   mulle_testallocator_trace_verbose    = 2,
   mulle_testallocator_trace_stacktrace = 4
};

enum
{
   mulle_testallocator_leak_only_one   = 1,  // only list one
   mulle_testallocator_leak_dont_bail  = 2,  // don't abort on leaks
};


static struct
{
   int                       trace;
   struct mulle_stacktrace   stacktrace;
   mulle_thread_mutex_t      alloc_lock;
   struct _pointerset        allocations;
   struct _pointerset        frees;
   size_t                    max_size;
} local =
{
   mulle_testallocator_trace_disabled
};

//
// unintialized data gets name mangled by cl.exe
// initialized data fortunately not
//
MULLE_C_GLOBAL struct _mulle_testallocator_config    mulle_testallocator_config  =
{
#ifdef _WIN32
   1
#endif
};


static int   may_alloc( size_t size)
{
   assert( local.trace != mulle_testallocator_trace_disabled && "mulle_testallocator_initialize has not run yet");

   if( mulle_testallocator_config.out_of_memory)
      return( 0);

   return( ! mulle_testallocator_config.max_size || size <= mulle_testallocator_config.max_size);
}


MULLE_C_NEVER_INLINE
static void   log_stacktrace( char *format, ...)
{
   va_list   args;

   va_start( args, format);
   {
      vfprintf( stderr, format, args);
      if( local.trace & mulle_testallocator_trace_stacktrace)
         _mulle_stacktrace( &local.stacktrace, 1, mulle_stacktrace_trimmed, stderr);
      fputc( '\n', stderr);
   }
   va_end( args);
}


MULLE_C_NEVER_INLINE
void   mulle_testallocator_bail( void *p)
{
#if defined( __APPLE__)
   if( getenv( "MULLE_TESTALLOCATOR_HISTORY"))
   {
      /* start malloc_history */
      char        buf [ 256];
      extern int  getpid( void);

      /* undo some environment stuff, there must be an easier way */
      unsetenv( "DYLD_INSERT_LIBRARIES");
      unsetenv( "MallocStackLogging");
      unsetenv( "MallocStackLoggingNoCompact");
      unsetenv( "MallocScribble");
      unsetenv( "MallocPreScribble");
      unsetenv( "MallocGuardEdges");
      unsetenv( "MallocCheckHeapEach");
      sprintf( buf, "sudo malloc_history %d %p", getpid(), p);
      fprintf( stderr, "%s\n", buf);
      system( buf);
   }
#endif

/* abort is clumsy on WIN32 */
#if defined( _WIN32)
   exit( 1);
#endif
   abort();
}


static void   reused_pointer_assert( void *p)
{
   if( _pointerset_get( &local.allocations, p))
   {
      log_stacktrace( "\n###\n### a non-allocator-freed block got reused: %p", p);
      mulle_testallocator_bail( p);
   }
}


static void  *test_realloc( void *q, size_t size)
{
   void   *p;
   void   *old;

   if( ! may_alloc( size))
   {
      errno = ENOMEM;
      return( NULL);
   }

   if( q)
   {
      if( local.trace != mulle_testallocator_trace_cancelled)
      {
         if( mulle_thread_mutex_lock( &local.alloc_lock))
         {
            perror( "mulle_thread_mutex_lock:");
            abort();
         }

         old = _pointerset_get( &local.allocations, q);
         if( ! old)
         {
            log_stacktrace( "\n###\n### false realloc: %p", q);
            mulle_testallocator_bail( q);
         }
         mulle_thread_mutex_unlock( &local.alloc_lock);
      }
   }

   //
   // dont_free doesn't work here, since we don't know the previous size
   // we cant fake it with a malloc/memcpy combination
   //
   p = realloc( q, size);
   if( p)
   {
      if( local.trace != mulle_testallocator_trace_cancelled)
      {
         if( mulle_thread_mutex_lock( &local.alloc_lock))
         {
            perror( "mulle_thread_mutex_lock:");
            abort();
         }

         if( ! q)
         {
            // just a normal malloc
            _pointerset_remove( &local.frees, p);
            reused_pointer_assert( p);
            _pointerset_add( &local.allocations, p, calloc, free);
         }
         else
         {
            // if p == q, then nothing happened
            if( p != q)
            {
               assert( ! _pointerset_get( &local.frees, q));
               assert( _pointerset_get( &local.allocations, q));
               _pointerset_remove( &local.allocations, q); // just a pointer remove
               _pointerset_add( &local.frees, q, calloc, free);

               _pointerset_remove( &local.frees, p);
               reused_pointer_assert( p);
               _pointerset_add( &local.allocations, p, calloc, free);
            }
         }
         mulle_thread_mutex_unlock( &local.alloc_lock);
      }
   }

   if( local.trace & mulle_testallocator_trace_verbose)
   {
      if( q) // analyzer, just a print of the old address
         log_stacktrace( "realloced %p -> %p-%p",
                  q, p, &((char *)p)[ size ? size - 1 : 0]);
      else
         log_stacktrace( "alloced %p-%p",
                  p, &((char *)p)[ size ? size - 1 : 0]);
   }
   return( p);
}


static void  *test_calloc( size_t n, size_t size)
{
   void   *p;

   if( ! may_alloc( size))
   {
      errno = ENOMEM;
      return( NULL);
   }

   p = calloc( n, size);
   if( ! p)
      return( p);

   if( local.trace != mulle_testallocator_trace_cancelled)
   {
      if( mulle_thread_mutex_lock( &local.alloc_lock))
      {
         perror( "mulle_thread_mutex_lock:");
         abort();
      }

      _pointerset_remove( &local.frees, p);
      reused_pointer_assert( p);
      _pointerset_add( &local.allocations, p, calloc, free);

      mulle_thread_mutex_unlock( &local.alloc_lock);
   }

   if( local.trace & mulle_testallocator_trace_verbose)
   {
      log_stacktrace( "alloced %p-%p",
               p, &((char *)p)[ n * size ? n * size - 1 : 0]);
   }

   return( p);
}


static void  test_free( void *p)
{
   void   *q;

   assert( local.trace != mulle_testallocator_trace_disabled &&
           "mulle_testallocator_initialize has not run yet");

   if( ! p)
      return;

   if( local.trace != mulle_testallocator_trace_cancelled)
   {
      if( mulle_thread_mutex_lock( &local.alloc_lock))
      {
         perror( "mulle_thread_mutex_lock:");
         abort();
      }

      q = _pointerset_get( &local.frees, p);
      if( q)
      {
         log_stacktrace( "\n###\n### double free: %p", p);
         mulle_testallocator_bail( p);
      }
      _pointerset_add( &local.frees, p, calloc, free);

      q = _pointerset_get( &local.allocations, p);
      if( ! q)
      {
         log_stacktrace( "\n###\n### false free: %p", p);
         mulle_testallocator_bail( p);
      }
      _pointerset_remove( &local.allocations, q);

      mulle_thread_mutex_unlock( &local.alloc_lock);
   }

   if( ! mulle_testallocator_config.dont_free)
      free( p);

   if( local.trace & mulle_testallocator_trace_verbose)
   {
      log_stacktrace( "freed %p", p);  // analyzer: just an address print
   }
}


#pragma mark - global variable

MULLE_C_GLOBAL
struct mulle_allocator   mulle_testallocator =
{
   test_calloc,
   test_realloc,
   test_free,
   mulle_allocation_fail,
   (int (*)(void *, void (*)(void *), void *)) abort
};


#pragma mark - reset allocator between tests

static int   getenv_yes_no( char *name)
{
   char   *s;

   s = getenv( name);
   if( ! s)
      return( 0);

   switch( *s)
   {
   case '\0':
   case 'f' :
   case 'F' :
   case 'n' :
   case 'N' :
   case '0' : return( 0);
   }

   return( 1);
}


static long   getenv_long( char *name)
{
   char   *s;

   s = getenv( name);
   if( ! s)
      return( 0);

   return( atol( s));
}


void   mulle_testallocator_set_tracelevel( unsigned int value)
{
   if( (int) value != local.trace && (local.trace != mulle_testallocator_trace_disabled || (int) value > 0))
      fprintf( stderr, "mulle_testallocator: trace level set to %d\n", value);

   local.trace = value;
}


void   mulle_testallocator_set_max_size( size_t value)
{
   if( (int) value != local.trace && (local.trace != mulle_testallocator_trace_disabled || (int) value > 0))
      fprintf( stderr, "mulle_testallocator: max size set to %ld\n", (long) value);

   mulle_testallocator_config.max_size = value;
}


void   mulle_testallocator_set_stacktracesymbolizer( void (*f)( void))
{
   assert( f);
   local.stacktrace.symbolize = (mulle_stacktrace_symbolizer_t *) f;
}


void   _mulle_testallocator_reset()
{
   _pointerset_done( &local.allocations, free);
   _pointerset_done( &local.frees, free);

   mulle_testallocator_config.out_of_memory = 0;

   _pointerset_init( &local.allocations);
   _pointerset_init( &local.frees);
}


void   _mulle_testallocator_detect_leaks()
{
   struct _pointerset_enumerator   rover;
   void                            *p;
   void                            *first_leak;
   int                             leakmode;
   char                            *s;

   if( local.trace == mulle_testallocator_trace_cancelled)
      return;

   first_leak = NULL;

   s        = getenv( "MULLE_TESTALLOCATOR_LEAKS");
   leakmode = s ? atoi( s) : 0;

   rover = _pointerset_enumerate( &local.allocations);
   while( p = _pointerset_enumerator_next( &rover))
   {
      fprintf( stderr, "### leak %p\n", p);
      if( ! first_leak)
      {
         first_leak = p;
         if( leakmode & mulle_testallocator_leak_only_one)
            break;
      }
   }
   _pointerset_enumerator_done( &rover);

   if( first_leak && ! (leakmode & mulle_testallocator_leak_dont_bail))
      mulle_testallocator_bail( first_leak);
}


static void   trace_log( char *s)
{
   if( local.trace & mulle_testallocator_trace_enabled)
     fprintf( stderr, "mulle_testallocator: %s\n", s);
}


static void   trace_log_pointer( char *s, void *pointer)
{
   if( local.trace & mulle_testallocator_trace_enabled)
     fprintf( stderr, "mulle_testallocator: %s (%p)\n", s, pointer);
}


//
// TODO: MULLE_C_CONSTRUCTOR doesn't work with non-clang compilers
//
static void   mulle_testallocator_exit()
{
   if( local.trace == mulle_testallocator_trace_disabled)
      return;

   // only display if enabled by environment
   trace_log_pointer( "exit", (void *) mulle_testallocator_exit);

   mulle_testallocator_reset();
}


static void   _mulle_testallocator_initialize( void *unused)
{
   int    rval;

   if( local.trace != mulle_testallocator_trace_disabled)
      return;

   rval = mulle_thread_mutex_init( &local.alloc_lock);
   if( rval)
   {
      fprintf( stderr, "_mulle_testallocator_initialize could not get a mutex\n");
      abort();
   }

   mulle_testallocator_set_tracelevel( (int) getenv_long( "MULLE_TESTALLOCATOR_TRACE"));
   mulle_testallocator_set_max_size( getenv_long( "MULLE_TESTALLOCATOR_MAX_SIZE"));
   mulle_testallocator_config.dont_free = getenv_yes_no( "MULLE_TESTALLOCATOR_DONT_FREE");

   _mulle_stacktrace_init_default( &local.stacktrace);

   if( getenv_yes_no( "MULLE_TESTALLOCATOR"))
   {
      /* Now it gets tricky. In a dylib situation we are not linked with
         mulle_atexit. mulle_atexit will be statically linked to the exe,
         and this will be resolved at link time. So thats fine. If
         mulle_testallocator is added with DYLD_INSERT_LIBRARY this will also
         work (AFAIK). But if you want to run the debugger within such
         a DYLD_INSERT_LIBRARY environment, this will fail, since the debugger
         itself is also getting the insertion and it is usually NOT linked
         with mulle_atexit. For this we lazy link mulle_atexit and just don't
         do the codepath if mulle_atexit is not available.
      */
      void  (*p_mulle_atexit)( void (*)(void));

      p_mulle_atexit = dlsym( MULLE_RTLD_DEFAULT, "mulle_atexit");
      if( ! p_mulle_atexit)
      {
         trace_log( "not enabled as mulle_atexit was not found");
         return;
      }

      trace_log_pointer( "start:     mulle_testallocator_initialize", &mulle_testallocator_initialize);
      trace_log_pointer( "allocator: mulle_default_allocator", &mulle_default_allocator);
      trace_log_pointer( "stdlib:    mulle_stdlib_allocator", &mulle_stdlib_allocator);

      // keep old aba, and fail function pointers
      // scribbling over aba_free would be disastrous
      mulle_default_allocator.calloc  = test_calloc;
      mulle_default_allocator.realloc = test_realloc;
      mulle_default_allocator.free    = test_free;

      trace_log_pointer( "install atexit \"mulle_testallocator_exit\"", (void *) mulle_testallocator_exit);

      (*p_mulle_atexit)( mulle_testallocator_exit);

      if( mulle_testallocator_config.dont_free)
         trace_log( "memory will not really be freed");
   }
}


MULLE_C_CONSTRUCTOR( mulle_testallocator_initialize)
void   mulle_testallocator_initialize( void)
{
//#ifdef __APPLE__
//   // on APPLE we don't need mulle_atinit, it doesn't work right to delay
//   // this why ??
//   _mulle_testallocator_initialize( NULL);
//#else
# ifdef DEBUG_INITIALIZE
   fprintf( stderr, "mulle_testallocator_initialize: mulle_atinit set for _mulle_testallocator_initialize\n");
# endif
   // 1 meeelion priority!
   mulle_atinit( _mulle_testallocator_initialize, NULL, 1000000);
//#endif
}


void   mulle_testallocator_reset_detect_leaks( int detect)
{
   if( local.trace == mulle_testallocator_trace_disabled)
      mulle_testallocator_initialize();   // for windows, tests can get by calling
                                          // mulle_testallocator_reset first
   trace_log( "lock");
   if( mulle_thread_mutex_lock( &local.alloc_lock))
   {
      perror( "mulle_thread_mutex_lock:");
      abort();
   }

   trace_log( "reset");

   if( detect)
      _mulle_testallocator_detect_leaks();
   _mulle_testallocator_reset();

   trace_log( "unlock");
   mulle_thread_mutex_unlock( &local.alloc_lock);
}


void   mulle_testallocator_cancel( void)
{
   mulle_testallocator_discard();
   mulle_testallocator_set_tracelevel( mulle_testallocator_trace_cancelled);
}


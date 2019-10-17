//
//  mulle_testallocator.h
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

#ifndef mulle_testallocator_h__
#define mulle_testallocator_h__

#include <mulle-allocator/mulle-allocator.h>

#include "mulle-testallocator-struct.h"

#define MULLE_TESTALLOCATOR_VERSION    ((4 << 20) | (1 << 8) | 0)

MULLE_ALLOCATOR_EXTERN_GLOBAL struct _mulle_testallocator_config   mulle_testallocator_config;
MULLE_ALLOCATOR_EXTERN_GLOBAL struct mulle_allocator               mulle_testallocator;

void   mulle_testallocator_initialize( void);
void   mulle_testallocator_reset_detect_leaks( int detect);
void   mulle_testallocator_set_tracelevel( unsigned int value); // 0,1,2 -1 turns off

//
// the symbolizer parses the backtrace string and possibly improves it
// return mulle_alloc string or input if unchanged
//
// We don't want to expose stacktrace here though, so we'd use a generic
// functionpointer if that existed. Instead we just use a void one.
//
void   mulle_testallocator_set_stacktracesymbolizer( void (*f)( void));

// start a clean sheet, without leak checking
static inline void   mulle_testallocator_discard( void)
{
   mulle_testallocator_reset_detect_leaks( 0);
}


static inline void   mulle_testallocator_reset( void)
{
   mulle_testallocator_reset_detect_leaks( 1);
}

//
// call this only once, you will have a hard time to reinitialize the
// test allocator propery. Do this at the end of a test, if you used
// mulle_testallocator_discard.
//
void   mulle_testallocator_cancel( void);

// unlocked functions, rarely useful
void   _mulle_testallocator_reset( void);
void   _mulle_testallocator_detect_leaks( void);

#endif /* mulle_testallocator_h */

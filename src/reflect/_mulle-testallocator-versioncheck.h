/*
 *   This file will be regenerated by `mulle-project-versioncheck`.
 *   Any edits will be lost.
 */
#if defined( MULLE_ALLOCATOR_VERSION)
# if MULLE_ALLOCATOR_VERSION < ((4 << 20) | (2 << 8) | 4)
#  error "mulle-allocator is too old"
# endif
# if MULLE_ALLOCATOR_VERSION >= ((5 << 20) | (0 << 8) | 0)
#  error "mulle-allocator is too new"
# endif
#endif

#if defined( MULLE_ATEXIT_VERSION)
# if MULLE_ATEXIT_VERSION < ((0 << 20) | (0 << 8) | 10)
#  error "mulle-atexit is too old"
# endif
# if MULLE_ATEXIT_VERSION >= ((0 << 20) | (1 << 8) | 0)
#  error "mulle-atexit is too new"
# endif
#endif

#if defined( MULLE_ATINIT_VERSION)
# if MULLE_ATINIT_VERSION < ((0 << 20) | (0 << 8) | 7)
#  error "mulle-atinit is too old"
# endif
# if MULLE_ATINIT_VERSION >= ((0 << 20) | (1 << 8) | 0)
#  error "mulle-atinit is too new"
# endif
#endif

#if defined( MULLE_DLFCN_VERSION)
# if MULLE_DLFCN_VERSION < ((0 << 20) | (0 << 8) | 8)
#  error "mulle-dlfcn is too old"
# endif
# if MULLE_DLFCN_VERSION >= ((0 << 20) | (1 << 8) | 0)
#  error "mulle-dlfcn is too new"
# endif
#endif

#if defined( MULLE_STACKTRACE_VERSION)
# if MULLE_STACKTRACE_VERSION < ((0 << 20) | (2 << 8) | 4)
#  error "mulle-stacktrace is too old"
# endif
# if MULLE_STACKTRACE_VERSION >= ((0 << 20) | (3 << 8) | 0)
#  error "mulle-stacktrace is too new"
# endif
#endif

#if defined( MULLE_THREAD_VERSION)
# if MULLE_THREAD_VERSION < ((4 << 20) | (4 << 8) | 0)
#  error "mulle-thread is too old"
# endif
# if MULLE_THREAD_VERSION >= ((5 << 20) | (0 << 8) | 0)
#  error "mulle-thread is too new"
# endif
#endif

# This file will be regenerated by `mulle-sourcetree-to-cmake` via
# `mulle-sde reflect` and any edits will be lost.
#
# This file will be included by cmake/share/Files.cmake
#
# Disable generation of this file with:
#
# mulle-sde environment set MULLE_SOURCETREE_TO_CMAKE_DEPENDENCIES_FILE DISABLE
#
if( MULLE_TRACE_INCLUDE)
   message( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
endif()

#
# Generated from sourcetree: 5C3405CC-15C5-4602-AC79-FF22891F4ADE;mulle-allocator;no-all-load,no-bequeath,no-cmake-inherit,no-import,no-link,no-singlephase;mulle-core,mulle-allocator
# Disable with : `mulle-sourcetree mark mulle-allocator no-header`
# Disable for this platform: `mulle-sourcetree mark mulle-allocator no-cmake-platform-${MULLE_UNAME}`
# Disable for a sdk: `mulle-sourcetree mark mulle-allocator no-cmake-sdk-<name>`
#
if( NOT MULLE__ALLOCATOR_HEADER)
   find_file( MULLE__ALLOCATOR_HEADER NAMES mulle-allocator.h mulle-core/mulle-core.h mulle-allocator/mulle-allocator.h)
   message( STATUS "MULLE__ALLOCATOR_HEADER is ${MULLE__ALLOCATOR_HEADER}")

   #
   # Add MULLE__ALLOCATOR_HEADER to HEADER_ONLY_LIBRARIES list.
   # Disable with: `mulle-sourcetree mark mulle-allocator no-cmake-add`
   #
   set( HEADER_ONLY_LIBRARIES
      ${MULLE__ALLOCATOR_HEADER}
      ${HEADER_ONLY_LIBRARIES}
   )
   if( MULLE__ALLOCATOR_HEADER)
      # intentionally left blank
   else()
      # Disable with: `mulle-sourcetree mark mulle-allocator no-require`
      message( SEND_ERROR "MULLE__ALLOCATOR_HEADER was not found")
   endif()
endif()



#
# Generated from sourcetree: 557D6E11-900A-499A-BCF2-23D58BA04C5D;mulle-thread;no-all-load,no-cmake-searchpath,no-import,no-singlephase;mulle-core,mulle-thread
# Disable with : `mulle-sourcetree mark mulle-thread no-link`
# Disable for this platform: `mulle-sourcetree mark mulle-thread no-cmake-platform-${MULLE_UNAME}`
# Disable for a sdk: `mulle-sourcetree mark mulle-thread no-cmake-sdk-<name>`
#
if( COLLECT_DEPENDENCY_LIBRARIES_AS_NAMES)
   list( APPEND DEPENDENCY_LIBRARIES "mulle-core")
else()
   if( NOT MULLE__THREAD_LIBRARY)
      find_library( MULLE__THREAD_LIBRARY NAMES
         ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-core${CMAKE_DEBUG_POSTFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}
         ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-core${CMAKE_STATIC_LIBRARY_SUFFIX}
         mulle-core
         ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-thread${CMAKE_DEBUG_POSTFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}
         ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-thread${CMAKE_STATIC_LIBRARY_SUFFIX}
         mulle-thread
         NO_CMAKE_SYSTEM_PATH NO_SYSTEM_ENVIRONMENT_PATH
      )
      if( NOT MULLE__THREAD_LIBRARY AND NOT DEPENDENCY_IGNORE_SYSTEM_LIBARIES)
         find_library( MULLE__THREAD_LIBRARY NAMES
            ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-core${CMAKE_DEBUG_POSTFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}
            ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-core${CMAKE_STATIC_LIBRARY_SUFFIX}
            mulle-core
            ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-thread${CMAKE_DEBUG_POSTFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}
            ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-thread${CMAKE_STATIC_LIBRARY_SUFFIX}
            mulle-thread
         )
      endif()
      message( STATUS "MULLE__THREAD_LIBRARY is ${MULLE__THREAD_LIBRARY}")
      #
      # The order looks ascending, but due to the way this file is read
      # it ends up being descending, which is what we need.
      #
      if( MULLE__THREAD_LIBRARY)
         #
         # Add MULLE__THREAD_LIBRARY to DEPENDENCY_LIBRARIES list.
         # Disable with: `mulle-sourcetree mark mulle-thread no-cmake-add`
         #
         list( APPEND DEPENDENCY_LIBRARIES ${MULLE__THREAD_LIBRARY})
         #
         # Inherit information from dependency.
         # Encompasses: no-cmake-searchpath,no-cmake-dependency,no-cmake-loader
         # Disable with: `mulle-sourcetree mark mulle-thread no-cmake-inherit`
         #
         # temporarily expand CMAKE_MODULE_PATH
         get_filename_component( _TMP_MULLE__THREAD_ROOT "${MULLE__THREAD_LIBRARY}" DIRECTORY)
         get_filename_component( _TMP_MULLE__THREAD_ROOT "${_TMP_MULLE__THREAD_ROOT}" DIRECTORY)
         #
         #
         # Search for "Definitions.cmake" and "DependenciesAndLibraries.cmake" to include.
         # Disable with: `mulle-sourcetree mark mulle-thread no-cmake-dependency`
         #
         foreach( _TMP_MULLE__THREAD_NAME "mulle-core" "mulle-thread")
            set( _TMP_MULLE__THREAD_DIR "${_TMP_MULLE__THREAD_ROOT}/include/${_TMP_MULLE__THREAD_NAME}/cmake")
            # use explicit path to avoid "surprises"
            if( IS_DIRECTORY "${_TMP_MULLE__THREAD_DIR}")
               list( INSERT CMAKE_MODULE_PATH 0 "${_TMP_MULLE__THREAD_DIR}")
               # we only want top level INHERIT_OBJC_LOADERS, so disable them
               if( NOT NO_INHERIT_OBJC_LOADERS)
                  set( NO_INHERIT_OBJC_LOADERS OFF)
               endif()
               list( APPEND _TMP_INHERIT_OBJC_LOADERS ${NO_INHERIT_OBJC_LOADERS})
               set( NO_INHERIT_OBJC_LOADERS ON)
               #
               include( "${_TMP_MULLE__THREAD_DIR}/DependenciesAndLibraries.cmake" OPTIONAL)
               #
               list( GET _TMP_INHERIT_OBJC_LOADERS -1 NO_INHERIT_OBJC_LOADERS)
               list( REMOVE_AT _TMP_INHERIT_OBJC_LOADERS -1)
               list( REMOVE_ITEM CMAKE_MODULE_PATH "${_TMP_MULLE__THREAD_DIR}")
               #
               unset( MULLE__THREAD_DEFINITIONS)
               include( "${_TMP_MULLE__THREAD_DIR}/Definitions.cmake" OPTIONAL)
               list( APPEND INHERITED_DEFINITIONS ${MULLE__THREAD_DEFINITIONS})
               break()
            else()
               message( STATUS "${_TMP_MULLE__THREAD_DIR} not found")
            endif()
         endforeach()
      else()
         # Disable with: `mulle-sourcetree mark mulle-thread no-require-link`
         message( SEND_ERROR "MULLE__THREAD_LIBRARY was not found")
      endif()
   endif()
endif()


#
# Generated from sourcetree: B417A6CC-391E-466E-9516-27D754C8A317;mulle-stacktrace;no-all-load,no-cmake-searchpath,no-import,no-public,no-singlephase;mulle-core,mulle-stacktrace
# Disable with : `mulle-sourcetree mark mulle-stacktrace no-link`
# Disable for this platform: `mulle-sourcetree mark mulle-stacktrace no-cmake-platform-${MULLE_UNAME}`
# Disable for a sdk: `mulle-sourcetree mark mulle-stacktrace no-cmake-sdk-<name>`
#
if( COLLECT_DEPENDENCY_LIBRARIES_AS_NAMES)
   list( APPEND DEPENDENCY_LIBRARIES "mulle-core")
else()
   if( NOT MULLE__STACKTRACE_LIBRARY)
      find_library( MULLE__STACKTRACE_LIBRARY NAMES
         ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-core${CMAKE_DEBUG_POSTFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}
         ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-core${CMAKE_STATIC_LIBRARY_SUFFIX}
         mulle-core
         ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-stacktrace${CMAKE_DEBUG_POSTFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}
         ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-stacktrace${CMAKE_STATIC_LIBRARY_SUFFIX}
         mulle-stacktrace
         NO_CMAKE_SYSTEM_PATH NO_SYSTEM_ENVIRONMENT_PATH
      )
      if( NOT MULLE__STACKTRACE_LIBRARY AND NOT DEPENDENCY_IGNORE_SYSTEM_LIBARIES)
         find_library( MULLE__STACKTRACE_LIBRARY NAMES
            ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-core${CMAKE_DEBUG_POSTFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}
            ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-core${CMAKE_STATIC_LIBRARY_SUFFIX}
            mulle-core
            ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-stacktrace${CMAKE_DEBUG_POSTFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}
            ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-stacktrace${CMAKE_STATIC_LIBRARY_SUFFIX}
            mulle-stacktrace
         )
      endif()
      message( STATUS "MULLE__STACKTRACE_LIBRARY is ${MULLE__STACKTRACE_LIBRARY}")
      #
      # The order looks ascending, but due to the way this file is read
      # it ends up being descending, which is what we need.
      #
      if( MULLE__STACKTRACE_LIBRARY)
         #
         # Add MULLE__STACKTRACE_LIBRARY to DEPENDENCY_LIBRARIES list.
         # Disable with: `mulle-sourcetree mark mulle-stacktrace no-cmake-add`
         #
         list( APPEND DEPENDENCY_LIBRARIES ${MULLE__STACKTRACE_LIBRARY})
         #
         # Inherit information from dependency.
         # Encompasses: no-cmake-searchpath,no-cmake-dependency,no-cmake-loader
         # Disable with: `mulle-sourcetree mark mulle-stacktrace no-cmake-inherit`
         #
         # temporarily expand CMAKE_MODULE_PATH
         get_filename_component( _TMP_MULLE__STACKTRACE_ROOT "${MULLE__STACKTRACE_LIBRARY}" DIRECTORY)
         get_filename_component( _TMP_MULLE__STACKTRACE_ROOT "${_TMP_MULLE__STACKTRACE_ROOT}" DIRECTORY)
         #
         #
         # Search for "Definitions.cmake" and "DependenciesAndLibraries.cmake" to include.
         # Disable with: `mulle-sourcetree mark mulle-stacktrace no-cmake-dependency`
         #
         foreach( _TMP_MULLE__STACKTRACE_NAME "mulle-core" "mulle-stacktrace")
            set( _TMP_MULLE__STACKTRACE_DIR "${_TMP_MULLE__STACKTRACE_ROOT}/include/${_TMP_MULLE__STACKTRACE_NAME}/cmake")
            # use explicit path to avoid "surprises"
            if( IS_DIRECTORY "${_TMP_MULLE__STACKTRACE_DIR}")
               list( INSERT CMAKE_MODULE_PATH 0 "${_TMP_MULLE__STACKTRACE_DIR}")
               # we only want top level INHERIT_OBJC_LOADERS, so disable them
               if( NOT NO_INHERIT_OBJC_LOADERS)
                  set( NO_INHERIT_OBJC_LOADERS OFF)
               endif()
               list( APPEND _TMP_INHERIT_OBJC_LOADERS ${NO_INHERIT_OBJC_LOADERS})
               set( NO_INHERIT_OBJC_LOADERS ON)
               #
               include( "${_TMP_MULLE__STACKTRACE_DIR}/DependenciesAndLibraries.cmake" OPTIONAL)
               #
               list( GET _TMP_INHERIT_OBJC_LOADERS -1 NO_INHERIT_OBJC_LOADERS)
               list( REMOVE_AT _TMP_INHERIT_OBJC_LOADERS -1)
               list( REMOVE_ITEM CMAKE_MODULE_PATH "${_TMP_MULLE__STACKTRACE_DIR}")
               #
               unset( MULLE__STACKTRACE_DEFINITIONS)
               include( "${_TMP_MULLE__STACKTRACE_DIR}/Definitions.cmake" OPTIONAL)
               list( APPEND INHERITED_DEFINITIONS ${MULLE__STACKTRACE_DEFINITIONS})
               break()
            else()
               message( STATUS "${_TMP_MULLE__STACKTRACE_DIR} not found")
            endif()
         endforeach()
      else()
         # Disable with: `mulle-sourcetree mark mulle-stacktrace no-require-link`
         message( SEND_ERROR "MULLE__STACKTRACE_LIBRARY was not found")
      endif()
   endif()
endif()


#
# Generated from sourcetree: 1E64BF82-7365-41E3-94CA-3CF148B45533;mulle-atinit;no-cmake-searchpath,no-dynamic-link,no-import,no-intermediate-link,no-public,no-singlephase;
# Disable with : `mulle-sourcetree mark mulle-atinit no-link`
# Disable for this platform: `mulle-sourcetree mark mulle-atinit no-cmake-platform-${MULLE_UNAME}`
# Disable for a sdk: `mulle-sourcetree mark mulle-atinit no-cmake-sdk-<name>`
#
if( COLLECT_STARTUP_ALL_LOAD_DEPENDENCY_LIBRARIES_AS_NAMES)
   list( APPEND STARTUP_ALL_LOAD_DEPENDENCY_LIBRARIES "mulle-atinit")
else()
   if( NOT MULLE__ATINIT_LIBRARY)
      find_library( MULLE__ATINIT_LIBRARY NAMES
         ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-atinit${CMAKE_DEBUG_POSTFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}
         ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-atinit${CMAKE_STATIC_LIBRARY_SUFFIX}
         NO_CMAKE_SYSTEM_PATH NO_SYSTEM_ENVIRONMENT_PATH
      )
      if( NOT MULLE__ATINIT_LIBRARY AND NOT DEPENDENCY_IGNORE_SYSTEM_LIBARIES)
         find_library( MULLE__ATINIT_LIBRARY NAMES
            ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-atinit${CMAKE_DEBUG_POSTFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}
            ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-atinit${CMAKE_STATIC_LIBRARY_SUFFIX}
         )
      endif()
      message( STATUS "MULLE__ATINIT_LIBRARY is ${MULLE__ATINIT_LIBRARY}")
      #
      # The order looks ascending, but due to the way this file is read
      # it ends up being descending, which is what we need.
      #
      if( MULLE__ATINIT_LIBRARY)
         #
         # Add MULLE__ATINIT_LIBRARY to STARTUP_ALL_LOAD_DEPENDENCY_LIBRARIES list.
         # Disable with: `mulle-sourcetree mark mulle-atinit no-cmake-add`
         #
         list( APPEND STARTUP_ALL_LOAD_DEPENDENCY_LIBRARIES ${MULLE__ATINIT_LIBRARY})
         #
         # Inherit information from dependency.
         # Encompasses: no-cmake-searchpath,no-cmake-dependency,no-cmake-loader
         # Disable with: `mulle-sourcetree mark mulle-atinit no-cmake-inherit`
         #
         # temporarily expand CMAKE_MODULE_PATH
         get_filename_component( _TMP_MULLE__ATINIT_ROOT "${MULLE__ATINIT_LIBRARY}" DIRECTORY)
         get_filename_component( _TMP_MULLE__ATINIT_ROOT "${_TMP_MULLE__ATINIT_ROOT}" DIRECTORY)
         #
         #
         # Search for "Definitions.cmake" and "DependenciesAndLibraries.cmake" to include.
         # Disable with: `mulle-sourcetree mark mulle-atinit no-cmake-dependency`
         #
         foreach( _TMP_MULLE__ATINIT_NAME "mulle-atinit")
            set( _TMP_MULLE__ATINIT_DIR "${_TMP_MULLE__ATINIT_ROOT}/include/${_TMP_MULLE__ATINIT_NAME}/cmake")
            # use explicit path to avoid "surprises"
            if( IS_DIRECTORY "${_TMP_MULLE__ATINIT_DIR}")
               list( INSERT CMAKE_MODULE_PATH 0 "${_TMP_MULLE__ATINIT_DIR}")
               #
               include( "${_TMP_MULLE__ATINIT_DIR}/DependenciesAndLibraries.cmake" OPTIONAL)
               #
               list( REMOVE_ITEM CMAKE_MODULE_PATH "${_TMP_MULLE__ATINIT_DIR}")
               #
               unset( MULLE__ATINIT_DEFINITIONS)
               include( "${_TMP_MULLE__ATINIT_DIR}/Definitions.cmake" OPTIONAL)
               list( APPEND INHERITED_DEFINITIONS ${MULLE__ATINIT_DEFINITIONS})
               break()
            else()
               message( STATUS "${_TMP_MULLE__ATINIT_DIR} not found")
            endif()
         endforeach()
         #
         # Search for "MulleObjCLoader+<name>.h" in include directory.
         # Disable with: `mulle-sourcetree mark mulle-atinit no-cmake-loader`
         #
         if( NOT NO_INHERIT_OBJC_LOADERS)
            foreach( _TMP_MULLE__ATINIT_NAME "mulle-atinit")
               set( _TMP_MULLE__ATINIT_FILE "${_TMP_MULLE__ATINIT_ROOT}/include/${_TMP_MULLE__ATINIT_NAME}/MulleObjCLoader+${_TMP_MULLE__ATINIT_NAME}.h")
               if( EXISTS "${_TMP_MULLE__ATINIT_FILE}")
                  list( APPEND INHERITED_OBJC_LOADERS ${_TMP_MULLE__ATINIT_FILE})
                  break()
               endif()
            endforeach()
         endif()
      else()
         # Disable with: `mulle-sourcetree mark mulle-atinit no-require-link`
         message( SEND_ERROR "MULLE__ATINIT_LIBRARY was not found")
      endif()
   endif()
endif()


#
# Generated from sourcetree: 8CCFB85A-7AE3-452E-A231-A93918CDD6C8;mulle-atexit;no-cmake-searchpath,no-dynamic-link,no-import,no-intermediate-link,no-public,no-singlephase;
# Disable with : `mulle-sourcetree mark mulle-atexit no-link`
# Disable for this platform: `mulle-sourcetree mark mulle-atexit no-cmake-platform-${MULLE_UNAME}`
# Disable for a sdk: `mulle-sourcetree mark mulle-atexit no-cmake-sdk-<name>`
#
if( COLLECT_STARTUP_ALL_LOAD_DEPENDENCY_LIBRARIES_AS_NAMES)
   list( APPEND STARTUP_ALL_LOAD_DEPENDENCY_LIBRARIES "mulle-atexit")
else()
   if( NOT MULLE__ATEXIT_LIBRARY)
      find_library( MULLE__ATEXIT_LIBRARY NAMES
         ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-atexit${CMAKE_DEBUG_POSTFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}
         ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-atexit${CMAKE_STATIC_LIBRARY_SUFFIX}
         NO_CMAKE_SYSTEM_PATH NO_SYSTEM_ENVIRONMENT_PATH
      )
      if( NOT MULLE__ATEXIT_LIBRARY AND NOT DEPENDENCY_IGNORE_SYSTEM_LIBARIES)
         find_library( MULLE__ATEXIT_LIBRARY NAMES
            ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-atexit${CMAKE_DEBUG_POSTFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}
            ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-atexit${CMAKE_STATIC_LIBRARY_SUFFIX}
         )
      endif()
      message( STATUS "MULLE__ATEXIT_LIBRARY is ${MULLE__ATEXIT_LIBRARY}")
      #
      # The order looks ascending, but due to the way this file is read
      # it ends up being descending, which is what we need.
      #
      if( MULLE__ATEXIT_LIBRARY)
         #
         # Add MULLE__ATEXIT_LIBRARY to STARTUP_ALL_LOAD_DEPENDENCY_LIBRARIES list.
         # Disable with: `mulle-sourcetree mark mulle-atexit no-cmake-add`
         #
         list( APPEND STARTUP_ALL_LOAD_DEPENDENCY_LIBRARIES ${MULLE__ATEXIT_LIBRARY})
         #
         # Inherit information from dependency.
         # Encompasses: no-cmake-searchpath,no-cmake-dependency,no-cmake-loader
         # Disable with: `mulle-sourcetree mark mulle-atexit no-cmake-inherit`
         #
         # temporarily expand CMAKE_MODULE_PATH
         get_filename_component( _TMP_MULLE__ATEXIT_ROOT "${MULLE__ATEXIT_LIBRARY}" DIRECTORY)
         get_filename_component( _TMP_MULLE__ATEXIT_ROOT "${_TMP_MULLE__ATEXIT_ROOT}" DIRECTORY)
         #
         #
         # Search for "Definitions.cmake" and "DependenciesAndLibraries.cmake" to include.
         # Disable with: `mulle-sourcetree mark mulle-atexit no-cmake-dependency`
         #
         foreach( _TMP_MULLE__ATEXIT_NAME "mulle-atexit")
            set( _TMP_MULLE__ATEXIT_DIR "${_TMP_MULLE__ATEXIT_ROOT}/include/${_TMP_MULLE__ATEXIT_NAME}/cmake")
            # use explicit path to avoid "surprises"
            if( IS_DIRECTORY "${_TMP_MULLE__ATEXIT_DIR}")
               list( INSERT CMAKE_MODULE_PATH 0 "${_TMP_MULLE__ATEXIT_DIR}")
               #
               include( "${_TMP_MULLE__ATEXIT_DIR}/DependenciesAndLibraries.cmake" OPTIONAL)
               #
               list( REMOVE_ITEM CMAKE_MODULE_PATH "${_TMP_MULLE__ATEXIT_DIR}")
               #
               unset( MULLE__ATEXIT_DEFINITIONS)
               include( "${_TMP_MULLE__ATEXIT_DIR}/Definitions.cmake" OPTIONAL)
               list( APPEND INHERITED_DEFINITIONS ${MULLE__ATEXIT_DEFINITIONS})
               break()
            else()
               message( STATUS "${_TMP_MULLE__ATEXIT_DIR} not found")
            endif()
         endforeach()
         #
         # Search for "MulleObjCLoader+<name>.h" in include directory.
         # Disable with: `mulle-sourcetree mark mulle-atexit no-cmake-loader`
         #
         if( NOT NO_INHERIT_OBJC_LOADERS)
            foreach( _TMP_MULLE__ATEXIT_NAME "mulle-atexit")
               set( _TMP_MULLE__ATEXIT_FILE "${_TMP_MULLE__ATEXIT_ROOT}/include/${_TMP_MULLE__ATEXIT_NAME}/MulleObjCLoader+${_TMP_MULLE__ATEXIT_NAME}.h")
               if( EXISTS "${_TMP_MULLE__ATEXIT_FILE}")
                  list( APPEND INHERITED_OBJC_LOADERS ${_TMP_MULLE__ATEXIT_FILE})
                  break()
               endif()
            endforeach()
         endif()
      else()
         # Disable with: `mulle-sourcetree mark mulle-atexit no-require-link`
         message( SEND_ERROR "MULLE__ATEXIT_LIBRARY was not found")
      endif()
   endif()
endif()


#
# Generated from sourcetree: 42A968F8-3B06-4645-B569-C459E9238D22;mulle-dlfcn;no-all-load,no-cmake-searchpath,no-import,no-public,no-singlephase;mulle-core,mulle-dlfcn
# Disable with : `mulle-sourcetree mark mulle-dlfcn no-link`
# Disable for this platform: `mulle-sourcetree mark mulle-dlfcn no-cmake-platform-${MULLE_UNAME}`
# Disable for a sdk: `mulle-sourcetree mark mulle-dlfcn no-cmake-sdk-<name>`
#
if( COLLECT_DEPENDENCY_LIBRARIES_AS_NAMES)
   list( APPEND DEPENDENCY_LIBRARIES "mulle-core")
else()
   if( NOT MULLE__DLFCN_LIBRARY)
      find_library( MULLE__DLFCN_LIBRARY NAMES
         ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-core${CMAKE_DEBUG_POSTFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}
         ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-core${CMAKE_STATIC_LIBRARY_SUFFIX}
         mulle-core
         ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-dlfcn${CMAKE_DEBUG_POSTFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}
         ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-dlfcn${CMAKE_STATIC_LIBRARY_SUFFIX}
         mulle-dlfcn
         NO_CMAKE_SYSTEM_PATH NO_SYSTEM_ENVIRONMENT_PATH
      )
      if( NOT MULLE__DLFCN_LIBRARY AND NOT DEPENDENCY_IGNORE_SYSTEM_LIBARIES)
         find_library( MULLE__DLFCN_LIBRARY NAMES
            ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-core${CMAKE_DEBUG_POSTFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}
            ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-core${CMAKE_STATIC_LIBRARY_SUFFIX}
            mulle-core
            ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-dlfcn${CMAKE_DEBUG_POSTFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}
            ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-dlfcn${CMAKE_STATIC_LIBRARY_SUFFIX}
            mulle-dlfcn
         )
      endif()
      message( STATUS "MULLE__DLFCN_LIBRARY is ${MULLE__DLFCN_LIBRARY}")
      #
      # The order looks ascending, but due to the way this file is read
      # it ends up being descending, which is what we need.
      #
      if( MULLE__DLFCN_LIBRARY)
         #
         # Add MULLE__DLFCN_LIBRARY to DEPENDENCY_LIBRARIES list.
         # Disable with: `mulle-sourcetree mark mulle-dlfcn no-cmake-add`
         #
         list( APPEND DEPENDENCY_LIBRARIES ${MULLE__DLFCN_LIBRARY})
         #
         # Inherit information from dependency.
         # Encompasses: no-cmake-searchpath,no-cmake-dependency,no-cmake-loader
         # Disable with: `mulle-sourcetree mark mulle-dlfcn no-cmake-inherit`
         #
         # temporarily expand CMAKE_MODULE_PATH
         get_filename_component( _TMP_MULLE__DLFCN_ROOT "${MULLE__DLFCN_LIBRARY}" DIRECTORY)
         get_filename_component( _TMP_MULLE__DLFCN_ROOT "${_TMP_MULLE__DLFCN_ROOT}" DIRECTORY)
         #
         #
         # Search for "Definitions.cmake" and "DependenciesAndLibraries.cmake" to include.
         # Disable with: `mulle-sourcetree mark mulle-dlfcn no-cmake-dependency`
         #
         foreach( _TMP_MULLE__DLFCN_NAME "mulle-core" "mulle-dlfcn")
            set( _TMP_MULLE__DLFCN_DIR "${_TMP_MULLE__DLFCN_ROOT}/include/${_TMP_MULLE__DLFCN_NAME}/cmake")
            # use explicit path to avoid "surprises"
            if( IS_DIRECTORY "${_TMP_MULLE__DLFCN_DIR}")
               list( INSERT CMAKE_MODULE_PATH 0 "${_TMP_MULLE__DLFCN_DIR}")
               # we only want top level INHERIT_OBJC_LOADERS, so disable them
               if( NOT NO_INHERIT_OBJC_LOADERS)
                  set( NO_INHERIT_OBJC_LOADERS OFF)
               endif()
               list( APPEND _TMP_INHERIT_OBJC_LOADERS ${NO_INHERIT_OBJC_LOADERS})
               set( NO_INHERIT_OBJC_LOADERS ON)
               #
               include( "${_TMP_MULLE__DLFCN_DIR}/DependenciesAndLibraries.cmake" OPTIONAL)
               #
               list( GET _TMP_INHERIT_OBJC_LOADERS -1 NO_INHERIT_OBJC_LOADERS)
               list( REMOVE_AT _TMP_INHERIT_OBJC_LOADERS -1)
               list( REMOVE_ITEM CMAKE_MODULE_PATH "${_TMP_MULLE__DLFCN_DIR}")
               #
               unset( MULLE__DLFCN_DEFINITIONS)
               include( "${_TMP_MULLE__DLFCN_DIR}/Definitions.cmake" OPTIONAL)
               list( APPEND INHERITED_DEFINITIONS ${MULLE__DLFCN_DEFINITIONS})
               break()
            else()
               message( STATUS "${_TMP_MULLE__DLFCN_DIR} not found")
            endif()
         endforeach()
      else()
         # Disable with: `mulle-sourcetree mark mulle-dlfcn no-require-link`
         message( SEND_ERROR "MULLE__DLFCN_LIBRARY was not found")
      endif()
   endif()
endif()

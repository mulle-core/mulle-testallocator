#
# This file will be included by cmake/share/Files.cmake
#
# cmake/reflect/_Dependencies.cmake is generated by `mulle-sde reflect`.
# Edits will be lost.
#
# Disable generation of this file with:
#
# mulle-sde environment set MULLE_SOURCETREE_TO_CMAKE_DEPENDENCIES_FILE DISABLE
#
if( MULLE_TRACE_INCLUDE)
   message( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
endif()

#
# Generated from sourcetree: EFB20198-B38A-4725-B15A-85BB8206D940;mulle-thread;no-all-load,no-cmake-searchpath,no-import,no-singlephase;
# Disable with : `mulle-sourcetree mark mulle-thread no-link`
# Disable for this platform: `mulle-sourcetree mark mulle-thread no-cmake-platform-linux`
#
if( NOT MULLE_THREAD_LIBRARY)
   find_library( MULLE_THREAD_LIBRARY NAMES ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-thread${CMAKE_STATIC_LIBRARY_SUFFIX} mulle-thread NO_CMAKE_SYSTEM_PATH NO_SYSTEM_ENVIRONMENT_PATH)
   message( STATUS "MULLE_THREAD_LIBRARY is ${MULLE_THREAD_LIBRARY}")
   #
   # The order looks ascending, but due to the way this file is read
   # it ends up being descending, which is what we need.
   #
   if( MULLE_THREAD_LIBRARY)
      #
      # Add MULLE_THREAD_LIBRARY to DEPENDENCY_LIBRARIES list.
      # Disable with: `mulle-sourcetree mark mulle-thread no-cmake-add`
      #
      set( DEPENDENCY_LIBRARIES
         ${DEPENDENCY_LIBRARIES}
         ${MULLE_THREAD_LIBRARY}
         CACHE INTERNAL "need to cache this"
      )
      #
      # Inherit ObjC loader and link dependency info.
      # Disable with: `mulle-sourcetree mark mulle-thread no-cmake-inherit`
      #
      # temporarily expand CMAKE_MODULE_PATH
      get_filename_component( _TMP_MULLE_THREAD_ROOT "${MULLE_THREAD_LIBRARY}" DIRECTORY)
      get_filename_component( _TMP_MULLE_THREAD_ROOT "${_TMP_MULLE_THREAD_ROOT}" DIRECTORY)
      #
      #
      # Search for "DependenciesAndLibraries.cmake" to include.
      # Disable with: `mulle-sourcetree mark mulle-thread no-cmake-dependency`
      #
      foreach( _TMP_MULLE_THREAD_NAME "mulle-thread")
         set( _TMP_MULLE_THREAD_DIR "${_TMP_MULLE_THREAD_ROOT}/include/${_TMP_MULLE_THREAD_NAME}/cmake")
         # use explicit path to avoid "surprises"
         if( EXISTS "${_TMP_MULLE_THREAD_DIR}/DependenciesAndLibraries.cmake")
            unset( MULLE_THREAD_DEFINITIONS)
            list( INSERT CMAKE_MODULE_PATH 0 "${_TMP_MULLE_THREAD_DIR}")
            # we only want top level INHERIT_OBJC_LOADERS, so disable them
            if( NOT NO_INHERIT_OBJC_LOADERS)
               set( NO_INHERIT_OBJC_LOADERS OFF)
            endif()
            list( APPEND _TMP_INHERIT_OBJC_LOADERS ${NO_INHERIT_OBJC_LOADERS})
            set( NO_INHERIT_OBJC_LOADERS ON)
            #
            include( "${_TMP_MULLE_THREAD_DIR}/DependenciesAndLibraries.cmake")
            #
            list( GET _TMP_INHERIT_OBJC_LOADERS -1 NO_INHERIT_OBJC_LOADERS)
            list( REMOVE_AT _TMP_INHERIT_OBJC_LOADERS -1)
            #
            list( REMOVE_ITEM CMAKE_MODULE_PATH "${_TMP_MULLE_THREAD_DIR}")
            set( INHERITED_DEFINITIONS
               ${INHERITED_DEFINITIONS}
               ${MULLE_THREAD_DEFINITIONS}
               CACHE INTERNAL "need to cache this"
            )
            break()
         else()
            message( STATUS "${_TMP_MULLE_THREAD_DIR}/DependenciesAndLibraries.cmake not found")
         endif()
      endforeach()
   else()
      message( FATAL_ERROR "MULLE_THREAD_LIBRARY was not found")
   endif()
endif()


#
# Generated from sourcetree: 1636C30E-73CC-482C-98E5-F5FBBAF609A3;mulle-allocator;no-all-load,no-cmake-searchpath,no-import,no-singlephase;
# Disable with : `mulle-sourcetree mark mulle-allocator no-link`
# Disable for this platform: `mulle-sourcetree mark mulle-allocator no-cmake-platform-linux`
#
if( NOT MULLE_ALLOCATOR_LIBRARY)
   find_library( MULLE_ALLOCATOR_LIBRARY NAMES ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-allocator${CMAKE_STATIC_LIBRARY_SUFFIX} mulle-allocator NO_CMAKE_SYSTEM_PATH NO_SYSTEM_ENVIRONMENT_PATH)
   message( STATUS "MULLE_ALLOCATOR_LIBRARY is ${MULLE_ALLOCATOR_LIBRARY}")
   #
   # The order looks ascending, but due to the way this file is read
   # it ends up being descending, which is what we need.
   #
   if( MULLE_ALLOCATOR_LIBRARY)
      #
      # Add MULLE_ALLOCATOR_LIBRARY to DEPENDENCY_LIBRARIES list.
      # Disable with: `mulle-sourcetree mark mulle-allocator no-cmake-add`
      #
      set( DEPENDENCY_LIBRARIES
         ${DEPENDENCY_LIBRARIES}
         ${MULLE_ALLOCATOR_LIBRARY}
         CACHE INTERNAL "need to cache this"
      )
      #
      # Inherit ObjC loader and link dependency info.
      # Disable with: `mulle-sourcetree mark mulle-allocator no-cmake-inherit`
      #
      # temporarily expand CMAKE_MODULE_PATH
      get_filename_component( _TMP_MULLE_ALLOCATOR_ROOT "${MULLE_ALLOCATOR_LIBRARY}" DIRECTORY)
      get_filename_component( _TMP_MULLE_ALLOCATOR_ROOT "${_TMP_MULLE_ALLOCATOR_ROOT}" DIRECTORY)
      #
      #
      # Search for "DependenciesAndLibraries.cmake" to include.
      # Disable with: `mulle-sourcetree mark mulle-allocator no-cmake-dependency`
      #
      foreach( _TMP_MULLE_ALLOCATOR_NAME "mulle-allocator")
         set( _TMP_MULLE_ALLOCATOR_DIR "${_TMP_MULLE_ALLOCATOR_ROOT}/include/${_TMP_MULLE_ALLOCATOR_NAME}/cmake")
         # use explicit path to avoid "surprises"
         if( EXISTS "${_TMP_MULLE_ALLOCATOR_DIR}/DependenciesAndLibraries.cmake")
            unset( MULLE_ALLOCATOR_DEFINITIONS)
            list( INSERT CMAKE_MODULE_PATH 0 "${_TMP_MULLE_ALLOCATOR_DIR}")
            # we only want top level INHERIT_OBJC_LOADERS, so disable them
            if( NOT NO_INHERIT_OBJC_LOADERS)
               set( NO_INHERIT_OBJC_LOADERS OFF)
            endif()
            list( APPEND _TMP_INHERIT_OBJC_LOADERS ${NO_INHERIT_OBJC_LOADERS})
            set( NO_INHERIT_OBJC_LOADERS ON)
            #
            include( "${_TMP_MULLE_ALLOCATOR_DIR}/DependenciesAndLibraries.cmake")
            #
            list( GET _TMP_INHERIT_OBJC_LOADERS -1 NO_INHERIT_OBJC_LOADERS)
            list( REMOVE_AT _TMP_INHERIT_OBJC_LOADERS -1)
            #
            list( REMOVE_ITEM CMAKE_MODULE_PATH "${_TMP_MULLE_ALLOCATOR_DIR}")
            set( INHERITED_DEFINITIONS
               ${INHERITED_DEFINITIONS}
               ${MULLE_ALLOCATOR_DEFINITIONS}
               CACHE INTERNAL "need to cache this"
            )
            break()
         else()
            message( STATUS "${_TMP_MULLE_ALLOCATOR_DIR}/DependenciesAndLibraries.cmake not found")
         endif()
      endforeach()
   else()
      message( FATAL_ERROR "MULLE_ALLOCATOR_LIBRARY was not found")
   endif()
endif()


#
# Generated from sourcetree: DC0E6DE2-37B0-4CCF-BF12-F0C5C7F3A994;mulle-stacktrace;no-all-load,no-cmake-searchpath,no-import,no-public,no-singlephase;
# Disable with : `mulle-sourcetree mark mulle-stacktrace no-link`
# Disable for this platform: `mulle-sourcetree mark mulle-stacktrace no-cmake-platform-linux`
#
if( NOT MULLE_STACKTRACE_LIBRARY)
   find_library( MULLE_STACKTRACE_LIBRARY NAMES ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-stacktrace${CMAKE_STATIC_LIBRARY_SUFFIX} mulle-stacktrace NO_CMAKE_SYSTEM_PATH NO_SYSTEM_ENVIRONMENT_PATH)
   message( STATUS "MULLE_STACKTRACE_LIBRARY is ${MULLE_STACKTRACE_LIBRARY}")
   #
   # The order looks ascending, but due to the way this file is read
   # it ends up being descending, which is what we need.
   #
   if( MULLE_STACKTRACE_LIBRARY)
      #
      # Add MULLE_STACKTRACE_LIBRARY to DEPENDENCY_LIBRARIES list.
      # Disable with: `mulle-sourcetree mark mulle-stacktrace no-cmake-add`
      #
      set( DEPENDENCY_LIBRARIES
         ${DEPENDENCY_LIBRARIES}
         ${MULLE_STACKTRACE_LIBRARY}
         CACHE INTERNAL "need to cache this"
      )
      #
      # Inherit ObjC loader and link dependency info.
      # Disable with: `mulle-sourcetree mark mulle-stacktrace no-cmake-inherit`
      #
      # temporarily expand CMAKE_MODULE_PATH
      get_filename_component( _TMP_MULLE_STACKTRACE_ROOT "${MULLE_STACKTRACE_LIBRARY}" DIRECTORY)
      get_filename_component( _TMP_MULLE_STACKTRACE_ROOT "${_TMP_MULLE_STACKTRACE_ROOT}" DIRECTORY)
      #
      #
      # Search for "DependenciesAndLibraries.cmake" to include.
      # Disable with: `mulle-sourcetree mark mulle-stacktrace no-cmake-dependency`
      #
      foreach( _TMP_MULLE_STACKTRACE_NAME "mulle-stacktrace")
         set( _TMP_MULLE_STACKTRACE_DIR "${_TMP_MULLE_STACKTRACE_ROOT}/include/${_TMP_MULLE_STACKTRACE_NAME}/cmake")
         # use explicit path to avoid "surprises"
         if( EXISTS "${_TMP_MULLE_STACKTRACE_DIR}/DependenciesAndLibraries.cmake")
            unset( MULLE_STACKTRACE_DEFINITIONS)
            list( INSERT CMAKE_MODULE_PATH 0 "${_TMP_MULLE_STACKTRACE_DIR}")
            # we only want top level INHERIT_OBJC_LOADERS, so disable them
            if( NOT NO_INHERIT_OBJC_LOADERS)
               set( NO_INHERIT_OBJC_LOADERS OFF)
            endif()
            list( APPEND _TMP_INHERIT_OBJC_LOADERS ${NO_INHERIT_OBJC_LOADERS})
            set( NO_INHERIT_OBJC_LOADERS ON)
            #
            include( "${_TMP_MULLE_STACKTRACE_DIR}/DependenciesAndLibraries.cmake")
            #
            list( GET _TMP_INHERIT_OBJC_LOADERS -1 NO_INHERIT_OBJC_LOADERS)
            list( REMOVE_AT _TMP_INHERIT_OBJC_LOADERS -1)
            #
            list( REMOVE_ITEM CMAKE_MODULE_PATH "${_TMP_MULLE_STACKTRACE_DIR}")
            set( INHERITED_DEFINITIONS
               ${INHERITED_DEFINITIONS}
               ${MULLE_STACKTRACE_DEFINITIONS}
               CACHE INTERNAL "need to cache this"
            )
            break()
         else()
            message( STATUS "${_TMP_MULLE_STACKTRACE_DIR}/DependenciesAndLibraries.cmake not found")
         endif()
      endforeach()
   else()
      message( FATAL_ERROR "MULLE_STACKTRACE_LIBRARY was not found")
   endif()
endif()


#
# Generated from sourcetree: 5A3C4A8D-C513-491E-A254-FCB2EAA4F8DE;mulle-atinit;no-cmake-searchpath,no-dynamic-link,no-import,no-intermediate-link,no-public,no-singlephase;
# Disable with : `mulle-sourcetree mark mulle-atinit no-link`
# Disable for this platform: `mulle-sourcetree mark mulle-atinit no-cmake-platform-linux`
#
if( NOT MULLE_ATINIT_LIBRARY)
   find_library( MULLE_ATINIT_LIBRARY NAMES ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-atinit${CMAKE_STATIC_LIBRARY_SUFFIX} mulle-atinit NO_CMAKE_SYSTEM_PATH NO_SYSTEM_ENVIRONMENT_PATH)
   message( STATUS "MULLE_ATINIT_LIBRARY is ${MULLE_ATINIT_LIBRARY}")
   #
   # The order looks ascending, but due to the way this file is read
   # it ends up being descending, which is what we need.
   #
   if( MULLE_ATINIT_LIBRARY)
      #
      # Add MULLE_ATINIT_LIBRARY to STARTUP_ALL_LOAD_DEPENDENCY_LIBRARIES list.
      # Disable with: `mulle-sourcetree mark mulle-atinit no-cmake-add`
      #
      set( STARTUP_ALL_LOAD_DEPENDENCY_LIBRARIES
         ${STARTUP_ALL_LOAD_DEPENDENCY_LIBRARIES}
         ${MULLE_ATINIT_LIBRARY}
         CACHE INTERNAL "need to cache this"
      )
      #
      # Inherit ObjC loader and link dependency info.
      # Disable with: `mulle-sourcetree mark mulle-atinit no-cmake-inherit`
      #
      # temporarily expand CMAKE_MODULE_PATH
      get_filename_component( _TMP_MULLE_ATINIT_ROOT "${MULLE_ATINIT_LIBRARY}" DIRECTORY)
      get_filename_component( _TMP_MULLE_ATINIT_ROOT "${_TMP_MULLE_ATINIT_ROOT}" DIRECTORY)
      #
      #
      # Search for "DependenciesAndLibraries.cmake" to include.
      # Disable with: `mulle-sourcetree mark mulle-atinit no-cmake-dependency`
      #
      foreach( _TMP_MULLE_ATINIT_NAME "mulle-atinit")
         set( _TMP_MULLE_ATINIT_DIR "${_TMP_MULLE_ATINIT_ROOT}/include/${_TMP_MULLE_ATINIT_NAME}/cmake")
         # use explicit path to avoid "surprises"
         if( EXISTS "${_TMP_MULLE_ATINIT_DIR}/DependenciesAndLibraries.cmake")
            unset( MULLE_ATINIT_DEFINITIONS)
            list( INSERT CMAKE_MODULE_PATH 0 "${_TMP_MULLE_ATINIT_DIR}")
            # we only want top level INHERIT_OBJC_LOADERS, so disable them
            if( NOT NO_INHERIT_OBJC_LOADERS)
               set( NO_INHERIT_OBJC_LOADERS OFF)
            endif()
            list( APPEND _TMP_INHERIT_OBJC_LOADERS ${NO_INHERIT_OBJC_LOADERS})
            set( NO_INHERIT_OBJC_LOADERS ON)
            #
            include( "${_TMP_MULLE_ATINIT_DIR}/DependenciesAndLibraries.cmake")
            #
            list( GET _TMP_INHERIT_OBJC_LOADERS -1 NO_INHERIT_OBJC_LOADERS)
            list( REMOVE_AT _TMP_INHERIT_OBJC_LOADERS -1)
            #
            list( REMOVE_ITEM CMAKE_MODULE_PATH "${_TMP_MULLE_ATINIT_DIR}")
            set( INHERITED_DEFINITIONS
               ${INHERITED_DEFINITIONS}
               ${MULLE_ATINIT_DEFINITIONS}
               CACHE INTERNAL "need to cache this"
            )
            break()
         else()
            message( STATUS "${_TMP_MULLE_ATINIT_DIR}/DependenciesAndLibraries.cmake not found")
         endif()
      endforeach()
      #
      # Search for "MulleObjCLoader+<name>.h" in include directory.
      # Disable with: `mulle-sourcetree mark mulle-atinit no-cmake-loader`
      #
      if( NOT NO_INHERIT_OBJC_LOADERS)
         foreach( _TMP_MULLE_ATINIT_NAME "mulle-atinit")
            set( _TMP_MULLE_ATINIT_FILE "${_TMP_MULLE_ATINIT_ROOT}/include/${_TMP_MULLE_ATINIT_NAME}/MulleObjCLoader+${_TMP_MULLE_ATINIT_NAME}.h")
            if( EXISTS "${_TMP_MULLE_ATINIT_FILE}")
               set( INHERITED_OBJC_LOADERS
                  ${INHERITED_OBJC_LOADERS}
                  ${_TMP_MULLE_ATINIT_FILE}
                  CACHE INTERNAL "need to cache this"
               )
               break()
            endif()
         endforeach()
      endif()
   else()
      message( FATAL_ERROR "MULLE_ATINIT_LIBRARY was not found")
   endif()
endif()


#
# Generated from sourcetree: DA08D176-9F38-434B-AFCD-FD83A249E6ED;mulle-atexit;no-cmake-searchpath,no-dynamic-link,no-import,no-intermediate-link,no-public,no-singlephase;
# Disable with : `mulle-sourcetree mark mulle-atexit no-link`
# Disable for this platform: `mulle-sourcetree mark mulle-atexit no-cmake-platform-linux`
#
if( NOT MULLE_ATEXIT_LIBRARY)
   find_library( MULLE_ATEXIT_LIBRARY NAMES ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-atexit${CMAKE_STATIC_LIBRARY_SUFFIX} mulle-atexit NO_CMAKE_SYSTEM_PATH NO_SYSTEM_ENVIRONMENT_PATH)
   message( STATUS "MULLE_ATEXIT_LIBRARY is ${MULLE_ATEXIT_LIBRARY}")
   #
   # The order looks ascending, but due to the way this file is read
   # it ends up being descending, which is what we need.
   #
   if( MULLE_ATEXIT_LIBRARY)
      #
      # Add MULLE_ATEXIT_LIBRARY to STARTUP_ALL_LOAD_DEPENDENCY_LIBRARIES list.
      # Disable with: `mulle-sourcetree mark mulle-atexit no-cmake-add`
      #
      set( STARTUP_ALL_LOAD_DEPENDENCY_LIBRARIES
         ${STARTUP_ALL_LOAD_DEPENDENCY_LIBRARIES}
         ${MULLE_ATEXIT_LIBRARY}
         CACHE INTERNAL "need to cache this"
      )
      #
      # Inherit ObjC loader and link dependency info.
      # Disable with: `mulle-sourcetree mark mulle-atexit no-cmake-inherit`
      #
      # temporarily expand CMAKE_MODULE_PATH
      get_filename_component( _TMP_MULLE_ATEXIT_ROOT "${MULLE_ATEXIT_LIBRARY}" DIRECTORY)
      get_filename_component( _TMP_MULLE_ATEXIT_ROOT "${_TMP_MULLE_ATEXIT_ROOT}" DIRECTORY)
      #
      #
      # Search for "DependenciesAndLibraries.cmake" to include.
      # Disable with: `mulle-sourcetree mark mulle-atexit no-cmake-dependency`
      #
      foreach( _TMP_MULLE_ATEXIT_NAME "mulle-atexit")
         set( _TMP_MULLE_ATEXIT_DIR "${_TMP_MULLE_ATEXIT_ROOT}/include/${_TMP_MULLE_ATEXIT_NAME}/cmake")
         # use explicit path to avoid "surprises"
         if( EXISTS "${_TMP_MULLE_ATEXIT_DIR}/DependenciesAndLibraries.cmake")
            unset( MULLE_ATEXIT_DEFINITIONS)
            list( INSERT CMAKE_MODULE_PATH 0 "${_TMP_MULLE_ATEXIT_DIR}")
            # we only want top level INHERIT_OBJC_LOADERS, so disable them
            if( NOT NO_INHERIT_OBJC_LOADERS)
               set( NO_INHERIT_OBJC_LOADERS OFF)
            endif()
            list( APPEND _TMP_INHERIT_OBJC_LOADERS ${NO_INHERIT_OBJC_LOADERS})
            set( NO_INHERIT_OBJC_LOADERS ON)
            #
            include( "${_TMP_MULLE_ATEXIT_DIR}/DependenciesAndLibraries.cmake")
            #
            list( GET _TMP_INHERIT_OBJC_LOADERS -1 NO_INHERIT_OBJC_LOADERS)
            list( REMOVE_AT _TMP_INHERIT_OBJC_LOADERS -1)
            #
            list( REMOVE_ITEM CMAKE_MODULE_PATH "${_TMP_MULLE_ATEXIT_DIR}")
            set( INHERITED_DEFINITIONS
               ${INHERITED_DEFINITIONS}
               ${MULLE_ATEXIT_DEFINITIONS}
               CACHE INTERNAL "need to cache this"
            )
            break()
         else()
            message( STATUS "${_TMP_MULLE_ATEXIT_DIR}/DependenciesAndLibraries.cmake not found")
         endif()
      endforeach()
      #
      # Search for "MulleObjCLoader+<name>.h" in include directory.
      # Disable with: `mulle-sourcetree mark mulle-atexit no-cmake-loader`
      #
      if( NOT NO_INHERIT_OBJC_LOADERS)
         foreach( _TMP_MULLE_ATEXIT_NAME "mulle-atexit")
            set( _TMP_MULLE_ATEXIT_FILE "${_TMP_MULLE_ATEXIT_ROOT}/include/${_TMP_MULLE_ATEXIT_NAME}/MulleObjCLoader+${_TMP_MULLE_ATEXIT_NAME}.h")
            if( EXISTS "${_TMP_MULLE_ATEXIT_FILE}")
               set( INHERITED_OBJC_LOADERS
                  ${INHERITED_OBJC_LOADERS}
                  ${_TMP_MULLE_ATEXIT_FILE}
                  CACHE INTERNAL "need to cache this"
               )
               break()
            endif()
         endforeach()
      endif()
   else()
      message( FATAL_ERROR "MULLE_ATEXIT_LIBRARY was not found")
   endif()
endif()

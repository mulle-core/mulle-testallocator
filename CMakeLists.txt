cmake_minimum_required( VERSION 3.13...99.99)

project( mulle-testallocator VERSION 5.2.0 LANGUAGES C)


### mulle-sde environment

# add cmake module paths to search path
list( INSERT CMAKE_MODULE_PATH 0 "${CMAKE_CURRENT_SOURCE_DIR}/cmake/share")
list( INSERT CMAKE_MODULE_PATH 0 "${CMAKE_CURRENT_SOURCE_DIR}/cmake/reflect")
list( INSERT CMAKE_MODULE_PATH 0 "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

include( Environment)

include( Files)

add_compile_options(-Wno-use-after-free -Wno-int-in-bool-context)

### Library

if( HEADERS_PHASE)
   install( FILES ${INSTALL_PUBLIC_HEADERS}  DESTINATION "include/mulle-testallocator")
   install( FILES ${INSTALL_PRIVATE_HEADERS} DESTINATION "include/mulle-testallocator")
   install( FILES ${INSTALL_CMAKE_INCLUDES}  DESTINATION "include/mulle-testallocator/cmake")

   # short cut out
   if( NOT COMPILE_PHASE AND NOT LINK_PHASE)
      return()
   endif()
endif()

if( LINK_PHASE)
   include( Dependencies OPTIONAL)
endif()

include( Library)

# use LIBRARY_COMPILE_TARGET for compiler options
target_compile_definitions( "${LIBRARY_COMPILE_TARGET}" PUBLIC)
target_compile_options( "${LIBRARY_COMPILE_TARGET}" PUBLIC)
if( NOT MSVC)
   target_compile_options( "${LIBRARY_COMPILE_TARGET}" PUBLIC -Wunused)
endif()

# use LIBRARY_LINK_TARGET for linker options
if( LINK_PHASE)
   target_link_options( "${LIBRARY_LINK_TARGET}" PUBLIC)
endif()

# keep reference to mulle-allocator open, don't link
if( LINK_PHASE AND APPLE)
   if( BUILD_SHARED_LIBS)
      target_link_libraries( "${LIBRARY_NAME}" "-undefined dynamic_lookup")
   endif()
endif()

include( InstallLibrary)

if( LINK_PHASE)
   include( InstallCMakeInclude)
   include( InstallCMakePackage)
endif() 

include( FinalOutput OPTIONAL)

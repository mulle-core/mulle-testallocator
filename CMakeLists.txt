cmake_minimum_required( VERSION 3.1)

project( mulle-testallocator C)


### mulle-sde environment

# add cmake module paths to search path
list( INSERT CMAKE_MODULE_PATH 0 "${PROJECT_SOURCE_DIR}/cmake/share")
list( INSERT CMAKE_MODULE_PATH 0 "${PROJECT_SOURCE_DIR}/cmake/reflect")
list( INSERT CMAKE_MODULE_PATH 0 "${PROJECT_SOURCE_DIR}/cmake")

include( Environment)

include( Files)

### Library

if( HEADERS_PHASE)
   install( FILES ${INSTALL_PUBLIC_HEADERS}  DESTINATION "include/mulle-testallocator")
   install( FILES ${INSTALL_PRIVATE_HEADERS} DESTINATION "include/mulle-testallocator/private")
   install( FILES ${CMAKE_INCLUDES}          DESTINATION "include/mulle-testallocator/cmake")

   # short cut out
   if( NOT COMPILE_PHASE AND NOT LINK_PHASE)
      return()
   endif()
endif()

if( LINK_PHASE)
   include( Dependencies OPTIONAL)
endif()

include( Library)

# keep reference to mulle-allocator open, don't link
if( LINK_PHASE AND APPLE)
   if( BUILD_SHARED_LIBS)
      target_link_libraries( "${LIBRARY_NAME}" "-undefined dynamic_lookup")
   endif()
endif()

include( InstallLibrary)
include( FinalOutput OPTIONAL)

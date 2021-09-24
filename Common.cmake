include_guard()

set(CMAKE_POSITION_INDEPENDENT_CODE ON)
enable_testing()
enable_language(CXX)

if (LANGUAGES_USE_CUDA)
    include(CheckLanguage)
    check_language(CUDA)
    enable_language(CUDA)
endif()

if (BUILD_SYSTEM_USE_CCACHE)
    find_program(CCACHE_PROGRAM ccache)
    mark_as_advanced(CCACHE_PROGRAM)

    if(CCACHE_PROGRAM)
        message(STATUS "Using ccache")
        set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE "${CCACHE_PROGRAM}")
    else()
        message(WARNING "ccache not found, not using it")
    endif()
endif()

if (BUILD_SHARED_LIBS)
    message(STATUS "Building dynamic libraries")
else()
    message(STATUS "Building static libraries")
endif()

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib")

execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_SOURCE_DIR}/cmake/CMakePresets.json ${CMAKE_SOURCE_DIR}/CMakePresets.json)
execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_SOURCE_DIR}/cmake/Utilities/IgnoreWarning.h ${CMAKE_SOURCE_DIR}/IgnoreWarning.h)
include_directories(${CMAKE_SOURCE_DIR})

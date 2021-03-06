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
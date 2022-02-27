include_guard()

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

    if ((NOT BUILD_SYSTEM_USE_DISTCC) AND (NOT BUILD_SYSTEM_USE_ICECC))
        if(CCACHE_PROGRAM)
            message(STATUS "Using ccache")
            set(CMAKE_CXX_COMPILER_LAUNCHER ${CCACHE_PROGRAM} CACHE STRING "")
        else()
            message(WARNING "ccache not found, not using it")
        endif()
    endif()
endif()

if (BUILD_SYSTEM_USE_DISTCC)
    find_program(DISTCC_PROGRAM distcc)
    mark_as_advanced(DISTCC_PROGRAM)

    if (BUILD_SYSTEM_USE_CCACHE AND CCACHE_PROGRAM)
        if(DISTCC_PROGRAM)
            message(STATUS "Using distcc with ccache")
            set(CMAKE_CXX_COMPILER_LAUNCHER "CCACHE_PREFIX=${DISTCC_PROGRAM} ${CCACHE_PROGRAM}" CACHE STRING "")
        else()
            message(WARNING "distcc not found, not using it")
        endif()
    else()
        if(DISTCC_PROGRAM)
            message(STATUS "Using distcc without ccache")
            set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE "${DISTCC_PROGRAM}")
        else()
            message(WARNING "distcc not found, not using it")
        endif()
    endif()
endif()

if (BUILD_SYSTEM_USE_ICECC)
    find_program(ICECC_PROGRAM icecc)
    mark_as_advanced(ICECC_PROGRAM)

    if (BUILD_SYSTEM_USE_CCACHE AND CCACHE_PROGRAM)
        if(DISTCC_PROGRAM)
            message(STATUS "Using icecc with ccache")
            set(CMAKE_CXX_COMPILER_LAUNCHER "CCACHE_PREFIX=${ICECC_PROGRAM} ${CCACHE_PROGRAM}" CACHE STRING "")
        else()
            message(WARNING "icecc not found, not using it")
        endif()
    else()
        if(DISTCC_PROGRAM)
            message(STATUS "Using icecc without ccache")
            set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE "${ICECC_PROGRAM}")
        else()
            message(WARNING "icecc not found, not using it")
        endif()
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

if (MISC_RUN_SYMLINK)
    if (NOT EXISTS ${CMAKE_SOURCE_DIR}/CMakePresets.json)
        file(COPY_FILE ${CMAKE_SOURCE_DIR}/cmake/CMakePresets.json ${CMAKE_SOURCE_DIR}/CMakePresets.json)
    endif()

    if (NOT EXISTS ${CMAKE_SOURCE_DIR}/IgnoreWarning.h)
        file(CREATE_LINK ${CMAKE_SOURCE_DIR}/cmake/Utilities/IgnoreWarning.h ${CMAKE_SOURCE_DIR}/IgnoreWarning.h SYMBOLIC)
    endif()

    if (NOT EXISTS ${CMAKE_SOURCE_DIR}/.pre-commit-config.yaml)
        file(CREATE_LINK ${CMAKE_SOURCE_DIR}/cmake/.pre-commit-config.yaml.in ${CMAKE_SOURCE_DIR}/.pre-commit-config.yaml SYMBOLIC)
    endif()

    if (NOT EXISTS ${CMAKE_SOURCE_DIR}/.clang-format)
        file(CREATE_LINK ${CMAKE_SOURCE_DIR}/cmake/.clang-format.in ${CMAKE_SOURCE_DIR}/.clang-format SYMBOLIC)
    endif()

    if (NOT EXISTS ${CMAKE_SOURCE_DIR}/.clang-tidy)
        file(CREATE_LINK ${CMAKE_SOURCE_DIR}/cmake/.clang-tidy.in ${CMAKE_SOURCE_DIR}/.clang-tidy SYMBOLIC)
    endif()

    if (NOT EXISTS ${CMAKE_SOURCE_DIR}/.gitignore)
        file(CREATE_LINK ${CMAKE_SOURCE_DIR}/cmake/.gitignore.in ${CMAKE_SOURCE_DIR}/.gitignore SYMBOLIC)
    endif()
endif()

include_directories(${CMAKE_SOURCE_DIR})

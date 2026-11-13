include_guard(GLOBAL)

# ==============================================================================
# Clang-Tidy Static Analysis Integration
# ==============================================================================
if (NOT TOOLS_USE_CLANG_TIDY)
    return()
endif()

find_program(CLANG_TIDY_PROGRAM NAMES clang-tidy clang-tidy-23 clang-tidy-22 clang-tidy-21 clang-tidy-20 clang-tidy-19 clang-tidy-18 clang-tidy-17 clang-tidy-16)
mark_as_advanced(CLANG_TIDY_PROGRAM)

if (NOT CLANG_TIDY_PROGRAM)
    message(FATAL_ERROR "TOOLS_USE_CLANG_TIDY is ON, but clang-tidy executable was not found.")
endif()

set(_tidy_cmd "${CLANG_TIDY_PROGRAM}" "-p=${CMAKE_BINARY_DIR}")
if (NOT EXISTS "${CMAKE_SOURCE_DIR}/.clang-tidy" AND EXISTS "${CMAKE_UTILS_ROOT}/.clang-tidy.in")
    list(APPEND _tidy_cmd "--config-file=${CMAKE_UTILS_ROOT}/.clang-tidy.in")
endif()
if (DETECTED_COMPILER_FLAVOR STREQUAL "GCC")
    list(APPEND _tidy_cmd "--extra-arg=-Wno-unknown-warning-option")
    # GCC C++20 module scanning passes -fmodules-ts/-fdeps-format=p1689r5/-fmodule-mapper
    # flags that clang-tidy's Clang driver rejects with [clang-diagnostic-error].
    set(CMAKE_CXX_SCAN_FOR_MODULES OFF CACHE BOOL "Disable C++ module scanning during GCC clang-tidy runs" FORCE)
endif()
if (TOOLS_CLANG_TIDY_WERROR)
    list(APPEND _tidy_cmd "--warnings-as-errors=*")
endif()
if (TOOLS_CLANG_TIDY_FIX)
    list(APPEND _tidy_cmd "--fix" "--fix-errors")
endif()

message(STATUS "Using clang-tidy: ${_tidy_cmd}")
set(CMAKE_CXX_CLANG_TIDY "${_tidy_cmd}" CACHE STRING "" FORCE)

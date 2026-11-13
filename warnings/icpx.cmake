include_guard(GLOBAL)

# ==============================================================================
# Intel oneAPI icpx (IntelLLVM) Warning Flags (2021 -> 2026+)
# Probes internal __clang_major__/__clang_minor__ with calendar-year fallback.
# ==============================================================================
set(_EFFECTIVE_CLANG_VERSION "")

if (CMAKE_CXX_COMPILER)
    execute_process(
        COMMAND "${CMAKE_CXX_COMPILER}" -x c++ -dM -E -
        INPUT_FILE /dev/null
        OUTPUT_VARIABLE _icpx_macros
        ERROR_QUIET
    )
    if (_icpx_macros MATCHES "#define __clang_major__ ([0-9]+)" AND _icpx_macros MATCHES "#define __clang_minor__ ([0-9]+)")
        string(REGEX MATCH "#define __clang_major__ ([0-9]+)" _ "${_icpx_macros}")
        set(_icpx_clang_maj "${CMAKE_MATCH_1}")
        string(REGEX MATCH "#define __clang_minor__ ([0-9]+)" _ "${_icpx_macros}")
        set(_icpx_clang_min "${CMAKE_MATCH_1}")
        set(_EFFECTIVE_CLANG_VERSION "${_icpx_clang_maj}.${_icpx_clang_min}.0")
    endif()
endif()

if (NOT _EFFECTIVE_CLANG_VERSION)
    if (CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL "2026.0")
        set(_EFFECTIVE_CLANG_VERSION "20.0.0")
    elseif (CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL "2025.0")
        set(_EFFECTIVE_CLANG_VERSION "19.0.0")
    elseif (CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL "2024.0")
        set(_EFFECTIVE_CLANG_VERSION "17.0.0")
    elseif (CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL "2023.0")
        set(_EFFECTIVE_CLANG_VERSION "16.0.0")
    elseif (CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL "2022.0")
        set(_EFFECTIVE_CLANG_VERSION "14.0.0")
    else()
        set(_EFFECTIVE_CLANG_VERSION "13.0.0")
    endif()
endif()

include(${CMAKE_CURRENT_LIST_DIR}/clang.cmake)

if (WARNINGS_USE_PEDANTIC_WARNINGS)
    # IntelLLVM driver-specific reasonable exclusions
    list(APPEND PEDANTIC_WARNING_FLAGS
        -Wno-unused-command-line-argument
    )
endif()

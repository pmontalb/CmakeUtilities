include_guard(GLOBAL)

# ==============================================================================
# Clang Warning Flags (Version-Gated for Recent Clang: 13 -> 22+)
# Uses -Weverything with curated, version-gated exclusions for C++20+.
# Shared as base for AOCC, Emscripten, and IntelLLVM.
# ==============================================================================
list(APPEND WARNING_FLAGS -Wno-unknown-pragmas -Wno-unused-function)

if (NOT WARNINGS_USE_PEDANTIC_WARNINGS)
    return()
endif()

# Allow AOCC/IntelLLVM callers to pass effective Clang version override
if (NOT DEFINED _EFFECTIVE_CLANG_VERSION)
    set(_EFFECTIVE_CLANG_VERSION "${CMAKE_CXX_COMPILER_VERSION}")
endif()

message(STATUS "Enabling exhaustive Clang-style warnings (-Weverything, effective LLVM ${_EFFECTIVE_CLANG_VERSION})")

set(PEDANTIC_WARNING_FLAGS ${WARNING_FLAGS}
    -Weverything

    # Do not warn about incompatibility with pre-C++20 standards
    -Wno-c++98-compat
    -Wno-c++98-compat-pedantic
    -Wno-c++11-compat
    -Wno-c++14-compat
    -Wno-c++17-compat
    -Wno-pre-c++14-compat
    -Wno-pre-c++17-compat
    -Wno-pre-c++20-compat
    -Wno-pre-c++20-compat-pedantic
    -Wno-c++20-compat

    # Reasonable noise / C++ ecosystem exclusions
    -Wno-padded
    -Wno-switch-enum
    -Wno-covered-switch-default
    -Wno-weak-vtables
    -Wno-weak-template-vtables
    -Wno-exit-time-destructors
    -Wno-global-constructors
    -Wno-disabled-macro-expansion
    -Wno-reserved-id-macro
    -Wno-reserved-identifier
    -Wno-ctad-maybe-unsupported
    -Wno-poison-system-directories
)

# Clang 14-15 (2022)
if (_EFFECTIVE_CLANG_VERSION VERSION_GREATER_EQUAL "14.0" AND _EFFECTIVE_CLANG_VERSION VERSION_LESS "16.0")
    if (FLAGS_CPP_STANDARD GREATER_EQUAL 23)
        list(APPEND PEDANTIC_WARNING_FLAGS
            -Wno-pre-c++2b-compat
            -Wno-pre-c++2b-compat-pedantic
        )
    endif()
endif()

# Clang 16+ (2023)
if (_EFFECTIVE_CLANG_VERSION VERSION_GREATER_EQUAL "16.0")
    list(APPEND PEDANTIC_WARNING_FLAGS
        -Wno-unsafe-buffer-usage
    )
    if (FLAGS_CPP_STANDARD GREATER_EQUAL 23)
        list(APPEND PEDANTIC_WARNING_FLAGS
            -Wno-pre-c++23-compat
            -Wno-pre-c++23-compat-pedantic
        )
    endif()
endif()

# Clang 19+ (2024/2025)
if (_EFFECTIVE_CLANG_VERSION VERSION_GREATER_EQUAL "19.0")
    if (FLAGS_CPP_STANDARD GREATER_EQUAL 26)
        list(APPEND PEDANTIC_WARNING_FLAGS
            -Wno-pre-c++26-compat
            -Wno-pre-c++26-compat-pedantic
        )
    endif()
endif()

# Clang 22+ (2026)
if (_EFFECTIVE_CLANG_VERSION VERSION_GREATER_EQUAL "22.0")
    list(APPEND PEDANTIC_WARNING_FLAGS
        -Wno-lifetime-safety-intra-tu-suggestions
        -Wno-lifetime-safety-intra-tu-constructor-suggestions
    )
endif()

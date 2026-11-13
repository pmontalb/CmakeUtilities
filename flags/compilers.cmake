include_guard(GLOBAL)

# ==============================================================================
# Compiler Flavor Detection & Recent-Version Checks (Last ~5 Years: 2021-2026)
# Supported: GCC (11+), Clang (13+), IntelLLVM/icpx (2021+), AOCC (3.2+), Emscripten (2.0+)
# ==============================================================================
if (NOT COMPILER_FLAVOR STREQUAL "AUTO" AND NOT COMPILER_FLAVOR STREQUAL "")
    set(DETECTED_COMPILER_FLAVOR "${COMPILER_FLAVOR}")
elseif (EMSCRIPTEN OR CMAKE_SYSTEM_NAME STREQUAL "Emscripten")
    set(DETECTED_COMPILER_FLAVOR "Emscripten")
elseif (CMAKE_CXX_COMPILER_ID STREQUAL "IntelLLVM")
    set(DETECTED_COMPILER_FLAVOR "IntelLLVM")
elseif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    set(DETECTED_COMPILER_FLAVOR "GCC")
elseif (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    # Distinguish AMD AOCC from upstream Clang
    if (CMAKE_CXX_COMPILER MATCHES "aocc|AOCC" OR CMAKE_CXX_COMPILER_VERSION MATCHES "AOCC")
        set(DETECTED_COMPILER_FLAVOR "AOCC")
    else()
        execute_process(
            COMMAND "${CMAKE_CXX_COMPILER}" --version
            OUTPUT_VARIABLE _clang_ver_out
            ERROR_QUIET
            OUTPUT_STRIP_TRAILING_WHITESPACE
        )
        if (_clang_ver_out MATCHES "AOCC|AMD")
            set(DETECTED_COMPILER_FLAVOR "AOCC")
        else()
            set(DETECTED_COMPILER_FLAVOR "Clang")
        endif()
    endif()
elseif (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    set(DETECTED_COMPILER_FLAVOR "MSVC")
else()
    message(FATAL_ERROR "Unsupported compiler '${CMAKE_CXX_COMPILER_ID}'. Supported: GCC, Clang, IntelLLVM (icpx), AOCC, Emscripten.")
endif()

message(STATUS "Detected compiler flavor: ${DETECTED_COMPILER_FLAVOR} (${CMAKE_CXX_COMPILER_ID} ${CMAKE_CXX_COMPILER_VERSION})")

# Check 5-year recency window (warn if too old for C++20+ / modern flags)
if (DETECTED_COMPILER_FLAVOR STREQUAL "GCC" AND CMAKE_CXX_COMPILER_VERSION VERSION_LESS "11.0")
    message(WARNING "GCC ${CMAKE_CXX_COMPILER_VERSION} is older than 5 years (GCC 11+ recommended); some warning/optimization flags may not work.")
elseif (DETECTED_COMPILER_FLAVOR STREQUAL "Clang" AND CMAKE_CXX_COMPILER_VERSION VERSION_LESS "13.0")
    message(WARNING "Clang ${CMAKE_CXX_COMPILER_VERSION} is older than 5 years (Clang 13+ recommended); some warning/optimization flags may not work.")
elseif (DETECTED_COMPILER_FLAVOR STREQUAL "IntelLLVM" AND CMAKE_CXX_COMPILER_VERSION VERSION_LESS "2021.1")
    message(WARNING "Intel oneAPI icpx ${CMAKE_CXX_COMPILER_VERSION} is older than 2021.1.")
endif()

# Normalize PIC & RTTI global settings
if (MISC_USE_POSITION_INDEPENDENT_CODE)
    set(CMAKE_POSITION_INDEPENDENT_CODE ON)
endif()

set(CMAKE_UTILS_RTTI_FLAGS "")
if (MISC_USE_RUNTIME_TYPE_INFO)
    if (DETECTED_COMPILER_FLAVOR STREQUAL "MSVC")
        set(CMAKE_UTILS_RTTI_FLAGS "/GR")
    else()
        set(CMAKE_UTILS_RTTI_FLAGS "-frtti")
    endif()
else()
    if (DETECTED_COMPILER_FLAVOR STREQUAL "MSVC")
        set(CMAKE_UTILS_RTTI_FLAGS "/GR-")
    else()
        set(CMAKE_UTILS_RTTI_FLAGS "-fno-rtti")
    endif()
endif()

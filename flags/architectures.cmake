include_guard(GLOBAL)

# ==============================================================================
# Architecture, 64-bit & Tuning Flags
# ==============================================================================
set(CMAKE_UTILS_ARCH_FLAGS "" CACHE STRING "" FORCE)
mark_as_advanced(CMAKE_UTILS_ARCH_FLAGS)

set(_arch_flags "")

# 64-bit target flags
if (LANGUAGES_USE_64_BITS)
    if (DETECTED_COMPILER_FLAVOR STREQUAL "Emscripten")
        # WASM64 requires explicit -sMEMORY64=1 (keep 32-bit default unless explicitly toggled for wasm64)
        if (EMSCRIPTEN_USE_MEMORY64)
            list(APPEND _arch_flags "-sMEMORY64=1")
        endif()
    elseif (NOT DETECTED_COMPILER_FLAVOR STREQUAL "MSVC" AND CMAKE_SYSTEM_PROCESSOR MATCHES "x86_64|AMD64|i.86")
        list(APPEND _arch_flags "-m64")
    endif()
endif()

# Emscripten targets WASM, not host x86/ARM CPU ISA
if (DETECTED_COMPILER_FLAVOR STREQUAL "Emscripten")
    if (EMSCRIPTEN_USE_SIMD)
        list(APPEND _arch_flags "-msimd128")
    endif()
    list(APPEND _arch_flags "-mbulk-memory" "-mnontrapping-fptoint")
else()
    # Host / Custom CPU Architecture & Tuning
    if (OPTIMIZATIONS_CUSTOM_ARCHITECTURE)
        if (DETECTED_COMPILER_FLAVOR STREQUAL "MSVC")
            list(APPEND _arch_flags "/arch:${OPTIMIZATIONS_CUSTOM_ARCHITECTURE}")
        else()
            list(APPEND _arch_flags "-march=${OPTIMIZATIONS_CUSTOM_ARCHITECTURE}")
        endif()
        message(STATUS "Using custom architecture: ${OPTIMIZATIONS_CUSTOM_ARCHITECTURE}")
    elseif (OPTIMIZATIONS_USE_NATIVE_ARCHITECTURE)
        if (DETECTED_COMPILER_FLAVOR STREQUAL "IntelLLVM")
            list(APPEND _arch_flags "-xHost")
            message(STATUS "Using native architecture: -xHost")
        elseif (DETECTED_COMPILER_FLAVOR STREQUAL "MSVC")
            message(WARNING "MSVC has no -march=native equivalent; skipping native architecture flag.")
        else()
            list(APPEND _arch_flags "-march=native")
            message(STATUS "Using native architecture: -march=native")
        endif()
    endif()

    if (OPTIMIZATIONS_CUSTOM_TUNING)
        if (NOT DETECTED_COMPILER_FLAVOR STREQUAL "MSVC")
            list(APPEND _arch_flags "-mtune=${OPTIMIZATIONS_CUSTOM_TUNING}")
            message(STATUS "Using custom tuning: -mtune=${OPTIMIZATIONS_CUSTOM_TUNING}")
        endif()
    elseif (OPTIMIZATIONS_USE_NATIVE_TUNING AND NOT OPTIMIZATIONS_USE_NATIVE_ARCHITECTURE AND NOT OPTIMIZATIONS_CUSTOM_ARCHITECTURE)
        if (NOT DETECTED_COMPILER_FLAVOR STREQUAL "MSVC")
            list(APPEND _arch_flags "-mtune=native")
            message(STATUS "Using native tuning: -mtune=native")
        endif()
    endif()
endif()

string(JOIN " " _arch_str ${_arch_flags})
set(CMAKE_UTILS_ARCH_FLAGS "${_arch_str}" CACHE STRING "" FORCE)

include_guard(GLOBAL)

# ==============================================================================
# Sanitizer Build Configurations (ASan, UBSan, TSan, MSan, LSan, AsanUbsan)
# Sets BOTH compile flags and linker flags!
# ==============================================================================
if (NOT CMAKE_BUILD_TYPE MATCHES "^(Asan|Ubsan|Tsan|Msan|Lsan|AsanUbsan)$")
    return()
endif()

if (DETECTED_COMPILER_FLAVOR STREQUAL "MSVC")
    if (CMAKE_BUILD_TYPE STREQUAL "Asan")
        set(CMAKE_CXX_FLAGS_ASAN "${CMAKE_UTILS_ARCH_FLAGS} /Zi /Od /fsanitize=address ${CMAKE_UTILS_RTTI_FLAGS}" CACHE STRING "" FORCE)
        mark_as_advanced(CMAKE_CXX_FLAGS_ASAN)
        return()
    endif()
    message(FATAL_ERROR "Sanitizer '${CMAKE_BUILD_TYPE}' is not supported on MSVC.")
endif()

string(JOIN " " _common_cxx_str ${CMAKE_UTILS_COMMON_CXX_FLAGS})
set(_san_base_flags "-ggdb3 -O1 -fno-omit-frame-pointer -fno-optimize-sibling-calls")

if (CMAKE_BUILD_TYPE STREQUAL "Asan")
    set(_san_flags "-fsanitize=address -fsanitize-address-use-after-scope")
elseif (CMAKE_BUILD_TYPE STREQUAL "Lsan")
    set(_san_flags "-fsanitize=leak")
elseif (CMAKE_BUILD_TYPE STREQUAL "Tsan")
    if (DETECTED_COMPILER_FLAVOR STREQUAL "Emscripten")
        message(FATAL_ERROR "ThreadSanitizer (Tsan) is not supported with Emscripten.")
    endif()
    set(_san_flags "-fsanitize=thread")
elseif (CMAKE_BUILD_TYPE STREQUAL "Msan")
    if (NOT DETECTED_COMPILER_FLAVOR MATCHES "^(Clang|AOCC)$")
        message(FATAL_ERROR "MemorySanitizer (Msan) is only supported on Clang/AOCC.")
    endif()
    set(_san_flags "-fsanitize=memory -fsanitize-memory-track-origins=2")
elseif (CMAKE_BUILD_TYPE STREQUAL "Ubsan")
    if (DETECTED_COMPILER_FLAVOR MATCHES "^(Clang|AOCC|IntelLLVM|Emscripten)$")
        set(_san_flags "-DCLANG_UBSAN -fsanitize=undefined,nullability,bounds,float-divide-by-zero -fno-sanitize-recover=all")
    else()
        set(_san_flags "-fsanitize=undefined,float-divide-by-zero,float-cast-overflow -fno-sanitize-recover=all")
    endif()
elseif (CMAKE_BUILD_TYPE STREQUAL "AsanUbsan")
    if (DETECTED_COMPILER_FLAVOR MATCHES "^(Clang|AOCC|IntelLLVM|Emscripten)$")
        set(_san_flags "-DCLANG_UBSAN -fsanitize=address,undefined,nullability,bounds,float-divide-by-zero -fsanitize-address-use-after-scope -fno-sanitize-recover=all")
    else()
        set(_san_flags "-fsanitize=address,undefined,float-divide-by-zero,float-cast-overflow -fsanitize-address-use-after-scope -fno-sanitize-recover=all")
    endif()
endif()

set(CMAKE_CXX_FLAGS_${CMAKE_UTILS_CONFIG_UPPER}
    "${CMAKE_UTILS_ARCH_FLAGS} ${_san_base_flags} ${_san_flags} ${_common_cxx_str} ${CMAKE_UTILS_RTTI_FLAGS}"
    CACHE STRING "" FORCE)
set(CMAKE_EXE_LINKER_FLAGS_${CMAKE_UTILS_CONFIG_UPPER} "${_san_flags}" CACHE STRING "" FORCE)
# Clang/LLVM does not link ASan runtime into shared libraries (the executable provides it);
# omitting it from shared linker flags prevents nvcc's GCC host linker from pulling in GCC's
# incompatible libasan.so alongside Clang's ASan runtime.
if (DETECTED_COMPILER_FLAVOR MATCHES "^(Clang|AOCC|IntelLLVM)$" AND CMAKE_BUILD_TYPE MATCHES "^(Asan|AsanUbsan)$")
    set(CMAKE_SHARED_LINKER_FLAGS_${CMAKE_UTILS_CONFIG_UPPER} "" CACHE STRING "" FORCE)
else()
    set(CMAKE_SHARED_LINKER_FLAGS_${CMAKE_UTILS_CONFIG_UPPER} "${_san_flags}" CACHE STRING "" FORCE)
endif()

mark_as_advanced(
    CMAKE_CXX_FLAGS_${CMAKE_UTILS_CONFIG_UPPER}
    CMAKE_EXE_LINKER_FLAGS_${CMAKE_UTILS_CONFIG_UPPER}
    CMAKE_SHARED_LINKER_FLAGS_${CMAKE_UTILS_CONFIG_UPPER}
)

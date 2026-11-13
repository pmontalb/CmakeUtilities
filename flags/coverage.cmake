include_guard(GLOBAL)

# ==============================================================================
# Code Coverage Configuration (GCC gcov & LLVM source-based coverage)
# Sets BOTH compile flags and linker flags!
# ==============================================================================
if (NOT CMAKE_BUILD_TYPE STREQUAL "Coverage")
    return()
endif()

string(JOIN " " _common_cxx_str ${CMAKE_UTILS_COMMON_CXX_FLAGS})

if (DETECTED_COMPILER_FLAVOR MATCHES "^(Clang|AOCC)$")
    set(_cov_flags "-fprofile-instr-generate -fcoverage-mapping")
elseif (DETECTED_COMPILER_FLAVOR STREQUAL "GCC")
    set(_cov_flags "--coverage -fprofile-correction")
else()
    message(FATAL_ERROR "Code coverage is not supported on compiler '${DETECTED_COMPILER_FLAVOR}'.")
endif()

set(CMAKE_CXX_FLAGS_COVERAGE
    "${CMAKE_UTILS_ARCH_FLAGS} -ggdb3 -O0 -fno-inline ${_cov_flags} ${_common_cxx_str} ${CMAKE_UTILS_RTTI_FLAGS}"
    CACHE STRING "" FORCE)
set(CMAKE_EXE_LINKER_FLAGS_COVERAGE "${_cov_flags}" CACHE STRING "" FORCE)
set(CMAKE_SHARED_LINKER_FLAGS_COVERAGE "${_cov_flags}" CACHE STRING "" FORCE)

mark_as_advanced(CMAKE_CXX_FLAGS_COVERAGE CMAKE_EXE_LINKER_FLAGS_COVERAGE CMAKE_SHARED_LINKER_FLAGS_COVERAGE)

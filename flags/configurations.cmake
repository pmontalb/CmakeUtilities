include_guard(GLOBAL)

# ==============================================================================
# Build Configurations
# ==============================================================================
if (DETECTED_COMPILER_FLAVOR STREQUAL "Clang")
    set(_allowed_configs "Debug" "Release" "RelWithDebInfo" "MinSizeRel" "Profile" "Asan" "Ubsan" "Tsan" "Msan" "Lsan" "AsanUbsan" "Coverage" "IWYU")
elseif (DETECTED_COMPILER_FLAVOR STREQUAL "GCC")
    set(_allowed_configs "Debug" "Release" "RelWithDebInfo" "MinSizeRel" "Profile" "Asan" "Ubsan" "Tsan" "Lsan" "AsanUbsan" "Coverage")
elseif (DETECTED_COMPILER_FLAVOR STREQUAL "IntelLLVM")
    set(_allowed_configs "Debug" "Release" "RelWithDebInfo" "MinSizeRel" "Profile" "Asan" "Ubsan" "Tsan" "AsanUbsan")
elseif (DETECTED_COMPILER_FLAVOR STREQUAL "AOCC")
    set(_allowed_configs "Debug" "Release" "RelWithDebInfo" "MinSizeRel" "Profile" "Asan" "Ubsan" "Tsan" "AsanUbsan" "Coverage")
elseif (DETECTED_COMPILER_FLAVOR STREQUAL "Emscripten")
    set(_allowed_configs "Debug" "Release" "RelWithDebInfo" "MinSizeRel" "Asan" "Ubsan")
elseif (DETECTED_COMPILER_FLAVOR STREQUAL "MSVC")
    set(_allowed_configs "Debug" "Release" "RelWithDebInfo" "MinSizeRel" "Profile" "Asan")
endif()

if (NOT CMAKE_BUILD_TYPE)
    message(STATUS "Using Debug configuration as none was specified")
    set(CMAKE_BUILD_TYPE "Debug" CACHE STRING "Build type" FORCE)
endif()

set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS ${_allowed_configs})

if (NOT CMAKE_BUILD_TYPE IN_LIST _allowed_configs)
    message(FATAL_ERROR "Unsupported CMAKE_BUILD_TYPE '${CMAKE_BUILD_TYPE}' for compiler '${DETECTED_COMPILER_FLAVOR}'. Allowed: ${_allowed_configs}")
endif()

message(STATUS "Using ${CMAKE_BUILD_TYPE} configuration")

# Determine uppercase suffix for CMAKE_CXX_FLAGS_<CONFIG>
string(TOUPPER "${CMAKE_BUILD_TYPE}" CMAKE_UTILS_CONFIG_UPPER)

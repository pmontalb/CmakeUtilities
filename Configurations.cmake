include_guard()

if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
    set(CACHE CMAKE_BUILD_TYPE PROPERTY STRING "Debug" "Release" "Profile" "MinSizeRel" "RelWithDebInfo" "Asan" "Ubsan" "Tsan" "Stan" "Coverage" "IWYU")
elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
    set(CACHE CMAKE_BUILD_TYPE PROPERTY STRING "Debug" "Release" "Profile" "MinSizeRel" "RelWithDebInfo" "Asan" "Ubsan" "Tsan" "Coverage")
elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel")
    set(CACHE CMAKE_BUILD_TYPE PROPERTY STRING "Debug" "Release" "Profile" "MinSizeRel" "RelWithDebInfo")
elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
    set(CACHE CMAKE_BUILD_TYPE PROPERTY STRING "Debug" "Release" "Profile" "MinSizeRel" "RelWithDebInfo")
endif()

if (NOT CMAKE_BUILD_TYPE)
    message(STATUS "Using Debug configuration as none has been specified")
    set(CMAKE_BUILD_TYPE Debug CACHE STRING "Build type")
elseif(CMAKE_BUILD_TYPE STREQUAL "Debug")
    message(STATUS "Using Debug configuration")
elseif(CMAKE_BUILD_TYPE STREQUAL "Release")
    message(STATUS "Using Release configuration")
elseif(CMAKE_BUILD_TYPE STREQUAL "Profile")
    message(STATUS "Using Profile configuration")
elseif(CMAKE_BUILD_TYPE STREQUAL "RelWithDebInfo")
    message(STATUS "Using RelWithDebInfo configuration")
elseif(CMAKE_BUILD_TYPE STREQUAL "MinSizeRel")
    message(STATUS "Using MinSizeRel configuration")
elseif(CMAKE_BUILD_TYPE STREQUAL "Asan")
    message(STATUS "Using ASAN configuration")
elseif(CMAKE_BUILD_TYPE STREQUAL "Ubsan")
    message(STATUS "Using UBSAN configuration")
elseif(CMAKE_BUILD_TYPE STREQUAL "Tsan")
    message(STATUS "Using TSAN configuration")
elseif(CMAKE_BUILD_TYPE STREQUAL "Stan")
    message(STATUS "Using STAN configuration")
elseif(CMAKE_BUILD_TYPE STREQUAL "Coverage")
    message(STATUS "Using Coverage configuration")
elseif(CMAKE_BUILD_TYPE STREQUAL "IWYU")
    message(STATUS "Using IWYU configuration")
else()
    message(FATAL "Unknown configuration type: ${CMAKE_BUILD_TYPE}")
endif()

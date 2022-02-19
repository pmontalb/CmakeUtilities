
include_guard()

if (NOT "${CMAKE_BUILD_TYPE}" STREQUAL "Coverage")
    return()
endif()

if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
    set(CMAKE_CXX_FLAGS_COVERAGE "-ggdb3 -O0 -fno-inline -fprofile-instr-generate -fcoverage-mapping" CACHE STRING "" FORCE)
elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
    set(CMAKE_CXX_FLAGS_COVERAGE "-ggdb3 -O0 -fno-inline --coverage -fprofile-correction" CACHE STRING "" FORCE)
elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel")
    message(FATAL "icc not supported")
elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
    message(FATAL "MSVC not supported")
endif()

mark_as_advanced(CMAKE_CXX_FLAGS_COVERAGE)

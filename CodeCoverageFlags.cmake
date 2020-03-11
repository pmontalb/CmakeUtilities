
include_guard()

mark_as_advanced(CMAKE_CXX_FLAGS_COVERAGE)

if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
    set(CMAKE_CXX_FLAGS_COVERAGE "-ggdb3 -O0 -fprofile-instr-generate -fcoverage-mapping --coverage" CACHE STRING "" FORCE)
elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
    set(CMAKE_CXX_FLAGS_COVERAGE "-ggdb3 -O0 -fbranch-probabilities -fno-inline -fprofile-correction --coverage" CACHE STRING "" FORCE)
elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel")
    message(FATAL "icc not supported")
elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
    message(FATAL "MSVC not supported")
endif()
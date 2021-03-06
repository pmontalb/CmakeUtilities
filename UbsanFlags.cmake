include_guard()

mark_as_advanced(CMAKE_CXX_FLAGS_UBSAN)

if (NOT "${CMAKE_BUILD_TYPE}" STREQUAL "Ubsan")
    return()
endif()

if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
    set(CMAKE_CXX_FLAGS_UBSAN "-ggdb3 -O0 -fsanitize=undefined -fsanitize=integer -fsanitize=nullability" CACHE STRING "" FORCE)
elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
    set(CMAKE_CXX_FLAGS_UBSAN "-ggdb3 -O0 -fsanitize=undefined -fsanitize=float-divide-by-zero -fsanitize=float-cast-overflow" CACHE STRING "" FORCE)
elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel")
    message(FATAL "icc not supported")
elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
    message(FATAL "MSVC not supported")
endif()
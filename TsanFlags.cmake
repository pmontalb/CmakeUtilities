include_guard()

mark_as_advanced(CMAKE_CXX_FLAGS_TSAN)

if (NOT "${CMAKE_BUILD_TYPE}" STREQUAL "Tsan")
    return()
endif()

if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
    set(CMAKE_CXX_FLAGS_TSAN "-ggdb3 -O0 -fsanitize=thread" CACHE STRING "" FORCE)
elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
    set(CMAKE_CXX_FLAGS_TSAN "-ggdb3 -O0 -fsanitize=thread" CACHE STRING "" FORCE)
elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel")
    message(FATAL "icc not supported")
elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
    message(FATAL "MSVC not supported")
endif()
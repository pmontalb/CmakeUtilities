include_guard()

if (NOT "${CMAKE_BUILD_TYPE}" STREQUAL "Ubsan")
    return()
endif()

if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
    set(CMAKE_CXX_FLAGS_UBSAN "-DCLANG_UBSAN -ggdb3 -O0 -fsanitize=undefined,integer,nullability,implicit-conversion,bounds,float-divide-by-zero -fno-sanitize-recover -fno-omit-frame-pointer -fno-optimize-sibling-calls" CACHE STRING "" FORCE)
elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
    set(CMAKE_CXX_FLAGS_UBSAN "-ggdb3 -O0 -fsanitize=undefined,float-divide-by-zero,float-cast-overflow -fno-sanitize-recover -fno-omit-frame-pointer -fno-optimize-sibling-calls" CACHE STRING "" FORCE)
elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "IntelLLVM")
    message(FATAL "icc not supported")
elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
    message(FATAL "MSVC not supported")
endif()

mark_as_advanced(CMAKE_CXX_FLAGS_UBSAN)

include_guard()

if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
    set(CMAKE_CXX_FLAGS_ASAN "-ggdb3 -O0 -fsanitize=address -fsanitize-address-use-after-scope -fno-omit-frame-pointer -fno-optimize-sibling-calls" CACHE STRING "" FORCE)
elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
    set(CMAKE_CXX_FLAGS_ASAN "-ggdb3 -O0 -fsanitize=address -fsanitize-address-use-after-scope -fno-omit-frame-pointer -fno-optimize-sibling-calls" CACHE STRING "" FORCE)
elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel")
    message(FATAL "icc not supported")
elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
    message(FATAL "MSVC not supported")
endif()
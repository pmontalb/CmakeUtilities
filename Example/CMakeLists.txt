cmake_minimum_required(VERSION 3.28)
if (PROJECT_IS_TOP_LEVEL)
    project(CmakeUtilitiesExample LANGUAGES CXX)
endif()

if (EXISTS "${CMAKE_CURRENT_LIST_DIR}/../All.cmake")
    include("${CMAKE_CURRENT_LIST_DIR}/../All.cmake")
else()
    file(CREATE_LINK ../ Example/cmake SYMBOLIC)
    include(cmake/All.cmake)
endif()

if (NOT EMSCRIPTEN)
    create_library(
        NAME testMain
        SOURCES Main.cpp
        SYSTEM_DEPENDENCIES gtest pthread
    )
endif()

add_subdirectory(libcore)
add_subdirectory(lib1)
add_subdirectory(lib2)
add_subdirectory(lib3)
add_subdirectory(lib4)
add_subdirectory(lib5)
add_subdirectory(lib6)
add_subdirectory(libmsan)

if (LANGUAGES_USE_CUDA AND CMAKE_CUDA_COMPILER)
    add_subdirectory(libcuda)
endif()

if (EMSCRIPTEN)
    create_executable(
        NAME wasm_smoke
        SOURCES WasmSmoke.cpp
        DEPENDENCIES libcore lib1 lib3 lib5 lib6
    )

    find_program(NODE_EXECUTABLE NAMES node nodejs HINTS "$ENV{EMSDK_NODE}" "$ENV{EMSDK}/node" PATH_SUFFIXES bin)
    if (NODE_EXECUTABLE)
        add_test(NAME wasm_smoke.test COMMAND "${NODE_EXECUTABLE}" "$<TARGET_FILE:wasm_smoke>")
    endif()
endif()

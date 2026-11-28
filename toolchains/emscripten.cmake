# Portable CMake toolchain file for Emscripten (emcc / em++).
# Runs before project() so CMake discovers EMSDK without requiring the user
# to manually source emsdk_env.sh or hardcode a single install prefix.

set(_emsdk_toolchain "")

if (DEFINED ENV{EMSDK} AND EXISTS "$ENV{EMSDK}/upstream/emscripten/cmake/Modules/Platform/Emscripten.cmake")
    set(_emsdk_toolchain "$ENV{EMSDK}/upstream/emscripten/cmake/Modules/Platform/Emscripten.cmake")
endif()

if (NOT _emsdk_toolchain)
    foreach(_candidate IN ITEMS
            "$ENV{HOME}/emsdk"
            "/opt/emsdk"
            "/usr/local/emsdk"
            "C:/emsdk")
        if (EXISTS "${_candidate}/upstream/emscripten/cmake/Modules/Platform/Emscripten.cmake")
            set(_emsdk_toolchain "${_candidate}/upstream/emscripten/cmake/Modules/Platform/Emscripten.cmake")
            break()
        endif()
    endforeach()
endif()

if (NOT _emsdk_toolchain)
    find_program(_EMCC_EXECUTABLE NAMES emcc)
    if (_EMCC_EXECUTABLE)
        get_filename_component(_emcc_dir "${_EMCC_EXECUTABLE}" DIRECTORY)
        if (EXISTS "${_emcc_dir}/cmake/Modules/Platform/Emscripten.cmake")
            set(_emsdk_toolchain "${_emcc_dir}/cmake/Modules/Platform/Emscripten.cmake")
        endif()
    endif()
endif()

if (NOT _emsdk_toolchain)
    message(FATAL_ERROR
        "Could not locate Emscripten.cmake. Set the EMSDK environment variable or install emsdk in ~/emsdk or /opt/emsdk.")
endif()

include("${_emsdk_toolchain}")

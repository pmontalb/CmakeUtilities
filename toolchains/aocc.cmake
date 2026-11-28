# Portable CMake toolchain file for AMD AOCC (clang / clang++).
# Runs before project() so CMake discovers AOCC without requiring the user
# to manually source setenv_AOCC.sh or accidentally picking up system /usr/bin/clang++.

set(_aocc_search_hints "")
if (DEFINED ENV{AOCC_DIR} AND EXISTS "$ENV{AOCC_DIR}/bin")
    list(APPEND _aocc_search_hints "$ENV{AOCC_DIR}/bin")
endif()

set(_aocc_search_paths "")
file(GLOB _aocc_versioned_bins
    "/opt/AMD/aocc-compiler-*/bin"
    "$ENV{HOME}/AMD/aocc-compiler-*/bin"
    "/opt/aocc-compiler-*/bin"
)
if (_aocc_versioned_bins)
    list(SORT _aocc_versioned_bins ORDER DESCENDING)
    list(APPEND _aocc_search_paths ${_aocc_versioned_bins})
endif()

find_program(_AOCC_C_EXECUTABLE
    NAMES clang
    HINTS ${_aocc_search_hints}
    PATHS ${_aocc_search_paths}
    NO_DEFAULT_PATH
)
find_program(_AOCC_CXX_EXECUTABLE
    NAMES clang++
    HINTS ${_aocc_search_hints}
    PATHS ${_aocc_search_paths}
    NO_DEFAULT_PATH
)

if (NOT _AOCC_C_EXECUTABLE OR NOT _AOCC_CXX_EXECUTABLE)
    message(FATAL_ERROR
        "Could not locate AMD AOCC clang/clang++. Set AOCC_DIR or install AOCC under /opt/AMD/aocc-compiler-*.")
endif()

set(CMAKE_C_COMPILER "${_AOCC_C_EXECUTABLE}" CACHE FILEPATH "AMD AOCC C compiler")
set(CMAKE_CXX_COMPILER "${_AOCC_CXX_EXECUTABLE}" CACHE FILEPATH "AMD AOCC C++ compiler")

# Derive runtime library directory (../lib) dynamically from the discovered compiler path
get_filename_component(_aocc_bin_dir "${_AOCC_CXX_EXECUTABLE}" DIRECTORY)
get_filename_component(_aocc_root_dir "${_aocc_bin_dir}" DIRECTORY)
if (EXISTS "${_aocc_root_dir}/lib")
    list(APPEND CMAKE_BUILD_RPATH "${_aocc_root_dir}/lib")
    list(APPEND CMAKE_INSTALL_RPATH "${_aocc_root_dir}/lib")
endif()

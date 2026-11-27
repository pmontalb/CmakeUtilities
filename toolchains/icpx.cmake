# Portable CMake toolchain file for Intel oneAPI (icx / icpx).
# Runs before project() so CMake discovers icx/icpx without requiring the user
# to manually source Intel's setvars.sh or hardcode a single install prefix.

set(_icpx_search_hints "")
if (DEFINED ENV{CMPLR_ROOT} AND EXISTS "$ENV{CMPLR_ROOT}/bin")
    list(APPEND _icpx_search_hints "$ENV{CMPLR_ROOT}/bin")
endif()
if (DEFINED ENV{ONEAPI_ROOT} AND EXISTS "$ENV{ONEAPI_ROOT}/compiler/latest/bin")
    list(APPEND _icpx_search_hints "$ENV{ONEAPI_ROOT}/compiler/latest/bin")
endif()

set(_icpx_search_paths
    "/opt/intel/oneapi/compiler/latest/bin"
    "$ENV{HOME}/intel/oneapi/compiler/latest/bin"
    "C:/Program Files (x86)/Intel/oneAPI/compiler/latest/bin"
)

# Also probe versioned oneAPI compiler directories if 'latest' symlink is absent
file(GLOB _icpx_versioned_bins
    "/opt/intel/oneapi/compiler/*/bin"
    "$ENV{HOME}/intel/oneapi/compiler/*/bin"
)
if (_icpx_versioned_bins)
    list(SORT _icpx_versioned_bins ORDER DESCENDING)
    list(APPEND _icpx_search_paths ${_icpx_versioned_bins})
endif()

find_program(_ICX_EXECUTABLE
    NAMES icx
    HINTS ${_icpx_search_hints}
    PATHS ${_icpx_search_paths}
)
find_program(_ICPX_EXECUTABLE
    NAMES icpx
    HINTS ${_icpx_search_hints}
    PATHS ${_icpx_search_paths}
)

if (_ICX_EXECUTABLE)
    set(CMAKE_C_COMPILER "${_ICX_EXECUTABLE}" CACHE FILEPATH "Intel C compiler")
else()
    set(CMAKE_C_COMPILER "icx" CACHE FILEPATH "Intel C compiler")
endif()

if (_ICPX_EXECUTABLE)
    set(CMAKE_CXX_COMPILER "${_ICPX_EXECUTABLE}" CACHE FILEPATH "Intel C++ compiler")
    # Derive runtime library directory (../lib) dynamically from the discovered compiler path
    get_filename_component(_icpx_bin_dir "${_ICPX_EXECUTABLE}" DIRECTORY)
    get_filename_component(_icpx_root_dir "${_icpx_bin_dir}" DIRECTORY)
    if (EXISTS "${_icpx_root_dir}/lib")
        list(APPEND CMAKE_BUILD_RPATH "${_icpx_root_dir}/lib")
        list(APPEND CMAKE_INSTALL_RPATH "${_icpx_root_dir}/lib")
    endif()
else()
    set(CMAKE_CXX_COMPILER "icpx" CACHE FILEPATH "Intel C++ compiler")
endif()

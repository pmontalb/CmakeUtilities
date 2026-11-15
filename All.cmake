include_guard(GLOBAL)

cmake_minimum_required(VERSION 3.28)
if (DEFINED CMAKE_UTILS_ROOT)
    return()
endif()

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/Modules/")

# Determine the base directory of CmakeUtilities cleanly (works both standalone and as submodule)
set(CMAKE_UTILS_ROOT "${CMAKE_CURRENT_LIST_DIR}")

include(${CMAKE_UTILS_ROOT}/Options.cmake)
include(${CMAKE_UTILS_ROOT}/Common.cmake)

include(${CMAKE_UTILS_ROOT}/flags/standards.cmake)
include(${CMAKE_UTILS_ROOT}/flags/compilers.cmake)
include(${CMAKE_UTILS_ROOT}/flags/configurations.cmake)
include(${CMAKE_UTILS_ROOT}/flags/architectures.cmake)
include(${CMAKE_UTILS_ROOT}/flags/optimizations.cmake)
include(${CMAKE_UTILS_ROOT}/flags/debug.cmake)
include(${CMAKE_UTILS_ROOT}/flags/sanitizers.cmake)
include(${CMAKE_UTILS_ROOT}/flags/coverage.cmake)

include(${CMAKE_UTILS_ROOT}/warnings/warnings.cmake)
include(${CMAKE_UTILS_ROOT}/tools/tools.cmake)
include(${CMAKE_UTILS_ROOT}/TargetUtilities.cmake)

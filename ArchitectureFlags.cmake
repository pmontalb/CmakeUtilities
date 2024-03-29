include_guard()

set(ARCHI_FLAG "" CACHE STRING "")
mark_as_advanced(ARCHI_FLAG)

if (OPTIMIZATIONS_CUSTOM_TUNING)
    if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
        message(STATUS "Using -mtune=${OPTIMIZATIONS_CUSTOM_ARCHITECTURE}")
        set(ARCHI_FLAG -mtune=${OPTIMIZATIONS_CUSTOM_ARCHITECTURE})
    elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
        message(STATUS "Using -mtune=${OPTIMIZATIONS_CUSTOM_ARCHITECTURE}")
        set(ARCHI_FLAG -mtune=${OPTIMIZATIONS_CUSTOM_ARCHITECTURE})
    elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "IntelLLVM")
        message(STATUS "Using -x=${OPTIMIZATIONS_CUSTOM_ARCHITECTURE}")
        set(ARCHI_FLAG -x=${OPTIMIZATIONS_CUSTOM_ARCHITECTURE})
    elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
        message(FATAL "MSVC not supported")
    endif()
elseif (OPTIMIZATIONS_CUSTOM_ARCHITECTURE)
    if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
        message(STATUS "Using -march=${OPTIMIZATIONS_CUSTOM_ARCHITECTURE}")
        set(ARCHI_FLAG -march=${OPTIMIZATIONS_CUSTOM_ARCHITECTURE})
    elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
        message(STATUS "Using -march=${OPTIMIZATIONS_CUSTOM_ARCHITECTURE}")
        set(ARCHI_FLAG -march=${OPTIMIZATIONS_CUSTOM_ARCHITECTURE})
    elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "IntelLLVM")
        message(STATUS "Using -x=${OPTIMIZATIONS_CUSTOM_ARCHITECTURE}")
        set(ARCHI_FLAG -x=${OPTIMIZATIONS_CUSTOM_ARCHITECTURE})
    elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
        message(STATUS "Using /arch=${OPTIMIZATIONS_CUSTOM_ARCHITECTURE}")
        set(ARCHI_FLAG /arch:${OPTIMIZATIONS_CUSTOM_ARCHITECTURE})
    endif()
elseif (OPTIMIZATIONS_USE_NATIVE_TUNING)
    if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
        message(STATUS "Using -mtune=native")
        set(ARCHI_FLAG -mtune=native)
    elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
        message(STATUS "Using -mtune=native")
        set(ARCHI_FLAG -mtune=native)
    elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "IntelLLVM")
        message(STATUS "Using native architecture: -xhost")
        set(ARCHI_FLAG -xhost)
    elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
        message(FATAL "MSVC not supported")
    endif()
elseif (OPTIMIZATIONS_USE_NATIVE_ARCHITECTURE)
    if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
        message(STATUS "Using -march=native")
        set(ARCHI_FLAG -march=native)
    elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
        message(STATUS "Using -march=native")
        set(ARCHI_FLAG -march=native)
    elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "IntelLLVM")
        message(STATUS "Using -xHost")
        set(ARCHI_FLAG -xHost)
    elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
        message(FATAL "MSVC not supported")
    endif()
endif()

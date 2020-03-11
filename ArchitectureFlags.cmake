include_guard()

set(ARCHI_FLAG "")
mark_as_advanced(ARCHI_FLAG)

if (OPTIMIZATIONS_CUSTOM_TUNING)
    if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
        message(STATUS "Using -mtune=${OPTIMIZATIONS_CUSTOM_ARCHITECTURE}")
        set(ARCHI_FLAG -mtune=${OPTIMIZATIONS_CUSTOM_ARCHITECTURE})
    elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
        message(STATUS "Using -mtune=${OPTIMIZATIONS_CUSTOM_ARCHITECTURE}")
        set(ARCHI_FLAG -mtune=${OPTIMIZATIONS_CUSTOM_ARCHITECTURE})
    elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel")
        message(STATUS "Using -mtune=${OPTIMIZATIONS_CUSTOM_ARCHITECTURE}")
        set(ARCHI_FLAG -mtune=${OPTIMIZATIONS_CUSTOM_ARCHITECTURE})
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
    elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel")
        message(STATUS "Using -march=${OPTIMIZATIONS_CUSTOM_ARCHITECTURE}")
        set(ARCHI_FLAG -march=${OPTIMIZATIONS_CUSTOM_ARCHITECTURE})
    elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
        message(FATAL "MSVC not supported")
    endif()
elseif (OPTIMIZATIONS_USE_NATIVE_TUNING)
    if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
        message(STATUS "Using -mtune=native")
        set(ARCHI_FLAG -mtune=native)
    elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
        message(STATUS "Using -mtune=native")
        set(ARCHI_FLAG -mtune=${OPTIMIZATIONS_CUSTOM_ARCHITECTURE})
    elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel")
        message(STATUS "Using -mtune=native")
        set(ARCHI_FLAG -mtune=${OPTIMIZATIONS_CUSTOM_ARCHITECTURE})
    elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
        message(FATAL "MSVC not supported")
    endif()
elseif (OPTIMIZATIONS_USE_NATIVE_ARCHITECTURE)
    if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
        message(STATUS "Using -march=native")
        set(ARCHI_FLAG -march=native)
    elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
        message(STATUS "Using -march=native")
        set(ARCHI_FLAG -march=${OPTIMIZATIONS_CUSTOM_ARCHITECTURE})
    elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel")
        message(STATUS "Using -march=native")
        set(ARCHI_FLAG -march=${OPTIMIZATIONS_CUSTOM_ARCHITECTURE})
    elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
        message(FATAL "MSVC not supported")
    endif()
endif()
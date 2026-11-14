include_guard(GLOBAL)

# ==============================================================================
# Release, RelWithDebInfo, MinSizeRel & Profile Optimization Flags
# ==============================================================================
if (DETECTED_COMPILER_FLAVOR STREQUAL "GCC")
    include(${CMAKE_CURRENT_LIST_DIR}/compilers/gcc.cmake)
elseif (DETECTED_COMPILER_FLAVOR STREQUAL "Clang")
    include(${CMAKE_CURRENT_LIST_DIR}/compilers/clang.cmake)
elseif (DETECTED_COMPILER_FLAVOR STREQUAL "IntelLLVM")
    include(${CMAKE_CURRENT_LIST_DIR}/compilers/icpx.cmake)
elseif (DETECTED_COMPILER_FLAVOR STREQUAL "AOCC")
    include(${CMAKE_CURRENT_LIST_DIR}/compilers/aocc.cmake)
elseif (DETECTED_COMPILER_FLAVOR STREQUAL "Emscripten")
    include(${CMAKE_CURRENT_LIST_DIR}/compilers/emscripten.cmake)
elseif (DETECTED_COMPILER_FLAVOR STREQUAL "MSVC")
    include(${CMAKE_CURRENT_LIST_DIR}/compilers/msvc.cmake)
endif()

# Global language/ABI flags applied consistently across build types
set(CMAKE_UTILS_COMMON_CXX_FLAGS "")
if (OPTIMIZATIONS_DISABLE_EXCEPTIONS)
    if (DETECTED_COMPILER_FLAVOR STREQUAL "MSVC")
        message(STATUS "Disabling C++ exceptions: /EHs-c-")
        # Strip CMake's default /EHsc so /EHs-c- does not trigger D9025 override warnings
        string(REGEX REPLACE "(^| )/EH[a-zA-Z-]+" "" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}" CACHE STRING "" FORCE)
        list(APPEND CMAKE_UTILS_COMMON_CXX_FLAGS "/EHs-c-")
    else()
        message(STATUS "Disabling C++ exceptions: -fno-exceptions")
        list(APPEND CMAKE_UTILS_COMMON_CXX_FLAGS "-fno-exceptions")
    endif()
endif()

if (OPTIMIZATIONS_DO_NOT_OMIT_FRAME_POINTER AND NOT DETECTED_COMPILER_FLAVOR STREQUAL "MSVC")
    message(STATUS "Preserving frame pointers: -fno-omit-frame-pointer")
    list(APPEND CMAKE_UTILS_COMMON_CXX_FLAGS "-fno-omit-frame-pointer")
endif()

if (OPTIMIZATIONS_HIDDEN_VISIBILITY AND NOT DETECTED_COMPILER_FLAVOR STREQUAL "MSVC")
    list(APPEND CMAKE_UTILS_COMMON_CXX_FLAGS "-fvisibility=hidden" "-fvisibility-inlines-hidden")
endif()

# Release-family optimization flags
set(_rel_cxx_flags "")
set(_rel_link_flags "")

if (DETECTED_COMPILER_FLAVOR STREQUAL "MSVC")
    if (OPTIMIZATIONS_GENERATE_DEBUG_INFO)
        list(APPEND _rel_cxx_flags "/Z7")
        list(APPEND _rel_link_flags "/DEBUG")
    endif()

    if (OPTIMIZATIONS_USE_SECTIONS_GC)
        list(APPEND _rel_cxx_flags "/Gy")
        list(APPEND _rel_link_flags "/OPT:REF" "/OPT:ICF")
    endif()
else()
    if (OPTIMIZATIONS_GENERATE_DEBUG_INFO)
        list(APPEND _rel_cxx_flags "-g")
    endif()

    if (OPTIMIZATIONS_USE_SECTIONS_GC AND NOT DETECTED_COMPILER_FLAVOR STREQUAL "Emscripten")
        list(APPEND _rel_cxx_flags "-ffunction-sections" "-fdata-sections")
        if (APPLE)
            list(APPEND _rel_link_flags "-Wl,-dead_strip")
        else()
            list(APPEND _rel_link_flags "-Wl,--gc-sections" "-Wl,-O1" "-Wl,--as-needed")
        endif()
    endif()

    # Improve devirtualization & inlining for PIC / shared libraries (Linux/BSD ELF)
    if (OPTIMIZATIONS_NO_SEMANTIC_INTERPOSITION AND NOT APPLE AND NOT WIN32 AND NOT DETECTED_COMPILER_FLAVOR STREQUAL "Emscripten")
        # Supported by GCC 5+ and Clang 11+
        list(APPEND _rel_cxx_flags "-fno-semantic-interposition")
    endif()

    if (OPTIMIZATIONS_UNROLL_LOOPS)
        list(APPEND _rel_cxx_flags "-funroll-loops")
    endif()
endif()

list(APPEND _rel_cxx_flags ${COMPILER_OPT_CXX_FLAGS})
list(APPEND _rel_link_flags ${COMPILER_OPT_LINK_FLAGS})

string(JOIN " " _common_cxx_str ${CMAKE_UTILS_COMMON_CXX_FLAGS})
string(JOIN " " _rel_cxx_str ${_rel_cxx_flags})
string(JOIN " " _rel_link_str ${_rel_link_flags})

if (DETECTED_COMPILER_FLAVOR STREQUAL "MSVC")
    set(CMAKE_CXX_FLAGS_RELEASE "/DNDEBUG ${CMAKE_UTILS_ARCH_FLAGS} /O2 /Ob2 ${_common_cxx_str} ${CMAKE_UTILS_RTTI_FLAGS} ${_rel_cxx_str}" CACHE STRING "" FORCE)
    set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "/DNDEBUG ${CMAKE_UTILS_ARCH_FLAGS} /O2 /Ob1 /Z7 ${_common_cxx_str} ${CMAKE_UTILS_RTTI_FLAGS} ${_rel_cxx_str}" CACHE STRING "" FORCE)
    set(CMAKE_CXX_FLAGS_MINSIZEREL "/DNDEBUG ${CMAKE_UTILS_ARCH_FLAGS} /O1 /Ob1 ${_common_cxx_str} ${CMAKE_UTILS_RTTI_FLAGS} ${_rel_cxx_str}" CACHE STRING "" FORCE)
    set(CMAKE_CXX_FLAGS_PROFILE "/DNDEBUG ${CMAKE_UTILS_ARCH_FLAGS} /O2 /Ob2 /Z7 /Oy- ${_common_cxx_str} ${CMAKE_UTILS_RTTI_FLAGS} ${_rel_cxx_str}" CACHE STRING "" FORCE)
else()
    set(CMAKE_CXX_FLAGS_RELEASE "-DNDEBUG ${CMAKE_UTILS_ARCH_FLAGS} -O3 ${_common_cxx_str} ${CMAKE_UTILS_RTTI_FLAGS} ${_rel_cxx_str}" CACHE STRING "" FORCE)
    set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-DNDEBUG ${CMAKE_UTILS_ARCH_FLAGS} -O2 -g ${_common_cxx_str} ${CMAKE_UTILS_RTTI_FLAGS} ${_rel_cxx_str}" CACHE STRING "" FORCE)
    set(CMAKE_CXX_FLAGS_MINSIZEREL "-DNDEBUG ${CMAKE_UTILS_ARCH_FLAGS} -Os ${_common_cxx_str} ${CMAKE_UTILS_RTTI_FLAGS} ${_rel_cxx_str}" CACHE STRING "" FORCE)
    set(CMAKE_CXX_FLAGS_PROFILE "-DNDEBUG ${CMAKE_UTILS_ARCH_FLAGS} -O3 -g -fno-omit-frame-pointer ${_common_cxx_str} ${CMAKE_UTILS_RTTI_FLAGS} ${_rel_cxx_str}" CACHE STRING "" FORCE)
endif()

set(CMAKE_EXE_LINKER_FLAGS_RELEASE "${_rel_link_str}" CACHE STRING "" FORCE)
set(CMAKE_SHARED_LINKER_FLAGS_RELEASE "${_rel_link_str}" CACHE STRING "" FORCE)

set(CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO "${_rel_link_str}" CACHE STRING "" FORCE)
set(CMAKE_SHARED_LINKER_FLAGS_RELWITHDEBINFO "${_rel_link_str}" CACHE STRING "" FORCE)

set(CMAKE_EXE_LINKER_FLAGS_MINSIZEREL "${_rel_link_str}" CACHE STRING "" FORCE)
set(CMAKE_SHARED_LINKER_FLAGS_MINSIZEREL "${_rel_link_str}" CACHE STRING "" FORCE)

set(CMAKE_EXE_LINKER_FLAGS_PROFILE "${_rel_link_str}" CACHE STRING "" FORCE)
set(CMAKE_SHARED_LINKER_FLAGS_PROFILE "${_rel_link_str}" CACHE STRING "" FORCE)

mark_as_advanced(
    CMAKE_CXX_FLAGS_RELEASE CMAKE_EXE_LINKER_FLAGS_RELEASE CMAKE_SHARED_LINKER_FLAGS_RELEASE
    CMAKE_CXX_FLAGS_RELWITHDEBINFO CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO CMAKE_SHARED_LINKER_FLAGS_RELWITHDEBINFO
    CMAKE_CXX_FLAGS_MINSIZEREL CMAKE_EXE_LINKER_FLAGS_MINSIZEREL CMAKE_SHARED_LINKER_FLAGS_MINSIZEREL
    CMAKE_CXX_FLAGS_PROFILE CMAKE_EXE_LINKER_FLAGS_PROFILE CMAKE_SHARED_LINKER_FLAGS_PROFILE
)

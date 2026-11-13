include_guard(GLOBAL)

# ==============================================================================
# Debug Build Flags
# ==============================================================================
set(CMAKE_UTILS_STL_DEBUG_FLAGS "")
if (DEBUG_USE_STL_DEBUG AND CMAKE_BUILD_TYPE STREQUAL "Debug")
    # _GLIBCXX_DEBUG only applies to GNU libstdc++ (skip Emscripten, MSVC, or Clang with libc++)
    if (DETECTED_COMPILER_FLAVOR STREQUAL "GCC")
        message(STATUS "Enabling GNU libstdc++ debug checks (_GLIBCXX_DEBUG)")
        set(CMAKE_UTILS_STL_DEBUG_FLAGS "-D_GLIBCXX_DEBUG -D_GLIBCXX_DEBUG_PEDANTIC")
    elseif (DETECTED_COMPILER_FLAVOR MATCHES "^(Clang|AOCC|IntelLLVM)$")
        # Only enable _GLIBCXX_DEBUG if not explicitly using libc++
        if (NOT CMAKE_CXX_FLAGS MATCHES "-stdlib=libc\\+\\+")
            message(STATUS "Enabling libstdc++ debug checks (_GLIBCXX_DEBUG)")
            set(CMAKE_UTILS_STL_DEBUG_FLAGS "-D_GLIBCXX_DEBUG -D_GLIBCXX_DEBUG_PEDANTIC")
        endif()
    endif()
endif()

string(JOIN " " _common_cxx_str ${CMAKE_UTILS_COMMON_CXX_FLAGS})

if (DETECTED_COMPILER_FLAVOR STREQUAL "MSVC")
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_UTILS_ARCH_FLAGS} /Z7 /Od ${_common_cxx_str} ${CMAKE_UTILS_RTTI_FLAGS}" CACHE STRING "" FORCE)
elseif (DETECTED_COMPILER_FLAVOR STREQUAL "IntelLLVM")
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_UTILS_ARCH_FLAGS} ${CMAKE_UTILS_STL_DEBUG_FLAGS} -g3 -O0 ${_common_cxx_str} ${CMAKE_UTILS_RTTI_FLAGS}" CACHE STRING "" FORCE)
else()
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_UTILS_ARCH_FLAGS} ${CMAKE_UTILS_STL_DEBUG_FLAGS} -ggdb3 -O0 ${_common_cxx_str} ${CMAKE_UTILS_RTTI_FLAGS}" CACHE STRING "" FORCE)
endif()

mark_as_advanced(CMAKE_CXX_FLAGS_DEBUG)

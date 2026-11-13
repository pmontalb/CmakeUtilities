include_guard(GLOBAL)

# ==============================================================================
# Include-What-You-Use (IWYU) Integration
# ==============================================================================
if (NOT TOOLS_USE_IWYU AND NOT CMAKE_BUILD_TYPE STREQUAL "IWYU")
    return()
endif()

if (NOT DETECTED_COMPILER_FLAVOR STREQUAL "Clang")
    message(FATAL_ERROR "Include-What-You-Use requires Clang (current: ${DETECTED_COMPILER_FLAVOR}).")
endif()

find_program(IWYU_PROGRAM include-what-you-use iwyu)
mark_as_advanced(IWYU_PROGRAM)
if (NOT IWYU_PROGRAM)
    message(FATAL_ERROR "Include-What-You-Use executable (include-what-you-use / iwyu) not found.")
endif()

message(STATUS "Using IWYU: ${IWYU_PROGRAM}")
set(CMAKE_CXX_INCLUDE_WHAT_YOU_USE "${IWYU_PROGRAM};-Xiwyu;--any;-Xiwyu;--iwyu;-Xiwyu;--args" CACHE STRING "" FORCE)

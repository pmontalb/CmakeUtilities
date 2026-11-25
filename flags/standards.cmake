include_guard(GLOBAL)

# ==============================================================================
# C++ Standard Enforcement (C++20 and upward only)
# ==============================================================================
if (NOT FLAGS_CPP_STANDARD)
    set(FLAGS_CPP_STANDARD 20 CACHE STRING "C++ standard (20, 23, 26)" FORCE)
endif()

if (NOT FLAGS_CPP_STANDARD MATCHES "^(20|23|26)$")
    message(FATAL_ERROR "Unsupported C++ standard '${FLAGS_CPP_STANDARD}'. Only C++20 and upward (20, 23, 26) are supported.")
endif()

message(STATUS "Using C++${FLAGS_CPP_STANDARD} standard (extensions OFF)")

set(CMAKE_CXX_STANDARD ${FLAGS_CPP_STANDARD})
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

if (NOT DEFINED CMAKE_CXX_SCAN_FOR_MODULES)
    set(CMAKE_CXX_SCAN_FOR_MODULES OFF)
endif()
if (NOT DEFINED CMAKE_CXX_MODULE_STD)
    set(CMAKE_CXX_MODULE_STD OFF)
endif()

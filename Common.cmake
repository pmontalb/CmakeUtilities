include_guard(GLOBAL)

option(BUILD_TESTING "Build the testing tree" ON)
if (BUILD_TESTING)
    enable_testing()
endif()
enable_language(CXX)

if (BUILD_SHARED_LIBS)
    message(STATUS "Building dynamic libraries")
else()
    message(STATUS "Building static libraries")
endif()

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib")

if (MISC_RUN_SYMLINK AND NOT CMAKE_SOURCE_DIR STREQUAL CMAKE_UTILS_ROOT)
    if (NOT EXISTS "${CMAKE_SOURCE_DIR}/CMakePresets.json" AND EXISTS "${CMAKE_UTILS_ROOT}/CMakePresets.json")
        file(RELATIVE_PATH _cmake_utils_rel "${CMAKE_SOURCE_DIR}" "${CMAKE_UTILS_ROOT}")
        file(READ "${CMAKE_UTILS_ROOT}/CMakePresets.json" _cmake_presets_content)
        string(REPLACE "\"preset/" "\"${_cmake_utils_rel}/preset/" _cmake_presets_content "${_cmake_presets_content}")
        file(WRITE "${CMAKE_SOURCE_DIR}/CMakePresets.json" "${_cmake_presets_content}")
    endif()

    if (NOT EXISTS "${CMAKE_SOURCE_DIR}/IgnoreWarning.h" AND EXISTS "${CMAKE_UTILS_ROOT}/Utilities/IgnoreWarning.h")
        file(COPY_FILE "${CMAKE_UTILS_ROOT}/Utilities/IgnoreWarning.h" "${CMAKE_SOURCE_DIR}/IgnoreWarning.h")
    endif()

    if (NOT EXISTS "${CMAKE_SOURCE_DIR}/.pre-commit-config.yaml" AND EXISTS "${CMAKE_UTILS_ROOT}/.pre-commit-config.yaml.in")
        file(COPY_FILE "${CMAKE_UTILS_ROOT}/.pre-commit-config.yaml.in" "${CMAKE_SOURCE_DIR}/.pre-commit-config.yaml")
    endif()

    if (NOT EXISTS "${CMAKE_SOURCE_DIR}/.clang-format" AND EXISTS "${CMAKE_UTILS_ROOT}/.clang-format.in")
        file(COPY_FILE "${CMAKE_UTILS_ROOT}/.clang-format.in" "${CMAKE_SOURCE_DIR}/.clang-format")
    endif()

    if (NOT EXISTS "${CMAKE_SOURCE_DIR}/.clang-tidy" AND EXISTS "${CMAKE_UTILS_ROOT}/.clang-tidy.in")
        file(COPY_FILE "${CMAKE_UTILS_ROOT}/.clang-tidy.in" "${CMAKE_SOURCE_DIR}/.clang-tidy")
    endif()

    if (NOT EXISTS "${CMAKE_SOURCE_DIR}/.gitignore" AND EXISTS "${CMAKE_UTILS_ROOT}/.gitignore.in")
        file(COPY_FILE "${CMAKE_UTILS_ROOT}/.gitignore.in" "${CMAKE_SOURCE_DIR}/.gitignore")
    endif()

    if (NOT EXISTS "${CMAKE_SOURCE_DIR}/build.py" AND EXISTS "${CMAKE_UTILS_ROOT}/build.py.in")
        file(COPY_FILE "${CMAKE_UTILS_ROOT}/build.py.in" "${CMAKE_SOURCE_DIR}/build.py")
    endif()
endif()

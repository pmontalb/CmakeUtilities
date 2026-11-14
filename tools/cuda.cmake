include_guard(GLOBAL)

# ==============================================================================
# Modern Native CMake CUDA Configuration
# ==============================================================================
if (NOT CMAKE_CUDA_ARCHITECTURES)
    set(CMAKE_CUDA_ARCHITECTURES "${LANGUAGES_CUDA_ARCHITECTURE}")
endif()

set(CMAKE_CUDA_STANDARD ${FLAGS_CPP_STANDARD})
set(CMAKE_CUDA_STANDARD_REQUIRED ON)
set(CMAKE_CUDA_EXTENSIONS OFF)

include(CheckLanguage)
check_language(CUDA)

if (NOT CMAKE_CUDA_COMPILER)
    message(WARNING "LANGUAGES_USE_CUDA is ON, but no CUDA compiler (nvcc) was found.")
    return()
endif()

enable_language(CUDA)
find_package(CUDAToolkit REQUIRED)

message(STATUS "CUDA enabled (compiler: ${CMAKE_CUDA_COMPILER_ID} ${CMAKE_CUDA_COMPILER_VERSION}, arch: ${CMAKE_CUDA_ARCHITECTURES})")

set(DEFAULT_CUDA_FLAGS "")

if (CMAKE_CUDA_COMPILER_ID STREQUAL "NVIDIA")
    set(CMAKE_CUDA_FLAGS_PROFILE "-DNDEBUG -O3 -lineinfo -Xcompiler=-fno-omit-frame-pointer" CACHE STRING "" FORCE)
    set(CMAKE_CUDA_FLAGS_ASAN "-g -O1 -Xcompiler=-fno-omit-frame-pointer" CACHE STRING "" FORCE)
    set(CMAKE_CUDA_FLAGS_ASANUBSAN "-g -O1 -Xcompiler=-fno-omit-frame-pointer" CACHE STRING "" FORCE)
    mark_as_advanced(CMAKE_CUDA_FLAGS_PROFILE CMAKE_CUDA_FLAGS_ASAN CMAKE_CUDA_FLAGS_ASANUBSAN)

    list(APPEND DEFAULT_CUDA_FLAGS --default-stream per-thread)

    set(_nvcc_host_warnings "-Wno-unknown-pragmas")
    if (WARNINGS_USE_WALL_AND_WEXTRA)
        list(APPEND _nvcc_host_warnings "-Wall" "-Wextra")
    endif()
    string(JOIN "," _nvcc_host_warnings_str ${_nvcc_host_warnings})
    list(APPEND DEFAULT_CUDA_FLAGS "-Xcompiler=${_nvcc_host_warnings_str}")

    if (WARNINGS_TREAT_WARNINGS_AS_ERROR)
        list(APPEND DEFAULT_CUDA_FLAGS --Werror=all-warnings)
    endif()

    if (LANGUAGES_CUDA_ALLOW_UNSUPPORTED_COMPILER)
        list(APPEND DEFAULT_CUDA_FLAGS -allow-unsupported-compiler)
    endif()

    if (CMAKE_BUILD_TYPE MATCHES "^(Release|RelWithDebInfo|Profile)$")
        list(APPEND DEFAULT_CUDA_FLAGS -Xptxas=-O3 --extra-device-vectorization)
        if (OPTIMIZATIONS_USE_FAST_MATH)
            list(APPEND DEFAULT_CUDA_FLAGS --use_fast_math)
        endif()
    endif()
endif()

mark_as_advanced(DEFAULT_CUDA_FLAGS)

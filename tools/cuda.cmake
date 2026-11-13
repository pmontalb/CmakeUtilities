include_guard(GLOBAL)

# ==============================================================================
# Modern Native CMake CUDA Configuration
# ==============================================================================
include(CheckLanguage)
check_language(CUDA)

if (NOT CMAKE_CUDA_COMPILER)
    message(WARNING "LANGUAGES_USE_CUDA is ON, but no CUDA compiler (nvcc) was found.")
    return()
endif()

enable_language(CUDA)
find_package(CUDAToolkit REQUIRED)

set(CMAKE_CUDA_STANDARD ${FLAGS_CPP_STANDARD})
set(CMAKE_CUDA_STANDARD_REQUIRED ON)
set(CMAKE_CUDA_EXTENSIONS OFF)

if (NOT CMAKE_CUDA_ARCHITECTURES)
    set(CMAKE_CUDA_ARCHITECTURES "${LANGUAGES_CUDA_ARCHITECTURE}")
endif()

message(STATUS "CUDA enabled (compiler: ${CMAKE_CUDA_COMPILER_ID} ${CMAKE_CUDA_COMPILER_VERSION}, arch: ${CMAKE_CUDA_ARCHITECTURES})")

set(DEFAULT_CUDA_FLAGS --default-stream per-thread -Xcompiler=-Wno-unknown-pragmas)

if (WARNINGS_USE_WALL_AND_WEXTRA)
    list(APPEND DEFAULT_CUDA_FLAGS -Xcompiler=-Wall,-Wextra)
endif()

if (WARNINGS_TREAT_WARNINGS_AS_ERROR)
    list(APPEND DEFAULT_CUDA_FLAGS --Werror all-warnings)
endif()

if (CMAKE_BUILD_TYPE MATCHES "^(Release|RelWithDebInfo|Profile)$")
    list(APPEND DEFAULT_CUDA_FLAGS -Xptxas=-O3 --extra-device-vectorization)
    if (OPTIMIZATIONS_USE_FAST_MATH)
        list(APPEND DEFAULT_CUDA_FLAGS --use_fast_math)
    endif()
endif()

mark_as_advanced(DEFAULT_CUDA_FLAGS)

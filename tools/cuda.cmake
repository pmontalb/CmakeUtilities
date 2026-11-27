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

if (LANGUAGES_CUDA_DEVICE_LTO)
    set(CMAKE_CUDA_SEPARABLE_COMPILATION ON)
endif()

include(CheckLanguage)
check_language(CUDA)

if (NOT CMAKE_CUDA_COMPILER)
    message(WARNING "LANGUAGES_USE_CUDA is ON, but no CUDA compiler (nvcc) was found.")
    return()
endif()

enable_language(CUDA)
find_package(CUDAToolkit REQUIRED)

# When nvcc uses an older GCC host compiler wrapper (e.g. g++-13 under nvcc 12.4)
# than CMAKE_CXX_COMPILER (e.g. g++-15), avoid prepending the older GCC's libstdc++
# directory to C++ link lines.
if (CMAKE_CUDA_COMPILER_ID STREQUAL "NVIDIA" AND CMAKE_CUDA_IMPLICIT_LINK_DIRECTORIES)
    set(_filtered_cuda_link_dirs "")
    foreach(_dir IN LISTS CMAKE_CUDA_IMPLICIT_LINK_DIRECTORIES)
        if (_dir MATCHES "/lib/gcc/[^/]+/[0-9]+$" AND NOT _dir IN_LIST CMAKE_CXX_IMPLICIT_LINK_DIRECTORIES)
            continue()
        endif()
        list(APPEND _filtered_cuda_link_dirs "${_dir}")
    endforeach()
    set(CMAKE_CUDA_IMPLICIT_LINK_DIRECTORIES "${_filtered_cuda_link_dirs}")
endif()

message(STATUS "CUDA enabled (compiler: ${CMAKE_CUDA_COMPILER_ID} ${CMAKE_CUDA_COMPILER_VERSION}, arch: ${CMAKE_CUDA_ARCHITECTURES})")

set(DEFAULT_CUDA_FLAGS "")

if (CMAKE_CUDA_COMPILER_ID STREQUAL "NVIDIA")
    set(CMAKE_CUDA_FLAGS_PROFILE "-DNDEBUG -O3 -lineinfo -Xcompiler=-fno-omit-frame-pointer" CACHE STRING "" FORCE)
    set(CMAKE_CUDA_FLAGS_ASAN "-g -O1 -Xcompiler=-fno-omit-frame-pointer" CACHE STRING "" FORCE)
    set(CMAKE_CUDA_FLAGS_ASANUBSAN "-g -O1 -Xcompiler=-fno-omit-frame-pointer" CACHE STRING "" FORCE)
    mark_as_advanced(CMAKE_CUDA_FLAGS_PROFILE CMAKE_CUDA_FLAGS_ASAN CMAKE_CUDA_FLAGS_ASANUBSAN)

    list(APPEND DEFAULT_CUDA_FLAGS
        --default-stream per-thread
        --display-error-number
        --Wreorder
        --Wext-lambda-captures-this
    )

    set(_nvcc_host_flags "-Wno-unknown-pragmas")

    if (CMAKE_UTILS_ARCH_FLAGS)
        separate_arguments(_nvcc_arch_list NATIVE_COMMAND "${CMAKE_UTILS_ARCH_FLAGS}")
        # Translate Intel-specific -xHost to -march=native for nvcc's GCC/Clang host compiler
        list(TRANSFORM _nvcc_arch_list REPLACE "^-xHost$" "-march=native")
        list(APPEND _nvcc_host_flags ${_nvcc_arch_list})
    endif()

    if (NOT MISC_USE_RUNTIME_TYPE_INFO)
        list(APPEND _nvcc_host_flags "-fno-rtti")
    endif()

    if (OPTIMIZATIONS_DISABLE_EXCEPTIONS)
        list(APPEND _nvcc_host_flags "-fno-exceptions")
    endif()

    if (WARNINGS_USE_WALL_AND_WEXTRA)
        list(APPEND _nvcc_host_flags "-Wall" "-Wextra")
    endif()

    if (WARNINGS_USE_PEDANTIC_WARNINGS)
        list(APPEND _nvcc_host_flags "-Wshadow")
    endif()

    if (WARNINGS_TREAT_WARNINGS_AS_ERROR)
        list(APPEND DEFAULT_CUDA_FLAGS --Werror=all-warnings)
        list(APPEND _nvcc_host_flags "-Werror")
    endif()

    if (CMAKE_BUILD_TYPE MATCHES "^(Release|RelWithDebInfo|Profile)$")
        list(APPEND DEFAULT_CUDA_FLAGS -Xptxas=-O3 --extra-device-vectorization)
        if (CMAKE_BUILD_TYPE STREQUAL "Release" AND OPTIMIZATIONS_GENERATE_DEBUG_INFO)
            list(APPEND DEFAULT_CUDA_FLAGS -lineinfo)
        endif()
        if (OPTIMIZATIONS_UNROLL_LOOPS)
            list(APPEND _nvcc_host_flags "-funroll-loops")
        endif()
        if (OPTIMIZATIONS_USE_FAST_MATH)
            list(APPEND DEFAULT_CUDA_FLAGS --use_fast_math)
        endif()
    endif()

    if (LANGUAGES_CUDA_ALLOW_UNSUPPORTED_COMPILER)
        list(APPEND DEFAULT_CUDA_FLAGS -allow-unsupported-compiler)
    endif()
    if (LANGUAGES_CUDA_RESTRICT)
        list(APPEND DEFAULT_CUDA_FLAGS --restrict)
    endif()
    if (LANGUAGES_CUDA_WARN_SPILLS)
        list(APPEND DEFAULT_CUDA_FLAGS "-Xptxas=--warn-on-spills,--warn-on-local-memory-usage")
    endif()
    if (LANGUAGES_CUDA_WARN_DEFAULT_STREAM)
        list(APPEND DEFAULT_CUDA_FLAGS --Wdefault-stream-launch)
    endif()
    if (LANGUAGES_CUDA_RESOURCE_USAGE AND NOT LANGUAGES_CUDA_DEVICE_LTO)
        list(APPEND DEFAULT_CUDA_FLAGS --resource-usage)
    endif()
    if (LANGUAGES_CUDA_RELAXED_CONSTEXPR)
        list(APPEND DEFAULT_CUDA_FLAGS --expt-relaxed-constexpr)
    endif()
    if (LANGUAGES_CUDA_EXTENDED_LAMBDA)
        list(APPEND DEFAULT_CUDA_FLAGS --expt-extended-lambda)
    endif()
    if (LANGUAGES_CUDA_DEVICE_LTO)
        string(APPEND CMAKE_CUDA_FLAGS " -dlto")
        list(APPEND DEFAULT_CUDA_FLAGS --gen-opt-lto)
    endif()

    string(JOIN "," _nvcc_host_flags_str ${_nvcc_host_flags})
    list(APPEND DEFAULT_CUDA_FLAGS "-Xcompiler=${_nvcc_host_flags_str}")
endif()

mark_as_advanced(DEFAULT_CUDA_FLAGS)

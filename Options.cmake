include_guard()

option(BUILD_SHARED_LIBS OFF)
option(BUILD_EXAMPLES "Build sample project" OFF)

option(WARNINGS_TREAT_WARNINGS_AS_ERROR "Use -Werror" ON)
option(WARNINGS_USE_WALL_AND_WEXTRA "Use -Wall and -Wextra" ON)
option(WARNINGS_USE_PEDANTIC_WARNINGS "Use -Weverything" ON)

option(DEBUG_USE_STL_DEBUG "Use GLIBCXX_DEBUG and GLIBCXX_DEBUG_PEDANTIC in non-release builds" ON)

option(LANGUAGES_USE_64_BITS "Use 64 bits" ON)
mark_as_advanced(LANGUAGES_USE_64_BITS)
option(LANGUAGES_USE_CUDA "Depends on CUDA" OFF)

option(MISC_USE_POSITION_INDEPENDENT_CODE "Use PIC" ON)
option(MISC_USE_RUNTIME_TYPE_INFO "Use rtti" OFF)

option(MISC_USE_MKL "Use MKL library" OFF)
option(MISC_USE_OPENBLAS "Use OpenBLAS library" OFF)
option(MISC_USE_LAPACK "Use LAPACK library" OFF)

option(MISC_RUN_SYMLINK "Symlink clang-tidy, clang-format, pre-commit and presets" ON)

option(OPTIMIZATIONS_GENERATE_DEBUG_INFO "Use -g in release mode" ON)
option(OPTIMIZATIONS_USE_OFAST "Use -Ofast in release mode instead of O3" OFF)
option(OPTIMIZATIONS_USE_MEMORY_OPTIMIZATION "Use Graphite/Polly in release mode" OFF)
option(OPTIMIZATIONS_USE_FAST_MATH "Use -ffast-math in release mode" OFF)
option(OPTIMIZATIONS_USE_LTO "Use Link-Time Optimization in release mode" OFF)
option(OPTIMIZATIONS_USE_NATIVE_ARCHITECTURE "Use -march=native [for a custom arch define OPTIMIZATIONS_CUSTOM_TUNING]" ON)
option(OPTIMIZATIONS_USE_NATIVE_TUNING "Use -mtune=native  [for a custom tune define OPTIMIZATIONS_CUSTOM_ARCHITECTURE]" OFF)
option(OPTIMIZATIONS_DISABLE_EXCEPTIONS "Use -fno-exceptions " OFF)
option(OPTIMIZATIONS_DO_NOT_OMIT_FRAME_POINTER "Use -fno-omit-frame-pointer" OFF)

option(BUILD_SYSTEM_USE_CCACHE "Use ccache" OFF)
option(BUILD_SYSTEM_USE_DISTCC "Use distcc" OFF)
option(BUILD_SYSTEM_USE_ICECC "Use icecc" OFF)


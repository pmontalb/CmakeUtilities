include_guard(GLOBAL)

# ==============================================================================
# Project & Build Options
# ==============================================================================
option(BUILD_SHARED_LIBS "Build shared libraries instead of static libraries" OFF)
option(BUILD_EXAMPLES "Build sample project" OFF)

# ==============================================================================
# C++ Standard (C++20 and upward only)
# ==============================================================================
set(FLAGS_CPP_STANDARD "20" CACHE STRING "C++ standard (20, 23, 26)")
set_property(CACHE FLAGS_CPP_STANDARD PROPERTY STRINGS "20" "23" "26")

# ==============================================================================
# Compiler Flavor Override (useful when Clang-based compilers need disambiguation)
# ==============================================================================
set(COMPILER_FLAVOR "AUTO" CACHE STRING "Compiler flavor: AUTO, GCC, Clang, IntelLLVM, AOCC, MSVC, Emscripten")
set_property(CACHE COMPILER_FLAVOR PROPERTY STRINGS "AUTO" "GCC" "Clang" "IntelLLVM" "AOCC" "MSVC" "Emscripten")

# ==============================================================================
# Warning Options
# ==============================================================================
option(WARNINGS_TREAT_WARNINGS_AS_ERROR "Treat compiler warnings as errors (-Werror)" ON)
option(WARNINGS_USE_WALL_AND_WEXTRA "Enable baseline -Wall and -Wextra" ON)
option(WARNINGS_USE_PEDANTIC_WARNINGS "Enable exhaustive compiler-version-gated warnings" ON)

# ==============================================================================
# Debug & Language Behavior Options
# ==============================================================================
option(DEBUG_USE_STL_DEBUG "Enable _GLIBCXX_DEBUG in Debug builds (GNU libstdc++ only)" ON)
option(LANGUAGES_USE_64_BITS "Target 64-bit architecture (-m64 / wasm64)" ON)
mark_as_advanced(LANGUAGES_USE_64_BITS)
option(LANGUAGES_USE_CUDA "Enable CUDA language support" OFF)
set(LANGUAGES_CUDA_ARCHITECTURE "native" CACHE STRING "CUDA target architecture (e.g. native, 86, 89)")
option(LANGUAGES_CUDA_ALLOW_UNSUPPORTED_COMPILER "Pass -allow-unsupported-compiler to nvcc when host compiler is newer than toolkit limit" OFF)
option(LANGUAGES_CUDA_RESTRICT "Assert CUDA kernel pointer parameters do not alias (--restrict)" OFF)
option(LANGUAGES_CUDA_DEVICE_LTO "Enable CUDA device link-time optimization (-dlto + separable compilation)" OFF)
option(LANGUAGES_CUDA_RESOURCE_USAGE "Print CUDA kernel register and memory usage during compilation (--resource-usage)" OFF)
option(LANGUAGES_CUDA_WARN_SPILLS "Warn on CUDA register spills and local memory usage in ptxas" OFF)
option(LANGUAGES_CUDA_WARN_DEFAULT_STREAM "Warn when CUDA kernel launches omit an explicit stream (--Wdefault-stream-launch)" OFF)
option(LANGUAGES_CUDA_RELAXED_CONSTEXPR "Enable --expt-relaxed-constexpr for nvcc" OFF)
option(LANGUAGES_CUDA_EXTENDED_LAMBDA "Enable --expt-extended-lambda for nvcc" OFF)

option(MISC_USE_POSITION_INDEPENDENT_CODE "Enable Position Independent Code (PIC)" ON)
option(MISC_USE_RUNTIME_TYPE_INFO "Enable RTTI (-frtti); when OFF, passes -fno-rtti" OFF)
option(MISC_RUN_SYMLINK "Sync helper configs (.clang-format, .clang-tidy, presets) into project root" ON)

# ==============================================================================
# Architecture & Optimization Options
# ==============================================================================
option(OPTIMIZATIONS_USE_NATIVE_ARCHITECTURE "Optimize for host CPU (-march=native / -xHost)" ON)
option(OPTIMIZATIONS_USE_NATIVE_TUNING "Tune for host CPU without restricting portability (-mtune=native)" OFF)
set(OPTIMIZATIONS_CUSTOM_ARCHITECTURE "" CACHE STRING "Custom -march=<arch> (e.g. x86-64-v3, x86-64-v4, znver4)")
set(OPTIMIZATIONS_CUSTOM_TUNING "" CACHE STRING "Custom -mtune=<cpu> (e.g. znver4, alderlake)")

option(OPTIMIZATIONS_GENERATE_DEBUG_INFO "Include debug symbols (-g) in Release builds" ON)
option(OPTIMIZATIONS_USE_FAST_MATH "Enable aggressive -ffast-math in Release builds" OFF)
option(OPTIMIZATIONS_USE_FAST_MATH_SAFE "Enable fast-math flags that preserve NaN/Inf (-fno-math-errno -ffp-contract=fast -fno-trapping-math -fassociative-math -freciprocal-math)" OFF)
option(OPTIMIZATIONS_USE_LTO "Enable Link-Time Optimization (LTO)" OFF)
set(OPTIMIZATIONS_LTO_MODE "AUTO" CACHE STRING "LTO mode: AUTO, FULL, THIN")
set_property(CACHE OPTIMIZATIONS_LTO_MODE PROPERTY STRINGS "AUTO" "FULL" "THIN")

set(OPTIMIZATIONS_PGO_MODE "OFF" CACHE STRING "Profile-Guided Optimization mode: OFF, GENERATE, USE")
set_property(CACHE OPTIMIZATIONS_PGO_MODE PROPERTY STRINGS "OFF" "GENERATE" "USE")
set(OPTIMIZATIONS_PGO_DIR "${CMAKE_BINARY_DIR}/pgo-data" CACHE PATH "Directory for PGO profile data")

option(OPTIMIZATIONS_USE_MEMORY_OPTIMIZATION "Enable polyhedral/loop-nest optimizations (Graphite/Polly)" OFF)
option(OPTIMIZATIONS_USE_VECTOR_MATH_LIB "Enable compiler vector math library (libmvec/AMDLIBM/SVML)" OFF)
option(OPTIMIZATIONS_USE_SECTIONS_GC "Enable -ffunction-sections -fdata-sections and --gc-sections" ON)
option(OPTIMIZATIONS_HIDDEN_VISIBILITY "Use -fvisibility=hidden -fvisibility-inlines-hidden" OFF)
option(OPTIMIZATIONS_NO_SEMANTIC_INTERPOSITION "Use -fno-semantic-interposition for better PIC inlining" ON)
option(OPTIMIZATIONS_UNROLL_LOOPS "Enable -funroll-loops in Release builds" OFF)
option(OPTIMIZATIONS_DISABLE_EXCEPTIONS "Disable C++ exceptions (-fno-exceptions)" OFF)
option(OPTIMIZATIONS_DO_NOT_OMIT_FRAME_POINTER "Preserve frame pointers (-fno-omit-frame-pointer)" OFF)

# ==============================================================================
# Build System & Linker Options
# ==============================================================================
set(BUILD_SYSTEM_LINKER "AUTO" CACHE STRING "Linker override: AUTO, DEFAULT, LLD, MOLD, GOLD")
set_property(CACHE BUILD_SYSTEM_LINKER PROPERTY STRINGS "AUTO" "DEFAULT" "LLD" "MOLD" "GOLD")

option(BUILD_SYSTEM_USE_CCACHE "Use ccache launcher" OFF)
option(BUILD_SYSTEM_USE_SCCACHE "Use sccache launcher" OFF)
option(BUILD_SYSTEM_USE_DISTCC "Use distcc launcher" OFF)
option(BUILD_SYSTEM_USE_ICECC "Use icecc launcher" OFF)

# ==============================================================================
# Developer Tooling Options
# ==============================================================================
option(TOOLS_USE_CLANG_TIDY "Enable clang-tidy static analysis during build" OFF)
option(TOOLS_CLANG_TIDY_FIX "Automatically apply clang-tidy fixes" OFF)
option(TOOLS_CLANG_TIDY_WERROR "Treat clang-tidy warnings as errors" OFF)
option(TOOLS_USE_IWYU "Enable Include-What-You-Use" OFF)
option(TOOLS_ENABLE_DEPENDENCY_GRAPH "Add dependency_graph target using CMake --graphviz" OFF)
option(TOOLS_TIME_TRACE "Enable compiler build time trace (-ftime-trace on Clang)" OFF)

# ==============================================================================
# Emscripten (WASM) Specific Options
# ==============================================================================
option(EMSCRIPTEN_USE_SIMD "Enable WebAssembly 128-bit SIMD (-msimd128)" ON)
option(EMSCRIPTEN_USE_PTHREADS "Enable WebAssembly pthreads (-pthread)" OFF)
option(EMSCRIPTEN_USE_WASM_EXCEPTIONS "Use native WASM exceptions (-fwasm-exceptions)" ON)
option(EMSCRIPTEN_USE_CLOSURE "Enable Closure compiler minification on Release link" OFF)

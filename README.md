# CmakeUtilities

[![CI](https://github.com/pmontalb/CmakeUtilities/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/pmontalb/CmakeUtilities/actions/workflows/ci.yml)

Modular CMake (3.28+) build, warning, optimization, and preset framework for **C++20 / C++23 / C++26** projects.

## Supported Compilers & Toolchains
- **GCC** (`11+` through `16+`)
- **Clang** (`13+` through `23+`)
- **Intel oneAPI `icpx`** (`IntelLLVM`, `2021+`)
- **AMD `AOCC`** (`clang++` with AMD Zen & AMDLIBM tuning)
- **Emscripten `em++`** (WebAssembly, SIMD128, WASM exceptions, pthreads)
- **NVIDIA CUDA `nvcc`** (with GCC/Clang host C++ toolchains)

## Directory Layout
- `All.cmake` / `Options.cmake` / `Common.cmake` / `TargetUtilities.cmake`: Entrypoint & helper functions (`create_executable`, `create_library`, `create_test`, `create_cuda_*`, etc.)
- `flags/`:
  - `standards.cmake`: Enforces C++20+ (`CMAKE_CXX_STANDARD_REQUIRED ON`, `CMAKE_CXX_EXTENSIONS OFF`)
  - `compilers.cmake`: Compiler flavor detection & RTTI/PIC setup
  - `configurations.cmake`: Build configuration validation (`Debug`, `Release`, `RelWithDebInfo`, `MinSizeRel`, `Profile`, `Asan`, `Ubsan`, `Tsan`, `Msan`, `Lsan`, `AsanUbsan`, `Coverage`, `IWYU`)
  - `architectures.cmake`: `-m64`, `-march=native` / `-xHost`, custom arch/tuning, WASM SIMD128
  - `optimizations.cmake` + `compilers/*.cmake`: Release flags, `-ffunction-sections`/`-fdata-sections` + `--gc-sections`, `-fno-semantic-interposition`, `-fvisibility=hidden`, LTO/ThinLTO, PGO, safe & aggressive fast-math, vector math libs (`libmvec`, `AMDLIBM`, `SVML`), `mold`/`lld`
  - `debug.cmake`, `sanitizers.cmake`, `coverage.cmake`: Debug, sanitizer, and coverage compile + link flags
- `warnings/`: Version-gated exhaustive C++ warning flags per compiler (`gcc.cmake`, `clang.cmake`, `icpx.cmake`, `aocc.cmake`, `emscripten.cmake`)
- `tools/`: `launchers.cmake` (`ccache`, `sccache`, `distcc`, `icecc`), `clang_tidy.cmake`, `iwyu.cmake`, `graphviz.cmake` (`dependency_graph` target), `cuda.cmake`
- `preset/`: Modular CMake Presets v8 fragments included by `CMakePresets.json`:
  - `base.json`, `gcc.json`, `clang.json`, `icc.json`, `aocc.json`, `msvc.json`, `emscripten.json`, `cuda.json`
  - `fast-math.json`, `lto.json`, `pgo.json`, `sanitizers.json`, `tools.json`

## Quick Usage
```bash
cmake --list-presets=all
cmake -S . --preset=gcc-release
cmake --build --preset=gcc-release
ctest --preset=gcc-release
```

Run tool or multi-step workflows via presets:
```bash
# Generate target dependency graph (.dot / .svg / .png)
cmake --workflow --preset=dependency-graph

# Run clang-tidy analysis
cmake --workflow --preset=clang-tidy
```

---

## Available Presets

All configure/build presets share `base` defaults: Ninja generator, `cmake-build-<preset>` binary dir, `compile_commands.json` export, `ccache` enabled (disabled for tidy/iwyu/time-trace), 64-bit target (`OFF` for Emscripten), and `-Wall -Wextra -Werror` with pedantic warnings enabled.

### 1. Core Build Configurations
Available across toolchains (`gcc-*`, `clang-*`, `icpx-*`, `aocc-*`, `msvc-*` on Windows, and `emscripten-*` excluding `profile`):

| Preset(s) | Configuration | Purpose / What It Accomplishes |
|---|---|---|
| `gcc-debug`, `clang-debug`, `icpx-debug`, `aocc-debug`, `msvc-debug`, `emscripten-debug` | `Debug` | Unoptimized (`-O0` / `/Od`) build with full debug symbols (`-ggdb3` / `-g3` / `/Z7`) and `libstdc++` iterator/container debug checks (`_GLIBCXX_DEBUG`, skipped on Emscripten/libc++/MSVC). Best for day-to-day debugging. |
| `gcc-release`, `clang-release`, `icpx-release`, `aocc-release`, `msvc-release`, `emscripten-release` | `Release` | Production `-O3` (`/O2 /Ob2` on MSVC) build with `-march=native` (`-xHost` on `icpx`, SIMD on Emscripten), debug symbols (`-g` / `/Z7`), `--gc-sections` (`/Gy /OPT:REF /OPT:ICF`), and `-fno-semantic-interposition`. |
| `gcc-minsizerel`, `clang-minsizerel`, `icpx-minsizerel`, `aocc-minsizerel`, `msvc-minsizerel`, `emscripten-minsizerel` | `MinSizeRel` | Size-optimized (`-Os` / `/O1 /Ob1`) build with section GC and hidden symbol visibility (`-fvisibility=hidden`). Used for minimal binary / WASM footprint. |
| `gcc-profile`, `clang-profile`, `icpx-profile`, `aocc-profile`, `msvc-profile` | `Profile` | Optimized `-O3` (`/O2 /Ob2`) + debug info build with preserved frame pointers (`-fno-omit-frame-pointer` / `/Oy-`) for accurate CPU profiling (`perf`, VTune, flamegraphs). |

### 2. CUDA Presets (`nvcc`)
Enable `LANGUAGES_USE_CUDA=ON` targeting native GPU architecture (`native`). All have matching configure, build, and test presets:

| Preset | Host Toolchain | Purpose / What It Accomplishes |
|---|---|---|
| `gcc-cuda-debug` | `gcc` / `g++` | `Debug` host + CUDA device debug build (`-g`) with `_GLIBCXX_DEBUG` on host C++ TUs. |
| `gcc-cuda-release` | `gcc` / `g++` | Optimized `Release` (`-O3`, `-Xptxas=-O3`, `--extra-device-vectorization`, `-lineinfo`). |
| `gcc-cuda-profile` | `gcc` / `g++` | Optimized `-O3` host/device build with `-fno-omit-frame-pointer` and `-lineinfo` for Nsight / `perf`. |
| `gcc-cuda-asan` | `gcc` / `g++` | Host AddressSanitizer build with `ASAN_OPTIONS=...:protect_shadow_gap=0` configured automatically for CUDA compatibility. |
| `gcc-cuda-fast-math` | `gcc` / `g++` | `Release` + host `-ffast-math` + device `--use_fast_math` (FTZ, fast division/sqrt, FMAD). |
| `clang-cuda-debug` | `clang` / `clang++` | Clang host `Debug` + CUDA (`nvcc`) debug build. |
| `clang-cuda-release` | `clang` / `clang++` | Clang host `Release` + CUDA (`nvcc`) optimized build. |
| `clang-cuda-profile` | `clang` / `clang++` | Clang host `Profile` + CUDA (`nvcc`) build with frame pointers and `-lineinfo`. |
| `clang-cuda-asan` | `clang` / `clang++` | Clang host ASan + CUDA (`nvcc`) build with `protect_shadow_gap=0`. |
| `clang-cuda-fast-math` | `clang` / `clang++` | Clang host `-ffast-math` + CUDA `--use_fast_math`. |

### 3. Fast-Math Presets
Enable `-O3` plus floating-point optimizations and vector math libraries (`OPTIMIZATIONS_USE_VECTOR_MATH_LIB=ON`):

| Preset(s) | Purpose / What It Accomplishes |
|---|---|
| `gcc-fast-math`, `clang-fast-math`, `icpx-fast-math`, `aocc-fast-math`, `emscripten-fast-math` | Aggressive `-ffast-math` + vector math library (`libmvec`/`AMDLIBM`/`SVML`). Maximum FP throughput where strict IEEE-754 NaN/Inf/signed-zero semantics are not required. |
| `gcc-fast-math-safe`, `clang-fast-math-safe` | Safe fast-math: enables `-fno-math-errno`, `-ffp-contract=fast`, `-fno-trapping-math`, `-fassociative-math`, `-freciprocal-math` while preserving finite NaN/Inf handling. |

### 4. Sanitizers & Code Coverage
All sanitizer/coverage presets disable `_GLIBCXX_DEBUG`, add `-ggdb3 -O1 -fno-omit-frame-pointer`, and set matching runtime `CTest` environment options:

| Preset(s) | Tool | Purpose / What It Accomplishes |
|---|---|---|
| `gcc-asan`, `clang-asan`, `icpx-asan`, `aocc-asan` | AddressSanitizer | Detects out-of-bounds accesses, use-after-free, use-after-return, and leaks. |
| `gcc-ubsan`, `clang-ubsan`, `icpx-ubsan`, `aocc-ubsan` | UndefinedBehaviorSanitizer | Traps UB (signed overflow, misaligned/null pointers, bounds, float divide-by-zero) with stacktraces and `-fno-sanitize-recover=all`. |
| `gcc-tsan`, `clang-tsan` | ThreadSanitizer | Detects data races and lock-order inversions in multithreaded code. |
| `clang-msan` | MemorySanitizer | Detects reads of uninitialized heap/stack memory with origin tracking (`Clang`/`AOCC` only; avoid linking uninstrumented C++ static libraries like system `libgtest`). |
| `gcc-lsan`, `clang-lsan` | LeakSanitizer | Lightweight standalone memory leak detector without ASan's memory-access shadow overhead. |
| `gcc-asan-ubsan`, `clang-asan-ubsan` | ASan + UBSan | Combined memory safety and undefined behavior check in a single run. |
| `gcc-coverage`, `clang-coverage` | `gcov` / `llvm-cov` | Builds with coverage instrumentation (`--coverage` on GCC; `-fprofile-instr-generate -fcoverage-mapping` on Clang) for line/branch coverage reports. |

### 5. Link-Time Optimization (LTO)
Whole-program cross-translation-unit optimization (`OPTIMIZATIONS_USE_LTO=ON`, ThinLTO when supported via `OPTIMIZATIONS_LTO_MODE=AUTO`):

| Preset(s) | Purpose / What It Accomplishes |
|---|---|
| `gcc-lto`, `clang-lto`, `icpx-lto`, `aocc-lto`, `emscripten-lto` | `Release` (`-O3`, `-march=native`) + whole-program LTO inlining and dead-code elimination. |
| `gcc-lto-fast-math`, `clang-lto-fast-math`, `icpx-lto-fast-math`, `aocc-lto-fast-math`, `emscripten-lto-fast-math` | Combines LTO with aggressive `-ffast-math` + vector math library for maximum CPU performance. |

### 6. Profile-Guided Optimization (PGO)
Two-stage PGO builds sharing one binary dir (`cmake-build-<toolchain>-pgo*`): run `*-train`, execute a representative workload / `ctest`, merge profiles if using Clang (`llvm-profdata merge`), then build `*-opti` to feed runtime branch/hotness profiles back into the optimizer:

| Stage / Variant | Presets | Purpose / What It Accomplishes |
|---|---|---|
| Baseline PGO | `gcc-pgo-train`, `gcc-pgo-opti`, `clang-pgo-train`, `clang-pgo-opti`, `icpx-pgo-train`, `icpx-pgo-opti`, `aocc-pgo-train`, `aocc-pgo-opti` | Instrument (`GENERATE`) then re-optimize (`USE`) using runtime execution profiles. |
| LTO + PGO | `gcc-lto-pgo-train`, `gcc-lto-pgo-opti`, `clang-lto-pgo-train`, `clang-lto-pgo-opti`, `icpx-lto-pgo-train`, `icpx-lto-pgo-opti`, `aocc-lto-pgo-train`, `aocc-lto-pgo-opti` | Combines PGO with cross-TU LTO for better interprocedural inlining and layout. |
| LTO + PGO + Fast-Math | `gcc-lto-pgo-fast-math-train`, `gcc-lto-pgo-fast-math-opti`, `clang-lto-pgo-fast-math-train`, `clang-lto-pgo-fast-math-opti`, `icpx-lto-pgo-fast-math-train`, `icpx-lto-pgo-fast-math-opti`, `aocc-lto-pgo-fast-math-train`, `aocc-lto-pgo-fast-math-opti` | Peak CPU optimization: PGO + LTO + `-ffast-math` + vector math library. |

Also provided as one-shot **workflow presets** (`cmake --workflow --preset=<name>`): `gcc-pgo-train`, `gcc-pgo-opti`, `clang-pgo-train`, `clang-pgo-opti`, `gcc-lto-pgo-train`, `gcc-lto-pgo-opti`, `gcc-lto-pgo-fast-math-train`, `gcc-lto-pgo-fast-math-opti`.

### 7. Static Analysis, Include Hygiene & Build Tooling
Configure and build presets (plus workflow presets `dependency-graph` and `clang-tidy`; no test presets):

| Preset | Purpose / What It Accomplishes |
|---|---|
| `clang-tidy-clang` | Runs `clang-tidy` on every translation unit alongside a Clang `Debug` build. |
| `clang-tidy-gcc` | Runs `clang-tidy` alongside a GCC `Debug` build (disables C++20 module dep scanning for compatibility). |
| `clang-tidy-strict-clang` | Same as `clang-tidy-clang`, promoting all `clang-tidy` warnings to errors (`TOOLS_CLANG_TIDY_WERROR=ON`). |
| `dependency-graph` | Configures `TOOLS_ENABLE_DEPENDENCY_GRAPH=ON` and builds the `dependency_graph` target (`.dot` / `.svg` / `.png` via Graphviz). |
| `clang-iwyu` | Runs `include-what-you-use` on all translation units (`CMAKE_BUILD_TYPE=IWYU`). |
| `clang-time-trace` | Builds with Clang `-ftime-trace` (`Release`) to emit per-TU JSON compile flamegraphs for `ClangBuildAnalyzer`. |

---

## CMake Options Reference (`Options.cmake`)

Override any option at configure time with `-D<OPTION>=<VALUE>`.

### Project, Standard & Toolchain
| Option | Default | Description |
|---|---|---|
| `BUILD_SHARED_LIBS` | `OFF` | Build shared libraries instead of static libraries. |
| `BUILD_EXAMPLES` | `OFF` | Build the `Example/` sample libraries and test suite. |
| `FLAGS_CPP_STANDARD` | `"20"` | C++ standard (`20`, `23`, or `26`), with extensions disabled (`CXX_EXTENSIONS OFF`). |
| `COMPILER_FLAVOR` | `"AUTO"` | Override compiler detection: `AUTO`, `GCC`, `Clang`, `IntelLLVM`, `AOCC`, `Emscripten`. |
| `LANGUAGES_USE_64_BITS` | `ON` | Target 64-bit architecture (`-m64` / `wasm64`). |
| `MISC_USE_POSITION_INDEPENDENT_CODE` | `ON` | Enable PIC (`CMAKE_POSITION_INDEPENDENT_CODE=ON`). |
| `MISC_USE_RUNTIME_TYPE_INFO` | `OFF` | Enable RTTI (`-frtti`); when `OFF`, passes `-fno-rtti`. |
| `MISC_RUN_SYMLINK` | `ON` | Sync `.clang-format`, `.clang-tidy`, `.gitignore`, `IgnoreWarning.h`, `build.py`, and presets into downstream project roots. |

### Debug, Sanitizers & Warnings
| Option | Default | Description |
|---|---|---|
| `DEBUG_USE_STL_DEBUG` | `ON` | Enable `_GLIBCXX_DEBUG` and `_GLIBCXX_DEBUG_PEDANTIC` in `Debug` builds (GNU `libstdc++` only; auto-disabled in sanitizer/Emscripten presets). |
| `WARNINGS_TREAT_WARNINGS_AS_ERROR` | `ON` | Pass `-Werror` (`/WX` on MSVC) and `--Werror=all-warnings` on `nvcc`. |
| `WARNINGS_USE_WALL_AND_WEXTRA` | `ON` | Enable baseline `-Wall -Wextra` (`/W4` on MSVC). |
| `WARNINGS_USE_PEDANTIC_WARNINGS` | `ON` | Enable exhaustive compiler-version-gated warnings (including `-Wswitch-default`, `-Wshadow`, etc.). |
| `OPTIMIZATIONS_GENERATE_DEBUG_INFO` | `ON` | Include `-g` in `Release` builds (and `-lineinfo` in `nvcc` Release builds). |
| `OPTIMIZATIONS_DO_NOT_OMIT_FRAME_POINTER` | `OFF` | Preserve frame pointers (`-fno-omit-frame-pointer`) for cleaner stack traces/profiling. |

### Performance & Code Generation
| Option | Default | Description |
|---|---|---|
| `OPTIMIZATIONS_USE_NATIVE_ARCHITECTURE` | `ON` | Target host CPU ISA (`-march=native` / `-xHost`). Disable for portable distribution binaries. |
| `OPTIMIZATIONS_USE_NATIVE_TUNING` | `OFF` | Tune scheduling (`-mtune=native`) without requiring host-only ISA instructions. |
| `OPTIMIZATIONS_CUSTOM_ARCHITECTURE` | `""` | Explicit `-march=<arch>` (e.g. `x86-64-v3`, `x86-64-v4`, `znver4`). |
| `OPTIMIZATIONS_CUSTOM_TUNING` | `""` | Explicit `-mtune=<cpu>` (e.g. `znver4`, `alderlake`). |
| `OPTIMIZATIONS_USE_FAST_MATH` | `OFF` | Aggressive `-ffast-math` in Release builds (and `--use_fast_math` on CUDA). |
| `OPTIMIZATIONS_USE_FAST_MATH_SAFE` | `OFF` | Safe FP speedups (`-fno-math-errno -ffp-contract=fast -fno-trapping-math -fassociative-math -freciprocal-math`) preserving NaN/Inf. |
| `OPTIMIZATIONS_USE_LTO` | `OFF` | Enable host C++ Link-Time Optimization (LTO). |
| `OPTIMIZATIONS_LTO_MODE` | `"AUTO"` | LTO mode: `AUTO`, `FULL`, or `THIN`. |
| `OPTIMIZATIONS_PGO_MODE` | `"OFF"` | Profile-Guided Optimization stage: `OFF`, `GENERATE`, or `USE`. |
| `OPTIMIZATIONS_PGO_DIR` | `"${CMAKE_BINARY_DIR}/pgo-data"` | Directory used to read/write PGO profile data. |
| `OPTIMIZATIONS_USE_MEMORY_OPTIMIZATION` | `OFF` | Enable Graphite (`GCC`) / Polly (`Clang`) polyhedral loop-nest optimizations. |
| `OPTIMIZATIONS_USE_VECTOR_MATH_LIB` | `OFF` | Link compiler vector math library (`libmvec`, `AMDLIBM`, `SVML`). |
| `OPTIMIZATIONS_USE_SECTIONS_GC` | `ON` | Enable `-ffunction-sections -fdata-sections` and linker `--gc-sections` / `-dead_strip`. |
| `OPTIMIZATIONS_HIDDEN_VISIBILITY` | `OFF` | Set `-fvisibility=hidden -fvisibility-inlines-hidden` to reduce dynamic symbol tables and improve inlining. |
| `OPTIMIZATIONS_NO_SEMANTIC_INTERPOSITION` | `ON` | Pass `-fno-semantic-interposition` for better PIC inlining on ELF shared libraries. |
| `OPTIMIZATIONS_UNROLL_LOOPS` | `OFF` | Pass `-funroll-loops` in Release builds. |
| `OPTIMIZATIONS_DISABLE_EXCEPTIONS` | `OFF` | Build C++ (and CUDA host code) with `-fno-exceptions` (`/EHs-c-` on MSVC) to shrink binaries and remove unwind tables. |

### CUDA Options
| Option | Default | Description |
|---|---|---|
| `LANGUAGES_USE_CUDA` | `OFF` | Enable native CMake CUDA support and `CUDAToolkit`. |
| `LANGUAGES_CUDA_ARCHITECTURE` | `"native"` | Default `CMAKE_CUDA_ARCHITECTURES` target (e.g. `native`, `86`, `89`). |
| `LANGUAGES_CUDA_ALLOW_UNSUPPORTED_COMPILER` | `OFF` | Pass `-allow-unsupported-compiler` to `nvcc` when the host compiler is newer than the toolkit's checked max. |
| `LANGUAGES_CUDA_RESTRICT` | `OFF` | Pass `--restrict` to `nvcc` (asserts kernel pointer parameters do not alias). |
| `LANGUAGES_CUDA_DEVICE_LTO` | `OFF` | Enable CUDA device link-time optimization (`-dlto` + `--gen-opt-lto` + `CMAKE_CUDA_SEPARABLE_COMPILATION=ON`). |
| `LANGUAGES_CUDA_RESOURCE_USAGE` | `OFF` | Pass `--resource-usage` to `nvcc` to print registers/shared/local memory per kernel (non-LTO builds). |
| `LANGUAGES_CUDA_WARN_SPILLS` | `OFF` | Warn in `ptxas` on register spills and local memory usage (`--warn-on-spills,--warn-on-local-memory-usage`). |
| `LANGUAGES_CUDA_WARN_DEFAULT_STREAM` | `OFF` | Warn if `<<<...>>>` kernel launches omit an explicit stream (`--Wdefault-stream-launch`). |
| `LANGUAGES_CUDA_RELAXED_CONSTEXPR` | `OFF` | Enable `--expt-relaxed-constexpr` for `nvcc`. |
| `LANGUAGES_CUDA_EXTENDED_LAMBDA` | `OFF` | Enable `--expt-extended-lambda` for `nvcc`. |

### Build System & Developer Tooling
| Option | Default | Description |
|---|---|---|
| `BUILD_SYSTEM_LINKER` | `"AUTO"` | Override linker (`AUTO`, `DEFAULT`, `LLD`, `MOLD`, `GOLD`). |
| `BUILD_SYSTEM_USE_CCACHE` | `OFF` | Enable `ccache` compiler launcher (enabled by default in `base` presets). |
| `BUILD_SYSTEM_USE_SCCACHE` | `OFF` | Enable `sccache` compiler launcher. |
| `BUILD_SYSTEM_USE_DISTCC` | `OFF` | Enable `distcc` distributed compiler launcher. |
| `BUILD_SYSTEM_USE_ICECC` | `OFF` | Enable `icecc` distributed compiler launcher. |
| `TOOLS_USE_CLANG_TIDY` | `OFF` | Run `clang-tidy` static analysis on every translation unit. |
| `TOOLS_CLANG_TIDY_FIX` | `OFF` | Automatically apply `clang-tidy` fixes during build. |
| `TOOLS_CLANG_TIDY_WERROR` | `OFF` | Promote `clang-tidy` warnings to errors (`--warnings-as-errors=*`). |
| `TOOLS_USE_IWYU` | `OFF` | Run `include-what-you-use` during compilation. |
| `TOOLS_ENABLE_DEPENDENCY_GRAPH` | `OFF` | Add `dependency_graph` CMake target using Graphviz. |
| `TOOLS_TIME_TRACE` | `OFF` | Pass `-ftime-trace` on Clang to emit per-TU compile timing JSON files. |

### Emscripten (WebAssembly) Options
| Option | Default | Description |
|---|---|---|
| `EMSCRIPTEN_USE_SIMD` | `ON` | Enable WebAssembly 128-bit SIMD (`-msimd128`). |
| `EMSCRIPTEN_USE_PTHREADS` | `OFF` | Enable WebAssembly pthreads (`-pthread`). |
| `EMSCRIPTEN_USE_WASM_EXCEPTIONS` | `ON` | Use native WASM exception handling (`-fwasm-exceptions`). |
| `EMSCRIPTEN_USE_CLOSURE` | `OFF` | Run Closure compiler minification on Emscripten Release links. |

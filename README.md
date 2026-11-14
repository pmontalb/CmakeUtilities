# CmakeUtilities

[![CI](https://github.com/pmontalb/CmakeUtilities/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/pmontalb/CmakeUtilities/actions/workflows/ci.yml)

Modular CMake (3.28+) build, warning, optimization, and preset framework for **C++20 / C++23 / C++26** projects.

## Supported Compilers (Last ~5 Years)
- **GCC** (`11+` through `15+`)
- **Clang** (`13+` through `21+`)
- **Intel oneAPI `icpx`** (`IntelLLVM`, `2021+`)
- **AMD `AOCC`** (`clang++` with AMD Zen & AMDLIBM tuning)
- **Emscripten `em++`** (WebAssembly, SIMD128, WASM exceptions, pthreads)

## Directory Layout
- `All.cmake` / `Options.cmake` / `Common.cmake` / `TargetUtilities.cmake`: Entrypoint & helper functions (`create_executable`, `create_library`, `create_test`, etc.)
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
  - `base.json`, `gcc.json`, `clang.json`, `icc.json`, `aocc.json`, `emscripten.json`, `cuda.json`
  - `fast-math.json`, `lto.json`, `pgo.json`, `sanitizers.json`, `tools.json`

## Quick Usage
```bash
cmake --list-presets
cmake -S . --preset=gcc-release
cmake --build --preset=gcc-release
ctest --preset=gcc-release
```

Run tools via presets:
```bash
# Generate target dependency graph (.dot / .svg / .png)
cmake --workflow --preset=dependency-graph

# Run clang-tidy analysis
cmake --workflow --preset=clang-tidy
```

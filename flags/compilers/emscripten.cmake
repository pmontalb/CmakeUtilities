include_guard(GLOBAL)

# ==============================================================================
# Emscripten (em++) WebAssembly Optimization & Runtime Flags
# ==============================================================================
set(COMPILER_OPT_CXX_FLAGS "")
set(COMPILER_OPT_LINK_FLAGS "")

# Apply dynamic heap growth and a practical 2 MB stack across all build types (including Debug)
add_link_options("-sALLOW_MEMORY_GROWTH=1" "-sSTACK_SIZE=2MB")

# Fast-Math
if (OPTIMIZATIONS_USE_FAST_MATH)
    list(APPEND COMPILER_OPT_CXX_FLAGS "-ffast-math" "-fno-math-errno")
elseif (OPTIMIZATIONS_USE_FAST_MATH_SAFE)
    list(APPEND COMPILER_OPT_CXX_FLAGS "-fno-math-errno" "-ffp-contract=fast" "-fno-trapping-math" "-fassociative-math" "-freciprocal-math")
endif()

# Native WASM exceptions (much faster & smaller than JS-emulated exceptions)
if (EMSCRIPTEN_USE_WASM_EXCEPTIONS AND NOT OPTIMIZATIONS_DISABLE_EXCEPTIONS)
    list(APPEND COMPILER_OPT_CXX_FLAGS "-fwasm-exceptions")
    list(APPEND COMPILER_OPT_LINK_FLAGS "-fwasm-exceptions")
endif()

# WASM pthreads
if (EMSCRIPTEN_USE_PTHREADS)
    list(APPEND COMPILER_OPT_CXX_FLAGS "-pthread")
    list(APPEND COMPILER_OPT_LINK_FLAGS "-pthread" "-sPTHREAD_POOL_SIZE=navigator.hardwareConcurrency")
endif()

# LTO (wasm-ld LTO)
if (OPTIMIZATIONS_USE_LTO)
    list(APPEND COMPILER_OPT_CXX_FLAGS "-flto")
    list(APPEND COMPILER_OPT_LINK_FLAGS "-flto")
endif()

# Closure compiler JS minification in Release
if (EMSCRIPTEN_USE_CLOSURE AND CMAKE_BUILD_TYPE STREQUAL "Release")
    list(APPEND COMPILER_OPT_LINK_FLAGS "--closure" "1")
endif()

if (TOOLS_TIME_TRACE)
    list(APPEND COMPILER_OPT_CXX_FLAGS "-ftime-trace")
endif()

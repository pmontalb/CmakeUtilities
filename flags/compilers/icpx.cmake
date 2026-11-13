include_guard(GLOBAL)

# ==============================================================================
# Intel oneAPI icpx (IntelLLVM) Optimization, LTO & PGO Flags
# ==============================================================================
set(COMPILER_OPT_CXX_FLAGS "")
set(COMPILER_OPT_LINK_FLAGS "")

# Fast-Math & Floating Point Model (-fp-model=fast is icpx's canonical fast-math; combining with -ffast-math triggers -Woverriding-complex-range)
if (OPTIMIZATIONS_USE_FAST_MATH)
    list(APPEND COMPILER_OPT_CXX_FLAGS "-fp-model=fast")
elseif (OPTIMIZATIONS_USE_FAST_MATH_SAFE)
    list(APPEND COMPILER_OPT_CXX_FLAGS "-fno-math-errno" "-ffp-contract=fast" "-fno-trapping-math")
endif()

# High ZMM / AVX-512 register usage (compile-only via generator expression so linker doesn't warn)
if (OPTIMIZATIONS_USE_NATIVE_ARCHITECTURE OR OPTIMIZATIONS_CUSTOM_ARCHITECTURE MATCHES "avx512|x86-64-v4|sapphirerapids|icelake|skylake-avx512")
    add_compile_options($<$<AND:$<COMPILE_LANGUAGE:CXX>,$<CONFIG:Release,RelWithDebInfo,Profile>>:-qopt-zmm-usage=high>)
endif()

# Intel SVML Vector Math Library
if (OPTIMIZATIONS_USE_VECTOR_MATH_LIB)
    list(APPEND COMPILER_OPT_CXX_FLAGS "-fveclib=SVML")
endif()

# LTO (icpx supports standard LLVM -flto / -flto=thin)
if (OPTIMIZATIONS_USE_LTO)
    set(CMAKE_INTERPROCEDURAL_OPTIMIZATION ON)
    if (OPTIMIZATIONS_LTO_MODE STREQUAL "FULL")
        set(CMAKE_CXX_COMPILE_OPTIONS_IPO "-flto=full")
        set(CMAKE_C_COMPILE_OPTIONS_IPO "-flto=full")
        list(APPEND COMPILER_OPT_LINK_FLAGS "-flto=full")
    else()
        set(CMAKE_CXX_COMPILE_OPTIONS_IPO "-flto=thin")
        set(CMAKE_C_COMPILE_OPTIONS_IPO "-flto=thin")
        list(APPEND COMPILER_OPT_LINK_FLAGS "-flto=thin")
    endif()
endif()

# PGO
if (OPTIMIZATIONS_PGO_MODE STREQUAL "GENERATE")
    file(MAKE_DIRECTORY "${OPTIMIZATIONS_PGO_DIR}")
    list(APPEND COMPILER_OPT_CXX_FLAGS "-fprofile-generate=${OPTIMIZATIONS_PGO_DIR}")
    list(APPEND COMPILER_OPT_LINK_FLAGS "-fprofile-generate=${OPTIMIZATIONS_PGO_DIR}")
elseif (OPTIMIZATIONS_PGO_MODE STREQUAL "USE")
    list(APPEND COMPILER_OPT_CXX_FLAGS "-fprofile-use=${OPTIMIZATIONS_PGO_DIR}/default.profdata")
    list(APPEND COMPILER_OPT_LINK_FLAGS "-fprofile-use=${OPTIMIZATIONS_PGO_DIR}/default.profdata")
endif()

if (BUILD_SYSTEM_LINKER STREQUAL "LLD")
    list(APPEND COMPILER_OPT_LINK_FLAGS "-fuse-ld=lld")
elseif (BUILD_SYSTEM_LINKER STREQUAL "MOLD")
    list(APPEND COMPILER_OPT_LINK_FLAGS "-fuse-ld=mold")
endif()

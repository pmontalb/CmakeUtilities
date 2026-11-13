include_guard(GLOBAL)

# ==============================================================================
# GCC-Specific Optimization, LTO, PGO & Linker Flags (GCC 11+)
# ==============================================================================
set(COMPILER_OPT_CXX_FLAGS "")
set(COMPILER_OPT_LINK_FLAGS "")

# Fast-Math (avoid deprecated -Ofast in GCC 15+)
if (OPTIMIZATIONS_USE_FAST_MATH)
    list(APPEND COMPILER_OPT_CXX_FLAGS "-ffast-math" "-fno-math-errno")
elseif (OPTIMIZATIONS_USE_FAST_MATH_SAFE)
    list(APPEND COMPILER_OPT_CXX_FLAGS "-fno-math-errno" "-ffp-contract=fast" "-fno-signed-zeros" "-fno-trapping-math" "-fassociative-math" "-freciprocal-math")
endif()

# Graphite polyhedral loop optimizations
if (OPTIMIZATIONS_USE_MEMORY_OPTIMIZATION)
    list(APPEND COMPILER_OPT_CXX_FLAGS "-fgraphite-identity" "-floop-nest-optimize")
endif()

# Vector Math Library (glibc libmvec)
# On Linux glibc, GCC auto-vectorizes math via glibc <bits/math-vector.h> when -ffast-math / -fno-math-errno is enabled;
# -fveclib=libmvec is Clang-only and intentionally omitted here.
if (OPTIMIZATIONS_USE_VECTOR_MATH_LIB AND CMAKE_SYSTEM_NAME STREQUAL "Linux")
    list(APPEND COMPILER_OPT_LINK_FLAGS "-Wl,--as-needed")
endif()

# LTO
if (OPTIMIZATIONS_USE_LTO)
    set(CMAKE_INTERPROCEDURAL_OPTIMIZATION ON)
    list(APPEND COMPILER_OPT_CXX_FLAGS "-flto=auto" "-fno-fat-lto-objects")
    list(APPEND COMPILER_OPT_LINK_FLAGS "-flto=auto")
endif()

# PGO (Profile-Guided Optimization)
if (OPTIMIZATIONS_PGO_MODE STREQUAL "GENERATE")
    file(MAKE_DIRECTORY "${OPTIMIZATIONS_PGO_DIR}")
    list(APPEND COMPILER_OPT_CXX_FLAGS "-fprofile-generate=${OPTIMIZATIONS_PGO_DIR}")
    list(APPEND COMPILER_OPT_LINK_FLAGS "-fprofile-generate=${OPTIMIZATIONS_PGO_DIR}")
elseif (OPTIMIZATIONS_PGO_MODE STREQUAL "USE")
    list(APPEND COMPILER_OPT_CXX_FLAGS "-fprofile-use=${OPTIMIZATIONS_PGO_DIR}" "-fprofile-correction" "-Wno-missing-profile")
    list(APPEND COMPILER_OPT_LINK_FLAGS "-fprofile-use=${OPTIMIZATIONS_PGO_DIR}")
endif()

# Linker selection
if (BUILD_SYSTEM_LINKER STREQUAL "MOLD")
    if (CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL "12.0")
        list(APPEND COMPILER_OPT_LINK_FLAGS "-fuse-ld=mold")
    endif()
elseif (BUILD_SYSTEM_LINKER STREQUAL "LLD")
    list(APPEND COMPILER_OPT_LINK_FLAGS "-fuse-ld=lld")
elseif (BUILD_SYSTEM_LINKER STREQUAL "GOLD")
    list(APPEND COMPILER_OPT_LINK_FLAGS "-fuse-ld=gold")
endif()

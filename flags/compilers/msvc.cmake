include_guard(GLOBAL)

# ==============================================================================
# MSVC-Specific Optimization, LTO & Linker Flags
# ==============================================================================
set(COMPILER_OPT_CXX_FLAGS "")
set(COMPILER_OPT_LINK_FLAGS "")

# Fast-Math
if (OPTIMIZATIONS_USE_FAST_MATH)
    list(APPEND COMPILER_OPT_CXX_FLAGS "/fp:fast")
elseif (OPTIMIZATIONS_USE_FAST_MATH_SAFE)
    list(APPEND COMPILER_OPT_CXX_FLAGS "/fp:contract")
endif()

# Whole-Program Optimization / LTO
if (OPTIMIZATIONS_USE_LTO)
    set(CMAKE_INTERPROCEDURAL_OPTIMIZATION ON)
    list(APPEND COMPILER_OPT_CXX_FLAGS "/GL")
    list(APPEND COMPILER_OPT_LINK_FLAGS "/LTCG")
endif()

include_guard(GLOBAL)

# ==============================================================================
# AMD AOCC (Clang-based) Warning Flags (AOCC 3.2 -> 6.0+, up to LLVM 21.1)
# AOCC reports underlying LLVM/Clang version in CMAKE_CXX_COMPILER_VERSION.
# ==============================================================================
set(_EFFECTIVE_CLANG_VERSION "${CMAKE_CXX_COMPILER_VERSION}")
include(${CMAKE_CURRENT_LIST_DIR}/clang.cmake)

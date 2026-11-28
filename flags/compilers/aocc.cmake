include_guard(GLOBAL)

# ==============================================================================
# AMD AOCC (Clang-based) Optimization, LTO, PGO & Vector Math Flags
# ==============================================================================
set(COMPILER_OPT_CXX_FLAGS "")
set(COMPILER_OPT_LINK_FLAGS "")

# Prevent Ubuntu's system /usr/bin/clang-scan-deps-* from crashing against AOCC's LD_LIBRARY_PATH libLLVM
get_filename_component(_aocc_bin_dir "${CMAKE_CXX_COMPILER}" DIRECTORY)
if (EXISTS "${_aocc_bin_dir}/clang-scan-deps")
    set(CMAKE_CXX_COMPILER_CLANG_SCAN_DEPS "${_aocc_bin_dir}/clang-scan-deps" CACHE FILEPATH "" FORCE)
else()
    set(CMAKE_CXX_SCAN_FOR_MODULES OFF CACHE BOOL "" FORCE)
endif()

# Fast-Math
if (OPTIMIZATIONS_USE_FAST_MATH)
    list(APPEND COMPILER_OPT_CXX_FLAGS "-ffast-math" "-fno-math-errno")
elseif (OPTIMIZATIONS_USE_FAST_MATH_SAFE)
    list(APPEND COMPILER_OPT_CXX_FLAGS "-fno-math-errno" "-ffp-contract=fast" "-fno-trapping-math" "-fassociative-math" "-freciprocal-math")
endif()

# AMD Zen loop/memory & strided vectorization optimizations
if (OPTIMIZATIONS_USE_MEMORY_OPTIMIZATION)
    list(APPEND COMPILER_OPT_CXX_FLAGS
        "-mllvm" "-polly"
        "-mllvm" "-polly-vectorizer=stripmine"
        "-mllvm" "-enable-strided-vectorization"
        "-mllvm" "-inline-recursion=4"
    )
endif()

# AMDLIBM Vector Math Library
if (OPTIMIZATIONS_USE_VECTOR_MATH_LIB)
    list(APPEND COMPILER_OPT_CXX_FLAGS "-fveclib=AMDLIBM")
    get_filename_component(_aocc_root_dir "${_aocc_bin_dir}" DIRECTORY)
    if (EXISTS "${_aocc_root_dir}/lib")
        list(APPEND COMPILER_OPT_LINK_FLAGS "-L${_aocc_root_dir}/lib")
    endif()
    list(APPEND COMPILER_OPT_LINK_FLAGS "-lamdlibm")
endif()

# LTO
if (OPTIMIZATIONS_USE_LTO)
    set(CMAKE_INTERPROCEDURAL_OPTIMIZATION ON)
    if (EXISTS "${_aocc_bin_dir}/llvm-ar")
        set(CMAKE_AR "${_aocc_bin_dir}/llvm-ar" CACHE PATH "AR" FORCE)
        set(CMAKE_CXX_COMPILER_AR "${_aocc_bin_dir}/llvm-ar" CACHE FILEPATH "CXX AR" FORCE)
        set(CMAKE_CXX_ARCHIVE_CREATE_IPO "\"${_aocc_bin_dir}/llvm-ar\" qc <TARGET> <LINK_FLAGS> <OBJECTS>")
        set(CMAKE_CXX_ARCHIVE_APPEND_IPO "\"${_aocc_bin_dir}/llvm-ar\" q <TARGET> <LINK_FLAGS> <OBJECTS>")
        set(CMAKE_C_ARCHIVE_CREATE_IPO "\"${_aocc_bin_dir}/llvm-ar\" qc <TARGET> <LINK_FLAGS> <OBJECTS>")
        set(CMAKE_C_ARCHIVE_APPEND_IPO "\"${_aocc_bin_dir}/llvm-ar\" q <TARGET> <LINK_FLAGS> <OBJECTS>")
    elseif (CMAKE_CXX_COMPILER_AR)
        set(CMAKE_AR "${CMAKE_CXX_COMPILER_AR}" CACHE PATH "AR" FORCE)
    endif()
    if (EXISTS "${_aocc_bin_dir}/llvm-ranlib")
        set(CMAKE_RANLIB "${_aocc_bin_dir}/llvm-ranlib" CACHE PATH "RANLIB" FORCE)
        set(CMAKE_CXX_COMPILER_RANLIB "${_aocc_bin_dir}/llvm-ranlib" CACHE FILEPATH "CXX RANLIB" FORCE)
        set(CMAKE_CXX_ARCHIVE_FINISH_IPO "\"${_aocc_bin_dir}/llvm-ranlib\" <TARGET>")
        set(CMAKE_C_ARCHIVE_FINISH_IPO "\"${_aocc_bin_dir}/llvm-ranlib\" <TARGET>")
    elseif (CMAKE_CXX_COMPILER_RANLIB)
        set(CMAKE_RANLIB "${CMAKE_CXX_COMPILER_RANLIB}" CACHE PATH "RANLIB" FORCE)
    endif()
    if (OPTIMIZATIONS_LTO_MODE STREQUAL "THIN" AND CMAKE_CXX_COMPILER_VERSION VERSION_LESS "21.0")
        set(CMAKE_CXX_COMPILE_OPTIONS_IPO "-flto=thin")
        set(CMAKE_C_COMPILE_OPTIONS_IPO "-flto=thin")
        list(APPEND COMPILER_OPT_LINK_FLAGS "-flto=thin")
    else()
        if (OPTIMIZATIONS_LTO_MODE STREQUAL "THIN")
            message(STATUS "AOCC ${CMAKE_CXX_COMPILER_VERSION} does not support -flto=thin; using -flto=full")
        endif()
        set(CMAKE_CXX_COMPILE_OPTIONS_IPO "-flto=full")
        set(CMAKE_C_COMPILE_OPTIONS_IPO "-flto=full")
        list(APPEND COMPILER_OPT_LINK_FLAGS "-flto=full")
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

if (TOOLS_TIME_TRACE)
    list(APPEND COMPILER_OPT_CXX_FLAGS "-ftime-trace")
endif()

if (BUILD_SYSTEM_LINKER STREQUAL "LLD" OR (BUILD_SYSTEM_LINKER STREQUAL "AUTO" AND OPTIMIZATIONS_USE_LTO))
    find_program(_lld_prog NAMES ld.lld lld)
    if (_lld_prog)
        list(APPEND COMPILER_OPT_LINK_FLAGS "-fuse-ld=lld")
    endif()
elseif (BUILD_SYSTEM_LINKER STREQUAL "MOLD")
    list(APPEND COMPILER_OPT_LINK_FLAGS "-fuse-ld=mold")
endif()

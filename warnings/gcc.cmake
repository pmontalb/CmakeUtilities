include_guard(GLOBAL)

# ==============================================================================
# GCC Warning Flags (Version-Gated for Recent GCC: 11, 12, 13, 14, 15+)
# Enables every high-signal C++ warning bar reasonable noise exclusions:
#   Excluded: -Wabi, -Wabi-tag, -Waggregate-return, -Wpadded, -Wsystem-headers,
#             -Winline, -Weffc++, -Wswitch-enum, -Wmultiple-inheritance,
#             -Wvirtual-inheritance, -Wnamespaces, -Wtemplates,
#             -Wsuggest-final-*, -Wsuggest-attribute=*, -Wleading/trailing-whitespace
# ==============================================================================
list(APPEND WARNING_FLAGS -Wno-unknown-pragmas -Wno-unused-function)

if (NOT WARNINGS_USE_PEDANTIC_WARNINGS)
    return()
endif()

message(STATUS "Enabling exhaustive GCC (${CMAKE_CXX_COMPILER_VERSION}) C++ warnings")

set(PEDANTIC_WARNING_FLAGS ${WARNING_FLAGS}
    -Wall
    -Wextra
    -Wpedantic

    # Type & Conversion Safety
    -Wconversion
    -Wsign-conversion
    -Wfloat-conversion
    -Warith-conversion
    -Wdouble-promotion
    -Wfloat-equal
    -Wcast-qual
    -Wcast-align=strict
    -Wold-style-cast
    -Wuseless-cast
    -Wzero-as-null-pointer-constant
    -Wsign-promo
    -Wdeprecated-enum-enum-conversion
    -Wdeprecated-enum-float-conversion

    # C++ Semantics & Object Lifecycle
    -Wnon-virtual-dtor
    -Woverloaded-virtual
    -Wsuggest-override
    -Wctor-dtor-privacy
    -Wmismatched-tags
    -Wredundant-tags
    -Wnoexcept
    -Wdeprecated-copy-dtor
    -Wctad-maybe-unsupported
    -Wcomma-subscript
    -Wvolatile
    -Wregister
    -Wconditionally-supported
    -Wstrict-null-sentinel
    -Wsynth

    # Control Flow & Logic
    -Wshadow
    -Wduplicated-cond
    -Wduplicated-branches
    -Wlogical-op
    -Wnull-dereference
    -Wswitch-default
    -Wimplicit-fallthrough=5
    -Winit-self

    # Memory, Bounds & Format Safety
    -Walloc-zero
    -Walloca
    -Wformat=2
    -Wformat-signedness
    -Wformat-y2k
    -Wstringop-overflow=4
    -Warray-bounds=2
    -Wshift-overflow=2
    -Wplacement-new=2
    -Wstrict-aliasing=3
    -Wstrict-overflow=2
    -Wstack-protector
    -Wtrampolines
    -Wmismatched-dealloc
    -Wrange-loop-construct
    -Wstring-compare
    -Wzero-length-bounds

    # Declarations, Macros & Cleanliness
    -Wmissing-declarations
    -Wmissing-include-dirs
    -Wredundant-decls
    -Wundef
    -Wunused-macros
    -Wunused-const-variable=2
    -Wdate-time
    -Wextra-semi
    -Wmultichar
    -Wpacked
    -Winvalid-pch
    -Wwrite-strings
    -Wvector-operation-performance
    -Wdisabled-optimization
)

# GCC 12+ (2022)
if (CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL "12.0")
    list(APPEND PEDANTIC_WARNING_FLAGS
        -Warray-compare
        -Wbidi-chars=any
        -Wdangling-pointer=2
        -Wopenacc-parallelism
        -Wtrivial-auto-var-init
        -Wuse-after-free=3
    )
endif()

# GCC 13+ (2023)
if (CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL "13.0")
    list(APPEND PEDANTIC_WARNING_FLAGS
        -Wdangling-reference
        -Wself-move
        -Wxor-used-as-pow
        -Winvalid-utf8
    )
endif()

# GCC 14+ (2024)
if (CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL "14.0")
    list(APPEND PEDANTIC_WARNING_FLAGS
        -Walloc-size
        -Wenum-conversion
        -Wnrvo
        -Wtemplate-id-cdtor
    )
endif()

# GCC 15+ (2025)
if (CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL "15.0")
    list(APPEND PEDANTIC_WARNING_FLAGS
        -Wdeprecated-literal-operator
        -Wdeprecated-variadic-comma-omission
        -Wheader-guard
        -Wflex-array-member-not-at-end
        -Wtemplate-body
    )
endif()

# GCC 16+ (2026)
if (CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL "16.0")
    list(APPEND PEDANTIC_WARNING_FLAGS
        -Wunused-but-set-variable=3
        -Wunused-but-set-parameter=3
    )
endif()

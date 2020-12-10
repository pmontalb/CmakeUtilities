include_guard()

set(WARNING_FLAGS "")
mark_as_advanced(WARNING_FLAGS)

if (WARNINGS_USE_WALL_AND_WEXTRA)
    message(STATUS "Use -Wall and -Wextra")
    if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
        set(WARNING_FLAGS ${WARNING_FLAGS} /W4)
    else()
        set(WARNING_FLAGS ${WARNING_FLAGS} -Wall -Wextra)
    endif()
endif()

if (WARNINGS_TREAT_WARNINGS_AS_ERROR)
    message(STATUS "Use -Werror")
    if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
        set(WARNING_FLAGS ${WARNING_FLAGS} /WX)
    else()
        set(WARNING_FLAGS ${WARNING_FLAGS} -Werror)
    endif()
endif()

# disable basic warnings
if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
    set(WARNING_FLAGS ${WARNING_FLAGS} -Wno-unused-function)
elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
    set(WARNING_FLAGS ${WARNING_FLAGS} -Wno-unknown-pragmas -Wno-unused-function -Wno-unused-macros)
elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel")
    set(WARNING_FLAGS ${WARNING_FLAGS} -Wno-unknown-pragmas -Wno-unused-function)
elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
    set(WARNING_FLAGS ${WARNING_FLAGS} /wd4820 /wd4324 /wd4623 /wd4626 /wd5027 /wd4514 /wd4710 /wd5045 /wd4668)
endif()

set(PEDANTIC_WARNING_FLAGS "")
mark_as_advanced(PEDANTIC_WARNING_FLAGS)

if (WARNINGS_USE_PEDANTIC_WARNINGS)
    message(STATUS "Use pedantic warnings")

    if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
        if (NOT "${CMAKE_BUILD_TYPE}" STREQUAL "Stan" AND NOT "${CMAKE_BUILD_TYPE}" STREQUAL "IWYU")
	    if ("${CMAKE_CXX_COMPILER_VERSION}" MATCHES "11.")
            set(UNKNOWN_CUDA_WARNING -Wno-unknown-cuda-version)
	    else()
            set(UNKNOWN_CUDA_WARNING "")
	    endif()
	    mark_as_advanced(UNKNOWN_CUDA_WARNING)

            set(PEDANTIC_WARNING_FLAGS ${WARNING_FLAGS} -Weverything
                    ${UNKNOWN_CUDA_WARNING}
                    -Wno-c++98-compat
                    -Wno-c++98-compat-pedantic
                    -Wno-reserved-id-macro
                    -Wno-switch-enum
                    -Wno-unknown-pragmas
                    -Wno-disabled-macro-expansion
                    -Wno-unneeded-internal-declaration
                    -Wno-weak-vtables
                    -Wno-padded
                    -Wno-unused-macros
                    -Wno-exit-time-destructors
                    -Wno-unused-template
                    -Wno-covered-switch-default
                    -Wno-global-constructors
                    -Wno-missing-noreturn)
        endif()
    elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
        if ("${CMAKE_CXX_COMPILER_VERSION}" MATCHES "9.")
            # https://raw.githubusercontent.com/Barro/compiler-warnings/master/gcc/warnings-gcc-top-level-8.txt
            set(PEDANTIC_WARNING_FLAGS ${WARNING_FLAGS}
                    #-Wabi-tag
                    #-Waggregate-return
                    -Waggressive-loop-optimizations
                    -Wall
                    -Walloc-zero
                    -Walloca
                    -Wattribute-alias
                    -Wattributes
                    -Wbuiltin-declaration-mismatch
                    -Wbuiltin-macro-redefined
                    -Wcast-align
                    -Wcast-align=strict
                    -Wcast-qual
                    -Wconditionally-supported
                    -Wconversion
                    -Wconversion-null
                    -Wcoverage-mismatch
                    -Wcpp
                    -Wctor-dtor-privacy
                    -Wdate-time
                    -Wdelete-incomplete
                    -Wdeprecated
                    -Wdeprecated-declarations
                    -Wdisabled-optimization
                    -Wdiv-by-zero
                    -Wdouble-promotion
                    -Wduplicated-branches
                    -Wduplicated-cond
                    -Weffc++
                    -Wextra-semi
                    -Wfloat-equal
                    -Wformat-signedness
                    -Wfree-nonheap-object
                    -Whsa
                    -Wif-not-aligned
                    -Wignored-attributes
                    -Wimport # DUMMY switch
                    -Winherited-variadic-ctor
    #                -Winline
                    -Wint-to-pointer-cast
                    -Winvalid-memory-model
                    -Winvalid-offsetof
                    -Winvalid-pch
                    -Wliteral-suffix
                    -Wlogical-op
                    -Wlto-type-mismatch
                    -Wmissing-declarations
                    -Wmissing-include-dirs
                    -Wmultichar
                    -Wnoexcept
                    -Wnon-template-friend
                    -Wnull-dereference
                    -Wodr
                    -Wold-style-cast
                    -Woverflow
                    #-Woverloaded-virtual
                    -Wpacked
                    -Wpacked-bitfield-compat
                    #-Wpadded
                    -Wpedantic
                    -Wpmf-conversions
                    -Wpointer-compare
                    -Wpragmas
                    -Wredundant-decls
                    -Wregister
                    -Wreturn-local-addr
                    -Wscalar-storage-order
                    -Wshadow
                    -Wshift-count-negative
                    -Wshift-count-overflow
                    -Wshift-negative-value
                    -Wsign-promo
                    -Wsizeof-array-argument
                    -Wstack-protector
                    -Wstrict-aliasing
                    -Wstrict-null-sentinel
                    -Wstrict-overflow
                    -Wsubobject-linkage
    #                -Wsuggest-attribute=cold
    #                -Wsuggest-attribute=const
    #                -Wsuggest-attribute=format
    #                -Wsuggest-attribute=malloc
    #                -Wsuggest-attribute=noreturn
    #                -Wsuggest-attribute=pure
    #                -Wsuggest-final-methods
    #                -Wsuggest-final-types
                    -Wsuggest-override
                    -Wswitch-bool
                    -Wswitch-default
                    #-Wswitch-enum
                    -Wswitch-unreachable
                    -Wsync-nand
                    -Wsynth
                    -Wterminate
                    -Wtrampolines
                    #-Wundef
                    -Wunreachable-code # DUMMY switch
                    -Wunsafe-loop-optimizations # DUMMY switch
                    -Wunused-result
                    -Wuseless-cast
                    -Wvarargs
                    -Wvector-operation-performance
                    -Wvirtual-inheritance
                    -Wvirtual-move-assign
                    -Wvla
                    -Wwrite-strings
                    -Wzero-as-null-pointer-constant)
        elseif ("${CMAKE_CXX_COMPILER_VERSION}" MATCHES "7.")
            set(PEDANTIC_WARNING_FLAGS ${WARNING_FLAGS}
                    #-Wabi-tag
                    #-Waggregate-return
                    -Waggressive-loop-optimizations
                    -Wall
                    -Walloc-zero
                    -Walloca
                    -Wattributes
                    -Wbuiltin-declaration-mismatch
                    -Wbuiltin-macro-redefined
                    -Wcast-align
                    -Wcast-qual
                    -Wconditionally-supported
                    -Wconversion
                    -Wconversion-null
                    -Wcoverage-mismatch
                    -Wcpp
                    -Wctor-dtor-privacy
                    -Wdate-time
                    -Wdelete-incomplete
                    -Wdeprecated
                    -Wdeprecated-declarations
                    -Wdisabled-optimization
                    -Wdiv-by-zero
                    -Wdouble-promotion
                    -Wduplicated-branches
                    -Wduplicated-cond
                    -Weffc++
                    -Wfloat-equal
                    -Wformat-signedness
                    -Wfree-nonheap-object
                    -Whsa
                    -Wignored-attributes
                    -Wimport # DUMMY switch
                    -Winherited-variadic-ctor
                    #                -Winline
                    -Wint-to-pointer-cast
                    -Winvalid-memory-model
                    -Winvalid-offsetof
                    -Winvalid-pch
                    -Wliteral-suffix
                    -Wlogical-op
                    -Wlto-type-mismatch
                    -Wmissing-declarations
                    -Wmissing-include-dirs
                    -Wmultichar
                    -Wnoexcept
                    -Wnon-template-friend
                    -Wnull-dereference
                    -Wodr
                    -Wold-style-cast
                    -Woverflow
                    #-Woverloaded-virtual
                    -Wpacked
                    -Wpacked-bitfield-compat
                    #-Wpadded
                    -Wpedantic
                    -Wpmf-conversions
                    -Wpointer-compare
                    -Wpragmas
                    -Wredundant-decls
                    -Wregister
                    -Wreturn-local-addr
                    -Wscalar-storage-order
                    -Wshadow
                    -Wshift-count-negative
                    -Wshift-count-overflow
                    -Wshift-negative-value
                    -Wsign-promo
                    -Wsizeof-array-argument
                    -Wstack-protector
                    -Wstrict-aliasing
                    -Wstrict-null-sentinel
                    -Wstrict-overflow
                    -Wsubobject-linkage
                    #                -Wsuggest-attribute=cold
                    #                -Wsuggest-attribute=const
                    #                -Wsuggest-attribute=format
                    #                -Wsuggest-attribute=malloc
                    #                -Wsuggest-attribute=noreturn
                    #                -Wsuggest-attribute=pure
                    #                -Wsuggest-final-methods
                    #                -Wsuggest-final-types
                    -Wsuggest-override
                    -Wswitch-bool
                    -Wswitch-default
                    #-Wswitch-enum
                    -Wswitch-unreachable
                    -Wsync-nand
                    -Wsynth
                    -Wterminate
                    -Wtrampolines
                    #-Wundef
                    -Wunreachable-code # DUMMY switch
                    -Wunsafe-loop-optimizations # DUMMY switch
                    -Wunused-result
                    -Wuseless-cast
                    -Wvarargs
                    -Wvector-operation-performance
                    -Wvirtual-inheritance
                    -Wvirtual-move-assign
                    -Wvla
                    -Wwrite-strings
                    -Wzero-as-null-pointer-constant)
        elseif ("${CMAKE_CXX_COMPILER_VERSION}" MATCHES "8.")
            set(PEDANTIC_WARNING_FLAGS ${WARNING_FLAGS}
                    #-Wabi-tag
                    #-Waggregate-return
                    -Waggressive-loop-optimizations
                    -Wall
                    -Walloc-zero
                    -Walloca
                    -Wattributes
                    -Wbuiltin-declaration-mismatch
                    -Wbuiltin-macro-redefined
                    -Wcast-align
                    -Wcast-qual
                    -Wconditionally-supported
                    -Wconversion
                    -Wconversion-null
                    -Wcoverage-mismatch
                    -Wcpp
                    -Wctor-dtor-privacy
                    -Wdate-time
                    -Wdelete-incomplete
                    -Wdeprecated
                    -Wdeprecated-declarations
                    -Wdisabled-optimization
                    -Wdiv-by-zero
                    -Wdouble-promotion
                    -Wduplicated-branches
                    -Wduplicated-cond
                    -Weffc++
                    -Wfloat-equal
                    -Wformat-signedness
                    -Wfree-nonheap-object
                    -Whsa
                    -Wignored-attributes
                    -Wimport # DUMMY switch
                    -Winherited-variadic-ctor
                    #                -Winline
                    -Wint-to-pointer-cast
                    -Winvalid-memory-model
                    -Winvalid-offsetof
                    -Winvalid-pch
                    -Wliteral-suffix
                    -Wlogical-op
                    -Wlto-type-mismatch
                    -Wmissing-declarations
                    -Wmissing-include-dirs
                    -Wmultichar
                    -Wnoexcept
                    -Wnon-template-friend
                    -Wnull-dereference
                    -Wodr
                    -Wold-style-cast
                    -Woverflow
                    #-Woverloaded-virtual
                    -Wpacked
                    -Wpacked-bitfield-compat
                    #-Wpadded
                    -Wpedantic
                    -Wpmf-conversions
                    -Wpointer-compare
                    -Wpragmas
                    -Wredundant-decls
                    -Wregister
                    -Wreturn-local-addr
                    -Wscalar-storage-order
                    -Wshadow
                    -Wshift-count-negative
                    -Wshift-count-overflow
                    -Wshift-negative-value
                    -Wsign-promo
                    -Wsizeof-array-argument
                    -Wstack-protector
                    -Wstrict-aliasing
                    -Wstrict-null-sentinel
                    -Wstrict-overflow
                    -Wsubobject-linkage
                    #                -Wsuggest-attribute=cold
                    #                -Wsuggest-attribute=const
                    #                -Wsuggest-attribute=format
                    #                -Wsuggest-attribute=malloc
                    #                -Wsuggest-attribute=noreturn
                    #                -Wsuggest-attribute=pure
                    #                -Wsuggest-final-methods
                    #                -Wsuggest-final-types
                    -Wsuggest-override
                    -Wswitch-bool
                    -Wswitch-default
                    #-Wswitch-enum
                    -Wswitch-unreachable
                    -Wsync-nand
                    -Wsynth
                    -Wterminate
                    -Wtrampolines
                    #-Wundef
                    -Wunreachable-code # DUMMY switch
                    -Wunsafe-loop-optimizations # DUMMY switch
                    -Wunused-result
                    -Wuseless-cast
                    -Wvarargs
                    -Wvector-operation-performance
                    -Wvirtual-inheritance
                    -Wvirtual-move-assign
                    -Wvla
                    -Wwrite-strings
                    -Wzero-as-null-pointer-constant)
        endif()

    elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel")
        set(PEDANTIC_WARNING_FLAGS ${WARNING_FLAGS} -w3 -diag-disable:remark -Wall -Wcheck -Werror -Werror-all -Wformat -Wformat-security
                	                                -Wmissing-declarations -Wmissing-prototypes -Wnon-virtual-dtor
                                                    -Wpointer-arith -Wreorder -Wshadow -Wsign-compare
                                                    -Wstrict-prototypes -Wtrigraphs -Wuninitialized)
    elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
        set(PEDANTIC_WARNING_FLAGS ${WARNING_FLAGS} /Wall)
    endif()

endif()

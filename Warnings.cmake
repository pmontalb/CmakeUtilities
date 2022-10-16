include_guard()

set(WARNING_FLAGS "" CACHE STRING "")
mark_as_advanced(WARNING_FLAGS)

if (WARNINGS_USE_WALL_AND_WEXTRA)
	message(STATUS "Use -Wall and -Wextra")
	if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
		set(WARNING_FLAGS ${WARNING_FLAGS} /W4)
	else ()
		set(WARNING_FLAGS ${WARNING_FLAGS} -Wall -Wextra)
	endif ()
endif ()

if (WARNINGS_TREAT_WARNINGS_AS_ERROR)
	message(STATUS "Use -Werror")
	if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
		set(WARNING_FLAGS ${WARNING_FLAGS} /WX)
	else ()
		set(WARNING_FLAGS ${WARNING_FLAGS} -Werror)
	endif ()
endif ()

# disable basic warnings
if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
	set(WARNING_FLAGS ${WARNING_FLAGS} -Wno-unused-function)
elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
	set(WARNING_FLAGS ${WARNING_FLAGS} -Wno-unknown-pragmas -Wno-unused-function -Wno-unused-macros)
elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "IntelLLVM")
	set(WARNING_FLAGS ${WARNING_FLAGS} -Wno-unknown-pragmas -Wno-unused-function)
elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
	set(WARNING_FLAGS ${WARNING_FLAGS} /wd4820 /wd4324 /wd4623 /wd4626 /wd5027 /wd4514 /wd4710 /wd5045 /wd4668)
endif ()

set(PEDANTIC_WARNING_FLAGS "" CACHE STRING "")
mark_as_advanced(PEDANTIC_WARNING_FLAGS)

if (WARNINGS_USE_PEDANTIC_WARNINGS)
	message(STATUS "Use pedantic warnings")

	if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
		set(PEDANTIC_WARNING_FLAGS ${WARNING_FLAGS} -Weverything
				-Wno-c++98-compat
				-Wno-c++98-compat-pedantic
				-Wno-reserved-id-macro
				-Wno-switch-enum
				-Wno-disabled-macro-expansion
				-Wno-weak-vtables
				-Wno-padded
				-Wno-covered-switch-default
				-Wno-exit-time-destructors
				-Wno-global-constructors
				-Wno-ctad-maybe-unsupported
				-Wno-weak-template-vtables
				-Wno-reserved-identifier)
	elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
		### https://raw.githubusercontent.com/Barro/compiler-warnings/master/gcc/warnings-gcc-top-level-8.txt ###
		set(PEDANTIC_WARNING_FLAGS ${WARNING_FLAGS}
			### -Wabi
			#    -Wnoexcept-type
			#    -Wpsabi
			### -Wabi-tag
			### -Wabi=
			### -Waggregate-return
			-Waggressive-loop-optimizations
			-Wall
			#    -Waddress
			#    -Waligned-new=
			#    -Walloc-size-larger-than=
			#    -Warray-bounds
			#    -Warray-bounds=
			#    -Wbool-compare
			#    -Wbool-operation
			#    -Wc++11-compat
			#      -Wnarrowing
			#    -Wc++14-compat
			#    -Wc++17-compat
			#      -Wnoexcept-type
			#    -Wcatch-value=
			#    -Wchar-subscripts
			#    -Wchkp
			#    -Wclass-memaccess
			#    -Wcomment
			#    -Wdelete-non-virtual-dtor
			#    -Wduplicate-decl-specifier
			#    -Wenum-compare
			#    -Wformat=
			#      -Wformat-contains-nul
			#      -Wformat-extra-args
			#      -Wformat-nonliteral
			#      -Wformat-overflow=
			#      -Wformat-security
			#      -Wformat-truncation=
			#      -Wformat-y2k
			#      -Wformat-zero-length
			#      -Wnonnull
			#    -Wframe-address
			#    -Wimplicit
			#      -Wimplicit-function-declaration
			#      -Wimplicit-int
			#    -Winit-self
			#    -Wint-in-bool-context
			#    -Wlogical-not-parentheses
			#    -Wmain
			#    -Wmaybe-uninitialized
			#    -Wmemset-elt-size
			#    -Wmemset-transposed-args
			#    -Wmisleading-indentation
			#    -Wmissing-attributes
			#    -Wmissing-braces
			#    -Wmultistatement-macros
			#    -Wnarrowing
			#    -Wnonnull
			#    -Wnonnull-compare
			#    -Wopenmp-simd
			#    -Wpacked-not-aligned
			#    -Wparentheses
			#      -Wdangling-else
			#    -Wpointer-sign
			#    -Wreorder
			#    -Wrestrict
			#    -Wreturn-type
			#    -Wsequence-point
			#    -Wsign-compare
			#    -Wsizeof-pointer-div
			#    -Wsizeof-pointer-memaccess
			#    -Wstrict-aliasing=
			#    -Wstrict-overflow=
			#    -Wstringop-overflow=
			#    -Wstringop-truncation
			#    -Wswitch
			#    -Wtautological-compare
			#    -Wtrigraphs
			#    -Wuninitialized
			#      -Wmaybe-uninitialized
			#    -Wunknown-pragmas
			#    -Wunused
			#      -Wunused-but-set-variable
			#      -Wunused-function
			#      -Wunused-label
			#      -Wunused-local-typedefs
			#      -Wunused-value
			#      -Wunused-variable
			#        -Wunused-const-variable=
			#    -Wvolatile-register-var
			-Walloc-zero
			-Walloca
			### -Walloca-larger-than=
			### -Wassign-intercept
			-Wattribute-alias
			-Wattributes
			### -Wbad-function-cast
			-Wbuiltin-declaration-mismatch
			-Wbuiltin-macro-redefined
			### -Wc++-compat
			#    -Wenum-compare
			### -Wc90-c99-compat
			#    -Wlong-long
			### -Wc99-c11-compat
			-Wcast-align
			-Wcast-align=strict
			-Wcast-qual
			-Wconditionally-supported
			-Wconversion
			#    -Wfloat-conversion
			#    -Wsign-conversion
			-Wconversion-null
			-Wcoverage-mismatch
			-Wcpp
			-Wctor-dtor-privacy
			-Wdate-time
			### -Wdeclaration-after-statement
			-Wdelete-incomplete
			-Wdeprecated
			-Wdeprecated-declarations
			### -Wdesignated-init
			-Wdisabled-optimization
			### -Wdiscarded-array-qualifiers
			### -Wdiscarded-qualifiers
			-Wdiv-by-zero
			-Wdouble-promotion
			-Wduplicated-branches
			-Wduplicated-cond
			-Weffc++
			#    -Wdelete-non-virtual-dtor
			#    -Wnon-virtual-dtor
			-Wextra
			#    -Wcast-function-type
			#    -Wclobbered
			#    -Wempty-body
			#    -Wignored-qualifiers
			#    -Wimplicit-fallthrough=
			#    -Wmissing-field-initializers
			#    -Wmissing-parameter-type
			#    -Wold-style-declaration
			#    -Woverride-init
			#    -Wsign-compare
			#    -Wsized-deallocation
			#    -Wtype-limits
			#    -Wuninitialized
			#      -Wmaybe-uninitialized
			#    -Wunused-but-set-parameter
			#    -Wunused-parameter
			-Wextra-semi
			-Wfloat-equal
			-Wformat-signedness
			### -Wframe-larger-than=
			-Wfree-nonheap-object
			-Whsa
			-Wif-not-aligned
			-Wignored-attributes
			-Wimport # DUMMY switch
			### -Wincompatible-pointer-types
			-Winherited-variadic-ctor
			### -Winline
			### -Wint-conversion
			-Wint-to-pointer-cast
			-Winvalid-memory-model
			-Winvalid-offsetof
			-Winvalid-pch
			### -Wjump-misses-init
			### -Wlarger-than=
			-Wliteral-suffix
			-Wlogical-op
			-Wlto-type-mismatch
			-Wmismatched-tags
			-Wmissing-declarations
			-Wmissing-include-dirs
			### -Wmissing-prototypes
			### -Wmudflap # DUMMY switch
			-Wmultichar
			### -Wmultiple-inheritance
			### -Wnamespaces
			### -Wnested-externs
			-Wnoexcept
			-Wnon-template-friend
			### -Wnormalized=
			-Wnull-dereference
			-Wodr
			-Wold-style-cast
			### -Wold-style-definition
			-Woverflow
			-Woverloaded-virtual
			### -Woverride-init-side-effects
			-Wpacked
			-Wpacked-bitfield-compat
			### -Wpadded
			-Wpedantic
			#    -Wendif-labels
			#    -Wexpansion-to-defined
			#    -Wmain
			#    -Woverlength-strings
			#    -Wpointer-arith
			#    -Wpointer-sign
			#    -Wvariadic-macros
			### -Wplacement-new=
			-Wpmf-conversions
			-Wpointer-compare
			### -Wpointer-to-int-cast
			-Wpragmas
			### -Wproperty-assign-default
			### -Wprotocol
			-Wredundant-decls
			-Wredundant-tags
			-Wregister
			-Wreturn-local-addr
			-Wscalar-storage-order
			### -Wselector
			-Wshadow
			#    -Wshadow-ivar
			#    -Wshadow=local
			#      -Wshadow=compatible-local
			-Wshift-count-negative
			-Wshift-count-overflow
			-Wshift-negative-value
			### -Wshift-overflow=
			-Wsign-promo
			-Wsizeof-array-argument
			-Wstack-protector
			### -Wstack-usage=
			-Wstrict-aliasing
			-Wstrict-null-sentinel
			-Wstrict-overflow
			### -Wstrict-prototypes
			### -Wstrict-selector-match
			-Wsubobject-linkage
			### -Wsuggest-attribute=cold
			### -Wsuggest-attribute=const
			### -Wsuggest-attribute=format
			### -Wsuggest-attribute=malloc
			### -Wsuggest-attribute=noreturn
			### -Wsuggest-attribute=pure
			### -Wsuggest-final-methods
			### -Wsuggest-final-types
			-Wsuggest-override
			-Wswitch-bool
			-Wswitch-default
			### -Wswitch-enum
			-Wswitch-unreachable
			-Wsync-nand
			-Wsynth
			### -Wsystem-headers
			### -Wtemplates
			-Wterminate
			### -Wtraditional
			#    -Wvariadic-macros
			### -Wtraditional-conversion
			-Wtrampolines
			### -Wundeclared-selector
			### -Wundef
			-Wunreachable-code # DUMMY switch
			-Wunsafe-loop-optimizations # DUMMY switch
			### -Wunsuffixed-float-constants
			-Wunused-macros
			-Wunused-result
			-Wuseless-cast
			-Wvarargs
			-Wvector-operation-performance
			-Wvirtual-inheritance
			-Wvirtual-move-assign
			-Wvla
			### -Wvla-larger-than=
			-Wwrite-strings
			-Wzero-as-null-pointer-constant)

	elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "IntelLLVM")
		set(PEDANTIC_WARNING_FLAGS ${WARNING_FLAGS} -Wall -Werror -Wformat -Wformat-security
			-Wmissing-declarations -Wmissing-prototypes -Wnon-virtual-dtor
			-Wpointer-arith -Wreorder -Wshadow -Wsign-compare
			-Wstrict-prototypes -Wtrigraphs -Wuninitialized)
	elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
		set(PEDANTIC_WARNING_FLAGS ${WARNING_FLAGS} /Wall)
	endif ()
endif()

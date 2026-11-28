include_guard(GLOBAL)

# ==============================================================================
# Emscripten (em++) Warning Flags (Emscripten 2.x -> 4.x)
# ==============================================================================
set(_EFFECTIVE_CLANG_VERSION "${CMAKE_CXX_COMPILER_VERSION}")
include(${CMAKE_CURRENT_LIST_DIR}/clang.cmake)

if (WARNINGS_USE_PEDANTIC_WARNINGS)
    # Emscripten-specific reasonable exclusions
    list(APPEND PEDANTIC_WARNING_FLAGS
        -Wno-pthreads-mem-growth
        -Wno-dollar-in-identifier-extension
    )
    if (_EFFECTIVE_CLANG_VERSION VERSION_GREATER_EQUAL "21.0")
        list(APPEND PEDANTIC_WARNING_FLAGS
            -Wno-unique-object-duplication
        )
    endif()
endif()

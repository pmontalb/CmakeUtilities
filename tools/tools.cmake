include_guard(GLOBAL)

# ==============================================================================
# Developer Tooling Dispatcher
# ==============================================================================
include(${CMAKE_CURRENT_LIST_DIR}/launchers.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/clang_tidy.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/iwyu.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/graphviz.cmake)

if (LANGUAGES_USE_CUDA)
    include(${CMAKE_CURRENT_LIST_DIR}/cuda.cmake)
endif()

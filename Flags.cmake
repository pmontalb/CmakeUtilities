include_guard(GLOBAL)

# Backward-compatible entrypoint forwarding to modular flags/ and warnings/
set(_utils_root "${CMAKE_CURRENT_LIST_DIR}")

include(${_utils_root}/Options.cmake)
include(${_utils_root}/flags/standards.cmake)
include(${_utils_root}/flags/compilers.cmake)
include(${_utils_root}/flags/configurations.cmake)
include(${_utils_root}/flags/architectures.cmake)
include(${_utils_root}/flags/optimizations.cmake)
include(${_utils_root}/flags/debug.cmake)
include(${_utils_root}/flags/sanitizers.cmake)
include(${_utils_root}/flags/coverage.cmake)
include(${_utils_root}/warnings/warnings.cmake)
include(${_utils_root}/tools/tools.cmake)

include_guard(GLOBAL)

function(create_executable)
    create_target(TARGET_TYPE "EXE" ${ARGN})
endfunction()

function(create_library)
    create_target(TARGET_TYPE "LIB" ${ARGN})
endfunction()

function(create_static_library)
    create_target(TARGET_TYPE "STATIC_LIB" ${ARGN})
endfunction()

function(create_test)
    create_target(TARGET_TYPE "TEST" ${ARGN})
endfunction()

function(create_cuda_executable)
    create_cuda_target(TARGET_TYPE "EXE" ${ARGN})
endfunction()

function(create_cuda_library)
    create_cuda_target(TARGET_TYPE "LIB" ${ARGN})
endfunction()

function(create_cuda_static_library)
    create_cuda_target(TARGET_TYPE "STATIC_LIB" ${ARGN})
endfunction()

function(create_cuda_test)
    create_cuda_target(TARGET_TYPE "TEST" ${ARGN})
endfunction()

function(create_target)
    cmake_parse_arguments(
        PREFIX
        "DO_NOT_USE_WARNINGS;DO_NOT_USE_PEDANTIC_WARNINGS;GPU"
        "NAME;TARGET_TYPE;"
        "SOURCES;PUBLIC_INCLUDE_DIRECTORIES;PRIVATE_INCLUDE_DIRECTORIES;PUBLIC_SYSTEM_INCLUDE_DIRECTORIES;PRIVATE_SYSTEM_INCLUDE_DIRECTORIES;PUBLIC_COMPILE_DEFINITIONS;PRIVATE_COMPILE_DEFINITIONS;DEPENDENCIES;SYSTEM_DEPENDENCIES"
        ${ARGN}
    )

    if (PREFIX_TARGET_TYPE STREQUAL "EXE")
        add_executable(${PREFIX_NAME} ${PREFIX_SOURCES})
    elseif (PREFIX_TARGET_TYPE STREQUAL "LIB")
        add_library(${PREFIX_NAME} ${PREFIX_SOURCES})
    elseif (PREFIX_TARGET_TYPE STREQUAL "STATIC_LIB")
        add_library(${PREFIX_NAME} STATIC ${PREFIX_SOURCES})
    elseif (PREFIX_TARGET_TYPE STREQUAL "TEST")
        add_executable(${PREFIX_NAME} ${PREFIX_SOURCES})
    endif()

    if (NOT PREFIX_DO_NOT_USE_WARNINGS)
        if (NOT PREFIX_DO_NOT_USE_PEDANTIC_WARNINGS AND WARNINGS_USE_PEDANTIC_WARNINGS)
            target_compile_options(${PREFIX_NAME} PRIVATE ${PEDANTIC_WARNING_FLAGS})
        else()
            target_compile_options(${PREFIX_NAME} PRIVATE ${WARNING_FLAGS})
        endif()
    endif()

    target_include_directories(${PREFIX_NAME} PUBLIC ${PREFIX_PUBLIC_INCLUDE_DIRECTORIES})
    target_include_directories(${PREFIX_NAME} PRIVATE ${PREFIX_PRIVATE_INCLUDE_DIRECTORIES} "${CMAKE_SOURCE_DIR}")
    if (NOT EXISTS "${CMAKE_SOURCE_DIR}/IgnoreWarning.h")
        target_include_directories(${PREFIX_NAME} PRIVATE "${CMAKE_UTILS_ROOT}/Utilities")
    endif()
    target_include_directories(${PREFIX_NAME} SYSTEM PUBLIC ${PREFIX_PUBLIC_SYSTEM_INCLUDE_DIRECTORIES})
    target_include_directories(${PREFIX_NAME} SYSTEM PRIVATE ${PREFIX_PRIVATE_SYSTEM_INCLUDE_DIRECTORIES})

    target_compile_definitions(${PREFIX_NAME} PUBLIC ${PREFIX_PUBLIC_COMPILE_DEFINITIONS})
    target_compile_definitions(${PREFIX_NAME} PRIVATE ${PREFIX_PRIVATE_COMPILE_DEFINITIONS})

    target_link_libraries(${PREFIX_NAME} ${PREFIX_DEPENDENCIES})
    target_link_libraries(${PREFIX_NAME} ${PREFIX_SYSTEM_DEPENDENCIES})

    if (PREFIX_TARGET_TYPE STREQUAL "TEST")
        _register_test_target(${PREFIX_NAME} "${PREFIX_DEPENDENCIES};${PREFIX_SYSTEM_DEPENDENCIES}" ${PREFIX_GPU})
    endif()
endfunction()

function(_register_test_target _target _all_deps _is_cuda)
    set(_test_env "")
    if (CMAKE_BUILD_TYPE STREQUAL "Asan")
        if (_is_cuda OR LANGUAGES_USE_CUDA)
            set(_test_env "ASAN_OPTIONS=detect_stack_use_after_return=1:protect_shadow_gap=0")
        else()
            set(_test_env "ASAN_OPTIONS=detect_stack_use_after_return=1")
        endif()
    elseif (CMAKE_BUILD_TYPE STREQUAL "AsanUbsan")
        if (_is_cuda OR LANGUAGES_USE_CUDA)
            set(_test_env "ASAN_OPTIONS=detect_stack_use_after_return=1:protect_shadow_gap=0"
                          "UBSAN_OPTIONS=print_stacktrace=1:report_error_type=1")
        else()
            set(_test_env "ASAN_OPTIONS=detect_stack_use_after_return=1"
                          "UBSAN_OPTIONS=print_stacktrace=1:report_error_type=1")
        endif()
    elseif (CMAKE_BUILD_TYPE STREQUAL "Tsan")
        set(_test_env "TSAN_OPTIONS=halt_on_error=1")
    elseif (CMAKE_BUILD_TYPE STREQUAL "Ubsan")
        set(_test_env "UBSAN_OPTIONS=print_stacktrace=1:report_error_type=1")
    elseif (CMAKE_BUILD_TYPE STREQUAL "Coverage")
        if (DETECTED_COMPILER_FLAVOR MATCHES "^(Clang|AOCC)$")
            set(_test_env "LLVM_PROFILE_FILE=${CMAKE_BINARY_DIR}/coverage-%p.profraw")
        endif()
    endif()

    set(_test_props "")
    if (_test_env)
        list(APPEND _test_props ENVIRONMENT "${_test_env}")
    endif()
    if (_is_cuda AND LANGUAGES_CUDA_SERIALIZE_TESTS)
        list(APPEND _test_props RESOURCE_LOCK gpu)
    endif()

    if ("${_all_deps}" MATCHES "(^|;)(gtest|GTest::gtest|GTest::gtest_main)(;|$)")
        include(GoogleTest)
        if (_test_props)
            gtest_discover_tests(${_target} PROPERTIES ${_test_props})
        else()
            gtest_discover_tests(${_target})
        endif()
    else()
        add_test(NAME ${_target}.test COMMAND ${_target})
        if (_test_env)
            set_property(TEST ${_target}.test APPEND PROPERTY ENVIRONMENT ${_test_env})
        endif()
        if (_is_cuda AND LANGUAGES_CUDA_SERIALIZE_TESTS)
            set_property(TEST ${_target}.test APPEND PROPERTY RESOURCE_LOCK gpu)
        endif()
    endif()
endfunction()

function(create_cuda_target)
    cmake_parse_arguments(
        PREFIX
        "DO_NOT_USE_WARNINGS;DO_NOT_USE_PEDANTIC_WARNINGS"
        "NAME;TARGET_TYPE"
        "SOURCES;PUBLIC_INCLUDE_DIRECTORIES;PRIVATE_INCLUDE_DIRECTORIES;DEPENDENCIES;SYSTEM_DEPENDENCIES"
        ${ARGN}
    )

    if (PREFIX_TARGET_TYPE STREQUAL "EXE")
        add_executable(${PREFIX_NAME} ${PREFIX_SOURCES})
    elseif (PREFIX_TARGET_TYPE STREQUAL "LIB")
        add_library(${PREFIX_NAME} SHARED ${PREFIX_SOURCES})
    elseif (PREFIX_TARGET_TYPE STREQUAL "STATIC_LIB")
        add_library(${PREFIX_NAME} STATIC ${PREFIX_SOURCES})
    elseif (PREFIX_TARGET_TYPE STREQUAL "TEST")
        add_executable(${PREFIX_NAME} ${PREFIX_SOURCES})
    endif()

    target_include_directories(${PREFIX_NAME} PUBLIC ${PREFIX_PUBLIC_INCLUDE_DIRECTORIES})
    target_include_directories(${PREFIX_NAME} PRIVATE ${PREFIX_PRIVATE_INCLUDE_DIRECTORIES} "${CMAKE_SOURCE_DIR}")
    target_link_libraries(${PREFIX_NAME} PUBLIC ${PREFIX_DEPENDENCIES})
    target_link_libraries(${PREFIX_NAME} PRIVATE ${PREFIX_SYSTEM_DEPENDENCIES})
    foreach(_cuda_lib IN ITEMS CUDA::cudart CUDA::cublas CUDA::cusolver CUDA::cusparse)
        if (TARGET ${_cuda_lib})
            target_link_libraries(${PREFIX_NAME} PRIVATE ${_cuda_lib})
        endif()
    endforeach()
    target_compile_options(${PREFIX_NAME} PRIVATE $<$<COMPILE_LANGUAGE:CUDA>:${DEFAULT_CUDA_FLAGS}>)

    if (PREFIX_TARGET_TYPE STREQUAL "TEST")
        _register_test_target(${PREFIX_NAME} "${PREFIX_DEPENDENCIES};${PREFIX_SYSTEM_DEPENDENCIES}" TRUE)
    endif()
endfunction()

function(find_gtest)
    if (TARGET GTest::gtest OR TARGET GTest::gtest_main)
        return()
    endif()

    cmake_parse_arguments(PREFIX "" "" "SOURCE_HINTS" ${ARGN})

    # Prebuilt system libgtest is ABI-incompatible with _GLIBCXX_DEBUG, uninstrumented for MSan,
    # and host-native (unusable when cross-compiling for Emscripten); build GoogleTest from source
    # so it shares the exact target ABI / instrumentation.
    if (CMAKE_UTILS_STL_DEBUG_FLAGS OR CMAKE_BUILD_TYPE STREQUAL "Msan" OR EMSCRIPTEN)
        set(_gtest_src "")
        foreach(_hint IN LISTS PREFIX_SOURCE_HINTS)
            if (EXISTS "${_hint}/CMakeLists.txt")
                set(_gtest_src "${_hint}")
                break()
            endif()
        endforeach()
        if (NOT _gtest_src)
            foreach(_default_hint IN ITEMS
                    "${CMAKE_SOURCE_DIR}/gtest"
                    "${CMAKE_SOURCE_DIR}/submodules/gtest"
                    "/usr/src/googletest")
                if (EXISTS "${_default_hint}/CMakeLists.txt")
                    set(_gtest_src "${_default_hint}")
                    break()
                endif()
            endforeach()
        endif()

        if (_gtest_src)
            message(STATUS "Building GoogleTest from source (${_gtest_src}) to match Debug/Sanitizer STL ABI")
            set(BUILD_GMOCK OFF CACHE BOOL "" FORCE)
            set(INSTALL_GTEST OFF CACHE BOOL "" FORCE)
            set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
            add_subdirectory("${_gtest_src}" "${CMAKE_BINARY_DIR}/gtest" EXCLUDE_FROM_ALL)
            return()
        endif()
    endif()

    find_package(GTest REQUIRED)
endfunction()

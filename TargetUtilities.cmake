include_guard(GLOBAL)

if (CMAKE_TESTING_ENABLED AND NOT TARGET build_and_test)
    add_custom_target(build_and_test COMMAND ${CMAKE_CTEST_COMMAND} --output-on-failure)
endif()

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
        "DO_NOT_USE_WARNINGS;DO_NOT_USE_PEDANTIC_WARNINGS"
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
        add_test(NAME ${PREFIX_NAME}.test COMMAND ${PREFIX_NAME})
        if (TARGET build_and_test)
            add_dependencies(build_and_test ${PREFIX_NAME})
        endif()

        if (CMAKE_BUILD_TYPE STREQUAL "Asan")
            if (LANGUAGES_USE_CUDA)
                set_property(TEST ${PREFIX_NAME}.test APPEND PROPERTY
                    ENVIRONMENT "ASAN_OPTIONS=detect_stack_use_after_return=1:protect_shadow_gap=0")
            else()
                set_property(TEST ${PREFIX_NAME}.test APPEND PROPERTY
                    ENVIRONMENT "ASAN_OPTIONS=detect_stack_use_after_return=1")
            endif()
        elseif (CMAKE_BUILD_TYPE STREQUAL "AsanUbsan")
            set_property(TEST ${PREFIX_NAME}.test APPEND PROPERTY
                ENVIRONMENT "ASAN_OPTIONS=detect_stack_use_after_return=1"
                "UBSAN_OPTIONS=print_stacktrace=1:report_error_type=1")
        elseif (CMAKE_BUILD_TYPE STREQUAL "Tsan")
            set_property(TEST ${PREFIX_NAME}.test APPEND PROPERTY
                ENVIRONMENT "TSAN_OPTIONS=halt_on_error=1")
        elseif (CMAKE_BUILD_TYPE STREQUAL "Ubsan")
            set_property(TEST ${PREFIX_NAME}.test APPEND PROPERTY
                ENVIRONMENT "UBSAN_OPTIONS=print_stacktrace=1:report_error_type=1")
        elseif (CMAKE_BUILD_TYPE STREQUAL "Coverage")
            if (DETECTED_COMPILER_FLAVOR MATCHES "^(Clang|AOCC)$")
                set_property(TEST ${PREFIX_NAME}.test APPEND PROPERTY
                    ENVIRONMENT "LLVM_PROFILE_FILE=${CMAKE_BINARY_DIR}/coverage-%p.profraw")
            endif()
        endif()
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
        add_test(NAME ${PREFIX_NAME}.test COMMAND ${PREFIX_NAME})
        if (TARGET build_and_test)
            add_dependencies(build_and_test ${PREFIX_NAME})
        endif()
        if (CMAKE_BUILD_TYPE STREQUAL "Asan")
            set_property(TEST ${PREFIX_NAME}.test APPEND PROPERTY
                ENVIRONMENT "ASAN_OPTIONS=detect_stack_use_after_return=1:protect_shadow_gap=0")
        elseif (CMAKE_BUILD_TYPE STREQUAL "AsanUbsan")
            set_property(TEST ${PREFIX_NAME}.test APPEND PROPERTY
                ENVIRONMENT "ASAN_OPTIONS=detect_stack_use_after_return=1:protect_shadow_gap=0"
                "UBSAN_OPTIONS=print_stacktrace=1:report_error_type=1")
        endif()
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
endfunction()

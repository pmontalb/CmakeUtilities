include_guard()

if (CMAKE_TESTING_ENABLED)
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
            "NAME;TARGET_TYPE"
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
        add_dependencies(build_and_test ${PREFIX_NAME})

        if ("${CMAKE_BUILD_TYPE}" STREQUAL "Asan")
            set_property(TEST ${PREFIX_NAME}.test PROPERTY
                    ENVIRONMENT "ASAN_OPTIONS=detect_stack_use_after_return=1")

            if (LANGUAGES_USE_CUDA)
                # https://github.com/google/sanitizers/issues/629
                set_property(TEST ${PREFIX_NAME}.test PROPERTY
                    ENVIRONMENT "ASAN_OPTIONS=protect_shadow_gap=0")
            endif()
        endif()

        if ("${CMAKE_BUILD_TYPE}" STREQUAL "Tsan")
            set_property(TEST ${PREFIX_NAME}.test PROPERTY
                    ENVIRONMENT "TSAN_OPTIONS=halt_on_error=1")
        endif()
    endif()

    if (NOT ${PREFIX_DO_NOT_USE_PEDANTIC_WARNINGS})
        target_compile_options(${PREFIX_NAME} PRIVATE ${PEDANTIC_WARNING_FLAGS})
    elseif (NOT PREFIX_DO_NOT_USE_WARNINGS)
        target_compile_options(${PREFIX_NAME} PRIVATE ${WARNING_FLAGS})
    endif()

    target_include_directories(${PREFIX_NAME} PUBLIC ${PREFIX_PUBLIC_INCLUDE_DIRECTORIES})
    target_include_directories(${PREFIX_NAME} PRIVATE ${PREFIX_PRIVATE_INCLUDE_DIRECTORIES})
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
        add_library(${PREFIX_NAME} SHARED ${PREFIX_SOURCES})  # shared by default!
    elseif (PREFIX_TARGET_TYPE STREQUAL "STATIC_LIB")
        add_library(${PREFIX_NAME} STATIC ${PREFIX_SOURCES})
    elseif (PREFIX_TARGET_TYPE STREQUAL "TEST")
        add_executable(${PREFIX_NAME} ${PREFIX_SOURCES})
        add_test(NAME ${PREFIX_NAME})
    endif()

    target_include_directories(${PREFIX_NAME} PUBLIC ${PREFIX_PUBLIC_INCLUDE_DIRECTORIES})
    target_include_directories(${PREFIX_NAME} PRIVATE ${PREFIX_PRIVATE_INCLUDE_DIRECTORIES})
    target_link_libraries(${PREFIX_NAME} PUBLIC ${PREFIX_DEPENDENCIES})
    target_link_libraries(${PREFIX_NAME} PRIVATE ${PREFIX_SYSTEM_DEPENDENCIES})
    target_link_libraries(${PREFIX_NAME} PRIVATE cudart)
    target_link_libraries(${PREFIX_NAME} PRIVATE cublas)
    target_link_libraries(${PREFIX_NAME} PRIVATE cusolver)
    target_link_libraries(${PREFIX_NAME} PRIVATE cusparse)
    target_compile_options(${PREFIX_NAME} PRIVATE $<$<COMPILE_LANGUAGE:CUDA>: ${DEFAULT_CUDA_FLAGS}>)
endfunction()

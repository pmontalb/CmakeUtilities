cmake_minimum_required(VERSION 3.28)
project(cmake_examples LANGUAGES C CXX)

enable_testing()

if (PROJECT_IS_TOP_LEVEL OR BUILD_EXAMPLES)
    add_subdirectory(Example)
endif()

include_guard(GLOBAL)

cmake_minimum_required(VERSION 3.14)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/Modules/")

include(cmake/Options.cmake)

if (LANGUAGES_USE_CUDA)
	include(cmake/CudaFlags.cmake)
endif()

include(cmake/Flags.cmake)
include(cmake/Warnings.cmake)
include(cmake/Common.cmake)
include(cmake/TargetUtilities.cmake)

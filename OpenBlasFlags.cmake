include_guard()

find_package(OpenBLAS)
if(OpenBLAS_FOUND)
	message(STATUS "OpenBLAS Library found: ${OpenBLAS_LIB}")
endif()
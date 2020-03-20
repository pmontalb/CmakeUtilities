include_guard()

find_package(Mkl)
if(MKL_FOUND)
	message(STATUS "MKL Library[ver=${MKL_VERSION}] found: ${MKL_LIBRARIES}")
endif()
include_guard()

find_package(BLAS)
if(BLAS_FOUND)
	message(STATUS "BLAS found: ${BLAS_LIBRARIES}")
endif()
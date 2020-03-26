include_guard()

SET(WITH_BLAS "generic" CACHE STRING "Blas type [mkl/open/goto/acml/atlas/accelerate/veclib/generic]")
find_package(BLAS)
if(BLAS_FOUND)
	message(STATUS "BLAS found: [${BLAS_INFO}][${BLAS_INCLUDE_DIR}][${BLAS_LIBRARIES}")
endif()
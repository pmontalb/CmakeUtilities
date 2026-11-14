create_cuda_static_library(
	NAME libcuda
	SOURCES CudaKernel.cu
	PUBLIC_INCLUDE_DIRECTORIES .
)

if (NOT EMSCRIPTEN AND NOT CMAKE_BUILD_TYPE STREQUAL "Msan")
	create_test(
		NAME testCuda
		SOURCES CudaTests.cpp
		DEPENDENCIES libcuda testMain
	)
endif()

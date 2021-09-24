include_guard()

# /* https://stackoverflow.com/questions/2285185/easiest-way-to-test-for-existence-of-cuda-capable-gpu-from-cmake */
find_package(CUDA)
if (CUDA_FOUND)
	try_run(RUN_RESULT_VAR COMPILE_RESULT_VAR
			${CMAKE_BINARY_DIR}
			${CMAKE_CURRENT_SOURCE_DIR}/cmake/Utilities/HasCudaGpu.c
			CMAKE_FLAGS
			-DINCLUDE_DIRECTORIES:STRING=${CUDA_TOOLKIT_INCLUDE}
			-DLINK_LIBRARIES:STRING=${CUDA_CUDART_LIBRARY}
			COMPILE_OUTPUT_VARIABLE COMPILE_OUTPUT_VAR
			RUN_OUTPUT_VARIABLE RUN_OUTPUT_VAR)
	message(STATUS "${RUN_OUTPUT_VAR}") # Display number of GPUs found
	# COMPILE_RESULT_VAR is TRUE when compile succeeds
	# RUN_RESULT_VAR is zero when a GPU is found
	if (COMPILE_RESULT_VAR AND NOT RUN_RESULT_VAR)
		set(CONFIG_FOUND_CUDA_GPU TRUE CACHE BOOL "Whether CUDA-capable GPU is present")
	else ()
		set(CONFIG_FOUND_CUDA_GPU FALSE CACHE BOOL "Whether CUDA-capable GPU is present")
	endif ()
	mark_as_advanced(CONFIG_FOUND_CUDA_GPU)
endif (CUDA_FOUND)

if (CONFIG_FOUND_CUDA_GPU AND LANGUAGES_USE_CUDA)
	set(PATHS_CUDA_PATH "/usr/local")
	mark_as_advanced(PATHS_CUDA_PATH)

	if (NOT LANGUAGES_CUDA_VERSION)
		message(STATUS "Using CUDA 11.4 as nothing specified")
		set(LANGUAGES_CUDA_VERSION 11.4)
	else ()
		message(STATUS "Using CUDA ${LANGUAGES_CUDA_VERSION}")
	endif ()

	set(CMAKE_CUDA_STANDARD ${FLAGS_CPP_STANDARD})
	set(CMAKE_CUDA_STANDARD_REQUIRED ON)
	set(CMAKE_CUDA_COMPILER /usr/local/cuda-${LANGUAGES_CUDA_VERSION}/bin/nvcc CACHE PATH "" FORCE)

	if (NOT LANGUAGES_CUDA_ARCHITECTURE)
		message(STATUS "Using gen 61 as nothing specified")
		set(LANGUAGES_CUDA_ARCHITECTURE 61)
	else ()
		message(STATUS "Using gen ${LANGUAGES_CUDA_ARCHITECTURE}")
	endif ()
	set(CMAKE_CUDA_ARCHITECTURES ${LANGUAGES_CUDA_ARCHITECTURE})

	set(DEFAULT_CUDA_FLAGS -restrict -Xcompiler -Wno-unknown-pragmas --default-stream per-thread)
	if (LANGUAGES_USE_64_BITS)
		set(DEFAULT_CUDA_FLAGS ${DEFAULT_CUDA_FLAGS} -m64)
	endif ()
	if (WARNINGS_USE_WALL_AND_WEXTRA)
		set(DEFAULT_CUDA_FLAGS ${DEFAULT_CUDA_FLAGS} --compiler-options -Wall)
	endif ()

	if (CMAKE_BUILD_TYPE STREQUAL "Release")
		# optimization flags
		set(DEFAULT_CUDA_FLAGS ${DEFAULT_CUDA_FLAGS} -Xptxas -O3)

		if (OPTIMIZATIONS_USE_FAST_MATH)
			# fast math (use intrinsics!)
			set(DEFAULT_CUDA_FLAGS ${DEFAULT_CUDA_FLAGS} --use_fast_math)
		endif ()
	endif ()

	mark_as_advanced(DEFAULT_CUDA_FLAGS)
endif ()

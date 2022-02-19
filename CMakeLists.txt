
if (BUILD_EXAMPLES)
	cmake_minimum_required(VERSION 3.14)
	project(cmake_examples)

	file(CREATE_LINK . cmake SYMBOLIC)
	add_subdirectory(Example)
endif()

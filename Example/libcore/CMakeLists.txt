create_library(
	NAME libcore
	SOURCES CoreFeatures.cpp
	PUBLIC_INCLUDE_DIRECTORIES .
)

if (NOT EMSCRIPTEN AND NOT CMAKE_BUILD_TYPE STREQUAL "Msan")
	create_test(
		NAME testCore
		SOURCES CoreTests.cpp
		DEPENDENCIES libcore testMain
	)
endif()

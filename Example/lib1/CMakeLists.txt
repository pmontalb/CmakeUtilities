
create_library(
		NAME lib1
		SOURCES lib1.cpp
		PUBLIC_INCLUDE_DIRECTORIES .
)

if (CMAKE_BUILD_TYPE MATCHES "Debug" AND DEBUG_USE_STL_DEBUG)
	create_test(
			NAME testLib1
			SOURCES StlDebugTests.cpp
			DEPENDENCIES lib1 testMain
	)
endif()

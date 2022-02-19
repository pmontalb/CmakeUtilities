
create_library(
		NAME lib5
		SOURCES lib5.cpp
		PUBLIC_INCLUDE_DIRECTORIES Example
)

if (CMAKE_BUILD_TYPE MATCHES "Release")
	create_test(
			NAME testLib5
			SOURCES PerformanceTests.cpp
			DEPENDENCIES lib5 testMain
	)
endif()

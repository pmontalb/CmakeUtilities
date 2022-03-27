
create_library(
		NAME lib6
		SOURCES lib6.cpp
		PUBLIC_INCLUDE_DIRECTORIES .
)

if (CMAKE_BUILD_TYPE MATCHES "Coverage")
	create_test(
			NAME testLib6
			SOURCES CoverageTests.cpp
			DEPENDENCIES lib6 testMain
	)
endif()


create_library(
		NAME lib2
		SOURCES lib2.cpp
		PUBLIC_INCLUDE_DIRECTORIES Example
)

if (CMAKE_BUILD_TYPE MATCHES "Asan")
	create_test(
			NAME testLib2
			SOURCES AsanTests.cpp
			DEPENDENCIES lib2 testMain
	)
endif()

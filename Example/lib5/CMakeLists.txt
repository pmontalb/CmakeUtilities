
create_library(
		NAME lib5
		SOURCES lib5.cpp
		PUBLIC_INCLUDE_DIRECTORIES .
)

if (NOT EMSCRIPTEN AND CMAKE_BUILD_TYPE MATCHES "^(Release|RelWithDebInfo|MinSizeRel|Profile)$")
	create_test(
			NAME testLib5
			SOURCES PerformanceTests.cpp
			DEPENDENCIES lib5 testMain
	)
endif()

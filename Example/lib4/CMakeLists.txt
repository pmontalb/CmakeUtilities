
create_library(
		NAME lib4
		SOURCES lib4.cpp
		PUBLIC_INCLUDE_DIRECTORIES Example
)

if (CMAKE_BUILD_TYPE MATCHES "Tsan")
	create_test(
			NAME testLib4
			SOURCES TsanTests.cpp
			DEPENDENCIES lib4 testMain
	)
endif()

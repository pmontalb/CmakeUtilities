
create_library(
		NAME lib3
		SOURCES lib3.cpp
		PUBLIC_INCLUDE_DIRECTORIES .
)

if (CMAKE_BUILD_TYPE MATCHES "Ubsan")
	create_test(
			NAME testLib3
			SOURCES UbsanTests.cpp
			DEPENDENCIES lib3 testMain
	)
endif()

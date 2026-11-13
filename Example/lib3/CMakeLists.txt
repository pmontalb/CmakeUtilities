
create_library(
		NAME lib3
		SOURCES lib3.cpp
		PUBLIC_INCLUDE_DIRECTORIES .
)

if (NOT EMSCRIPTEN AND CMAKE_BUILD_TYPE MATCHES "^(Ubsan|AsanUbsan)$")
	create_test(
			NAME testLib3
			SOURCES UbsanTests.cpp
			DEPENDENCIES lib3 testMain
	)
endif()

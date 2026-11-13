create_library(
		NAME lib2
		SOURCES lib2.cpp
		PUBLIC_INCLUDE_DIRECTORIES .
		DO_NOT_USE_WARNINGS
		DO_NOT_USE_PEDANTIC_WARNINGS
)

if (NOT EMSCRIPTEN AND CMAKE_BUILD_TYPE MATCHES "^(Asan|AsanUbsan)$")
	create_test(
			NAME testLib2
			SOURCES AsanTests.cpp
			DEPENDENCIES lib2 testMain
	)
elseif (NOT EMSCRIPTEN AND CMAKE_BUILD_TYPE STREQUAL "Lsan")
	create_test(
			NAME testLsan
			SOURCES LsanTests.cpp
			DEPENDENCIES lib2 testMain
	)
endif()

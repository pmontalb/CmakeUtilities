if (NOT EMSCRIPTEN AND CMAKE_BUILD_TYPE STREQUAL "Msan")
	create_executable(
		NAME testMsan
		SOURCES MsanTests.cpp
	)
	add_test(NAME testMsan.clean.test COMMAND testMsan clean)
	add_test(NAME testMsan.detect.test COMMAND testMsan fail)
	set_tests_properties(testMsan.detect.test PROPERTIES
		PASS_REGULAR_EXPRESSION "MemorySanitizer: use-of-uninitialized-value"
	)
endif()

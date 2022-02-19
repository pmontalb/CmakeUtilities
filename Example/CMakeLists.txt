
file(CREATE_LINK ../ Example/cmake SYMBOLIC)
include(cmake/All.cmake)

add_subdirectory(lib1)
add_subdirectory(lib2)
add_subdirectory(lib3)
add_subdirectory(lib4)
add_subdirectory(lib5)
add_subdirectory(lib6)

create_library(
		NAME testMain
		SOURCES Main.cpp
		SYSTEM_DEPENDENCIES gtest pthread
)

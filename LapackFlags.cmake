include_guard()

find_package(LAPACK)
if(LAPACK_FOUND)
	message(STATUS "LAPACK found: ${LAPACK_INFO}[${LAPACK_INCLUDE_DIR}][${LAPACK_LIBRARIES}]")
endif()
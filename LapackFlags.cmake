include_guard()

find_package(LAPACK)
if(LAPACK_FOUND)
	set(LAPACK_LIBRARIES ${LAPACK_LIBRARIES} -llapacke)
	message(STATUS "LAPACK found: [${LAPACK_INFO}][${LAPACK_INCLUDE_DIR}][${LAPACK_LIBRARIES}]")
endif()
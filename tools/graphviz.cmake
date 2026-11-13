include_guard(GLOBAL)

# ==============================================================================
# CMake Dependency Graph (Graphviz) Target
# ==============================================================================
if (NOT TOOLS_ENABLE_DEPENDENCY_GRAPH)
    return()
endif()

set(_graph_dir "${CMAKE_BINARY_DIR}/graph")
set(_dot_file "${_graph_dir}/dependencies.dot")
file(MAKE_DIRECTORY "${_graph_dir}")

# Write clean CMakeGraphVizOptions.cmake into binary dir if not already overridden
if (NOT EXISTS "${CMAKE_BINARY_DIR}/CMakeGraphVizOptions.cmake")
    file(WRITE "${CMAKE_BINARY_DIR}/CMakeGraphVizOptions.cmake"
        "set(GRAPHVIZ_EXECUTABLES TRUE)\n"
        "set(GRAPHVIZ_STATIC_LIBS TRUE)\n"
        "set(GRAPHVIZ_SHARED_LIBS TRUE)\n"
        "set(GRAPHVIZ_MODULE_LIBS TRUE)\n"
        "set(GRAPHVIZ_INTERFACE_LIBS TRUE)\n"
        "set(GRAPHVIZ_OBJECT_LIBS TRUE)\n"
        "set(GRAPHVIZ_EXTERNAL_LIBS FALSE)\n"
        "set(GRAPHVIZ_GENERATE_PER_TARGET TRUE)\n"
        "set(GRAPHVIZ_GENERATE_DEPENDERS TRUE)\n"
    )
endif()

find_program(DOT_PROGRAM dot)
mark_as_advanced(DOT_PROGRAM)

if (DOT_PROGRAM)
    add_custom_target(dependency_graph
        COMMAND "${CMAKE_COMMAND}" "--graphviz=${_dot_file}" "${CMAKE_BINARY_DIR}"
        COMMAND "${DOT_PROGRAM}" -Tsvg "${_dot_file}" -o "${_graph_dir}/dependencies.svg"
        COMMAND "${DOT_PROGRAM}" -Tpng "${_dot_file}" -o "${_graph_dir}/dependencies.png"
        COMMENT "Generating CMake target dependency graph (.dot, .svg, .png) in ${_graph_dir}"
        VERBATIM
    )
else()
    add_custom_target(dependency_graph
        COMMAND "${CMAKE_COMMAND}" "--graphviz=${_dot_file}" "${CMAKE_BINARY_DIR}"
        COMMENT "Generating CMake target dependency graph (.dot) in ${_graph_dir} (install graphviz 'dot' for SVG/PNG)"
        VERBATIM
    )
endif()

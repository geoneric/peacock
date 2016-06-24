set(pybind11_git_repository
    https://github.com/pybind/pybind11)

set(pybind11_prefix ${peacock_package_prefix})


set(pybind11_cmake_args ${pybind11_cmake_args}
    -DCMAKE_INSTALL_PREFIX:PATH=${pybind11_prefix})

if(CMAKE_MAKE_PROGRAM)
    set(pybind11_cmake_args ${pybind11_cmake_args}
        -DCMAKE_MAKE_PROGRAM=${CMAKE_MAKE_PROGRAM})
endif()

set(pybind11_cmake_args ${pybind11_cmake_args}
    -DPYBIND11_TEST:BOOL=FALSE)


add_custom_target(pybind11-${pybind11_version})


function(add_external_project)
    set(options "")
    set(one_value_arguments BUILD_TYPE)
    set(multi_value_arguments "")

    cmake_parse_arguments(add_external_project "${options}"
        "${one_value_arguments}" "${multi_value_arguments}" ${ARGN})

    if(add_external_project_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR
            "Macro called with unrecognized arguments: "
            "${add_external_project_UNPARSED_ARGUMENTS}")
    endif()

    set(build_type ${add_external_project_BUILD_TYPE})
    set(pybind11_target pybind11-${pybind11_version}-${build_type})

    ExternalProject_Add(${pybind11_target}
        DEPENDS ${pybind11_dependencies}
        LIST_SEPARATOR !
        DOWNLOAD_DIR ${peacock_download_dir}
        GIT_REPOSITORY ${pybind11_git_repository}
        GIT_TAG ${pybind11_git_tag}
        BUILD_IN_SOURCE FALSE
        CMAKE_ARGS ${pybind11_cmake_args} -DCMAKE_BUILD_TYPE=${build_type}
        PATCH_COMMAND ${pybind11_patch_command}
    )

    add_dependencies(pybind11-${pybind11_version} ${pybind11_target})
endfunction()


add_external_project(BUILD_TYPE Release)


if(WIN32 AND NOT CMAKE_CONFIGURATION_TYPES)
    add_external_project(BUILD_TYPE Debug)
    add_dependencies(pybind11-${pybind11_version}-Debug
        pybind11-${pybind11_version}-Release)
endif()

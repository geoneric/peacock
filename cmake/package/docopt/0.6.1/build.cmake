set(docopt_git_repository
    https://github.com/docopt/docopt.cpp.git)


set(docopt_prefix ${peacock_package_prefix})


set(docopt_cmake_args ${docopt_cmake_args}
    -DCMAKE_INSTALL_PREFIX:PATH=${docopt_prefix})

if(CMAKE_MAKE_PROGRAM)
    set(docopt_cmake_args ${docopt_cmake_args}
        -DCMAKE_MAKE_PROGRAM=${CMAKE_MAKE_PROGRAM})
endif()

set(docopt_cmake_args ${docopt_cmake_args}
    -DCMAKE_FIND_ROOT_PATH=${docopt_cmake_find_root_path})


add_custom_target(docopt-${docopt_version})


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
    set(docopt_target docopt-${docopt_version}-${build_type})

    ExternalProject_Add(${docopt_target}
        DEPENDS ${docopt_dependencies}
        LIST_SEPARATOR !
        DOWNLOAD_DIR ${peacock_download_dir}
        GIT_REPOSITORY ${docopt_git_repository}
        BUILD_IN_SOURCE FALSE
        CMAKE_ARGS ${docopt_cmake_args} -DCMAKE_BUILD_TYPE=${build_type}
        PATCH_COMMAND ${docopt_patch_command}
    )

    add_dependencies(docopt-${docopt_version} ${docopt_target})
endfunction()


add_external_project(BUILD_TYPE Release)


if(WIN32 AND NOT CMAKE_CONFIGURATION_TYPES)
    add_external_project(BUILD_TYPE Debug)
    add_dependencies(docopt-${docopt_version}-Debug
        docopt-${docopt_version}-Release)
endif()

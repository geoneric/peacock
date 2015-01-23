set(fern_prefix ${peacock_package_prefix})


set(fern_cmake_args ${fern_cmake_args}
    -DCMAKE_INSTALL_PREFIX:PATH=${fern_prefix})

if(CMAKE_MAKE_PROGRAM)
    set(fern_cmake_args ${fern_cmake_args}
        -DCMAKE_MAKE_PROGRAM=${CMAKE_MAKE_PROGRAM})
endif()

if(fern_build_fern_algorithm)
    set(fern_cmake_args ${fern_cmake_args}
        -DFERN_ALGORITHM:BOOL=TRUE)
endif()

if(build_boost)
    set(fern_cmake_args ${fern_cmake_args}
        -DBOOST_ROOT:PATH=${boost_prefix})
    set(fern_dependencies boost-${boost_version})
endif()


set(fern_patch_command
    COMMAND sed -i.tmp
        "s|ADD_SUBDIRECTORY(document)|# ADD_SUBDIRECTORY(document)|"
            CMakeLists.txt
)


add_custom_target(fern-${fern_version})


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
    set(fern_target fern-${fern_version}-${build_type})

    ExternalProject_Add(${fern_target}
        DEPENDS ${fern_dependencies}
        LIST_SEPARATOR !
        DOWNLOAD_DIR ${peacock_download_dir}
        GIT_REPOSITORY ${fern_git_repository}
        GIT_TAG ${fern_git_tag}
        BUILD_IN_SOURCE 1
        CMAKE_ARGS ${fern_cmake_args} -DCMAKE_BUILD_TYPE=${build_type}
        PATCH_COMMAND ${fern_patch_command}
        # TODO This requires updated path settings.
        # TEST_BEFORE_INSTALL 1
    )

    add_dependencies(fern-${fern_version} ${fern_target})
endfunction()


add_external_project(BUILD_TYPE Release)


if(WIN32 AND NOT CMAKE_CONFIGURATION_TYPES)
    add_external_project(BUILD_TYPE Debug)
    add_dependencies(fern-${fern_version}-Debug fern-${fern_version}-Release)
endif()

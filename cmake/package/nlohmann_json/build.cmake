set(nlohmann_json_git_tag "v${nlohmann_json_version}")

set(nlohmann_json_git_repository
    https://github.com/nlohmann/json)

set(nlohmann_json_prefix ${peacock_package_prefix})


set(nlohmann_json_cmake_args ${nlohmann_json_cmake_args}
    -DCMAKE_INSTALL_PREFIX:PATH=${nlohmann_json_prefix})

if(CMAKE_MAKE_PROGRAM)
    set(nlohmann_json_cmake_args ${nlohmann_json_cmake_args}
        -DCMAKE_MAKE_PROGRAM=${CMAKE_MAKE_PROGRAM})
endif()


set(nlohmann_json_cmake_args ${nlohmann_json_cmake_args}
    -DBuildTests:BOOL=FALSE)


add_custom_target(nlohmann_json-${nlohmann_json_version})


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
    set(nlohmann_json_target
        nlohmann_json-${nlohmann_json_version}-${build_type})

    ExternalProject_Add(${nlohmann_json_target}
        DEPENDS ${nlohmann_json_dependencies}
        LIST_SEPARATOR !
        DOWNLOAD_DIR ${peacock_download_dir}
        GIT_REPOSITORY ${nlohmann_json_git_repository}
        GIT_TAG ${nlohmann_json_git_tag}
        BUILD_IN_SOURCE FALSE
        CMAKE_ARGS ${nlohmann_json_cmake_args} -DCMAKE_BUILD_TYPE=${build_type}
        PATCH_COMMAND ${nlohmann_json_patch_command}
    )

    add_dependencies(nlohmann_json-${nlohmann_json_version}
        ${nlohmann_json_target})
endfunction()


add_external_project(BUILD_TYPE Release)


if(WIN32 AND NOT CMAKE_CONFIGURATION_TYPES)
    add_external_project(BUILD_TYPE Debug)
    add_dependencies(nlohmann_json-${nlohmann_json_version}-Debug
        nlohmann_json-${nlohmann_json_version}-Release)
endif()

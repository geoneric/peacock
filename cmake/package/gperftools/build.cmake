set(gperftools_git_tag "gperftools-${gperftools_version}")

set(gperftools_git_repository
    https://github.com/gperftools/gperftools)

set(gperftools_prefix ${peacock_package_prefix})

set(gperftools_configure_command
        cd <SOURCE_DIR> && ./autogen.sh
    COMMAND
        <SOURCE_DIR>/configure --prefix ${gperftools_prefix}
)

add_custom_target(gperftools-${gperftools_version})

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
    set(gperftools_target
        gperftools-${gperftools_version}-${build_type})

    ExternalProject_Add(${gperftools_target}
        DEPENDS ${gperftools_dependencies}
        LIST_SEPARATOR !
        DOWNLOAD_DIR ${peacock_download_dir}
        GIT_REPOSITORY ${gperftools_git_repository}
        GIT_TAG ${gperftools_git_tag}
        CONFIGURE_COMMAND ${gperftools_configure_command}
    )

    add_dependencies(gperftools-${gperftools_version}
        ${gperftools_target})
endfunction()


add_external_project(BUILD_TYPE Release)


if(WIN32 AND NOT CMAKE_CONFIGURATION_TYPES)
    add_external_project(BUILD_TYPE Debug)
    add_dependencies(gperftools-${gperftools_version}-Debug
        gperftools-${gperftools_version}-Release)
endif()

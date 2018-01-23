set(google_benchmark_git_tag "v${google_benchmark_version}")

set(google_benchmark_git_repository
    https://github.com/google/benchmark)

set(google_benchmark_prefix ${peacock_package_prefix})


set(google_benchmark_cmake_args ${google_benchmark_cmake_args}
    -DCMAKE_INSTALL_PREFIX:PATH=${google_benchmark_prefix})

if(CMAKE_MAKE_PROGRAM)
    set(google_benchmark_cmake_args ${google_benchmark_cmake_args}
        -DCMAKE_MAKE_PROGRAM=${CMAKE_MAKE_PROGRAM})
endif()


set(google_benchmark_cmake_args ${google_benchmark_cmake_args}
    -DBENCHMARK_ENABLE_TESTING:BOOL=FALSE)


add_custom_target(google_benchmark-${google_benchmark_version})


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
    set(google_benchmark_target
        google_benchmark-${google_benchmark_version}-${build_type})

    ExternalProject_Add(${google_benchmark_target}
        DEPENDS ${google_benchmark_dependencies}
        LIST_SEPARATOR !
        DOWNLOAD_DIR ${peacock_download_dir}
        GIT_REPOSITORY ${google_benchmark_git_repository}
        GIT_TAG ${google_benchmark_git_tag}
        BUILD_IN_SOURCE FALSE
        CMAKE_ARGS ${google_benchmark_cmake_args} -DCMAKE_BUILD_TYPE=${build_type}
        PATCH_COMMAND ${google_benchmark_patch_command}
    )

    add_dependencies(google_benchmark-${google_benchmark_version}
        ${google_benchmark_target})
endfunction()


add_external_project(BUILD_TYPE Release)


if(WIN32 AND NOT CMAKE_CONFIGURATION_TYPES)
    add_external_project(BUILD_TYPE Debug)
    add_dependencies(google_benchmark-${google_benchmark_version}-Debug
        google_benchmark-${google_benchmark_version}-Release)
endif()

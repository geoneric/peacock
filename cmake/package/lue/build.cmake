if((${lue_version} STREQUAL "head") AND (NOT DEFINED lue_git_tag))
    # Unless a specific tag is selected, we assume the user wants the tip of
    # the master branch
    set(lue_git_tag "master")
endif()

set(lue_git_repository
    https://github.com/pcraster/lue)

set(lue_prefix ${peacock_package_prefix})


set(lue_cmake_args ${lue_cmake_args}
    -DCMAKE_INSTALL_PREFIX:PATH=${lue_prefix})

if(CMAKE_MAKE_PROGRAM)
    set(lue_cmake_args ${lue_cmake_args}
        -DCMAKE_MAKE_PROGRAM=${CMAKE_MAKE_PROGRAM})
endif()


# Defaults are OK for now
# set(lue_cmake_args ${lue_cmake_args}
#     -DLUE_BUILD_HL_API:BOOL=TRUE
#     -DLUE_BUILD_UTILITIES:BOOL=TRUE
# )


if(build_boost)
    set(lue_dependencies ${lue_dependencies} boost-${boost_version})
    set(lue_cmake_find_root_path ${lue_cmake_find_root_path}
        ${boost_prefix})
endif()

if(build_docopt)
    set(lue_dependencies ${lue_dependencies} docopt-${docopt_version})
    set(lue_cmake_find_root_path ${lue_cmake_find_root_path}
        ${docopt_prefix})
endif()

if(build_gdal)
    set(lue_dependencies ${lue_dependencies} gdal-${gdal_version})
    set(lue_cmake_find_root_path ${lue_cmake_find_root_path}
        ${gdal_prefix})
endif()

if(build_hdf5)
    set(lue_dependencies ${lue_dependencies} hdf5-${hdf5_version})
    set(lue_cmake_find_root_path ${lue_cmake_find_root_path}
        ${hdf5_prefix})
endif()

if(build_nlohmann_json)
    set(lue_dependencies ${lue_dependencies}
        nlohmann_json-${nlohmann_json_version})
    set(lue_cmake_find_root_path ${lue_cmake_find_root_path}
        ${nlohmann_json_prefix})
endif()

if(build_pybind11)
    set(lue_dependencies ${lue_dependencies} pybind11-${pybind11_version})
    set(lue_cmake_find_root_path ${lue_cmake_find_root_path}
        ${pybind11_prefix})
endif()

set(lue_cmake_args ${lue_cmake_args}
    -DCMAKE_FIND_ROOT_PATH=${lue_cmake_find_root_path})

add_custom_target(lue-${lue_version})

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
    set(lue_target
        lue-${lue_version}-${build_type})

    ExternalProject_Add(${lue_target}
        DEPENDS ${lue_dependencies}
        LIST_SEPARATOR !
        DOWNLOAD_DIR ${peacock_download_dir}
        GIT_REPOSITORY ${lue_git_repository}
        GIT_TAG ${lue_git_tag}
        BUILD_IN_SOURCE FALSE
        CMAKE_ARGS ${lue_cmake_args} -DCMAKE_BUILD_TYPE=${build_type}
    )

    add_dependencies(lue-${lue_version}
        ${lue_target})
endfunction()


add_external_project(BUILD_TYPE Release)


if(WIN32 AND NOT CMAKE_CONFIGURATION_TYPES)
    add_external_project(BUILD_TYPE Debug)
    add_dependencies(lue-${lue_version}-Debug
        lue-${lue_version}-Release)
endif()

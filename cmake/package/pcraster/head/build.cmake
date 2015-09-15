set(pcraster_prefix ${peacock_package_prefix})


set(pcraster_cmake_args ${pcraster_cmake_args}
    -DCMAKE_INSTALL_PREFIX:PATH=${pcraster_prefix})

if(CMAKE_MAKE_PROGRAM)
    set(pcraster_cmake_args ${pcraster_cmake_args}
        -DCMAKE_MAKE_PROGRAM=${CMAKE_MAKE_PROGRAM})
endif()

if(pcraster_build_pcraster_documentation)
    set(pcraster_cmake_args ${pcraster_cmake_args}
        -DPCRASTER_BUILD_DOCUMENTATION:BOOL=TRUE)
endif()

if(pcraster_build_pcraster_test)
    set(pcraster_cmake_args ${pcraster_cmake_args}
        -DPCRASTER_BUILD_TEST:BOOL=TRUE)
endif()

if(build_boost)
    set(pcraster_dependencies ${pcraster_dependencies} boost-${boost_version})
    set(pcraster_cmake_find_root_path ${pcraster_cmake_find_root_path}
        ${boost_prefix})
endif()

if(build_gdal)
    set(pcraster_dependencies ${pcraster_dependencies} gdal-${gdal_version})
    set(pcraster_cmake_find_root_path ${pcraster_cmake_find_root_path}
        ${gdal_prefix})
endif()

if(build_pcraster_raster_format)
    set(pcraster_dependencies ${pcraster_dependencies}
        pcraster_raster_format-${pcraster_raster_format_version})
    set(pcraster_cmake_find_root_path ${pcraster_cmake_find_root_path}
        ${pcraster_raster_format_prefix})
endif()


if(build_qt)
    set(pcraster_dependencies qt-${qt_version})
    set(pcraster_cmake_find_root_path ${pcraster_cmake_find_root_path}
        ${qt_prefix})
endif()


if(build_qwt)
    set(pcraster_dependencies ${pcraster_dependencies} qwt-${qwt_version})
    set(pcraster_cmake_find_root_path ${pcraster_cmake_find_root_path}
        ${qwt_prefix})
endif()

set(pcraster_cmake_args ${pcraster_cmake_args}
    -DCMAKE_FIND_ROOT_PATH=${pcraster_cmake_find_root_path})

add_custom_target(pcraster-${pcraster_version})

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
    set(pcraster_target pcraster-${pcraster_version}-${build_type})

    ExternalProject_Add(${pcraster_target}
        DEPENDS ${pcraster_dependencies}
        LIST_SEPARATOR !
        DOWNLOAD_DIR ${peacock_download_dir}
        GIT_REPOSITORY ${pcraster_git_repository}
        GIT_TAG ${pcraster_git_tag}
        BUILD_IN_SOURCE FALSE
        CMAKE_ARGS ${pcraster_cmake_args} -DCMAKE_BUILD_TYPE=${build_type}
        PATCH_COMMAND ${pcraster_patch_command}
        # TODO This requires updated path settings.
        # TEST_BEFORE_INSTALL 1
    )

    add_dependencies(pcraster-${pcraster_version} ${pcraster_target})
endfunction()


add_external_project(BUILD_TYPE Release)


if(WIN32 AND NOT CMAKE_CONFIGURATION_TYPES)
    add_external_project(BUILD_TYPE Debug)
    add_dependencies(pcraster-${pcraster_version}-Debug
        pcraster-${pcraster_version}-Release)
endif()

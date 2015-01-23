set(pcraster_raster_format_prefix ${peacock_package_prefix})
set(pcraster_raster_format_git_repository
    git://git.code.sf.net/p/pcraster/rasterformat)
set(pcraster_raster_format_git_tag v1.3.1)


# Comment stuff we don't need and that will trip the build.
set(pcraster_raster_format_patch_command
    COMMAND sed -i.tmp "4,6s|^|# |" CMakeLists.txt

    COMMAND sed -i.tmp
        "7i IF(WIN32)\\n    SET(CMAKE_DEBUG_POSTFIX \"d\")\\nENDIF()"
            CMakeLists.txt
)


if(CMAKE_MAKE_PROGRAM)
    set(pcraster_raster_format_cmake_args
        ${pcraster_raster_format_cmake_args}
        -DCMAKE_MAKE_PROGRAM=${CMAKE_MAKE_PROGRAM}
    )
endif()


set(pcraster_raster_format_install_command
    COMMAND ${CMAKE_COMMAND} -E make_directory
        ${pcraster_raster_format_prefix}/lib
    COMMAND ${CMAKE_COMMAND} -E make_directory
        ${pcraster_raster_format_prefix}/include
    COMMAND ${CMAKE_COMMAND} -E copy
        <SOURCE_DIR>/sources/pcraster_raster_format/csftypes.h
        ${pcraster_raster_format_prefix}/include
    COMMAND ${CMAKE_COMMAND} -E copy
        <SOURCE_DIR>/sources/pcraster_raster_format/csf.h
        ${pcraster_raster_format_prefix}/include
    COMMAND ${CMAKE_COMMAND} -E copy
        <SOURCE_DIR>/sources/pcraster_raster_format/csfimpl.h
        ${pcraster_raster_format_prefix}/include
    COMMAND ${CMAKE_COMMAND} -E copy
        <SOURCE_DIR>/sources/pcraster_raster_format/csfattr.h
        ${pcraster_raster_format_prefix}/include
    COMMAND ${CMAKE_COMMAND} -E copy
        <SOURCE_DIR>/sources/pcraster_raster_format/pcrtypes.h
        ${pcraster_raster_format_prefix}/include
)


add_custom_target(pcraster_raster_format-${pcraster_raster_format_version})


function(add_external_project)
    set(options "")
    set(one_value_arguments BUILD_TYPE)
    set(multi_value_arguments INSTALL_COMMAND)

    cmake_parse_arguments(add_external_project "${options}"
        "${one_value_arguments}" "${multi_value_arguments}" ${ARGN})

    if(add_external_project_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR
            "Macro called with unrecognized arguments: "
            "${add_external_project_UNPARSED_ARGUMENTS}")
    endif()

    set(build_type ${add_external_project_BUILD_TYPE})
    set(pcraster_raster_format_install_command
        ${add_external_project_INSTALL_COMMAND})
    set(target
        pcraster_raster_format-${pcraster_raster_format_version}-${build_type})

    ExternalProject_Add(${target}
        LIST_SEPARATOR !
        DOWNLOAD_DIR ${peacock_download_dir}
        GIT_REPOSITORY ${pcraster_raster_format_git_repository}
        GIT_TAG ${pcraster_raster_format_git_tag}
        BUILD_IN_SOURCE 1
        CMAKE_ARGS ${pcraster_raster_format_cmake_args}
            -DCMAKE_BUILD_TYPE=${build_type}
        PATCH_COMMAND ${pcraster_raster_format_patch_command}
        INSTALL_COMMAND ${pcraster_raster_format_install_command}
    )

    add_dependencies(pcraster_raster_format-${pcraster_raster_format_version}
        ${target})
endfunction()


add_external_project(
    BUILD_TYPE Release
    INSTALL_COMMAND
        ${pcraster_raster_format_install_command}
        COMMAND ${CMAKE_COMMAND} -E copy
            <SOURCE_DIR>/sources/pcraster_raster_format/libpcraster_raster_format.a
            ${pcraster_raster_format_prefix}/lib
)

if(WIN32 AND NOT CMAKE_CONFIGURATION_TYPES)
    add_external_project(
        BUILD_TYPE Debug
        INSTALL_COMMAND
            ${pcraster_raster_format_install_command}
            COMMAND ${CMAKE_COMMAND} -E copy
                <SOURCE_DIR>/sources/pcraster_raster_format/libpcraster_raster_formatd.a
                ${pcraster_raster_format_prefix}/lib
    )
    add_dependencies(
        pcraster_raster_format-${pcraster_raster_format_version}-Debug
        pcraster_raster_format-${pcraster_raster_format_version}-Release)
endif()

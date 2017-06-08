set(pcraster_raster_format_prefix ${peacock_package_prefix})
set(pcraster_raster_format_git_repository
    https://github.com/pcraster/rasterformat.git)

set(pcraster_raster_format_git_tag ${pcraster_raster_format_version})

if(NOT pcraster_raster_format_version STREQUAL "HEAD")
    set(pcraster_raster_format_git_tag
        "v${pcraster_raster_format_git_tag}")
endif()


if(${pcraster_raster_format_version} VERSION_LESS "1.3.3")
    # Comment stuff we don't need and that will trip the build.
    set(pcraster_raster_format_patch_command
        COMMAND sed -i.tmp "4,6s|^|# |" CMakeLists.txt

        # This should be handled by the lib itself, but it isn't yet. In future
        # versions we not have to do this.
        COMMAND sed -i.tmp
            "7i \
    if(WIN32)\\n\
        set(CMAKE_DEBUG_POSTFIX \"d\")\\n\
    endif()"
            CMakeLists.txt

        # Add the -fPIC compiler option to allow this library to be included in
        # shared libraries.
        # This should be handled by the lib itself, but it isn't yet. In future
        # versions we not have to do this.
        COMMAND sed -i.tmp
            "1i \
    if(CMAKE_C_COMPILER_ID STREQUAL \"GNU\")\\n\
        add_compile_options(\"-fPIC\")\\n\
    endif()"
            sources/pcraster_raster_format/CMakeLists.txt
    )
endif()


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

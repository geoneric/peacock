set(pcraster_raster_format_prefix ${peacock_package_prefix})
set(pcraster_raster_format_git_repository
    git://git.code.sf.net/p/pcraster/rasterformat)
set(pcraster_raster_format_git_tag v1.3.1)


# Comment stuff we don't need and that will trip the build.
set(pcraster_raster_format_patch_command
    COMMAND sed -i.tmp "4,6s|^|# |" CMakeLists.txt
)


if(CMAKE_MAKE_PROGRAM)
    set(pcraster_raster_format_cmake_args
        -DCMAKE_MAKE_PROGRAM=${CMAKE_MAKE_PROGRAM})
endif()


set(pcraster_raster_format_install_command
    COMMAND ${CMAKE_COMMAND} -E make_directory
        ${pcraster_raster_format_prefix}/lib
    COMMAND ${CMAKE_COMMAND} -E copy
        <SOURCE_DIR>/sources/pcraster_raster_format/libpcraster_raster_format.a
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


ExternalProject_Add(pcraster_raster_format-${pcraster_raster_format_version}
    LIST_SEPARATOR !
    DOWNLOAD_DIR ${peacock_download_dir}
    GIT_REPOSITORY ${pcraster_raster_format_git_repository}
    GIT_TAG ${pcraster_raster_format_git_tag}
    BUILD_IN_SOURCE 1
    CMAKE_ARGS ${pcraster_raster_format_cmake_args}
    PATCH_COMMAND ${pcraster_raster_format_patch_command}
    INSTALL_COMMAND ${pcraster_raster_format_install_command}
)

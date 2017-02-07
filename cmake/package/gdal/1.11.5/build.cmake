set(gdal_download_url http://download.osgeo.org/gdal/${gdal_version})
string(REPLACE "." "" gdal_version_no_dots ${gdal_version})
set(gdal_prefix ${peacock_package_prefix})


if(${host_system_name} STREQUAL "windows")
    set(gdal_url ${gdal_download_url}/gdal${gdal_version_no_dots}.zip)
    set(gdal_url_md5 9553f563f9352030819ad2c8797c17f4)
else()
    set(gdal_url ${gdal_download_url}/gdal-${gdal_version}.tar.gz)
    set(gdal_url_md5 879fa140f093a2125f71e38502bdf714)
endif()


set(gdal_configure_options
    ${gdal_configure_options}
    --prefix=${gdal_prefix}
    --without-libtool
    --host=${peacock_gnu_configure_host}
)

if(${gdal_build_ogr})
    set(gdal_configure_options ${gdal_configure_options} --with-ogr)
else()
    set(gdal_configure_options ${gdal_configure_options} --without-ogr)
endif()


# Set Python_ADDITIONAL_VERSIONS to a list of version numbers that should
# be taken into account when searching for Python.
if(${gdal_build_python_package})
    find_package(PythonInterp REQUIRED)
    set(gdal_configure_options ${gdal_configure_options}
        --with-python=${PYTHON_EXECUTABLE})
endif()


if(${gdal_with_hdf5})
    if(build_hdf5)
        set(gdal_dependencies ${gdal_dependencies} hdf5-${hdf5_version})
        set(gdal_configure_options ${gdal_configure_options}
            --with-hdf5=${hdf5_prefix})
    else()
        find_package(HDF5 REQUIRED
            COMPONENTS C)
        set(gdal_configure_options ${gdal_configure_options}
            --with-hdf5=${HDF5_INCLUDE_DIRS}/..})
    endif()
endif()


if(${gdal_with_netcdf})
    if(build_netcdf)
        set(gdal_dependencies ${gdal_dependencies} netcdf-${netcdf_version})
        set(gdal_configure_options ${gdal_configure_options}
            --with-netcdf=${netcdf_prefix})
    else()
        find_package(NetCDF REQUIRED)
        set(gdal_configure_options ${gdal_configure_options}
            --with-netcdf=${NetCDF_INCLUDE_DIRS}/..})
    endif()
endif()



# On certain platforms, we need to edit some files before starting the build.
if(${host_system_name} STREQUAL "windows")
    if(${peacock_compiler_id} STREQUAL "mingw")
        set(gdal_configure_options
          ${gdal_configure_options}
          --with-curl=no
          --with-threads=no
        )

        set(gdal_patch_command
            # Insert GDAL_ROOT with Windows-style path.
            COMMAND sed -i.tmp "s|@abs_top_builddir@|<SOURCE_DIR>\\n|"
                GDALmake.opt.in

            # Work around "Argument list too long" error by ar.exe, by
            # removing the path to the current directory from the list
            # of object files.
            COMMAND sed -i.tmp "4,7s|^|# |" GNUmakefile
            COMMAND sed -i.tmp
                "8i GDAL_OBJ = ./frmts/o/*.o ./gcore/*.o ./port/*.o ./alg/*.o"
                GNUmakefile
        )
    endif()
endif()


set(gdal_configure_command ./configure ${gdal_configure_options})


# ExternalProject_Add(gdal-${gdal_version}
#     LIST_SEPARATOR !
#     DOWNLOAD_DIR ${peacock_download_dir}
#     URL ${gdal_url}
#     URL_MD5 ${gdal_url_md5}
#     BUILD_IN_SOURCE 1
#     PATCH_COMMAND ${gdal_patch_command}
#     CONFIGURE_COMMAND ${gdal_configure_command}
# )


add_custom_target(gdal-${gdal_version})


function(add_external_project)
    set(options "")
    set(one_value_arguments BUILD_TYPE)
    set(multi_value_arguments PATCH_COMMAND CONFIGURE_COMMAND)

    cmake_parse_arguments(add_external_project "${options}"
        "${one_value_arguments}" "${multi_value_arguments}" ${ARGN})

    if(add_external_project_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR
            "Macro called with unrecognized arguments: "
            "${add_external_project_UNPARSED_ARGUMENTS}")
    endif()

    set(build_type ${add_external_project_BUILD_TYPE})
    set(gdal_patch_command ${add_external_project_PATCH_COMMAND})
    set(gdal_configure_command ${add_external_project_CONFIGURE_COMMAND})
    set(target gdal-${gdal_version}-${build_type})

    ExternalProject_Add(${target}
        DEPENDS ${gdal_dependencies}
        LIST_SEPARATOR !
        DOWNLOAD_DIR ${peacock_download_dir}
        URL ${gdal_url}
        URL_MD5 ${gdal_url_md5}
        BUILD_IN_SOURCE 1
        CMAKE_ARGS ${gdal_cmake_args}
        PATCH_COMMAND ${gdal_patch_command}
        CONFIGURE_COMMAND ${gdal_configure_command}
    )

    add_dependencies(gdal-${gdal_version} ${target})
endfunction()


add_external_project(
    BUILD_TYPE Release
    PATCH_COMMAND ${gdal_patch_command}
    CONFIGURE_COMMAND ${gdal_configure_command}
)


if(WIN32 AND NOT CMAKE_CONFIGURATION_TYPES)
    # Enable debugging and make sure the name of the debug library has a
    # trailing 'd'.
    add_external_project(
        BUILD_TYPE Debug
        PATCH_COMMAND ${gdal_patch_command}
            COMMAND sed -i.tmp "s|libgdal|libgdald|g" GDALmake.opt.in
            COMMAND sed -i.tmp "s|-lgdal|-lgdald|g" GDALmake.opt.in
        CONFIGURE_COMMAND ${gdal_configure_command} --enable-debug
    )

    # First build and install the debug build and after that the release
    # build. We want some of the debug stuff to be overwritten by the
    # release stuff (executables). We only want the debug libraries to be
    # added.
    add_dependencies(
        gdal-${gdal_version}-Release
        gdal-${gdal_version}-Debug)
endif()

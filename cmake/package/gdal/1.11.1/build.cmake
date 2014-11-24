set(gdal_download_url http://download.osgeo.org/gdal/${gdal_version})
string(REPLACE "." "" gdal_version_no_dots ${gdal_version})
set(gdal_prefix ${peacock_package_prefix})


if(${host_system_name} STREQUAL "windows")
    set(gdal_url ${gdal_download_url}/gdal${gdal_version_no_dots}.zip)
    set(gdal_url_md5 bc490ae81b7eb69e15d041c0e308edeb)
else()
    set(gdal_url ${gdal_download_url}/gdal-${gdal_version}.tar.gz)
    set(gdal_url_md5 7555f55855f613be49e6508eed0ac3fa)
endif()


set(configure_options
    --prefix=${gdal_prefix}
    --without-ogr
)

if(${peacock_cross_compiling})
    if(${compiler_id} STREQUAL "mingw")
        if(${target_architecture} STREQUAL "x86_32")
            set(configure_options
                ${configure_options}
                --host=i686-w64-mingw32
            )
        elseif(${target_architecture} STREQUAL "x86_64")
            set(configure_options
                ${configure_options}
                --host=x86_64-w64-mingw32
            )
        endif()
    endif()
endif()

# Set Python_ADDITIONAL_VERSIONS to a list of version numbers that should
# be taken into account when searching for Python.
if(${gdal_build_python_package})
    find_package(PythonInterp REQUIRED)
    set(configure_options
        ${configure_options}
        --with-python=${PYTHON_EXECUTABLE}
    )
endif()

set(gdal_configure_command ./configure ${configure_options})

if(${host_system_name} STREQUAL "windows")
    if(${compiler_id} STREQUAL "mingw")
        set(gdal_build_command mingw32-make -j${peacock_processor_count})
    endif()
endif()


ExternalProject_Add(gdal-${gdal_version}
    LIST_SEPARATOR !
    DOWNLOAD_DIR ${peacock_download_dir}
    URL ${gdal_url}
    URL_MD5 ${gdal_url_md5}
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ${gdal_configure_command}
    BUILD_COMMAND ${gdal_build_command}
)


# On certain platforms, we need to edit some files before starting the build.
if(${host_system_name} STREQUAL "windows")
    if(${compiler_id} STREQUAL "mingw")
        set(configure_options
            ${configure_options}
            --host=x86_64-w64-mingw32
            --build=x86_64-w64-mingw32
        )

        # We assume here that GNU sed is available.
        # TODO Find sed and bail out if not available.

        # When the mingw compiler is used on Windows, the GDALmake.opt script
        # contains a Unix-style path to the root of the GDAL sources.
        # We need to replace this by a Windows-style path.
        ExternalProject_Add_Step(gdal-${gdal_version} port_pathname

            # Comment out GDAL_ROOT with Unix-style path.
            COMMAND sed -i.tmp "1s|^|# |" GDALmake.opt

            # Insert GDAL_ROOT with Windows-style path.
            COMMAND sed -i.tmp "2s|^|GDAL_ROOT = <SOURCE_DIR>\\n|" GDALmake.opt

            # Link errors, GetACP.
            # http://stackoverflow.com/questions/16558813/link-error-with-getacp-under-mingw64-mingw-builds
            COMMAND sed -i.tmp "517s|$| -liconv|" GDALmake.opt

            # Comment out part of the command that confuses libtool.
            COMMAND sed -i.tmp "41s| -DINST_DATA=.*$| \\\\\\|"
                gcore/GNUmakefile

            # TODO Determine the path to the compiler and use that instead
            #      of hardcoding it.
            set(compiler_root "C:/mingw64/bin")

            # Point to mingw's ar.
            COMMAND sed -i.tmp "144s|ar|${compiler_root}/ar|" libtool

            # Point to mingw's ranlib.
            COMMAND sed -i.tmp "156s|ranlib|${compiler_root}/ranlib|" libtool

            DEPENDEES configure
            WORKING_DIRECTORY <SOURCE_DIR>
        )
    endif()
endif()

set(gdal_download_url http://download.osgeo.org/gdal/${gdal_version})
string(REPLACE "." "" gdal_version_no_dots ${gdal_version})
set(gdal_prefix ${package_prefix}/gdal-${gdal_version})


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
        else if(${target_architecture} STREQUAL "x86_64")
            set(configure_options
                ${configure_options}
                --host=x86_64-w64-mingw32
            )
        endif()
    endif()
endif()


set(gdal_update_command "")
set(gdal_configure_command ./configure ${configure_options})


ExternalProject_Add(gdal-${gdal_version}
    LIST_SEPARATOR !
    DOWNLOAD_DIR ${peacock_download_dir}
    URL ${gdal_url}
    URL_MD5 ${gdal_url_md5}
    BUILD_IN_SOURCE 1
    UPDATE_COMMAND ${gdal_update_command}
    CONFIGURE_COMMAND ${gdal_configure_command}
)

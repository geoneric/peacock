set(hdf5_project_url http://www.hdfgroup.org/ftp/HDF5/releases)
set(hdf5_url ${hdf5_project_url}/hdf5-${hdf5_version}/src/hdf5-${hdf5_version}.${hdf5_zip_extension})
set(hdf5_prefix ${peacock_package_prefix})


set(hdf5_configure_options
    ${hdf5_configure_options}
    --prefix=${hdf5_prefix}
    --disable-cxx  # Can't be used icw threadsafe.
    --disable-static
    --enable-shared
    --enable-threadsafe  # Required by HPX.
    --host=${peacock_gnu_configure_host}
    # CFLAGS='-DHDatexit=""'  # TODO Required by HPX.
    # CPPFLAGS='-DHDatexit=""'  # TODO Required by HPX.
)


set(hdf5_configure_command <SOURCE_DIR>/configure ${hdf5_configure_options})


ExternalProject_Add(hdf5-${hdf5_version}
    LIST_SEPARATOR !
    DOWNLOAD_DIR ${peacock_download_dir}
    URL ${hdf5_url}
    URL_MD5 ${hdf5_url_md5}
    BUILD_IN_SOURCE 0
    CONFIGURE_COMMAND ${hdf5_configure_command}
)

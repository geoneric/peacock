set(hpx_project_url http://stellar.cct.lsu.edu/files)
set(hpx_url ${hpx_project_url}/hpx_${hpx_version}.${hpx_zip_extension})
set(hpx_prefix ${peacock_package_prefix})


set(hpx_cmake_args
    ${hpx_cmake_args}
    -DHPX_WITH_HWLOC:BOOL=ON
    -DHPX_WITH_GOOGLE_PERFTOOLS:BOOL=ON
    -DCMAKE_INSTALL_PREFIX=${hpx_prefix}
)

if(hpx_build_examples)
    set(hpx_cmake_args
        ${hpx_cmake_args}
        -DHPX_BUILD_EXAMPLES:BOOL=ON)
endif()

if(build_boost)
    # Make sure our boost is built before hpx is built. Otherwise hpx might
    # pick up another boost build.
    set(hpx_dependencies boost-${boost_version})

    set(hpx_cmake_args
        ${hpx_cmake_args}
        -DBOOST_ROOT:PATH=${boost_prefix}
    )
endif()

ExternalProject_Add(hpx-${hpx_version}
    DEPENDS ${hpx_dependencies}
    LIST_SEPARATOR !
    DOWNLOAD_DIR ${peacock_download_dir}
    URL ${hpx_url}
    URL_MD5 ${hpx_url_md5}
    BUILD_IN_SOURCE 0
    CMAKE_ARGS ${hpx_cmake_args}
)

set(hpx_project_url http://stellar.cct.lsu.edu/files)
set(hpx_url ${hpx_project_url}/hpx_${hpx_version}.${hpx_zip_extension})
set(hpx_prefix ${peacock_package_prefix})


set(hpx_cmake_args
    ${hpx_cmake_args}
    -DHPX_WITH_HWLOC:BOOL=ON
    -DHPX_WITH_GOOGLE_PERFTOOLS:BOOL=ON
    -DCMAKE_INSTALL_PREFIX=${hpx_prefix}
)


set(hpx_parcelport_mpi TRUE)
if(hpx_parcelport_mpi)
    set(hpx_cmake_args
        ${hpx_cmake_args}
        -DHPX_PARCELPORT_MPI:BOOL=ON
    )
endif()


if(hpx_build_examples)
    set(hpx_cmake_args
        ${hpx_cmake_args}
        -DHPX_BUILD_EXAMPLES:BOOL=ON)
endif()


if(build_boost)
    set(hpx_dependencies ${hpx_dependencies} boost-${boost_version})
    set(hpx_cmake_find_root_path ${hpx_cmake_find_root_path}
        ${boost_prefix})
endif()


set(hpx_no_boost_cmake TRUE)
if(build_boost OR hpx_no_boost_cmake)
    set(hpx_cmake_args
        ${hpx_cmake_args}
        -DBoost_NO_BOOST_CMAKE:BOOL=TRUE)
endif()


if(hpx_cmake_find_root_path)
    set(hpx_cmake_args ${hpx_cmake_args}
        -DCMAKE_FIND_ROOT_PATH=${hpx_cmake_find_root_path})
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

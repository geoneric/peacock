set(hpx_url https://github.com/STEllAR-GROUP/hpx/archive/${hpx_version}.tar.gz)
set(hpx_prefix ${peacock_package_prefix})


set(hpx_cmake_args
    ${hpx_cmake_args}
    -DCMAKE_INSTALL_PREFIX=${hpx_prefix}
)


set(hpx_cmake_args
    ${hpx_cmake_args}
    -DHPX_WITH_HWLOC:BOOL=ON
)


if(CMAKE_SYSTEM_NAME MATCHES "^Linux$")
    set(hpx_cmake_args
        ${hpx_cmake_args}
        -DHPX_WITH_HWLOC:BOOL=ON
        -DHPX_WITH_GOOGLE_PERFTOOLS:BOOL=ON
    )
endif()


# TODO Make this a configuration variable in configure.cmake
set(hpx_parcelport_mpi FALSE)
# if(CMAKE_SYSTEM_NAME MATCHES "^Linux$")
#     set(hpx_parcelport_mpi TRUE)
# endif()


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


if(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
    # TODO
    set(hpx_no_boost_cmake TRUE)
endif()


if(build_boost OR hpx_no_boost_cmake)
    set(hpx_cmake_args
        ${hpx_cmake_args}
        -DBoost_NO_BOOST_CMAKE:BOOL=TRUE
    )
endif()


if(hpx_cmake_find_root_path)
    set(hpx_cmake_args
        ${hpx_cmake_args}
        -DCMAKE_FIND_ROOT_PATH=${hpx_cmake_find_root_path}
    )
endif()


ExternalProject_Add(hpx-${hpx_version}
    DEPENDS ${hpx_dependencies}
    LIST_SEPARATOR !
    DOWNLOAD_DIR ${peacock_download_dir}
    URL ${hpx_url}
    BUILD_IN_SOURCE FALSE
    CMAKE_ARGS ${hpx_cmake_args}
    PATCH_COMMAND ${hpx_patch_command}
)

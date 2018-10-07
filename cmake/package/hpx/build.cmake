set(hpx_url https://github.com/STEllAR-GROUP/hpx/archive/${hpx_version}.tar.gz)
set(hpx_prefix ${peacock_package_prefix})


set(hpx_cmake_args
    ${hpx_cmake_args}
    -DCMAKE_INSTALL_PREFIX=${hpx_prefix}
    -DCMAKE_BUILD_TYPE=Release
    -DHPX_WITH_MALLOC=JEMALLOC
    -DHPX_WITH_HWLOC:BOOL=ON
    -DHPX_WITH_THREAD_IDLE_RATES:BOOL=ON

    -DHPX_WITH_PAPI:BOOL=ON
    -DHPX_WITH_GOOGLE_PERFTOOLS:BOOL=ON

    -DHPX_WITH_TOOLS:BOOL=ON
    -DHPX_WITH_TESTS:BOOL=ON
    -DHPX_WITH_EXAMPLES:BOOL=OFF  # TODO Compiler error. Boost.Config.
    -DHPX_WITH_EXAMPLES_HDF5:BOOL=OFF  # TODO threadsafe hdf5 is not picked up
    -DHPX_WITH_EXAMPLES_OPENMP:BOOL=ON

    -DHPX_WITH_CXX0Y:BOOL=ON
    -DHPX_WITH_UNWRAPPED_COMPATIBILITY:BOOL=OFF
    -DHPX_WITH_INCLUSIVE_SCAN_COMPATIBILITY:BOOL=OFF
    -DHPX_WITH_LOCAL_DATAFLOW_COMPATIBILITY:BOOL=OFF
    -DHPX_WITH_PARCELPORT_ACTION_COUNTERS:BOOL=ON
)


### if(CMAKE_SYSTEM_NAME MATCHES "^Linux$")
###     set(hpx_cmake_args
###         ${hpx_cmake_args}
###         -DHPX_WITH_HWLOC:BOOL=ON
###         -DHPX_WITH_GOOGLE_PERFTOOLS:BOOL=ON
###     )
### endif()


# TODO Make this a configuration variable in configure.cmake
set(hpx_parcelport_mpi FALSE)
# if(CMAKE_SYSTEM_NAME MATCHES "^Linux$")
#     set(hpx_parcelport_mpi TRUE)
# endif()


if(hpx_parcelport_mpi)
    set(hpx_cmake_args
        ${hpx_cmake_args}
        -DHPX_WITH_PARCELPORT_MPI:BOOL=ON
    )
endif()


if(build_hdf5)
    set(hpx_dependencies ${hpx_dependencies} hdf5-${hdf5_version})
    set(hpx_cmake_find_root_path
        ${hpx_cmake_find_root_path}
        ${hdf5_prefix})
endif()


if(build_boost)
    set(hpx_dependencies ${hpx_dependencies} boost-${boost_version})
    set(hpx_cmake_find_root_path
        ${hpx_cmake_find_root_path}
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

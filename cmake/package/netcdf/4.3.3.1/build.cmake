# See also:
# - http://www.unidata.ucar.edu/software/netcdf/docs/getting_and_building_netcdf.html#netCDF-CMake

if(${host_system_name} STREQUAL "windows")
    set(netcdf_url_md5 ???)
    set(netcdf_zip_extension zip)
else()
    set(netcdf_url_md5 41fe6758d46cccb1675693d155ee7001)
    set(netcdf_zip_extension tar.gz)
endif()

set(netcdf_project_url https://github.com/Unidata/netcdf-c/archive)
set(netcdf_url ${netcdf_project_url}/v${netcdf_version}.${netcdf_zip_extension})
set(netcdf_prefix ${peacock_package_prefix})


set(netcdf_cmake_args
    ${netcdf_cmake_args}
    -DCMAKE_INSTALL_PREFIX=${netcdf_prefix}
    -DENABLE_NETCDF_4:BOOL=ON
    -DENABLE_DAP:BOOL=ON
    -DBUILD_SHARED_LIBS:BOOL=ON
)


if(${target_system_name} STREQUAL "windows")
    set(netcdf_cmake_args
        ${netcdf_cmake_args}
        ENABLE_DLL:BOOL=ON
    )
endif()


if(build_hdf5)
    set(netcdf_dependencies ${netcdf_dependencies} hdf5-${hdf5_version})

    # TODO Somehow point NetCDF to our HDF5 libraries. This is done
    #      explicitly below, to get things working. NetCDF should find
    #      our HDF5 libraries itself though.
    # Although NetCDF finds our HDF5, it fails with this error:
    # Its seems HDF5_C_LIBRARY is not set.
    #
    # CMake Error at CMakeLists.txt:464 (CHECK_LIBRARY_EXISTS):
    #   CHECK_LIBRARY_EXISTS Macro invoked with incorrect arguments for macro
    #   named: CHECK_LIBRARY_EXISTS

    # Point CMake to our hdf5 install.
    # set(ENV{HDF5_ROOT} ${hdf5_prefix})

    # Pass the location of our hdf5 to the netcdf configuration.
    set(netcdf_cmake_args
        ${netcdf_cmake_args}
        # -DHDF5_DIR:PATH=${hdf5_prefix}/share/cmake/hdf5
        # -DCMAKE_PREFIX_PATH=${hdf5_prefix}

        -DHDF5_INCLUDE_DIR:PATH=${hdf5_prefix}/include
        -DHDF5_HL_LIB:PATH=${hdf5_prefix}/lib/libhdf5_hl.so
        -DHDF5_LIB:PATH=${hdf5_prefix}/lib/libhdf5.so
    )
else()
    find_package(HDF5 REQUIRED COMPONENTS C HL)
    set(netcdf_cmake_args
        ${netcdf_cmake_args}
        -DHDF5_INCLUDE_DIR:PATH=${HDF5_INCLUDE_DIRS}
        -DHDF5_HL_LIB:PATH=${HDF5_HL_LIBRARIES}
        -DHDF5_LIB:PATH=${HDF5_C_LIBRARIES}
    )
endif()


add_custom_target(netcdf-${netcdf_version})


function(add_external_project)
    set(options "")
    set(one_value_arguments BUILD_TYPE)
    set(multi_value_arguments "")

    cmake_parse_arguments(add_external_project "${options}"
        "${one_value_arguments}" "${multi_value_arguments}" ${ARGN})

    if(add_external_project_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR
            "Macro called with unrecognized arguments: "
            "${add_external_project_UNPARSED_ARGUMENTS}")
    endif()

    set(build_type ${add_external_project_BUILD_TYPE})
    set(target netcdf-${netcdf_version}-${build_type})

    ExternalProject_Add(${target}
        DEPENDS ${netcdf_dependencies}
        LIST_SEPARATOR !
        DOWNLOAD_DIR ${peacock_download_dir}
        URL ${netcdf_url}
        URL_MD5 ${netcdf_url_md5}
        BUILD_IN_SOURCE FALSE
        CMAKE_ARGS ${netcdf_cmake_args} -DCMAKE_BUILD_TYPE:STRING=${build_type}
    )

    add_dependencies(netcdf-${netcdf_version} ${target})
endfunction()


add_external_project(BUILD_TYPE Release)


if(WIN32 AND NOT CMAKE_CONFIGURATION_TYPES)
    add_external_project(BUILD_TYPE Debug)
    add_dependencies(netcdf-${netcdf_version}-Debug
        netcdf-${netcdf_version}-Release)
endif()

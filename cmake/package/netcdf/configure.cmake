set(build_netcdf FALSE CACHE BOOL "Build NetCDF")
set(netcdf_version "4.3.3.1")

if(build_netcdf)
    set(netcdf_version ${netcdf_version} CACHE STRING
        "Version of NetCDF to build")
    # dap
    # tests
    # netcdf-4
    # shared
    # utilities
    # hdf4
    # hdf5
    # pnetcdf
    # parallel
    # diskless

    # Needs: hdf5, curl.

    # set(netcdf_build_ogr FALSE CACHE BOOL "Build OGR")
    # set(netcdf_build_python_package FALSE CACHE BOOL "Build Python package")

    set(netcdf_settings
        "version: ${netcdf_version}"
        # "ogr: ${netcdf_build_ogr}"
        # "python: ${netcdf_build_python_package}"
    )
endif()


set(filename ${peacock_package_dir}/netcdf/${netcdf_version}/configure.cmake)
include(${filename})

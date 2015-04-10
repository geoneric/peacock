set(build_netcdf FALSE CACHE BOOL "Build NetCDF")
set(netcdf_version "4.3.3.1")

if(build_netcdf)
    set(netcdf_version ${netcdf_version} CACHE STRING
        "Version of NetCDF to build")
    set(netcdf_settings
        "version: ${netcdf_version}"
    )
endif()


set(filename ${peacock_package_dir}/netcdf/${netcdf_version}/configure.cmake)
include(${filename})

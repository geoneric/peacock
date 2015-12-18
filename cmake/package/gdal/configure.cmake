set(build_gdal FALSE CACHE BOOL "Build GDAL")
set(gdal_version "1.11.1")

if(build_gdal)
    set(gdal_version ${gdal_version} CACHE STRING "Version of GDAL to build")

    # OGR and GDAL have been unified in version >= 2. Before that, building
    # OGR was optional.
    if(gdal_version VERSION_LESS "2")
        set(gdal_build_ogr FALSE CACHE BOOL "Build OGR")
    endif()

    set(gdal_build_python_package FALSE CACHE BOOL "Build Python package")
    set(gdal_with_netcdf FALSE CACHE BOOL "Include netCDF support")
    set(gdal_with_hdf5 FALSE CACHE BOOL "Include HDF5 support")

    set(gdal_settings
        "version: ${gdal_version}"
    )

    if(gdal_version VERSION_LESS "2")
        set(gdal_settings
            "ogr: ${gdal_build_ogr}"
        )
    endif()

    set(gdal_settings
        "python: ${gdal_build_python_package}"
        "hdf5: ${gdal_with_hdf5}"
        "netcdf: ${gdal_with_netcdf}"
    )
endif()


set(filename ${peacock_package_dir}/gdal/${gdal_version}/configure.cmake)
include(${filename})

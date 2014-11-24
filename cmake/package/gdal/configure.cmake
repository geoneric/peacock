set(build_gdal FALSE CACHE BOOL "Build GDAL")
set(gdal_version "1.11.1")

if(build_gdal)
    set(gdal_version ${gdal_version} CACHE STRING "Version of GDAL to build")
    set(gdal_build_ogr FALSE CACHE BOOL "Build OGR")
    set(gdal_build_python_package FALSE CACHE BOOL "Build Python package")

    set(gdal_settings
        "version: ${gdal_version}"
        "ogr: ${gdal_build_ogr}"
        "python: ${gdal_build_python_package}"
    )
endif()


set(filename ${peacock_package_dir}/gdal/${gdal_version}/configure.cmake)
include(${filename})

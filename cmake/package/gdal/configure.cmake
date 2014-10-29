set(build_gdal FALSE CACHE BOOL "Build GDAL")
set(gdal_version "1.11.1")

if(build_gdal)
    set(gdal_version ${gdal_version} CACHE STRING "Version of GDAL to build")
    set(gdal_settings "${gdal_version}")
endif()


set(configure_filename ${peacock_package_dir}/gdal/configure-${gdal_version})
include(${configure_filename}.cmake)

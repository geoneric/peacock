set(build_hdf5 FALSE CACHE BOOL "Build HDF5")
set(hdf5_version "1.8.14")

if(build_hdf5)
    set(hdf5_version ${hdf5_version} CACHE STRING "Version of HDF5 to build")

    set(hdf5_settings
        "version: ${hdf5_version}"
    )
endif()


set(filename ${peacock_package_dir}/hdf5/${hdf5_version}/configure.cmake)
include(${filename})

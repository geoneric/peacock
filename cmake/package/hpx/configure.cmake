set(build_hpx FALSE CACHE BOOL "Build HPX")
set(hpx_version "0.9.10")

if(build_hpx)
    set(hpx_version ${hpx_version} CACHE STRING "Version of HPX to build")
    set(hpx_build_examples FALSE CACHE BOOL "Build the examples")

    set(hpx_settings
        "version: ${hpx_version}"
    )
endif()


set(filename ${peacock_package_dir}/hpx/${hpx_version}/configure.cmake)
include(${filename})

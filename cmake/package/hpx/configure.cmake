set(build_hpx FALSE CACHE BOOL "Build HPX")
set(hpx_version "0.9.99")

if(build_hpx)
    set(hpx_version ${hpx_version} CACHE STRING "Version of HPX to build")
    set(hpx_settings
        "version: ${hpx_version}"
    )
endif()

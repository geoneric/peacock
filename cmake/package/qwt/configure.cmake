set(build_qwt FALSE CACHE BOOL "Build Qwt")
set(qwt_version "6.1.2")

if(build_qwt)
    set(qwt_version ${qwt_version} CACHE STRING "Version of Qwt to build")

    set(qwt_settings
        "version: ${qwt_version}"
    )
endif()


set(filename ${peacock_package_dir}/qwt/${qwt_version}/configure.cmake)
include(${filename})

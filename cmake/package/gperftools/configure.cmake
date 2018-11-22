set(build_gperftools FALSE CACHE BOOL "Build gperftools")
set(gperftools_version "2.7")

if(build_gperftools)
    set(gperftools_version ${gperftools_version} CACHE STRING
        "Version of gperftools to install")

    set(gperftools_settings
        "version: ${gperftools_version}"
    )
endif()

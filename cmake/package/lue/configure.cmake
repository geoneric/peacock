set(build_lue FALSE CACHE BOOL "Build LUE")
set(lue_version "head")

if(build_lue)
    set(lue_version ${lue_version} CACHE STRING
        "Version of LUE to install")

    set(lue_settings
        "version: ${lue_version}"
    )
endif()

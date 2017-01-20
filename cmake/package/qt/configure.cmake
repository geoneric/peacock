set(build_qt FALSE CACHE BOOL "Build Qt")
set(qt_version "5.7.1")

if(build_qt)
    set(qt_version ${qt_version} CACHE STRING "Version of Qt to build")

    set(qt_settings
        "version: ${qt_version}"
    )
endif()

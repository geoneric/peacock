set(build_boost FALSE CACHE BOOL "Build Boost")
set(boost_version "1.57.0")

if(build_boost)
    set(boost_version ${boost_version} CACHE STRING "Version of Boost to build")
    set(boost_build_boost_filesystem FALSE CACHE BOOL
        "Build Filesystem library")
    set(boost_build_boost_python FALSE CACHE BOOL "Build Python library")
    set(boost_build_boost_system FALSE CACHE BOOL "Build System library")
    set(boost_build_boost_test FALSE CACHE BOOL "Build Test library")
    set(boost_build_boost_timer FALSE CACHE BOOL "Build Timer library")

    # http://www.boost.org/doc/libs/1_57_0/more/getting_started/unix-variants.html#header-only-libraries
    set(boost_settings
        "version: ${boost_version}"
        "filesystem: ${boost_build_boost_filesystem}"
        "python: ${boost_build_boost_python}"
        "system: ${boost_build_boost_system}"
        "test: ${boost_build_boost_test}"
        "timer: ${boost_build_boost_timer}"
    )
endif()


set(filename ${peacock_package_dir}/boost/${boost_version}/configure.cmake)
include(${filename})

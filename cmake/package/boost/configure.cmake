set(build_boost FALSE CACHE BOOL "Build Boost")
set(boost_version "1.65.0")

if(build_boost)
    set(boost_version ${boost_version} CACHE STRING "Version of Boost to build")
    set(boost_build_boost_atomic FALSE CACHE BOOL "Build Atomic library")
    set(boost_build_boost_chrono FALSE CACHE BOOL "Build Chrono library")
    set(boost_build_boost_date_time FALSE CACHE BOOL "Build DateTime library")
    set(boost_build_boost_filesystem FALSE CACHE BOOL
        "Build Filesystem library")
    set(boost_build_boost_log FALSE CACHE BOOL "Build Log library")
    set(boost_build_boost_math FALSE CACHE BOOL "Build Math library")
    set(boost_build_boost_program_options FALSE CACHE BOOL
        "Build Program Options library")
    set(boost_build_boost_python FALSE CACHE BOOL "Build Python library")
    set(boost_build_boost_regex FALSE CACHE BOOL "Build Regex library")
    set(boost_build_boost_serialization FALSE CACHE BOOL
        "Build Serialization library")
    set(boost_build_boost_system FALSE CACHE BOOL "Build System library")
    set(boost_build_boost_test FALSE CACHE BOOL "Build Test library")
    set(boost_build_boost_thread FALSE CACHE BOOL "Build Thread library")
    set(boost_build_boost_timer FALSE CACHE BOOL "Build Timer library")

    # http://www.boost.org/doc/libs/1_57_0/more/getting_started/unix-variants.html#header-only-libraries
    set(boost_settings
        "version: ${boost_version}"
        "atomic: ${boost_build_boost_atomic}"
        "chrono: ${boost_build_boost_chrono}"
        "date_time: ${boost_build_boost_date_time}"
        "filesystem: ${boost_build_boost_filesystem}"
        "log: ${boost_build_boost_log}"
        "math: ${boost_build_boost_math}"
        "program_options: ${boost_build_boost_program_options}"
        "python: ${boost_build_boost_python}"
        "regex: ${boost_build_boost_regex}"
        "serialization: ${boost_build_boost_serialization}"
        "system: ${boost_build_boost_system}"
        "test: ${boost_build_boost_test}"
        "thread: ${boost_build_boost_thread}"
        "timer: ${boost_build_boost_timer}"
    )
endif()


set(filename ${peacock_package_dir}/boost/configure_common.cmake)
include(${filename})

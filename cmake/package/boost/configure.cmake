set(build_boost FALSE CACHE BOOL "Build Boost")
set(boost_version "1.56.0")

if(build_boost)
    set(boost_version ${boost_version} CACHE STRING "Version of Boost to build")
    set(boost_settings "${boost_version}")
endif()


set(filename ${peacock_package_dir}/boost/configure-${boost_version}.cmake)
include(${filename})

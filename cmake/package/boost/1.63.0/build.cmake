if(${host_system_name} STREQUAL "windows")
    set(boost_url_md5 3c706b3fc749884ea5510c39474fd732)
else()
    set(boost_url_md5 1c837ecd990bb022d07e7aab32b09847)
endif()

set(user_config_jam_filename "tools/build/src/user-config.jam")

set(filename ${peacock_package_dir}/boost/build_common.cmake)
include(${filename})

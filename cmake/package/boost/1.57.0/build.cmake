if(${host_system_name} STREQUAL "windows")
    set(boost_url_md5 5e040e578e3f0ba879da04a1e0cd55ff)
else()
    set(boost_url_md5 1be49befbdd9a5ce9def2983ba3e7b76)
endif()

set(user_config_jam_filename "tools/build/src/user-config.jam")

set(filename ${peacock_package_dir}/boost/build_common.cmake)
include(${filename})

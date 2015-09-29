if(${host_system_name} STREQUAL "windows")
    set(boost_url_md5 08d29a2d85db3ebc8c6fdfa3a1f2b83c)
else()
    set(boost_url_md5 6aa9a5c6a4ca1016edd0ed1178e3cb87)
endif()

set(user_config_jam_filename "tools/build/src/user-config.jam")

set(filename ${peacock_package_dir}/boost/build_common.cmake)
include(${filename})

if(${host_system_name} STREQUAL "windows")
    set(boost_url_md5 fc16da21d641e03715a4144cb093964e)
else()
    set(boost_url_md5 a744cf167b05d72335f27c88115f211d)
endif()

set(user_config_jam_filename "tools/build/src/user-config.jam")

set(filename ${peacock_package_dir}/boost/build_common.cmake)
include(${filename})

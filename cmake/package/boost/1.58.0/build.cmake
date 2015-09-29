if(${host_system_name} STREQUAL "windows")
    set(boost_url_md5 b0605a9323f1e960f7434dbbd95a7a5c)
else()
    set(boost_url_md5 b8839650e61e9c1c0a89f371dd475546)
endif()

set(user_config_jam_filename "tools/build/src/user-config.jam")

set(filename ${peacock_package_dir}/boost/build_common.cmake)
include(${filename})

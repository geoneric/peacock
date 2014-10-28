if(${host_system_name} STREQUAL "windows")
    set(boost_url_md5 8aca361a4713a1f491b0a5e33fee0f1f)
else()
    set(boost_url_md5 d6eef4b4cacb2183f2bf265a5a03a354)
endif()

set(user_config_jam_filename "tools/build/v2/user-config.jam")

set(filename ${peacock_package_dir}/boost/build_common.cmake)
include(${filename})

if(${host_system_name} STREQUAL "windows")
    set(boost_url_md5 eb1e11262e0cfc6949d054f6d8d25dc6)
else()
    set(boost_url_md5 5512d3809801b0a1b9dd58447b70915d)
endif()

set(user_config_jam_filename "tools/build/src/user-config.jam")

set(filename ${peacock_package_dir}/boost/build_common.cmake)
include(${filename})

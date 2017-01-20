if(${host_system_name} STREQUAL "windows")
    set(qt_url_md5 b684a2f37b1beebd421b3b7d1eca15dc)
else()
    set(qt_url_md5 1b1b1f929d0cd83680354a0c83d8e945)
endif()

set(filename ${peacock_package_dir}/qt/build_common.cmake)
include(${filename})

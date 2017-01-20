if(${host_system_name} STREQUAL "windows")
    set(qt_url_md5 d8d84c6062c15539c5ff9f6f5d781ad8)
else()
    set(qt_url_md5 031fb3fd0c3cc0f1082644492683f18d)
endif()

set(filename ${peacock_package_dir}/qt/build_common.cmake)
include(${filename})

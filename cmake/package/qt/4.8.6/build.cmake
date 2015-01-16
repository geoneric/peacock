if(${host_system_name} STREQUAL "windows")
    set(qt_url_md5 61f7d0ebe900ed3fb64036cfdca55975)
else()
    set(qt_url_md5 2edbe4d6c2eff33ef91732602f3518eb)
endif()

set(filename ${peacock_package_dir}/qt/build_common.cmake)
include(${filename})

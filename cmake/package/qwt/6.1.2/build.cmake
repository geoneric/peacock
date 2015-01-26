if(${host_system_name} STREQUAL "windows")
    set(qwt_url_md5 b43a4e93c59b09fa3eb60b2406b4b37f)
else()
    set(qwt_url_md5 9c88db1774fa7e3045af063bbde44d7d)
endif()

set(qwt_prefix ${peacock_package_prefix})

set(qwt_patch_command
    # Our install prefix.
    COMMAND sed -i.tmp "30s|^|QWT_INSTALL_PREFIX = ${qwt_prefix}|"
        qwtconfig.pri
)

set(filename ${peacock_package_dir}/qwt/build_common.cmake)
include(${filename})

if(${host_system_name} STREQUAL "windows")
    set(qwt_url_md5 62048253bcd0161d7a5b058a1592ff3d)
else()
    set(qwt_url_md5 845837320328e3c92d049cc45c7bdbc2)
endif()

set(qwt_prefix ${peacock_package_prefix})

set(qwt_patch_command
    # Our install prefix.
    COMMAND sed -i.tmp "28s|^|QWT_INSTALL_PREFIX = ${qwt_prefix}|"
        qwtconfig.pri

    # Comment out support for MathML. Results in build error. Fix whenever
    # it is actually needed.
    COMMAND sed -i.tmp
        "s!QWT_CONFIG     += QwtMathML!# QWT_CONFIG     += QwtMathML!"
            qwtconfig.pri
)

set(filename ${peacock_package_dir}/qwt/build_common.cmake)
include(${filename})

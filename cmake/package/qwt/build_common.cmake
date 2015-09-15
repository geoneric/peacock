set(qwt_project_url http://downloads.sourceforge.net/project/qwt/qwt)
set(qwt_url ${qwt_project_url}/${qwt_version}/qwt-${qwt_version})
set(qwt_prefix ${peacock_package_prefix})


if(${host_system_name} STREQUAL "windows")
    set(qwt_url ${qwt_url}.zip)
else()
    set(qwt_url ${qwt_url}.tar.bz2)
endif()


set(qwt_patch_command
    ${qwt_patch_command}

    # We don't have svg support.
    COMMAND sed -i.tmp
        "s!QWT_CONFIG     += QwtSvg!# QWT_CONFIG     += QwtSvg!" qwtconfig.pri

    # Disable support for the Designer plugin. Our Qt build doesn't ѕeem
    # to support it.
    COMMAND sed -i.tmp
        "s!QWT_CONFIG     += QwtDesigner!# QWT_CONFIG     += QwtDesigner!"
            qwtconfig.pri
)


include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/package/qt/qt_make_spec.cmake)


if(build_qt)
    set(qwt_dependencies qt-${qt_version})
    set(qwt_cmake_find_root_path ${qwt_cmake_find_root_path}
        ${qt_prefix})
endif()


set(qwt_cmake_args ${qwt_cmake_args}
    -DCMAKE_FIND_ROOT_PATH=${qwt_cmake_find_root_path})


set(qwt_build_command ${qwt_qmake} -spec ${qt_make_spec} qwt.pro)


ExternalProject_Add(qwt-${qwt_version}
    DEPENDS ${qwt_dependencies}
    LIST_SEPARATOR !
    DOWNLOAD_DIR ${peacock_download_dir}
    URL ${qwt_url}
    URL_MD5 ${qwt_url_md5}
    BUILD_IN_SOURCE 1
    CMAKE_ARGS ${qwt_cmake_args}  # -DCMAKE_BUILD_TYPE=${build_type}
    PATCH_COMMAND ${qwt_patch_command}
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ${qwt_build_command}
)

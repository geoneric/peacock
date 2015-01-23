set(qwt_project_url http://downloads.sourceforge.net/project/qwt/qwt)
set(qwt_url ${qwt_project_url}/${qwt_version}/qwt-${qwt_version})
set(qwt_prefix ${peacock_package_prefix})


if(${host_system_name} STREQUAL "windows")
    set(qwt_url ${qwt_url}.zip)
else()
    set(qwt_url ${qwt_url}.tar.bz2)
endif()


set(qwt_patch_command
    # TODO These commands are possibly version dependent. Move into version-
    #      specific build script that is calling us.

    # Our install prefix.
    COMMAND sed -i.tmp "30s|^|QWT_INSTALL_PREFIX = ${qwt_prefix}|"
        qwtconfig.pri

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
    # If we are building Qt also, then make sure this Qwt is built after Qt
    # has finished building. Otherwise, it may pick up another Qt
    # installation.
    set(qwt_dependencies qt-${qt_version})

    # Building Qt. Set variable to the qmake that will be there once Qt is
    # built (it may be busy building right now and not finished installing
    # qmake). Dependency settings make sure Qwt doest not start building
    # before Qt has finished installing.
    set(qwt_qmake ${peacock_package_prefix}/bin/qmake)
else()
    # Not building Qt. We provide a hint to the directory where Qt's qmake
    # would be installed if we were building Qt. This is handy if Qt is build
    # in a previous run, and we want to pick it up.
    find_program(qwt_qmake qmake HINTS ${peacock_package_prefix}/bin)
endif()


set(qwt_build_command ${qwt_qmake} -spec ${qt_make_spec} qwt.pro)


ExternalProject_Add(qwt-${qwt_version}
    DEPENDS ${qwt_dependencies}
    LIST_SEPARATOR !
    DOWNLOAD_DIR ${peacock_download_dir}
    URL ${qwt_url}
    URL_MD5 ${qwt_url_md5}
    BUILD_IN_SOURCE 1
    PATCH_COMMAND ${qwt_patch_command}
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ${qwt_build_command}
)

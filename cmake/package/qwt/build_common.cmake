set(qwt_project_url http://downloads.sourceforge.net/project/qwt/qwt)
set(qwt_url ${qwt_project_url}/${qwt_version}/qwt-${qwt_version})
set(qwt_prefix ${peacock_package_prefix})


if(${host_system_name} STREQUAL "windows")
    set(qwt_url ${qwt_url}.zip)
else()
    set(qwt_url ${qwt_url}.tar.bz2)
endif()


find_program(qt_qmake qmake HINTS ${peacock_package_prefix}/bin)

# TODO Load macro from script in ../qt dir.
set(qt_make_spec linux-g++-64)


set(qwt_build_command ${qt_qmake} -spec ${qt_make_spec} qwt.pro)


ExternalProject_Add(qwt-${qwt_version}
    LIST_SEPARATOR !
    DOWNLOAD_DIR ${peacock_download_dir}
    URL ${qwt_url}
    URL_MD5 ${qwt_url_md5}
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ${qwt_build_command}
)

ExternalProject_Add_Step(qwt-${qwt_version} qwt_configure

    # Configure install prefix.
    COMMAND sed -i.tmp "30s|^|QWT_INSTALL_PREFIX = ${qwt_prefix}|" qwtconfig.pri

    DEPENDEES update
    WORKING_DIRECTORY <SOURCE_DIR>
)

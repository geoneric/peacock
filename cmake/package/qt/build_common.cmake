string(REGEX REPLACE "^([0-9]+)\\.[0-9]+\\.[0-9]+" "\\1" qt_main_version
    ${qt_version})
string(REGEX REPLACE "^[0-9]+\\.([0-9])+\\.[0-9]+" "\\1" qt_minor_version
    ${qt_version})
string(REGEX REPLACE "^[0-9]+\\.[0-9]+\\.([0-9]+)" "\\1" qt_patch_version
    ${qt_version})
set(qt_project_url http://download.qt.io/archive/qt)
set(qt_url ${qt_project_url}/${qt_main_version}.${qt_minor_version}/${qt_version}/qt-everywhere-opensource-src-${qt_version})

set(qt_prefix ${peacock_package_prefix})


if(${host_system_name} STREQUAL "windows")
    set(qt_url ${qt_url}.zip)  # 7z)
else()
    set(qt_url ${qt_url}.tar.gz)
endif()


if(${target_system_name} STREQUAL "windows")
    set(qt_make_spec win32-g++)
    set(configure_arguments
        -debug-and-release
    )
else()
    if(${target_architecture} STREQUAL "x86_32")
        set(qt_address_model "32")
    else()
        set(qt_address_model "64")
    endif()
    set(qt_make_spec linux-g++-${qt_address_model})
    set(configure_arguments
        -release
        -prefix ${qt_prefix}
    )
endif()

# if cross compiling:
# -xplatform ...
# See README file for list of supported OS' and compilers.

set(configure_arguments
    ${configure_arguments}
    -opensource
    -confirm-license
    -platform ${qt_make_spec}
    -no-qt3support
    -no-xmlpatterns
    -no-multimedia
    -no-phonon
    -no-phonon-backend
    -no-webkit
    -no-script
    -no-scripttools
    -no-declarative
    -nomake examples
    -nomake demos
)

set(qt_configure_command ./configure ${configure_arguments})


ExternalProject_Add(qt-${qt_version}
    LIST_SEPARATOR !
    DOWNLOAD_DIR ${peacock_download_dir}
    URL ${qt_url}
    URL_MD5 ${qt_url_md5}
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ${qt_configure_command}
)

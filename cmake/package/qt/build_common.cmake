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
    set(qt_url ${qt_url}.zip)
else()
    set(qt_url ${qt_url}.tar.gz)
endif()

include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/package/qt/qt_make_spec.cmake)


if(${target_system_name} STREQUAL "windows")
    set(qt_configure_command ./configure.exe)
    set(qt_configure_arguments
        -debug-and-release
    )
else()
    set(qt_configure_command ./configure)
    set(qt_configure_arguments
        -release
        -prefix ${qt_prefix}
    )
endif()

# if cross compiling:
# -xplatform ...
# See README file for list of supported OS' and compilers.

# TODO Qwt's Designer plugin fails because Qt doesn't support for plugins(?).
#      Figure out how the build must be fixed to support Qwt's Designer
#      plugin.

set(qt_configure_arguments
    ${qt_configure_arguments}
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


set(qt_configure_command ${qt_configure_command} ${qt_configure_arguments})

if(${host_system_name} STREQUAL "windows")
    # Don't do anything at install time.
    # The default seems to build qt a second time. There is no install
    # target on Windows. See explicit install steps below.

    set(qt_install_command
        # Install on Windows.
        # http://stackoverflow.com/questions/4699311/how-to-install-qt-on-windows-after-building
        COMMAND ${CMAKE_MAKE_PROGRAM} clean  # Will remove pdb's too!

        COMMAND ${CMAKE_COMMAND} -E make_directory ${qt_prefix}

        COMMAND ${CMAKE_COMMAND} -E make_directory ${qt_prefix}/bin
        COMMAND bash -c "cp -r bin/* ${qt_prefix}/bin"

        COMMAND ${CMAKE_COMMAND} -E make_directory ${qt_prefix}/include
        COMMAND bash -c "cp -r include/* ${qt_prefix}/include"

        COMMAND ${CMAKE_COMMAND} -E make_directory ${qt_prefix}/lib
        COMMAND bash -c "cp -r lib/* ${qt_prefix}/lib"

        COMMAND ${CMAKE_COMMAND} -E make_directory ${qt_prefix}/mkspecs
        COMMAND bash -c "cp -r mkspecs/* ${qt_prefix}/mkspecs"

        COMMAND ${CMAKE_COMMAND} -E make_directory ${qt_prefix}/plugins
        COMMAND bash -c "cp -r plugins/* ${qt_prefix}/plugins"

        COMMAND ${CMAKE_COMMAND} -E make_directory ${qt_prefix}/src
        COMMAND bash -c "cp -r src/* ${qt_prefix}/src"

        COMMAND ${CMAKE_COMMAND} -E make_directory ${qt_prefix}/tools
        COMMAND bash -c "cp -r tools/* ${qt_prefix}/tools"

        COMMAND ${CMAKE_COMMAND} -E echo "[Paths]"
            > ${qt_prefix}/bin/qt.conf
        COMMAND ${CMAKE_COMMAND} -E echo_append "Prefix=.."
            >> ${qt_prefix}/bin/qt.conf
    )
endif()


ExternalProject_Add(qt-${qt_version}
    LIST_SEPARATOR !
    DOWNLOAD_DIR ${peacock_download_dir}
    URL ${qt_url}
    URL_MD5 ${qt_url_md5}
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ${qt_configure_command}
    INSTALL_COMMAND ${qt_install_command}
)

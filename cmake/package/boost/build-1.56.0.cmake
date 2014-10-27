string(REPLACE "." "_" boost_version_underscore ${boost_version})
set(project_url http://downloads.sourceforge.net/project/boost/boost)
set(url ${project_url}/${boost_version}/boost_${boost_version_underscore})
set(prefix ${package_prefix}/boost-${boost_version})

if(WIN32)
    set(url ${url}.zip)
    set(url_md5 fc16da21d641e03715a4144cb093964e)
    set(configure_command ./bootstrap.bat)
    set(boost_variant "debug,release")
else()
    set(url ${url}.tar.bz2)
    set(url_md5 a744cf167b05d72335f27c88115f211d)
    set(configure_command ./bootstrap.sh)
    set(boost_variant "release")
endif()

if(${compiler_id} STREQUAL "gcc" OR ${compiler_id} STREQUAL "mingw")
    set(boost_toolset gcc)
endif()

# if(${target_architecture} STREQUAL x86_64)
#     set(boost_address_model 64)
# endif()

set(boost_link "shared")
set(boost_threading "multi")

set(b2_options
    --debug-configuration
    -j ${peacock_processor_count}
    --prefix=${prefix}
    --layout=tagged
    --without-mpi
    --without-python
    toolset=${boost_toolset}
    variant=${boost_variant}
    # address-model=${boost_address_model}
    link=${boost_link}
    threading=${boost_threading}
)

set(update_command)
if(UNIX AND (${compiler_id} STREQUAL "gcc"))
    if(DEFINED ENV{CXX})
        # b2 does not pick up CC and CXX. It uses toolsets. In case CC or
        # CXX is set, we need to make sure the toolset we use refers to those
        # compilers.
        set(update_command
            echo "using gcc : : $ENV{CXX} !" > ./tools/build/src/user-config.jam
        )
    endif()
endif()


set(build_command ./b2 ${b2_options} stage)
set(install_command ./b2 ${b2_options} install)


ExternalProject_Add(boost-1.56.0
    LIST_SEPARATOR !
    DOWNLOAD_DIR ${peacock_download_dir}
    URL ${url}
    URL_MD5 ${url_md5}
    BUILD_IN_SOURCE 1
    UPDATE_COMMAND ${update_command}
    CONFIGURE_COMMAND ${configure_command}
    BUILD_COMMAND ${build_command}
    INSTALL_COMMAND ${install_command}
)

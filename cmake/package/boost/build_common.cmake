string(REPLACE "." "_" boost_version_underscore ${boost_version})
set(boost_project_url http://downloads.sourceforge.net/project/boost/boost)
set(boost_url ${boost_project_url}/${boost_version}/boost_${boost_version_underscore})
set(boost_prefix ${peacock_package_prefix})


# b2 does not pick up CC and CXX. It uses toolsets. In case
# CXX is set, we need to make sure the toolset we use refers to it.
if(${target_system_name} STREQUAL "darwin")
    set(boost_toolset darwin)

    if(DEFINED ENV{CXX})
        get_filename_component(cxx $ENV{CXX} ABSOLUTE)

        set(boost_update_command
            echo "using darwin : : ${cxx} "
                "!"
                > ${user_config_jam_filename}
        )
    endif()
else()
    if((${compiler_id} STREQUAL "gcc") OR (${compiler_id} STREQUAL "mingw"))
        set(boost_toolset gcc)

        if(DEFINED ENV{CXX})
            get_filename_component(cxx $ENV{CXX} ABSOLUTE)

            if(${peacock_cross_compiling})
                # When cross-compiling, we need to point b2 to the windres, ar
                # and ranlib commands.
                string(FIND ${cxx} "g++" base_id)
                string(SUBSTRING ${cxx} 0 ${base_id} base)

                if(${host_system_name} STREQUAL "windows")
                    set(resource_compiler "windres")
                else()
                    set(resource_compiler ${base}windres)
                endif()

                set(boost_update_command
                    echo "using gcc : : ${cxx} "
                        ": "
                        "<rc>${resource_compiler} "
                        "<archiver>${base}gcc-ar "
                        "<ranlib>${base}gcc-ranlib "
                        "!"
                        > ${user_config_jam_filename}
                )
            else()
                set(boost_update_command
                    echo "using gcc : : ${cxx} "
                        "!"
                        > ${user_config_jam_filename}
                )
            endif()
        endif()
    elseif((${compiler_id} STREQUAL "clang"))
        set(boost_toolset clang)
    endif()
endif()


if(${host_system_name} STREQUAL "windows")
    set(boost_url ${boost_url}.zip)  # 7z)
    set(boost_configure_command ./bootstrap.bat ${boost_toolset})
else()
    set(boost_url ${boost_url}.tar.bz2)
    set(boost_configure_command ./bootstrap.sh --with-toolset=${boost_toolset})
endif()


if(${target_system_name} STREQUAL "windows")
    set(boost_variant "debug,release")
    if(${peacock_cross_compiling})
        set(boost_platform_specific_options
            ${boost_platform_specific_options}
            target-os=windows
            threadapi=win32
            -sNO_BZIP2=1
            # MASM not available on non-Windows platforms. Ѕkip Context and
            # projects depending on it.
            --without-context --without-coroutine
        )
    endif()
else()
    set(boost_variant "release")
endif()


set(boost_link "shared")
set(boost_threading "multi")

if(${target_architecture} STREQUAL "x86_32")
    set(boost_address_model "32")
else()
    set(boost_address_model "64")
endif()


set(b2_options
    -q  # When an error occurs, stop ASAP.
    --debug-configuration
    -j ${peacock_processor_count}
    --prefix=${boost_prefix}
    --layout=tagged
    --without-mpi
    --without-python
    toolset=${boost_toolset}
    variant=${boost_variant}
    address-model=${boost_address_model}
    link=${boost_link}
    threading=${boost_threading}
    ${boost_platform_specific_options}
)


set(boost_build_command ./b2 ${b2_options} stage)
set(boost_install_command ./b2 ${b2_options} install)


ExternalProject_Add(boost-${boost_version}
    LIST_SEPARATOR !
    DOWNLOAD_DIR ${peacock_download_dir}
    URL ${boost_url}
    URL_MD5 ${boost_url_md5}
    BUILD_IN_SOURCE 1
    UPDATE_COMMAND ${boost_update_command}
    CONFIGURE_COMMAND ${boost_configure_command}
    BUILD_COMMAND ${boost_build_command}
    INSTALL_COMMAND ${boost_install_command}
)


# if(${host_system_name} STREQUAL "windows")
#     if(${compiler_id} STREQUAL "mingw")
#         ExternalProject_Add_Step(boost-${boost_version} fix_bootstrap
# 
#             # bootstrap.bat has the msvc toolset hardcoded.
#             COMMAND sed -i.tmp "s|toolset=msvc|toolset=${boost_toolset}|"
#                 bootstrap.bat
# 
#             DEPENDEES update
#             WORKING_DIRECTORY <SOURCE_DIR>
#         )
#     endif()
# endif()

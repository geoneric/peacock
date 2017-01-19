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

        list(APPEND user_config "using darwin : : ${cxx}")
    endif()
else()
    if((${peacock_compiler_id} STREQUAL "gcc") OR
            (${peacock_compiler_id} STREQUAL "mingw"))
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

                list(APPEND user_config
                    "using gcc : : ${cxx} "
                    ": "
                    "<rc>${resource_compiler} "
                    "<archiver>${base}gcc-ar "
                    "<ranlib>${base}gcc-ranlib")
            else()
                list(APPEND user_config "using gcc : : ${cxx}")
            endif()
        endif()
    elseif((${peacock_compiler_id} STREQUAL "clang"))
        set(boost_toolset clang)

        if(DEFINED ENV{CXX})
            get_filename_component(cxx $ENV{CXX} ABSOLUTE)

            list(APPEND user_config "using clang : : ${cxx}")

            # When building bjam, we need to hack to get it to build
            # with the configured compiler.
            # The bjam build scripts use 'clang' as the compiler instead of
            # $CC.
            list(APPEND boost_patch_command
                COMMAND sed -i.tmp "s!clang -W!$ENV{CC} -W!"
                    tools/build/src/engine/build.sh
                COMMAND sed -i.tmp "s!clang clang!clang $ENV{CC}!"
                    tools/build/src/engine/build.jam
            )
        endif()

        # http://stackoverflow.com/questions/12695625/boost-test-crashes-on-exit-with-clang-4-1-llvm-3-1svn
        set(boost_cxx_flags "-std=c++11 -stdlib=libc++")
    endif()
endif()


if(${boost_build_boost_python})
    find_package(PythonInterp REQUIRED)
    find_package(PythonLibs REQUIRED)

    get_filename_component(python_library_dir ${PYTHON_LIBRARIES} DIRECTORY)
    list(APPEND user_config "using python : ${PYTHON_VERSION_MAJOR}.${PYTHON_VERSION_MINOR} : ${PYTHON_EXECUTABLE} : ${PYTHON_INCLUDE_DIRS} : ${python_library_dir}")
endif()


if(${host_system_name} STREQUAL "windows")
    set(boost_url ${boost_url}.zip)  # 7z)
    set(boost_configure_command ./bootstrap.bat ${boost_toolset})
else()
    set(boost_url ${boost_url}.tar.bz2)
    set(boost_configure_command ./bootstrap.sh --with-toolset=${boost_toolset}
        ${bootstrap_options})
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


if(${target_architecture} STREQUAL "x86_32")
    set(boost_address_model "32")
else()
    set(boost_address_model "64")
endif()


if(peacock_verbose)
    set(b2_options
        --debug-configuration
        --debug-building
        -d1)
else()
    set(b2_options
        -d0)
endif()



set(b2_options
    ${b2_options}
    -q  # When an error occurs, stop ASAP.
    -j ${peacock_processor_count}
    --prefix=${boost_prefix}
    --layout=tagged
    toolset=${boost_toolset}
    # cxxflags=${boost_cxx_flags}
    variant=${boost_variant}
    address-model=${boost_address_model}
    link=shared
    threading=multi
    ${boost_platform_specific_options}
)

if(DEFINED boost_cxx_flags)
    set(b2_options
        ${b2_options}
        cxxflags=${boost_cxx_flags}
    )
endif()

# Only pass --with-<library> or --without-<library> options to b2!
# ./b2 --show-libraries
# Not handled yet:
# container context coroutine exception graph graph_parallel iostreams
# locale mpi random signals wave
if(${boost_build_boost_atomic})
    set(b2_options ${b2_options} --with-atomic)
endif()
if(${boost_build_boost_chrono})
    set(b2_options ${b2_options} --with-chrono)
endif()
if(${boost_build_boost_date_time})
    set(b2_options ${b2_options} --with-date_time)
endif()
if(${boost_build_boost_filesystem})
    set(b2_options ${b2_options} --with-filesystem)
endif()
if(${boost_build_boost_log})
    set(b2_options ${b2_options} --with-log)
endif()
if(${boost_build_boost_math})
    set(b2_options ${b2_options} --with-math)
endif()
if(${boost_build_boost_program_options})
    set(b2_options ${b2_options} --with-program_options)
endif()
if(${boost_build_boost_python})
    set(b2_options ${b2_options} --with-python)
endif()
if(${boost_build_boost_regex})
    set(b2_options ${b2_options} --with-regex)
endif()
if(${boost_build_boost_serialization})
    set(b2_options ${b2_options} --with-serialization)
endif()
if(${boost_build_boost_system})
    set(b2_options ${b2_options} --with-system)
endif()
if(${boost_build_boost_test})
    set(b2_options ${b2_options} --with-test)
endif()
if(${boost_build_boost_thread})
    set(b2_options ${b2_options} --with-thread)
endif()
if(${boost_build_boost_timer})
    set(b2_options ${b2_options} --with-timer)
endif()


if(user_config)
    foreach(line ${user_config})
        list(APPEND boost_patch_command
            COMMAND echo "${line} !" >> ${user_config_jam_filename}
        )
    endforeach()
endif()


set(boost_build_command ./b2 ${b2_options} stage)
set(boost_install_command ./b2 ${b2_options} install)


ExternalProject_Add(boost-${boost_version}
    LIST_SEPARATOR !
    DOWNLOAD_DIR ${peacock_download_dir}
    URL ${boost_url}
    URL_MD5 ${boost_url_md5}
    BUILD_IN_SOURCE 1
    CMAKE_ARGS ${boost_cmake_args}
    PATCH_COMMAND ${boost_patch_command}
    CONFIGURE_COMMAND ${boost_configure_command}
    BUILD_COMMAND ${boost_build_command}
    INSTALL_COMMAND ${boost_install_command}
)

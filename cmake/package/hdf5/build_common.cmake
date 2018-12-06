set(hdf5_project_url https://support.hdfgroup.org/ftp/HDF5/releases)

string(REPLACE "." ";" hdf5_versions ${hdf5_version})
list(GET hdf5_versions 0 hdf5_version_major)
list(GET hdf5_versions 1 hdf5_version_minor)
list(GET hdf5_versions 2 hdf5_version_patch)

set(hdf5_url ${hdf5_project_url}/hdf5-${hdf5_version_major}.${hdf5_version_minor}/hdf5-${hdf5_version}/src/hdf5-${hdf5_version}.${hdf5_zip_extension})
set(hdf5_prefix ${peacock_package_prefix})


set(hdf5_cmake_args
    ${hdf5_cmake_args}
    -DCMAKE_INSTALL_PREFIX=${hdf5_prefix}
    -DBUILD_SHARED_LIBS:BOOL=ON
    -DHDF5_BUILD_FORTRAN:BOOL=OFF
    -DHDF5_BUILD_TOOLS:BOOL=ON
    -DHDF5_BUILD_HL_LIB:BOOL=OFF  # Not threadsafe
)

if(hdf5_cpp_lib)
    set(hdf5_cmake_args
        ${hdf5_cmake_args}
        -DHDF5_BUILD_CPP_LIB:BOOL=ON
    )
endif()

if(NOT hdf5_deprecated_symbols)
    set(hdf5_cmake_args
        ${hdf5_cmake_args}
        -DHDF5_ENABLE_DEPRECATED_SYMBOLS:BOOL=OFF
    )
endif()

if(hdf5_parallel)
    set(hdf5_cmake_args
        ${hdf5_cmake_args}
        -DHDF5_ENABLE_PARALLEL:BOOL=ON
    )
endif()

if(hdf5_thread_safe)
    set(hdf5_cmake_args
        ${hdf5_cmake_args}
        -DHDF5_ENABLE_THREADSAFE:BOOL=ON
    )
endif()

add_custom_target(hdf5-${hdf5_version})


function(add_external_project)
    set(options "")
    set(one_value_arguments BUILD_TYPE)
    set(multi_value_arguments "")

    cmake_parse_arguments(add_external_project "${options}"
        "${one_value_arguments}" "${multi_value_arguments}" ${ARGN})

    if(add_external_project_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR
            "Macro called with unrecognized arguments: "
            "${add_external_project_UNPARSED_ARGUMENTS}")
    endif()

    set(build_type ${add_external_project_BUILD_TYPE})
    set(target hdf5-${hdf5_version}-${build_type})

    ExternalProject_Add(${target}
        DEPENDS ${hdf5_dependencies}
        LIST_SEPARATOR !
        DOWNLOAD_DIR ${peacock_download_dir}
        URL ${hdf5_url}
        URL_MD5 ${hdf5_url_md5}
        BUILD_IN_SOURCE FALSE
        CMAKE_ARGS ${hdf5_cmake_args} -DCMAKE_BUILD_TYPE:STRING=${build_type}
    )

    add_dependencies(hdf5-${hdf5_version} ${target})
endfunction()


add_external_project(BUILD_TYPE Release)


if(WIN32 AND NOT CMAKE_CONFIGURATION_TYPES)
    add_external_project(BUILD_TYPE Debug)
    add_dependencies(hdf5-${hdf5_version}-Debug
        hdf5-${hdf5_version}-Release)
endif()

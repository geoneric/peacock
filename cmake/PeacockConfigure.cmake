set(peacock_prefix ${CMAKE_INSTALL_PREFIX} CACHE PATH "Install root")
set(peacock_package_prefix ${peacock_prefix}/${peacock_target_platform})
set(peacock_verbose FALSE CACHE BOOL "Print extra (debug) output")

message(STATUS "peacock: download dir         : ${peacock_download_dir}")
message(STATUS "peacock: install prefix       : ${peacock_package_prefix}")
message(STATUS "peacock: verbose              : ${peacock_verbose}")


# Iterate over all packages and load each package's configuration settings.
file(GLOB filenames RELATIVE ${peacock_package_dir} ${peacock_package_dir}/*)

foreach(package_name ${filenames})
    set(filename ${peacock_package_dir}/${package_name}/configure.cmake)

    # Skip package names that are in fact regular files instead of directories.
    if(EXISTS ${filename})
        list(APPEND package_names ${package_name})
        include(${filename})
        if(${build_${package_name}})
            list(APPEND peacock_packages_to_build ${package_name})
        endif()
    endif()
endforeach()


foreach(package_name ${package_names})
    list(FIND peacock_packages_to_build ${package_name} index)
    if(index GREATER -1)
        message(STATUS
            # "peacock: + ${package_name} (${${package_name}_settings})")
            "peacock: + ${package_name}")
        foreach(setting ${${package_name}_settings})
            message(STATUS
                "peacock:   ${setting}")
        endforeach()
    else()
        message(STATUS
            "peacock: - ${package_name}")
    endif()
endforeach()

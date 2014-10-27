# Iterate over all packages to build and load each package's build rules.

message(STATUS "peacock: packages to build: ${names_of_packages_to_build}")

foreach(package_name ${names_of_packages_to_build})
    set(build_filename ${peacock_package_dir}/${package_name}/build.cmake)
    include(${build_filename})
endforeach()

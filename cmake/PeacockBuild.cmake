# Iterate over all packages to build and load each package's build rules.

message(STATUS "peacock: packages to build: ${peacock_packages_to_build}")

foreach(package_name ${peacock_packages_to_build})
    set(filename ${peacock_package_dir}/${package_name}/${${package_name}_version}/build.cmake)
    include(${filename})
endforeach()

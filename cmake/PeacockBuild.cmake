# Iterate over all packages to build and load each package's build rules.

message(STATUS "peacock: packages to build: ${peacock_packages_to_build}")


# cmake_args contains stuff that should be passed to each invocation of
# ExternalProject_Add. Below, for each project a variable named after
# the project is initialized with the contents of cmake_args. Projects
# can add more stuff to it.

# In case the caller overrides default compilers, we must make sure that
# this information is passed to the project.
if(DEFINED ENV{CC})
    set(cmake_args ${cmake_args} -DCC=ENV{CC})
endif()

if(DEFINED ENV{CXX})
    set(cmake_args ${cmake_args} -DCXX=ENV{CXX})
endif()


foreach(package_name ${peacock_packages_to_build})
    set(${package_name}_cmake_args ${cmake_args})
    set(filename ${peacock_package_dir}/${package_name}/${${package_name}_version}/build.cmake)
    include(${filename})
endforeach()

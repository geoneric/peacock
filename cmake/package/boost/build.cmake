# Pick the file containing the right build rules.
set(build_filename ${peacock_package_dir}/boost/build-${boost_version})
include(${build_filename}.cmake)

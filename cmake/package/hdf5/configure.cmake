set(build_hdf5 FALSE CACHE BOOL "Build HDF5")
set(hdf5_version "1.8.14")


if(build_hdf5)
    set(hdf5_version ${hdf5_version} CACHE STRING "Version of HDF5 to build")
    set(hdf5_cpp_lib FALSE CACHE BOOL "Build HDF5 C++ library")
    set(hdf5_deprecated_symbols TRUE CACHE BOOL
        "Enable deprecated public API symbols")
    set(hdf5_parallel FALSE CACHE BOOL "Enable parallel build (requires MPI)")
    set(hdf5_thread_safe FALSE CACHE BOOL "Enable thread safety")

    if(build_hpx)
        # Required by HPX:
        set(hdf5_thread_safe TRUE)
        set(ENV{CFLAGS} "-DHDatexit=\"\" $ENV{CFLAGS}")
        set(ENV{CPPFLAGS} "-DHDatexit=\"\" $ENV{CPPFLAGS}")
    endif()

    set(hdf5_settings
        "version: ${hdf5_version}"
        "cpp_lib: ${hdf5_cpp_lib}"
        "deprecated symbols: ${hdf5_deprecated_symbols}"
        "parallel: ${hdf5_parallel}"
        "thread_safe: ${hdf5_thread_safe}"
    )
endif()


set(filename ${peacock_package_dir}/hdf5/${hdf5_version}/configure.cmake)
include(${filename})

HDF5
====
http://www.hdfgroup.org/HDF5


Supported platforms
-------------------

| host platform | target platform | compiler | architecture |
| ------------- | --------------- | -------- | ------------ |
| linux         | linux           | gcc, 4.9 | x86-64       |

Other platforms may work but have not been tested.


Package-specific options
------------------------

| variable                       | description                                 |
| ------------------------------ | --------------------------------------------|
| `hdf5_version`                 | Version of HDF5 to build                    |
| `hdf5_cpp_lib`                 | Build HDF5 C++ library                      |
| `hdf5_deprecated_symbols`      | Enable deprecated public API symbols        |
| `hdf5_parallel`                | Enable parallel build (requires MPI)        |
| `hdf5_thread_safe`             | Enable thread safety                        |


Platform-specific notes
-----------------------

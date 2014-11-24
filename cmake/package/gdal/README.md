GDAL
====
http://www.gdal.org

Supported platforms
-------------------

| host platform | target platform | compiler  | target architecture |
| ------------- | --------------- | --------- | ------------------- |
| linux         | linux           | gcc-4     | x86-64              |
| linux         | windows         | mingw-w64 | x86-64              |
| linux         | windows         | mingw-w64 | x86-32              |
| windows       | windows         | mingw-w64 | x86-64              |

Other platforms may work but have not been tested.


Package-specific options
------------------------

| variable                    | description                                    |
| --------------------------- | -----------------------------------------------|
| `gdal_version`              | Version of GDAL to build                       |
| `gdal_build_python_package` | Whether or not to build the Python package     |

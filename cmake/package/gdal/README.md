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
| `gdal_build_ogr`            | Whether or not to build the OGR library        |
| `gdal_build_python_package` | Whether or not to build the Python package     |


See also
--------
- http://trac.osgeo.org/gdal/wiki/FAQInstallationAndBuilding
- https://trac.osgeo.org/gdal/wiki/FAQMiscellaneous#HowdoIdebugGDAL
- http://trac.osgeo.org/postgis/wiki/DevWikiWinMingW64_21#GDAL
- https://github.com/aashish24/gdal-svn

Supporting packages
===================

Configuration generators and build types
----------------------------------------
Some configuration generators configure a project for a single build type (eg: the various Makefile generators) and others for multiple build types (eg: the various Visual Studio project file generators). On some platforms we only need to build a package for the release build type (eg: Linux), on other platforms we need to build for both the debug and release build types (eg: Windows).

To handle these situations, each package's build script must test whether the configuration generator used is a single or multiple configuration generator. CMake provides the variable `CMAKE_CONFIGURATION_TYPES` for that purpose. If it is set, the generator supports multiple configurations.

Additionally, we must test whether we need to build packages for both debug and release build types, or only for release.


Variables set
-------------
|  variable                    | description                           |
| ---------------------------- | ------------------------------------- |
| `peacock_cross_compiling`    | Whether or not we are cross-compiling |
| `host_system_name`           | Name of OS of host system             |
| `target_system_name`         | Name of OS of target system           |
| `target_architecture`        | Architecture of target system         |
| `compiler_id`                | Name of compiler                      |
| `compiler_version`           | Compiler version                      |
| `compiler_main_version`      | Main compiler version                 |
| `peacock_target_platform`    | Name of target platform               |
| `peacock_gnu_configure_host` | Name of host, per GNU conventions     |


Normalized names
----------------
Host and target system names:

- linux
- darwin
- cygwin (implies Windows)
- windows

Host and target architectures:

- x86_32
- x86_64

Compilers:

 - clang
 - gcc
 - mingw
 - msvc

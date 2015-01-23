Supporting packages
===================

Configuration generators and build types
----------------------------------------
Some configuration generators configure a project for a single build type (eg: the various Makefile generators) and others for multiple build types (eg: the various Visual Studio project file generators). On some platforms we only need to build a package for the release build type (eg: Linux), on other platforms we need to build for both the debug and release build types (eg: Windows).

To handle these situations, each package's build script must test whether the configuration generator used is a single or multiple configuration generator. CMake provides the variable `CMAKE_CONFIGURATION_TYPES` for that purpose. If it is set, the generator supports multiple configurations.

Additionally, we must test whether we need to build packages for both debug and release build types, or only for release.


Variables set
-------------
|  variable               | description |
| ---------------------------- | ----------- |
| `peacock_cross_compiling`    | TODO        |
| `host_system_name`           | TODO        |
| `target_system_name`         | TODO        |
| `target_architecture`        | TODO        |
| `compiler_id`                | TODO        |
| `compiler_version`           | TODO        |
| `compiler_main_version`      | TODO        |
| `peacock_target_platform`    | TODO        |
| `peacock_gnu_configure_host` | TODO        |


Normalized names
----------------
host and target system names: linux, darwin, cygwin, windows

host and target architectures: x86_32, x86_64

compilers: clang, gcc, mingw, msvc

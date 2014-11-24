Peacock
=======
Software for building external projects.

**Very much work in progress!**

Most software depends on external software. When building such software, those external software packages must be installed first. Often they are installed already or can be installed easily using package managers. Sometimes this is not the case, though.

This project tries to make it easy to install specific versions of external software. It uses [CMake](http://www.cmake.org) to manage the builds. Here is an example command for building the latest version of [Boost](http://www.boost.org) supported by Peacock:

```bash
cd /tmp/peacock-build
cmake -Dpeacock_prefix=/opt/peacock -Dbuild_boost=true <path_to>/peacock
make
```

This command will configure, build and install Boost. The results will be installed to a directory below `/opt/peacock`. Projects using Boost can point their build script to this directory. The name of the installation directory reflects the target platform of the build, so multiple builds of the same package but for different target platforms can co-exist in the same prefix location.

- [Supported packages](cmake/package/README.md)


Usage
-----
Peacock consists of a collection of CMake script files that manage the build of requested software packages. The first thing to do is to configure the Peacock build. At the very least you need to tell Peacock which packages you want to build. Packages can be selected by passing `-Dbuild_<package>=true` to the `cmake` command. This will add the package to the build. Most packages allow you to tweak their builds by passing additional, package-specific, configuration options. All packages support the `<package>_version` option to select one of the supported versions. Here is an example of building boost version 1.56:

```bash
cmake -Dbuild_boost=true -Dboost_version=1.56.0 <path_to>/peacock
```

General options
---------------
Package-specific options are documented in the [package-specific documentation](cmake/package/README.md).

| variable                  | description                                      |
| ------------------------- | ------------------------------------------------ |
| `peacock_download_dir`    | Directory for downloaded files                   |
| `peacock_prefix`          | Directory for installing files                   |
| `peacock_verbose`         | Print extra (debug) output                       |

Peacock will pick up `$CC` and `$CXX`, and forward them to the build scripts of the packages.


Platform-specific notes
-----------------------
**Windows, Mingw-w64**

On Windows, CMake will always pick up the most recent version of Microsoft Visual Studio, if you have it installed. You can get around this by explicitly selecting the CMake generator of your choice (`cmake -G <generator>`).


Examples
--------
**Linux, GCC**

```bash
cmake \
    -Dpeacock_download_dir=~/tmp/peacock-downloads \
    -Dpeacock_prefix=$HOME/Desktop/peacock \
    -Dbuild_boost=true <path_to>/peacock
```


**Windows, Mingw-w64, Cygwin Bash shell**

```bash
cmake \
    -G "Unix Makefiles" \
    -DCMAKE_MAKE_PROGRAM=mingw32-make \
    -Dpeacock_download_dir=c:/Cygwin/home/<user>/tmp/peacock_downloads \
    -Dpeacock_prefix="c:/Users/<user>/Desktop/peacock" \
    -Dbuild_boost=true <path_to>/peacock
```

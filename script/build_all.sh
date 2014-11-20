#!/usr/bin/env bash
set -e

# The purpose of this script is to test the build of all versions of all
# packages with the current set compiler (default in PATH or explicitly set
# in CC/CXX environment variables).


cwd=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
peacock_root=$cwd/..


function print_usage()
{
    echo -e "\
usage: $0 [-h] <download_dir> <prefix>

-h              Show (this) usage information.

download_dir    Directory to store downloaded files.
prefix          Directory to install the resulting files."
}


function parse_commandline()
{
    while getopts h option; do
        case $option in
            h) print_usage; exit 0;;
            *) print_usage; exit 2;;
        esac
    done
    shift $((OPTIND-1))

    if [ $# -ne 2 ]; then
        print_usage
        exit 2
    fi

    download_dir=$1
    prefix=$2
}


function build_peacock_package()
{
    local package_name=$1
    local version=$2

    echo "build package: $package_name-$version"

    if [[ $OSTYPE == "cygwin" ]]; then
        options+=("-GUnix Makefiles")
        options+=("-DCMAKE_MAKE_PROGRAM=mingw32-make")
    fi

    if [[ $OSTYPE == "linux-gnu" ]] && [[ "$CC" == *mingw* ]]; then
        # Cross-compiling, need toolchain file.
        options+=("-DCMAKE_TOOLCHAIN_FILE=$peacock_root/cmake/toolchain/mingw-linux.cmake")
    fi

    # TODO This partly overwrites earlier versions.
    #      Add option to not install built packages.
    # options+=("-Dpeacock_build_only=true")

    options+=("-Dpeacock_download_dir=$download_dir")
    options+=("-Dpeacock_prefix=$prefix")
    # options+=("-DCMAKE_VERBOSE_MAKEFILE=ON")

    options+=("-Dbuild_$package_name=true")
    options+=("-D${package_name}_version=$version")

    build_root=$package_name-$version
    mkdir -p $build_root
    cd $build_root
    rm -fr *
    cmake "${options[@]}" $peacock_root
    cmake --build . --target all

    cd ..
}


function build_peacock_packages()
{
    for package_name in `ls $peacock_root/cmake/package`; do
        local package_root=$peacock_root/cmake/package/$package_name

        if [ -d $package_root ]; then

            for version in `ls $package_root`; do
                local version_root=$package_root/$version

                if [ -d $version_root ]; then
                    build_peacock_package $package_name $version
                fi
            done
        fi
    done
}


parse_commandline $*
build_peacock_packages

set(build_fern FALSE CACHE BOOL "Build Fern")
set(fern_version "head")

if(build_fern)
    set(fern_version ${fern_version} CACHE STRING "Version of Fern to build")
    set(fern_git_repository CACHE STRING "Repository of Fern sources")
    set(fern_git_tag CACHE STRING "Commit to check out")
    set(fern_build_fern_algorithm FALSE CACHE BOOL "Build Algorithm library")
    set(fern_build_fern_documentation FALSE CACHE BOOL "Build documentation")
    set(fern_build_fern_test FALSE CACHE BOOL "Build tests")

    set(fern_settings
        "version: ${fern_version}"
        "repository: ${fern_git_repository}"
        "tag: ${fern_git_tag}"
        "algorithm: ${fern_build_fern_algorithm}"
        "documentation: ${fern_build_fern_documentation}"
        "test: ${fern_build_fern_test}"
    )
endif()


set(filename ${peacock_package_dir}/fern/${fern_version}/configure.cmake)
include(${filename})

set(build_pcraster FALSE CACHE BOOL "Build PCRaster raster format")
set(pcraster_version "head")

if(build_pcraster)
    set(pcraster_version ${pcraster_version} CACHE STRING
        "Version of PCRaster to build")
    set(pcraster_git_repository CACHE STRING "Repository of PCRaster sources")
    set(pcraster_git_tag CACHE STRING "Commit to check out")

    set(pcraster_settings
        "version: ${pcraster_version}"
        "repository: ${pcraster_git_repository}"
        "tag: ${pcraster_git_tag}"
        "documentation: ${pcraster_build_pcraster_documentation}"
        "test: ${pcraster_build_pcraster_test}"
    )
endif()

set(filename
    ${peacock_package_dir}/pcraster/${pcraster_version}/configure.cmake)
include(${filename})

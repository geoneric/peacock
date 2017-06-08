set(build_pcraster_raster_format FALSE CACHE BOOL
    "Build PCRaster raster format")
set(pcraster_raster_format_version "1.3.2")

if(build_pcraster_raster_format)
    set(pcraster_raster_format_version ${pcraster_raster_format_version}
        CACHE STRING "Version of PCRaster raster format to build")

    set(pcraster_raster_format_settings
        "version: ${pcraster_raster_format_version}"
    )
endif()

set(build_nlohmann_json FALSE CACHE BOOL "Build Docopt")
set(nlohmann_json_version "2.1.1")

if(build_nlohmann_json)
    set(nlohmann_json_version ${nlohmann_json_version} CACHE STRING
        "Version of JSON to install")

    set(nlohmann_json_settings
        "version: ${nlohmann_json_version}"
    )
endif()

set(build_nlohmann_json FALSE CACHE BOOL "Build NLohmann JSON")
set(nlohmann_json_version "3.1.2")

if(build_nlohmann_json)
    set(nlohmann_json_version ${nlohmann_json_version} CACHE STRING
        "Version of JSON to install")

    set(nlohmann_json_settings
        "version: ${nlohmann_json_version}"
    )
endif()

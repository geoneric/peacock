set(build_docopt FALSE CACHE BOOL "Build Docopt")
set(docopt_version "0.6.2")

if(build_docopt)
    set(docopt_version ${docopt_version} CACHE STRING
        "Version of Docopt to build")

    set(docopt_settings
        "version: ${docopt_version}"
    )
endif()

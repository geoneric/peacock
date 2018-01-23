set(build_google_benchmark FALSE CACHE BOOL "Build Google Benchmark")
set(google_benchmark_version "1.3.0")

if(build_google_benchmark)
    set(google_benchmark_version ${google_benchmark_version} CACHE STRING
        "Version of Google Benchmark to install")

    set(google_benchmark_settings
        "version: ${google_benchmark_version}"
    )
endif()

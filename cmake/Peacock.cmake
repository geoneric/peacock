include(ExternalProject)
include(ProcessorCount)

set(peacock_package_dir ${peacock_source_dir}/cmake/package)
set(peacock_download_dir "" CACHE PATH "Directory to store downloaded files")
ProcessorCount(peacock_processor_count)

include(PeacockPlatform)
include(PeacockConfigure)
include(PeacockBuild)

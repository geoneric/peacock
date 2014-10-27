cmake_minimum_required(VERSION 2.8.8 FATAL_ERROR)

project(peacock)

set(CMAKE_MODULE_PATH
    ${CMAKE_CURRENT_SOURCE_DIR}/cmake
    ${CMAKE_CURRENT_SOURCE_DIR}/cmake/package
    ${CMAKE_MODULE_PATH}
)

set(peacock_source_dir ${CMAKE_CURRENT_SOURCE_DIR})

include(Peacock)

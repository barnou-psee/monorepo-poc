cmake_minimum_required(VERSION 3.16..3.31)

project(metavision-bar VERSION 0.0.1 LANGUAGES CXX)

include(cmake/utils/configurator.cmake)
configure_top_level_project()

include(cmake/utils/targets.cmake)
include(cmake/utils/add_library_version_header.cmake)

include(CTest)

find_package(metavision_foo CONFIG REQUIRED)

add_subdirectory(cpp)

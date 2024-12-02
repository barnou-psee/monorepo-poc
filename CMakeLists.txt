cmake_minimum_required(VERSION 3.16..3.31)

project(monorepo_poc LANGUAGES CXX VERSION 0.0.1)

include(cmake/utils/configurator.cmake)
configure_top_level_project()

include(cmake/utils/targets.cmake)
include(cmake/utils/add_library_version_header.cmake)

add_subdirectory(metavision-foo)

cmake_minimum_required(VERSION 3.16)

project(metavision-foo VERSION 0.0.1 LANGUAGES CXX)

find_package(pmake CONFIG REQUIRED)
pmake_configure_project()

add_subdirectory(cpp)

if (BUILD_BINDINGS)
    add_subdirectory(python)
endif()

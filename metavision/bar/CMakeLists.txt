cmake_minimum_required(VERSION 3.16)

project(metavision-bar VERSION 0.0.1 LANGUAGES CXX)

find_package(pmake CONFIG REQUIRED)
pmake_configure_project()

find_package(Metavision COMPONENTS foo REQUIRED)

add_subdirectory(cpp)

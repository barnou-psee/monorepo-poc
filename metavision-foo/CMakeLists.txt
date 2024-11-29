cmake_minimum_required(VERSION 3.16..3.31)

project(metavision-foo VERSION 0.0.1 LANGUAGES CXX)

include(CPack)

add_subdirectory(cpp)

if (BUILD_BINDINGS)
    add_subdirectory(python)
endif()

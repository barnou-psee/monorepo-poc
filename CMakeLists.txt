cmake_minimum_required(VERSION 3.16..3.31)

project(monorepo_poc LANGUAGES CXX VERSION 0.0.1)

include("${CMAKE_BINARY_DIR}/conanworkspace.cmake")
conan_workspace_subdirectories()

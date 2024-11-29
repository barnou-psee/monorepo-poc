cmake_minimum_required(VERSION 3.16..3.31)

project(monorepo_poc LANGUAGES CXX VERSION 0.0.1)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_DEBUG_POSTFIX "d")
 
set(as_subproject metavision-foo)

include(Options.cmake)
include(Dependencies.cmake)

include(${PROJECT_SOURCE_DIR}/cmake/utils/targets.cmake)
include(${PROJECT_SOURCE_DIR}/cmake/utils/add_library_version_header.cmake)

# This macro originates from Daniel Pfeifer's talk at C++Now 2017:
# https://www.youtube.com/watch?v=bsXLMQ6WgIk
macro(find_package)
  if(NOT "${ARGV0}" IN_LIST as_subproject)
    message(STATUS "using native find_package for ${ARGV0}: ${ARGV}")
    _find_package(${ARGV})
  endif()
endmacro()

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}/lib")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}/lib")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}/bin")

add_subdirectory(metavision-foo)

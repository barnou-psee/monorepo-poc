# Copyright (c) Prophesee S.A.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed
# on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.

include(CMakePackageConfigHelpers)

add_library(metavision_bar SHARED)
add_library(Metavision::bar ALIAS metavision_bar)

set_target_properties(metavision_bar
    PROPERTIES
        DEBUG_POSTFIX ${CMAKE_DEBUG_POSTFIX}
        VERSION ${PROJECT_VERSION})

target_psee_set_shared_options(metavision_bar)
target_sources(metavision_bar
    PRIVATE
        src/bar.cpp)
target_include_directories(metavision_bar
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:${PROJECT_NAME}/include>)
target_link_libraries(metavision_bar
    PRIVATE
        Metavision::bar)
      
add_library_version_header(Metavision bar ${CMAKE_CURRENT_SOURCE_DIR}/include/metavision/bar/version.h)

# Tests
if (BUILD_TESTING)
    add_subdirectory(tests)
endif()

if (NOT BUILD_BINDINGS)
    install(
        TARGETS metavision_bar
        EXPORT metavision_barTargets
        LIBRARY DESTINATION ${PROJECT_NAME}/lib)
    install(
        EXPORT metavision_barTargets
        FILE metavision_barTargets.cmake
        NAMESPACE Metavision::
        DESTINATION ${PROJECT_NAME}/lib/cmake/metavision_bar)
    install(
        DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/include/
        DESTINATION ${PROJECT_NAME}/include)
    write_basic_package_version_file(
        metavision_barConfigVersion.cmake
        VERSION ${PROJECT_VERSION}
        COMPATIBILITY SameMajorVersion)
    install(
        FILES metavision_barConfigVersion.cmake
        DESTINATION lib/cmake/metavision_bar)
endif()

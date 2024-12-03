# Copyright (c) Prophesee S.A.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed
# on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.

include(CMakePackageConfigHelpers)

add_library(cimaging_app SHARED)
add_library(CImaging::app ALIAS cimaging_app)

set_target_properties(cimaging_app
    PROPERTIES
        DEBUG_POSTFIX ${CMAKE_DEBUG_POSTFIX}
        VERSION ${PROJECT_VERSION})

target_psee_set_shared_options(cimaging_app)
target_sources(cimaging_app
    PRIVATE
        src/app.cpp)
target_include_directories(cimaging_app
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:${PROJECT_NAME}/include>)
target_link_libraries(cimaging_app
    PRIVATE
        Metavision::foo
        CImaging::app)
      
add_library_version_header(CImaging app ${CMAKE_CURRENT_SOURCE_DIR}/include/cimaging/app/version.h)

# Tests
if (BUILD_APPS)
    add_subdirectory(apps)
endif()

# Tests
if (BUILD_TESTING)
    add_subdirectory(tests)
endif()

if (NOT BUILD_BINDINGS)
    install(
        TARGETS cimaging_app
        EXPORT cimaging_appTargets
        LIBRARY DESTINATION ${PROJECT_NAME}/lib)
    install(
        EXPORT cimaging_appTargets
        FILE cimaging_appTargets.cmake
        NAMESPACE CImaging::
        DESTINATION ${PROJECT_NAME}/lib/cmake/cimaging_app)
    install(
        DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/include/
        DESTINATION ${PROJECT_NAME}/include)
    write_basic_package_version_file(
        cimaging_appConfigVersion.cmake
        VERSION ${PROJECT_VERSION}
        COMPATIBILITY SameMajorVersion)
    install(
        FILES cimaging_appConfigVersion.cmake
        DESTINATION lib/cmake/cimaging_app)
endif()

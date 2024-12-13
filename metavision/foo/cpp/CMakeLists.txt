# Copyright (c) Prophesee S.A.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed
# on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.

include(CMakePackageConfigHelpers)

add_library(metavision_foo SHARED)
add_library(Metavision::foo ALIAS metavision_foo)

set_target_properties(metavision_foo
    PROPERTIES
        DEBUG_POSTFIX ${CMAKE_DEBUG_POSTFIX}
        VERSION ${PROJECT_VERSION})
target_sources(metavision_foo
    PRIVATE
        src/foo.cpp)
target_include_directories(metavision_foo
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:${PROJECT_NAME}/include>)
target_link_libraries(metavision_foo
    PRIVATE
        Metavision::foo)
      
pmake_target_options(metavision_foo)
pmake_generate_version_file(Metavision foo ${CMAKE_CURRENT_SOURCE_DIR}/include/metavision/foo/version.h)

# Tests
if (BUILD_TESTING)
    add_subdirectory(tests)
endif()

if (NOT BUILD_BINDINGS)
    install(
        TARGETS metavision_foo
        EXPORT metavision_fooTargets
        LIBRARY DESTINATION ${PROJECT_NAME}/lib)
    install(
        EXPORT metavision_fooTargets
        FILE metavision_fooTargets.cmake
        NAMESPACE Metavision::
        DESTINATION ${PROJECT_NAME}/lib/cmake/metavision_foo)
    install(
        DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/include/
        DESTINATION ${PROJECT_NAME}/include)
    write_basic_package_version_file(
        metavision_fooConfigVersion.cmake
        VERSION ${PROJECT_VERSION}
        COMPATIBILITY SameMajorVersion)
    install(
        FILES metavision_fooConfigVersion.cmake
        DESTINATION lib/cmake/metavision_foo)
endif()

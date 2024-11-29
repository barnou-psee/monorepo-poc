# Copyright (c) Prophesee S.A.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed
# on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.

add_library(metavision_foo SHARED)
add_library(Metavision::foo ALIAS metavision_foo)

set_target_properties(metavision_foo
    PROPERTIES
        DEBUG_POSTFIX ${CMAKE_DEBUG_POSTFIX}
        VERSION ${PROJECT_VERSION})

target_psee_set_shared_options(metavision_foo)
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
      
add_library_version_header(Metavision foo ${CMAKE_CURRENT_SOURCE_DIR}/include/metavision/foo/version.h)

# Tests
if (BUILD_TESTING)
    add_subdirectory(tests)
endif()

install(TARGETS metavision_foo
        LIBRARY DESTINATION ${PROJECT_NAME}/lib)
install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/include/
        DESTINATION ${PROJECT_NAME}/include)

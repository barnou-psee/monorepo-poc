# Copyright (c) Prophesee S.A.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed
# on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.

find_package(Python REQUIRED COMPONENTS Interpreter Development.Module)
find_package(pybind11 CONFIG REQUIRED)

python_add_library(_app MODULE bindings/cimaging_app_bindings.cpp WITH_SOABI)
target_psee_set_shared_options(_app)
target_link_libraries(_app PRIVATE pybind11::headers CImaging::app)

# This is passing in the version as a define just as an example
target_compile_definitions(_app PRIVATE VERSION_INFO=${PROJECT_VERSION})

set_target_properties(_app PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/cimaging/app
)

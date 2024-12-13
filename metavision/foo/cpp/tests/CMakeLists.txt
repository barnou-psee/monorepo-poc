# Copyright (c) Prophesee S.A.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed
# on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.

find_package(GTest REQUIRED)

set(testname gtest_metavision_utils_foo)
add_executable(${testname}
    ${CMAKE_CURRENT_SOURCE_DIR}/metavision_foo_gtest.cpp
)
pmake_target_options(${testname})
target_link_libraries(${testname}
    PRIVATE
        Metavision::foo
        GTest::gtest
        GTest::gtest_main
)
add_test(
    NAME ${testname}
    COMMAND ${testname} --gtest_color=yes --gtest_output=xml:${PROJECT_BINARY_DIR}/reports/${testname}_output.xml
)
set_property(
    TEST ${testname}
    PROPERTY LABELS "gtest" "metavision" "foo"
)

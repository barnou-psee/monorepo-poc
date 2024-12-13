# Copyright (c) Prophesee S.A.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed
# on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.

function(_get_target_link_directive target directive)
  get_target_property(type ${target} TYPE)
  if (${type} STREQUAL "INTERACE_LIBRARY")
    set(${directive} INTERFACE PARENT_SCOPE)
  else()
    set(${directive} PRIVATE PARENT_SCOPE)
  endif()
endfunction()

function(pmake_target_options_coverage target)
  if (COVERAGE)
    _get_target_link_directive(${target} directive)
    target_compile_options(${target} ${directive} "--coverage" "-fno-inline")
    target_link_options(${target} ${directive} "--coverage")
  endif()
endfunction()

function(pmake_target_options_sanitizer target)
  if (CMAKE_BUILD_TYPE_LOWER STREQUAL "release")
      message(STATUS "No sanitizer in release")
  else()
      _get_target_link_directive(${target} directive)
      string(TOLOWER ${SANITIZER} SANITIZER_LOWER)
      target_compile_options(${target} ${directive} "-fsanitize-recover=address")
      if (SANITIZER_LOWER STREQUAL "address")
          message(STATUS "Enabling Address sanitizer")
          target_link_libraries(${target} ${directive} "-fsanitize=address")
          target_compile_options(${target} ${directive} "-fsanitize=address" "-fno-omit-frame-pointer")
          target_link_options(${target} ${directive} "-static-libasan")
          # for exact trace: add "-fno-optimize-sibling-calls"
      elseif(SANITIZER_LOWER STREQUAL "thread")
          message(STATUS "Enabling Thread sanitizer")
          target_link_libraries(${target} ${directive} "-fsanitize=thread")
      elseif(SANITIZER_LOWER STREQUAL "memory")
          message(STATUS "Enabling Memory sanitizer")
          target_link_libraries(${target} ${directive} "-fsanitize=memory")
          target_compile_options(${target} ${directive} "-fno-omit-frame-pointer")
          # for exact trace: add "-fno-optimize-sibling-calls"
      elseif(SANITIZER_LOWER STREQUAL "undefined")
          message(STATUS "Enabling UndefinedBehaviour sanitizer")
          target_link_libraries(${target} ${directive} "-fsanitize=undefined")
          # a lot of available checks exists
      elseif(NOT SANITIZER_LOWER STREQUAL "none")
          message(WARNING "Unknow sanitizer ${SANITIZER}")
      endif()
  endif()
endfunction()

function(pmake_target_options_optimization target)
  _get_target_link_directive(${target} directive)
  if (CMAKE_BUILD_TYPE_LOWER STREQUAL "debug")
    if (SANITIZER_LOWER STREQUAL "address")
        target_link_libraries(${target} ${directive} "-O1")
    elseif(SANITIZER_LOWER STREQUAL "leak")
        target_link_libraries(${target} ${directive} "-O1")
    elseif(SANITIZER_LOWER STREQUAL "thread")
        target_link_libraries(${target} ${directive} "-O2")
    elseif(SANITIZER_LOWER STREQUAL "undefined")
        target_link_libraries(${target} ${directive} "-O1")
    else()
        target_link_libraries(${target} ${directive} "-O1")
    endif()
  else()
    target_compile_options(${target} ${directive} "-O3")
  endif()
endfunction()

function(pmake_target_options target)
  _get_target_link_directive(${target} directive)
  target_compile_options(${target} ${directive} "-fexceptions")
  if (MSVC)
    find_path(VCPKG_INCLUDE_DIR dirent.h)
    target_include_directories(${target}
        ${directive}
            $<BUILD_INTERFACE:${VCPKG_INCLUDE_DIR}>
            $<INSTALL_INTERFACE:include>)

    target_compile_definitions(${target}
        ${directive}
          "__PRETTY_FUNCTION__=__FUNCSIG__"
          "_USE_MATH_DEFINES"
          "BOOST_ALL_NO_LIB"
          "_CRT_SECURE_NO_WARNINGS"
          "_SCL_SECURE_NO_WARNINGS")

    if (CMAKE_BUILD_TYPE_LOWER STREQUAL "release")
      target_compile_options(${target} ${directive} INTERFACE "/wd\\\"4244\\\" /wd\\\"4267\\\"")
    endif()
  else()
    target_compile_options(${target} ${directive} "-Wall" "-Wextra")
  endif()

  if (CMAKE_BUILD_TYPE_LOWER STREQUAL "debug")
    target_compile_options(${target} ${directive} "-g")
    target_compile_definitions(${target} ${directive} "DEBUG")
  endif()
  pmake_target_options_coverage(${target})
  pmake_target_options_sanitizer(${target})
  pmake_target_options_optimization(${target})
endfunction()

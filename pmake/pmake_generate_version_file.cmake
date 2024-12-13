# Copyright (c) Prophesee S.A.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed
# on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.

# Write the cmake file that we'll run to generate the version file
# Remark : we need to do this instead of just having the file and passing the
# commands like ${GIT_COMMAND_GET_BRANCH} into a variable because this variable would
# contain spaces (and even if passing it between quotes id does not work because it keeps the quotes)
set(_script_dir ${PROJECT_BINARY_DIR}/generated/scripts)
if (NOT EXISTS ${_script_dir})
    file(MAKE_DIRECTORY ${_script_dir})
endif()
set(cmake_script ${_script_dir}/configure_version_file.cmake)
file(WRITE ${cmake_script} "
configure_file(\"${CMAKE_CURRENT_LIST_DIR}/version.h.in\" \"\${OUTPUTFILE}\" @ONLY)
")

########################################################################################
#
# Creates a custom target that writes a version header for a given library
#
#
# usage :
#     add_library_version_header(<target-name> <output-file-path> <library-name>
#        [VERSION X.Y.Z]
#      )
#
#
#  Adds a custom target named <target-name> that writes a version file at <output-file-path>. The header guard of the
#  generated header will be <NAME_UPPER>_VERSION_H, and the following variables are defined :
#
#        <LIBRARY_NAME_UPPER>_VERSION_MAJOR
#        <LIBRARY_NAME_UPPER>_VERSION_MINOR
#        <LIBRARY_NAME_UPPER>_VERSION_PATCH
#
#        <LIBRARY_NAME_UPPER>_GIT_BRANCH_RAW
#        <LIBRARY_NAME_UPPER>_GIT_HASH_RAW
#        <LIBRARY_NAME_UPPER>_GIT_COMMIT_DATE
#
#  where <LIBRARY_NAME_UPPER> = <library-name> upper case.
#
#  If option VERSION is given, its value will be used to set variables <LIBRARY_NAME_UPPER>_VERSION_{MAJOR,MINOR,PATCH},
#  otherwise the PROJECT_VERSION will be used
#
include(CMakeParseArguments)
function(pmake_generate_version_file namespace module outputfile)

    set(VERSION_MAJOR ${PROJECT_VERSION_MAJOR})
    set(VERSION_MINOR ${PROJECT_VERSION_MINOR})
    set(VERSION_PATCH ${PROJECT_VERSION_PATCH})
    set(VERSION_SUFFIX ${PROJECT_VERSION_SUFFIX})

    cmake_parse_arguments(LIB_HEADER "" "VERSION" "" ${ARGN})
    if (LIB_HEADER_VERSION)
        string(REPLACE "." ";" LIB_HEADER_VERSION_LIST ${LIB_HEADER_VERSION})
        list(GET LIB_HEADER_VERSION_LIST 0 VERSION_MAJOR)
        list(GET LIB_HEADER_VERSION_LIST 1 VERSION_MINOR)
        list(GET LIB_HEADER_VERSION_LIST 2 VERSION_PATCH)
    endif(LIB_HEADER_VERSION)

    set(version_file_command
        ${CMAKE_COMMAND}
        -DOUTPUTFILE=${outputfile}
        -DNAMESPACE=${namespace}
        -DMODULE=${module}
        -DVERSION_MAJOR=${VERSION_MAJOR}
        -DVERSION_MINOR=${VERSION_MINOR}
        -DVERSION_PATCH=${VERSION_PATCH}
        -DVERSION_SUFFIX=${VERSION_SUFFIX}
        -P ${cmake_script})

    add_custom_target(
        ${namespace}_${module}_version_file ALL
        COMMAND ${version_file_command}
        COMMENT "Generating version file for library ${namespace}::${module}"
        VERBATIM
    )
    if (NOT EXISTS ${outputfile})
        # Make sure version.h exist at configure then it's updated at runtime
        execute_process(
            COMMAND ${version_file_command}
            ERROR_VARIABLE err
            RESULT_VARIABLE ret
        )
        if(ret AND NOT ret EQUAL 0)
            message(FATAL_ERROR "Error execuding command \n'${version_file_command}' :\n${err}")
        endif()
    endif()
endfunction()

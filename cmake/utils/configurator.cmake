include(CMakeDependentOption)

set(ROOT_PROJECT_DIR ${CMAKE_CURRENT_LIST_DIR}/../..)
set(ROOT_CMAKE_DIR ${ROOT_PROJECT_DIR}/cmake)
set(ROOT_CMAKE_UTILS_DIR ${ROOT_CMAKE_DIR}/utils)
set(ROOT_CMAKE_CPM_DIR ${ROOT_CMAKE_DIR}/cpm)

macro(configure_top_level_project)
  set(CMAKE_CXX_STANDARD 17)
  set(CMAKE_CXX_STANDARD_REQUIRED ON)
  set(CMAKE_CXX_EXTENSIONS OFF)
  set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
  set(CMAKE_DEBUG_POSTFIX "d")

  register_global_options()
  
  set(CPM_SOURCE_CACHE ${ROOT_PROJECT_DIR}/.cache/cpm)
  set(CPM_USE_NAMED_CACHE_DIRECTORIES ON CACHE BOOL "CPM Option")
  set(CPM_USE_LOCAL_PACKAGES ON CACHE BOOL "CPM Option")
  include(${ROOT_CMAKE_CPM_DIR}/get_cpm.cmake)
  if (BUILD_TESTING)
    include(${ROOT_CMAKE_CPM_DIR}/_/googletest.cmake)
  endif()
  if (BUILD_BINDINGS)
    include(${ROOT_CMAKE_CPM_DIR}/_/pybind11.cmake)
  endif()

  set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}/lib")
  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}/lib")
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}/bin")
endmacro()

macro(register_global_options)
  # Build the tests
  option(BUILD_TESTING "Build tests" ON)

  # Build the apps
  option(BUILD_APPS "Build tests" ON)

  # Enable code coverage
  cmake_dependent_option(COVERAGE "Enable code coverage" ON "CMAKE_BUILD_TYPE_LOWER STREQUAL debug" OFF)

  # Enable a sanitizer, only available for Clang with a Debug build
  # Available sanitizers:
  # With just:
  # - [address](https://clang.llvm.org/docs/AddressSanitizer.html)
  # - [memory](https://clang.llvm.org/docs/MemorySanitizer.html)
  # - [thread](https://clang.llvm.org/docs/ThreadSanitizer.html)
  # - [undefined](https://clang.llvm.org/docs/UndefinedBehaviourSanitizer.html)
  # With just:
  # - just cpp-build x86-linux-clang-debug -DSANITIZER=address
  # With cmake:
  # - cmake --preset x86-linux-clang-debug -DSANITIZER=thread
  set(DEFAULT_SANITIZER "address")
  set(POSSIBLE_SANITIZERS "${DEFAULT_SANITIZER};thread;memory;undefined;none")
  if (CMAKE_BUILD_TYPE_LOWER STREQUAL debug AND NOT ANDROID)
    if (NOT SANITIZER)
      set(SANITIZER ${DEFAULT_SANITIZER})
    else()
      set(SANITIZER ${SANITIZER})
    endif()
  else()
    set(SANITIZER "none")
  endif()
  if (NOT "${SANITIZER}" IN_LIST POSSIBLE_SANITIZERS)
    message(WARNING "Disabling sanitizer since given sanitizer ${SANITIZER} is not in the available values ${POSSIBLE_SANITIZERS}")
  endif()
  set(SANITIZER "${SANITIZER}" CACHE STRING "Enabled Sanitizer")

  # Build python bindings
  cmake_dependent_option(BUILD_BINDINGS "Build Python bindings" ON "NOT ANDROID" OFF)
endmacro()

macro(register_cpm)
  set(CPM_SOURCE_CACHE ${ROOT_PROJECT_DIR})
  set(CPM_USE_NAMED_CACHE_DIRECTORIES ON CACHE BOOL "CPM Option")
  set(CPM_USE_LOCAL_PACKAGES ON CACHE BOOL "CPM Option")
  include(${ROOT_CMAKE_CPM_DIR}/get_cpm.cmake)
endmacro()

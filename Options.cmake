include(CMakeDependentOption)

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

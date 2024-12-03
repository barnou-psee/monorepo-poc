project(cimaging-app VERSION 0.0.1 LANGUAGES CXX)

add_subdirectory(cpp)

if (BUILD_BINDINGS)
    add_subdirectory(python)
endif()

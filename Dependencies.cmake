set(CPM_USE_NAMED_CACHE_DIRECTORIES ON CACHE BOOL "CPM Option")
set(CPM_USE_LOCAL_PACKAGES ON CACHE BOOL "CPM Option")
include(${CMAKE_CURRENT_LIST_DIR}/cmake/get_cpm.cmake)

# googletest
if (BUILD_TESTING)
    set(googletest_VERSION "1.14.0")
    CPMFindPackage(
        NAME googletest
        GITHUB_REPOSITORY google/googletest
        VERSION ${googletest_VERSION}
        OPTIONS
            "INSTALL_GTEST OFF"
            "gtest_force_shared_crt ON"
    )
endif()


if (BUILD_BINDINGS)
    # pybind
    set(pybind11_VERSION "2.13.6")
    CPMAddPackage(
        NAME pybind11
        GITHUB_REPOSITORY pybind/pybind11
        VERSION ${pybind11_VERSION}
        OPTIONS
            "PYBIND11_INSTALL OFF"
            "PYBIND11_FINDPYTHON OFF"
    )
endif()

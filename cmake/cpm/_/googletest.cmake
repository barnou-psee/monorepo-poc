set(googletest_VERSION "1.14.0")
CPMFindPackage(
    NAME googletest
    GITHUB_REPOSITORY google/googletest
    VERSION ${googletest_VERSION}
    OPTIONS
        "INSTALL_GTEST OFF"
        "gtest_force_shared_crt ON"
)

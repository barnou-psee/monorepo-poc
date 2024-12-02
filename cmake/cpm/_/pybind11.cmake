set(pybind11_VERSION "2.13.6")
CPMAddPackage(
    NAME pybind11
    GITHUB_REPOSITORY pybind/pybind11
    VERSION ${pybind11_VERSION}
    OPTIONS
        "PYBIND11_INSTALL OFF"
        "PYBIND11_FINDPYTHON OFF"
)

from conan import ConanFile
from conan.tools.files import copy


class PMake(ConanFile):
    name = "pmake"
    version = "1.0.0"
    package_type = "static-library"

    # Declare that we are not including any binaries or libraries
    exports_sources = "*.cmake", "version.h.in"

    def package(self):
        # Define the CMake functions you want to package
        copy(self, "*", src=self.source_folder, dst=self.package_folder)

    def package_info(self):
        # You can provide information on how to use the package
        self.cpp_info.set_property(
            "cmake_build_modules",
            [
                "pmake_generate_version_file.cmake",
                "pmake_configure_project.cmake",
                "pmake_target_options.cmake",
            ],
        )

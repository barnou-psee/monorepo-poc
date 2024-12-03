from conan import ConanFile
from conan.tools.cmake import CMakeToolchain, CMake, CMakeDeps, cmake_layout
from conan.tools.build import check_min_cppstd, can_run
from conan.tools.files import copy
import os


class MetavisionBarConan(ConanFile):
    name = "metavision_bar"

    license = "MIT"
    author = "Your Name <your.email@example.com>"
    url = "https://github.com/your-repo/mypackage"
    description = "A package combining C++ and Python using pybind11 and Google Test"
    topics = ("Metavision", "bar")

    settings = "os", "compiler", "build_type", "arch"
    generators = "CMakeDeps"
    exports_sources = "CMakeLists.txt", "cpp/*", "tests/*", "cmake/*", "CMakePresets.json"

    def set_version(self):
        cz_version = "0.0.1"
        self.version = cz_version

    def requirements(self):
        # Define runtime dependencies if needed
        self.requires("metavision_foo/0.0.1")
        self.test_requires("gtest/1.14.0")

    def validate(self):
        # Ensure the project is built with the minimum required C++ standard
        check_min_cppstd(self, "17")

    def build_requirements(self):
        # Add build-only dependencies if needed
        pass

    def layout(self):
        cmake_layout(self)
        self.folders.build = os.path.join(
            "build",
            str(self.settings.arch).lower()
            + "-"
            + str(self.settings.os).lower()
            + "-"
            + str(self.settings.compiler).lower()
            + "-"
            + str(self.settings.build_type).lower(),
        )
        self.folders.build_folder_vars = ["settings.arch", "settings.os", "settings.compiler", "settings.build_type"]

    def generate(self):
        tc = CMakeToolchain(self)
        tc.generate()

    def configure(self):
        self.options["gtest/*"].shared = False
        self.options["pybind11/*"].shared = False

    def build(self):
        cmake = CMake(self)
        cmake.configure()
        cmake.build()
        if can_run(self) and not self.conf.get("tools.build:skip_test", default=True):
            self.run(f"ctest --output-on-failure -C {self.settings.build_type}")

    def package(self):
        cmake = CMake(self)
        cmake.install()

    def package_info(self):
        self.cpp_info.libs = ["metavision_bar"]
        self.cpp_info.set_property("cmake_target_name", "Metavision::bar")
        if self.settings.compiler.cppstd:
            self.cpp_info.cppstd = "17"

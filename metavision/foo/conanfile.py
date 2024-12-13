from conan import ConanFile
from conan.tools.files import load
from conan.tools.cmake import CMake, CMakeDeps, CMakeToolchain, cmake_layout
import os
import re


class MetavisionFoo(ConanFile):
    name = "metavision-foo"
    description = "A basic recipe"
    settings = "os", "compiler", "build_type", "arch"

    exports_sources = "CMakeLists.txt", "cpp/*"

    def layout(self):
        cmake_layout(self)
        self.folders.build = os.path.join(
            "build",
            "conan",
            str(self.settings.arch).lower()
            + "-"
            + str(self.settings.os).lower()
            + "-"
            + str(self.settings.compiler).lower()
            + "-"
            + str(self.settings.build_type).lower(),
        )
        self.folders.build_folder_vars = ["settings.arch", "settings.os", "settings.compiler", "settings.build_type"]

    def requirements(self):
        self.tool_requires("pmake/1.0.0")
        self.requires("pybind11/2.13.6")
        self.test_requires("gtest/1.14.0")

    def set_version(self):
        content = load(self, os.path.join(self.recipe_folder, "CMakeLists.txt"))
        self.version = re.search(r"project\(metavision-foo VERSION (.*) LANGUAGES CXX\)", content).group(1)

    # The purpose of generate() is to prepare the build, generating the necessary files, such as
    # Files containing information to locate the dependencies, environment activation scripts,
    # and specific build system files among others
    def generate(self):
        tc = CMakeToolchain(self)
        tc.variables["BUILD_BINDINGS"] = False
        tc.generate()

        deps = CMakeDeps(self)
        # By default 'myfunctions-config.cmake' is not created for tool_requires
        # we need to explicitly activate it
        deps.build_context_activated = ["pmake"]
        # and we need to tell to automatically load 'myfunctions' modules
        deps.build_context_build_modules = ["pmake"]
        deps.generate()

    # This method is used to build the source code of the recipe using the desired commands.
    def build(self):
        cmake = CMake(self)
        cmake.configure()
        cmake.build()

    # The actual creation of the package, once it's built, is done in the package() method.
    # Using the copy() method from tools.files, artifacts are copied
    # from the build folder to the package folder
    def package(self):
        cmake = CMake(self)
        cmake.install()

    def package_info(self):
        self.cpp_info.set_property("cmake_file_name", "Metavision")
        self.cpp_info.components["foo"].libs = ["metavision_foo"]
        self.cpp_info.components["foo"].includedirs = ["cpp/include"]
        self.cpp_info.components["foo"].set_property("cmake_target_name", "Metavision::foo")
        self.cpp_info.cppstd = "17"

set shell := ["bash", "-uc"]
export PATH := join(justfile_directory(), ".venv/bin") + ":" + env_var('PATH')

import 'private.just'

default_preset := 'x86-linux-gcc-release'


# Build using CMake
[no-cd]
build preset=default_preset args='':
    @echo "🚀 Building preset={{preset}}"
    cmake --preset {{preset}} {{args}}
    cmake --build --preset {{preset}} -j

# Test using CTest
[no-cd]
test preset=default_preset: (build preset)
    @echo "🚀 Testing preset={{preset}}"
    ctest --preset {{preset}}

# Build using Conan
[no-cd]
conan-build profile='default' build_type='Release':
    @echo "🚀 Packaging conan for profile={{profile}} build_type={{build_type}}"
    conan build . \
        --build=missing \
        -s build_type={{build_type}} \
        -c tools.build:skip_test=False \
        -s compiler.cppstd=17 \
        --profile={{profile}}

# Package using Conan
[no-cd]
package profile='default' build_type='Release':
    @echo "🚀 Packaging conan for profile={{profile}} build_type={{build_type}}"
    conan create . \
        --build=missing \
        -s build_type={{build_type}} \
        -c tools.build:skip_test=False \
        -s compiler.cppstd=17 \
        --profile={{profile}}

# Publishing on artifactory using Conan
[no-cd]
publish profile='default' build_type='Release': (package profile build_type)
    @echo "🚀 Publishing with conan for profile={{profile}} build_type={{build_type}}"
    conan upload metavision_libraw -r=cimaging-conan

# Analyzing C++ code with Sonarqube
[no-cd]
analyze dir *flags:
    @echo "🚀 Publishing wheels"
    @just _check-file {{dir}}/compile_commands.json
    gcovr -r . --sonarqube {{dir}}/coverage.xml -s -j
    @just _check-file {{dir}}/coverage.xml
    pysonar-scanner -Dtoml.path=pyproject.toml \
        -Dsonar.projectKey=metavision-libraw-cpp \
        -Dsonar.cfamily.compile-commands={{dir}}/compile_commands.json \
        -Dsonar.cfamily.reportingCppStandardOverride=c++17 \
        -Dsonar.coverageReportPaths={{dir}}/coverage.xml \
        -Dsonar.python.file.suffixes=- \
        -Dsonar.toml.file.suffixes=- \
        -Dsonar.yaml.file.suffixes=- \
        -Dsonar.exclusions=test_package/** \
        -Dsonar.coverage.exclusions=cpp/apps/**,cpp/tests/** {{flags}}

#!/bin/bash

cyan="\033[96m"
red="\033[91m"
yellow="\033[93m"
green="\033[92m"
reset="\033[0m"

# An array to hold any output
output=()

# brief: Checks version of a program installed against a version specified as the
# first parameter.
#
# param_1: The name of the program
# param_2: The command to get the version
# param_3: The version to check for
# param_4: The type of check
# (EXACTLY: check for this exact version)
# (ATLEAST: check that this version or later is installed.)
# param_5: A REGEX command to search for the version number
#
# return: 0 on success, anything else is failure
check_package_version()
{
    local name="$1"
    local version_command="$2"
    local required_version="$3"
    local check_type="$4"
    local search_command="$5"
    local installed_version=""
    
    if ! dpkg -s "${name}" >/dev/null 2>&1; then
        output+="$red[NOT FOUND]$reset\n"
        return 1
    fi
    
    installed_version=$(${version_command} | grep -oP "${search_command}")
    
    if [ "$check_type" == "EXACTLY" ]; then
        if [[ "$installed_version" == "$required_version" ]]; then
            output+="$yellow[$installed_version]$reset\n"
            return 0
        else
            output+="$red[$installed_version]$reset requires exactly $yellow[$required_version]$reset\n"
            return 1
        fi
    fi

    if [ "$check_type" == "ATLEAST" ]; then
        if [[ $(echo -e "${installed_version}\n${required_version}" | sort -V | head -n 1) == "${required_version}" ]]; then
            output+="$yellow[$installed_version]$reset\n"
            return 0
        else
            output+="$red[$installed_version]$reset requires at least $yellow[$required_version]$reset\n"
            return 1
        fi
    fi
    
    echo "invalid check type"
    return 1
}

# brief: Checks version of a program installed against a version specified as the
# first parameter.
#
# param_1: The name of the program
# param_2: The command to get the version
# param_3: The version to check for
# param_4: The type of check
# (EXACTLY: check for this exact version)
# (ATLEAST: check that this version or later is installed.)
# param_5: A REGEX command to search for the version number
#
# return: 0 on success, anything else is failure
check_snap_version()
{
    local name="$1"
    local version_command="$2"
    local required_version="$3"
    local check_type="$4"
    local search_command="$5"
    local installed_version=""
    
    if ! snap list | grep -q "${name}"; then
        output+="$red[NOT FOUND]$reset\n"
        return 1
    fi
    
    installed_version=$(${version_command} | grep -oP "${search_command}")
    
    if [ "$check_type" == "EXACTLY" ]; then
        if [[ "$installed_version" == "$required_version" ]]; then
            output+="$yellow[$installed_version]$reset\n"
            return 0
        else
            output+="$red[$installed_version]$reset requires exactly $yellow[$required_version]$reset\n"
            return 1
        fi
    fi

    if [ "$check_type" == "ATLEAST" ]; then
        if [[ $(echo -e "${installed_version}\n${required_version}" | sort -V | head -n 1) == "${required_version}" ]]; then
            output+="$yellow[$installed_version]$reset\n"
            return 0
        else
            output+="$red[$installed_version]$reset requires at least $yellow[$required_version]$reset\n"
            return 1
        fi
    fi
    
    echo "invalid check type"
    return 1
}

#####################################################################
# NOTE: The following brief applies to all of the remaining functions
#####################################################################

# brief: Checks version of a program installed against a version specified as the
# first parameter.
#
# param_1: The version to check for (defaults to specific version if left blank)
#
# return: 0 on success, anything else is failure

check_build_essential()
{
    check_package_version "build-essential" "apt-cache policy build-essential" "${1:-"12.8"}" "ATLEAST" "(?<=Installed: )\d+\.\d+(\.\d+)?"
}

check_make()
{
    check_package_version "make" "make --version" "${1:-"4.2.1"}" "ATLEAST" "(?<=GNU Make )\d+\.\d+(\.\d+)?"
}

check_cmake()
{
    check_package_version "cmake" "cmake --version" "${1:-"3.16.3"}" "EXACTLY" "(?<=cmake version )\d+\.\d+(\.\d+)?"
}

check_valgrind()
{
    check_package_version "valgrind" "valgrind --version" "${1:-"3.15.0"}" "ATLEAST" "(?<=valgrind-)\d+\.\d+(\.\d+)?"
}

check_python()
{
    check_package_version "python3" "python3 --version" "${1:-"3.8.10"}" "EXACTLY" "(?<=Python )\d+\.\d+(\.\d+)?"
}

check_pip()
{
    check_package_version "python3-pip" "pip --version" "${1:-"20.0.2"}" "ATLEAST" "(?<=pip )\d+\.\d+(\.\d+)?"
}

check_curl()
{
    check_package_version "curl" "curl --version" "${1:-"7.68.0"}" "ATLEAST" "(?<=curl )\d+\.\d+(\.\d+)?"
}

check_clang()
{
    check_package_version "clang-12" "clang-12 --version" "${1:-"12.0.0"}" "EXACTLY" "(?<=clang version )\d+\.\d+(\.\d+)?"
}

check_clang_format()
{
    check_package_version "clang-format" "clang-format --version" "${1:-"10.0.0"}" "ATLEAST" "(?<=clang-format version )\d+\.\d+(\.\d+)?"
}

check_clang_tidy()
{
    check_package_version "clang-tidy" "clang-tidy --version" "${1:-"10.0.0"}" "ATLEAST" "(?<=version )\d+\.\d+(\.\d+)?"
}

check_libcunit1()
{
    check_package_version "libcunit1" "apt-cache policy libcunit1" "${1:-"2.1"}" "ATLEAST" "(?<=Installed: )\d+\.\d+"
}

check_libcunit1_doc()
{
    check_package_version "libcunit1-doc" "apt-cache policy libcunit1-doc" "${1:-"2.1"}" "ATLEAST" "(?<=Installed: )\d+\.\d+"
}

check_libcunit1_dev()
{
    check_package_version "libcunit1-dev" "apt-cache policy libcunit1-dev" "${1:-"2.1"}" "ATLEAST" "(?<=Installed: )\d+\.\d+"
}

check_vscode()
{
    check_snap_version "code" "code --version" "${1:-"1.77.1"}" "ATLEAST" "\d+\.\d+(\.\d+)?"
}

check_git()
{
    check_package_version "git" "git --version" "${1:-"2.25.1"}" "ATLEAST" "(?<=git version )\d+\.\d+\.\d+"
}

checks=(
    check_build_essential:build-essential
    check_make:make
    check_cmake:cmake
    check_valgrind:valgrind
    check_python:python3
    check_pip:python3-pip
    check_curl:curl
    check_clang:clang-12
    check_clang_format:clang-format
    check_clang_tidy:clang-tidy
    check_libcunit1:libcunit1
    check_libcunit1_doc:libcunit-doc
    check_libcunit1_dev:libcunit-dev
    check_vscode:code
    check_git:git
)

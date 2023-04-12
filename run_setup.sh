#! /bin/bash

set -e # used to exit the script immediately if any errors occur
trap "catch $? $LINENO" EXIT

source src/utilities.sh
source src/vscode_config.sh
source src/git_config.sh
source src/ssh_key_setup.sh

catch()
{
    if [ "$1" != "0" ]; then
        # error handling goes here
        print_style "\n*** ERROR: Exit failure with $1 on line $2 ***\n" "danger"
    fi
}

main()
{
    EXIT_SUCCESS=0
    EXIT_FAILURE=1

    base_install
    print_style "\n***Complete***\n" "success"
    exit "$EXIT_SUCCESS"
}

base_install()
{
    option=''

    print_style "\n[NOTICE]:\n" "warning"
    print_style "\
This script installs the necessary programs and extensions required to complete
the CSD-T JQR project requirements on a Linux Ubuntu 20.04 system.

The script will install the following programs:\n\n" "info"
    print_style "\
       [NAME]               [DESCRIPTION]
    1. build-essential:.....Essential tools and needed to build software
    2. make:................Used to build executable programs and libraries
    3. cmake:...............Used to manage the build process of software
    4. curl:................Command-line tool used to transfer data
    5. pip:.................Package installer for Python
    6. clang-12:............Compiler for C and C++ programming languages
    7. clang-format:........Code Formatting tool for C/C++
    8. clang-tidy:..........Static analyzer tool for C/C++
    9. cunit:...............Unit testing framework for C
    10. VS Code:............Source-code editor made by Microsoft\n"

    while [ "$option" != "y" ] && [ "$option" != "n" ]
    do
        print_style "\ncontinue? [y/n]\n" "info"
        read -r option
    done
    
    if [ "$option" = "n" ]; then
        echo "Exiting..."
        exit 0
    fi

    # Perform initial setup
    sudo apt update && sudo apt dist-upgrade -y

    # Install base packages
    install_build_essential
    install_make
    install_cmake
    install_valgrind
    install_curl
    install_pip
    install_clang_suite
    install_cunit
    install_vscode
    install_git

    clear

    # Verify everything was installed correctly
    chmod +x ./scripts/run_version_check.sh
    cd scripts
    ./run_version_check.sh
    cd ..

    # optional configurations/installations
    set_up_git
    install_posix_cac
    setup_ssh_keys

    # Setup aliases
    set_aliases
}

#---------------------------------------------------------------
# Name:        | Build-Essential
# Description: | Meta-packages necessary for compiling software
#---------------------------------------------------------------
install_build_essential()
{
    install_package_if_not_present "build-essential" "Meta-packages necessary for compiling software" "Build-Essential"
}

#---------------------------------------------------------------
# Name:        | Make
# Description: | Used to build executable programs and libraries from source code
#---------------------------------------------------------------
install_make()
{
    install_package_if_not_present "make" "Used to build execuatable programs and libraries from source code" "Make"
}

#---------------------------------------------------------------
# Name:        | CMake
# Description: | Used to build executable programs and libraries from source code
#---------------------------------------------------------------
install_cmake()
{
    install_package_if_not_present "cmake" "Used to build executable programs and libraries from source code" "CMake"
}

#---------------------------------------------------------------
# Name:        | Curl
# Description: | Command-line tool to transfer data to or from a server
#---------------------------------------------------------------
install_curl()
{
    install_package_if_not_present "curl" "Command-line tool to transfer data to or from a server" "Curl"
}

#---------------------------------------------------------------
# Name:        | Pip
# Description: | 3rd-party package manager for Python modules
#---------------------------------------------------------------
install_pip()
{
    install_package_if_not_present "python3-pip" "3rd-party package manager for Python modules" "Pip"
}

#---------------------------------------------------------------
# Name:        | Clang / Clang Format / Clang Tidy
# Description: | LLVM-based C/C++ compiler and additional tools
#---------------------------------------------------------------
install_clang_suite()
{
    install_package_if_not_present "clang-12" "LLVM-based C/C++ compiler" "Clang"
    install_package_if_not_present "clang-format" "Code Formatting tool for C/C++" "Clang Format"
    install_package_if_not_present "clang-tidy" "Static analyzer tool for C/C++" "Clang Tidy"
}

#---------------------------------------------------------------
# Name:        | CUnit / doc / dev
# Description: | Unit testing framework for C, and additional documentation and files
#---------------------------------------------------------------
install_cunit()
{
    install_package_if_not_present "libcunit1" "Unit testing framework for C" "CUnit"
    install_package_if_not_present "libcunit1-doc" "Documentation for the Cunit framework" "Cunit Documentation"
    install_package_if_not_present "libcunit1-dev" "Development files and header files for CUnit" "Cunit Development Files"
}

#---------------------------------------------------------------
# Name:        | Valgrind
# Description: | Memory management and bug detector for C
#---------------------------------------------------------------
install_valgrind()
{
    install_package_if_not_present "valgrind" "Memory management and bug detector for C" "Valgrind"
}

#---------------------------------------------------------------
# Name:        | Git
# Description: | Distributed version control system for developers
#---------------------------------------------------------------
install_git()
{
    install_package_if_not_present "git-all" "Distributed version control system for developers" "Git"
}

#---------------------------------------------------------------
# Name:        | VS Code
# Description: | Source-code editor made by Microsoft
#---------------------------------------------------------------
install_vscode()
{
    if ! command -v code &> /dev/null; then
        print_description "VS Code" "Source-code editor made by Microsoft"
        sudo snap install --classic code
    fi

    install_vscode_extensions
    update_vscode_settings
    update_vscode_user_snippets
}

install_vscode_extensions()
{
    if command -v code &> /dev/null; then

        # C/C++ Extension Pack
        install_extension_if_not_present "ms-vscode.cpptools-extension-pack" "C/C++ Extention Pack"

        # Doxygen Documentation Generator
        install_extension_if_not_present "cschlosser.doxdocgen" "Doxygen"

        # Python
        install_extension_if_not_present "ms-python.python" "Python"

        # VS Code PDF
        install_extension_if_not_present "tomoki1207.pdf" "VS Code PDF"

    else
        print_style "VS Code is not installed. Cannot install VS Code extensions!\n" "danger"
    fi
}

install_posix_cac()
{
    option=''

    print_style "\n[POSIX CAC]-----------------------------------\n" "header"

    while [ "$option" != "y" ] && [ "$option" != "n" ]
    do
        print_style "Do you want to install CAC credentials? [y/n]\n" "info"
        read -r option
    done
    
    if [ "$option" = "y" ]; then
        chmod +x ./scripts/install_posix_cac.sh
        ./scripts/install_posix_cac.sh
    fi
}

install_package_if_not_present()
{
    local package_name="$1"
    local description="$2"
    local display_name="$3"

    if ! dpkg -s "$package_name" >/dev/null 2>&1; then
        print_description "$display_name" "$description"
        sudo apt-get install -qq "$package_name" -y
    fi
}

install_extension_if_not_present()
{
    local extension="$1"
    local description="$2"

    if ! code --list-extensions 2>/dev/null | grep -q "^$extension$"; then
        print_style "installing VS Code extension: $description\n" "info"
        code --install-extension "$extension" 2>/dev/null
    fi
}

main
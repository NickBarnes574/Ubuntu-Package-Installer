set -e # used to exit the script immediately if any errors occur
trap 'catch $? $LINENO' EXIT

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
    # Perform initial setup
    sudo apt update && sudo apt dist-upgrade -y

    # Install base packages
    get_build_essential
    get_make
    get_cmake
    get_valgrind
    get_curl
    get_pip
    get_clang_suite
    get_cunit
    get_vscode
    get_git

    clear

    ./scripts/sanity_check.sh

    set_up_git
    get_posix_cac
    setup_ssh_keys

    # Setup aliases
    set_aliases
}

#---------------------------------------------------------------
# Name:        | Build-Essential
# Description: | Meta-packages necessary for compiling software
#---------------------------------------------------------------
get_build_essential()
{
    if ! dpkg -s build-essential >/dev/null 2>&1; then
        print_description "Build-Essential" "Meta-packages necessary for compiling software"
        sudo apt-get install -qq build-essential -y
    fi
}

#---------------------------------------------------------------
# Name:        | Make
# Description: | Used to build executable programs and libraries from source code
#---------------------------------------------------------------
get_make()
{
    if ! dpkg -s make >/dev/null 2>&1; then
        print_description "Make" "Used to build executable programs and libraries from source code"
        sudo apt-get install -qq make -y
    fi
}

#---------------------------------------------------------------
# Name:        | CMake
# Description: | Used to build executable programs and libraries from source code
#---------------------------------------------------------------
get_cmake()
{
    if ! dpkg -s cmake >/dev/null 2>&1; then
        print_description "CMake" "Used to build executable programs and libraries from source code"
        sudo apt-get install -qq cmake -y
    fi
}

#---------------------------------------------------------------
# Name:        | Curl
# Description: | Command-line tool to transfer data to or from a server
#---------------------------------------------------------------
get_curl()
{
    if ! dpkg -s curl >/dev/null 2>&1; then
        print_description "Curl" "Command-line tool to transfer data to or from a server"
        sudo apt-get install -qq curl -y
    fi
}

#---------------------------------------------------------------
# Name:        | Pip
# Description: | 3rd-party package manager for Python modules
#---------------------------------------------------------------
get_pip()
{
    if ! dpkg -s python3-pip >/dev/null 2>&1; then
        print_description "Pip" "3rd-party package manager for Python modules"
        sudo apt-get install -qq python3-pip -y
    fi
}

#---------------------------------------------------------------
# Name:        | Clang
# Description: | LLVM-based C/C++ compiler
# 
# Name:        | Clang Format
# Description: | Code Formatting tool for C/C++
#
# Name:        | Clang Tidy
# Description: | Static analyzer tool for C/C++
#---------------------------------------------------------------
get_clang_suite()
{
    if ! dpkg -s clang >/dev/null 2>&1; then
        print_description "Clang" "LLVM-based C/C++ compiler"
        sudo apt-get install -qq -y clang-12
    fi

    if ! dpkg -s clang-format >/dev/null 2>&1; then
        print_description "Clang Format" "Code Formatting tool for C/C++"
        sudo apt-get install -qq -y clang-format
    fi

    if ! dpkg -s clang-tidy >/dev/null 2>&1; then
        print_description "Clang Tidy" "Static analyzer tool for C/C++"
        sudo apt-get install -qq -y clang-tidy
    fi
}

#---------------------------------------------------------------
# Name:        | CUnit
# Description: | Unit testing framework for C
#---------------------------------------------------------------
get_cunit()
{
    if ! dpkg -s libcunit1 libcunit1-doc libcunit1-dev >/dev/null 2>&1; then
        print_description "CUnit" "Unit testing framework for C"
        sudo apt-get install -qq -y libcunit1 libcunit1-doc libcunit1-dev
    fi
}

#---------------------------------------------------------------
# Name:        | VS Code
# Description: | Source-code editor made by Microsoft
#---------------------------------------------------------------
get_vscode()
{
    if ! command -v code &> /dev/null; then
        print_description "VS Code" "Source-code editor made by Microsoft"
        sudo snap install --classic code
    fi

    install_vscode_extensions
    update_vscode_settings
    update_vscode_user_snippets
}

#---------------------------------------------------------------
# Name:        | Valgrind
# Description: | Memory management and bug detector for C
#---------------------------------------------------------------
get_valgrind()
{
    if ! dpkg -s valgrind >/dev/null 2>&1; then
        print_description "Valgrind" "Memory management and bug detector for C"
        sudo apt-get install -qq valgrind -y
    fi
}

install_vscode_extensions()
{
    if command -v code &> /dev/null; then

        # C/C++ Extension Pack
        extension="ms-vscode.cpptools-extension-pack"
        if ! code --list-extensions 2>/dev/null | grep -q "^$extension$"; then
            print_style "installing VS Code extension: C/C++ Extention Pack\n" "info"
            code --install-extension ms-vscode.cpptools-extension-pack 2>/dev/null
        fi

        # Doxygen Documentation Generator
        extension="cschlosser.doxdocgen"
        if ! code --list-extensions 2>/dev/null | grep -q "^$extension$"; then
            print_style "installing VS Code extension: Doxygen\n" "info"
            code --install-extension cschlosser.doxdocgen 2>/dev/null
        fi

        # Python
        extension="ms-python.python"
        if ! code --list-extensions 2>/dev/null | grep -q "^$extension$"; then
            print_style "installing VS Code extension: Python\n" "info"
            code --install-extension ms-python.python 2>/dev/null
        fi

        # VS Code PDF
        extension="tomoki1207.pdf"
        if ! code --list-extensions 2>/dev/null | grep -q "^$extension$"; then
            print_style "installing VS Code extension: VS Code PDF\n" "info"
            code --install-extension tomoki1207.pdf 2>/dev/null
        fi

    else
        print_style "VS Code is not installed. Cannot install VS Code extensions!\n" "danger"
    fi
}

#---------------------------------------------------------------
# Name:        | Git
# Description: | Distributed version control system for developers
#---------------------------------------------------------------
get_git()
{
    # Check if git is already installed
    if ! dpkg -s git-all >/dev/null 2>&1; then
        print_description "Git" "Distributed version control system for developers"
        sudo apt-get install -qq git-all -y
    fi
}

get_posix_cac()
{
    option=''

    print_style "\n[POSIX CAC]-----------------------------------\n" "header"

    while [ "$option" != "y" ] && [ "$option" != "n" ]
    do
        print_style "Do you want to install CAC credentials? [y/n]\n" "info"
        read -r option
    done
    
    if [ "$option" = "y" ]; then
        ./scripts/install_posix_cac.sh
    fi
}

main
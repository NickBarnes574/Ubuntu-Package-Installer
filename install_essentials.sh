set -e # used to exit the script immediately if any errors occur
trap 'catch $? $LINENO' EXIT

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

print_style() {
    case "$2" in
        "info")
            COLOR="96m"; # cyan
            ;;
        "success")
            COLOR="92m"; # green
            ;;
        "warning")
            COLOR="93m"; # yellow
            ;;
        "danger")
            COLOR="91m"; # red
            ;;
        *)
            COLOR="0m"; # default color
            ;;
    esac

    STARTCOLOR="\e[$COLOR";
    ENDCOLOR="\e[0m";

    printf "$STARTCOLOR%b$ENDCOLOR" "$1";
}

print_description()
{
    print_style "\n              **Preparing to install package**\n" "info"
    print_style "---------------------------------------------------------------\n" "info"
    print_style "Name:        | $1\n" "info"
    print_style "Description: | $2\n" "info"
    print_style "---------------------------------------------------------------\n" "info"
}

base_install()
{
    # Perform initial setup
    # sudo apt update && sudo apt dist-upgrade -y
    setup_ssh_keys

    # Install base packages
    get_build_essential
    get_cmake
    get_curl
    get_pip
    get_clang_suite
    get_vscode
    get_cunit
    get_git
}

#---------------------------------------------------------------
# Name:        | Build-Essential
# Description: | Meta-packages necessary for compiling software
#---------------------------------------------------------------
get_build_essential()
{
    if dpkg -s build-essential >/dev/null 2>&1; then
        print_style "Build-Essential is already installed. skipping...\n" "success"
    else
        print_description "Build-Essential" "Meta-packages necessary for compiling software"
        # sudo apt install build-essential -y
    fi
}

#---------------------------------------------------------------
# Name:        | CMake
# Description: | Used to build executable programs and libraries from source code
#---------------------------------------------------------------
get_cmake()
{
    if dpkg -s cmake >/dev/null 2>&1; then
        print_style "CMake is already installed. skipping...\n" "success"
    else
        print_description "CMake" "Used to build executable programs and libraries from source code"
        # sudo apt install cmake -y
    fi
}

#---------------------------------------------------------------
# Name:        | Curl
# Description: | Command-line tool to transfer data to or from a server
#---------------------------------------------------------------
get_curl()
{
    if dpkg -s curl >/dev/null 2>&1; then
        print_style "Curl is already installed. skipping...\n" "success"
    else
        print_description "Curl" "Command-line tool to transfer data to or from a server"
        # sudo apt-get install curl -y
    fi
}

#---------------------------------------------------------------
# Name:        | Pip
# Description: | 3rd-party package manager for Python modules
#---------------------------------------------------------------
get_pip()
{
    if dpkg -s python3-pip >/dev/null 2>&1; then
        print_style "Pip is already installed. skipping...\n" "success"
    else
        print_description "Pip" "3rd-party package manager for Python modules"
        # sudo apt install python3-pip -y
    fi
}

#---------------------------------------------------------------
# Name:        | Clang
# Description: | Alternative C compiler
# 
# Name:        | Clang Format
# Description: | Formatting tool for C
#
# Name:        | Clang Tidy
# Description: | Static analyzer tool for C
#---------------------------------------------------------------
get_clang_suite()
{
    if dpkg -s clang >/dev/null 2>&1; then
        print_style "Clang is already installed. skipping...\n" "success"
    else
        print_description "Clang" "Alternative C compiler"
        # sudo apt install -y clang
    fi

    if dpkg -s clang-format >/dev/null 2>&1; then
        print_style "Clang Format is already installed. skipping...\n" "success"
    else
        print_description "Clang Format" "Formatting tool for C"
        # sudo apt install -y clang-format
    fi

    if dpkg -s clang-tidy >/dev/null 2>&1; then
        print_style "Clang Tidy is already installed. skipping...\n" "success"
    else
        print_description "Clang Tidy" "Static analyzer tool for C"
        # sudo apt install -y clang-tidy
    fi
}

#---------------------------------------------------------------
# Name:        | CUnit
# Description: | Unit testing framework for C
#---------------------------------------------------------------
get_cunit()
{
    if dpkg -s libcunit1 libcunit1-doc libcunit1-dev >/dev/null 2>&1; then
        print_style "Cunit is already installed. skipping...\n" "success"
    else
        print_description "CUnit" "Unit testing framework for C"
        # sudo apt-get install libcunit1 libcunit1-doc libcunit1-dev
    fi
}

#---------------------------------------------------------------
# Name:        | VS Code
# Description: | Source-code editor made by Microsoft
#---------------------------------------------------------------
get_vscode()
{
    if dpkg -s code >/dev/null 2>&1; then
        print_style "VS Code is already installed. skipping...\n" "success"
    else
        print_description "VS Code" "Source-code editor made by Microsoft"

        # Download the latest VS Code Deb file
        wget -O vscode.deb 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'

        sudo apt install ./vscode.deb -y
    fi

    install_vscode_extensions
}

install_vscode_extensions()
{
    if dpkg -s code >/dev/null 2>&1; then

        # C/C++ Extension Pack
        extension="ms-vscode.cpptools-extension-pack"
        if code --list-extensions | grep -q "^$extension$"; then
            print_style "VS Code extension: C/C++ Extension Pack already installed.\n" "success"
        else
            print_style "installing VS Code extension: C/C++ Extention Pack\n" "info"
            code --install-extension ms-vscode.cpptools-extension-pack
        fi

        # Doxygen Documentation Generator
        extension="cschlosser.doxdocgen"
        if code --list-extensions | grep -q "^$extension$"; then
            print_style "VS Code extension: Doxygen already installed.\n" "success"
        else
            print_style "installing VS Code extension: Doxygen\n" "info"
            code --install-extension cschlosser.doxdocgen
        fi

        # Python
        extension="ms-python.python"
        if code --list-extensions | grep -q "^$extension$"; then
            print_style "VS Code extension: Python already installed\n" "success"
        else
            print_style "installing VS Code extension: Python\n" "info"
            code --install-extension ms-python.python
        fi

    else
        print_style "VS Code is not installed. Cannot install VS Code extensions!\n" "danger"
    fi
}

setup_ssh_keys()
{
    # Check if SSH keys already exist
    if [ -f ~/.ssh/id_rsa.pub ]; then
        print_style "SSH keys are already installed.\n" "success"
    else
        # Ask the user if they would like to create SSH keys
        read -p "SSH keys are not installed. Would you like to create them? (y/n) " choice
        if [ "$choice" = "y" ]; then
            # Create SSH keys
            ssh-keygen
            print_style "SSH keys created successfully!\n" "success"
        else
            print_style "SSH keys were not installed.\n" "info"
        fi
    fi
}

#---------------------------------------------------------------
# Name:        | Git
# Description: | Distributed version control system for developers
#---------------------------------------------------------------
get_git()
{
    configure=''

    # Check if git is already installed
    if dpkg -s git-all >/dev/null 2>&1; then
        print_style "Git is already installed. skipping...\n" "success"
    else
        print_description "Git" "Distributed version control system for developers"
        # sudo apt-get install git-all -y
    fi

    # Ask if the user wants to set up global username and email if not already configured
    while [ "$configure" != "y" ] && [ "$configure" != "n" ]
    do
        if check_git_config; then
            print_style "Git username and email found:\n" "success"
            print_style "username: $(git config --global user.name)\n" "warning"
            print_style "email: $(git config --global user.email)\n" "warning"
        else
            print_style "Git not configured.\n" "warning"
        fi

        print_style "Manage username/email?(y/n)\n" "info"
        read -r configure
    done

    if [ "$configure" = "y" ]; then
        configure_git
    else
        print_style "\nskipping git configuration.\n" "info"
    fi
}

# Checks if git global username and email exist
check_git_config()
{
    if git config --global user.name > /dev/null || git config --global user.email > /dev/null; then
        return 0
    else
        return 1
    fi
}

# Sets up a new git global username and email
configure_git()
{
    option=''
    name=''
    email=''
    
    while [ "$option" != "y" ] && [ "$option" != "n" ]
    do
        print_style "Please enter your git username:\n" "info"
        read -r name

        print_style "Please enter your git email:\n" "info"
        read -r email

        print_style "Is the following information correct?(y/n)\n" "info"
        print_style "username: $name\n" "warning"
        print_style "email: $email\n" "warning"
        read -r option
    done

    if [ "$option" = "y" ]; then
        # Configure user name
        git config --global user.name "$name"

        # Configure email
        git config --global user.email "$email"

    else
        option=''

        while [ "$option" != "y" ] && [ "$option" != "n" ]
        do
            print_style "\nRe-enter git username and email?(y/n)\n" "info"
            read -r option
        done

        if [ "$option" = "y" ]; then
            configure_git
        fi
    fi
}

main